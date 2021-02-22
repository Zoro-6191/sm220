init()
{
	precacheItem( "ak47_mp" );
	precacheItem( "ak74u_mp" );
	precacheItem( "beretta_mp" );
	precacheItem( "colt45_mp" );
	precacheItem( "deserteagle_mp" );
	precacheItem( "deserteaglegold_mp" );
	precacheItem( "frag_grenade_mp" );
	precacheItem( "g3_mp" );
	precacheItem( "g36c_mp" );
	precacheItem( "m4_mp" );
	precacheItem( "m14_mp" );
	precacheItem( "m16_mp" );
	precacheItem( "m40a3_mp" );
	precacheItem( "m1014_mp" );
	precacheItem( "mp5_mp" );
	precacheItem( "mp44_mp" );
	precacheItem( "remington700_mp" );
	precacheItem( "usp_mp" );
	precacheItem( "uzi_mp" );
	precacheItem( "uzi_silencer_mp" );
	precacheItem( "winchester1200_mp" );
	precacheItem( "smoke_grenade_mp" );
	precacheItem( "flash_grenade_mp" );
	precacheItem( "destructible_car" );
	precacheShellShock( "default" );
	thread maps\mp\_flashgrenades::main();
	level thread onPlayerConnect();
}

onPlayerConnect()
{
	for(;;)
	{
		level waittill("connecting", player);
		player thread onPlayerSpawned();
	}
}

onPlayerSpawned()
{
	self endon("disconnect");
	for(;;)
	{
		self waittill("spawned_player");

		self.hasDoneCombat = false;
		self thread watchWeaponUsage();
		self thread watchGrenadeUsage();
		self thread watchGrenadeAmmo();
	}
}

watchGrenadeAmmo()
{
	self endon("death");
	self endon("disconnect");
	self endon("game_ended");
	prim = true;
	sec = true;
	while(prim || sec)
	{
		self waittill("grenade_fire");
		if( isDefined( game["promod_do_readyup"] ) && game["promod_do_readyup"] )
			break;
		wait 0.25;
		pg = "";
		if(self hasWeapon("frag_grenade_mp"))
			pg = "frag_grenade_mp";
		else prim = false;
		sg = "";
		if(self hasWeapon("flash_grenade_mp"))
			sg = "flash_grenade_mp";
		else if(self hasWeapon("smoke_grenade_mp"))
			sg = "smoke_grenade_mp";
		else sec = false;
		if(prim && pg != "" && self GetAmmoCount(pg) < 1)
		{
			self TakeWeapon(pg);
			prim = false;
		}
		if(sec && sg != "" && self GetAmmoCount(sg) < 1)
		{
			self TakeWeapon(sg);
			sec = false;
		}
	}
}

dropWeaponForDeath( attacker )
{
	weapon = self getCurrentWeapon();
	if ( !isDefined( weapon ) || !self hasWeapon( weapon ) )
		return;
	switch ( weapon )
	{
		case "m16_mp":
		case "m16_silencer_mp":
		case "ak47_mp":
		case "ak47_silencer_mp":
		case "m4_mp":
		case "m4_silencer_mp":
		case "g3_mp":
		case "g3_silencer_mp":
		case "g36c_mp":
		case "g36c_silencer_mp":
		case "m14_mp":
		case "m14_silencer_mp":
		case "mp44_mp":
			if ( !getDvarInt( "class_assault_allowdrop" ) )
				return;
			break;
		case "mp5_mp":
		case "mp5_silencer_mp":
		case "uzi_mp":
		case "uzi_silencer_mp":
		case "ak74u_mp":
		case "ak74u_silencer_mp":
			if ( !getDvarInt( "class_specops_allowdrop" ) )
				return;
			break;
		case "m40a3_mp":
		case "remington700_mp":
			if ( !getDvarInt( "class_sniper_allowdrop" ) )
				return;
			break;
		case "winchester1200_mp":
		case "m1014_mp":
			if ( !getDvarInt( "class_demolitions_allowdrop" ) )
				return;
			break;
		default:
			return;
	}
	clipAmmo = self GetWeaponAmmoClip( weapon );
	if ( !clipAmmo )
		return;
	stockAmmo = self GetWeaponAmmoStock( weapon );
	stockMax = WeaponMaxAmmo( weapon );
	if ( stockAmmo > stockMax )
		stockAmmo = stockMax;
	item = self dropItem( weapon );
	item ItemWeaponSetAmmo( clipAmmo, stockAmmo );
	if( game["promod_do_readyup"] )
		item thread deletePickupAfterAWhile();
}

deletePickupAfterAWhile()
{
	self endon("death");
	wait 180;
	if ( !isDefined( self ) )
		return;
	self delete();
}

watchWeaponUsage()
{
	self endon( "death" );
	self endon( "disconnect" );
	level endon ( "game_ended" );
	self waittill ( "begin_firing" );
	self.hasDoneCombat = true;
}

watchGrenadeUsage()
{
	self endon( "death" );
	self endon( "disconnect" );
	self.throwingGrenade = false;
	for(;;)
	{
		self waittill ( "grenade_pullback", weaponName );

		self.hasDoneCombat = true;
		self.throwingGrenade = true;
		self beginGrenadeTracking();
	}
}

beginGrenadeTracking()
{
	self endon ( "death" );
	self endon ( "disconnect" );
	self waittill ( "grenade_fire", grenade, weaponName );
	if ( weaponName == "frag_grenade_mp" )
		grenade thread maps\mp\gametypes\_shellshock::grenade_earthQuake();
	self.throwingGrenade = false;
}

onWeaponDamage( eInflictor, sWeapon, meansOfDeath, damage )
{
	self endon ( "death" );
	self endon ( "disconnect" );
	maps\mp\gametypes\_shellshock::shellshockOnDamage( meansOfDeath, damage );
}