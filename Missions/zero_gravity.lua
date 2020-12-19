TITLE_MISSION_LOC = "CREATIVE BASE"
USED_NAME_DIAL = "ws"

playlist_index = 0
spawned_items = {}

used_id = nil
USER_ID = 0

function getDial(n, ...) local x={} for _,v in ipairs({...}) do table.insert(x, ({server.getVehicleDial(n, v)})[1]) end; return table.unpack(x) end

function onCreate(is_world_create)
	server.announce("[Server]", "reloaded")

    playlist_index = server.getPlaylistIndexCurrent()
end

interval = 60

tick = 0
function onTick(game_ticks)
    tick = tick + 1
    if used_id then
        ws, ad, ud, lr, b1, b2, b3, b4, signal_str = getDial(used_id, "ws","ad","ud","lr","1","2","3","4","signal strength")

        m = server.getPlayerPos(USER_ID)
        x,y,z = matrix.position(m)
        x,y,z = server.getPlayerLookDirection(USER_ID)

        if b1 == 1 and (tick % interval == 0)  then
            server.setPlayerPos(USER_ID, m)
        end
    else
        for _, v in pairs(spawned_items) do
            _, is = server.getVehicleDial(v, USED_NAME_DIAL)

            if is then
                used_id = v
                server.announce("[Server]", "detect used_id: "..used_id)
            end
        end
    end
end

-- events

function onVehicleSpawn(vehicle_id, peer_id, x, y, z)
    nickname, is = server.getPlayerName(peer_id)
    if is then
        server.announce("[Server]", peer_id.." "..nickname .." spawn: " .. vehicle_id)
    end
end

function onSpawnMissionComponent(vehicle_id, name, type, on_playlist_index)
    if on_playlist_index == playlist_index then
        table.insert(spawned_items, vehicle_id)
    end
end

function onCustomCommand(full_message, user_peer_id, is_admin, is_auth, command, a1, a2, a3)
	if (command == "??") then
		server.announce("[Server]", "?reload_scripts")
	end
    if (command == "?s") then
        server.spawnThisPlaylistMissionLocation(TITLE_MISSION_LOC)
    end
    if (command == "?d") then
        for _,v in pairs(spawned_items) do
            server.despawnVehicle(v, true)
        end
        spawned_items = {}
        used_id = nil
    end
    if (command == "?del") then
        server.despawnVehicle(a1, true)
    end
    if (command == "?use") then
        used_id = a1
    end
    if (command == "?int") then
        interval = a1
    end
end