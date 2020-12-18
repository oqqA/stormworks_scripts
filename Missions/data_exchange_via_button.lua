vehiclePOS, vehicleID, playlist_index = 0, 0, 0 

function onCreate(is_world_create)
	server.announce("[Server]", "reloaded")

	vehiclePOS = matrix.translation(-18233,4,-4933) --(-237.28, 7.0, 63.59)
	vehicleID = 3

	playlist_index = server.getPlaylistIndexCurrent()
end

tick = 0
vehicle_id = 0
keypad_name = ""

v_id = 0

function onTick(game_ticks)
	if tick > 0 then
		server.setVehicleKeypad(vehicle_id, keypad_name, tick)
	end
	if tick == 1 then
		server.setVehicleKeypad(vehicle_id, keypad_name, 0)
	end
	if tick > 0 then tick = tick - 1 end
end

function onVehicleSpawn(vehicle_id, peer_id, x, y, z)
	nickname = server.getPlayerName(peer_id)
	server.announce("[Server]", nickname .." spawn: " .. vehicle_id)
end

function onCustomCommand(full_message, user_peer_id, is_admin, is_auth, command, a1, a2, a3)
	if (command == "??") then
		server.announce("[Server]", "?reload_scripts")
	end
	if (command == "?p") then
		vehicle_id = tonumber(a1)
		keypad_name = a2
		tick = tonumber(a3)
	end
    if (command == "?s") then
		v_id = server.spawnVehicle(vehiclePOS, playlist_index, vehicleID)
    end
    
	if (command == "?d") then
		server.despawnVehicle(a1, true)
		server.despawnVehicle(v_id, true)
	end

	if (command == "?o") then
		m = server.getPlayerPos(user_peer_id)
		x,y,z = matrix.position(m)

		server.announce("[Server]", "gps: "..x.." "..y.." "..z)
    end
    
    if (command == "?z") then
        k = server.getZones("tags=kek")
        server.announce("[Server] 1 #k", #k )

        k = server.getZones("type=kek")
        server.announce("[Server] 2 #k", #k )

        k = server.getZones()
        server.announce("[Server] 4 #k", #k )
    end
end
