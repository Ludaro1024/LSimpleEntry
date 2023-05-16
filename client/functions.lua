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
        json.encode(input) -- den Table ausgeben
      else
        print(input) -- den Input ausgeben
      end
    end
  end
  RegisterNetEvent('esx:playerLoaded')
AddEventHandler('esx:playerLoaded', function(playerdata)
    TriggerServerEvent("Lentry:CheckEntry", playerdata, source)
end)


RegisterNetEvent('esx:onPlayerLogout')
AddEventHandler('esx:onPlayerLogout', function()
    TriggerServerEvent("Lentry:Reset")
end)

