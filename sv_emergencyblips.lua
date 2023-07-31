local ACTIVE_STAFF_PERSONNEL = {}

local CLIENT_UPDATE_INTERVAL_SECONDS = Config.CLIENT_UPDATE_INTERVAL_SECONDS;

--[[
person = {
 src = 123,
 color = 3,
 name = "Taylor Weitman"
}
]]

RegisterServerEvent("eblips:add")
AddEventHandler("eblips:add", function(person)
	ACTIVE_STAFF_PERSONNEL[person.src] = person
	TriggerClientEvent("eblips:toggle", person.src, true)
end)

RegisterServerEvent("eblips:remove")
AddEventHandler("eblips:remove", function(src)
	-- remove from list --
	ACTIVE_STAFF_PERSONNEL[src] = nil
	-- deactive blips when off duty --
	TriggerClientEvent("eblips:toggle", src, false)
end)

-- Clean up blip entry for on duty player who leaves --
AddEventHandler("playerDropped", function()
	if ACTIVE_STAFF_PERSONNEL[source] then
		ACTIVE_STAFF_PERSONNEL[source] = nil
	end
end)

Citizen.CreateThread(function()
	local lastUpdateTime = os.time()
	while true do
		if os.difftime(os.time(), lastUpdateTime) >= CLIENT_UPDATE_INTERVAL_SECONDS then
			for id, info in pairs(ACTIVE_STAFF_PERSONNEL) do
				ACTIVE_STAFF_PERSONNEL[id].coords = GetEntityCoords(GetPlayerPed(id))
				TriggerClientEvent("eblips:updateAll", id, ACTIVE_STAFF_PERSONNEL)
			end
			lastUpdateTime = os.time()
		end
		Wait(500)
	end
end)