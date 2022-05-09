
-- ESX = nil

Keys = {
    ["ESC"] = 322, ["F1"] = 288, ["F2"] = 289, ["F3"] = 170, ["F5"] = 166, ["F6"] = 167, ["F7"] = 168, ["F8"] = 169, ["F9"] = 56, ["F10"] = 57,
    ["~"] = 243, ["1"] = 157, ["2"] = 158, ["3"] = 160, ["4"] = 164, ["5"] = 165, ["6"] = 159, ["7"] = 161, ["8"] = 162, ["9"] = 163, ["-"] = 84, ["="] = 83, ["BACKSPACE"] = 177,
    ["TAB"] = 37, ["Q"] = 44, ["W"] = 32, ["E"] = 38, ["R"] = 45, ["T"] = 245, ["Y"] = 246, ["U"] = 303, ["P"] = 199, ["["] = 39, ["]"] = 40, ["ENTER"] = 18,
    ["CAPS"] = 137, ["A"] = 34, ["S"] = 8, ["D"] = 9, ["F"] = 23, ["G"] = 47, ["H"] = 74, ["K"] = 311, ["L"] = 182,
    ["LEFTSHIFT"] = 21, ["Z"] = 20, ["X"] = 73, ["C"] = 26, ["V"] = 0, ["B"] = 29, ["N"] = 249, ["M"] = 244, [","] = 82, ["."] = 81,
    ["LEFTCTRL"] = 36, ["LEFTALT"] = 19, ["SPACE"] = 22, ["RIGHTCTRL"] = 70,
    ["HOME"] = 213, ["PAGEUP"] = 10, ["PAGEDOWN"] = 11, ["DELETE"] = 178,
    ["LEFT"] = 174, ["RIGHT"] = 175, ["TOP"] = 27, ["DOWN"] = 173,
}

-- Citizen.CreateThread(function()
-- 	while ESX == nil do
-- 		TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)
-- 		Citizen.Wait(0)
-- 	end

-- 	while ESX.GetPlayerData().job == nil do
-- 		Citizen.Wait(10)
-- 	end


--     ESX.PlayerData = ESX.GetPlayerData()

-- end)

local hudaktif = true
local speed = 0.0
local seatbeltOn = false
local cruiseOn = false


Citizen.CreateThread(function()
   
    while true do 
        if IsPedInAnyVehicle(PlayerPedId()) then
            SetRadarBigmapEnabled(false, false)
        sleep = 60
        local player = GetPlayerPed(-1)
        local vehicle = GetVehiclePedIsIn(player, false)
         speed = GetEntitySpeed(GetVehiclePedIsIn(PlayerPedId(), false)) * 3.6

         local pos = GetEntityCoords(PlayerPedId())
         local vehicleVal,vehicleLights,vehicleHighlights  = GetVehicleLightsState(vehicle)
         local vehicleIsLightsOn
         if vehicleLights == 1 and vehicleHighlights == 0 then
             vehicleIsLightsOn = 'normal'
         elseif (vehicleLights == 1 and vehicleHighlights == 1) or (vehicleLights == 0 and vehicleHighlights == 1) then
             vehicleIsLightsOn = 'high'
         else
             vehicleIsLightsOn = 'off'
         end
         local araiptalmi = GetVehicleEngineHealth(GetVehiclePedIsIn(PlayerPedId()))
         
         SendNUIMessage({
             action = "hudtick",
             show = IsPauseMenuActive(),
            
    
          
             speed = math.ceil(speed),
             aracisik = vehicleIsLightsOn,
    
             aracbenzin = math.floor(((GetVehicleFuelLevel(vehicle) / 100) * 100)),
             aracdurum = araiptalmi,
             engine = GetIsVehicleEngineRunning(vehicle),
         })
        --  print(araiptalmi)

        else
            sleep = 1000
        end
        Citizen.Wait(sleep)
       
     end
         
    

end)

local radarActive = false
Citizen.CreateThread(function() 
    while true do
        Citizen.Wait(1000)
       
        if IsPedInAnyVehicle(PlayerPedId()) and hudaktif then
            DisplayRadar(true)
            SendNUIMessage({
                action = "car",
                show = true,
            })
           
            radarActive = true
        else
           
            DisplayRadar(false)
            SendNUIMessage({
                action = "car",
                show = false,
            })
            seatbeltOn = false
            cruiseOn = false

            SendNUIMessage({
                action = "seatbelt",
                seatbelt = seatbeltOn,
            })

            SendNUIMessage({
                action = "cruise",
                cruise = cruiseOn,
            })
            radarActive = false
        end
        -- print(cruiseOn)
    end
end)

Citizen.CreateThread(function()
    local currSpeed = 0.0
    local cruiseSpeed = 999.0
    local prevVelocity = {x = 0.0, y = 0.0, z = 0.0}
    local seatbeltEjectSpeed = 45.0 
    local seatbeltEjectAccel = 100.0

    while true do
      
        local player = PlayerPedId()
        local position = GetEntityCoords(player)
        local vehicle = GetVehiclePedIsIn(player, false)
        
        if IsPedInAnyVehicle(player, false) then
            sleep = 40
            local vehicleClass = GetVehicleClass(vehicle)
            if IsPedInAnyVehicle(player, false) and vehicleClass ~= 13 then
                local prevSpeed = currSpeed
                currSpeed = GetEntitySpeed(vehicle)

                SetPedConfigFlag(PlayerPedId(), 32, true)
                if not seatbeltOn then
                    local vehIsMovingFwd = GetEntitySpeedVector(vehicle, true).y > 1.0
                    local vehAcc = (prevSpeed - currSpeed) / GetFrameTime()
                    if (vehIsMovingFwd and (prevSpeed > (seatbeltEjectSpeed/2.237)) and (vehAcc > (seatbeltEjectAccel*9.81))) then
                        SetEntityCoords(player, position.x, position.y, position.z - 0.47, true, true, true)
                        SetEntityVelocity(player, prevVelocity.x, prevVelocity.y, prevVelocity.z)
                        Citizen.Wait(1)
                        SetPedToRagdoll(player, 1000, 1000, 0, 0, 0, 0)
                    else
                        prevVelocity = GetEntityVelocity(vehicle)
                    end
                else
                    DisableControlAction(0, 75)
                end
                -- print(cruiseOn)
                local isDriver = (GetPedInVehicleSeat(vehicle, -1) == player)
                if isDriver then
                    -- Check if cruise control button pressed, toggle state and set maximum speed appropriately
                    if cruiseOn then
                       
                        cruiseSpeed = currSpeed
                 
    
                    local maxSpeed = cruiseOn and cruiseSpeed or GetVehicleHandlingFloat(vehicle,"CHandlingData","fInitialDriveMaxFlatVel")
                    SetEntityMaxSpeed(vehicle, maxSpeed)
                    else
                     local maxSpeed =  GetVehicleHandlingFloat(vehicle,"CHandlingData","fInitialDriveMaxFlatVel")
                     SetEntityMaxSpeed(vehicle, maxSpeed)
                    end
                    
                else
                    -- Reset cruise control
                    cruiseOn = false
                end

            end
        else
            sleep = 1000
        end
    
        Citizen.Wait(sleep)
    end
end)
Citizen.CreateThread(function()
	while true do
      
        local player = PlayerPedId()
   
        
        if IsPedInAnyVehicle(player, true) then
            sleep = 0
      if IsControlJustReleased(0, 29) and IsPedInAnyVehicle(PlayerPedId()) then
        
           seatbeltOn = not seatbeltOn
            if not seatbeltOn then
               TriggerEvent("seatbelt:client:ToggleSeatbelt",false)
               TriggerEvent("InteractSound_CL:PlayOnOne","seatbeltoff",0.8)
               exports['mythic_notify']:DoHudText('inform', 'Kemer cıkartıldı')
            else
             TriggerEvent("seatbelt:client:ToggleSeatbelt",true)
             TriggerEvent("InteractSound_CL:PlayOnOne","seatbelt",0.8)
            
             exports['mythic_notify']:DoHudText('inform', 'Kemer takıldı')
           end
       end
       if IsControlJustReleased(0, 137) and IsPedInAnyVehicle(PlayerPedId()) then
        
           cruiseOn = not cruiseOn
            if not cruiseOn then
              TriggerEvent("sabitleme:client:tusabas",false)
              TriggerEvent("InteractSound_CL:PlayOnOne","cruise",0.2)
              exports['mythic_notify']:DoHudText('inform', 'Sabitleyici kapali')
           else
             TriggerEvent("sabitleme:client:tusabas",true)
              TriggerEvent("InteractSound_CL:PlayOnOne","cruise",0.2)
         
             exports['mythic_notify']:DoHudText('inform', 'Sabitleyici acik')
           end
        end
       else
        sleep = 1000
       end
       Citizen.Wait(sleep)
    end
end)

RegisterNetEvent("sabitleme:client:tusabas")
AddEventHandler("sabitleme:client:tusabas", function(toggle)

    if toggle == nil then
       
        cruiseOn = not cruiseOn
        SendNUIMessage({
            action = "cruise",
            cruise = cruiseOn,
        })
    else
        cruiseOn = toggle
        SendNUIMessage({
            action = "cruise",
            cruise = toggle,
        })
    end
end)

RegisterNetEvent("seatbelt:client:ToggleSeatbelt")
AddEventHandler("seatbelt:client:ToggleSeatbelt", function(toggle)

    if toggle == nil then
       
        seatbeltOn = not seatbeltOn
        SendNUIMessage({
            action = "seatbelt",
            seatbelt = seatbeltOn,
        })
    else
        seatbeltOn = toggle
        SendNUIMessage({
            action = "seatbelt",
            seatbelt = toggle,
        })
    end
end)
RegisterNetEvent("blaze_carhud:hudaktifkapali")
AddEventHandler("blaze_carhud:hudaktifkapali", function()

 hudaktif = not hudaktif
end)
RegisterCommand('hud', function(source, args, rawCommand)
    hudaktif = not hudaktif
end)

RegisterCommand('motor', function(source, args, rawCommand)
    local player = GetPlayerPed(-1)
    local vehicle = GetVehiclePedIsIn(player, false)
   
    if not GetIsVehicleEngineRunning(vehicle) then
    
    SetVehicleEngineOn(vehicle, true, false, true)

    else
        SetVehicleEngineOn(vehicle, false, false, true)
    end
end)

