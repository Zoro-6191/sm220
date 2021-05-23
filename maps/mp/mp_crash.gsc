main(){maps\mp\_load::main();maps\mp\_compass::setupMiniMap("compass_map_mp_crash");game["allies"]="marines";game["axis"]="opfor";game["attackers"]="allies";game["defenders"]="axis";game["allies_soldiertype"]="desert";game["axis_soldiertype"]="desert";level.sunlight=1.3;
	allyfix=spawn("trigger_radius",( -239, -97, 135 ),10,10,6);
	allyfix setContents(1);
	a_fix=spawn("trigger_radius",( 1378, 39, 115 ),10,10,7);
	a_fix setContents(1);
}