local unutra = false
local listaUnutra = {}

RegisterNetEvent("apartmani:otvoriMeni", function()
  SetTimecycleModifier('hud_def_blur') -- blur
  SendNUIMessage({action = "open", apartmani = GlobalState.Apartmani})
  SetNuiFocus(true, true)
end)

CreateThread(function()
  for id,data in pairs(GlobalState.Apartmani) do
    exports['qtarget']:AddCircleZone('apartman_' .. id, data.ulazak, 1.5, {
      name = 'apartman_' .. id,
      debugPoly = false,
      useZ = true,
    }, {
      options = {
        {
          icon = "fas fa-sign-in-alt",
          label = "Pristupi Apartmanu",
          action = function()
            TriggerEvent('apartmani:pristupiApartmanu', data)
          end
        },
        {
          icon = "fas fa-sign-in-alt",
          label = "Raidajte Apartman",
          action = function()
            TriggerEvent('apartmani:policijaRaidMeni', data)
          end
        },
      },
      distance = 2.0,
    })

    exports['qtarget']:AddCircleZone('apartmanIzlazak_' .. id, data.izlazak, 1.5, {
      name = 'apartmanIzlazak_' .. id,
      debugPoly = false,
      useZ = true,
    }, {
      options = {
        {
          icon = "fas fa-sign-in-alt",
          label = "Napusti Apartman",
          action = function()
            TriggerEvent('apartmani:napustiApartman', data)
          end
        },
      },
      distance = 2.0,
    })

    exports['qtarget']:AddCircleZone('apartmanstash_' .. id, data.stash, 1.5, {
      name = 'apartmanstash_' .. id,
      debugPoly = false,
      useZ = true,
    }, {
      options = {
        {
          icon = "fas fa-box",
          label = "Pristupi Ostavi",
          action = function()
            TriggerEvent('apartmani:otvoriStash')
          end
        },
      },
      distance = 2.0,
    })
  end
end)

RegisterNetEvent('apartmani:policijaRaidMeni', function(apartmanData)
    local opcije = {}
    local menu_podaci = {}

    for id,data in pairs(listaUnutra) do
      if data.apartman == apartmanData.ime then
        table.insert(menu_podaci, data)
      end
    end

    for id,data in pairs(menu_podaci) do
      table.insert(opcije, {
        title = 'ID Apartmana: ' .. data.id, 
        event = 'apartmani:raidApartman',
        description = 'Pritisnite da raidate ovaj apartman!',
        args = {id = data.id, apartmanData = apartmanData},
        icon = 'fas fa-house'
      })
    end

    lib.registerContext({
        id = 'apartmani-lista',
        title = 'Lista Apartmana',
        options = opcije
    })

    lib.showContext('apartmani-lista')
end)

RegisterNetEvent('apartmani:raidApartman', function(data)
  DoScreenFadeOut(300)
  TriggerServerEvent('apartmani:napraviBucket', data.id)
  Wait(2300)
  SetEntityCoords(PlayerPedId(), data.apartmanData.izlazak, 0, 0, 0, false)
  DoScreenFadeIn(300)
end)

RegisterNetEvent('apartmani:pristupiApartmanu', function(apartmanData)
  ESX.TriggerServerCallback('apartmani:getajApartman', function(callbackData) 
    if callbackData == apartmanData.ime then
      local id = GetPlayerServerId(NetworkGetEntityOwner(PlayerPedId()))
      unutra = true
      DoScreenFadeOut(300)
      TriggerServerEvent('apartmani:napraviBucket', id)
      Wait(2300)
      SetEntityCoords(PlayerPedId(), apartmanData.izlazak, 0, 0, 0, false)
      DoScreenFadeIn(300)

      table.insert(listaUnutra, {
        apartman = apartmanData.ime, 
        id = id,
        vlasnik = LocalPlayer.state.identifikacija
      })
    else
      ESX.ShowNotification('Moras kupiti ovaj apartman da bi mu pristupio!')
    end
  end)
end)

RegisterNetEvent('apartmani:napustiApartman', function(apartmanData)
  local id = GetPlayerServerId(NetworkGetEntityOwner(PlayerPedId()))
  unutra = false
  DoScreenFadeOut(300)
  TriggerServerEvent('apartmani:resetujBucket')
  Wait(2300)
  SetEntityCoords(PlayerPedId(), apartmanData.ulazak, 0, 0, 0, false)
  DoScreenFadeIn(450) 
end)

RegisterNUICallback('kupiApartman', function(data)
  TriggerServerEvent('apartmani:kupiApartman', data.ime, data.cijena)
end)

RegisterNUICallback('close', function(data)
  SetTimecycleModifier('default') 
  SetNuiFocus(false, false)
end)

RegisterNetEvent('apartmani:izadji', function ()
  unutra = false
  DoScreenFadeOut(300)
  TSE('apartmani:resetujBucket')
  Wait(2300)
  SetEntityCoords(PlayerPedId(), -776.5603, 316.75546, 85.662643, 0, 0, 0, false)
  DoScreenFadeIn(450)  

end)

RegisterNetEvent('apartmani:otvoriStash', function ()
  TriggerEvent('ox_inventory:openInventory', 'stash', {id=LocalPlayer.state.identifikacija, owner = true})
end)

AddEventHandler('onResourceStop', function(resource)
  TriggerServerEvent('apartmani:resetujBucket')
end)

CreateThread(function()
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
  TriggerServerEvent("apartmani:registrujStashove")
end)

RegisterCommand("kupiApartman", function()
  TriggerEvent('apartmani:otvoriMeni')
end)
