;* * * * *  Small-C/Plus z88dk * * * * *
;  Version: 20100416.1
;
;	Reconstructed for z80 Module Assembler
;
;	Module compile time: Fri Dec 27 22:39:58 2019



	MODULE	mk2.c


	INCLUDE "z80_crt0.hdr"


	LIB SPMoveSprAbs
	LIB SPPrintAtInv
	LIB SPTileArray
	LIB SPInvalidate
	LIB SPCompDListAddr
;	SECTION	text

._keyscancodes
	defw	2175,765,509,1277,1151,0,507,509,735,479
	defw	383,0
;	SECTION	code



._my_malloc
	ld	hl,0 % 256	;const
	push	hl
	call	sp_BlockAlloc
	pop	bc
	ret


;	SECTION	text

._u_malloc
	defw	_my_malloc

;	SECTION	code

;	SECTION	text

._u_free
	defw	sp_FreeBlock

;	SECTION	code

	.vpClipStruct defb 0, 0 + 20, 1, 1 + 30
	.fsClipStruct defb 0, 24, 0, 32
;	SECTION	text

._half_life
	defm	""
	defb	0

;	SECTION	code


;	SECTION	text

._level
	defm	""
	defb	0

;	SECTION	code


;	SECTION	text

._do_gravity
	defm	""
	defb	1

;	SECTION	code


;	SECTION	text

._script_result
	defm	""
	defb	0

;	SECTION	code


;	SECTION	text

._sc_terminado
	defm	""
	defb	0

;	SECTION	code


;	SECTION	text

._sc_continuar
	defm	""
	defb	0

;	SECTION	code


	._script defw 0

._SetRAMBank
	.SetRAMBank
	ld a, b
	or a
	jp z, restISR
	xor a
	ld i, a
	jp keepGoing
	.restISR
	ld a, $f0
	ld i, a
	.keepGoing
	ld a, 16
	or b
	ld bc, $7ffd
	out (C), a
	ret


	; aPPack decompressor
	; original source by dwedit
	; very slightly adapted by utopian
	; optimized by Metalbrain
	;hl = source
	;de = dest
	.depack ld ixl,128
	.apbranch1 ldi
	.aploop0 ld ixh,1 ;LWM = 0
	.aploop call ap_getbit
	jr nc,apbranch1
	call ap_getbit
	jr nc,apbranch2
	ld b,0
	call ap_getbit
	jr nc,apbranch3
	ld c,16 ;get an offset
	.apget4bits call ap_getbit
	rl c
	jr nc,apget4bits
	jr nz,apbranch4
	ld a,b
	.apwritebyte ld (de),a ;write a 0
	inc de
	jr aploop0
	.apbranch4 and a
	ex de,hl ;write a previous byte (1-15 away from dest)
	sbc hl,bc
	ld a,(hl)
	add hl,bc
	ex de,hl
	jr apwritebyte
	.apbranch3 ld c,(hl) ;use 7 bit offset, length = 2 or 3
	inc hl
	rr c
	ret z ;if a zero is encountered here, it is EOF
	ld a,2
	adc a,b
	push hl
	ld iyh,b
	ld iyl,c
	ld h,d
	ld l,e
	sbc hl,bc
	ld c,a
	jr ap_finishup2
	.apbranch2 call ap_getgamma ;use a gamma code * 256 for offset, another gamma code for length
	dec c
	ld a,c
	sub ixh
	jr z,ap_r0_gamma ;if gamma code is 2, use old r0 offset,
	dec a
	;do I even need this code?
	;bc=bc*256+(hl), lazy 16bit way
	ld b,a
	ld c,(hl)
	inc hl
	ld iyh,b
	ld iyl,c
	push bc
	call ap_getgamma
	ex (sp),hl ;bc = len, hl=offs
	push de
	ex de,hl
	ld a,4
	cp d
	jr nc,apskip2
	inc bc
	or a
	.apskip2 ld hl,127
	sbc hl,de
	jr c,apskip3
	inc bc
	inc bc
	.apskip3 pop hl ;bc = len, de = offs, hl=junk
	push hl
	or a
	.ap_finishup sbc hl,de
	pop de ;hl=dest-offs, bc=len, de = dest
	.ap_finishup2 ldir
	pop hl
	ld ixh,b
	jr aploop
	.ap_r0_gamma call ap_getgamma ;and a new gamma code for length
	push hl
	push de
	ex de,hl
	ld d,iyh
	ld e,iyl
	jr ap_finishup
	.ap_getbit ld a,ixl
	add a,a
	ld ixl,a
	ret nz
	ld a,(hl)
	inc hl
	rla
	ld ixl,a
	ret
	.ap_getgamma ld bc,1
	.ap_getgammaloop call ap_getbit
	rl c
	rl b
	call ap_getbit
	jr c,ap_getgammaloop
	ret
	._ram_address
	defw 0
	._ram_destination
	defw 0
	._ram_page
	defb 0

._unpack_RAMn
	ld	de,_ram_address
	ld	hl,6-2	;const
	add	hl,sp
	call	l_gint	;
	call	l_pint
	ld	hl,_ram_page
	push	hl
	ld	hl,8	;const
	add	hl,sp
	ld	a,(hl)
	pop	de
	ld	(de),a
	ld	de,_ram_destination
	ld	hl,4-2	;const
	add	hl,sp
	call	l_gint	;
	call	l_pint
	di
	ld a, (_ram_page)
	ld b, a
	call SetRAMBank
	ld hl, (_ram_address)
	ld de, (_ram_destination)
	call depack
	ld b, 0
	call SetRAMBank
	ei
	ret


;	SECTION	text

._resources
	defb	3
	defw	49152
	defb	3
	defw	51540
	defb	3
	defw	51540
	defb	3
	defw	53905
	defb	3
	defw	56453
	defb	3
	defw	59406
	defb	3
	defw	61790
	defb	4
	defw	49152
	defb	4
	defw	51597
	defb	4
	defw	54469
	defb	4
	defw	56937
	defb	4
	defw	59808
	defb	4
	defw	62322
	defb	7
	defw	49152
	defb	7
	defw	51641

;	SECTION	code


._get_resource
	ld	hl,_resources
	push	hl
	ld	hl,6	;const
	add	hl,sp
	ld	l,(hl)
	ld	h,0
	ld	b,h
	ld	c,l
	add	hl,bc
	add	hl,bc
	pop	de
	add	hl,de
	ld	l,(hl)
	ld	h,0
	push	hl
	ld	hl,_resources
	push	hl
	ld	hl,8	;const
	add	hl,sp
	ld	l,(hl)
	ld	h,0
	ld	b,h
	ld	c,l
	add	hl,bc
	add	hl,bc
	pop	de
	add	hl,de
	inc	hl
	ld	e,(hl)
	inc	hl
	ld	d,(hl)
	push	de
	ld	hl,6	;const
	add	hl,sp
	call	l_gint	;
	push	hl
	call	_unpack_RAMn
	pop	bc
	pop	bc
	pop	bc
	ret


	._level_data defs 16
	._map defs 5 * 4 * 75
	._tileset
	._font
	BINARY "../bin/font.bin"
	._metatileset
	defs 192*8+256
	._spriteset
	defb 85, 170
	defb 85, 170
	defb 85, 170
	defb 85, 170
	defb 85, 170
	defb 85, 170
	defb 85, 170
	defb 85, 170
	._sprite_1_a
	defb 85, 170
	defb 85, 170
	defb 85, 170
	defb 85, 170
	defb 85, 170
	defb 85, 170
	defb 85, 170
	defb 85, 170
	defb 85, 170
	defb 85, 170
	defb 85, 170
	defb 85, 170
	defb 85, 170
	defb 85, 170
	defb 85, 170
	defb 85, 170
	defb 85, 170
	defb 85, 170
	defb 85, 170
	defb 85, 170
	defb 85, 170
	defb 85, 170
	defb 85, 170
	defb 85, 170
	._sprite_1_b
	defb 85, 170
	defb 85, 170
	defb 85, 170
	defb 85, 170
	defb 85, 170
	defb 85, 170
	defb 85, 170
	defb 85, 170
	defb 85, 170
	defb 85, 170
	defb 85, 170
	defb 85, 170
	defb 85, 170
	defb 85, 170
	defb 85, 170
	defb 85, 170
	defb 85, 170
	defb 85, 170
	defb 85, 170
	defb 85, 170
	defb 85, 170
	defb 85, 170
	defb 85, 170
	defb 85, 170
	._sprite_1_c
	defb 85, 170
	defb 85, 170
	defb 85, 170
	defb 85, 170
	defb 85, 170
	defb 85, 170
	defb 85, 170
	defb 85, 170
	defb 85, 170
	defb 85, 170
	defb 85, 170
	defb 85, 170
	defb 85, 170
	defb 85, 170
	defb 85, 170
	defb 85, 170
	defb 85, 170
	defb 85, 170
	defb 85, 170
	defb 85, 170
	defb 85, 170
	defb 85, 170
	defb 85, 170
	defb 85, 170
	._sprite_2_a
	defb 85, 170
	defb 85, 170
	defb 85, 170
	defb 85, 170
	defb 85, 170
	defb 85, 170
	defb 85, 170
	defb 85, 170
	defb 85, 170
	defb 85, 170
	defb 85, 170
	defb 85, 170
	defb 85, 170
	defb 85, 170
	defb 85, 170
	defb 85, 170
	defb 85, 170
	defb 85, 170
	defb 85, 170
	defb 85, 170
	defb 85, 170
	defb 85, 170
	defb 85, 170
	defb 85, 170
	._sprite_2_b
	defb 85, 170
	defb 85, 170
	defb 85, 170
	defb 85, 170
	defb 85, 170
	defb 85, 170
	defb 85, 170
	defb 85, 170
	defb 85, 170
	defb 85, 170
	defb 85, 170
	defb 85, 170
	defb 85, 170
	defb 85, 170
	defb 85, 170
	defb 85, 170
	defb 85, 170
	defb 85, 170
	defb 85, 170
	defb 85, 170
	defb 85, 170
	defb 85, 170
	defb 85, 170
	defb 85, 170
	._sprite_2_c
	defb 85, 170
	defb 85, 170
	defb 85, 170
	defb 85, 170
	defb 85, 170
	defb 85, 170
	defb 85, 170
	defb 85, 170
	defb 85, 170
	defb 85, 170
	defb 85, 170
	defb 85, 170
	defb 85, 170
	defb 85, 170
	defb 85, 170
	defb 85, 170
	defb 85, 170
	defb 85, 170
	defb 85, 170
	defb 85, 170
	defb 85, 170
	defb 85, 170
	defb 85, 170
	defb 85, 170
	._sprite_3_a
	defb 85, 170
	defb 85, 170
	defb 85, 170
	defb 85, 170
	defb 85, 170
	defb 85, 170
	defb 85, 170
	defb 85, 170
	defb 85, 170
	defb 85, 170
	defb 85, 170
	defb 85, 170
	defb 85, 170
	defb 85, 170
	defb 85, 170
	defb 85, 170
	defb 85, 170
	defb 85, 170
	defb 85, 170
	defb 85, 170
	defb 85, 170
	defb 85, 170
	defb 85, 170
	defb 85, 170
	._sprite_3_b
	defb 85, 170
	defb 85, 170
	defb 85, 170
	defb 85, 170
	defb 85, 170
	defb 85, 170
	defb 85, 170
	defb 85, 170
	defb 85, 170
	defb 85, 170
	defb 85, 170
	defb 85, 170
	defb 85, 170
	defb 85, 170
	defb 85, 170
	defb 85, 170
	defb 85, 170
	defb 85, 170
	defb 85, 170
	defb 85, 170
	defb 85, 170
	defb 85, 170
	defb 85, 170
	defb 85, 170
	._sprite_3_c
	defb 85, 170
	defb 85, 170
	defb 85, 170
	defb 85, 170
	defb 85, 170
	defb 85, 170
	defb 85, 170
	defb 85, 170
	defb 85, 170
	defb 85, 170
	defb 85, 170
	defb 85, 170
	defb 85, 170
	defb 85, 170
	defb 85, 170
	defb 85, 170
	defb 85, 170
	defb 85, 170
	defb 85, 170
	defb 85, 170
	defb 85, 170
	defb 85, 170
	defb 85, 170
	defb 85, 170
	._sprite_4_a
	defb 85, 170
	defb 85, 170
	defb 85, 170
	defb 85, 170
	defb 85, 170
	defb 85, 170
	defb 85, 170
	defb 85, 170
	defb 85, 170
	defb 85, 170
	defb 85, 170
	defb 85, 170
	defb 85, 170
	defb 85, 170
	defb 85, 170
	defb 85, 170
	defb 85, 170
	defb 85, 170
	defb 85, 170
	defb 85, 170
	defb 85, 170
	defb 85, 170
	defb 85, 170
	defb 85, 170
	._sprite_4_b
	defb 85, 170
	defb 85, 170
	defb 85, 170
	defb 85, 170
	defb 85, 170
	defb 85, 170
	defb 85, 170
	defb 85, 170
	defb 85, 170
	defb 85, 170
	defb 85, 170
	defb 85, 170
	defb 85, 170
	defb 85, 170
	defb 85, 170
	defb 85, 170
	defb 85, 170
	defb 85, 170
	defb 85, 170
	defb 85, 170
	defb 85, 170
	defb 85, 170
	defb 85, 170
	defb 85, 170
	._sprite_4_c
	defb 85, 170
	defb 85, 170
	defb 85, 170
	defb 85, 170
	defb 85, 170
	defb 85, 170
	defb 85, 170
	defb 85, 170
	defb 85, 170
	defb 85, 170
	defb 85, 170
	defb 85, 170
	defb 85, 170
	defb 85, 170
	defb 85, 170
	defb 85, 170
	defb 85, 170
	defb 85, 170
	defb 85, 170
	defb 85, 170
	defb 85, 170
	defb 85, 170
	defb 85, 170
	defb 85, 170
	._sprite_5_a
	defb 85, 170
	defb 85, 170
	defb 85, 170
	defb 85, 170
	defb 85, 170
	defb 85, 170
	defb 85, 170
	defb 85, 170
	defb 85, 170
	defb 85, 170
	defb 85, 170
	defb 85, 170
	defb 85, 170
	defb 85, 170
	defb 85, 170
	defb 85, 170
	defb 85, 170
	defb 85, 170
	defb 85, 170
	defb 85, 170
	defb 85, 170
	defb 85, 170
	defb 85, 170
	defb 85, 170
	._sprite_5_b
	defb 85, 170
	defb 85, 170
	defb 85, 170
	defb 85, 170
	defb 85, 170
	defb 85, 170
	defb 85, 170
	defb 85, 170
	defb 85, 170
	defb 85, 170
	defb 85, 170
	defb 85, 170
	defb 85, 170
	defb 85, 170
	defb 85, 170
	defb 85, 170
	defb 85, 170
	defb 85, 170
	defb 85, 170
	defb 85, 170
	defb 85, 170
	defb 85, 170
	defb 85, 170
	defb 85, 170
	._sprite_5_c
	defb 85, 170
	defb 85, 170
	defb 85, 170
	defb 85, 170
	defb 85, 170
	defb 85, 170
	defb 85, 170
	defb 85, 170
	defb 85, 170
	defb 85, 170
	defb 85, 170
	defb 85, 170
	defb 85, 170
	defb 85, 170
	defb 85, 170
	defb 85, 170
	defb 85, 170
	defb 85, 170
	defb 85, 170
	defb 85, 170
	defb 85, 170
	defb 85, 170
	defb 85, 170
	defb 85, 170
	._sprite_6_a
	defb 85, 170
	defb 85, 170
	defb 85, 170
	defb 85, 170
	defb 85, 170
	defb 85, 170
	defb 85, 170
	defb 85, 170
	defb 85, 170
	defb 85, 170
	defb 85, 170
	defb 85, 170
	defb 85, 170
	defb 85, 170
	defb 85, 170
	defb 85, 170
	defb 85, 170
	defb 85, 170
	defb 85, 170
	defb 85, 170
	defb 85, 170
	defb 85, 170
	defb 85, 170
	defb 85, 170
	._sprite_6_b
	defb 85, 170
	defb 85, 170
	defb 85, 170
	defb 85, 170
	defb 85, 170
	defb 85, 170
	defb 85, 170
	defb 85, 170
	defb 85, 170
	defb 85, 170
	defb 85, 170
	defb 85, 170
	defb 85, 170
	defb 85, 170
	defb 85, 170
	defb 85, 170
	defb 85, 170
	defb 85, 170
	defb 85, 170
	defb 85, 170
	defb 85, 170
	defb 85, 170
	defb 85, 170
	defb 85, 170
	._sprite_6_c
	defb 85, 170
	defb 85, 170
	defb 85, 170
	defb 85, 170
	defb 85, 170
	defb 85, 170
	defb 85, 170
	defb 85, 170
	defb 85, 170
	defb 85, 170
	defb 85, 170
	defb 85, 170
	defb 85, 170
	defb 85, 170
	defb 85, 170
	defb 85, 170
	defb 85, 170
	defb 85, 170
	defb 85, 170
	defb 85, 170
	defb 85, 170
	defb 85, 170
	defb 85, 170
	defb 85, 170
	._sprite_7_a
	defb 85, 170
	defb 85, 170
	defb 85, 170
	defb 85, 170
	defb 85, 170
	defb 85, 170
	defb 85, 170
	defb 85, 170
	defb 85, 170
	defb 85, 170
	defb 85, 170
	defb 85, 170
	defb 85, 170
	defb 85, 170
	defb 85, 170
	defb 85, 170
	defb 85, 170
	defb 85, 170
	defb 85, 170
	defb 85, 170
	defb 85, 170
	defb 85, 170
	defb 85, 170
	defb 85, 170
	._sprite_7_b
	defb 85, 170
	defb 85, 170
	defb 85, 170
	defb 85, 170
	defb 85, 170
	defb 85, 170
	defb 85, 170
	defb 85, 170
	defb 85, 170
	defb 85, 170
	defb 85, 170
	defb 85, 170
	defb 85, 170
	defb 85, 170
	defb 85, 170
	defb 85, 170
	defb 85, 170
	defb 85, 170
	defb 85, 170
	defb 85, 170
	defb 85, 170
	defb 85, 170
	defb 85, 170
	defb 85, 170
	._sprite_7_c
	defb 85, 170
	defb 85, 170
	defb 85, 170
	defb 85, 170
	defb 85, 170
	defb 85, 170
	defb 85, 170
	defb 85, 170
	defb 85, 170
	defb 85, 170
	defb 85, 170
	defb 85, 170
	defb 85, 170
	defb 85, 170
	defb 85, 170
	defb 85, 170
	defb 85, 170
	defb 85, 170
	defb 85, 170
	defb 85, 170
	defb 85, 170
	defb 85, 170
	defb 85, 170
	defb 85, 170
	._sprite_8_a
	defb 85, 170
	defb 85, 170
	defb 85, 170
	defb 85, 170
	defb 85, 170
	defb 85, 170
	defb 85, 170
	defb 85, 170
	defb 85, 170
	defb 85, 170
	defb 85, 170
	defb 85, 170
	defb 85, 170
	defb 85, 170
	defb 85, 170
	defb 85, 170
	defb 85, 170
	defb 85, 170
	defb 85, 170
	defb 85, 170
	defb 85, 170
	defb 85, 170
	defb 85, 170
	defb 85, 170
	._sprite_8_b
	defb 85, 170
	defb 85, 170
	defb 85, 170
	defb 85, 170
	defb 85, 170
	defb 85, 170
	defb 85, 170
	defb 85, 170
	defb 85, 170
	defb 85, 170
	defb 85, 170
	defb 85, 170
	defb 85, 170
	defb 85, 170
	defb 85, 170
	defb 85, 170
	defb 85, 170
	defb 85, 170
	defb 85, 170
	defb 85, 170
	defb 85, 170
	defb 85, 170
	defb 85, 170
	defb 85, 170
	._sprite_8_c
	defb 85, 170
	defb 85, 170
	defb 85, 170
	defb 85, 170
	defb 85, 170
	defb 85, 170
	defb 85, 170
	defb 85, 170
	defb 85, 170
	defb 85, 170
	defb 85, 170
	defb 85, 170
	defb 85, 170
	defb 85, 170
	defb 85, 170
	defb 85, 170
	defb 85, 170
	defb 85, 170
	defb 85, 170
	defb 85, 170
	defb 85, 170
	defb 85, 170
	defb 85, 170
	defb 85, 170
	._sprite_9_a
	defb 85, 170
	defb 85, 170
	defb 85, 170
	defb 85, 170
	defb 85, 170
	defb 85, 170
	defb 85, 170
	defb 85, 170
	defb 85, 170
	defb 85, 170
	defb 85, 170
	defb 85, 170
	defb 85, 170
	defb 85, 170
	defb 85, 170
	defb 85, 170
	defb 85, 170
	defb 85, 170
	defb 85, 170
	defb 85, 170
	defb 85, 170
	defb 85, 170
	defb 85, 170
	defb 85, 170
	._sprite_9_b
	defb 85, 170
	defb 85, 170
	defb 85, 170
	defb 85, 170
	defb 85, 170
	defb 85, 170
	defb 85, 170
	defb 85, 170
	defb 85, 170
	defb 85, 170
	defb 85, 170
	defb 85, 170
	defb 85, 170
	defb 85, 170
	defb 85, 170
	defb 85, 170
	defb 85, 170
	defb 85, 170
	defb 85, 170
	defb 85, 170
	defb 85, 170
	defb 85, 170
	defb 85, 170
	defb 85, 170
	._sprite_9_c
	defb 85, 170
	defb 85, 170
	defb 85, 170
	defb 85, 170
	defb 85, 170
	defb 85, 170
	defb 85, 170
	defb 85, 170
	defb 85, 170
	defb 85, 170
	defb 85, 170
	defb 85, 170
	defb 85, 170
	defb 85, 170
	defb 85, 170
	defb 85, 170
	defb 85, 170
	defb 85, 170
	defb 85, 170
	defb 85, 170
	defb 85, 170
	defb 85, 170
	defb 85, 170
	defb 85, 170
	._sprite_10_a
	defb 85, 170
	defb 85, 170
	defb 85, 170
	defb 85, 170
	defb 85, 170
	defb 85, 170
	defb 85, 170
	defb 85, 170
	defb 85, 170
	defb 85, 170
	defb 85, 170
	defb 85, 170
	defb 85, 170
	defb 85, 170
	defb 85, 170
	defb 85, 170
	defb 85, 170
	defb 85, 170
	defb 85, 170
	defb 85, 170
	defb 85, 170
	defb 85, 170
	defb 85, 170
	defb 85, 170
	._sprite_10_b
	defb 85, 170
	defb 85, 170
	defb 85, 170
	defb 85, 170
	defb 85, 170
	defb 85, 170
	defb 85, 170
	defb 85, 170
	defb 85, 170
	defb 85, 170
	defb 85, 170
	defb 85, 170
	defb 85, 170
	defb 85, 170
	defb 85, 170
	defb 85, 170
	defb 85, 170
	defb 85, 170
	defb 85, 170
	defb 85, 170
	defb 85, 170
	defb 85, 170
	defb 85, 170
	defb 85, 170
	._sprite_10_c
	defb 85, 170
	defb 85, 170
	defb 85, 170
	defb 85, 170
	defb 85, 170
	defb 85, 170
	defb 85, 170
	defb 85, 170
	defb 85, 170
	defb 85, 170
	defb 85, 170
	defb 85, 170
	defb 85, 170
	defb 85, 170
	defb 85, 170
	defb 85, 170
	defb 85, 170
	defb 85, 170
	defb 85, 170
	defb 85, 170
	defb 85, 170
	defb 85, 170
	defb 85, 170
	defb 85, 170
	._sprite_11_a
	defb 85, 170
	defb 85, 170
	defb 85, 170
	defb 85, 170
	defb 85, 170
	defb 85, 170
	defb 85, 170
	defb 85, 170
	defb 85, 170
	defb 85, 170
	defb 85, 170
	defb 85, 170
	defb 85, 170
	defb 85, 170
	defb 85, 170
	defb 85, 170
	defb 85, 170
	defb 85, 170
	defb 85, 170
	defb 85, 170
	defb 85, 170
	defb 85, 170
	defb 85, 170
	defb 85, 170
	._sprite_11_b
	defb 85, 170
	defb 85, 170
	defb 85, 170
	defb 85, 170
	defb 85, 170
	defb 85, 170
	defb 85, 170
	defb 85, 170
	defb 85, 170
	defb 85, 170
	defb 85, 170
	defb 85, 170
	defb 85, 170
	defb 85, 170
	defb 85, 170
	defb 85, 170
	defb 85, 170
	defb 85, 170
	defb 85, 170
	defb 85, 170
	defb 85, 170
	defb 85, 170
	defb 85, 170
	defb 85, 170
	._sprite_11_c
	defb 85, 170
	defb 85, 170
	defb 85, 170
	defb 85, 170
	defb 85, 170
	defb 85, 170
	defb 85, 170
	defb 85, 170
	defb 85, 170
	defb 85, 170
	defb 85, 170
	defb 85, 170
	defb 85, 170
	defb 85, 170
	defb 85, 170
	defb 85, 170
	defb 85, 170
	defb 85, 170
	defb 85, 170
	defb 85, 170
	defb 85, 170
	defb 85, 170
	defb 85, 170
	defb 85, 170
	._sprite_12_a
	defb 85, 170
	defb 85, 170
	defb 85, 170
	defb 85, 170
	defb 85, 170
	defb 85, 170
	defb 85, 170
	defb 85, 170
	defb 85, 170
	defb 85, 170
	defb 85, 170
	defb 85, 170
	defb 85, 170
	defb 85, 170
	defb 85, 170
	defb 85, 170
	defb 85, 170
	defb 85, 170
	defb 85, 170
	defb 85, 170
	defb 85, 170
	defb 85, 170
	defb 85, 170
	defb 85, 170
	._sprite_12_b
	defb 85, 170
	defb 85, 170
	defb 85, 170
	defb 85, 170
	defb 85, 170
	defb 85, 170
	defb 85, 170
	defb 85, 170
	defb 85, 170
	defb 85, 170
	defb 85, 170
	defb 85, 170
	defb 85, 170
	defb 85, 170
	defb 85, 170
	defb 85, 170
	defb 85, 170
	defb 85, 170
	defb 85, 170
	defb 85, 170
	defb 85, 170
	defb 85, 170
	defb 85, 170
	defb 85, 170
	._sprite_12_c
	defb 85, 170
	defb 85, 170
	defb 85, 170
	defb 85, 170
	defb 85, 170
	defb 85, 170
	defb 85, 170
	defb 85, 170
	defb 85, 170
	defb 85, 170
	defb 85, 170
	defb 85, 170
	defb 85, 170
	defb 85, 170
	defb 85, 170
	defb 85, 170
	defb 85, 170
	defb 85, 170
	defb 85, 170
	defb 85, 170
	defb 85, 170
	defb 85, 170
	defb 85, 170
	defb 85, 170
	._sprite_13_a
	defb 85, 170
	defb 85, 170
	defb 85, 170
	defb 85, 170
	defb 85, 170
	defb 85, 170
	defb 85, 170
	defb 85, 170
	defb 85, 170
	defb 85, 170
	defb 85, 170
	defb 85, 170
	defb 85, 170
	defb 85, 170
	defb 85, 170
	defb 85, 170
	defb 85, 170
	defb 85, 170
	defb 85, 170
	defb 85, 170
	defb 85, 170
	defb 85, 170
	defb 85, 170
	defb 85, 170
	._sprite_13_b
	defb 85, 170
	defb 85, 170
	defb 85, 170
	defb 85, 170
	defb 85, 170
	defb 85, 170
	defb 85, 170
	defb 85, 170
	defb 85, 170
	defb 85, 170
	defb 85, 170
	defb 85, 170
	defb 85, 170
	defb 85, 170
	defb 85, 170
	defb 85, 170
	defb 85, 170
	defb 85, 170
	defb 85, 170
	defb 85, 170
	defb 85, 170
	defb 85, 170
	defb 85, 170
	defb 85, 170
	._sprite_13_c
	defb 85, 170
	defb 85, 170
	defb 85, 170
	defb 85, 170
	defb 85, 170
	defb 85, 170
	defb 85, 170
	defb 85, 170
	defb 85, 170
	defb 85, 170
	defb 85, 170
	defb 85, 170
	defb 85, 170
	defb 85, 170
	defb 85, 170
	defb 85, 170
	defb 85, 170
	defb 85, 170
	defb 85, 170
	defb 85, 170
	defb 85, 170
	defb 85, 170
	defb 85, 170
	defb 85, 170
	._sprite_14_a
	defb 85, 170
	defb 85, 170
	defb 85, 170
	defb 85, 170
	defb 85, 170
	defb 85, 170
	defb 85, 170
	defb 85, 170
	defb 85, 170
	defb 85, 170
	defb 85, 170
	defb 85, 170
	defb 85, 170
	defb 85, 170
	defb 85, 170
	defb 85, 170
	defb 85, 170
	defb 85, 170
	defb 85, 170
	defb 85, 170
	defb 85, 170
	defb 85, 170
	defb 85, 170
	defb 85, 170
	._sprite_14_b
	defb 85, 170
	defb 85, 170
	defb 85, 170
	defb 85, 170
	defb 85, 170
	defb 85, 170
	defb 85, 170
	defb 85, 170
	defb 85, 170
	defb 85, 170
	defb 85, 170
	defb 85, 170
	defb 85, 170
	defb 85, 170
	defb 85, 170
	defb 85, 170
	defb 85, 170
	defb 85, 170
	defb 85, 170
	defb 85, 170
	defb 85, 170
	defb 85, 170
	defb 85, 170
	defb 85, 170
	._sprite_14_c
	defb 85, 170
	defb 85, 170
	defb 85, 170
	defb 85, 170
	defb 85, 170
	defb 85, 170
	defb 85, 170
	defb 85, 170
	defb 85, 170
	defb 85, 170
	defb 85, 170
	defb 85, 170
	defb 85, 170
	defb 85, 170
	defb 85, 170
	defb 85, 170
	defb 85, 170
	defb 85, 170
	defb 85, 170
	defb 85, 170
	defb 85, 170
	defb 85, 170
	defb 85, 170
	defb 85, 170
	._sprite_15_a
	defb 85, 170
	defb 85, 170
	defb 85, 170
	defb 85, 170
	defb 85, 170
	defb 85, 170
	defb 85, 170
	defb 85, 170
	defb 85, 170
	defb 85, 170
	defb 85, 170
	defb 85, 170
	defb 85, 170
	defb 85, 170
	defb 85, 170
	defb 85, 170
	defb 85, 170
	defb 85, 170
	defb 85, 170
	defb 85, 170
	defb 85, 170
	defb 85, 170
	defb 85, 170
	defb 85, 170
	._sprite_15_b
	defb 85, 170
	defb 85, 170
	defb 85, 170
	defb 85, 170
	defb 85, 170
	defb 85, 170
	defb 85, 170
	defb 85, 170
	defb 85, 170
	defb 85, 170
	defb 85, 170
	defb 85, 170
	defb 85, 170
	defb 85, 170
	defb 85, 170
	defb 85, 170
	defb 85, 170
	defb 85, 170
	defb 85, 170
	defb 85, 170
	defb 85, 170
	defb 85, 170
	defb 85, 170
	defb 85, 170
	._sprite_15_c
	defb 85, 170
	defb 85, 170
	defb 85, 170
	defb 85, 170
	defb 85, 170
	defb 85, 170
	defb 85, 170
	defb 85, 170
	defb 85, 170
	defb 85, 170
	defb 85, 170
	defb 85, 170
	defb 85, 170
	defb 85, 170
	defb 85, 170
	defb 85, 170
	defb 85, 170
	defb 85, 170
	defb 85, 170
	defb 85, 170
	defb 85, 170
	defb 85, 170
	defb 85, 170
	defb 85, 170
	._sprite_16_a
	defb 85, 170
	defb 85, 170
	defb 85, 170
	defb 85, 170
	defb 85, 170
	defb 85, 170
	defb 85, 170
	defb 85, 170
	defb 85, 170
	defb 85, 170
	defb 85, 170
	defb 85, 170
	defb 85, 170
	defb 85, 170
	defb 85, 170
	defb 85, 170
	defb 85, 170
	defb 85, 170
	defb 85, 170
	defb 85, 170
	defb 85, 170
	defb 85, 170
	defb 85, 170
	defb 85, 170
	._sprite_16_b
	defb 85, 170
	defb 85, 170
	defb 85, 170
	defb 85, 170
	defb 85, 170
	defb 85, 170
	defb 85, 170
	defb 85, 170
	defb 85, 170
	defb 85, 170
	defb 85, 170
	defb 85, 170
	defb 85, 170
	defb 85, 170
	defb 85, 170
	defb 85, 170
	defb 85, 170
	defb 85, 170
	defb 85, 170
	defb 85, 170
	defb 85, 170
	defb 85, 170
	defb 85, 170
	defb 85, 170
	._sprite_16_c
	defb 85, 170
	defb 85, 170
	defb 85, 170
	defb 85, 170
	defb 85, 170
	defb 85, 170
	defb 85, 170
	defb 85, 170
	defb 85, 170
	defb 85, 170
	defb 85, 170
	defb 85, 170
	defb 85, 170
	defb 85, 170
	defb 85, 170
	defb 85, 170
	defb 85, 170
	defb 85, 170
	defb 85, 170
	defb 85, 170
	defb 85, 170
	defb 85, 170
	defb 85, 170
	defb 85, 170
	._baddies defs 5 * 4 * 3 * 10
	._behs defs 48
	defb 0, 255
	defb 0, 255
	defb 0, 255
	defb 0, 255
	defb 0, 255
	defb 0, 255
	defb 0, 255
	defb 0, 255
	._sprite_17_a
	defb 0, 128, 56, 0, 117, 0, 123, 0, 127, 0, 57, 0, 0, 0, 96, 0, 238, 0, 95, 0, 31, 0, 62, 0, 53, 128, 42, 128, 20, 128, 0, 192, 0, 255, 0, 255, 0, 255, 0, 255, 0, 255, 0, 255, 0, 255, 0, 255
	._sprite_17_b
	defb 0, 3, 240, 1, 248, 0, 236, 0, 212, 0, 248, 0, 224, 1, 24, 0, 124, 0, 120, 0, 244, 0, 168, 0, 0, 1, 0, 3, 0, 63, 0, 127, 0, 255, 0, 255, 0, 255, 0, 255, 0, 255, 0, 255, 0, 255, 0, 255
	._sprite_17_c
	defb 0, 255, 0, 255, 0, 255, 0, 255, 0, 255, 0, 255, 0, 255, 0, 255, 0, 255, 0, 255, 0, 255, 0, 255, 0, 255, 0, 255, 0, 255, 0, 255, 0, 255, 0, 255, 0, 255, 0, 255, 0, 255, 0, 255, 0, 255, 0, 255
	._sprite_18_a
	defb 0, 255, 0, 255, 0, 255, 0, 255, 0, 255, 0, 255, 0, 255, 0, 255, 0, 255, 0, 255, 0, 255, 0, 255, 0, 255, 0, 255, 0, 255, 0, 255, 0, 255, 0, 255, 0, 255, 0, 255, 0, 255, 0, 255, 0, 255, 0, 255
	._sprite_18_b
	defb 0, 255, 0, 255, 0, 255, 0, 255, 0, 255, 0, 255, 0, 255, 0, 255, 0, 255, 0, 255, 0, 255, 0, 255, 0, 255, 0, 255, 0, 255, 0, 255, 0, 255, 0, 255, 0, 255, 0, 255, 0, 255, 0, 255, 0, 255, 0, 255
	._sprite_18_c
	defb 0, 255, 0, 255, 0, 255, 0, 255, 0, 255, 0, 255, 0, 255, 0, 255, 0, 255, 0, 255, 0, 255, 0, 255, 0, 255, 0, 255, 0, 255, 0, 255, 0, 255, 0, 255, 0, 255, 0, 255, 0, 255, 0, 255, 0, 255, 0, 255
	._sprite_19_a
	defb 0, 255
	defb 0, 195
	defb 24, 129
	defb 60, 0
	defb 60, 0
	defb 24, 129
	defb 0, 195
	defb 0, 255
	defb 0, 255, 0, 255, 0, 255, 0, 255, 0, 255, 0, 255, 0, 255, 0, 255
	._sprite_19_b
	defb 0, 255, 0, 255, 0, 255, 0, 255, 0, 255, 0, 255, 0, 255, 0, 255
	defb 0, 255, 0, 255, 0, 255, 0, 255, 0, 255, 0, 255, 0, 255, 0, 255
;	SECTION	text

._levels
	defb	3
	defb	1
	defw	52704
	defb	4
	defb	2
	defw	54310
	defb	5
	defb	7
	defw	55370
	defb	6
	defb	4
	defw	56087
	defb	7
	defb	14
	defw	57403
	defb	8
	defb	9
	defw	58276
	defb	9
	defb	8
	defw	60325
	defb	10
	defb	11
	defw	61921
	defb	11
	defb	13
	defw	64216

;	SECTION	code


._addons_between
	ld	hl,8	;const
	add	hl,sp
	ld	e,(hl)
	ld	d,0
	ld	hl,8-2	;const
	add	hl,sp
	ld	l,(hl)
	ld	h,0
	call	l_ult
	jp	nc,i_14
	ld	hl,8	;const
	add	hl,sp
	ld	l,(hl)
	ld	h,0
	jp	i_15
.i_14
	ld	hl,6	;const
	add	hl,sp
	ld	l,(hl)
	ld	h,0
.i_15
	push	hl
	ld	hl,12	;const
	add	hl,sp
	ld	e,(hl)
	ld	d,0
	ld	hl,8-2	;const
	add	hl,sp
	ld	l,(hl)
	ld	h,0
	add	hl,de
	pop	de
	call	l_ule
	jp	nc,i_16
	ld	hl,10	;const
	add	hl,sp
	ld	l,(hl)
	ld	h,0
	push	hl
	ld	hl,10	;const
	add	hl,sp
	ld	e,(hl)
	ld	d,0
	ld	hl,10-2	;const
	add	hl,sp
	ld	l,(hl)
	ld	h,0
	call	l_ult
	jp	nc,i_17
	ld	hl,8	;const
	add	hl,sp
	ld	l,(hl)
	ld	h,0
	jp	i_18
.i_17
	ld	hl,10	;const
	add	hl,sp
	ld	l,(hl)
	ld	h,0
.i_18
	ex	de,hl
	ld	hl,6-2	;const
	add	hl,sp
	ld	l,(hl)
	ld	h,0
	add	hl,de
	pop	de
	call	l_ule
	jp	nc,i_16
	ld	hl,1	;const
	jr	i_19
.i_16
	ld	hl,0	;const
.i_19
	ld	h,0
	ret


	defb 0, 255
	defb 0, 255
	defb 0, 255
	defb 0, 255
	defb 0, 255
	defb 0, 255
	defb 0, 255
	defb 0, 255
	._drop_sprites
	BINARY "../bin/spdrop.bin"
	defb 0, 255
	defb 0, 255
	defb 0, 255
	defb 0, 255
	defb 0, 255
	defb 0, 255
	defb 0, 255
	defb 0, 255
	._arrow_sprites
	BINARY "../bin/sparrow.bin"
	defw 0

._ISR
	ld b, 1
	call SetRAMBank
	call 0xC000
	ld b, 0
	call SetRAMBank
	ld	hl,(_isrc)
	ld	h,0
	inc	hl
	ld	a,l
	ld	(_isrc),a
	ret



._wyz_init
	ld b,1
	call SetRAMBank
	call 0xC018
	ld b,0
	call SetRAMBank
	ret



._wyz_play_sound
	push	hl
	di
	ld b, 1
	call SetRAMBank
	; __FASTCALL__ -> fx_number is in l!
	ld b, l
	call 0xC47E
	ld b, 0
	call SetRAMBank
	ei
	pop	bc
	ret



._wyz_play_music
	push	hl
	di
	ld b, 1
	call SetRAMBank
	; __FASTCALL__ -> song_number is in l!
	ld a, l
	call 0xC087
	ld b, 0
	call SetRAMBank
	ei
	pop	bc
	ret



._wyz_stop_sound
	di
	ld b,1
	call SetRAMBank
	call 0xC062
	ld b,0
	call SetRAMBank
	ei
	ret


;	SECTION	text

._spacer
	defw	i_1+0
;	SECTION	code


._draw_coloured_tile
	ld a, (__x)
	ld c, a
	ld a, (__y)
	call SPCompDListAddr
	ex de, hl
	ld a, (__t)
	sla a
	sla a
	add 64
	ld hl, _tileset + 2048
	ld b, 0
	ld c, a
	add hl, bc
	ld c, a
	ld a, (hl)
	ld (de), a
	inc de
	inc hl
	ld a, c
	ld (de), a
	inc de
	inc a
	ld c, a
	inc de
	inc de
	ld a, (hl)
	ld (de), a
	inc de
	inc hl
	ld a, c
	ld (de), a
	inc a
	ex de, hl
	ld bc, 123
	add hl, bc
	ex de, hl
	ld c, a
	ld a, (hl)
	ld (de), a
	inc de
	inc hl
	ld a, c
	ld (de), a
	inc de
	inc a
	ld c, a
	inc de
	inc de
	ld a, (hl)
	ld (de), a
	inc de
	ld a, c
	ld (de), a
	ret



._invalidate_tile
	; Invalidate Rectangle
	;
	; enter: B = row coord top left corner
	; C = col coord top left corner
	; D = row coord bottom right corner
	; E = col coord bottom right corner
	; IY = clipping rectangle, set it to "ClipStruct" for full screen
	ld a, (__x)
	inc a
	ld e, a
	ld a, (__y)
	inc a
	ld d, a
	ld a, (__x)
	ld c, a
	ld a, (__y)
	ld b, a
	ld iy, fsClipStruct
	call SPInvalidate
	ret



._invalidate_viewport
	; Invalidate Rectangle
	;
	; enter: B = row coord top left corner
	; C = col coord top left corner
	; D = row coord bottom right corner
	; E = col coord bottom right corner
	; IY = clipping rectangle, set it to "ClipStruct" for full screen
	ld b, 0
	ld c, 1
	ld d, 0+19
	ld e, 1+29
	ld iy, vpClipStruct
	call SPInvalidate
	ret



._draw_invalidate_coloured_tile_g
	call	_draw_coloured_tile_gamearea
	call	_invalidate_tile
	ret



._draw_coloured_tile_gamearea
	ld	a,(__x)
	ld	e,a
	ld	d,0
	ld	l,#(1 % 256)
	call	l_asl
	ld	de,1
	add	hl,de
	ld	h,0
	ld	a,l
	ld	(__x),a
	ld	a,(__y)
	ld	e,a
	ld	d,0
	ld	l,#(1 % 256)
	call	l_asl
	ld	de,0
	add	hl,de
	ld	h,0
	ld	a,l
	ld	(__y),a
	call	_draw_coloured_tile
	ret



._print_number2
	ld	a,(__t)
	ld	e,a
	ld	d,0
	ld	hl,10	;const
	call	l_div_u
	ld	de,16
	add	hl,de
	ld	h,0
	ld	a,l
	ld	(_rda),a
	ld	a,(__t)
	ld	e,a
	ld	d,0
	ld	hl,10	;const
	call	l_div_u
	ex	de,hl
	ld	de,16
	add	hl,de
	ld	h,0
	ld	a,l
	ld	(_rdb),a
	; enter: A = row position (0..23)
	; C = col position (0..31/63)
	; D = pallette #
	; E = graphic #
	ld a, (_rda)
	ld e, a
	ld d, 7
	ld a, (__x)
	ld c, a
	ld a, (__y)
	call SPPrintAtInv
	ld a, (_rdb)
	ld e, a
	ld d, 7
	ld a, (__x)
	inc a
	ld c, a
	ld a, (__y)
	call SPPrintAtInv
	ret



._print_str
	ld hl, (_gp_gen)
	.print_str_loop
	ld a, (hl)
	or a
	ret z
	inc hl
	sub 32
	ld e, a
	ld a, (__t)
	ld d, a
	ld a, (__x)
	ld c, a
	inc a
	ld (__x), a
	ld a, (__y)
	push hl
	call SPPrintAtInv
	pop hl
	jr print_str_loop
	ret



._blackout_area
	ld	hl,22529	;const
	ld	(_asm_int),hl
	ld de, (_asm_int)
	ld b, 20
	.bal1
	push bc
	ld h, d
	ld l, e
	ld (hl), 0
	inc de
	ld bc, 29
	ldir
	inc de
	inc de
	pop bc
	djnz bal1
	ret


;	SECTION	text

._utaux
	defm	""
	defb	0

;	SECTION	code



._update_tile
	ld a, (__x)
	ld c, a
	ld a, (__y)
	ld b, a
	sla a
	sla a
	sla a
	sla a
	sub b
	add c
	ld b, 0
	ld c, a
	ld hl, _map_attr
	add hl, bc
	ld a, (__n)
	ld (hl), a
	ld hl, _map_buff
	add hl, bc
	ld a, (__t)
	ld (hl), a
	call _draw_coloured_tile_gamearea
	ld a, (_is_rendering)
	or a
	ret nz
	call _invalidate_tile
	ret



._print_message
	ld	a,#(10 % 256 % 256)
	ld	(__x),a
	ld	a,#(12 % 256 % 256)
	ld	(__y),a
	ld	hl,87 % 256	;const
	ld	a,l
	ld	(__t),a
	call	_print_str
	ld	a,#(10 % 256 % 256)
	ld	(__x),a
	ld	a,#(11 % 256 % 256)
	ld	(__y),a
	ld	a,#(87 % 256 % 256)
	ld	(__t),a
	ld	hl,(_spacer)
	ld	(_gp_gen),hl
	call	_print_str
	ld	a,#(10 % 256 % 256)
	ld	(__x),a
	ld	a,#(13 % 256 % 256)
	ld	(__y),a
	ld	a,#(87 % 256 % 256)
	ld	(__t),a
	ld	hl,(_spacer)
	ld	(_gp_gen),hl
	call	_print_str
	call	sp_UpdateNow
	call	sp_WaitForNoKey
	ret



._read_controller
	ld	hl,(_pad0)
	ld	h,0
	ld	a,l
	ld	(_pad_this_frame),a
	ld	hl,(_joyfunc)
	push	hl
	ld	hl,_keys
	pop	de
	ld	bc,i_22
	push	hl
	push	bc
	push	de
	ld	a,1
	ret
.i_22
	pop	bc
	ld	h,0
	ld	a,l
	ld	(_pad0),a
	ld	hl,(_pad_this_frame)
	ld	h,0
	ex	de,hl
	ld	hl,(_pad0)
	ld	h,0
	call	l_xor
	call	l_com
	ex	de,hl
	ld	hl,(_pad0)
	ld	h,0
	call	l_or
	ld	de,112	;const
	ex	de,hl
	call	l_or
	ld	h,0
	ld	a,l
	ld	(_pad_this_frame),a
	ret



._button_pressed
	call	_read_controller
	ld	a,(_pad_this_frame)
	ld	e,a
	ld	d,0
	ld	hl,255	;const
	call	l_ne
	ld	hl,0	;const
	rl	l
	ld	h,0
	ret



._cortina
	ld b, 7
	.fade_out_extern
	push bc
	ld e, 3 ; 3 tercios
	ld hl, 22528 ; aqu� empiezan los atributos
	halt ; esperamos retrazo.
	.fade_out_bucle
	ld a, (hl ) ; nos traemos el atributo actual
	ld d, a ; tomar atributo
	and 7 ; aislar la tinta
	jr z, ink_done ; si vale 0, no se decrementa
	dec a ; decrementamos tinta
	.ink_done
	ld b, a ; en b tenemos ahora la tinta ya procesada.
	ld a, d ; tomar atributo
	and 56 ; aislar el papel, sin modificar su posición en el byte
	jr z, paper_done ; si vale 0, no se decrementa
	sub 8 ; decrementamos papel restando 8
	.paper_done
	ld c, a ; en c tenemos ahora el papel ya procesado.
	ld a, d
	and 192 ; nos quedamos con bits 6 y 7 (0x40 y 0x80)
	or c ; a�adimos paper
	or b ; e ink, con lo que recompuesto el atributo
	ld (hl),a ; lo escribimos,
	inc l ; e incrementamos el puntero.
	jr nz, fade_out_bucle ; continuamos hasta acabar el tercio (cuando L valga 0)
	inc h ; siguiente tercio
	dec e
	jr nz, fade_out_bucle ; repetir las 3 veces
	pop bc
	djnz fade_out_extern
	ret



._addsign
	ld	hl,4	;const
	call	l_gintspsp	;
	ld	hl,0	;const
	pop	de
	call	l_eq
	jp	nc,i_23
	ld	hl,0	;const
	jp	i_24
.i_23
	ld	hl,4	;const
	call	l_gintspsp	;
	ld	hl,0	;const
	pop	de
	call	l_gt
	jp	nc,i_25
	pop	bc
	pop	hl
	push	hl
	push	bc
	jp	i_26
.i_25
	pop	bc
	pop	hl
	push	hl
	push	bc
	call	l_neg
.i_26
.i_24
	ret



._abs
	pop	bc
	pop	hl
	push	hl
	push	bc
	xor	a
	or	h
	jp	p,i_27
	pop	bc
	pop	hl
	push	hl
	push	bc
	call	l_neg
	ret


.i_27
	pop	bc
	pop	hl
	push	hl
	push	bc
	ret


.i_28
	ret



._active_sleep
.i_31
	halt
	ld	a,(_p_killme)
	ld	e,a
	ld	d,0
	ld	hl,0	;const
	call	l_eq
	jp	nc,i_33
	call	_button_pressed
	ld	a,h
	or	l
	jr	nz,i_34_i_33
.i_33
	jp	i_32
.i_34_i_33
	jp	i_30
.i_32
.i_29
	pop	de
	pop	hl
	dec	hl
	push	hl
	push	de
	ld	a,h
	or	l
	jp	nz,i_31
.i_30
	ld	hl,0 % 256	;const
	push	hl
	call	sp_Border
	pop	bc
	ret



._select_joyfunc
.i_35
	call	sp_GetKey
	ld	h,0
	ld	a,l
	ld	(_gpit),a
	cp	#(49 % 256)
	jp	z,i_38
	ld	a,(_gpit)
	cp	#(50 % 256)
	jp	nz,i_37
.i_38
	ld	hl,sp_JoyKeyboard
	ld	(_joyfunc),hl
	ld	hl,(_gpit)
	ld	h,0
	ld	bc,-49
	add	hl,bc
	ld	a,h
	or	l
	jp	z,i_40
	ld	hl,6	;const
	jp	i_41
.i_40
	ld	hl,0	;const
.i_41
	ld	h,0
	ld	a,l
	ld	(_gpjt),a
	ld	hl,_keys+8
	push	hl
	ld	hl,_keyscancodes
	push	hl
	ld	hl,_gpjt
	ld	a,(hl)
	inc	(hl)
	ld	l,a
	ld	h,0
	add	hl,hl
	pop	de
	add	hl,de
	call	l_gint	;
	pop	de
	call	l_pint
	ld	hl,_keys+6
	push	hl
	ld	hl,_keyscancodes
	push	hl
	ld	hl,_gpjt
	ld	a,(hl)
	inc	(hl)
	ld	l,a
	ld	h,0
	add	hl,hl
	pop	de
	add	hl,de
	call	l_gint	;
	pop	de
	call	l_pint
	ld	hl,_keys+4
	push	hl
	ld	hl,_keyscancodes
	push	hl
	ld	hl,_gpjt
	ld	a,(hl)
	inc	(hl)
	ld	l,a
	ld	h,0
	add	hl,hl
	pop	de
	add	hl,de
	call	l_gint	;
	pop	de
	call	l_pint
	ld	hl,_keys+1+1
	push	hl
	ld	hl,_keyscancodes
	push	hl
	ld	hl,_gpjt
	ld	a,(hl)
	inc	(hl)
	ld	l,a
	ld	h,0
	add	hl,hl
	pop	de
	add	hl,de
	call	l_gint	;
	pop	de
	call	l_pint
	ld	hl,_keys
	push	hl
	ld	hl,_keyscancodes
	push	hl
	ld	hl,_gpjt
	ld	a,(hl)
	inc	(hl)
	ld	l,a
	ld	h,0
	add	hl,hl
	pop	de
	add	hl,de
	call	l_gint	;
	pop	de
	call	l_pint
	jp	i_36
.i_37
	ld	a,(_gpit)
	cp	#(51 % 256)
	jp	nz,i_43
	ld	hl,sp_JoyKempston
	ld	(_joyfunc),hl
	jp	i_36
.i_43
	ld	a,(_gpit)
	cp	#(52 % 256)
	jp	nz,i_45
	ld	hl,sp_JoySinclair1
	ld	(_joyfunc),hl
	jp	i_36
.i_45
.i_44
.i_42
	jp	i_35
.i_36
	ld	hl,0 % 256	;const
	call	_wyz_play_sound
	call	sp_WaitForNoKey
	ret


;	SECTION	text

._is_cutscene
	defm	""
	defb	0

;	SECTION	code



._do_extern_action
	ld	hl,2	;const
	add	hl,sp
	ld	l,(hl)
	ld	h,0
	ld	a,l
	ld	(_gpt),a
	and	a
	jp	nz,i_47
	ld	hl,0 % 256	;const
	ld	a,l
	ld	(_exti),a
	jp	i_50
.i_48
	ld	hl,_exti
	ld	a,(hl)
	inc	(hl)
.i_50
	ld	a,(_exti)
	cp	#(10 % 256)
	jp	z,i_49
	jp	nc,i_49
	ld	hl,(_exti)
	ld	h,0
	ld	a,l
	ld	(_extx),a
	jp	i_53
.i_51
	ld	hl,_extx
	ld	a,(hl)
	inc	(hl)
.i_53
	ld	hl,(_extx)
	ld	h,0
	push	hl
	ld	hl,(_exti)
	ld	h,0
	ld	de,30
	ex	de,hl
	and	a
	sbc	hl,de
	pop	de
	call	l_ult
	jp	nc,i_52
	ld de, 0x4700
	ld a, (_extx)
	add 1
	ld c, a
	ld a, (_exti)
	add 0
	call SPPrintAtInv
	ld de, 0x4700
	ld a, (_extx)
	add 1
	ld c, a
	ld a, (_exti)
	ld b, a
	ld a, 0 + 19
	sub b
	call SPPrintAtInv
	ld	hl,(_extx)
	ld	h,0
	push	hl
	ld	hl,(_exti)
	ld	h,0
	ld	de,19
	ex	de,hl
	and	a
	sbc	hl,de
	pop	de
	call	l_ult
	jp	nc,i_54
	ld de, 0x4700
	ld a, (_exti)
	add 1
	ld c, a
	ld a, (_extx)
	add 0
	call SPPrintAtInv
	ld de, 0x4700
	ld a, (_exti)
	ld b, a
	ld a, 1 + 29
	sub b
	ld c, a
	ld a, (_extx)
	add 0
	call SPPrintAtInv
.i_54
	jp	i_51
.i_52
	halt
	ld	hl,0 % 256	;const
	push	hl
	call	sp_UpdateNowEx
	pop	bc
	jp	i_48
.i_49
	ret


.i_47
	ld	a,(_gpt)
	cp	#(250 % 256)
	jp	z,i_56
	jp	nc,i_56
	ld	a,#(1 % 256 % 256)
	ld	(_stepbystep),a
	ld	hl,(_gpt)
	ld	h,0
	dec	hl
	add	hl,hl
	ld	(_asm_int),hl
	di
	ld b, 6
	call SetRAMBank
	; First we get where to look for the packed string
	ld hl, (_asm_int)
	ld de, $c000
	add hl, de
	ld a, (hl)
	inc hl
	ld h, (hl)
	ld l, a
	add hl, de
	ld de, _textbuff
	; 5-bit scaped depacker by na_th_an
	; Contains code by Antonio Villena
	ld a, $80
	.fbsd_mainb
	call fbsd_unpackc
	ld c, a
	ld a, b
	and a
	jr z, fbsd_fin
	call fbsd_stor
	ld a, c
	jr fbsd_mainb
	.fbsd_stor
	cp 31
	jr z, fbsd_escaped
	add a, 64
	jr fbsd_stor2
	.fbsd_escaped
	ld a, c
	call fbsd_unpackc
	ld c, a
	ld a, b
	add a, 32
	.fbsd_stor2
	ld (de), a
	inc de
	ret
	.fbsd_unpackc
	ld b, 0x08
	.fbsd_bucle
	call fbsd_getbit
	rl b
	jr nc, fbsd_bucle
	ret
	.fbsd_getbit
	add a, a
	ret nz
	ld a, (hl)
	inc hl
	rla
	ret
	.fbsd_fin
	ld (de), a
	;
	;
	ld b, 0
	call SetRAMBank
	ei
	ld	a,(_is_cutscene)
	and	a
	jp	nz,i_57
	ld	hl,(_textbuff)
	ld	h,0
	ld	bc,-64
	add	hl,bc
	ld	h,0
	ld	a,l
	ld	(_exti),a
	ld	hl,(_exti)
	ld	h,0
	ld	de,3
	add	hl,de
	ex	de,hl
	ld	hl,(_exti)
	ld	h,0
	add	hl,de
	ld	h,0
	ld	a,l
	ld	(_extx),a
	ld	a,#(3 % 256 % 256)
	ld	(__x),a
	ld	a,#(3 % 256 % 256)
	ld	(__y),a
	ld	a,#(6 % 256 % 256)
	ld	(__t),a
	ld	hl,i_1+13
	ld	(_gp_gen),hl
	call	_print_str
	ld	a,#(3 % 256 % 256)
	ld	(__x),a
	ld	a,#(6 % 256 % 256)
	ld	(__t),a
	ld	hl,i_1+40
	ld	(_gp_gen),hl
	ld	hl,4 % 256	;const
	ld	a,l
	ld	(__y),a
	jp	i_60
.i_58
	ld	hl,(__y)
	ld	h,0
	inc	hl
	ld	a,l
	ld	(__y),a
.i_60
	ld	hl,(__y)
	ld	h,0
	ex	de,hl
	ld	hl,(_extx)
	ld	h,0
	call	l_ult
	jp	nc,i_59
	ld	hl,3 % 256	;const
	ld	a,l
	ld	(__x),a
	call	_print_str
	jp	i_58
.i_59
	ld	a,#(3 % 256 % 256)
	ld	(__x),a
	ld	hl,(_extx)
	ld	h,0
	ld	a,l
	ld	(__y),a
	ld	a,#(6 % 256 % 256)
	ld	(__t),a
	ld	hl,i_1+67
	ld	(_gp_gen),hl
	call	_print_str
	ld	hl,4 % 256	;const
	ld	a,l
	ld	(_exty),a
	jp	i_61
.i_57
	ld	hl,13 % 256	;const
	ld	a,l
	ld	(_exty),a
.i_61
	ld	a,#(4 % 256 % 256)
	ld	(_extx),a
	ld	hl,_textbuff+1
	ld	(_gp_gen),hl
	ld	hl,1 % 256	;const
	ld	a,l
	ld	(_keyp),a
.i_62
	ld	hl,(_gp_gen)
	inc	hl
	ld	(_gp_gen),hl
	dec	hl
	ld	l,(hl)
	ld	h,0
	ld	a,l
	ld	(_exti),a
	ld	a,h
	or	l
	jp	z,i_63
	ld	a,(_exti)
	cp	#(37 % 256)
	jp	nz,i_64
	ld	a,#(4 % 256 % 256)
	ld	(_extx),a
	ld	hl,(_exty)
	ld	h,0
	inc	hl
	inc	hl
	ld	h,0
	ld	a,l
	ld	(_exty),a
	jp	i_65
.i_64
	ld a, (_exti)
	sub 32
	ld e, a
	ld a, (_extx)
	ld c, a
	ld a, (_exty)
	ld d, 71
	call SPPrintAtInv
	ld	hl,(_extx)
	ld	h,0
	inc	hl
	ld	a,l
	ld	(_extx),a
	cp	#(28 % 256)
	jp	nz,i_66
	ld	a,#(4 % 256 % 256)
	ld	(_extx),a
	ld	hl,(_exty)
	ld	h,0
	inc	hl
	inc	hl
	ld	h,0
	ld	a,l
	ld	(_exty),a
.i_66
.i_65
	ld	hl,(_stepbystep)
	ld	h,0
	ld	a,h
	or	l
	jp	z,i_67
	halt
	ld	a,(_exti)
	cp	#(32 % 256)
	jp	z,i_69
	ld	a,(_is_cutscene)
	cp	#(0 % 256)
	jr	z,i_70_i_69
.i_69
	jp	i_68
.i_70_i_69
	ld	hl,8 % 256	;const
	call	_wyz_play_sound
.i_68
	halt
	halt
	ld	hl,0 % 256	;const
	push	hl
	call	sp_UpdateNowEx
	pop	bc
.i_67
	call	_button_pressed
	ld	a,h
	or	l
	jp	z,i_71
	ld	a,(_keyp)
	and	a
	jp	nz,i_72
	ld	hl,0 % 256	;const
	ld	a,l
	ld	(_stepbystep),a
.i_72
	jp	i_73
.i_71
	ld	hl,0 % 256	;const
	ld	a,l
	ld	(_keyp),a
.i_73
	jp	i_62
.i_63
	ld	hl,0 % 256	;const
	push	hl
	call	sp_UpdateNowEx
	pop	bc
	call	sp_WaitForNoKey
.i_74
	call	_button_pressed
	ld	a,h
	or	l
	jp	nz,i_74
.i_75
	ld	hl,5000	;const
	push	hl
	call	_active_sleep
	pop	bc
	ld	a,(_is_cutscene)
	and	a
	jp	z,i_76
	ld	hl,11 % 256	;const
	ld	a,l
	ld	(_exti),a
	jp	i_79
.i_77
	ld	hl,_exti
	ld	a,(hl)
	inc	(hl)
.i_79
	ld	a,(_exti)
	cp	#(24 % 256)
	jp	z,i_78
	jp	nc,i_78
	ld	a,#(3 % 256 % 256)
	ld	(__x),a
	ld	hl,(_exti)
	ld	h,0
	ld	a,l
	ld	(__y),a
	ld	a,#(71 % 256 % 256)
	ld	(__t),a
	ld	hl,i_1+94
	ld	(_gp_gen),hl
	call	_print_str
	ld	hl,0	;const
	push	hl
	call	sp_UpdateNow
	pop	bc
	jp	i_77
.i_78
.i_76
	jp	i_80
.i_56
	ld	a,(_gpt)
	cp	#(251 % 256)
	jp	nz,i_81
	ld	hl,1 % 256	;const
	ld	a,l
	ld	(_is_cutscene),a
	jp	i_82
.i_81
	ld	a,(_gpt)
	cp	#(250 % 256)
	jp	nz,i_83
	ld	hl,0 % 256	;const
	ld	a,l
	ld	(_is_cutscene),a
	jp	i_84
.i_83
	ld	hl,(_gpt)
	ld	h,0
	ld	bc,-252
	add	hl,bc
	ld	h,0
	ld	a,l
	ld	(_exti),a
	ld	hl,_baddies
	push	hl
	ld	hl,(_enoffs)
	ld	h,0
	ex	de,hl
	ld	hl,(_exti)
	ld	h,0
	add	hl,de
	ld	b,h
	ld	c,l
	add	hl,hl
	add	hl,hl
	add	hl,bc
	add	hl,hl
	pop	de
	add	hl,de
	ld	bc,8
	add	hl,bc
	push	hl
	ld	a,(hl)
	and	#(127 % 256)
	pop	de
	ld	(de),a
	ld	de,_en_an_state
	ld	hl,(_exti)
	ld	h,0
	add	hl,de
	push	hl
	ld	de,_en_an_count
	ld	hl,(_exti)
	ld	h,0
	add	hl,de
	ld	(hl),#(0 % 256 % 256)
	ld	l,(hl)
	ld	h,0
	pop	de
	ld	a,l
	ld	(de),a
	ld	hl,_baddies
	push	hl
	ld	hl,(_enoffs)
	ld	h,0
	ex	de,hl
	ld	hl,(_exti)
	ld	h,0
	add	hl,de
	ld	b,h
	ld	c,l
	add	hl,hl
	add	hl,hl
	add	hl,bc
	add	hl,hl
	pop	de
	add	hl,de
	ld	bc,9
	add	hl,bc
	push	hl
	ld	hl,_level_data+6
	ld	a,(hl)
	pop	de
	ld	(de),a
	ld	l,a
	ld	h,0
.i_84
.i_82
.i_80
.i_55
	ret



._read_byte
	di
	ld b, 6
	call SetRAMBank
	ld hl, (_script)
	ld a, (hl)
	ld (_safe_byte), a
	inc hl
	ld (_script), hl
	ld b, 0
	call SetRAMBank
	ei
	ld	hl,(_safe_byte)
	ld	h,0
	ret



._read_vbyte
	call _read_byte
	ld a, l
	and 128
	ret z
	ld a, l
	and 127
	ld c, a
	ld b, 0
	ld hl, _flags
	add hl, bc
	ld l, (hl)
	ld h, 0
	ret
	ret



._readxy
	call	_read_vbyte
	ld	h,0
	ld	a,l
	ld	(_sc_x),a
	call	_read_vbyte
	ld	h,0
	ld	a,l
	ld	(_sc_y),a
	ret



._stop_player
	ld	hl,0	;const
	ld	a,l
	call	l_sxt
	ld	a,l
	ld	(_p_vy),a
	ld	a,l
	call	l_sxt
	ld	a,l
	ld	(_p_vx),a
	ret



._reloc_player
	call	_read_vbyte
	ld	h,l
	ld	l,0
	ld	(_p_x),hl
	call	_read_vbyte
	ld	h,l
	ld	l,0
	ld	(_p_y),hl
	call	_stop_player
	ret



._run_script
	ld	de,(_main_script_offset)
	ld	hl,4-2	;const
	add	hl,sp
	ld	l,(hl)
	ld	h,0
	add	hl,de
	ex	de,hl
	ld	hl,4-2	;const
	add	hl,sp
	ld	l,(hl)
	ld	h,0
	add	hl,de
	ld	(_asm_int),hl
	di
	ld b, 6
	call SetRAMBank
	ld hl, (_asm_int)
	ld a, (hl)
	inc hl
	ld h, (hl)
	ld l, a
	ld (_script), hl
	ld b, 0
	call SetRAMBank
	ei
	ld	hl,(_script)
	ld	a,h
	or	l
	jp	nz,i_85
	ret


.i_85
	ld	de,(_script)
	ld	hl,(_main_script_offset)
	add	hl,de
	ld	(_script),hl
.i_86
	call	_read_byte
	ld	h,0
	ld	a,l
	ld	(_sc_c),a
	ld	de,255	;const
	ex	de,hl
	call	l_ne
	jp	nc,i_87
	ld	de,(_script)
	ld	hl,(_sc_c)
	ld	h,0
	add	hl,de
	ld	(_next_script),hl
	ld	hl,0 % 256	;const
	ld	a,l
	ld	(_sc_continuar),a
	ld	h,0
	ld	a,l
	ld	(_sc_terminado),a
.i_88
	ld	hl,(_sc_terminado)
	ld	h,0
	call	l_lneg
	jp	nc,i_89
	call	_read_byte
.i_92
	ld	a,l
	cp	#(16% 256)
	jp	z,i_93
	cp	#(17% 256)
	jp	z,i_94
	cp	#(18% 256)
	jp	z,i_95
	cp	#(19% 256)
	jp	z,i_96
	cp	#(32% 256)
	jp	z,i_97
	cp	#(34% 256)
	jp	z,i_100
	cp	#(80% 256)
	jp	z,i_103
	cp	#(81% 256)
	jp	z,i_104
	cp	#(240% 256)
	jp	z,i_105
	cp	#(255% 256)
	jp	z,i_106
	jp	i_91
.i_93
	call	_readxy
	ld	de,_flags
	ld	hl,(_sc_x)
	ld	h,0
	add	hl,de
	ld	e,(hl)
	ld	d,0
	ld	hl,(_sc_y)
	ld	h,0
	call	l_ne
	ld	hl,0	;const
	rl	l
	ld	h,0
	ld	a,l
	ld	(_sc_terminado),a
	jp	i_91
.i_94
	call	_readxy
	ld	de,_flags
	ld	hl,(_sc_x)
	ld	h,0
	add	hl,de
	ld	e,(hl)
	ld	d,0
	ld	hl,(_sc_y)
	ld	h,0
	call	l_uge
	ld	hl,0	;const
	rl	l
	ld	h,0
	ld	a,l
	ld	(_sc_terminado),a
	jp	i_91
.i_95
	call	_readxy
	ld	de,_flags
	ld	hl,(_sc_x)
	ld	h,0
	add	hl,de
	ld	e,(hl)
	ld	d,0
	ld	hl,(_sc_y)
	ld	h,0
	call	l_ule
	ld	hl,0	;const
	rl	l
	ld	h,0
	ld	a,l
	ld	(_sc_terminado),a
	jp	i_91
.i_96
	call	_readxy
	ld	de,_flags
	ld	hl,(_sc_x)
	ld	h,0
	add	hl,de
	ld	e,(hl)
	ld	d,0
	ld	hl,(_sc_y)
	ld	h,0
	call	l_eq
	ld	hl,0	;const
	rl	l
	ld	h,0
	ld	a,l
	ld	(_sc_terminado),a
	jp	i_91
.i_97
	call	_readxy
	ld	a,(_sc_x)
	ld	e,a
	ld	d,0
	ld	l,#(4 % 256)
	call	l_asl
	ld	h,0
	ld	a,l
	ld	(_sc_x),a
	ld	a,(_sc_y)
	ld	e,a
	ld	d,0
	ld	l,#(4 % 256)
	call	l_asl
	ld	h,0
	ld	a,l
	ld	(_sc_y),a
	ld	hl,(_gpx)
	ld	h,0
	ld	bc,15
	add	hl,bc
	ex	de,hl
	ld	hl,(_sc_x)
	ld	h,0
	call	l_uge
	jp	nc,i_98
	ld	hl,(_gpx)
	ld	h,0
	push	hl
	ld	hl,(_sc_x)
	ld	h,0
	ld	bc,15
	add	hl,bc
	pop	de
	call	l_ule
	jp	nc,i_98
	ld	hl,(_gpy)
	ld	h,0
	ld	bc,15
	add	hl,bc
	ex	de,hl
	ld	hl,(_sc_y)
	ld	h,0
	call	l_uge
	jp	nc,i_98
	ld	hl,(_gpy)
	ld	h,0
	push	hl
	ld	hl,(_sc_y)
	ld	h,0
	ld	bc,15
	add	hl,bc
	pop	de
	call	l_ule
	jp	nc,i_98
	ld	hl,1	;const
	jr	i_99
.i_98
	ld	hl,0	;const
.i_99
	call	l_lneg
	ld	hl,0	;const
	rl	l
	ld	h,0
	ld	a,l
	ld	(_sc_terminado),a
	jp	i_91
.i_100
	call	_read_byte
	ld	h,0
	ld	a,l
	ld	(_sc_x),a
	call	_read_byte
	ld	h,0
	ld	a,l
	ld	(_sc_y),a
	ld	hl,(_p_y)
	ex	de,hl
	ld	l,#(4 % 256)
	call	l_asr
	ex	de,hl
	ld	hl,(_sc_x)
	ld	h,0
	call	l_ge
	jp	nc,i_101
	ld	hl,(_p_y)
	ex	de,hl
	ld	l,#(4 % 256)
	call	l_asr
	ex	de,hl
	ld	hl,(_sc_y)
	ld	h,0
	call	l_le
	jp	nc,i_101
	ld	hl,1	;const
	jr	i_102
.i_101
	ld	hl,0	;const
.i_102
	call	l_lneg
	ld	hl,0	;const
	rl	l
	ld	h,0
	ld	a,l
	ld	(_sc_terminado),a
	jp	i_91
.i_103
	ld	hl,(_n_pant)
	ld	h,0
	push	hl
	call	_read_vbyte
	pop	de
	call	l_ne
	ld	hl,0	;const
	rl	l
	ld	h,0
	ld	a,l
	ld	(_sc_terminado),a
	jp	i_91
.i_104
	ld	hl,(_n_pant)
	ld	h,0
	push	hl
	call	_read_vbyte
	pop	de
	call	l_eq
	ld	hl,0	;const
	rl	l
	ld	h,0
	ld	a,l
	ld	(_sc_terminado),a
.i_105
	jp	i_91
.i_106
	ld	a,#(1 % 256 % 256)
	ld	(_sc_terminado),a
	ld	hl,1 % 256	;const
	ld	a,l
	ld	(_sc_continuar),a
.i_91
	jp	i_88
.i_89
	ld	a,(_sc_continuar)
	and	a
	jp	z,i_107
	ld	hl,0 % 256	;const
	ld	a,l
	ld	(_sc_terminado),a
.i_108
	ld	hl,(_sc_terminado)
	ld	h,0
	call	l_lneg
	jp	nc,i_109
	call	_read_byte
.i_112
	ld	a,l
	cp	#(1% 256)
	jp	z,i_113
	cp	#(16% 256)
	jp	z,i_114
	cp	#(17% 256)
	jp	z,i_115
	cp	#(32% 256)
	jp	z,i_116
	cp	#(80% 256)
	jp	z,i_117
	cp	#(105% 256)
	jp	z,i_118
	cp	#(109% 256)
	jp	z,i_119
	cp	#(110% 256)
	jp	z,i_120
	cp	#(112% 256)
	jp	z,i_125
	cp	#(113% 256)
	jp	z,i_126
	cp	#(114% 256)
	jp	z,i_127
	cp	#(128% 256)
	jp	z,i_128
	cp	#(129% 256)
	jp	z,i_129
	cp	#(224% 256)
	jp	z,i_130
	cp	#(225% 256)
	jp	z,i_131
	cp	#(226% 256)
	jp	z,i_132
	cp	#(228% 256)
	jp	z,i_133
	cp	#(229% 256)
	jp	z,i_134
	cp	#(230% 256)
	jp	z,i_137
	cp	#(242% 256)
	jp	z,i_140
	cp	#(243% 256)
	jp	z,i_141
	cp	#(244% 256)
	jp	z,i_142
	cp	#(255% 256)
	jp	z,i_145
	jp	i_111
.i_113
	call _readxy
	ld de, (_sc_x)
	ld d, 0
	ld hl, _flags
	add hl, de
	ld a, (_sc_y)
	ld (hl), a
	jp	i_111
.i_114
	call _readxy
	ld de, (_sc_x)
	ld d, 0
	ld hl, _flags
	add hl, de
	ld c, (hl)
	ld a, (_sc_y)
	add c
	ld (hl), a
	jp	i_111
.i_115
	call _readxy
	ld de, (_sc_x)
	ld d, 0
	ld hl, _flags
	add hl, de
	ld a, (_sc_y)
	ld c, a
	ld a, (hl)
	sub c
	ld (hl), a
	jp	i_111
.i_116
	call	_readxy
	call	_read_vbyte
	ld	h,0
	ld	a,l
	ld	(_sc_n),a
	ld	hl,(_sc_x)
	ld	h,0
	ld	a,l
	ld	(__x),a
	ld	hl,(_sc_y)
	ld	h,0
	ld	a,l
	ld	(__y),a
	ld	de,_behs
	ld	hl,(_sc_n)
	ld	h,0
	add	hl,de
	ld	l,(hl)
	ld	h,0
	ld	a,l
	ld	(__n),a
	ld	hl,(_sc_n)
	ld	h,0
	ld	a,l
	ld	(__t),a
	call	_update_tile
	jp	i_111
.i_117
	call	_readxy
	ld	hl,(_sc_x)
	ld	h,0
	ld	a,l
	ld	(__x),a
	ld	hl,(_sc_y)
	ld	h,0
	ld	a,l
	ld	(__y),a
	call	_read_vbyte
	ld	h,0
	ld	a,l
	ld	(__t),a
	call	_draw_coloured_tile
	call	_invalidate_tile
	jp	i_111
.i_118
	call	_read_vbyte
	ld	h,0
	ld	a,l
	ld	(_warp_to_level),a
	call	_read_vbyte
	ld	h,0
	ld	a,l
	ld	(_n_pant),a
	ld	hl,99 % 256	;const
	ld	a,l
	ld	(_o_pant),a
	call	_reloc_player
	call	_read_vbyte
	ld	h,0
	ld	a,l
	ld	(_silent_level),a
	ld	a,#(1 % 256 % 256)
	ld	(_sc_terminado),a
	ld	hl,3 % 256	;const
	ld	a,l
	ld	(_script_result),a
	ret


.i_119
	call	_read_vbyte
	ld	h,0
	ld	a,l
	ld	(_n_pant),a
	ld	hl,99 % 256	;const
	ld	a,l
	ld	(_o_pant),a
	call	_reloc_player
	ret


.i_120
	ld	hl,0 % 256	;const
	ld	a,l
	ld	(_sc_y),a
	ld	h,0
	ld	a,l
	ld	(_sc_x),a
	ld	hl,0 % 256	;const
	ld	a,l
	ld	(_sc_c),a
	jp	i_123
.i_121
	ld	hl,_sc_c
	ld	a,(hl)
	inc	(hl)
.i_123
	ld	a,(_sc_c)
	cp	#(150 % 256)
	jp	z,i_122
	jp	nc,i_122
	ld	hl,(_sc_x)
	ld	h,0
	ld	a,l
	ld	(__x),a
	ld	hl,(_sc_y)
	ld	h,0
	ld	a,l
	ld	(__y),a
	ld	de,_map_attr
	ld	hl,(_sc_c)
	ld	h,0
	add	hl,de
	ld	l,(hl)
	ld	h,0
	ld	a,l
	ld	(__n),a
	ld	de,_map_buff
	ld	hl,(_sc_c)
	ld	h,0
	add	hl,de
	ld	l,(hl)
	ld	h,0
	ld	a,l
	ld	(__t),a
	call	_update_tile
	ld	hl,_sc_x
	ld	a,(hl)
	inc	(hl)
	ld	a,(_sc_x)
	cp	#(15 % 256)
	jp	nz,i_124
	ld	a,#(0 % 256 % 256)
	ld	(_sc_x),a
	ld	hl,_sc_y
	ld	a,(hl)
	inc	(hl)
	ld	l,a
	ld	h,0
.i_124
	jp	i_121
.i_122
	jp	i_111
.i_125
	ld	hl,_ctimer+1
	push	hl
	call	_read_vbyte
	pop	de
	ld	a,l
	ld	(de),a
	ld	hl,_ctimer+1+1
	push	hl
	call	_read_vbyte
	pop	de
	ld	a,l
	ld	(de),a
	ld	hl,_ctimer+1+1+1
	push	hl
	ld	hl,_ctimer+4
	ld	(hl),#(0 % 256 % 256)
	ld	l,(hl)
	ld	h,0
	pop	de
	ld	a,l
	ld	(de),a
	jp	i_111
.i_126
	ld	hl,_ctimer
	ld	(hl),#(1 % 256 % 256)
	ld	l,(hl)
	ld	h,0
	jp	i_111
.i_127
	ld	hl,_ctimer
	ld	(hl),#(0 % 256 % 256)
	ld	l,(hl)
	ld	h,0
	jp	i_111
.i_128
	ld	hl,_baddies
	push	hl
	ld	hl,(_enoffs)
	ld	h,0
	push	hl
	call	_read_vbyte
	pop	de
	add	hl,de
	ld	b,h
	ld	c,l
	add	hl,hl
	add	hl,hl
	add	hl,bc
	add	hl,hl
	pop	de
	add	hl,de
	ld	bc,8
	add	hl,bc
	push	hl
	ld	a,(hl)
	and	#(127 % 256)
	pop	de
	ld	(de),a
	ld	l,a
	ld	h,0
	jp	i_111
.i_129
	ld	hl,_baddies
	push	hl
	ld	hl,(_enoffs)
	ld	h,0
	push	hl
	call	_read_vbyte
	pop	de
	add	hl,de
	ld	b,h
	ld	c,l
	add	hl,hl
	add	hl,hl
	add	hl,bc
	add	hl,hl
	pop	de
	add	hl,de
	ld	bc,8
	add	hl,bc
	ld	a,(hl)
	or	#(128 % 256)
	ld	(hl),a
	ld	l,a
	ld	h,0
	jp	i_111
.i_130
	call	_read_vbyte
	ld	h,0
	call	_wyz_play_sound
	jp	i_111
.i_131
	call	sp_UpdateNow
	jp	i_111
.i_132
	ld	hl,5 % 256	;const
	ld	a,l
	ld	(_p_life),a
	jp	i_111
.i_133
	call	_read_byte
	ld	h,0
	push	hl
	call	_do_extern_action
	pop	bc
	jp	i_111
.i_134
	call	_read_byte
	ld	h,0
	ld	a,l
	ld	(_sc_n),a
.i_135
	ld	hl,_sc_n
	ld	a,(hl)
	dec	(hl)
	ld	l,a
	ld	h,0
	ld	a,h
	or	l
	jp	z,i_136
	halt
	jp	i_135
.i_136
	jp	i_111
.i_137
	call	_read_vbyte
	ld	h,0
	ld	a,l
	ld	(_sc_n),a
	ld	e,a
	ld	d,0
	ld	hl,255	;const
	call	l_eq
	jp	nc,i_138
	call	_wyz_stop_sound
	jp	i_139
.i_138
	ld	hl,_level_data+10
	push	hl
	ld	hl,_sc_n
	ld	a,(hl)
	pop	de
	ld	(de),a
	ld	hl,(_level_data+10)
	ld	h,0
	call	_wyz_play_music
.i_139
	jp	i_111
.i_140
	ret


.i_141
	ld	hl,4 % 256	;const
	ld	a,l
	ld	(_script_result),a
	ret


	jp	i_111
.i_142
.i_143
	call	_read_byte
	ld	h,0
	ld	a,l
	ld	(_sc_x),a
	ld	de,255
	call	l_ne
	jp	nc,i_144
	call	_read_byte
	ld	h,0
	ld	a,l
	ld	(_sc_n),a
	ld	a,(_sc_x)
	ld	e,a
	ld	d,0
	ld	l,#(4 % 256)
	call	l_asr_u
	ld	h,0
	ld	a,l
	ld	(__x),a
	ld	a,(_sc_x)
	ld	e,a
	ld	d,0
	ld	hl,15	;const
	call	l_and
	ld	h,0
	ld	a,l
	ld	(__y),a
	ld	de,_behs
	ld	hl,(_sc_n)
	ld	h,0
	add	hl,de
	ld	l,(hl)
	ld	h,0
	ld	a,l
	ld	(__n),a
	ld	hl,(_sc_n)
	ld	h,0
	ld	a,l
	ld	(__t),a
	call	_update_tile
	jp	i_143
.i_144
	jp	i_111
.i_145
	ld	hl,1 % 256	;const
	ld	a,l
	ld	(_sc_terminado),a
.i_111
	jp	i_108
.i_109
.i_107
	ld	hl,(_next_script)
	ld	(_script),hl
	jp	i_86
.i_87
	ret



._run_entering_script
	ld	hl,41 % 256	;const
	push	hl
	call	_run_script
	pop	bc
	ld	hl,(_n_pant)
	ld	h,0
	ex	de,hl
	ld	hl,(_n_pant)
	ld	h,0
	add	hl,de
	push	hl
	call	_run_script
	pop	bc
	ret



._run_fire_script
	ld	hl,42 % 256	;const
	push	hl
	call	_run_script
	pop	bc
	ld	hl,(_n_pant)
	ld	h,0
	ex	de,hl
	ld	hl,(_n_pant)
	ld	h,0
	add	hl,de
	inc	hl
	push	hl
	call	_run_script
	pop	bc
	ret



._do_ingame_scripting
	ld	hl,_pad0
	ld	a,(hl)
	and	#(2 % 256)
	jp	nz,i_146
	ld	a,(_action_pressed)
	and	a
	jp	nz,i_147
	ld	hl,1 % 256	;const
	ld	a,l
	ld	(_action_pressed),a
	call	_run_fire_script
.i_147
	jp	i_148
.i_146
	ld	hl,0 % 256	;const
	ld	a,l
	ld	(_action_pressed),a
.i_148
	ret


;	SECTION	text

._player_frames
	defw	_sprite_5_a
	defw	_sprite_6_a
	defw	_sprite_7_a
	defw	_sprite_6_a
	defw	_sprite_1_a
	defw	_sprite_2_a
	defw	_sprite_3_a
	defw	_sprite_2_a
	defw	_sprite_8_a
	defw	_sprite_4_a

;	SECTION	code

;	SECTION	text

._enem_frames
	defw	_sprite_9_a
	defw	_sprite_10_a
	defw	_sprite_11_a
	defw	_sprite_12_a
	defw	_sprite_13_a
	defw	_sprite_14_a
	defw	_sprite_15_a
	defw	_sprite_16_a

;	SECTION	code


._prepare_level
	ld	hl,_levels
	push	hl
	ld	hl,(_level)
	ld	h,0
	add	hl,hl
	add	hl,hl
	pop	de
	add	hl,de
	ld	l,(hl)
	ld	h,0
	push	hl
	ld	hl,_level_data
	push	hl
	call	_get_resource
	pop	bc
	pop	bc
	ld	hl,(_level_data+1+1)
	ld	h,0
	ld	a,l
	ld	(_n_pant),a
	ld	a,(_level_data+1+1+1)
	ld	e,a
	ld	d,0
	ld	l,#(4 % 256)
	call	l_asl
	ld	h,0
	ld	a,l
	ld	(_gpx),a
	ld	a,(_level_data+4)
	ld	e,a
	ld	d,0
	ld	l,#(4 % 256)
	call	l_asl
	ld	h,0
	ld	a,l
	ld	(_gpy),a
	ld	a,(_gpx)
	ld	e,a
	ld	d,0
	ld	l,#(4 % 256)
	call	l_asl
	ld	(_p_x),hl
	ld	a,(_gpy)
	ld	e,a
	ld	d,0
	ld	l,#(4 % 256)
	call	l_asl
	ld	(_p_y),hl
	ld	hl,_levels
	push	hl
	ld	hl,(_level)
	ld	h,0
	add	hl,hl
	add	hl,hl
	pop	de
	add	hl,de
	inc	hl
	inc	hl
	call	l_gint	;
	ld	(_main_script_offset),hl
	ret



._collide_pixel
	ld hl, 0
	ld a, (_cx2)
	inc a
	ld c, a
	ld a, (_cx1)
	cp c
	jr c, _collide_pixel_return
	ld a, (_cx1)
	ld c, a
	ld a, (_cx2)
	add 14
	cp c
	jr c, _collide_pixel_return
	ld a, (_cy2)
	inc a
	ld c, a
	ld a, (_cy1)
	cp c
	jr c, _collide_pixel_return
	ld a, (_cy1)
	ld c, a
	ld a, (_cy2)
	add 14
	cp c
	jr c, _collide_pixel_return
	ld l, 1
	._collide_pixel_return
	ret
	ret



._cm_two_points
	ld a, (_cx1)
	cp 15
	jr nc, _cm_two_points_at1_reset
	ld a, (_cy1)
	cp 10
	jr c, _cm_two_points_at1_do
	._cm_two_points_at1_reset
	xor a
	jr _cm_two_points_at1_done
	._cm_two_points_at1_do
	ld a, (_cy1)
	ld b, a
	sla a
	sla a
	sla a
	sla a
	sub b
	ld b, a
	ld a, (_cx1)
	add b
	ld e, a
	ld d, 0
	ld hl, _map_attr
	add hl, de
	ld a, (hl)
	._cm_two_points_at1_done
	ld (_at1), a
	ld a, (_cx2)
	cp 15
	jr nc, _cm_two_points_at2_reset
	ld a, (_cy2)
	cp 10
	jr c, _cm_two_points_at2_do
	._cm_two_points_at2_reset
	xor a
	jr _cm_two_points_at2_done
	._cm_two_points_at2_do
	ld a, (_cy2)
	ld b, a
	sla a
	sla a
	sla a
	sla a
	sub b
	ld b, a
	ld a, (_cx2)
	add b
	ld e, a
	ld d, 0
	ld hl, _map_attr
	add hl, de
	ld a, (hl)
	._cm_two_points_at2_done
	ld (_at2), a
	ret



._attr
	ld a, (_cx1)
	cp 15
	jr nc, _attr_reset
	ld a, (_cy1)
	cp 10
	jr c, _attr_do
	._attr_reset
	ld hl, 0
	ret
	._attr_do
	ld a, (_cy1)
	ld b, a
	sla a
	sla a
	sla a
	sla a
	sub b
	ld b, a
	ld a, (_cx1)
	add b
	ld e, a
	ld d, 0
	ld hl, _map_attr
	add hl, de
	ld a, (hl)
	ld h, 0
	ld l, a
	ret
	ret



._qtile
	ld a, (_cx1)
	cp 15
	jr nc, _qtile_reset
	ld a, (_cy1)
	cp 10
	jr c, _qtile_do
	._qtile_reset
	ld hl, 0
	ret
	._qtile_do
	ld a, (_cy1)
	ld b, a
	sla a
	sla a
	sla a
	sla a
	sub b
	ld b, a
	ld a, (_cx1)
	add b
	ld e, a
	ld d, 0
	ld hl, _map_buff
	add hl, de
	ld a, (hl)
	ld h, 0
	ld l, a
	ret
	ret


	._seed1 defw 0
	._seed2 defw 0
	._randres defb 0

._rand
	.rnd
	ld hl,0xA280
	ld de,0xC0DE
	ld a,h ; t = x ^ (x << 1)
	add a,a
	xor h
	ld h,l ; x = y
	ld l,d ; y = z
	ld d,e ; z = w
	ld e,a
	rra ; t = t ^ (t >> 1)
	xor e
	ld e,a
	ld a,d ; w = w ^ ( w << 3 ) ^ t
	add a,a
	add a,a
	add a,a
	xor d
	xor e
	ld e,a
	ld (rnd+1),hl
	ld (rnd+4),de
	ld (_randres), a
	ld	hl,(_randres)
	ld	h,0
	ret



._srand
	ld hl, (_seed1)
	ld (rnd+1),hl
	ld hl, (_seed2)
	ld (rnd+4),hl
	ret



._game_ending
	call	sp_UpdateNow
	ld	hl,2 % 256	;const
	push	hl
	ld	hl,16384	;const
	push	hl
	call	_get_resource
	pop	bc
	pop	bc
	ret



._game_over
	ld	a,#(1 % 256 % 256)
	ld	(__x),a
	ld	a,#(23 % 256 % 256)
	ld	(__y),a
	ld	hl,(_p_life)
	ld	h,0
	ld	a,l
	ld	(__t),a
	call	_print_number2
	ld	hl,i_1+121
	ld	(_gp_gen),hl
	call	_print_message
	ret



._init_bullets
	ld	hl,0 % 256	;const
	ld	a,l
	ld	(_gpit),a
.i_151
	ld	a,(_gpit)
	cp	#(1 % 256)
	jp	z,i_152
	jp	nc,i_152
	ld	hl,_bullets_estado
	push	hl
	ld	hl,_gpit
	ld	a,(hl)
	inc	(hl)
	ld	l,a
	ld	h,0
	pop	de
	add	hl,de
	ld	(hl),#(0 % 256 % 256)
	ld	l,(hl)
	ld	h,0
	jp	i_151
.i_152
	ret



._fire_bullet
	ld	hl,(_flags+1)
	ld	h,0
	ld	a,h
	or	l
	jp	nz,i_153
	ret


.i_153
	ld	hl,0 % 256	;const
	ld	a,l
	ld	(_gpit),a
	jp	i_156
.i_154
	ld	hl,_gpit
	ld	a,(hl)
	inc	(hl)
.i_156
	ld	a,(_gpit)
	cp	#(1 % 256)
	jp	z,i_155
	jp	nc,i_155
	ld	de,_bullets_estado
	ld	hl,(_gpit)
	ld	h,0
	add	hl,de
	ld	a,(hl)
	and	a
	jp	nz,i_157
	ld	de,_bullets_estado
	ld	hl,(_gpit)
	ld	h,0
	add	hl,de
	ld	(hl),#(1 % 256 % 256)
	ld	de,_bullets_y
	ld	hl,(_gpit)
	ld	h,0
	add	hl,de
	push	hl
	ld	hl,(_p_y)
	ex	de,hl
	ld	l,#(4 % 256)
	call	l_asr
	pop	de
	ld	a,l
	ld	(de),a
	ld	de,_bullets_my
	ld	hl,(_gpit)
	ld	h,0
	add	hl,de
	ld	(hl),#(0 % 256 % 256)
	ld	a,(_p_facing)
	and	a
	jp	nz,i_158
	ld	de,_bullets_x
	ld	hl,(_gpit)
	ld	h,0
	add	hl,de
	push	hl
	ld	hl,(_p_x)
	ex	de,hl
	ld	l,#(4 % 256)
	call	l_asr
	ld	bc,-4
	add	hl,bc
	pop	de
	ld	a,l
	ld	(de),a
	ld	de,_bullets_mx
	ld	hl,(_gpit)
	ld	h,0
	add	hl,de
	ld	(hl),#(65532 % 256 % 256)
	ld	l,(hl)
	ld	h,0
	jp	i_159
.i_158
	ld	de,_bullets_x
	ld	hl,(_gpit)
	ld	h,0
	add	hl,de
	push	hl
	ld	hl,(_p_x)
	ex	de,hl
	ld	l,#(4 % 256)
	call	l_asr
	ld	bc,12
	add	hl,bc
	pop	de
	ld	a,l
	ld	(de),a
	ld	de,_bullets_mx
	ld	hl,(_gpit)
	ld	h,0
	add	hl,de
	ld	(hl),#(4 % 256 % 256)
.i_159
	ld	hl,9 % 256	;const
	call	_wyz_play_sound
	ld	de,_bullets_life
	ld	hl,(_gpit)
	ld	h,0
	add	hl,de
	push	hl
	ld	hl,_flags+1+1
	ld	a,(hl)
	pop	de
	ld	(de),a
	ld	l,a
	ld	h,0
	jp	i_155
.i_157
	jp	i_154
.i_155
	ret



._mueve_bullets
	ld	hl,0 % 256	;const
	ld	a,l
	ld	(_gpit),a
	jp	i_162
.i_160
	ld	hl,_gpit
	ld	a,(hl)
	inc	(hl)
.i_162
	ld	a,(_gpit)
	cp	#(1 % 256)
	jp	z,i_161
	jp	nc,i_161
	ld	de,_bullets_estado
	ld	hl,(_gpit)
	ld	h,0
	add	hl,de
	ld	a,(hl)
	and	a
	jp	z,i_163
	ld	de,_bullets_mx
	ld	hl,(_gpit)
	ld	h,0
	add	hl,de
	ld	a,(hl)
	and	a
	jp	z,i_164
	ld	de,_bullets_x
	ld	hl,(_gpit)
	ld	h,0
	add	hl,de
	push	hl
	ld	l,(hl)
	ld	h,0
	push	hl
	ld	de,_bullets_mx
	ld	hl,(_gpit)
	ld	h,0
	add	hl,de
	ld	l,(hl)
	ld	h,0
	pop	de
	add	hl,de
	pop	de
	ld	a,l
	ld	(de),a
	ld	de,_bullets_x
	ld	hl,(_gpit)
	ld	h,0
	add	hl,de
	ld	a,(hl)
	cp	#(240 % 256)
	jp	z,i_165
	jp	c,i_165
	ld	de,_bullets_estado
	ld	hl,(_gpit)
	ld	h,0
	add	hl,de
	ld	(hl),#(0 % 256 % 256)
	ld	l,(hl)
	ld	h,0
.i_165
.i_164
	ld	de,_bullets_x
	ld	hl,(_gpit)
	ld	h,0
	add	hl,de
	ld	l,(hl)
	ld	h,0
	inc	hl
	inc	hl
	inc	hl
	ex	de,hl
	ld	l,#(4 % 256)
	call	l_asr_u
	ld	h,0
	ld	a,l
	ld	(_cx1),a
	ld	de,_bullets_y
	ld	hl,(_gpit)
	ld	h,0
	add	hl,de
	ld	l,(hl)
	ld	h,0
	inc	hl
	inc	hl
	inc	hl
	ex	de,hl
	ld	l,#(4 % 256)
	call	l_asr_u
	ld	h,0
	ld	a,l
	ld	(_cy1),a
	call	_attr
	ld	de,7	;const
	ex	de,hl
	call	l_gt
	jp	nc,i_166
	ld	de,_bullets_estado
	ld	hl,(_gpit)
	ld	h,0
	add	hl,de
	ld	(hl),#(0 % 256 % 256)
.i_166
	ld	de,_bullets_life
	ld	hl,(_gpit)
	ld	h,0
	add	hl,de
	ld	a,(hl)
	and	a
	jp	z,i_167
	ld	de,_bullets_life
	ld	hl,(_gpit)
	ld	h,0
	add	hl,de
	dec	(hl)
	ld	l,(hl)
	ld	h,0
	inc	l
	jp	i_168
.i_167
	ld	de,_bullets_estado
	ld	hl,(_gpit)
	ld	h,0
	add	hl,de
	ld	(hl),#(0 % 256 % 256)
	ld	l,(hl)
	ld	h,0
.i_168
.i_163
	jp	i_160
.i_161
	ret



._player_init
	xor	a
	ld	(_p_vy),a
	xor	a
	ld	(_p_vx),a
	ld	a,#(1 % 256 % 256)
	ld	(_p_jmp_ct),a
	ld	a,#(0 % 256 % 256)
	ld	(_p_jmp_on),a
	ld	a,#(0 % 256 % 256)
	ld	(_p_frame),a
	ld	a,#(0 % 256 % 256)
	ld	(_p_subframe),a
	ld	a,#(1 % 256 % 256)
	ld	(_p_facing),a
	ld	hl,255 % 256	;const
	ld	a,l
	ld	(_p_facing_h),a
	ld	h,0
	ld	a,l
	ld	(_p_facing_v),a
	ld	a,#(0 % 256 % 256)
	ld	(_p_state),a
	ld	a,#(0 % 256 % 256)
	ld	(_p_state_ct),a
	ld	a,#(0 % 256 % 256)
	ld	(_p_objs),a
	ld	a,#(0 % 256 % 256)
	ld	(_p_keys),a
	ld	a,#(0 % 256 % 256)
	ld	(_p_killed),a
	ld	a,#(0 % 256 % 256)
	ld	(_p_disparando),a
	ld	hl,_ctimer+1+1+1
	ld	(hl),#(0 % 256 % 256)
	ld	hl,_ctimer+4
	ld	(hl),#(0 % 256 % 256)
	ld	hl,_ctimer
	ld	(hl),#(0 % 256 % 256)
	ld	a,#(0 % 256 % 256)
	ld	(_p_killme),a
	ld	hl,(_n_pant)
	ld	h,0
	ld	a,l
	ld	(_p_safe_pant),a
	ld	a,(_gpx)
	ld	e,a
	ld	d,0
	ld	l,#(4 % 256)
	call	l_asr_u
	ld	h,0
	ld	a,l
	ld	(_p_safe_x),a
	ld	a,(_gpy)
	ld	e,a
	ld	d,0
	ld	l,#(4 % 256)
	call	l_asr_u
	ld	h,0
	ld	a,l
	ld	(_p_safe_y),a
	ret



._player_calc_bounding_box
	ld a, (_gpx)
	add 4
	srl a
	srl a
	srl a
	srl a
	ld (_ptx1), a
	ld a, (_gpx)
	add 11
	srl a
	srl a
	srl a
	srl a
	ld (_ptx2), a
	ld a, (_gpy)
	add 8
	srl a
	srl a
	srl a
	srl a
	ld (_pty1), a
	ld a, (_gpy)
	add 15
	srl a
	srl a
	srl a
	srl a
	ld (_pty2), a
	ret



._player_kill
	ld	hl,_p_life
	ld	a,(hl)
	dec	(hl)
	ld	hl,(_p_killme)
	ld	h,0
	call	_wyz_play_sound
	ld	a,#(0 % 256 % 256)
	ld	(_half_life),a
	ld	a,#(2 % 256 % 256)
	ld	(_p_state),a
	ld	a,#(50 % 256 % 256)
	ld	(_p_state_ct),a
	ld	hl,50	;const
	push	hl
	call	_active_sleep
	pop	bc
	ld	hl,(_p_safe_pant)
	ld	h,0
	ld	a,l
	ld	(_n_pant),a
	ld	hl,(_p_safe_x)
	ld	h,0
	ld	a,l
	ld	(_gpjt),a
	ld	hl,15 % 256	;const
	ld	a,l
	ld	(_gpit),a
.i_169
	ld	hl,_gpit
	ld	a,(hl)
	dec	(hl)
	ld	l,a
	ld	h,0
	ld	a,h
	or	l
	jp	z,i_170
	ld	hl,(_gpjt)
	ld	h,0
	ld	a,l
	ld	(_cx1),a
	ld	hl,(_p_safe_y)
	ld	h,0
	inc	hl
	ld	h,0
	ld	a,l
	ld	(_cy1),a
	call	_attr
	ld	h,0
	ld	a,l
	ld	(_at1),a
	ld	hl,(_gpjt)
	ld	h,0
	ld	a,l
	ld	(_cx1),a
	ld	hl,(_p_safe_y)
	ld	h,0
	ld	a,l
	ld	(_cy1),a
	call	_attr
	ld	h,0
	ld	a,l
	ld	(_at2),a
	ld	hl,_at1
	ld	a,(hl)
	and	#(12 % 256)
	jp	z,i_172
	ld	a,(_at2)
	ld	e,a
	ld	d,0
	ld	hl,8	;const
	call	l_and
	call	l_lneg
	jr	c,i_173_i_172
.i_172
	jp	i_171
.i_173_i_172
	jp	i_170
.i_171
	ld	hl,_gpjt
	ld	a,(hl)
	inc	(hl)
	ld	a,(_gpjt)
	cp	#(15 % 256)
	jp	nz,i_174
	ld	hl,0 % 256	;const
	ld	a,l
	ld	(_gpjt),a
.i_174
	jp	i_169
.i_170
	ld	hl,(_gpjt)
	ld	h,0
	ld	a,l
	ld	(_p_safe_x),a
	ld	e,a
	ld	d,0
	ld	l,#(4 % 256)
	call	l_asl
	ld	h,0
	ld	a,l
	ld	(_gpx),a
	ld	a,(_p_safe_y)
	ld	e,a
	ld	d,0
	ld	l,#(4 % 256)
	call	l_asl
	ld	h,0
	ld	a,l
	ld	(_gpy),a
	ld	a,(_gpx)
	ld	e,a
	ld	d,0
	ld	l,#(4 % 256)
	call	l_asl
	ld	(_p_x),hl
	ld	a,(_gpy)
	ld	e,a
	ld	d,0
	ld	l,#(4 % 256)
	call	l_asl
	ld	(_p_y),hl
	ld	hl,0 % 256	;const
	ld	a,l
	ld	(_p_jmp_on),a
	ld	a,l
	call	l_sxt
	ld	a,l
	ld	(_p_vy),a
	ld	a,l
	call	l_sxt
	ld	a,l
	ld	(_p_vx),a
	ld	hl,(_level_data+10)
	ld	h,0
	call	_wyz_play_music
	ret



._player_move
	ld	hl,0 % 256	;const
	ld	a,l
	ld	(_wall_h),a
	ld	h,0
	ld	a,l
	ld	(_wall_v),a
	ld a, (_do_gravity)
	or a
	jr z, _player_gravity_done
	; Signed comparisons are hard
	; p_vy <= 127 - 12
	; We are going to take a shortcut.
	; If p_vy < 0, just add 12.
	; If p_vy > 0, we can use unsigned comparition anyway.
	ld a, (_p_vy)
	bit 7, a
	jr nz, _player_gravity_add ; < 0
	cp 127 - 12
	jr nc, _player_gravity_maximum
	._player_gravity_add
	add 12
	jr _player_gravity_vy_set
	._player_gravity_maximum
	ld a, 127
	._player_gravity_vy_set
	ld (_p_vy), a
	._player_gravity_done
	ld a, (_p_gotten)
	or a
	jr z, _player_gravity_p_gotten_done
	xor a
	ld (_p_vy), a
	._player_gravity_p_gotten_done
	ld	hl,(_p_y)
	push	hl
	ld	hl,_p_vy
	call	l_gchar
	pop	de
	add	hl,de
	ld	(_p_y),hl
	xor	a
	or	h
	jp	p,i_175
	ld	hl,0	;const
	ld	(_p_y),hl
.i_175
	ld	hl,(_p_y)
	ld	de,2304	;const
	ex	de,hl
	call	l_gt
	jp	nc,i_176
	ld	hl,2304	;const
	ld	(_p_y),hl
.i_176
	ld	hl,(_p_y)
	ex	de,hl
	ld	l,#(4 % 256)
	call	l_asr
	ld	h,0
	ld	a,l
	ld	(_gpy),a
	call _player_calc_bounding_box
	xor a
	ld (_hit_v), a
	ld a, (_ptx1)
	ld (_cx1), a
	ld a, (_ptx2)
	ld (_cx2), a
	ld a, (_p_vy)
	ld c, a
	ld a, (_ptgmy)
	add c
	or a
	jp z, _va_collision_done
	bit 7, a
	jr z, _va_collision_vy_positive
	._va_collision_vy_negative
	ld a, (_pty1)
	ld (_cy1), a
	ld (_cy2), a
	call _cm_two_points
	ld a, (_at1)
	and 8
	jr nz, _va_col_vy_neg_do
	ld a, (_at2)
	and 8
	jr z, _va_collision_checkevil
	._va_col_vy_neg_do
	xor a
	ld (_p_vy), a
	ld a, (_pty1)
	inc a
	sla a
	sla a
	sla a
	sla a
	sub 8
	ld (_gpy), a
	ld d, 0
	ld e, a
	ld l, 4
	call l_asl
	ld (_p_y), hl
	ld a, 1
	ld (_wall_v), a
	jr _va_collision_checkevil
	._va_collision_vy_positive
	ld a, (_pty2)
	ld (_cy1), a
	ld (_cy2), a
	call _cm_two_points
	ld a, (_at1)
	and 8
	jr nz, _va_col_vy_pos_do
	ld a, (_at2)
	and 8
	jr nz, _va_col_vy_pos_do
	ld a, (_gpy)
	dec a
	and 15
	cp 8
	jr nc, _va_collision_checkevil
	ld a, (_at1)
	and 4
	jr nz, _va_col_vy_pos_do
	ld a, (_at2)
	and 4
	jr z, _va_collision_checkevil
	._va_col_vy_pos_do
	xor a
	ld (_p_vy), a
	ld a, (_pty2)
	dec a
	sla a
	sla a
	sla a
	sla a
	ld (_gpy), a
	ld d, 0
	ld e, a
	ld l, 4
	call l_asl
	ld (_p_y), hl
	ld a, 2
	ld (_wall_v), a
	._va_collision_checkevil
	ld	a,(_at1)
	cp	#(1 % 256)
	jp	z,i_177
	ld	a,(_at2)
	cp	#(1 % 256)
	jp	z,i_177
	ld	hl,0	;const
	jr	i_178
.i_177
	ld	hl,1	;const
.i_178
	ld	h,0
	ld	a,l
	ld	(_hit_v),a
	._va_collision_done
	ld	a,(_gpx)
	ld	e,a
	ld	d,0
	ld	l,#(4 % 256)
	call	l_asr_u
	ld	h,0
	ld	a,l
	ld	(_gpxx),a
	ld	a,(_gpy)
	ld	e,a
	ld	d,0
	ld	l,#(4 % 256)
	call	l_asr_u
	ld	h,0
	ld	a,l
	ld	(_gpyy),a
	ld	hl,(_gpy)
	ld	h,0
	ld	bc,16
	add	hl,bc
	ex	de,hl
	ld	l,#(4 % 256)
	call	l_asr_u
	ld	h,0
	ld	a,l
	ld	(_cy2),a
	ld	h,0
	ld	a,l
	ld	(_cy1),a
	ld	hl,(_ptx1)
	ld	h,0
	ld	a,l
	ld	(_cx1),a
	ld	hl,(_ptx2)
	ld	h,0
	ld	a,l
	ld	(_cx2),a
	call	_cm_two_points
	ld	hl,_at1
	ld	a,(hl)
	and	#(12 % 256)
	jp	nz,i_179
	ld	hl,_at2
	ld	a,(hl)
	and	#(12 % 256)
	jp	z,i_181
.i_179
	ld	a,(_gpy)
	ld	e,a
	ld	d,0
	ld	hl,15	;const
	call	l_and
	ld	de,8	;const
	ex	de,hl
	call	l_ult
	jp	nc,i_181
	ld	hl,1	;const
	jr	i_182
.i_181
	ld	hl,0	;const
.i_182
	ld	h,0
	ld	a,l
	ld	(_possee),a
	and	a
	jp	z,i_183
	ld	hl,(_n_pant)
	ld	h,0
	ld	a,l
	ld	(_p_safe_pant),a
	ld	hl,(_gpxx)
	ld	h,0
	ld	a,l
	ld	(_p_safe_x),a
	ld	hl,(_gpyy)
	ld	h,0
	ld	a,l
	ld	(_p_safe_y),a
.i_183
	ld	hl,_pad_this_frame
	ld	a,(hl)
	and	#(1 % 256)
	cp	#(0 % 256)
	ld	hl,0
	jp	nz,i_185
	inc	hl
	ld	a,(_p_jmp_on)
	cp	#(0 % 256)
	jp	nz,i_185
	ld	a,(_possee)
	and	a
	jp	nz,i_186
	ld	a,(_p_gotten)
	and	a
	jp	z,i_185
.i_186
	jr	i_188_i_185
.i_185
	jp	i_184
.i_188_i_185
	ld	a,#(1 % 256 % 256)
	ld	(_p_jmp_on),a
	ld	a,#(0 % 256 % 256)
	ld	(_p_jmp_ct),a
	ld	hl,1 % 256	;const
	call	_wyz_play_sound
.i_184
	ld	hl,_pad0
	ld	a,(hl)
	and	#(1 % 256)
	cp	#(0 % 256)
	ld	hl,0
	jp	nz,i_190
	inc	hl
	ld	a,(_p_jmp_on)
	and	a
	jr	nz,i_191_i_190
.i_190
	jp	i_189
.i_191_i_190
	ld	hl,_p_vy
	call	l_gchar
	push	hl
	ld	a,(_p_jmp_ct)
	ld	e,a
	ld	d,0
	ld	l,#(1 % 256)
	call	l_asr_u
	ld	de,44
	ex	de,hl
	and	a
	sbc	hl,de
	pop	de
	ex	de,hl
	and	a
	sbc	hl,de
	ld	a,l
	call	l_sxt
	ld	a,l
	ld	(_p_vy),a
	ld	hl,_p_vy
	call	l_gchar
	ld	de,65448	;const
	ex	de,hl
	call	l_lt
	jp	nc,i_192
	ld	hl,65448	;const
	ld	a,l
	call	l_sxt
	ld	a,l
	ld	(_p_vy),a
.i_192
	ld	hl,_p_jmp_ct
	ld	a,(hl)
	inc	(hl)
	ld	a,(_p_jmp_ct)
	cp	#(8 % 256)
	jp	nz,i_193
	ld	hl,0 % 256	;const
	ld	a,l
	ld	(_p_jmp_on),a
.i_193
.i_189
	ld	a,(_pad0)
	ld	e,a
	ld	d,0
	ld	hl,1	;const
	call	l_and
	ld	de,0	;const
	ex	de,hl
	call	l_eq
	ccf
	jp	nc,i_194
	ld	hl,0 % 256	;const
	ld	a,l
	ld	(_p_jmp_on),a
.i_194
	ld	a,(_pad0)
	ld	e,a
	ld	d,0
	ld	hl,4	;const
	call	l_and
	ld	de,0	;const
	ex	de,hl
	call	l_eq
	jp	c,i_195
	ld	a,(_pad0)
	ld	e,a
	ld	d,0
	ld	hl,8	;const
	call	l_and
	ld	de,0	;const
	ex	de,hl
	call	l_eq
	jp	c,i_195
	ld	hl,0	;const
	jr	i_196
.i_195
	ld	hl,1	;const
.i_196
	ld	h,0
	ld	a,l
	ld	(_rda),a
	ld	hl,(_rda)
	ld	h,0
	call	l_lneg
	jp	nc,i_197
	ld	hl,_p_vx
	call	l_gchar
	xor	a
	or	h
	jp	m,i_198
	or	l
	jp	z,i_198
	ld	hl,_p_vx
	call	l_gchar
	ld	bc,-8
	add	hl,bc
	ld	a,l
	call	l_sxt
	ld	a,l
	ld	(_p_vx),a
	ld	hl,_p_vx
	call	l_gchar
	xor	a
	or	h
	jp	p,i_199
	ld	hl,0	;const
	ld	a,l
	call	l_sxt
	ld	a,l
	ld	(_p_vx),a
.i_199
	jp	i_200
.i_198
	ld	hl,_p_vx
	call	l_gchar
	xor	a
	or	h
	jp	p,i_201
	ld	hl,_p_vx
	call	l_gchar
	ld	bc,8
	add	hl,bc
	ld	a,l
	call	l_sxt
	ld	a,l
	ld	(_p_vx),a
	ld	hl,_p_vx
	call	l_gchar
	xor	a
	or	h
	jp	m,i_202
	or	l
	jp	z,i_202
	ld	hl,0	;const
	ld	a,l
	call	l_sxt
	ld	a,l
	ld	(_p_vx),a
.i_202
.i_201
.i_200
.i_197
	ld	hl,_pad0
	ld	a,(hl)
	and	#(4 % 256)
	jp	nz,i_203
	ld	hl,_p_vx
	call	l_gchar
	ld	de,65488	;const
	ex	de,hl
	call	l_gt
	jp	nc,i_204
	ld	a,#(0 % 256 % 256)
	ld	(_p_facing),a
	ld	hl,_p_vx
	call	l_gchar
	ld	bc,-8
	add	hl,bc
	ld	a,l
	call	l_sxt
	ld	a,l
	ld	(_p_vx),a
.i_204
.i_203
	ld	hl,_pad0
	ld	a,(hl)
	and	#(8 % 256)
	jp	nz,i_205
	ld	hl,_p_vx
	call	l_gchar
	ld	de,48	;const
	ex	de,hl
	call	l_lt
	jp	nc,i_206
	ld	hl,_p_vx
	call	l_gchar
	ld	bc,8
	add	hl,bc
	ld	a,l
	call	l_sxt
	ld	a,l
	ld	(_p_vx),a
	ld	hl,1 % 256	;const
	ld	a,l
	ld	(_p_facing),a
.i_206
.i_205
	ld	hl,(_p_x)
	push	hl
	ld	hl,_p_vx
	call	l_gchar
	pop	de
	add	hl,de
	ld	(_p_x),hl
	ld	a,(_p_gotten)
	and	a
	jp	z,i_207
	ld	hl,(_p_x)
	push	hl
	ld	hl,_ptgmx
	call	l_gchar
	pop	de
	add	hl,de
	ld	(_p_x),hl
.i_207
	ld	hl,(_p_x)
	xor	a
	or	h
	jp	p,i_208
	ld	hl,0	;const
	ld	(_p_x),hl
.i_208
	ld	hl,(_p_x)
	ld	de,3584	;const
	ex	de,hl
	call	l_gt
	jp	nc,i_209
	ld	hl,3584	;const
	ld	(_p_x),hl
.i_209
	ld	hl,(_p_x)
	ex	de,hl
	ld	l,#(4 % 256)
	call	l_asr
	ld	h,0
	ld	a,l
	ld	(_gpx),a
	call _player_calc_bounding_box
	xor a
	ld (_hit_h), a
	ld a, (_pty1)
	ld (_cy1), a
	ld a, (_pty2)
	ld (_cy2), a
	ld a, (_p_vx)
	ld c, a
	ld a, (_ptgmx)
	add c
	or a
	jp z, _ha_collision_done
	bit 7, a
	jr z, _ha_collision_vx_positive
	._ha_collision_vx_negative
	ld a, (_ptx1)
	ld (_cx1), a
	ld (_cx2), a
	call _cm_two_points
	ld a, (_at1)
	and 8
	jr nz, _ha_col_vx_neg_do
	ld a, (_at2)
	and 8
	jr z, _ha_collision_checkevil
	._ha_col_vx_neg_do
	xor a
	ld (_p_vx), a
	ld a, (_ptx1)
	inc a
	sla a
	sla a
	sla a
	sla a
	sub 4
	ld (_gpx), a
	ld d, 0
	ld e, a
	ld l, 4
	call l_asl
	ld (_p_x), hl
	ld a, 3
	ld (_wall_h), a
	jr _ha_collision_checkevil
	._ha_collision_vx_positive
	ld a, (_ptx2)
	ld (_cx1), a
	ld (_cx2), a
	call _cm_two_points
	ld a, (_at1)
	and 8
	jr nz, _ha_col_vx_pos_do
	ld a, (_at2)
	and 8
	jr z, _ha_collision_checkevil
	._ha_col_vx_pos_do
	xor a
	ld (_p_vx), a
	ld a, (_ptx2)
	dec a
	sla a
	sla a
	sla a
	sla a
	add 4
	ld (_gpx), a
	ld d, 0
	ld e, a
	ld l, 4
	call l_asl
	ld (_p_x), hl
	ld a, 4
	ld (_wall_h), a
	._ha_collision_checkevil
	._ha_collision_done
	ld	hl,_pad0
	ld	a,(hl)
	and	#(128 % 256)
	cp	#(0 % 256)
	ld	hl,0
	jp	nz,i_211
	inc	hl
	ld	hl,(_p_disparando)
	ld	h,0
	call	l_lneg
	jr	c,i_212_i_211
.i_211
	jp	i_210
.i_212_i_211
	ld	hl,1 % 256	;const
	ld	a,l
	ld	(_p_disparando),a
	call	_fire_bullet
.i_210
	ld	a,(_pad0)
	ld	e,a
	ld	d,0
	ld	hl,128	;const
	call	l_and
	ld	de,0	;const
	ex	de,hl
	call	l_eq
	ccf
	jp	nc,i_213
	ld	hl,0 % 256	;const
	ld	a,l
	ld	(_p_disparando),a
.i_213
	ld	a,#(0 % 256 % 256)
	ld	(_hit),a
	ld	a,(_hit_v)
	and	a
	jp	z,i_214
	ld	a,#(1 % 256 % 256)
	ld	(_hit),a
	ld	hl,_p_vy
	call	l_gchar
	call	l_neg
	push	hl
	ld	hl,100	;const
	push	hl
	call	_addsign
	pop	bc
	pop	bc
	ld	a,l
	call	l_sxt
	ld	a,l
	ld	(_p_vy),a
	jp	i_215
.i_214
	ld	a,(_hit_h)
	and	a
	jp	z,i_216
	ld	a,#(1 % 256 % 256)
	ld	(_hit),a
	ld	hl,_p_vx
	call	l_gchar
	call	l_neg
	push	hl
	ld	hl,100	;const
	push	hl
	call	_addsign
	pop	bc
	pop	bc
	ld	a,l
	call	l_sxt
	ld	a,l
	ld	(_p_vx),a
.i_216
.i_215
	ld	a,(_hit)
	and	a
	jp	z,i_217
	ld	a,(_p_life)
	cp	#(0 % 256)
	jp	z,i_219
	jp	c,i_219
	ld	a,(_p_state)
	cp	#(0 % 256)
	jr	z,i_220_i_219
.i_219
	jp	i_218
.i_220_i_219
	ld	hl,3 % 256	;const
	ld	a,l
	ld	(_p_killme),a
.i_218
.i_217
	ld	hl,(_possee)
	ld	h,0
	call	l_lneg
	jp	nc,i_222
	ld	hl,(_p_gotten)
	ld	h,0
	call	l_lneg
	jr	c,i_223_i_222
.i_222
	jp	i_221
.i_223_i_222
	ld	hl,_player_frames
	push	hl
	ld	hl,(_p_facing)
	ld	h,0
	ld	de,8
	add	hl,de
	add	hl,hl
	pop	de
	add	hl,de
	call	l_gint	;
	ld	(_p_n_f),hl
	jp	i_224
.i_221
	ld	a,(_p_facing)
	ld	e,a
	ld	d,0
	ld	l,#(2 % 256)
	call	l_asl
	ld	h,0
	ld	a,l
	ld	(_gpit),a
	ld	hl,_p_vx
	call	l_gchar
	ld	a,h
	or	l
	jp	nz,i_225
	ld	hl,_player_frames
	push	hl
	ld	hl,(_gpit)
	ld	h,0
	inc	hl
	add	hl,hl
	pop	de
	add	hl,de
	call	l_gint	;
	ld	(_p_n_f),hl
	jp	i_226
.i_225
	ld	hl,_p_subframe
	ld	a,(hl)
	inc	(hl)
	ld	a,(_p_subframe)
	cp	#(4 % 256)
	jp	nz,i_227
	ld	a,#(0 % 256 % 256)
	ld	(_p_subframe),a
	ld	hl,(_p_frame)
	ld	h,0
	inc	hl
	ld	de,3	;const
	ex	de,hl
	call	l_and
	ld	h,0
	ld	a,l
	ld	(_p_frame),a
.i_227
	ld	hl,_player_frames
	push	hl
	ld	hl,(_gpit)
	ld	h,0
	ex	de,hl
	ld	hl,(_p_frame)
	ld	h,0
	add	hl,de
	add	hl,hl
	pop	de
	add	hl,de
	call	l_gint	;
	ld	(_p_n_f),hl
.i_226
.i_224
	ret



._distance
	ld a, (_cx1)
	ld c, a
	ld a, (_cx2)
	sub c
	bit 7, a
	jr z, _distance_dx_set
	neg
	._distance_dx_set
	ld (__x), a
	ld a, (_cy1)
	ld c, a
	ld a, (_cy2)
	sub c
	bit 7, a
	jr z, _distance_dy_set
	neg
	._distance_dy_set
	ld (__y), a
	ld c, a ; c = _y
	ld a, (__x) ; a = _x
	cp c ; _x < _y ?
	jr c, _distance_mn_set
	._distance_dy_min
	ld a, c
	._distance_mn_set
	ld (__n), a
	ld a, (__x)
	ld c, a
	ld a, (__y)
	add c
	ld b, a
	ld a, (__n)
	srl a
	ld c, a ; c = (mn >> 1)
	srl a
	ld d, a ; d = (mn >> 2)
	srl a
	srl a
	ld e, a ; e = (mn >> 4)
	ld a, b
	sub c
	sub d
	add e
	ld l, a
	ld h, 0
	ret



._coco_clear_sprite
	ld a, (_coco_it)
	sla a
	ld c, a
	ld b, 0
	ld hl, _sp_cocos
	add hl, bc
	ld e, (hl)
	inc hl
	ld d, (hl)
	push de
	pop ix
	ld iy, vpClipStruct
	ld bc, 0
	ld hl, 0xfefe
	ld de, 0
	call SPMoveSprAbs
	ret



._init_cocos
	ld	hl,0 % 256	;const
	ld	a,l
	ld	(_coco_it),a
	jp	i_230
.i_228
	ld	hl,(_coco_it)
	ld	h,0
	inc	hl
	ld	a,l
	ld	(_coco_it),a
.i_230
	ld	a,(_coco_it)
	cp	#(3 % 256)
	jp	z,i_229
	jp	nc,i_229
	ld	de,_coco_s
	ld	hl,(_coco_it)
	ld	h,0
	add	hl,de
	ld	(hl),#(0 % 256 % 256)
	ld	l,(hl)
	ld	h,0
	call	_coco_clear_sprite
	jp	i_228
.i_229
	ret



._shoot_coco
	ld	hl,(__en_x)
	ld	h,0
	ld	bc,4
	add	hl,bc
	ld	h,0
	ld	a,l
	ld	(_coco_x0),a
	ld	hl,0 % 256	;const
	ld	a,l
	ld	(_coco_it),a
	jp	i_233
.i_231
	ld	hl,(_coco_it)
	ld	h,0
	inc	hl
	ld	a,l
	ld	(_coco_it),a
.i_233
	ld	a,(_coco_it)
	cp	#(3 % 256)
	jp	z,i_232
	jp	nc,i_232
	ld	de,_coco_s
	ld	hl,(_coco_it)
	ld	h,0
	add	hl,de
	ld	a,(hl)
	and	a
	jp	nz,i_234
	ld	hl,(_coco_x0)
	ld	h,0
	ld	a,l
	ld	(_cx1),a
	ld	hl,(__en_y)
	ld	h,0
	ld	a,l
	ld	(_cy1),a
	ld	hl,(_gpx)
	ld	h,0
	ld	a,l
	ld	(_cx2),a
	ld	hl,(_gpy)
	ld	h,0
	ld	a,l
	ld	(_cy2),a
	call	_distance
	ld	h,0
	ld	a,l
	ld	(_coco_d),a
	cp	#(8 % 256)
	jr	z,i_235_uge
	jp	c,i_235
.i_235_uge
	ld	hl,3 % 256	;const
	call	_wyz_play_sound
	ld	de,_coco_s
	ld	hl,(_coco_it)
	ld	h,0
	add	hl,de
	ld	(hl),#(1 % 256 % 256)
	ld	de,_coco_x
	ld	hl,(_coco_it)
	ld	h,0
	add	hl,de
	push	hl
	ld	hl,_coco_x0
	ld	a,(hl)
	pop	de
	ld	(de),a
	ld	de,_coco_y
	ld	hl,(_coco_it)
	ld	h,0
	add	hl,de
	push	hl
	ld	hl,__en_y
	ld	a,(hl)
	pop	de
	ld	(de),a
	ld	de,_coco_vx
	ld	hl,(_coco_it)
	ld	h,0
	add	hl,de
	push	hl
	ld	hl,(_gpx)
	ld	h,0
	ex	de,hl
	ld	hl,(_coco_x0)
	ld	h,0
	ex	de,hl
	and	a
	sbc	hl,de
	ld	de,4
	call	l_mult
	ex	de,hl
	ld	hl,(_coco_d)
	ld	h,0
	call	l_div
	ld	a,l
	call	l_sxt
	pop	de
	ld	a,l
	ld	(de),a
	ld	de,_coco_vy
	ld	hl,(_coco_it)
	ld	h,0
	add	hl,de
	push	hl
	ld	hl,(_gpy)
	ld	h,0
	ex	de,hl
	ld	hl,(__en_y)
	ld	h,0
	ex	de,hl
	and	a
	sbc	hl,de
	ld	de,4
	call	l_mult
	ex	de,hl
	ld	hl,(_coco_d)
	ld	h,0
	call	l_div
	ld	a,l
	call	l_sxt
	pop	de
	ld	a,l
	ld	(de),a
.i_235
.i_234
	jp	i_231
.i_232
	ret



._destroy_cocos
	ld	de,_coco_s
	ld	hl,(_coco_it)
	ld	h,0
	add	hl,de
	ld	(hl),#(0 % 256 % 256)
	ld	l,(hl)
	ld	h,0
	call	_coco_clear_sprite
	ret



._move_cocos
	ld	hl,0 % 256	;const
	ld	a,l
	ld	(_coco_it),a
	jp	i_238
.i_236
	ld	hl,_coco_it
	ld	a,(hl)
	inc	(hl)
.i_238
	ld	a,(_coco_it)
	cp	#(3 % 256)
	jp	z,i_237
	jp	nc,i_237
	ld	de,_coco_s
	ld	hl,(_coco_it)
	ld	h,0
	add	hl,de
	ld	a,(hl)
	and	a
	jp	z,i_239
	ld	de,_coco_x
	ld	hl,(_coco_it)
	ld	h,0
	add	hl,de
	ld	l,(hl)
	ld	h,0
	push	hl
	ld	de,_coco_vx
	ld	hl,(_coco_it)
	ld	h,0
	add	hl,de
	call	l_gchar
	pop	de
	add	hl,de
	ld	h,0
	ld	a,l
	ld	(_ctx),a
	ld	de,_coco_y
	ld	hl,(_coco_it)
	ld	h,0
	add	hl,de
	ld	l,(hl)
	ld	h,0
	push	hl
	ld	de,_coco_vy
	ld	hl,(_coco_it)
	ld	h,0
	add	hl,de
	call	l_gchar
	pop	de
	add	hl,de
	ld	h,0
	ld	a,l
	ld	(_cty),a
	ld	a,(_ctx)
	ld	e,a
	ld	d,0
	ld	hl,240	;const
	call	l_uge
	jp	c,i_241
	ld	a,(_cty)
	ld	e,a
	ld	d,0
	ld	hl,160	;const
	call	l_uge
	jp	nc,i_240
.i_241
	ld	de,_coco_s
	ld	hl,(_coco_it)
	ld	h,0
	add	hl,de
	ld	(hl),#(0 % 256 % 256)
.i_240
	ld	a,(_p_state)
	and	a
	jp	nz,i_243
	ld	hl,(_ctx)
	ld	h,0
	inc	hl
	inc	hl
	inc	hl
	ld	h,0
	ld	a,l
	ld	(_cx1),a
	ld	hl,(_cty)
	ld	h,0
	inc	hl
	inc	hl
	inc	hl
	ld	h,0
	ld	a,l
	ld	(_cy1),a
	ld	hl,(_gpx)
	ld	h,0
	ld	a,l
	ld	(_cx2),a
	ld	hl,(_gpy)
	ld	h,0
	ld	a,l
	ld	(_cy2),a
	call	_collide_pixel
	ld	a,h
	or	l
	jp	z,i_244
	call	_destroy_cocos
	ld	hl,2 % 256	;const
	ld	a,l
	ld	(_p_killme),a
.i_244
.i_243
	ld a, (_coco_it)
	sla a
	ld c, a
	ld b, 0
	ld hl, _sp_cocos
	add hl, bc
	ld e, (hl)
	inc hl
	ld d, (hl)
	push de
	pop ix
	ld iy, vpClipStruct
	ld bc, 0
	ld a, (_cty)
	srl a
	srl a
	srl a
	add 0
	ld h, a
	ld a, (_ctx)
	srl a
	srl a
	srl a
	add 1
	ld l, a
	ld a, (_ctx)
	and 7
	ld d, a
	ld a, (_cty)
	and 7
	ld e, a
	call SPMoveSprAbs
	ld	de,_coco_x
	ld	hl,(_coco_it)
	ld	h,0
	add	hl,de
	push	hl
	ld	hl,_ctx
	ld	a,(hl)
	pop	de
	ld	(de),a
	ld	de,_coco_y
	ld	hl,(_coco_it)
	ld	h,0
	add	hl,de
	push	hl
	ld	hl,_cty
	ld	a,(hl)
	pop	de
	ld	(de),a
	ld	l,a
	ld	h,0
.i_239
	jp	i_236
.i_237
	ret



._enems_kill
	ld	hl,_en_an_n_f
	push	hl
	ld	hl,(_enit)
	ld	h,0
	add	hl,hl
	pop	de
	add	hl,de
	push	hl
	ld	hl,_sprite_17_a
	pop	de
	call	l_pint
	ld	a,(_killable)
	and	a
	jp	z,i_245
	ld	de,_en_an_state
	ld	hl,(_enit)
	ld	h,0
	add	hl,de
	ld	(hl),#(4 % 256 % 256)
	ld	de,_en_an_count
	ld	hl,(_enit)
	ld	h,0
	add	hl,de
	ld	(hl),#(12 % 256 % 256)
	ld	hl,2 % 256	;const
	call	_wyz_play_sound
	ld	a,(__en_t)
	ld	e,a
	ld	d,0
	ld	hl,128	;const
	call	l_or
	ld	h,0
	ld	a,l
	ld	(__en_t),a
	ld	hl,_p_killed
	ld	a,(hl)
	inc	(hl)
	ld	hl,45 % 256	;const
	push	hl
	call	_run_script
	pop	bc
.i_245
	ret



._enems_init
	ld	a,(_do_respawn)
	and	a
	jp	z,i_246
	ld	hl,0 % 256	;const
	ld	a,l
	ld	(_gpit),a
	jp	i_249
.i_247
	ld	hl,_gpit
	ld	a,(hl)
	inc	(hl)
.i_249
	ld	a,(_gpit)
	cp	#(3 % 256)
	jp	z,i_248
	jp	nc,i_248
	ld	de,_en_an_count
	ld	hl,(_gpit)
	ld	h,0
	add	hl,de
	ld	(hl),#(3 % 256 % 256)
	ld	de,_en_an_state
	ld	hl,(_gpit)
	ld	h,0
	add	hl,de
	ld	(hl),#(0 % 256 % 256)
	ld	hl,(_enoffs)
	ld	h,0
	ex	de,hl
	ld	hl,(_gpit)
	ld	h,0
	add	hl,de
	ld	h,0
	ld	a,l
	ld	(_enoffsmasi),a
	ld	hl,_baddies
	push	hl
	ld	hl,(_enoffsmasi)
	ld	h,0
	ld	b,h
	ld	c,l
	add	hl,hl
	add	hl,hl
	add	hl,bc
	add	hl,hl
	pop	de
	add	hl,de
	ld	bc,8
	add	hl,bc
	push	hl
	ld	a,(hl)
	and	#(127 % 256)
	pop	de
	ld	(de),a
	ld	de,_en_an_state
	ld	hl,(_gpit)
	ld	h,0
	add	hl,de
	ld	(hl),#(0 % 256 % 256)
	ld	hl,_baddies
	push	hl
	ld	hl,(_enoffsmasi)
	ld	h,0
	ld	b,h
	ld	c,l
	add	hl,hl
	add	hl,hl
	add	hl,bc
	add	hl,hl
	pop	de
	add	hl,de
	ld	bc,9
	add	hl,bc
	push	hl
	ld	hl,_level_data+6
	ld	a,(hl)
	pop	de
	ld	(de),a
	ld	hl,_baddies
	push	hl
	ld	hl,(_enoffsmasi)
	ld	h,0
	ld	b,h
	ld	c,l
	add	hl,hl
	add	hl,hl
	add	hl,bc
	add	hl,hl
	pop	de
	add	hl,de
	ld	bc,8
	add	hl,bc
	ld	l,(hl)
	ld	h,0
	ld	a,l
	ld	(__en_t),a
	ld	e,a
	ld	d,0
	ld	l,#(3 % 256)
	call	l_asr_u
	ld	h,0
	ld	a,l
	ld	(_gpt),a
	and	a
	jp	z,i_251
	ld	a,(_gpt)
	cp	#(16 % 256)
	jp	z,i_251
	jr	c,i_252_i_251
.i_251
	jp	i_250
.i_252_i_251
	ld	de,_en_an_base_frame
	ld	hl,(_gpit)
	ld	h,0
	add	hl,de
	push	hl
	ld	a,(__en_t)
	ld	e,a
	ld	d,0
	ld	hl,3	;const
	call	l_and
	add	hl,hl
	pop	de
	ld	a,l
	ld	(de),a
	ld	hl,(_gpt)
	ld	h,0
.i_255
	ld	a,l
	cp	#(2% 256)
	jp	nz,i_257
.i_256
	ld	hl,_en_an_x
	push	hl
	ld	hl,(_gpit)
	ld	h,0
	add	hl,hl
	pop	de
	add	hl,de
	push	hl
	ld	hl,_baddies
	push	hl
	ld	hl,(_enoffsmasi)
	ld	h,0
	ld	b,h
	ld	c,l
	add	hl,hl
	add	hl,hl
	add	hl,bc
	add	hl,hl
	pop	de
	add	hl,de
	inc	hl
	inc	hl
	ld	e,(hl)
	ld	d,0
	ld	l,#(4 % 256)
	call	l_asl
	pop	de
	call	l_pint
	ld	hl,_baddies
	push	hl
	ld	hl,(_enoffsmasi)
	ld	h,0
	ld	b,h
	ld	c,l
	add	hl,hl
	add	hl,hl
	add	hl,bc
	add	hl,hl
	pop	de
	add	hl,de
	push	hl
	ld	hl,_baddies
	push	hl
	ld	hl,(_enoffsmasi)
	ld	h,0
	ld	b,h
	ld	c,l
	add	hl,hl
	add	hl,hl
	add	hl,bc
	add	hl,hl
	pop	de
	add	hl,de
	inc	hl
	inc	hl
	ld	a,(hl)
	pop	de
	ld	(de),a
	ld	hl,_en_an_y
	push	hl
	ld	hl,(_gpit)
	ld	h,0
	add	hl,hl
	pop	de
	add	hl,de
	push	hl
	ld	hl,_baddies
	push	hl
	ld	hl,(_enoffsmasi)
	ld	h,0
	ld	b,h
	ld	c,l
	add	hl,hl
	add	hl,hl
	add	hl,bc
	add	hl,hl
	pop	de
	add	hl,de
	inc	hl
	inc	hl
	inc	hl
	ld	e,(hl)
	ld	d,0
	ld	l,#(4 % 256)
	call	l_asl
	pop	de
	call	l_pint
	ld	hl,_baddies
	push	hl
	ld	hl,(_enoffsmasi)
	ld	h,0
	ld	b,h
	ld	c,l
	add	hl,hl
	add	hl,hl
	add	hl,bc
	add	hl,hl
	pop	de
	add	hl,de
	inc	hl
	push	hl
	ld	hl,_baddies
	push	hl
	ld	hl,(_enoffsmasi)
	ld	h,0
	ld	b,h
	ld	c,l
	add	hl,hl
	add	hl,hl
	add	hl,bc
	add	hl,hl
	pop	de
	add	hl,de
	inc	hl
	inc	hl
	inc	hl
	ld	a,(hl)
	pop	de
	ld	(de),a
	ld	de,_en_an_vx
	ld	hl,(_gpit)
	ld	h,0
	add	hl,de
	push	hl
	ld	de,_en_an_vy
	ld	hl,(_gpit)
	ld	h,0
	add	hl,de
	push	hl
	ld	hl,0	;const
	ld	a,l
	call	l_sxt
	pop	de
	ld	a,l
	ld	(de),a
	ld	a,l
	call	l_sxt
	pop	de
	ld	a,l
	ld	(de),a
	ld	de,_en_an_state
	ld	hl,(_gpit)
	ld	h,0
	add	hl,de
	ld	(hl),#(0 % 256 % 256)
	ld	l,(hl)
	ld	h,0
.i_257
.i_254
.i_250
	jp	i_247
.i_248
.i_246
	ret



._enems_move_spr_abs
	; enter: IX = sprite structure address
	; IY = clipping rectangle, set it to "ClipStruct" for full screen
	; BC = animate bitdef displacement (0 for no animation)
	; H = new row coord in chars
	; L = new col coord in chars
	; D = new horizontal rotation (0..7) ie horizontal pixel position
	; E = new vertical rotation (0..7) ie vertical pixel position
	ld a, (_enit)
	sla a
	ld c, a
	ld b, 0
	ld hl, _sp_moviles
	add hl, bc
	ld e, (hl)
	inc hl
	ld d, (hl)
	push de
	pop ix
	ld iy, vpClipStruct
	ld hl, _en_an_c_f
	add hl, bc
	ld e, (hl)
	inc hl
	ld d, (hl)
	ld hl, _en_an_n_f
	add hl, bc
	ld a, (hl)
	inc hl
	ld h, (hl)
	ld l, a
	or a
	sbc hl, de
	push bc
	ld b, h
	ld c, l
	ld a, (__en_y)
	srl a
	srl a
	srl a
	add 0
	ld h, a
	ld a, (__en_x)
	srl a
	srl a
	srl a
	add 1
	ld l, a
	ld a, (__en_x)
	and 7
	ld d, a
	ld a, (__en_y)
	and 7
	ld e, a
	call SPMoveSprAbs
	pop bc
	ld hl, _en_an_c_f
	add hl, bc
	ex de, hl
	ld hl, _en_an_n_f
	add hl, bc
	ldi
	ldi
	ret



._enems_move
	ld	hl,0	;const
	ld	a,l
	call	l_sxt
	ld	a,l
	ld	(_ptgmx),a
	ld	a,l
	call	l_sxt
	ld	a,l
	ld	(_ptgmy),a
	ld	h,0
	ld	a,l
	ld	(_p_gotten),a
	ld	a,#(0 % 256 % 256)
	ld	(_tocado),a
	ld	hl,0 % 256	;const
	ld	a,l
	ld	(_enit),a
	jp	i_260
.i_258
	ld	hl,(_enit)
	ld	h,0
	inc	hl
	ld	a,l
	ld	(_enit),a
.i_260
	ld	a,(_enit)
	cp	#(3 % 256)
	jp	z,i_259
	jp	nc,i_259
	ld	hl,0 % 256	;const
	ld	a,l
	ld	(_animate),a
	ld	h,0
	ld	a,l
	ld	(_killable),a
	ld	h,0
	ld	a,l
	ld	(_active),a
	ld	hl,(_enoffs)
	ld	h,0
	ex	de,hl
	ld	hl,(_enit)
	ld	h,0
	add	hl,de
	ld	h,0
	ld	a,l
	ld	(_enoffsmasi),a
	ld hl, (_enoffsmasi)
	ld h, 0
	add hl, hl
	ld d, h
	ld e, l
	add hl, hl
	add hl, hl
	add hl, de
	ld de, _baddies
	add hl, de
	ld (__baddies_pointer), hl
	ld a, (hl)
	ld (__en_x), a
	inc hl
	ld a, (hl)
	ld (__en_y), a
	inc hl
	ld a, (hl)
	ld (__en_x1), a
	inc hl
	ld a, (hl)
	ld (__en_y1), a
	inc hl
	ld a, (hl)
	ld (__en_x2), a
	inc hl
	ld a, (hl)
	ld (__en_y2), a
	inc hl
	ld a, (hl)
	ld (__en_mx), a
	inc hl
	ld a, (hl)
	ld (__en_my), a
	inc hl
	ld a, (hl)
	ld (__en_t), a
	inc hl
	ld a, (hl)
	ld (__en_life), a
	ld	a,(__en_t)
	and	a
	jp	nz,i_261
	ld	hl,_en_an_n_f
	push	hl
	ld	hl,(_enit)
	ld	h,0
	add	hl,hl
	pop	de
	add	hl,de
	push	hl
	ld	hl,_sprite_18_a
	pop	de
	call	l_pint
	jp	i_262
.i_261
	ld	de,_en_an_state
	ld	hl,(_enit)
	ld	h,0
	add	hl,de
	ld	a,(hl)
	cp	#(4 % 256)
	jp	nz,i_263
	ld	de,_en_an_count
	ld	hl,(_enit)
	ld	h,0
	add	hl,de
	ld	a,(hl)
	and	a
	jp	z,i_264
	ld	de,_en_an_count
	ld	hl,(_enit)
	ld	h,0
	add	hl,de
	dec	(hl)
	ld	hl,_en_an_n_f
	push	hl
	ld	hl,(_enit)
	ld	h,0
	add	hl,hl
	pop	de
	add	hl,de
	push	hl
	ld	hl,_sprite_17_a
	pop	de
	call	l_pint
	jp	i_265
.i_264
	ld	de,_en_an_state
	ld	hl,(_enit)
	ld	h,0
	add	hl,de
	ld	(hl),#(0 % 256 % 256)
	ld	hl,_en_an_n_f
	push	hl
	ld	hl,(_enit)
	ld	h,0
	add	hl,hl
	pop	de
	add	hl,de
	push	hl
	ld	hl,_sprite_18_a
	pop	de
	call	l_pint
.i_265
	jp	i_266
.i_263
	ld	hl,__en_t
	ld	a,(hl)
	and	#(4 % 256)
	jp	z,i_267
	ld	hl,1 % 256	;const
	ld	a,l
	ld	(_enemy_shoots),a
	jp	i_268
.i_267
	ld	hl,0 % 256	;const
	ld	a,l
	ld	(_enemy_shoots),a
.i_268
	ld	a,(__en_t)
	ld	e,a
	ld	d,0
	ld	l,#(3 % 256)
	call	l_asr_u
	ld	h,0
	ld	a,l
	ld	(_gpt),a
	ld	e,a
	ld	d,0
	ld	hl,8	;const
	call	l_eq
	jp	nc,i_269
	ld a, (__en_x)
	ld c, a
	ld a, (_gpx)
	add 12
	cp c
	jp c, _enems_move_pregotten_not
	ld a, (_gpx)
	ld c, a
	ld a, (__en_x)
	add 12
	cp c
	jp c, _enems_move_pregotten_not
	ld a, 1
	jr _enems_move_pregotten_set
	._enems_move_pregotten_not
	xor a
	._enems_move_pregotten_set
	ld (_pregotten), a
.i_269
	ld	hl,(_gpt)
	ld	h,0
.i_272
	ld	a,l
	cp	#(1% 256)
	jp	z,i_273
	cp	#(8% 256)
	jp	z,i_274
	cp	#(2% 256)
	jp	z,i_278
	cp	#(9% 256)
	jp	z,i_279
	cp	#(10% 256)
	jp	z,i_287
	jp	i_299
.i_273
	ld	hl,1 % 256	;const
	ld	a,l
	ld	(_killable),a
.i_274
	ld a, 1
	ld (_active), a
	ld (_animate), a
	ld a, (__en_mx)
	ld c, a
	ld a, (__en_x)
	add a, c
	ld (__en_x), a
	ld c, a
	ld a, (__en_x1)
	cp c
	jr z, _enems_lm_change_axis_x
	ld a, (__en_x2)
	cp c
	jr nz, _enems_lm_change_axis_x_done
	._enems_lm_change_axis_x
	ld a, (__en_mx)
	neg
	ld (__en_mx), a
	._enems_lm_change_axis_x_done
	ld a, (__en_my)
	ld c, a
	ld a, (__en_y)
	add a, c
	ld (__en_y), a
	ld c, a
	ld a, (__en_y1)
	cp c
	jr z, _enems_lm_change_axis_y
	ld a, (__en_y2)
	cp c
	jr nz, _enems_lm_change_axis_y_done
	._enems_lm_change_axis_y
	ld a, (__en_my)
	neg
	ld (__en_my), a
	._enems_lm_change_axis_y_done
	ld	hl,(_enemy_shoots)
	ld	h,0
	ld	a,h
	or	l
	jp	z,i_276
	call	_rand
	ld	de,49	;const
	ex	de,hl
	call	l_and
	dec	hl
	ld	a,h	
	or	l
	jp	nz,i_276
	inc	hl
	jr	i_277
.i_276
	ld	hl,0	;const
.i_277
	ld	a,h
	or	l
	call	nz,_shoot_coco
.i_275
	jp	i_271
.i_278
	ld a, 1
	ld (_active), a
	ld (_killable), a
	ld (_animate), a
	ld bc, (_enit)
	ld b, 0
	ld hl, _en_an_vx
	add hl, bc
	ld a, (hl)
	ld (__en_an_vx), a
	ld hl, _en_an_vy
	add hl, bc
	ld a, (hl)
	ld (__en_an_vy), a
	ld hl, _en_an_x
	add hl, bc
	add hl, bc
	ld e, (hl)
	inc hl
	ld d, (hl)
	ld (__en_an_x), de
	ld hl, _en_an_y
	add hl, bc
	add hl, bc
	ld e, (hl)
	inc hl
	ld d, (hl)
	ld (__en_an_y), de
	ld a, (_gpx)
	ld (_cx1), a
	ld a, (_gpy)
	ld (_cy1), a
	ld a, (__en_x)
	ld (_cx2), a
	ld a, (__en_y)
	ld (_cy2), a
	call _distance
	ld a, l
	ld (_rda), a
	ld bc, (_enit)
	ld b, 0
	ld hl, _en_an_state
	add hl, bc
	ld a, (hl)
	ld (_rdb), a
	cp 1
	jp z, _move_fanty_pursuing
	cp 2
	jp z, _move_fanty_retreating
	._move_fanty_idle
	ld a, (_rda)
	cp 96
	jp nc, _move_fanty_state_done
	ld a, 1
	ld (_rdb), a
	jp _move_fanty_state_done
	._move_fanty_pursuing
	ld a, (_rda)
	cp 96
	jr c, _move_fanty_pursuing_do
	ld a, 2
	ld (_rdb), a
	jp _move_fanty_state_done
	._move_fanty_pursuing_do
	ld a, (__en_x)
	ld c, a
	ld a, (_gpx)
	cp c
	jr nc, _move_fanty_ax_pos
	._move_fanty_ax_neg
	ld a, -4
	jr _move_fanty_ax_set
	._move_fanty_ax_pos
	ld a, 4
	._move_fanty_ax_set
	ld c, a
	ld a, (__en_an_vx)
	add c
	bit 7, a
	jr nz, _move_fanty_vx_limit_neg
	._move_fanty_vx_limit_pos
	cp 32
	jr c, _move_fanty_vx_limit_set
	ld a, 32
	jr _move_fanty_vx_limit_set
	._move_fanty_vx_limit_neg
	neg a
	cp 32
	jr c, _move_fanty_vx_limit_neg_ok
	ld a, -32
	jr _move_fanty_vx_limit_set
	._move_fanty_vx_limit_neg_ok
	neg a
	._move_fanty_vx_limit_set
	ld (__en_an_vx), a
	ld hl, (__en_an_x)
	ld c, a
	add a, a
	sbc a
	ld b, a
	add hl, bc
	bit 7, h
	jr z, _move_fanty_x_limit_0
	ld hl, 0
	jr _move_fanty_x_set
	._move_fanty_x_limit_0
	ld bc, 3584
	or a
	sbc hl, bc
	add hl, bc
	jr c, _move_fanty_x_set
	._move_fanty_x_limit_224
	ld hl, 3584
	._move_fanty_x_set
	ld (__en_an_x), hl
	ld a, (__en_y)
	ld c, a
	ld a, (_gpy)
	cp c
	jr nc, _move_fanty_ay_pos
	._move_fanty_ay_neg
	ld a, -4
	jr _move_fanty_ay_set
	._move_fanty_ay_pos
	ld a, 4
	._move_fanty_ay_set
	ld c, a
	ld a, (__en_an_vy)
	add c
	bit 7, a
	jr nz, _move_fanty_vy_limit_neg
	._move_fanty_vy_limit_pos
	cp 32
	jr c, _move_fanty_vy_limit_set
	ld a, 32
	jr _move_fanty_vy_limit_set
	._move_fanty_vy_limit_neg
	neg a
	cp 32
	jr c, _move_fanty_vy_limit_neg_ok
	ld a, -32
	jr _move_fanty_vy_limit_set
	._move_fanty_vy_limit_neg_ok
	neg a
	._move_fanty_vy_limit_set
	ld (__en_an_vy), a
	ld hl, (__en_an_y)
	ld c, a
	add a, a
	sbc a
	ld b, a
	add hl, bc
	bit 7, h
	jr z, _move_fanty_y_limit_0
	ld hl, 0
	jr _move_fanty_y_set
	._move_fanty_y_limit_0
	ld bc, 2304
	or a
	sbc hl, bc
	add hl, bc
	jr c, _move_fanty_y_set
	._move_fanty_y_limit_144
	ld hl, 2304
	._move_fanty_y_set
	ld (__en_an_y), hl
	jp _move_fanty_state_done
	._move_fanty_retreating
	xor a
	ld (__en_an_vx), a
	ld (__en_an_vy), a
	ld hl, (__en_an_x)
	ld de, 16
	ld a, (__en_x1)
	ld c, a
	ld a, (__en_x)
	cp c
	jr z, _move_fanty_r_x_done
	jr nc, _move_fanty_r_x_neg
	._move_fanty_r_x_pos
	add hl, de
	jr _move_fanty_r_x_set
	._move_fanty_r_x_neg
	or a
	sbc hl, de
	._move_fanty_r_x_set
	ld (__en_an_x), hl
	._move_fanty_r_x_done
	ld hl, (__en_an_y)
	ld de, 16
	ld a, (__en_y1)
	ld c, a
	ld a, (__en_y)
	cp c
	jr z, _move_fanty_r_y_done
	jr nc, _move_fanty_r_y_neg
	._move_fanty_r_y_pos
	add hl, de
	jr _move_fanty_r_y_set
	._move_fanty_r_y_neg
	or a
	sbc hl, de
	._move_fanty_r_y_set
	ld (__en_an_y), hl
	._move_fanty_r_y_done
	ld a, (__en_x1)
	ld c, a
	ld a, (__en_x)
	cp c
	jr nz, _move_fanty_r_chstate_done
	ld a, (__en_y1)
	ld c, a
	ld a, (__en_y)
	cp c
	jr nz, _move_fanty_r_chstate_done
	ld a, 0
	ld (_rdb), a
	jr _move_fanty_state_done
	._move_fanty_r_chstate_done
	ld a, (_rda)
	cp 96
	jr nc, _move_fanty_state_done
	ld a, 1
	ld (_rdb), a
	._move_fanty_state_done
	ld bc, (_enit)
	ld b, 0
	ld hl, _en_an_state
	add hl, bc
	ld a, (_rdb)
	ld (hl), a
	ld	hl,(__en_an_x)
	ex	de,hl
	ld	l,#(4 % 256)
	call	l_asr
	ld	h,0
	ld	a,l
	ld	(__en_x),a
	ld	hl,(__en_an_y)
	ex	de,hl
	ld	l,#(4 % 256)
	call	l_asr
	ld	h,0
	ld	a,l
	ld	(__en_y),a
	ld bc, (_enit)
	ld b, 0
	ld hl, _en_an_vx
	add hl, bc
	ld a, (__en_an_vx)
	ld (hl), a
	ld hl, _en_an_vy
	add hl, bc
	ld a, (__en_an_vy)
	ld (hl), a
	ld hl, _en_an_x
	add hl, bc
	add hl, bc
	ld de, (__en_an_x)
	ld (hl), e
	inc hl
	ld (hl), d
	ld hl, _en_an_y
	add hl, bc
	add hl, bc
	ld de, (__en_an_y)
	ld (hl), e
	inc hl
	ld (hl), d
	jp	i_271
.i_279
	ld	hl,__en_mx
	call	l_gchar
	ld	a,h
	or	l
	jp	z,i_280
	ld	hl,_en_an_n_f
	push	hl
	ld	hl,(_gpit)
	ld	h,0
	add	hl,hl
	pop	de
	add	hl,de
	push	hl
	ld	hl,_drop_sprites
	push	hl
	ld	hl,__en_mx
	call	l_gchar
	ex	de,hl
	ld	l,#(7 % 256)
	call	l_asl
	pop	de
	add	hl,de
	push	hl
	ld	hl,__en_mx
	call	l_gchar
	ex	de,hl
	ld	l,#(4 % 256)
	call	l_asl
	pop	de
	add	hl,de
	pop	de
	call	l_pint
	ld	hl,(__en_x2)
	ld	h,0
	inc	hl
	ld	de,3	;const
	ex	de,hl
	call	l_and
	ld	h,0
	ld	a,l
	ld	(__en_x2),a
	and	a
	jp	nz,i_281
	ld	hl,__en_mx
	call	l_gchar
	inc	hl
	ld	de,3	;const
	ex	de,hl
	call	l_and
	ld	a,l
	call	l_sxt
	ld	a,l
	ld	(__en_mx),a
	ld	hl,__en_mx
	call	l_gchar
	ld	a,h
	or	l
	jp	nz,i_282
.i_282
.i_281
	jp	i_283
.i_280
	ld	a,(__en_x2)
	and	a
	jp	nz,i_284
	ld	hl,(__en_y1)
	ld	h,0
	ld	a,l
	ld	(__en_y),a
	ld	hl,1 % 256	;const
	ld	a,l
	ld	(__en_x2),a
.i_284
	ld	hl,_en_an_n_f
	push	hl
	ld	hl,(_gpit)
	ld	h,0
	add	hl,hl
	pop	de
	add	hl,de
	push	hl
	ld	hl,_drop_sprites
	pop	de
	call	l_pint
	ld	hl,(__en_y)
	ld	h,0
	push	hl
	ld	hl,__en_my
	call	l_gchar
	pop	de
	add	hl,de
	ld	h,0
	ld	a,l
	ld	(__en_y),a
	ld	hl,__en_y
	ld	a,(hl)
	and	#(15 % 256)
	jp	nz,i_285
	ld	a,(__en_x)
	ld	e,a
	ld	d,0
	ld	l,#(4 % 256)
	call	l_asr_u
	ld	h,0
	ld	a,l
	ld	(_cx1),a
	ld	hl,(__en_y)
	ld	h,0
	ld	bc,15
	add	hl,bc
	ex	de,hl
	ld	l,#(4 % 256)
	call	l_asr_u
	ld	h,0
	ld	a,l
	ld	(_cy1),a
	call	_attr
	ld	de,12	;const
	ex	de,hl
	call	l_and
	ld	a,h
	or	l
	jp	z,i_286
	ld	a,#(1 % 256)
	ld	(__en_mx),a
	ld	a,#(0 % 256 % 256)
	ld	(__en_x2),a
	ld	hl,16 % 256	;const
	call	_wyz_play_sound
.i_286
.i_285
.i_283
	ld	hl,1 % 256	;const
	ld	a,l
	ld	(_active),a
	jp	i_271
.i_287
	ld	a,#(0 % 256 % 256)
	ld	(__en_y2),a
	ld	hl,__en_my
	call	l_gchar
	ld	a,h
	or	l
	jp	z,i_288
	ld	hl,(__en_x)
	ld	h,0
	push	hl
	ld	hl,__en_mx
	call	l_gchar
	pop	de
	add	hl,de
	ld	h,0
	ld	a,l
	ld	(__en_x),a
	ld	hl,_en_an_n_f
	push	hl
	ld	hl,(_gpit)
	ld	h,0
	add	hl,hl
	pop	de
	add	hl,de
	push	hl
	ld	hl,_arrow_sprites
	push	hl
	ld	hl,__en_mx
	call	l_gchar
	ld	de,0	;const
	ex	de,hl
	call	l_lt
	jp	nc,i_289
	ld	hl,0	;const
	jp	i_290
.i_289
	ld	hl,144	;const
.i_290
	pop	de
	add	hl,de
	pop	de
	call	l_pint
	ld	hl,(__en_x)
	ld	h,0
	ex	de,hl
	ld	hl,(__en_x2)
	ld	h,0
	call	l_eq
	jp	nc,i_291
	ld	hl,0	;const
	ld	a,l
	call	l_sxt
	ld	a,l
	ld	(__en_my),a
.i_291
	jp	i_292
.i_288
	ld	hl,_en_an_n_f
	push	hl
	ld	hl,(_gpit)
	ld	h,0
	add	hl,hl
	pop	de
	add	hl,de
	push	hl
	ld	hl,_sprite_18_a
	pop	de
	call	l_pint
	ld	hl,(_enemy_shoots)
	ld	h,0
	ld	de,0
	call	l_eq
	jp	c,i_294
	ld	hl,(_gpy)
	ld	h,0
	push	hl
	ld	hl,(__en_y1)
	ld	h,0
	push	hl
	ld	hl,(__en_y1)
	ld	h,0
	push	hl
	ld	hl,15 % 256	;const
	push	hl
	push	hl
	call	_addons_between
	pop	bc
	pop	bc
	pop	bc
	pop	bc
	pop	bc
	ld	a,h
	or	l
	jp	z,i_295
	ld	hl,(_gpx)
	ld	h,0
	push	hl
	ld	hl,(__en_x1)
	ld	h,0
	push	hl
	ld	hl,(__en_x2)
	ld	h,0
	push	hl
	ld	hl,15 % 256	;const
	push	hl
	ld	hl,31 % 256	;const
	push	hl
	call	_addons_between
	pop	bc
	pop	bc
	pop	bc
	pop	bc
	pop	bc
	ld	a,h
	or	l
	jp	z,i_295
	ld	hl,1	;const
	jr	i_296
.i_295
	ld	hl,0	;const
.i_296
	ld	a,h
	or	l
	jp	nz,i_294
	jr	i_297
.i_294
	ld	hl,1	;const
.i_297
	ld	a,h
	or	l
	jp	z,i_293
	ld	hl,1 % 256	;const
	ld	a,l
	ld	(__en_y2),a
.i_293
.i_292
	ld	a,(__en_y2)
	and	a
	jp	z,i_298
	ld	a,#(1 % 256)
	ld	(__en_my),a
	ld	hl,(__en_x1)
	ld	h,0
	ld	a,l
	ld	(__en_x),a
	ld	hl,7 % 256	;const
	call	_wyz_play_sound
.i_298
	ld	hl,1 % 256	;const
	ld	a,l
	ld	(_active),a
	jp	i_271
.i_299
	ld	hl,_en_an_n_f
	push	hl
	ld	hl,(_enit)
	ld	h,0
	add	hl,hl
	pop	de
	add	hl,de
	push	hl
	ld	hl,_sprite_18_a
	pop	de
	call	l_pint
.i_271
	ld	a,(_active)
	and	a
	jp	z,i_300
	ld	a,(_animate)
	and	a
	jp	z,i_301
	ld	hl,__en_mx
	call	l_gchar
	ld	a,h
	or	l
	jp	z,i_302
	ld	hl,(__en_x)
	ld	h,0
	ld	bc,4
	add	hl,bc
	ex	de,hl
	ld	l,#(3 % 256)
	call	l_asr_u
	ld	de,1	;const
	ex	de,hl
	call	l_and
	jp	i_303
.i_302
	ld	hl,(__en_y)
	ld	h,0
	ld	bc,4
	add	hl,bc
	ex	de,hl
	ld	l,#(3 % 256)
	call	l_asr_u
	ld	de,1	;const
	ex	de,hl
	call	l_and
.i_303
	ld	h,0
	ld	a,l
	ld	(_gpjt),a
	ld	hl,_en_an_n_f
	push	hl
	ld	hl,(_enit)
	ld	h,0
	add	hl,hl
	pop	de
	add	hl,de
	push	hl
	ld	hl,_enem_frames
	push	hl
	ld	de,_en_an_base_frame
	ld	hl,(_enit)
	ld	h,0
	add	hl,de
	ld	e,(hl)
	ld	d,0
	ld	hl,(_gpjt)
	ld	h,0
	add	hl,de
	add	hl,hl
	pop	de
	add	hl,de
	call	l_gint	;
	pop	de
	call	l_pint
.i_301
	ld	a,(_gpt)
	cp	#(8 % 256)
	jp	z,i_304
	ld	hl,0 % 256	;const
	ld	a,l
	ld	(_gpjt),a
	jp	i_307
.i_305
	ld	hl,_gpjt
	ld	a,(hl)
	inc	(hl)
.i_307
	ld	a,(_gpjt)
	cp	#(1 % 256)
	jp	z,i_306
	jp	nc,i_306
	ld	de,_bullets_estado
	ld	hl,(_gpjt)
	ld	h,0
	add	hl,de
	ld	a,(hl)
	cp	#(1 % 256)
	jp	nz,i_308
	ld	de,_bullets_x
	ld	hl,(_gpjt)
	ld	h,0
	add	hl,de
	ld	l,(hl)
	ld	h,0
	inc	hl
	inc	hl
	inc	hl
	ld	h,0
	ld	a,l
	ld	(_cx1),a
	ld	de,_bullets_y
	ld	hl,(_gpjt)
	ld	h,0
	add	hl,de
	ld	l,(hl)
	ld	h,0
	inc	hl
	inc	hl
	inc	hl
	ld	h,0
	ld	a,l
	ld	(_cy1),a
	ld	hl,(__en_x)
	ld	h,0
	ld	a,l
	ld	(_cx2),a
	ld	hl,(__en_y)
	ld	h,0
	ld	a,l
	ld	(_cy2),a
	call	_collide_pixel
	ld	a,h
	or	l
	jp	z,i_309
	ld	de,_bullets_estado
	ld	hl,(_gpjt)
	ld	h,0
	add	hl,de
	ld	(hl),#(0 % 256 % 256)
	ld	hl,1 % 256	;const
	push	hl
	call	_enems_kill
	pop	bc
	jp	i_310
.i_309
.i_308
	jp	i_305
.i_306
.i_304
	ld a, (_gpt)
	cp 8
	jp nz, _enems_platforms_done
	ld a, (_p_jmp_on)
	or a
	jp nz, _enems_collision_skip
	ld a, (_pregotten)
	or a
	jp z, _enems_collision_skip
	ld a, (_p_gotten)
	or a
	jp nz, _enems_collision_skip
	ld a, (__en_mx)
	or a
	jr z, _enems_plats_horz_done
	ld a, (__en_y)
	ld c, a
	ld a, (_gpy)
	add 16
	cp c
	jr c, _enems_plats_horz_done
	ld a, (_gpy)
	add 10
	ld c, a
	ld a, (__en_y)
	cp c
	jr c, _enems_plats_horz_done
	._enems_plats_horz_do
	ld a, 1
	ld (_p_gotten), a
	ld a, (__en_mx)
	sla a
	sla a
	sla a
	sla a ; times 4
	ld (_ptgmx), a
	jr _enems_plats_gpy_set
	._enems_plats_horz_done
	._enems_plats_vert_check_1
	ld a, (_gpy)
	add 10
	ld c, a
	ld a, (__en_y)
	cp c
	jr c, _enems_plats_vert_done
	ld a, (__en_my)
	bit 7, a
	jr z, _enems_plats_vert_check_2 ; _en_my is positive
	ld a, (__en_y)
	ld c, a
	ld a, (_gpy)
	add 17
	cp c
	jr nc, _enems_plats_vert_do
	._enems_plats_vert_check_2
	ld a, (__en_y)
	ld c, a
	ld a, (__en_my)
	ld b, a
	ld a, (_gpy)
	add 17
	add b
	cp c
	jr c, _enems_plats_vert_done
	._enems_plats_vert_do
	ld a, 1
	ld (_p_gotten), a
	ld a, (__en_my)
	sla a
	sla a
	sla a
	sla a ; times 4
	ld (_ptgmy), a
	xor a
	ld (_p_vy), a
	._enems_plats_gpy_set
	ld a, (__en_y)
	sub 16
	ld (_gpy), a
	ld d, 0
	ld e, a
	ld l, 4
	call l_asl
	ld (_p_y), hl
	._enems_plats_vert_done
	jp _enems_collision_skip
	._enems_platforms_done
	ld a, (_tocado)
	or a
	jp nz, _enems_collision_skip
	ld a, (_p_state)
	or a
	jp nz, _enems_collision_skip
	ld a, (__en_x)
	ld c, a
	ld a, (_gpx)
	add 12
	cp c
	jp c, _enems_collision_skip
	ld a, (_gpx)
	ld c, a
	ld a, (__en_x)
	add 12
	cp c
	jp c, _enems_collision_skip
	ld a, (__en_y)
	ld c, a
	ld a, (_gpy)
	add 12
	cp c
	jp c, _enems_collision_skip
	ld a, (_gpy)
	ld c, a
	ld a, (__en_y)
	add 12
	cp c
	jp c, _enems_collision_skip
	ld	a,(_p_life)
	and	a
	jp	z,i_311
	ld	hl,1 % 256	;const
	ld	a,l
	ld	(_tocado),a
.i_311
	ld	a,(_lasttimehit)
	cp	#(0 % 256)
	jp	z,i_313
	ld	a,(_maincounter)
	ld	e,a
	ld	d,0
	ld	hl,3	;const
	call	l_and
	ld	de,0	;const
	ex	de,hl
	call	l_eq
	jp	nc,i_312
.i_313
	ld	hl,2 % 256	;const
	ld	a,l
	ld	(_p_killme),a
.i_312
	ld	a,(_gpt)
	cp	#(2 % 256)
	jp	nz,i_315
	ld	hl,1 % 256	;const
	push	hl
	call	_enems_kill
	pop	bc
.i_315
	ld	hl,__en_mx
	call	l_gchar
	push	hl
	ld	hl,96	;const
	push	hl
	call	_addsign
	pop	bc
	pop	bc
	ld	a,l
	call	l_sxt
	ld	a,l
	ld	(_p_vx),a
	ld	hl,__en_my
	call	l_gchar
	push	hl
	ld	hl,96	;const
	push	hl
	call	_addsign
	pop	bc
	pop	bc
	ld	a,l
	call	l_sxt
	ld	a,l
	ld	(_p_vy),a
	._enems_collision_skip
.i_300
.i_266
.i_262
.i_310
.i_316
	.enems_loop_continue_a
	call	_enems_move_spr_abs
	ld hl, (__baddies_pointer)
	ld a, (__en_x)
	ld (hl), a
	inc hl
	ld a, (__en_y)
	ld (hl), a
	inc hl
	ld a, (__en_x1)
	ld (hl), a
	inc hl
	ld a, (__en_y1)
	ld (hl), a
	inc hl
	ld a, (__en_x2)
	ld (hl), a
	inc hl
	ld a, (__en_y2)
	ld (hl), a
	inc hl
	ld a, (__en_mx)
	ld (hl), a
	inc hl
	ld a, (__en_my)
	ld (hl), a
	inc hl
	ld a, (__en_t)
	ld (hl), a
	inc hl
	ld a, (__en_life)
	ld (hl), a
	jp	i_258
.i_259
	ld	hl,(_tocado)
	ld	h,0
	ld	a,l
	ld	(_lasttimehit),a
	ret



._advance_worm
	ld bc, (_gpit)
	ld b, 0
	ld de, (_gpt)
	ld d, 0
	ld hl, _behs
	add hl, de
	ld a, (hl)
	ld hl, _map_attr
	add hl, bc
	ld (hl), a
	ld a, (_gpd)
	ld hl, _map_buff
	add hl, bc
	ld (hl), a
	ld (__t), a
	call _draw_coloured_tile
	ld a, (__x)
	add 2
	cp 30 + 1
	jr c, _advance_worm_no_inc_y
	ld a, (__y)
	add 2
	ld (__y), a
	ld a, 1
	._advance_worm_no_inc_y
	ld (__x), a
	ld hl, _gpit
	inc (hl)
	ret



._draw_scr_background
	ld	de,_seed1
	ld	hl,(_n_pant)
	ld	h,0
	call	l_pint
	ld	de,_seed2
	ld	hl,(_level)
	ld	h,0
	call	l_pint
	call	_srand
	ld	hl,_map
	push	hl
	ld	a,(_n_pant)
	ld	e,a
	ld	d,0
	ld	l,#(6 % 256)
	call	l_asl
	pop	de
	add	hl,de
	push	hl
	ld	a,(_n_pant)
	ld	e,a
	ld	d,0
	ld	l,#(3 % 256)
	call	l_asl
	pop	de
	add	hl,de
	push	hl
	ld	a,(_n_pant)
	ld	e,a
	ld	d,0
	ld	l,#(1 % 256)
	call	l_asl
	pop	de
	add	hl,de
	ex	de,hl
	ld	hl,(_n_pant)
	ld	h,0
	add	hl,de
	ld	(_map_pointer),hl
	._draw_scr_packed_unpacked
	ld a, 1
	ld (__x), a
	ld a, 0
	ld (__y), a
	xor a
	ld (_gpit), a
	._draw_scr_background_loop
	and 1
	jr z, draw_scr_background_new_byte
	ld a, (_gpc)
	and 15
	jr draw_scr_background_set_t
	.draw_scr_background_new_byte
	ld hl, (_map_pointer)
	ld a, (hl)
	inc hl
	ld (_map_pointer), hl
	ld (_gpc), a
	srl a
	srl a
	srl a
	srl a
	.draw_scr_background_set_t
	ld (_gpt), a
	ld (_gpd), a
	call _advance_worm
	ld a, (_gpit)
	cp 150
	jr nz, _draw_scr_background_loop
	ret



._draw_scr
	ld	a,#(1 % 256 % 256)
	ld	(_is_rendering),a
	ld	a,(_no_draw)
	and	a
	jp	z,i_317
	ld	hl,0 % 256	;const
	ld	a,l
	ld	(_no_draw),a
	jp	i_318
.i_317
	call	_draw_scr_background
.i_318
	ld	hl,(_n_pant)
	ld	h,0
	ld	b,h
	ld	c,l
	add	hl,bc
	add	hl,bc
	ld	h,0
	ld	a,l
	ld	(_enoffs),a
	call	_enems_init
	ld	hl,1 % 256	;const
	ld	a,l
	ld	(_do_respawn),a
	call	_run_entering_script
	call	_init_bullets
	call	_init_cocos
	ld	hl,(_n_pant)
	ld	h,0
	ex	de,hl
	ld	hl,(_level_data)
	ld	h,0
	call	l_div_u
	ex	de,hl
	ld	h,0
	ld	a,l
	ld	(_x_pant),a
	ld	hl,(_n_pant)
	ld	h,0
	ex	de,hl
	ld	hl,(_level_data)
	ld	h,0
	call	l_div_u
	ld	h,0
	ld	a,l
	ld	(_y_pant),a
	call	_invalidate_viewport
	ld	hl,0 % 256	;const
	ld	a,l
	ld	(_is_rendering),a
	ret



._update_hud
	ld	hl,(_p_life)
	ld	h,0
	ex	de,hl
	ld	hl,(_life_old)
	ld	h,0
	call	l_ne
	jp	nc,i_319
	ld	a,#(1 % 256 % 256)
	ld	(__x),a
	ld	a,#(23 % 256 % 256)
	ld	(__y),a
	ld	hl,(_p_life)
	ld	h,0
	ld	a,l
	ld	(__t),a
	call	_print_number2
	ld	hl,(_p_life)
	ld	h,0
	ld	a,l
	ld	(_life_old),a
.i_319
	ld	hl,(_flags+13)
	ld	h,0
	ex	de,hl
	ld	hl,(_flag_old)
	ld	h,0
	call	l_ne
	jp	nc,i_320
	ld	a,#(4 % 256 % 256)
	ld	(__x),a
	ld	a,#(23 % 256 % 256)
	ld	(__y),a
	ld	hl,(_flags+13)
	ld	h,0
	ld	a,l
	ld	(__t),a
	call	_print_number2
	ld	hl,(_flags+13)
	ld	h,0
	ld	a,l
	ld	(_flag_old),a
.i_320
	ret



._flick_screen
	ld	a,(_gpx)
	cp	#(0 % 256)
	jp	nz,i_322
	ld	hl,_p_vx
	call	l_gchar
	ld	de,0	;const
	ex	de,hl
	call	l_lt
	jp	nc,i_322
	ld	a,(_x_pant)
	cp	#(0 % 256)
	jp	z,i_322
	jp	c,i_322
	jr	i_323_i_322
.i_322
	jp	i_321
.i_323_i_322
	ld	hl,(_n_pant)
	ld	h,0
	dec	hl
	ld	h,0
	ld	a,l
	ld	(_n_pant),a
	ld	hl,3584	;const
	ld	(_p_x),hl
	ld	hl,224 % 256	;const
	ld	a,l
	ld	(_gpx),a
	jp	i_324
.i_321
	ld	a,(_gpx)
	cp	#(224 % 256)
	jp	nz,i_326
	ld	hl,_p_vx
	call	l_gchar
	ld	de,0	;const
	ex	de,hl
	call	l_gt
	jp	nc,i_326
	ld	hl,(_x_pant)
	ld	h,0
	push	hl
	ld	hl,(_level_data)
	ld	h,0
	dec	hl
	pop	de
	call	l_ult
	jr	c,i_327_i_326
.i_326
	jp	i_325
.i_327_i_326
	ld	hl,(_n_pant)
	ld	h,0
	inc	hl
	ld	h,0
	ld	a,l
	ld	(_n_pant),a
	ld	hl,0 % 256	;const
	ld	a,l
	ld	(_gpx),a
	ld	(_p_x),hl
.i_325
.i_324
	ld	a,(_gpy)
	cp	#(0 % 256)
	jp	nz,i_329
	ld	hl,_p_vy
	call	l_gchar
	ld	de,0	;const
	ex	de,hl
	call	l_lt
	jp	nc,i_329
	ld	a,(_y_pant)
	cp	#(0 % 256)
	jp	z,i_329
	jp	c,i_329
	jr	i_330_i_329
.i_329
	jp	i_328
.i_330_i_329
	ld	hl,(_n_pant)
	ld	h,0
	ex	de,hl
	ld	hl,(_level_data)
	ld	h,0
	ex	de,hl
	and	a
	sbc	hl,de
	ld	h,0
	ld	a,l
	ld	(_n_pant),a
	ld	hl,2304	;const
	ld	(_p_y),hl
	ld	hl,144 % 256	;const
	ld	a,l
	ld	(_gpy),a
	jp	i_331
.i_328
	ld	a,(_gpy)
	cp	#(144 % 256)
	jp	nz,i_333
	ld	hl,_p_vy
	call	l_gchar
	ld	de,0	;const
	ex	de,hl
	call	l_gt
	jp	nc,i_333
	ld	hl,(_y_pant)
	ld	h,0
	push	hl
	ld	hl,(_level_data+1)
	ld	h,0
	dec	hl
	pop	de
	call	l_ult
	jr	c,i_334_i_333
.i_333
	jp	i_332
.i_334_i_333
	ld	hl,(_n_pant)
	ld	h,0
	ex	de,hl
	ld	hl,(_level_data)
	ld	h,0
	add	hl,de
	ld	h,0
	ld	a,l
	ld	(_n_pant),a
	ld	hl,0 % 256	;const
	ld	a,l
	ld	(_gpy),a
	ld	(_p_y),hl
.i_332
.i_331
	ret



._hide_sprites
	ld	hl,2	;const
	add	hl,sp
	ld	l,(hl)
	ld	h,0
	ld	a,h
	or	l
	jp	nz,i_335
	ld ix, (_sp_player)
	ld iy, vpClipStruct
	ld bc, 0
	ld hl, 0xdede
	ld de, 0
	call SPMoveSprAbs
.i_335
	xor a
	.hide_sprites_enems_loop
	ld (_gpit), a
	sla a
	ld c, a
	ld b, 0
	ld hl, _sp_moviles
	add hl, bc
	ld e, (hl)
	inc hl
	ld d, (hl)
	push de
	pop ix
	ld iy, vpClipStruct
	ld bc, 0
	ld hl, 0xfefe
	ld de, 0
	call SPMoveSprAbs
	ld a, (_gpit)
	inc a
	cp 3
	jr nz, hide_sprites_enems_loop
	xor a
	.hide_sprites_bullets_loop
	ld (_gpit), a
	sla a
	ld c, a
	ld b, 0
	ld hl, _sp_bullets
	add hl, bc
	ld e, (hl)
	inc hl
	ld d, (hl)
	push de
	pop ix
	ld iy, vpClipStruct
	ld bc, 0
	ld hl, 0xfefe
	ld de, 0
	call SPMoveSprAbs
	ld a, (_gpit)
	inc a
	cp 3
	jr nz, hide_sprites_bullets_loop
	xor a
	.hide_sprites_cocos_loop
	ld (_gpit), a
	sla a
	ld c, a
	ld b, 0
	ld hl, _sp_cocos
	add hl, bc
	ld e, (hl)
	inc hl
	ld d, (hl)
	push de
	pop ix
	ld iy, vpClipStruct
	ld bc, 0
	ld hl, 0xfefe
	ld de, 0
	call SPMoveSprAbs
	ld a, (_gpit)
	inc a
	cp 3
	jr nz, hide_sprites_cocos_loop
	ret



._main
	di
	ld	hl,61937	;const
	push	hl
	call	sp_InitIM2
	pop	bc
	ld	hl,61937	;const
	push	hl
	call	sp_CreateGenericISR
	pop	bc
	ld	hl,255 % 256	;const
	push	hl
	ld	hl,_ISR
	push	hl
	call	sp_RegisterHook
	pop	bc
	pop	bc
	ld	hl,0 % 256	;const
	push	hl
	push	hl
	call	sp_Initialize
	pop	bc
	pop	bc
	ld	hl,0 % 256	;const
	push	hl
	call	sp_Border
	pop	bc
	ld	hl,0 % 256	;const
	push	hl
	ld	hl,55 % 256	;const
	push	hl
	ld	hl,14	;const
	push	hl
	ld	hl,_AD_FREE
	push	hl
	call	sp_AddMemory
	pop	bc
	pop	bc
	pop	bc
	pop	bc
	ld	hl,sp_JoyKeyboard
	ld	(_joyfunc),hl
	ld	hl,_tileset
	ld	(_gen_pt),hl
	ld	hl,0 % 256	;const
	ld	a,l
	ld	(_gpit),a
.i_338
	ld	hl,(_gpit)
	ld	h,0
	push	hl
	ld	hl,(_gen_pt)
	push	hl
	call	sp_TileArray
	pop	bc
	pop	bc
	ld	hl,(_gen_pt)
	ld	bc,8
	add	hl,bc
	ld	(_gen_pt),hl
	ld	hl,_gpit
	ld	a,(hl)
	inc	(hl)
.i_336
	ld	hl,(_gpit)
	ld	h,0
	ld	a,h
	or	l
	jp	nz,i_338
.i_337
	ld	hl,0 % 256	;const
	push	hl
	ld	hl,3 % 256	;const
	push	hl
	ld	hl,_sprite_2_a
	push	hl
	ld	hl,1 % 256	;const
	push	hl
	ld	hl,128 % 256	;const
	push	hl
	call	sp_CreateSpr
	pop	bc
	pop	bc
	pop	bc
	pop	bc
	pop	bc
	ld	(_sp_player),hl
	push	hl
	ld	hl,_sprite_2_b
	push	hl
	ld	hl,128 % 256	;const
	push	hl
	call	sp_AddColSpr
	pop	bc
	pop	bc
	pop	bc
	ld	hl,(_sp_player)
	push	hl
	ld	hl,_sprite_2_c
	push	hl
	ld	hl,128 % 256	;const
	push	hl
	call	sp_AddColSpr
	pop	bc
	pop	bc
	pop	bc
	ld	hl,_sprite_2_a
	ld	(_p_n_f),hl
	ld	(_p_c_f),hl
	ld	hl,0 % 256	;const
	ld	a,l
	ld	(_gpit),a
	jp	i_341
.i_339
	ld	hl,_gpit
	ld	a,(hl)
	inc	(hl)
.i_341
	ld	a,(_gpit)
	cp	#(3 % 256)
	jp	z,i_340
	jp	nc,i_340
	ld	hl,_sp_moviles
	push	hl
	ld	hl,(_gpit)
	ld	h,0
	add	hl,hl
	pop	de
	add	hl,de
	push	hl
	ld	hl,0 % 256	;const
	push	hl
	ld	hl,3 % 256	;const
	push	hl
	ld	de,_sprite_9_a
	push	de
	push	hl
	ld	hl,128 % 256	;const
	push	hl
	call	sp_CreateSpr
	pop	bc
	pop	bc
	pop	bc
	pop	bc
	pop	bc
	pop	de
	call	l_pint
	ld	hl,_sp_moviles
	push	hl
	ld	hl,(_gpit)
	ld	h,0
	add	hl,hl
	pop	de
	add	hl,de
	ld	e,(hl)
	inc	hl
	ld	d,(hl)
	push	de
	ld	hl,_sprite_9_b
	push	hl
	ld	hl,128 % 256	;const
	push	hl
	call	sp_AddColSpr
	pop	bc
	pop	bc
	pop	bc
	ld	hl,_sp_moviles
	push	hl
	ld	hl,(_gpit)
	ld	h,0
	add	hl,hl
	pop	de
	add	hl,de
	ld	e,(hl)
	inc	hl
	ld	d,(hl)
	push	de
	ld	hl,_sprite_9_c
	push	hl
	ld	hl,128 % 256	;const
	push	hl
	call	sp_AddColSpr
	pop	bc
	pop	bc
	pop	bc
	ld	hl,_en_an_c_f
	push	hl
	ld	hl,(_gpit)
	ld	h,0
	add	hl,hl
	pop	de
	add	hl,de
	push	hl
	ld	hl,_en_an_n_f
	push	hl
	ld	hl,(_gpit)
	ld	h,0
	add	hl,hl
	pop	de
	add	hl,de
	push	hl
	ld	hl,_sprite_9_a
	pop	de
	call	l_pint
	pop	de
	call	l_pint
	jp	i_339
.i_340
	ld	hl,0 % 256	;const
	ld	a,l
	ld	(_gpit),a
	jp	i_344
.i_342
	ld	hl,_gpit
	ld	a,(hl)
	inc	(hl)
.i_344
	ld	a,(_gpit)
	cp	#(1 % 256)
	jp	z,i_343
	jp	nc,i_343
	ld	hl,_sp_bullets
	push	hl
	ld	hl,(_gpit)
	ld	h,0
	add	hl,hl
	pop	de
	add	hl,de
	push	hl
	ld	hl,0 % 256	;const
	push	hl
	ld	hl,2 % 256	;const
	push	hl
	ld	hl,_sprite_19_a
	push	hl
	ld	hl,1 % 256	;const
	push	hl
	ld	hl,128 % 256	;const
	push	hl
	call	sp_CreateSpr
	pop	bc
	pop	bc
	pop	bc
	pop	bc
	pop	bc
	pop	de
	call	l_pint
	ld	hl,_sp_bullets
	push	hl
	ld	hl,(_gpit)
	ld	h,0
	add	hl,hl
	pop	de
	add	hl,de
	ld	e,(hl)
	inc	hl
	ld	d,(hl)
	push	de
	ld	hl,_sprite_19_a+32
	push	hl
	ld	hl,128 % 256	;const
	push	hl
	call	sp_AddColSpr
	pop	bc
	pop	bc
	pop	bc
	jp	i_342
.i_343
	ld	hl,0 % 256	;const
	ld	a,l
	ld	(_gpit),a
	jp	i_347
.i_345
	ld	hl,_gpit
	ld	a,(hl)
	inc	(hl)
.i_347
	ld	a,(_gpit)
	cp	#(3 % 256)
	jp	z,i_346
	jp	nc,i_346
	ld	hl,_sp_cocos
	push	hl
	ld	hl,(_gpit)
	ld	h,0
	add	hl,hl
	pop	de
	add	hl,de
	push	hl
	ld	hl,0 % 256	;const
	push	hl
	ld	hl,2 % 256	;const
	push	hl
	ld	hl,_sprite_19_a
	push	hl
	ld	hl,1 % 256	;const
	push	hl
	ld	hl,128 % 256	;const
	push	hl
	call	sp_CreateSpr
	pop	bc
	pop	bc
	pop	bc
	pop	bc
	pop	bc
	pop	de
	call	l_pint
	ld	hl,_sp_cocos
	push	hl
	ld	hl,(_gpit)
	ld	h,0
	add	hl,hl
	pop	de
	add	hl,de
	ld	e,(hl)
	inc	hl
	ld	d,(hl)
	push	de
	ld	hl,_sprite_19_a+32
	push	hl
	ld	hl,128 % 256	;const
	push	hl
	call	sp_AddColSpr
	pop	bc
	pop	bc
	pop	bc
	jp	i_345
.i_346
	ei
	call	_cortina
	call	_wyz_init
.i_348
	call	sp_UpdateNow
	ld	hl,0 % 256	;const
	push	hl
	ld	hl,16384	;const
	push	hl
	call	_get_resource
	pop	bc
	pop	bc
	ld	hl,0 % 256	;const
	call	_wyz_play_music
	call	_select_joyfunc
	call	_wyz_stop_sound
	ld	a,#(1 % 256 % 256)
	ld	(_mlplaying),a
	ld	a,#(0 % 256 % 256)
	ld	(_silent_level),a
	ld	a,#(0 % 256 % 256)
	ld	(_level),a
	ld	a,#(5 % 256 % 256)
	ld	(_p_life),a
	ld	a,#(0 % 256 % 256)
	ld	(_script_result),a
	ld	hl,0 % 256	;const
	ld	a,l
	ld	(_p_killme),a
.i_350
	ld	hl,(_mlplaying)
	ld	h,0
	ld	a,h
	or	l
	jp	z,i_351
	call	_prepare_level
	ld	hl,(_silent_level)
	ld	h,0
	call	l_lneg
	jp	nc,i_352
	call	_blackout_area
	ld	a,#(5 % 256 % 256)
	ld	(__x),a
	ld	a,#(5 % 256 % 256)
	ld	(__y),a
	ld	a,#(71 % 256 % 256)
	ld	(__t),a
	ld	hl,i_1+134
	ld	(_gp_gen),hl
	call	_print_str
	call	sp_UpdateNow
	ld	hl,150	;const
	push	hl
	call	_active_sleep
	pop	bc
	call	_blackout_area
	ld	a,#(6 % 256 % 256)
	ld	(__x),a
	ld	a,#(11 % 256 % 256)
	ld	(__y),a
	ld	a,#(71 % 256 % 256)
	ld	(__t),a
	ld	hl,i_1+159
	ld	(_gp_gen),hl
	call	_print_str
	call	sp_UpdateNow
	ld	hl,250	;const
	push	hl
	call	_active_sleep
	pop	bc
.i_352
	ld	a,#(1 % 256 % 256)
	ld	(_silent_level),a
	ld	hl,1 % 256	;const
	ld	a,l
	ld	(_playing),a
	call	_init_bullets
	call	_init_cocos
	call	_player_init
	ld	a,#(0 % 256 % 256)
	ld	(_maincounter),a
	ld	a,#(0 % 256 % 256)
	ld	(_script_result),a
	ld	hl,40 % 256	;const
	push	hl
	call	_run_script
	pop	bc
	ld	a,#(1 % 256 % 256)
	ld	(_do_respawn),a
	ld	hl,255 % 256	;const
	ld	a,l
	ld	(_killed_old),a
	ld	h,0
	ld	a,l
	ld	(_life_old),a
	ld	h,0
	ld	a,l
	ld	(_keys_old),a
	ld	h,0
	ld	a,l
	ld	(_objs_old),a
	ld	a,#(99 % 256 % 256)
	ld	(_flag_old),a
	ld	a,#(0 % 256 % 256)
	ld	(_success),a
	ld	hl,_levels
	push	hl
	ld	hl,(_level)
	ld	h,0
	add	hl,hl
	add	hl,hl
	pop	de
	add	hl,de
	inc	hl
	ld	l,(hl)
	ld	h,0
	call	_wyz_play_music
	ld	a,#(255 % 256 % 256)
	ld	(_o_pant),a
	ld	hl,0 % 256	;const
	ld	a,l
	ld	(_no_draw),a
.i_353
	ld	hl,(_playing)
	ld	h,0
	ld	a,h
	or	l
	jp	z,i_354
	call	_read_controller
	ld	a,(_ctimer)
	and	a
	jp	z,i_355
	ld	hl,_ctimer+1+1+1
	inc	(hl)
	ld	a,(_ctimer+1+1)
	cp	(hl)
	jp	nz,i_356
	ld	hl,_ctimer+1+1+1
	ld	(hl),#(0 % 256 % 256)
	ld	a,(_ctimer+1)
	and	a
	jp	z,i_357
	ld	hl,_ctimer+1
	dec	(hl)
	ld	l,(hl)
	ld	h,0
	inc	l
	jp	i_358
.i_357
	ld	hl,_ctimer+4
	ld	(hl),#(1 % 256 % 256)
	ld	l,(hl)
	ld	h,0
.i_358
.i_356
.i_355
	ld	a,(_ctimer+4)
	and	a
	jp	z,i_359
	ld	hl,_ctimer+4
	ld	(hl),#(0 % 256 % 256)
	ld	hl,43 % 256	;const
	push	hl
	call	_run_script
	pop	bc
.i_359
	ld	hl,(_n_pant)
	ld	h,0
	ex	de,hl
	ld	hl,(_o_pant)
	ld	h,0
	call	l_ne
	jp	nc,i_360
	ld	hl,(_n_pant)
	ld	h,0
	ld	a,l
	ld	(_o_pant),a
	call	_draw_scr
.i_360
	call	_update_hud
	ld	hl,_maincounter
	ld	a,(hl)
	inc	(hl)
	ld	hl,(_half_life)
	ld	h,0
	call	l_lneg
	ld	hl,0	;const
	rl	l
	ld	h,0
	ld	a,l
	ld	(_half_life),a
	call	_player_move
	call	_enems_move
	call	_move_cocos
	call	_mueve_bullets
	ld	a,(_p_state)
	ld	e,a
	ld	d,0
	ld	hl,2	;const
	call	l_and
	ld	de,0	;const
	ex	de,hl
	call	l_eq
	jp	c,i_362
	ld	a,(_half_life)
	cp	#(0 % 256)
	jp	nz,i_361
.i_362
	ld ix, (_sp_player)
	ld iy, vpClipStruct
	ld hl, (_p_n_f)
	ld de, (_p_c_f)
	or a
	sbc hl, de
	ld b, h
	ld c, l
	ld a, (_gpy)
	srl a
	srl a
	srl a
	add 0
	ld h, a
	ld a, (_gpx)
	srl a
	srl a
	srl a
	add 1
	ld l, a
	ld a, (_gpx)
	and 7
	ld d, a
	ld a, (_gpy)
	and 7
	ld e, a
	call SPMoveSprAbs
	jp	i_364
.i_361
	ld ix, (_sp_player)
	ld iy, vpClipStruct
	ld hl, (_p_n_f)
	ld de, (_p_c_f)
	or a
	sbc hl, de
	ld b, h
	ld c, l
	ld hl, 0xfefe
	ld de, 0
	call SPMoveSprAbs
.i_364
	ld	hl,(_p_n_f)
	ld	(_p_c_f),hl
	ld	hl,0 % 256	;const
	ld	a,l
	ld	(_gpit),a
	jp	i_367
.i_365
	ld	hl,_gpit
	ld	a,(hl)
	inc	(hl)
.i_367
	ld	a,(_gpit)
	cp	#(1 % 256)
	jp	z,i_366
	jp	nc,i_366
	ld	de,_bullets_estado
	ld	hl,(_gpit)
	ld	h,0
	add	hl,de
	ld	a,(hl)
	cp	#(1 % 256)
	jp	nz,i_368
	ld	de,_bullets_x
	ld	hl,(_gpit)
	ld	h,0
	add	hl,de
	ld	l,(hl)
	ld	h,0
	ld	a,l
	ld	(_rdx),a
	ld	de,_bullets_y
	ld	hl,(_gpit)
	ld	h,0
	add	hl,de
	ld	l,(hl)
	ld	h,0
	ld	a,l
	ld	(_rdy),a
	ld a, (_gpit)
	sla a
	ld c, a
	ld b, 0
	ld hl, _sp_bullets
	add hl, bc
	ld e, (hl)
	inc hl
	ld d, (hl)
	push de
	pop ix
	ld iy, vpClipStruct
	ld bc, 0
	ld a, (_rdy)
	srl a
	srl a
	srl a
	add 0
	ld h, a
	ld a, (_rdx)
	srl a
	srl a
	srl a
	add 1
	ld l, a
	ld a, (_rdx)
	and 7
	ld d, a
	ld a, (_rdy)
	and 7
	ld e, a
	call SPMoveSprAbs
	jp	i_369
.i_368
	ld a, (_gpit)
	sla a
	ld c, a
	ld b, 0
	ld hl, _sp_bullets
	add hl, bc
	ld e, (hl)
	inc hl
	ld d, (hl)
	push de
	pop ix
	ld iy, vpClipStruct
	ld bc, 0
	ld hl, 0xfefe
	ld de, 0
	call SPMoveSprAbs
.i_369
	jp	i_365
.i_366
.i_370
	ld	a,(_isrc)
	ld	e,a
	ld	d,0
	ld	hl,2	;const
	call	l_ult
	jp	nc,i_371
	halt
	jp	i_370
.i_371
	ld	hl,0 % 256	;const
	ld	a,l
	ld	(_isrc),a
	call	sp_UpdateNow
	ld	a,(_p_state)
	and	a
	jp	z,i_372
	ld	hl,_p_state_ct
	ld	a,(hl)
	dec	(hl)
	ld	a,(_p_state_ct)
	and	a
	jp	nz,i_373
	ld	hl,0 % 256	;const
	ld	a,l
	ld	(_p_state),a
.i_373
.i_372
	call	_do_ingame_scripting
	ld	a,(_level_data+7)
	cp	#(0 % 256)
	jp	nz,i_375
	ld	hl,(_p_objs)
	ld	h,0
	ex	de,hl
	ld	hl,(_level_data+5)
	ld	h,0
	call	l_eq
	jp	c,i_377
.i_375
	jr	i_375_i_376
.i_376
	ld	a,h
	or	l
	jp	nz,i_377
.i_375_i_376
	ld	a,(_level_data+7)
	cp	#(1 % 256)
	jp	nz,i_378
	ld	hl,(_n_pant)
	ld	h,0
	ex	de,hl
	ld	hl,(_level_data+8)
	ld	h,0
	call	l_eq
	jp	c,i_377
.i_378
	jr	i_378_i_379
.i_379
	ld	a,h
	or	l
	jp	nz,i_377
.i_378_i_379
	ld	a,(_level_data+7)
	cp	#(2 % 256)
	jp	nz,i_380
	ld	a,(_script_result)
	cp	#(1 % 256)
	jp	nz,i_380
	ld	hl,1	;const
	jr	i_381
.i_380
	ld	hl,0	;const
.i_381
	ld	a,h
	or	l
	jp	nz,i_377
	jr	i_382
.i_377
	ld	hl,1	;const
.i_382
	ld	a,h
	or	l
	jp	z,i_374
	ld	a,#(1 % 256 % 256)
	ld	(_success),a
	ld	hl,0 % 256	;const
	ld	a,l
	ld	(_playing),a
.i_374
	ld	a,(_p_life)
	cp	#(0 % 256)
	jp	nz,i_384
	ld	a,(_p_killme)
	and	a
	jp	z,i_384
	ld	hl,1	;const
	jr	i_385
.i_384
	ld	hl,0	;const
.i_385
	ld	a,h
	or	l
	jp	nz,i_386
	ld	a,(_script_result)
	cp	#(2 % 256)
	jp	nz,i_383
.i_386
	ld	hl,0 % 256	;const
	ld	a,l
	ld	(_playing),a
.i_383
	ld	a,(_script_result)
	cp	#(2 % 256)
	jp	z,i_388
	jp	c,i_388
	ld	hl,(_script_result)
	ld	h,0
	ld	a,l
	ld	(_success),a
	ld	hl,0 % 256	;const
	ld	a,l
	ld	(_playing),a
.i_388
	ld	hl,(_p_killme)
	ld	h,0
	ld	a,h
	or	l
	jp	z,i_389
	call	_player_kill
	ld	hl,0 % 256	;const
	ld	a,l
	ld	(_p_killme),a
.i_389
	call	_flick_screen
	jp	i_353
.i_354
	call	_wyz_stop_sound
	ld	hl,0 % 256	;const
	push	hl
	call	_hide_sprites
	pop	bc
	call	sp_UpdateNow
	ld	hl,(_success)
	ld	h,0
.i_392
	ld	a,l
	cp	#(0% 256)
	jp	z,i_393
	cp	#(1% 256)
	jp	z,i_394
	cp	#(3% 256)
	jp	z,i_395
	cp	#(4% 256)
	jp	z,i_396
	jp	i_391
.i_393
	ld	hl,i_1+121
	ld	(_gp_gen),hl
	call	_print_message
	ld	a,#(0 % 256 % 256)
	ld	(_mlplaying),a
	ld	hl,250	;const
	push	hl
	call	_active_sleep
	pop	bc
	jp	i_391
.i_394
	ld	hl,i_1+180
	ld	(_gp_gen),hl
	call	_print_message
	ld	hl,_level
	ld	a,(hl)
	inc	(hl)
	ld	hl,250	;const
	push	hl
	call	_active_sleep
	pop	bc
	jp	i_391
.i_395
	call	_blackout_area
	ld	hl,(_warp_to_level)
	ld	h,0
	ld	a,l
	ld	(_level),a
	jp	i_391
.i_396
	ld	hl,2 % 256	;const
	push	hl
	ld	hl,16384	;const
	push	hl
	call	_get_resource
	pop	bc
	pop	bc
	ld	hl,1000	;const
	push	hl
	call	_active_sleep
	pop	bc
	call	_wyz_stop_sound
	call	_cortina
	ld	hl,130	;const
	push	hl
	call	_active_sleep
	pop	bc
	ld	hl,0 % 256	;const
	ld	a,l
	ld	(_mlplaying),a
.i_391
	jp	i_350
.i_351
	call	_cortina
	jp	i_348
.i_349
	ret


;	SECTION	text

.i_1
	defm	"            "
	defb	0

	defm	"#$$$$$$$$$$$$$$$$$$$$$$$$%"
	defb	0

	defm	"&                        '"
	defb	0

	defm	"())))))))))))))))))))))))*"
	defb	0

	defm	"                          "
	defb	0

	defm	" GAME OVER! "
	defb	0

	defm	"GRACIAS ANDY Y NATHAN ;_"
	defb	0

	defm	"LA AVENTURA COMIENZA"
	defb	0

	defm	" ZONE CLEAR "
	defb	0

;	SECTION	code



; --- Start of Static Variables ---

;	SECTION	bss

.__en_t	defs	1
.__en_x	defs	1
.__en_y	defs	1
._sp_moviles	defs	6
.__en_x1	defs	1
.__en_y1	defs	1
.__en_x2	defs	1
.__en_y2	defs	1
._bullets_mx	defs	1
._bullets_my	defs	1
._en_an_base_frame	defs	3
._hotspot_x	defs	1
._hotspot_y	defs	1
._en_an_c_f	defs	6
.__en_mx	defs	1
.__en_my	defs	1
._map_pointer	defs	2
._en_an_state	defs	3
._flags	defs	32
._p_facing	defs	1
._p_frame	defs	1
._en_an_n_f	defs	6
._p_c_f	defs	2
._pregotten	defs	1
._en_an_morido	defs	3
._hit_h	defs	1
._hit_v	defs	1
._killed_old	defs	1
._p_n_f	defs	2
._gpaux	defs	1
._map_attr	defs	150
._active	defs	1
.__n	defs	1
._do_respawn	defs	1
.__t	defs	1
.__x	defs	1
.__y	defs	1
._mlplaying	defs	1
.__en_an_vx	defs	1
.__en_an_vy	defs	1
._life_old	defs	1
._coco_d	defs	1
._coco_s	defs	3
._coco_x	defs	3
._coco_y	defs	3
._p_engine	defs	1
._bullets_estado	defs	1
._gen_pt	defs	2
._no_draw	defs	1
._p_state	defs	1
._extaddress	defs	2
._ptgmx	defs	1
._ptgmy	defs	1
._warp_to_level	defs	1
._sp_player	defs	2
._gp_gen	defs	2
._sp_bullets	defs	2
._killable	defs	1
._enoffs	defs	1
._pad_this_frame	defs	1
._silent_level	defs	1
._ctimer	defs	5
._sp_cocos	defs	6
.__max	defs	2
.__min	defs	2
._p_killed	defs	1
._bullets_x	defs	1
._bullets_y	defs	1
._pad0	defs	1
.__val	defs	2
._p_killme	defs	1
._lasttimehit	defs	1
._p_jmp_ct	defs	1
._bullets_life	defs	1
._n_pant	defs	1
._p_jmp_on	defs	1
._o_pant	defs	1
._p_life	defs	1
._enit	defs	1
._p_safe_x	defs	1
._p_safe_y	defs	1
._joyfunc	defs	2
._gpcx	defs	1
._p_objs	defs	1
._p_gotten	defs	1
._gpcy	defs	1
._main_script_offset	defs	2
._gpit	defs	1
._en_an_vx	defs	3
._p_keys	defs	1
._en_an_vy	defs	3
._gpjt	defs	1
._playing	defs	1
._sc_c	defs	1
._keyp	defs	1
._sc_m	defs	1
._sc_n	defs	1
._keys	defs	10
._exti	defs	1
._sc_x	defs	1
._sc_y	defs	1
._p_vx	defs	1
._p_vy	defs	1
._gpxx	defs	1
._gpyy	defs	1
._objs_old	defs	1
.__en_an_x	defs	2
.__en_an_y	defs	2
._extx	defs	1
._exty	defs	1
._maincounter	defs	1
._ptx1	defs	1
._ptx2	defs	1
._pty1	defs	1
._pty2	defs	1
._flag_old	defs	1
._at1	defs	1
._at2	defs	1
._action_pressed	defs	1
.__en_life	defs	1
._cx1	defs	1
._cx2	defs	1
._cy1	defs	1
._cy2	defs	1
._enemy_shoots	defs	1
._p_subframe	defs	1
._p_state_ct	defs	1
._animate	defs	1
._next_script	defs	2
._gpc	defs	1
._gpd	defs	1
._coco_x0	defs	1
._p_g	defs	1
._en_an_x	defs	6
._en_an_y	defs	6
._hit	defs	1
._ctx	defs	1
._cty	defs	1
._gps	defs	1
._gpt	defs	1
._rda	defs	1
._rdb	defs	1
._p_x	defs	2
._AD_FREE	defs	825
._p_y	defs	2
._gpx	defs	1
._gpy	defs	1
._rds	defs	1
._coco_it	defs	1
._rdx	defs	1
._rdy	defs	1
._wall_h	defs	1
._coco_vx	defs	3
._coco_vy	defs	3
._stepbystep	defs	1
._enoffsmasi	defs	1
._keys_old	defs	1
._wall_v	defs	1
._tocado	defs	1
._x_pant	defs	1
._is_rendering	defs	1
._p_facing_h	defs	1
._y_pant	defs	1
.__baddies_pointer	defs	2
._p_facing_v	defs	1
._possee	defs	1
._orig_tile	defs	1
._success	defs	1
._en_an_count	defs	3
._p_disparando	defs	1
._p_safe_pant	defs	1
;	SECTION	code



; --- Start of Scope Defns ---

	LIB	sp_GetKey
	LIB	sp_BlockAlloc
	XDEF	__en_t
	XDEF	_read_vbyte
	LIB	sp_ScreenStr
	XDEF	__en_x
	XDEF	__en_y
	XDEF	_draw_scr
	LIB	sp_PixelUp
	XDEF	_enems_move_spr_abs
	XDEF	_prepare_level
	XDEF	_wyz_play_music
	LIB	sp_JoyFuller
	XDEF	_fire_bullet
	XDEF	_destroy_cocos
	LIB	sp_MouseAMXInit
	XDEF	_blackout_area
	LIB	sp_MouseAMX
	XDEF	_sp_moviles
	XDEF	__en_x1
	LIB	sp_SetMousePosAMX
	XDEF	__en_y1
	XDEF	_u_malloc
	LIB	sp_Validate
	LIB	sp_HashAdd
	XDEF	__en_x2
	XDEF	__en_y2
	XDEF	_bullets_mx
	XDEF	_bullets_my
	XDEF	_cortina
	LIB	sp_Border
	LIB	sp_Inkey
	XDEF	_enems_kill
	XDEF	_en_an_base_frame
	XDEF	_enems_init
	XDEF	_wyz_play_sound
	XDEF	_hotspot_x
	XDEF	_hotspot_y
	LIB	sp_CreateSpr
	LIB	sp_MoveSprAbs
	LIB	sp_BlockCount
	LIB	sp_AddMemory
	XDEF	_half_life
	XDEF	_en_an_c_f
	XDEF	__en_mx
	XDEF	__en_my
	XDEF	_map_pointer
	XDEF	_read_controller
	XDEF	_en_an_state
	XDEF	_flags
	LIB	sp_PrintAt
	LIB	sp_Pause
	XDEF	_enems_move
	LIB	sp_ListFirst
	LIB	sp_HeapSiftUp
	LIB	sp_ListCount
	XDEF	_p_facing
	XDEF	_invalidate_tile
	XDEF	_p_frame
	XDEF	_en_an_n_f
	LIB	sp_Heapify
	XDEF	_p_c_f
	LIB	sp_MoveSprRel
	XDEF	_mueve_bullets
	XDEF	_hide_sprites
	XDEF	_arrow_sprites
	XDEF	_pregotten
	XDEF	_en_an_morido
	XDEF	_hit_h
	LIB	sp_TileArray
	LIB	sp_MouseSim
	LIB	sp_BlockFit
	XDEF	_map_buff
	defc	_map_buff	=	61697
	XDEF	_resources
	XDEF	_hit_v
	LIB	sp_HeapExtract
	LIB	sp_HuffExtract
	XDEF	_killed_old
	LIB	sp_SetMousePosSim
	XDEF	_p_n_f
	XDEF	_gpaux
	LIB	sp_ClearRect
	XDEF	_print_message
	LIB	sp_HuffGetState
	XDEF	_map_attr
	XDEF	_baddies
	XDEF	_invalidate_viewport
	XDEF	_active
	XDEF	_seed1
	XDEF	_seed2
	LIB	sp_ListAppend
	XDEF	_keyscancodes
	XDEF	_level
	LIB	sp_ListCreate
	LIB	sp_ListConcat
	LIB	sp_JoyKempston
	LIB	sp_UpdateNow
	LIB	sp_MouseKempston
	LIB	sp_PrintString
	LIB	sp_PixelDown
	LIB	sp_MoveSprAbsC
	LIB	sp_PixelLeft
	XDEF	_enem_frames
	LIB	sp_InitAlloc
	LIB	sp_DeleteSpr
	XDEF	_get_resource
	LIB	sp_JoyTimexEither
	XDEF	__n
	XDEF	_unpack_RAMn
	XDEF	_flick_screen
	XDEF	_do_respawn
	XDEF	_player_kill
	XDEF	__t
	XDEF	__x
	XDEF	__y
	XDEF	_wyz_init
	XDEF	_player_init
	XDEF	_mlplaying
	XDEF	__en_an_vx
	LIB	sp_Invalidate
	XDEF	__en_an_vy
	XDEF	_life_old
	LIB	sp_CreateGenericISR
	LIB	sp_JoyKeyboard
	XDEF	_coco_d
	LIB	sp_FreeBlock
	XDEF	_coco_s
	LIB	sp_PrintAtDiff
	LIB	sp_UpdateNowEx
	XDEF	_run_fire_script
	XDEF	_coco_x
	XDEF	_coco_y
	XDEF	_p_engine
	XDEF	_addons_between
	XDEF	_player_move
	XDEF	_bullets_estado
	XDEF	_gen_pt
	XDEF	_no_draw
	XDEF	_read_byte
	XDEF	_sprite_10_a
	XDEF	_sprite_10_b
	XDEF	_sprite_10_c
	XDEF	_addsign
	XDEF	_sprite_11_a
	XDEF	_sprite_11_b
	XDEF	_sprite_11_c
	XDEF	_collide_pixel
	XDEF	_sprite_12_a
	XDEF	_sprite_12_b
	XDEF	_p_state
	XDEF	_sprite_12_c
	XDEF	_sprite_13_a
	XDEF	_sprite_13_b
	XDEF	_sprite_13_c
	XDEF	_extaddress
	XDEF	_sprite_14_a
	XDEF	_sprite_14_b
	XDEF	_sprite_14_c
	XDEF	_srand
	XDEF	_sprite_15_a
	XDEF	_sprite_15_b
	XDEF	_sprite_15_c
	LIB	sp_RegisterHookLast
	LIB	sp_IntLargeRect
	LIB	sp_IntPtLargeRect
	LIB	sp_HashDelete
	LIB	sp_GetCharAddr
	XDEF	_ptgmx
	XDEF	_ptgmy
	LIB	sp_RemoveHook
	XDEF	_warp_to_level
	XDEF	_sprite_16_a
	XDEF	_sprite_16_b
	XDEF	_sprite_16_c
	XDEF	_sprite_17_a
	XDEF	_sprite_18_a
	XDEF	_sprite_19_a
	XDEF	_sprite_19_b
	XDEF	_player_frames
	LIB	sp_MoveSprRelC
	LIB	sp_InitIM2
	XDEF	_cm_two_points
	XDEF	_qtile
	XDEF	_randres
	XDEF	_move_cocos
	XDEF	_do_ingame_scripting
	XDEF	_sp_player
	XDEF	_stop_player
	XDEF	_gp_gen
	XDEF	_sp_bullets
	XDEF	_init_bullets
	LIB	sp_GetTiles
	XDEF	_drop_sprites
	LIB	sp_Pallette
	LIB	sp_WaitForNoKey
	XDEF	_killable
	XDEF	_enoffs
	XDEF	_safe_byte
	defc	_safe_byte	=	23301
	XDEF	_pad_this_frame
	XDEF	_silent_level
	XDEF	_utaux
	XDEF	_ctimer
	LIB	sp_JoySinclair1
	LIB	sp_JoySinclair2
	LIB	sp_ListPrepend
	XDEF	_sp_cocos
	XDEF	__max
	XDEF	_behs
	XDEF	_init_cocos
	XDEF	_draw_invalidate_coloured_tile_g
	XDEF	__min
	XDEF	_p_killed
	LIB	sp_GetAttrAddr
	XDEF	_bullets_x
	XDEF	_bullets_y
	LIB	sp_HashCreate
	XDEF	_pad0
	XDEF	__val
	XDEF	_p_killme
	XDEF	_lasttimehit
	LIB	sp_Random32
	LIB	sp_ListInsert
	XDEF	_p_jmp_ct
	LIB	sp_ListFree
	XDEF	_bullets_life
	XDEF	_n_pant
	XDEF	_spriteset
	XDEF	_advance_worm
	XDEF	_p_jmp_on
	XDEF	_ISR
	LIB	sp_IntRect
	LIB	sp_ListLast
	LIB	sp_ListCurr
	XDEF	_o_pant
	XDEF	_p_life
	XDEF	_enit
	XDEF	_p_safe_x
	XDEF	_p_safe_y
	XDEF	_print_number2
	XDEF	_main
	LIB	sp_ListSearch
	LIB	sp_WaitForKey
	XDEF	_draw_coloured_tile
	LIB	sp_Wait
	LIB	sp_GetScrnAddr
	XDEF	_joyfunc
	LIB	sp_PutTiles
	XDEF	_gpcx
	XDEF	_p_objs
	XDEF	_p_gotten
	XDEF	_gpcy
	XDEF	_attr
	XDEF	_main_script_offset
	LIB	sp_RemoveDList
	XDEF	_gpit
	XDEF	_en_an_vx
	XDEF	_p_keys
	XDEF	_en_an_vy
	XDEF	_gpjt
	XDEF	_playing
	XDEF	_sc_c
	XDEF	_player_calc_bounding_box
	LIB	sp_ListNext
	XDEF	_keyp
	XDEF	_sc_m
	XDEF	_sc_n
	LIB	sp_HuffDecode
	XDEF	_keys
	XDEF	_rand
	LIB	sp_Swap
	XDEF	_run_entering_script
	XDEF	_exti
	XDEF	_sc_x
	XDEF	_isrc
	defc	_isrc	=	23296
	XDEF	_sc_y
	XDEF	_print_str
	XDEF	_levels
	XDEF	_asm_int_2
	defc	_asm_int_2	=	23299
	XDEF	_p_vx
	XDEF	_p_vy
	XDEF	_gpxx
	XDEF	_gpyy
	XDEF	_objs_old
	XDEF	__en_an_x
	XDEF	__en_an_y
	LIB	sp_ListPrev
	XDEF	_extx
	XDEF	_exty
	XDEF	_maincounter
	XDEF	_ptx1
	XDEF	_ptx2
	XDEF	_pty1
	XDEF	_pty2
	XDEF	_active_sleep
	XDEF	_flag_old
	LIB	sp_RegisterHook
	LIB	sp_ListRemove
	LIB	sp_ListTrim
	LIB	sp_MoveSprAbsNC
	LIB	sp_HuffDelete
	XDEF	_update_tile
	XDEF	_readxy
	XDEF	_at1
	XDEF	_at2
	XDEF	_level_data
	LIB	sp_ListAdd
	LIB	sp_KeyPressed
	XDEF	_action_pressed
	XDEF	_button_pressed
	XDEF	__en_life
	LIB	sp_PrintAtInv
	XDEF	_draw_coloured_tile_gamearea
	XDEF	_cx1
	XDEF	_cx2
	XDEF	_cy1
	XDEF	_cy2
	XDEF	_enemy_shoots
	LIB	sp_CompDListAddr
	XDEF	_p_subframe
	XDEF	_u_free
	XDEF	_abs
	XDEF	_p_state_ct
	XDEF	_game_ending
	LIB	sp_CharRight
	XDEF	_animate
	XDEF	_next_script
	XDEF	_run_script
	LIB	sp_InstallISR
	XDEF	_gpc
	XDEF	_gpd
	LIB	sp_HuffAccumulate
	LIB	sp_HuffSetState
	XDEF	_coco_x0
	XDEF	_p_g
	XDEF	_en_an_x
	XDEF	_en_an_y
	XDEF	_hit
	XDEF	_map
	XDEF	_sprite_1_a
	XDEF	_ctx
	XDEF	_cty
	XDEF	_sprite_1_b
	XDEF	_gps
	XDEF	_gpt
	XDEF	_rda
	XDEF	_rdb
	XDEF	_sprite_1_c
	LIB	sp_SwapEndian
	LIB	sp_CharLeft
	XDEF	_p_x
	XDEF	_AD_FREE
	LIB	sp_CharDown
	LIB	sp_HeapSiftDown
	LIB	sp_HuffCreate
	XDEF	_p_y
	XDEF	_gpx
	XDEF	_gpy
	XDEF	_sprite_2_a
	XDEF	_sprite_2_b
	XDEF	_sprite_2_c
	LIB	sp_HuffEncode
	XDEF	_rds
	XDEF	_sprite_3_a
	XDEF	_sprite_3_b
	XDEF	_sprite_3_c
	XDEF	_ram_page
	LIB	sp_JoyTimexRight
	LIB	sp_PixelRight
	XDEF	_coco_it
	XDEF	_rdx
	XDEF	_rdy
	LIB	sp_Initialize
	XDEF	_script_result
	XDEF	_sprite_4_a
	XDEF	_sprite_4_b
	XDEF	_sprite_4_c
	XDEF	_tileset
	XDEF	_sprite_5_a
	LIB	sp_JoyTimexLeft
	LIB	sp_SetMousePosKempston
	XDEF	_sprite_5_b
	XDEF	_sprite_5_c
	XDEF	_script
	LIB	sp_ComputePos
	XDEF	_sprite_6_a
	XDEF	_sprite_6_b
	XDEF	_sprite_6_c
	XDEF	_sprite_7_a
	XDEF	_sprite_7_b
	XDEF	_sprite_7_c
	XDEF	_sprite_8_a
	XDEF	_sprite_8_b
	XDEF	_sprite_8_c
	XDEF	_sprite_9_a
	XDEF	_sprite_9_b
	XDEF	_sprite_9_c
	XDEF	_wall_h
	XDEF	_wyz_stop_sound
	XDEF	_coco_vx
	XDEF	_coco_vy
	XDEF	_stepbystep
	XDEF	_enoffsmasi
	XDEF	_reloc_player
	XDEF	_keys_old
	XDEF	_update_hud
	XDEF	_spacer
	XDEF	_wall_v
	LIB	sp_IntIntervals
	XDEF	_my_malloc
	XDEF	_tocado
	XDEF	_x_pant
	XDEF	_do_gravity
	XDEF	_is_rendering
	LIB	sp_inp
	XDEF	_SetRAMBank
	LIB	sp_IterateSprChar
	LIB	sp_AddColSpr
	LIB	sp_outp
	XDEF	_sc_terminado
	XDEF	_asm_int
	defc	_asm_int	=	23297
	XDEF	_is_cutscene
	XDEF	_p_facing_h
	XDEF	_y_pant
	LIB	sp_IntPtInterval
	LIB	sp_RegisterHookFirst
	XDEF	__baddies_pointer
	LIB	sp_HashLookup
	XDEF	_p_facing_v
	LIB	sp_PFill
	XDEF	_possee
	LIB	sp_HashRemove
	XDEF	_sc_continuar
	LIB	sp_CharUp
	XDEF	_orig_tile
	XDEF	_success
	XDEF	_textbuff
	defc	_textbuff	=	23302
	LIB	sp_MoveSprRelNC
	XDEF	_ram_destination
	XDEF	_do_extern_action
	XDEF	_coco_clear_sprite
	XDEF	_en_an_count
	XDEF	_select_joyfunc
	XDEF	_p_disparando
	XDEF	_shoot_coco
	LIB	sp_IterateDList
	XDEF	_distance
	XDEF	_draw_scr_background
	XDEF	_game_over
	LIB	sp_LookupKey
	LIB	sp_HeapAdd
	LIB	sp_CompDirtyAddr
	LIB	sp_EmptyISR
	XDEF	_p_safe_pant
	XDEF	_ram_address
	LIB	sp_StackSpace


; --- End of Scope Defns ---


; --- End of Compilation ---