main()
{
	mode = toLower( getDvar( "promod_mode" ) );
	if ( !validMode( mode ) )
	{
		mode = "match_mr12_pb";
		setDvar( "promod_mode", mode );
	}

	setMode(mode);
}

validMode( mode )
{
	switch ( mode )
	{
		case "match":
			return true;
	}

	keys = strtok(mode, "_");
	if(keys.size <= 1)
		return false;
	switches = [];
	switches["mr_done"] = false;
	switches["scores_done"] = false;
	switches["match_knockout"] = false;
	switches["lan_pb"] = false;

	for(i=0;i<keys.size;i++)
	{
		switch(keys[i])
		{
			case "match":
				if(switches["match_knockout"])
					return false;
				switches["match_knockout"] = true;
				break;
			case "pb":
				if(switches["lan_pb"])
					return false;
				switches["lan_pb"] = true;
				break;
			default:
				if(keys[i] != "mr" && isSubStr(keys[i],"mr") && "mr"+int(strtok(keys[i], "mr")[0]) == keys[i] && int(strtok(keys[i], "mr")[0]) > 0 && !switches["mr_done"])
					switches["mr_done"] = true;
				else if ( ( isSubStr( keys[i], ":" ) ) && strtok( keys[i], ":" ).size == 2 && int(strtok( keys[i], ":" )[0]) >= 0 && int(strtok( keys[i], ":" )[1]) >= 0 && !switches["scores_done"] )
					switches["scores_done"] = true;
				else return false;
				break;
		}
	}
	return switches["match_knockout"];
}

monitorMode()
{
	o_mode = toLower( getDvar( "promod_mode" ) );

	for(;;)
	{
		mode = toLower( getDvar( "promod_mode" ) );
		cheats = getDvarInt( "sv_cheats" );

		if ( mode != o_mode )
		{
			if ( isDefined( game["state"] ) && game["state"] == "postgame" )
			{
				setDvar( "promod_mode", o_mode );
				continue;
			}

			if ( validMode( mode ) )
			{
				level notify ( "restarting" );

				iPrintLN( "Changing To Mode: ^1" + mode + "\nPlease Wait While It Loads..." );
				setMode( mode );

				wait 2;

				map_restart( false );
				setDvar( "promod_mode", mode );
			}
			else
			{
				if ( isDefined( mode ) && mode != "" )
					iPrintLN( "Error Changing To Mode: ^1" + mode + "\nSyntax: match_mr12, match_mr12_pb, match_mr12_#:#" );

				setDvar( "promod_mode", o_mode );
			}
		}
		wait 0.1;
	}
}

setMode( mode )
{
	knockout_mode = 0;
	mr_rating = 0;

	game["CUSTOM_MODE"] = 0;
	game["LAN_MODE"] = 0;
	game["HARDCORE_MODE"] = 0;
	game["PROMOD_STRATTIME"] = 6;
	game["PROMOD_MODE_HUD"] = "";
	game["PROMOD_MATCH_MODE"] = "";
	game["PROMOD_PB_OFF"] = 0;
	game["PROMOD_KNIFEROUND"] = 0;
	game["SCORES_ATTACK"] = 0;
	game["SCORES_DEFENCE"] = 0;

	if ( game["PROMOD_MATCH_MODE"] == "" )
	{
		exploded = StrTok( mode, "_" );
		for ( i = 0; i < exploded.size; i++ )
		{
			switch(exploded[i])
			{
				case "match":
					game["PROMOD_MATCH_MODE"] = "match";
					break;
				case "pb":
					game["PROMOD_PB_OFF"] = 1;
					break;
				default:
					if ( isSubStr( exploded[i], "mr" ) )
						mr_rating = int(strtok(exploded[i], "mr")[0]);
					else if ( isSubStr( exploded[i], ":" ) )
					{
						game["SCORES_ATTACK"] = int(strtok( exploded[i], ":" )[0]);
						game["SCORES_DEFENCE"] = int(strtok( exploded[i], ":" )[1]);
					}
					break;
			}
		}
	}

	if ( game["PROMOD_MATCH_MODE"] == "match" )
		promod\comp::main();

	if ( game["PROMOD_MATCH_MODE"] == "match" )
		game["PROMOD_MODE_HUD"] += "^4Match";

	maxscore = 0;
	if ( mr_rating > 0 && level.gametype == "sd" )
	{
		maxscore = mr_rating * ( 2 - 1 * knockout_mode ) + ( - 1 * !knockout_mode );

		game["PROMOD_MODE_HUD"] += " " + "^3MR" + mr_rating;

		setDvar( "scr_" + level.gametype + "_roundswitch", mr_rating );
		setDvar( "scr_" + level.gametype + "_roundlimit", mr_rating * 2 );

		if ( knockout_mode && level.gametype == "sd" )
			setDvar( "scr_sd_scorelimit", mr_rating + 1 );
	}
	else if ( game["PROMOD_MATCH_MODE"] == "match" )
	{
		game["PROMOD_MODE_HUD"] += " ^3Standard";
		mr_rating = 10;
		maxscore = mr_rating * ( 2 - 1 * knockout_mode ) + ( - 1 * !knockout_mode );
	}

	if ( level.gametype != "sd" || !knockout_mode && game["SCORES_ATTACK"] + game["SCORES_DEFENCE"] > maxscore || knockout_mode && ( ( game["SCORES_ATTACK"] > maxscore || game["SCORES_DEFENCE"] > maxscore ) || ( game["SCORES_ATTACK"] + game["SCORES_DEFENCE"] >= int( mr_rating ) * 2 ) ) )
	{
		game["SCORES_ATTACK"] = 0;
		game["SCORES_DEFENCE"] = 0;
	}

	if( game["PROMOD_PB_OFF"] && getDvarInt( "sv_cheats" ) && !getDvarInt( "sv_punkbuster" ) )
		game["PROMOD_MODE_HUD"] += " ^1PB: OFF & CHEATS";
	else if( game["PROMOD_PB_OFF"] && !getDvarInt( "sv_punkbuster" ) )
		game["PROMOD_MODE_HUD"] += " ^1PB: OFF";

	if(level.gametype != "sd")
		game["PROMOD_KNIFEROUND"] = 0;
}