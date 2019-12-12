// MT Engine MK2 v0.90b
// Copyleft 2016 the Mojon Twins

// engine.h
// Well, self explanatory innit?

#ifndef PLAYER_MIN_KILLABLE
#define PLAYER_MIN_KILLABLE 0
#endif

// Animation frames
#include "engine/frames.h"

// Prepare level (compressed levels)
#if defined (SIMPLE_LEVEL_MANAGER)
#include "engine/clevels-s.h"
#elif defined (COMPRESSED_LEVELS)
#include "engine/clevels.h"
#endif

// Collision
#include "engine/collision.h"

// Random
#include "engine/random.h"

// Messages
#include "engine/messages.h"

#ifdef PLAYER_STEP_SOUND
void step (void) {
	#asm
		ld a, 16
		out (254), a
		nop
		nop
		nop
		nop
		nop
		nop
		nop
		nop
		nop
		xor 16
		out (254), a
	#endasm
}
#endif

void cortina (void) {
	#asm
		ld b, 7
	.fade_out_extern
		push bc

		ld   e, 3               ; 3 tercios
		ld   hl, 22528          ; aqu� empiezan los atributos
	#endasm
#ifdef MODE_128K
	#asm
		halt                    ; esperamos retrazo.
	#endasm
#endif
	#asm
	.fade_out_bucle
		ld   a, (hl )           ; nos traemos el atributo actual

		ld   d, a               ; tomar atributo
		and  7                  ; aislar la tinta
		jr   z, ink_done        ; si vale 0, no se decrementa
		dec  a                  ; decrementamos tinta
	.ink_done
		ld   b, a               ; en b tenemos ahora la tinta ya procesada.

		ld   a, d               ; tomar atributo
		and  56                 ; aislar el papel, sin modificar su posición en el byte
		jr   z, paper_done      ; si vale 0, no se decrementa
		sub  8                  ; decrementamos papel restando 8
	.paper_done
		ld   c, a               ; en c tenemos ahora el papel ya procesado.
		ld   a, d
		and  192                ; nos quedamos con bits 6 y 7 (BRIGHT y FLASH)
		or   c                  ; a�adimos paper
		or   b                  ; e ink, con lo que recompuesto el atributo
		ld   (hl),a             ; lo escribimos,
		inc  l                  ; e incrementamos el puntero.
		jr   nz, fade_out_bucle ; continuamos hasta acabar el tercio (cuando L valga 0)
		inc  h                  ; siguiente tercio
		dec  e
		jr   nz, fade_out_bucle ; repetir las 3 veces
		pop bc
		djnz fade_out_extern
	#endasm
}

signed int addsign (signed int n, signed int value) {
	//if (n >= 0) return value; else return -value;
	return n == 0 ? 0 : n > 0 ? value : -value;
}

unsigned int abs (int n) {
	if (n < 0)
		return (unsigned int) (-n);
	else
		return (unsigned int) n;
}

// Floating objects
#if defined (ENABLE_FLOATING_OBJECTS) || defined (ENABLE_SIM)
#ifdef PLAYER_GENITAL
#include "engine/fo_genital.h"
#else
#include "engine/fo_sideview.h"
#endif
#ifdef ENABLE_SIM
#include "engine/sim.h"
#endif
#endif

// Animated tiles
#ifdef ENABLE_TILANIMS
#include "engine/tilanim.h"
#endif

// Breakable tiles helper functions
#ifdef BREAKABLE_WALLS
#include "engine/breakable.h"
#endif

#ifdef BREAKABLE_WALLS_SIMPLE
#include "engine/breakable-s.h"
#endif

// Initialization functions
#include "engine/inits.h"

// Hitter (punch/sword) helper functions
#if defined (PLAYER_CAN_PUNCH) || defined (PLAYER_HAZ_SWORD) || defined (PLAYER_HAZ_WHIP)
#include "engine/hitter.h"
#endif

// Bullets helper functions
#ifdef PLAYER_CAN_FIRE
#include "engine/bullets.h"
#endif

// Simple bomb helper functions
#ifdef PLAYER_SIMPLE_BOMBS
#include "engine/bombs-s.h"
#endif

// Block processing
#include "engine/blocks.h"

// Main player movement
#if defined (PHANTOMAS_ENGINE)
#include "engine/phantomas.h"
#else
#include "engine/player.h"
#endif

#ifdef ACTIVATE_SCRIPTING
	void run_entering_script (void) {
		#ifdef EXTENDED_LEVELS
			if (level_data->activate_scripting) 
		#endif
		{
			#ifdef LINE_OF_TEXT
				#ifdef LINE_OF_TEXT_SUBSTR
					#asm
							ld  a, 32 - LINE_OF_TEXT_SUBSTR
							ld  (_gpit), a
							ld  a, LINE_OF_TEXT_X
							ld  (__x), a
						._line_of_text_loop
							ld  hl, _gpit
							dec (hl)

							; enter:  A = row position (0..23)
							;         C = col position (0..31/63)
							;         D = pallette #
							;         E = graphic #

							ld hl, __x
							ld  a, (hl)
							ld  c, a
							inc (hl)

							ld  a, LINE_OF_TEXT

							ld  d, LINE_OF_TEXT_ATTR
							ld  e, 0

							call SPPrintAtInv

							ld  a, (_gpit)
							or  a
							jr  z, _line_of_text_loop
					#endasm
				#else
					_x = LINE_OF_TEXT_X; _y = LINE_OF_TEXT; _t = LINE_OF_TEXT_ATTR; gp_gen = "                              ";
					print_str ();
				#endif
			#endif
			// Ejecutamos los scripts de entrar en pantalla:
			run_script (2 * MAP_W * MAP_H + 1);
			run_script (n_pant + n_pant);
		}
	}
#endif

// Extra prints (screen drawing helpers)
#ifdef ENABLE_EXTRA_PRINTS
	#include "engine/extraprints.h"
#endif

// Level names (screen drawing helpers)
#ifdef ENABLE_LEVEL_NAMES
	#include "engine/levelnames.h"
#endif

// Enemies
#include "engine/enems.h"

// Screen drawing
#include "engine/drawscr.h"

void active_sleep (int espera) {
	do {
		#ifndef MODE_128K
			gpjt = 250; do { gpit = 1; } while (--gpjt);
		#else
			#asm
				halt
			#endasm
		#endif
		#ifdef DIE_AND_RESPAWN
			if (p_killme == 0 && button_pressed ()) break;
		#else
			if (button_pressed ()) break;
		#endif
	} while (--espera);
	sp_Border (0);
}

#ifdef ACTIVATE_SCRIPTING
	void run_fire_script (void) {
		run_script (2 * MAP_W * MAP_H + 2);	// Press fire at any
		run_script (n_pant + n_pant + 1);	// Press fire at n_pant
	}
#endif

void select_joyfunc (void) {
#ifdef PHANTOMAS_ENGINE
	joyfunc = sp_JoyKeyboard;
	keys.up    = 0x01fb;	// Q
	keys.down  = 0x01fd;	// A
	keys.left  = 0x02df;	// O
	keys.right = 0x01df;	// P
	keys.fire  = 0x017f;	// SPACE
	#asm
		; Music generated by beepola
		; call musicstart
	#endasm
	while (0 == sp_GetKey ());
#else
	#ifdef MODE_128K
	#else
		#asm
			; Music generated by beepola
			call musicstart
		#endasm
	#endif

	while (1) {
		gpit = sp_GetKey ();
		
		if (gpit == '1' || gpit == '2') {
			joyfunc = sp_JoyKeyboard;
			gpjt = (gpit - '1') ? 6 : 0;
			#ifdef USE_TWO_BUTTONS
				keys.up = keyscancodes [gpjt ++];
				keys.down = keyscancodes [gpjt ++];
				keys.left = keyscancodes [gpjt ++];
				keys.right = keyscancodes [gpjt ++];
				key_fire = keys.fire = keyscancodes [gpjt ++];
				key_jump = keyscancodes [gpjt];
			#else
				keys.up = keyscancodes [gpjt ++];		// UP
				keys.down = keyscancodes [gpjt ++];		// DOWN
				keys.left = keyscancodes [gpjt ++];		// LEFT
				keys.right = keyscancodes [gpjt ++];	// RIGHT
				keys.fire = keyscancodes [gpjt ++];		// FIRE				
			#endif
				break;
			} else if (gpit == '3') {
				joyfunc = sp_JoyKempston;
				break;
			} else if (gpit == '4') {
				joyfunc = sp_JoySinclair1;
				break;
			}
		}
	#ifdef MODE_128K
		_AY_PL_SND (0);
		sp_WaitForNoKey ();
	#endif
#endif
}

// Hud
#include "engine/hud.h"

// Experimental
#ifdef ENABLE_LAVA
#include "engine/lava.h"
#endif
