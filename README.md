# sm220
If you just want a minimalistic mod to play scrims on, this is the one for you.

# Major Changes:
- **Fixed smoke cheat** through ambient occlusion.
- Fixed prone animation glitch, where 1st and 3rd person perspectives are out of sync, giving player an advantage.
- **Pinging** or Marking feature added, aimed to be improved later on, if it's any useful, which I imagine could be game-changing in cod4.
- **Auto screenshot** feature added, off by default, configured in server.cfg. Can be turned on/off mid-game using `rcon sm_auto_screenshot 1` or `0`. v17 is also supported via punkbuster.
- Added **Killfeed Options** and **Chat Options** in "Game Options".
- New **Filmtweak Options** since there's always a struggle for good tweaks in promod, easier make what suits prople more freely.

You won't feel any difference while playing, it'll only be smoother, and hitreg is noticably better.
Bad hitreg was the only thing which inspired me to make this mod.
It's still far from perfect but should feel better than before.

# Here are all the code changes:

- Removed scorebot.
- Removed everything related to killcam.
- Removed all promod modes including strat mode, except `match|knockout_mr#` and `match|knockout_mr#_pb`, default being `knockout_mr12_pb`.
- Removed sabotage and domination gametypes.
- Removed non-promod map files from mod, done to reduce size.
- Removed excess hud elems from hud.menu. This should help in more stable fps.
- Removed constant dvar checking from promod/dvarmon.gsc.
- Removed everything related to silencers.
- Removed everything related to in-game voice.
- Removed wave mechanic.
- Removed all logging( connect, plant, defuse, damage, kill, disconnect ).
- Removed shoutcaster setup, shoutcaster map, shoutcaster binds and shoutcaster healthbar.
- Removed top and bottom gradients from all menus, looks cleaner. I know I'm nitpicking at this point.
- Fixed the glitch where playermodels glitch after round has ended and player suicides.
- Fixed mp_crash ally and A-back prone glitches.
- Fixed prone glitch where animation is much slower than actual player, 3rd person compared to 1st person.
- Changed TEAM_FREE and shoutcaster scoreboard colors. Previous ones were ugly. Made shoutcaster color stand out a bit.
- Cleared the area around minimap and removed tickertape. Never heard of people using tickertape in matches.
- Re-edited `Callback_PlayerDamage()` and `Callback_PlayerKilled()` in maps/mp/gametypes/_globallogic.gsc.
- Demo record reminder is disabled by default.
- Scoreboard top bar only shows gametype instead of win or lose status.
- Added `g_friendlyPlayerCanBlock` in server.cfg, a cod4x command, 1 = teammates can block. Anti-block enabled by default.
- Added "Reconnect" option when player gets killed.
- Added build date on connect.menu.
- Added credits in class.menu and main.menu.
- Changed button HIGHLIGHT_SHADER to "gradient_fadein" in all menus.
- Fixed smoke cheat through ambient occlusion.
- Weapon limits are now controlled by hardcode and not dvars, and are not limited in killhouse and shipment. This was done to fix a glitch.
- Clicking on Options directly opens Game Options

# Future Updates might include:

- Removal of filmtweak settings.
- Improvement of Pinging or Marking.

Sorry about code being messy, had to do it to save few KBs of space.

My discord: Zoro#6191