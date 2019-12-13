
#ifdef ACTIVATE_SCRIPTING
	if (
		#ifdef EXTENDED_LEVELS
			level_data->activate_scripting && 
		#endif
		#ifdef SCRIPTING_KEY_M
			sp_KeyPressed (KEY_M)
		#endif
		#ifdef SCRIPTING_DOWN
			(pad0 & sp_DOWN) == 0
		#endif
		#ifdef SCRIPTING_KEY_FIRE
			(pad0 & sp_FIRE) == 0
		#endif
	) {
		if (action_pressed == 0)  {
			action_pressed = 1;

			// Any scripts to run in this screen?
			run_fire_script ();
		}
	} else {
		action_pressed = 0;

		#ifdef ENABLE_FIRE_ZONE
			if (
				#ifdef EXTENDED_LEVELS
					level_data->activate_scripting &&
				#endif
				f_zone_ac
			) {
				if (gpx >= fzx1 && gpx <= fzx2 && gpy >= fzy1 && gpy <= fzy2) {
					run_fire_script ();
				}
			}
		#endif
	}
#endif
