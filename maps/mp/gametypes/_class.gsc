giveLoadout( team, class )
{
	self takeAllWeapons();

	self setClientDvar( "loadout_curclass", class );
	self.curClass = class;

	sidearmWeapon();
	primaryWeapon();

	if( !isDefined( level.strat_over ) || level.strat_over )
	{
		self giveWeapon( "frag_grenade_mp" );
		self setWeaponAmmoClip( "frag_grenade_mp", 1 );
		self switchToOffhand( "frag_grenade_mp" );
	}

	gren = self.pers[class]["loadout_grenade"];
	if( gren == "flash_grenade" || gren == "smoke_grenade" )  
	{
		self setOffhandSecondaryClass(GetSubStr(gren, 0, 5));
		if(!isDefined(level.strat_over) || level.strat_over)
		{
			self giveWeapon(gren+"_mp");
			self setWeaponAmmoClip(gren+"_mp", 1);
		}
	}

	self setMoveSpeedScale( ( 1.0 - 0.05 * int( class == "assault" ) ) * !int( isDefined( level.strat_over ) && !level.strat_over ) );
}

sidearmWeapon()
{
	class = self.pers["class"];
	sidearmWeapon = self.pers[class]["loadout_secondary"];

	if ( sidearmWeapon != "none" && sidearmWeapon != "deserteaglegold" && sidearmWeapon != "deserteagle" && sidearmWeapon != "colt45" && sidearmWeapon != "usp" && sidearmWeapon != "beretta" )
		sidearmWeapon = getDvar( "class_" + class + "_secondary" );

	if ( sideArmWeapon != "none" )
	{
		sidearmWeapon += "_mp";
		if ( isDefined( level.strat_over ) && level.strat_over || !isDefined( level.strat_over ) )
		{
			self giveWeapon( sidearmWeapon );
			self giveMaxAmmo( sidearmWeapon );
		}
	}
}

primaryWeapon()
{
	class = self.pers["class"];
	primaryWeapon = self.pers[class]["loadout_primary"];

	switch(primaryWeapon)
	{
		case "none":
		case "m16":
		case "ak47":
		case "m4":
		case "g3":
		case "g36c":
		case "m14":
		case "mp44":
		case "mp5":
		case "uzi":
		case "ak74u":
		case "winchester1200":
		case "m1014":
		case "m40a3":
		case "remington700":
			break;
		default:
			primaryWeapon = getDvar("class_"+class+"_primary");
	}

	camos = strtok("camo_brockhaurd|camo_bushdweller|camo_blackwhitemarpat|camo_tigerred|camo_stagger", "|");
	camonum = 0;

	if(isDefined(self.pers[class]["loadout_camo"]))
	{
		for(i=0;i<camos.size;i++)
			if(self.pers[class]["loadout_camo"] == camos[i])
			{
				camonum = i+1;
				break;
			}

		if(self.pers[class]["loadout_camo"] == "camo_gold" && (primaryWeapon == "ak47" || primaryWeapon == "uzi" || primaryWeapon == "m1014"))
			camonum = 6;
	}
	else self.pers[class]["loadout_camo"] = "camo_none";

	if(primaryWeapon != "none")
	{
		primaryWeapon += "_mp";
		self maps\mp\gametypes\_teams::playerModelForWeapon( self.pers[class]["loadout_primary"] );
		if ( isDefined( level.strat_over ) && level.strat_over || !isDefined( level.strat_over ) )
		{
			self giveWeapon( primaryWeapon, camonum );
			self setSpawnWeapon( primaryWeapon );
			self giveMaxAmmo( primaryWeapon );
		}
	}
}

preserveClass( class )
{
	CLASS_PRIMARY = "";
	CLASS_SECONDARY = "";
	CLASS_GRENADE = "";
	CLASS_CAMO = "";

	if ( class == "assault" )
	{
		CLASS_PRIMARY = "ASSAULT_PRIMARY";
		CLASS_SECONDARY = "ASSAULT_SECONDARY";
		CLASS_GRENADE = "ASSAULT_GRENADE";
		CLASS_CAMO = "ASSAULT_CAMO";
	}
	else if ( class == "specops" )
	{
		CLASS_PRIMARY = "SPECOPS_PRIMARY";
		CLASS_SECONDARY = "SPECOPS_SECONDARY";
		CLASS_GRENADE = "SPECOPS_GRENADE";
		CLASS_CAMO = "SPECOPS_CAMO";
	}
	else if ( class == "demolitions" )
	{
		CLASS_PRIMARY = "DEMOLITIONS_PRIMARY";
		CLASS_SECONDARY = "DEMOLITIONS_SECONDARY";
		CLASS_GRENADE = "DEMOLITIONS_GRENADE";
		CLASS_CAMO = "DEMOLITIONS_CAMO";
	}
	else if ( class == "sniper" )
	{
		CLASS_PRIMARY = "SNIPER_PRIMARY";
		CLASS_SECONDARY = "SNIPER_SECONDARY";
		CLASS_GRENADE = "SNIPER_GRENADE";
		CLASS_CAMO = "SNIPER_CAMO";
	}

	CLASS_PRIMARY_VALUE = int( tablelookup( "promod/customStatsTable.csv", 1, self.pers[class]["loadout_primary"], 0 ) );
	CLASS_SECONDARY_VALUE = int( tablelookup( "promod/customStatsTable.csv", 1, self.pers[class]["loadout_secondary"], 0 ) );
	CLASS_GRENADE_VALUE = int( tablelookup( "promod/customStatsTable.csv", 1, self.pers[class]["loadout_grenade"], 0 ) );
	CLASS_CAMO_VALUE = int( tablelookup( "promod/customStatsTable.csv", 1, self.pers[class]["loadout_camo"], 0 ) );

	self set_config( CLASS_PRIMARY, CLASS_PRIMARY_VALUE );
	self set_config( CLASS_SECONDARY, CLASS_SECONDARY_VALUE );
	self set_config( CLASS_GRENADE, CLASS_GRENADE_VALUE );
	self set_config( CLASS_CAMO, CLASS_CAMO_VALUE );
}

set_config( dataName, value )
{
	self setStat( int( tableLookup( "promod/customStatsTable.csv", 1, dataName, 0 ) ), value );
}