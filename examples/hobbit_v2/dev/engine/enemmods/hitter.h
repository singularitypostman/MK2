// Collide with hitter

if (hitter_on && killable && hitter_hit == 0) {
	#if defined (PLAYER_CAN_PUNCH)
		if (
			hitter_frame <= 3 && 
			collide_pixel (hitter_x + (p_facing ? 6 : 1), hitter_y + 3, _en_x, _en_y)
		) 
	#elif defined (PLAYER_HAZ_SWORD)
		if (
			hitter_frame > 2 && 
			hitter_frame < 7 &&
			(
				(p_up == 0 && collide_pixel (hitter_x + (p_facing ? 6 : 1), hitter_y + 3, _en_x, _en_y)) ||
				(p_up && collide_pixel (hitter_x + 4, hitter_y, _en_x, _en_y))
			)
		) 
	#elif defined (PLAYER_HAZ_WHIP)
		if (
			hitter_frame < 5 &&
			collide_pixel (hitter_x + (p_facing ? 14 : 1), hitter_y + 3, _en_x, _en_y)
		) 
	#endif
	{
		hitter_hit = 1;
		enems_kill (PLAYER_HITTER_STRENGTH);
		goto enems_loop_continue;
	}
}
