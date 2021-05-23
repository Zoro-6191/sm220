#include maps\mp\_utility;
init(){
	game["menu_team"]="team_marinesopfor";if(game["attackers"]=="axis" && game["defenders"]=="allies")game["menu_team"]+="_flipped";
	game["menu_class_allies"]="class_marines";game["menu_changeclass_allies"]="changeclass_marines_mw";
	game["menu_class_axis"]="class_opfor";game["menu_changeclass_axis"]="changeclass_opfor_mw";game["menu_class"]="class";game["menu_changeclass"]="changeclass_mw";
	game["menu_changeclass_offline"]="changeclass_offline";game["menu_shoutcast"]="shoutcast";game["menu_quickcommands"]="quickcommands";game["menu_quickstatements"]="quickstatements";
	game["menu_quickresponses"]="quickresponses";game["menu_quickpromod"]="quickpromod";game["menu_quickpromodgfx"]="quickpromodgfx";game["menu_demo"]="demo";
	precacheMenu("quickcommands");precacheMenu("quickstatements");precacheMenu("quickresponses");precacheMenu("quickpromod");
	precacheMenu("quickpromodgfx");precacheMenu("scoreboard");precacheMenu(game["menu_team"]);precacheMenu("class_marines");
	precacheMenu("changeclass_marines_mw");precacheMenu("class_opfor");precacheMenu("changeclass_opfor_mw");precacheMenu("class");
	precacheMenu("changeclass_mw");precacheMenu("changeclass_offline");precacheMenu("shoutcast");precacheMenu("echo");
	precacheMenu("demo");precacheMenu("filmtweak");
	level thread onPlayerConnect();
}onPlayerConnect(){for(;;){level waittill("connecting",player);player thread onMenuResponse();}}
onMenuResponse(){
	level endon("restarting");self endon("disconnect");
	for(;;){
		self waittill("menuresponse",menu,response);
		if(!isDefined(self.pers["team"]))continue;
		if(getSubStr(response,0,7)=="loadout"){self maps\mp\gametypes\_promod::processLoadoutResponse(response);continue;}
		switch(response){
			case "back":
				if(self.pers["team"]=="none")continue;
				if(menu==game["menu_changeclass"] &&(self.pers["team"]=="axis"||self.pers["team"]=="allies")){
					if(isDefined(self.pers["class"])){self maps\mp\gametypes\_promod::setClassChoice(self.pers["class"]);self maps\mp\gametypes\_promod::menuAcceptClass("go");}
					self openMenu(game["menu_changeclass_"+self.pers["team"]]);
				}else{self closeMenu();self closeInGameMenu();}continue;
			case "demo":if(menu=="demo")self.inrecmenu=false;continue;
			case "changeteam":self closeMenu();self closeInGameMenu();self openMenu(game["menu_team"]);continue;
			case "changeclass_marines":case "changeclass_opfor":if(self.pers["team"]=="axis"||self.pers["team"]=="allies"){self closeMenu();self closeInGameMenu();self openMenu(game["menu_changeclass_"+self.pers["team"]]);}continue;
			case "ping":self thread pingRightNow();break;
		}
		switch(menu){
			case "echo":k=strtok(response,"_");buf=k[0];for(i=1;i<k.size;i++)buf+=" "+k[i];self iprintln(buf);continue;
			case "team_marinesopfor":case "team_marinesopfor_flipped":
				switch(response){
					case "allies":self [[level.allies]]();break;
					case "axis":self [[level.axis]]();break;
					case "autoassign":self [[level.autoassign]]();break;
					case "shoutcast":self [[level.spectator]]();break;
				}continue;
			case "changeclass_marines_mw":case "changeclass_opfor_mw":
				if(response=="killspec"){self [[level.killspec]]();continue;}
				if(maps\mp\gametypes\_quickmessages::chooseClassName(response)==""||!self maps\mp\gametypes\_promod::verifyClassChoice(self.pers["team"],response))continue;
				self maps\mp\gametypes\_promod::setClassChoice(response);self closeMenu();self closeInGameMenu();self openMenu(game["menu_changeclass"]);continue;
			case "changeclass_mw":self maps\mp\gametypes\_promod::menuAcceptClass(response);continue;
			case "quickcommands":case "quickstatements":case "quickresponses":maps\mp\gametypes\_quickmessages::doQuickMessage(menu,int(response)-1);continue;
			case "quickpromod":maps\mp\gametypes\_quickmessages::quickpromod(response);continue;
			case "quickpromodgfx":maps\mp\gametypes\_quickmessages::quickpromodgfx(response);continue;
		}
	}
}
pingRightNow(){
	self endon("disconnect");if(!isAlive(self)||self.pinged)return;angles=self getPlayerAngles();eye=self getTagOrigin("j_head");forward=eye + vector_scale(anglesToForward(angles),4000);trace=bulletTrace(eye,forward,false,self);
	if(trace["fraction"]==1)return;pingloc=trace["position"]-vector_scale(anglesToForward(angles),50);self.pinged=true;
	pinghud=newTeamHudElem(self.pers["team"]);
	pinghud setShader("headicon_dead",2,2);
	pinghud setwaypoint(true);
	pinghud.x=pingloc[0];pinghud.y=pingloc[1];pinghud.z=pingloc[2]+10;	
	pinghud.color=(1,1,1);
	a=0.8;
	pinghud.alpha=a;wait 0.05;
	pinghud.alpha=0;wait 0.05;
	pinghud.alpha=a;wait 0.05;
	pinghud.alpha=0;wait 0.05;
	pinghud.alpha=a;wait 1;
	pinghud fadeovertime(0.2);
	pinghud.alpha=0;wait 0.2;pinghud destroy();self pingPlayer();
	//self playSound("impinging"); // buggy
	wait 0.3;self.pinged=false;
}