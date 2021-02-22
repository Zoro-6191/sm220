main()
{
	setDvar( "scr_sd_bombtimer", 45 );
	setDvar( "scr_sd_defusetime", 7 );
	setDvar( "scr_sd_planttime", 5 );
	setDvar( "scr_sd_playerrespawndelay", 0 );
	setDvar( "scr_sd_roundlimit", 24 );
	setDvar( "scr_sd_roundswitch", 12 );
	setDvar( "scr_sd_scorelimit", 0 );
	setDvar( "scr_sd_timelimit", 1.75 );

	setDvar( "scr_war_playerrespawndelay", 0 );
	setDvar( "scr_war_roundlimit", 2 );
	setDvar( "scr_war_scorelimit", 0 );
	setDvar( "scr_war_roundswitch", 1 );
	setDvar( "scr_war_timelimit", 15 );

	setDvar( "scr_dm_numlives", 0 );
	setDvar( "scr_dm_playerrespawndelay", 0 );
	setDvar( "scr_dm_roundlimit", 1 );
	setDvar( "scr_dm_scorelimit", 0 );
	setDvar( "scr_dm_timelimit", 10 );

	setDvar( "class_assault_allowdrop", 1 );
	setDvar( "class_specops_allowdrop", 1 );
	setDvar( "class_demolitions_allowdrop", 0 );
	setDvar( "class_sniper_allowdrop", 0 );

	setDvar( "class_assault_primary", "ak47" );
	setDvar( "class_assault_secondary", "deserteagle" );
	setDvar( "class_assault_grenade", "smoke_grenade" );
	setDvar( "class_assault_camo", "camo_none" );

	setDvar( "class_specops_primary", "ak74u" );
	setDvar( "class_specops_secondary", "deserteagle" );
	setDvar( "class_specops_grenade", "smoke_grenade" );
	setDvar( "class_specops_camo", "camo_none" );

	setDvar( "class_demolitions_primary", "winchester1200" );
	setDvar( "class_demolitions_secondary", "deserteagle" );
	setDvar( "class_demolitions_grenade", "smoke_grenade" );
	setDvar( "class_demolitions_camo", "camo_none" );

	setDvar( "class_sniper_primary", "m40a3" );
	setDvar( "class_sniper_secondary", "deserteagle" );
	setDvar( "class_sniper_grenade", "smoke_grenade" );
	setDvar( "class_sniper_camo", "camo_none" );

	setDvar( "scr_team_fftype", 1 );
	setDvar( "scr_player_forcerespawn", 1 );

	setDvar( "bg_fallDamageMinHeight", 140 );
	setDvar( "bg_fallDamageMaxHeight", 350 );

	setDvar( "scr_game_matchstarttime", 10 );
	setDvar( "scr_enable_hiticon", 2 );
	setDvar( "scr_enable_scoretext", 1 );

	setDvar( "g_inactivity", 0 );
	setDvar( "g_no_script_spam", 1 );
	setDvar( "g_antilag", 1 );
	setDvar( "g_smoothClients", 1 );
	setDvar( "sv_allowDownload", 1 );
	setDvar( "sv_maxPing", 0 );
	setDvar( "sv_minPing", 0 );
	setDvar( "sv_reconnectlimit", 3 );
	setDvar( "sv_timeout", 240 );
	setDvar( "sv_zombietime", 2 );
	setDvar( "sv_floodprotect", 4 );
	setDvar( "sv_clientarchive", 1 );
	setDvar( "timescale", 1 );
}