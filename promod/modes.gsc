main(){mode=toLower(getDvar("promod_mode"));if(!validMode(mode)){mode="knockout_mr12_pb";setDvar("promod_mode",mode);}setMode(mode);}
validMode(mode){
	switch(mode){case "match":case "knockout":return true;}
	keys=strtok(mode,"_");if(keys.size<=1)return false;switches=[];switches["match_knockout"]=false;switches["lan_pb"]=false;switches["knife_done"]=false;switches["mr_done"]=false;switches["scores_done"]=false;
	for(i=0;i<keys.size;i++){
		switch(keys[i]){
			case "match":
			case "knockout":
				if(switches["match_knockout"])
					return false;
				switches["match_knockout"]=true;
				break;
			case "lan":
			case "pb":
				if(switches["lan_pb"])
					return false;
				switches["lan_pb"]=true;
				break;
			case "knife":
				if(switches["scores_done"]) return false;
			default:
				if(keys[i] != "mr"&&isSubStr(keys[i],"mr")&&"mr"+int(strtok(keys[i],"mr")[0])==keys[i]&&int(strtok(keys[i],"mr")[0]) > 0&&!switches["mr_done"])
					switches["mr_done"]=true;
				else if((isSubStr(keys[i],":"))&&strtok(keys[i],":").size==2&&int(strtok(keys[i],":")[0]) >= 0&&int(strtok(keys[i],":")[1]) >= 0&&!switches["scores_done"]&&!switches["knife_done"])
					switches["scores_done"]=true;
				else return false;
				break;
		}
	}return switches["match_knockout"];
}
monitorMode(){
	o_mode=toLower(getDvar("promod_mode"));
	for(;;){
		mode=toLower(getDvar("promod_mode"));
		if(mode != o_mode){
			if(isDefined(game["state"])&& game["state"]=="postgame"){setDvar("promod_mode",o_mode);continue;}
			if(validMode(mode)){level notify("restarting");iPrintLN("Changing To Mode: ^1"+mode+"\nPlease Wait While It Loads...");setMode(mode);wait 2;map_restart(false);setDvar("promod_mode",mode);}
			else if(isDefined(mode)&& mode != "")iPrintLN("Error Changing To Mode: ^1"+mode+"\nSyntax: match|knockout_mr#_#:#");setDvar("promod_mode",o_mode);
		}wait 0.1;
	}
}
setMode(mode){
	limited_mode=0;knockout_mode=0;mr_rating=0;
	game["PROMOD_STRATTIME"]=6;game["PROMOD_MODE_HUD"]="";game["PROMOD_MATCH_MODE"]="";game["PROMOD_PB_OFF"]=0;game["PROMOD_KNIFEROUND"]=0;game["SCORES_ATTACK"]=0;game["SCORES_DEFENCE"]=0;
	if(game["PROMOD_MATCH_MODE"]==""){
		exploded=StrTok(mode,"_");
		for(i=0;i<exploded.size;i++){
			switch(exploded[i]){
				case "match":game["PROMOD_MATCH_MODE"]="match";break;
				case "knockout":knockout_mode=1;game["PROMOD_MATCH_MODE"]="match";break;
				case "knife":game["PROMOD_KNIFEROUND"]=1;break;
				case "pb":game["PROMOD_PB_OFF"]=1;break;
				default:
					if(isSubStr(exploded[i],"mr"))mr_rating=int(strtok(exploded[i],"mr")[0]);
					else if(isSubStr(exploded[i],":")){game["SCORES_ATTACK"]=int(strtok(exploded[i],":")[0]);game["SCORES_DEFENCE"]=int(strtok(exploded[i],":")[1]);}
					break;
			}
		}
	}if(game["PROMOD_MATCH_MODE"]=="match")promod\comp::main();
	if(knockout_mode&&!mr_rating)mr_rating=10;
	if(limited_mode){setDvar("class_demolitions_limit",0);setDvar("class_sniper_limit",0);game["PROMOD_MODE_HUD"]+="^2"+limited_mode+"V"+limited_mode+" ";}
	if(knockout_mode)game["PROMOD_MODE_HUD"]+="^4Knockout";else if(game["PROMOD_MATCH_MODE"]=="match")game["PROMOD_MODE_HUD"]+="^4Match";
	if(game["PROMOD_KNIFEROUND"]&&game["PROMOD_MATCH_MODE"]=="match"&&level.gametype=="sd")game["PROMOD_MODE_HUD"]+=" ^5Knife";maxscore=0;
	if(mr_rating>0&&level.gametype=="sd"){
		maxscore=mr_rating *(2 - 1*knockout_mode)+(- 1*!knockout_mode);game["PROMOD_MODE_HUD"]+=" "+"^3MR"+mr_rating;
		setDvar("scr_"+level.gametype+"_roundswitch",mr_rating);setDvar("scr_"+level.gametype+"_roundlimit",mr_rating*2);
		if(knockout_mode&&level.gametype=="sd")setDvar("scr_sd_scorelimit",mr_rating+1);
	}
	else if(game["PROMOD_MATCH_MODE"]=="match"){game["PROMOD_MODE_HUD"]+=" ^3Standard";mr_rating=10;maxscore=mr_rating *(2 - 1*knockout_mode)+(- 1*!knockout_mode);}

	if(level.gametype != "sd"||!knockout_mode&&game["SCORES_ATTACK"]+game["SCORES_DEFENCE"] > maxscore||knockout_mode &&((game["SCORES_ATTACK"] > maxscore||game["SCORES_DEFENCE"] > maxscore)||(game["SCORES_ATTACK"]+game["SCORES_DEFENCE"] >= int(mr_rating)* 2))){
		game["SCORES_ATTACK"]=0;game["SCORES_DEFENCE"]=0;}

	if(game["PROMOD_PB_OFF"]&&getDvarInt("sv_cheats")&&!getDvarInt("sv_punkbuster"))game["PROMOD_MODE_HUD"]+=" ^1PB: OFF & CHEATS";
	else if(game["PROMOD_PB_OFF"]&&!getDvarInt("sv_punkbuster"))game["PROMOD_MODE_HUD"]+=" ^1PB: OFF";
	else if(getDvarInt("sv_cheats"))game["PROMOD_MODE_HUD"]+=" ^1CHEATS";
	if(level.gametype != "sd")game["PROMOD_KNIFEROUND"]=0;
}