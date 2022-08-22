local CT = CreateThread
local TE = TriggerEvent
local TSE = TriggerServerEvent

local unutra = false

function hint(tipka, tekst)
  TE('notif:hint', tipka, tekst)
end


CT(function()
  for k,v in pairs(GlobalState.Apartmani) do
    local blip = AddBlipForCoord(v.ulazak)
    SetBlipSprite(blip, 475)
    SetBlipScale(blip, 0.6)
    SetBlipColour(blip, 18)
    SetBlipDisplay(blip, 4)
    SetBlipAsShortRange(blip, true)
  
    BeginTextCommandSetBlipName("STRING")
    AddTextComponentString(v.label)
    EndTextCommandSetBlipName(blip)
  end

  Wait(2000)
  TSE("registrujstashove")
end)

CT(function()
  while true do
    Wait(1)
    local spavanac = true
    local playerPed = PlayerPedId()
    local korde = GetEntityCoords(playerPed)

    for i = 1, #GlobalState.Apartmani do

      if crta then
        DrawMarker(30, GlobalState.Apartmani[i].ulazak, 0, 0, 0, 0, 0, 0, 1.0, 1.0, 1.0, 50, 112, 207, 155, false, false, 2, false, false, false, false)
      end

      distanca = GetDistanceBetweenCoords(korde, GlobalState.Apartmani[i].ulazak, true)
      if distanca <= 10.0 and distanca >= 2.0 then
        spavanac = false
        crta = true
      elseif distanca <= 5 then
        spavanac = false
        crta = false
        hint('E', 'Pritisni <span>E</span> da udjes u apartman!')
        if IsControlJustPressed(0, 38) then
          TE('rev-apartmani:udji')
        end
      end
    end

    if spavanac then
      Wait(1000)
    end
  end
end)

CT(function()
  while true do
    Wait(1)
    local spavanac = true
    local playerPed = PlayerPedId()
    local korde = GetEntityCoords(playerPed)

    for i = 1, #GlobalState.Apartmani do

      if crta then
        DrawMarker(30, GlobalState.Apartmani[i].izlazak, 0, 0, 0, 0, 0, 0, 1.0, 1.0, 1.0, 50, 112, 207, 155, false, false, 2, false, false, false, false)
      end

      distanca = GetDistanceBetweenCoords(korde, GlobalState.Apartmani[i].izlazak, true)
      if distanca <= 10.0 and distanca >= 2.0 then
        spavanac = false
        crta = true
      elseif distanca <= 5 then
        spavanac = false
        crta = false
        hint('E', 'Pritisni <span>E</span> da izadjes iz apartmana!')
        if IsControlJustPressed(0, 38) then
          TE('rev-apartmani:izadji')
        end
      end
    end

    if spavanac then
      Wait(1000)
    end
  end
end)

CT(function()
  while true do
    Wait(1)
    local spavanac = true
    local playerPed = PlayerPedId()
    local korde = GetEntityCoords(playerPed)

    for i = 1, #GlobalState.Apartmani do

      if crta then
        DrawMarker(30, GlobalState.Apartmani[i].stash, 0, 0, 0, 0, 0, 0, 1.0, 1.0, 1.0, 50, 112, 207, 155, false, false, 2, false, false, false, false)
      end

      distanca = GetDistanceBetweenCoords(korde, GlobalState.Apartmani[i].stash, true)
      if distanca <= 10.0 and distanca >= 2.0 then
        spavanac = false
        crta = true
      elseif distanca <= 5 then
        spavanac = false
        crta = false
        hint('E', 'Pritisni <span>E</span> da otvoris stash!')
        if IsControlJustPressed(0, 38) then
          TE('rev-apartmani:stash')
        end
      end
    end

    if spavanac then
      Wait(1000)
    end
  end
end)


RegisterNUICallback('kupiApartman', function(data)
  TriggerServerEvent('rev-apartmani:kupiApartman', data.ime)
end)

RegisterNUICallback('close', function(data)
  SetTimecycleModifier('default') 
  SetNuiFocus(false, false)
end)

local zadnjiKey = 0
AddEventHandler('rev-apartmani:udji', function ()
  local playerPed = PlayerPedId()
  local korde = GetEntityCoords(playerPed)
  for i = 1, #GlobalState.Apartmani do
    Wait(1)
    distanca = GetDistanceBetweenCoords(korde, GlobalState.Apartmani[i].ulazak, true)
    if distanca <= 5 then
      key = i
      zadnjiKey = i
      ESX.TriggerServerCallback('rev-apartmani:getajApartman', function(bogic) 
        if GlobalState.Apartmani[key].ime == bogic then
          local id = GetPlayerServerId(NetworkGetEntityOwner(GetPlayerPed(-1)))
          unutra = true
          DoScreenFadeOut(300)
          TSE('rev-apartmani:napraviBucket', id)
          Wait(2300)
          SetEntityCoords(PlayerPedId(), GlobalState.Apartmani[key].izlazak, 0, 0, 0, false)
          DoScreenFadeIn(450)
        else
          ESX.ShowNotification('Moras kupiti ovaj apartman da bi mu pristupio!')
        end
      end)
    end
  end
end)
  
AddEventHandler('rev-apartmani:izadji', function ()
  unutra = false
  DoScreenFadeOut(300)
  TSE('rev-apartmani:resetujBucket')
  Wait(2300)
  SetEntityCoords(PlayerPedId(), -776.5603, 316.75546, 85.662643, 0, 0, 0, false)
  DoScreenFadeIn(450)  

end)

AddEventHandler('rev-apartmani:stash', function ()
    TE('ox_inventory:openInventory', 'stash', {id=LocalPlayer.state.identifikacija, owner = true})
end)

AddEventHandler('onResourceStop', function(resource)
  TriggerServerEvent('rev-apartmani:resetujBucket')
end)

RegisterNetEvent('rev-apartmani:otvori')
AddEventHandler("rev-apartmani:otvori", function()
  SetTimecycleModifier('hud_def_blur') -- blur
  SendNUIMessage({action = "open", apartmani = GlobalState.Apartmani})
  SetNuiFocus(true, true)
end)
