# sm220
Scrim Promod based on pml220, free to use for everyone.

Major Fixes:
- Fixed smoke cheat through ambient occlusion.

You won't feel any difference in frontend, it'll only be smoother

Here are all the code changes:

- Removed scorebot
- Removed everything related to killcam
- Removed all promod modes including strat mode, except match_mr# and match_mr#_pb, will be adding knockout back in future though.
- Removed sabotage and domination gametypes
- Removed excess hud elems from hud.menu
- Removed constant dvar checking from promod/dvarmon.gsc
- Removed everything related to silencers
- Re-edited Callback_PlayerDamage() and Callback_PlayerKilled() in maps/mp/gametypes/_globallogic.gsc
- Removed shoutcaster setup, shoutcaster map, shoutcaster binds and shoutcaster healthbar
- Scoreboard top bar only shows gametype instead of win or lose status
- Added build date on connect.menu
- Added my name in class.menu

For any sort of queries,
my discord: Zoro#6191