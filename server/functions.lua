if (GetResourceState("es_extended") == "started") then
    if (exports["es_extended"] and exports["es_extended"].getSharedObject) then
        ESX = exports["es_extended"]:getSharedObject()
    else
        TriggerEvent("esx:getSharedObject", function(obj) ESX = obj end)
    end
end


function debug(input)
    if Config.Debug then -- prüfen, ob Config.Debug wahr ist
      if type(input) == "table" then -- prüfen, ob der Input ein Table ist
        print("[Lentry-Debug] ".. json.encode(input)) -- den Table ausgeben
      else
        print( "[Lentry-Debug] ".. input) -- den Input ausgeben
      end
    end
  end

  function updateid(source)
    local xPlayer = ESX.GetPlayerFromId(source)
        if xPlayer then
            MySQL.single('SELECT * FROM users WHERE identifier = ?', {xPlayer.getIdentifier()}, function(result)
                if result then
                    Player(source).state.entry = result.entry
                    debug("setting statebag for the id " .. source .. " to the entry "  .. result.entry .. "")
                    if result.entry == 0 then
                        debug("adding" .. tostring(source) .. "to the list of people who have entry 0 and need to be teleported")
                        table.insert(entry0players, source)
                end
            end
            end)
        else
            debug("Lentry: Error: Player is not in the database!")
        end
end

  for _, playerId in ipairs(GetPlayers()) do
            updateid(playerId)
end
 

  entry0players = {}

  RegisterNetEvent('Lentry:CheckEntry')
  AddEventHandler('Lentry:CheckEntry', function(playerdata)
    debug("checkentry")
    src = source
    identifier = playerdata.identifier
      debug("Player joined! with the id " .. src .. " spawned!")
      local result = MySQL.single.await('SELECT * FROM users WHERE identifier = ?', {identifier})
        if result then
            debug("entry row works fine. :) sql is there")
            debug("entry row is " .. result.entry .. "for the id " .. src .. "")
            debug("setting statebag for the id" .. src)
            ply = Player(src).state
            ply.entry = result.entry
            if result.entry == 0 then
                debug("adding" .. tostring(src) .. "to the list of people who have entry 0 and need to be teleported")
                table.insert(entry0players, src)
        else
            print("LENTRY SQL ISNT THERE HELPP!!!!")
        end
    end
      
  end)
  function valueintable(t, value)
    for k, v in pairs(t) do
      if v == value then
        return true
      end
    end
    return false
  end

RegisterNetEvent('Lentry:Reset')
AddEventHandler('Lentry:Reset', function()
    src = source
   debug("resetting statebag (for multichar purposes)")
   ply = Player(src).state
    ply.entry = nil
    if valueintable(src, entry0players) then
    table.remove(entry0players, src)
    end
end)

  MySQL.ready(function () 
    local result = MySQL.single.await('SELECT * FROM users', {})
    if result and result.entry then
        debug("entry row works fine. :) sql is there")
    else
        print("LENTRY SQL ISNT THERE HELPP!!!!")
        local create = MySQL.query.await('ALTER TABLE USERS ADD entry INT DEFAULT 0;', {})
        debug(create)
        debug("created the entry row in sql")
    end

  end)

 

  function setentry(id, entry)
    result = MySQL.query.await('UPDATE users SET entry = ? WHERE identifier = ?', {entry, id})
    debug("set entry to " .. entry .. " for the id " .. id .. "")
    if valueintable(id, entry0players) and entry ~= 0 then
        table.remove(entry0players, id)
        debug("removed " .. id .. " from the list of people who have entry 0 and need to be teleported")
    end
  end
  function getentry(id)
    result = MySQL.single.await('SELECT * FROM users WHERE identifier = ?', {id})
    debug("get entry for the id " .. id .. " is " .. result.entry .. "")  
    return result.entry
  end
  function removefrom0(id)
    if valueintable(id, entry0players) then
        table.remove(entry0players, id)
        debug("removed " .. id .. " from the list of people who have entry 0 and need to be teleported")
    end
  end
  

  Citizen.CreateThread(function()
    while true do
        Citizen.Wait(Config.Refreshtime)
        for k,v in pairs(entry0players) do
            if Player(v) then
                if Player(v).state then
                    if Player(v).state.entry then
                        if Player(v).state.entry == 0 then
                            debug(#(GetEntityCoords(GetPlayerPed(v)) - Config.SpawnCoords))
                            if #(GetEntityCoords(GetPlayerPed(v)) - Config.SpawnCoords) >= Config.Range then
                                debug("teleporting " .. tostring(v) .. " to the entry point")
                            local xPlayer = ESX.GetPlayerFromId(v)
                            xPlayer.showNotification(Translation[Config.Locale]["TPback"])
                            SetEntityCoords(GetPlayerPed(v), Config.SpawnCoords)
                            end
                    end
                    end
                end
            end
        end
    end
  end)

RegisterCommand(Config.SetCommand, function(source, args, rawCommand)
    local xPlayer = ESX.GetPlayerFromId(source) 
    if valueintable(Config.AllowedGroups, xPlayer.getGroup()) then
        if args[1] then
            if args[2] then
                setentry(args[1], args[2])
            else
                xPlayer.showNotification(Translation[Config.Locale]["NoArgs2"])
            end
        else
            xPlayer.showNotification(Translation[Config.Locale]["NoArgs1"])
        end
    else
        xPlayer.showNotification(Translation[Config.Locale]["NoPermission"])
    end
end)

RegisterCommand(Config.GetCommand.name, function(source, args, rawCommand)
    local xPlayer = ESX.GetPlayerFromId(source)
    if valueintable(Config.GetCommand.jobs, xPlayer.getJob()) or valueintable(Config.GetCommand.groups, xPlayer.getGroup())  then
        if args[1] then
            xPlayer.showNotification(Translation[Config.Locale]["getentry"]..getentry(args[1])) 
        else
            xPlayer.showNotification(Translation[Config.Locale]["NoArgs1"])
        end
    else
        xPlayer.showNotification(Translation[Config.Locale]["NoPermission"])
    end
end)