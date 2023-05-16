# LSIMPLEENTRY
for any script that needs to use the entry levels, the script automaticly adds statebags to every player upon restarting the script and upon a player joining /resetting it on leave 
the script also teleports players back to the entry point if they are too far away from it
the script also adds a command to set the entry level of a player
the script also adds a command to get the entry level of a player
to get the statebag and the entry of the player without doing anything with the sql you need to do the following (example):
lets say source is your playerid
```Player(source).state.entry```
thats it! :) and you got the entry of the player instantly. (statebogs only work server side)