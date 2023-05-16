Config = {}
Config.Debug = true
Config.Refreshtime = 1000
Config.SpawnCoords = vector3(-31.4741, -580.2321, 83.9076)
Config.Range = 10
Config.AllowedGroups = {"admin", "owner"}
Config.SetCommand = "einreise"
Config.GetCommand = { jobs = {"police", "sherriff"}, groups = {"superadmin", "admin"}, name = "geteinreise"}


Config.Locale = "de" -- de or en
Translation = {
        ['de'] = {
            ['NoPermission'] = "Dafür hast du nicht die rechte",
            ['TPback'] = "Du wurdest zum Eingangspunkt teleportiert",
            ['NoArgs1'] = "Du musst eine Spieler ID angeben",
            ['NoArgs2'] = "Du musst eine Eingangslevel angeben (0-3)",
            ['getentry'] = "Für diese person ist die Einreise auf Level: "
        },
        ['en'] = {
            ['NoPermission'] = "Yo dont have the permission for that",
            ['TPback'] = "You have been teleported back to the entry point",
            ['NoArgs1'] = "You need to specify a player id",
            ['NoArgs2'] = "You need to specify a entry level (0-3)",
            ['getentry'] = "for this person the entry level is: "

        }
}

-- for any script that needs to use the entry levels, the script automaticly adds statebags to every player upon restarting the script and upon a player joining /resetting it on leave 
-- the script also teleports players back to the entry point if they are too far away from it
