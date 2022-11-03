local ox_inventory = exports.ox_inventory

GlobalState.Apartmani = {
	{
        ime = 'eclipse', 
        label = 'Eclipse Tower ',
        cijena = 5000, 
        slika = 'https://external-preview.redd.it/t2og6RFRLMURxCHBomIGQxXxm8nEnjPUIKLbVcFnVVM.jpg?auto=webp&s=8bf8efa92e6e87a1b81f624a39a594b25398085c', 
        slikaBez = 'https://images.squarespace-cdn.com/content/v1/54a80d12e4b03ccd2a07ba13/1493491178760-P8ZXY71P7NS6OF71F30W/ke17ZwdGBToddI8pDm48kLl76CqolYQpYCK1tQUkpCVZw-zPPgdn4jUwVcJE1ZvWQUxwkmyExglNqGp0IvTJZUJFbgE-7XRK3dMEBRBhUpzq3NVIIp6jYqnwxy-xF8aVXRy_AJKc5toB5m-gAPM7p7ivWsEabuWKGrHqsHOeNt4/image-asset.jpeg?format=original', 
        ulazak = vector3(-777.4048, 319.64657, 85.662643), 
        izlazak = vector3(-774.6774, 332.39199, 160.00148), 
        stash = vector3(-784.1603, 331.65185, 160.01025)
    },
    {
        ime = 'integrity', 
        label = 'Integrity Way', 
        cijena = 5000, 
        slika = 'https://media.moddb.com/images/mods/1/30/29021/2015-11-19_00002.jpg', 
        slikaBez = 'https://i.imgur.com/pJTEia4.png',  
        ulazak = vector3(-43.72799, -584.547, 38.161361), 
        izlazak = vector3(-774.6774, 332.39199, 160.00148), 
        stash = vector3(-26.71478, -588.4059, 90.123497)
    },
    {
        ime = 'pierro', 
        label = 'Del Pierro Apartman', 
        cijena = 5000, 
        slika = 'https://static.wikigta.org/nl/images/5/53/GTAOnline_Del_Perro_Heights.jpg', 
        slikaBez = 'https://img.gta5-mods.com/q95/images/working-del-perro-apartment-interior-v1-0-menyoo/42d341-20201123220518_1.jpg',  
        ulazak = vector3(-1447.578, -538.1715, 34.740192), izlazak = vector3(-1449.861, -525.9108, 56.928997), 
        stash =  vector3(-1457.579, -531.3482, 56.937637)
    },
    {
       ime = 'richard', 
       label = 'Richard Apartman', 
       cijena = 5000, 
       slika = 'https://preview.redd.it/am0vzvwur9wy.jpg?auto=webp&s=b3a87acaea41ef125bb40ba1ffad93182d895c43', 
       slikaBez = 'https://i.imgur.com/wj5Swmh.jpg',  
       ulazak = vector3(-1447.578, -538.1715, 34.740192), 
       izlazak = vector3(-912.8149, -365.1465, 114.27474), 
       stash = vector3(-927.6943, -377.41, 113.67405)
    },
    {
        ime = 'wildoats', 
        label = 'Wildboats Apartman', 
        cijena = 5000, 
        slika = 'https://i.ytimg.com/vi/2v1UgzEPuXs/maxresdefault.jpg', 
        slikaBez = 'https://i.imgur.com/tDqHw2gh.jpg',  
        ulazak = vector3(-175.0978, 502.29672, 137.42005), 
        izlazak = vector3(-174.2295, 496.85745, 137.66696), 
        stash = vector3(-175.2413, 492.58413, 130.04365)
    },
} 

RegisterServerEvent('apartmani:registrujStashove', function()
    local xPlayer = ESX.GetPlayerFromId(source)
    Player(source).state.identifikacija = xPlayer.getName()

    local playerStash = {
        id = xPlayer.getName(),
        label = 'Apartman Skladiste - ' .. xPlayer.getName(),
        slots = 50,
        weight = 50000,
        owner = true
    }

    ox_inventory:RegisterStash(playerStash.id, playerStash.label, playerStash.slots, playerStash.weight, true)
end)

RegisterServerEvent('apartmani:napraviBucket', function(id)
    SetPlayerRoutingBucket(source, id)
end)

RegisterServerEvent('apartmani:resetujBucket', function(data)
    SetPlayerRoutingBucket(source, 0)
end)

RegisterServerEvent('apartmani:kupiApartman', function(apartmanData, cijena)
    local xPlayer = ESX.GetPlayerFromId(source)
    local cid = xPlayer.identifier

    if xPlayer.getMoney() >= cijena then
        MySQL.Async.fetchAll("UPDATE `users` SET apartman=@apartman WHERE `identifier` = @identifier", {
            ["@apartman"] = apartmanData,
            ["@identifier"] = cid,
        })
        xPlayer.removeMoney(cijena)
        xPlayer.showNotification('Uspjesno ste kupili apartman za ' .. cijena .. '$')
    else
        xPlayer.showNotification('Nemate dovoljno novca za ovaj apartman!')
    end
end)

ESX.RegisterServerCallback('apartmani:getajApartman', function(source, cb)
    local xPlayer = ESX.GetPlayerFromId(source)
    local cid = xPlayer.identifier
    local rezultat = MySQL.Sync.fetchAll("SELECT apartman FROM users WHERE identifier = @identifier", {
        ['@identifier'] = cid
    })

    if rezultat ~= nil then
        cb(rezultat[1].apartman)
    end
end)
