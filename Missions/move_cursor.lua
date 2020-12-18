USED_NAME_DIAL = "this dial for detection by mission script"

playlist_index = 0
spawned_vehicles = {}

used_id = nil
USER_ID = 0

function onCreate(is_world_create)
	server.announce("[Server]", "reloaded")

    playlist_index = server.getPlaylistIndexCurrent()
end

function onTick(game_ticks)
    for _, v in pairs(spawned_vehicles) do
        _, is = server.getVehicleDial(v, USED_NAME_DIAL)

        if is then
            m = server.getPlayerPos(USER_ID)
            x,y,z = matrix.position(m)

            server.setVehicleKeypad(v, "pos_x", x)
            server.setVehicleKeypad(v, "pos_y", y)
            server.setVehicleKeypad(v, "pos_z", z)

            x,y,z = server.getPlayerLookDirection(USER_ID)
            
            server.setVehicleKeypad(v, "look_dir_x", x)
            server.setVehicleKeypad(v, "look_dir_y", y)
            server.setVehicleKeypad(v, "look_dir_z", z)            
        end
    end
end

-- events

function onVehicleSpawn(vehicle_id, peer_id, x, y, z)
    nickname, is = server.getPlayerName(peer_id)
    if is then
        table.insert(spawned_vehicles, vehicle_id)
    end
end

function onVehicleDespawn(vehicle_id, peer_id)
    nickname, is = server.getPlayerName(peer_id)
    if is then
        for i, v in pairs(spawned_vehicles) do
            if v == vehicle_id then
                table.remove(spawned_vehicles, i)
                break
            end
        end
    end
end