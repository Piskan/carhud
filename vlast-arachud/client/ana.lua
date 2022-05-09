
local gecerliarac = 0
local sabitAktif, kemerAktif = false, false;
local playerPed = nil;
local inair = 0
local aracbilgileri = {
    kemervarmi = false,
    sabitlemevarmi = false,
    aracgecerlirpm =0.0,
    gecerlihiz = 0.0,
    sabithiz = 0.0,
    prevVelocity = {x = 0.0, y = 0.0, z = 0.0}, 
};



Citizen.CreateThread(function()
    while true do
        if (gecerliarac ~= 0) then
    
            SendNUIMessage({
             message = 'aracupdate',
			 arachiz =  math.floor(aracbilgileri['gecerlihiz'] * 3.6),
			 aracrpm = aracbilgileri['aracgecerlirpm'],
             aracbenzin = math.floor(GetVehicleFuelLevel(gecerliarac))
	
		   
             })
           
        
        end

        Citizen.Wait(gecerliarac == 0 and 500 or 60);
    end
end)


Citizen.CreateThread(function()
    while true do
        if (gecerliarac ~= 0) then
            local position = GetEntityCoords(playerPed);

        
            if (IsControlJustReleased(0, Config['kemertusu']) and aracbilgileri['kemervarmi']) then 
                kemerAktif = not kemerAktif;
				SendNUIMessage({
                 message = 'kemertetikle',
			     Kemervarmi = aracbilgileri['kemervarmi'],
				 KemerAktif = kemerAktif
				 
				  
                 })
				
         
            end
            
            local prevSpeed = aracbilgileri['gecerlihiz'];
            aracbilgileri['gecerlihiz'] = GetEntitySpeed(gecerliarac);
			aracbilgileri['aracgecerlirpm'] = GetVehicleCurrentRpm(gecerliarac)

            if (not aracbilgileri['kemervarmi'] or not kemerAktif) then
                kemerAktif = false;

                local vehIsMovingFwd = GetEntitySpeedVector(gecerliarac, true).y > 1.0;
                local vehAcc = (prevSpeed - aracbilgileri['gecerlihiz']) / GetFrameTime();
                if (vehIsMovingFwd and (prevSpeed > (Config['kemercikartmahizi']/2.237)) and (vehAcc > (Config['kemeroyuncuatma']*9.81))) then
                    SetEntityCoords(playerPed, position.x, position.y, position.z - 0.47, true, true, true);
                    SetEntityVelocity(playerPed, aracbilgileri['prevVelocity'].x, aracbilgileri['prevVelocity'].y, aracbilgileri['prevVelocity'].z);
                    Citizen.Wait(1);
                    SetPedToRagdoll(playerPed, 1000, 1000, 0, 0, 0, 0);
                else
                    aracbilgileri['prevVelocity'] = GetEntityVelocity(gecerliarac);
                end
            elseif (kemerAktif) then
                DisableControlAction(0, 75);
            end

            local isDriver = (GetPedInVehicleSeat(gecerliarac, -1) == playerPed);
            if (isDriver) then
                if (isDriver ~= aracbilgileri['sabitlemevarmi']) then
                    aracbilgileri['sabitlemevarmi']  = isDriver;
					SendNUIMessage({
                    message = 'sabittetikle',
			        Sabitvarmi = aracbilgileri['sabitlemevarmi'],
				    SabitAktif = sabitAktif
				 
				  
                     })
                    
                end
                if (IsControlJustReleased(0, Config['sabitlemetusu'])) then
                    sabitAktif = not sabitAktif;
                    SendNUIMessage({
                    message = 'sabittetikle',
			        Sabitvarmi = isDriver,
				    SabitAktif = sabitAktif
				 
				  
                     })
                    aracbilgileri['sabithiz'] = aracbilgileri['gecerlihiz'];
                    cruiseSpeeding = aracbilgileri['sabithiz'];
                end

                local maxSpeed = sabitAktif and aracbilgileri['sabithiz'] or GetVehicleHandlingFloat(gecerliarac,"CHandlingData","fInitialDriveMaxFlatVel");
                SetEntityMaxSpeed(gecerliarac, maxSpeed);

                local roll = GetEntityRoll(gecerliarac)


                if sabitAktif and not IsEntityInAir(gecerliarac) and inair >= 100 and not (roll > 75.0 or roll < -75.0) then
                    if cruiseSpeeding < maxSpeed then
                        cruiseSpeeding = cruiseSpeeding + 0.15
                    end


                    SetVehicleForwardSpeed(gecerliarac, cruiseSpeeding)
                
                elseif sabitAktif and not IsEntityInAir(gecerliarac) then
                    inair = inair + 1
                    cruiseSpeeding = aracbilgileri['gecerlihiz'];
                elseif sabitAktif then
                    inair = 0
                end
            else
                sabitAktif = false;
            end

         
        end

        Citizen.Wait(gecerliarac == 0 and 500 or 5);
    end
end)

function kemerivarmiaracin(class)
    if (not class) then return false end

    local hasBelt = Config.kemersiniflari[class];
    if (not hasBelt or hasBelt == nil) then return false end

    return hasBelt;
end 


Citizen.CreateThread(function()
	while true do
	   playerPed = PlayerPedId()
	   local veh = GetVehiclePedIsIn(playerPed, false)
	   local position = GetEntityCoords(playerPed)
             local heading = Config['Yonler'][math.floor((GetEntityHeading(playerPed) + 45.0) / 90.0)];
            local zoneNameFull = GetStreetNameFromHashKey(GetStreetNameAtCoord(position.x, position.y, position.z));
			 SendNUIMessage({
                 message = 'sokakinfo',
			     sokakisim = zoneNameFull,
				 sokakyon = heading
				 
				  
                 })
	  if (veh ~= gecerliarac) then
	  	  gecerliarac = veh;
	    SendNUIMessage({
           message = 'arachud',
		   hudaktif = veh ~= 0
		   
        })
		
		if (veh == 0) then
                kemerAktif, sabitAktif = false, false;
                aracbilgileri['sabitlemevarmi'] = false;
                aracbilgileri['gecerlihiz'] = 0.0;
				SendNUIMessage({
                    message = 'sabittetikle',
			        Sabitvarmi = aracbilgileri['sabitlemevarmi'],
				    SabitAktif = sabitAktif
				 
				  
                     })
              SendNUIMessage({
                 message = 'kemertetikle',
			     Kemervarmi = aracbilgileri['kemervarmi'],
				 KemerAktif = kemerAktif
				 
				  
                 })
            else
                local vehicleClass = GetVehicleClass(veh);
                aracbilgileri['kemervarmi'] = kemerivarmiaracin(vehicleClass);
			
			
         end
	  end
	   
	Citizen.Wait(1000)
	end


end)




