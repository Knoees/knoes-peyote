local spawnedPeyote = 0
local PeyotePlants = {}
local isPickingUp, isProcessing, inPeyoteField = false, false, false
local QBCore = exports['qb-core']:GetCoreObject()

local function LoadAnimationDict(dict)
    RequestAnimDict(dict)
    while not HasAnimDictLoaded(dict) do
        RequestAnimDict(dict)
        Wait(1)
    end
end

local function ValidatePeyoteCoord(plantCoord)
	local validate = true
	if spawnedPeyote > 0 then
		for _, v in pairs(PeyotePlants) do
			if #(plantCoord - GetEntityCoords(v)) < 5 then
				validate = false
			end
		end
		if not inPeyoteField then
			validate = false
		end
	end
	return validate
end

local function GetCoordZPeyote(x, y)
	local groundCheckHeights = { 50, 51.0, 52.0, 53.0, 54.0, 55.0, 56.0, 57.0, 58.0, 59.0, 60.0 }

	for i, height in ipairs(groundCheckHeights) do
		local foundGround, z = GetGroundZFor_3dCoord(x, y, height)

		if foundGround then
			return z
		end
	end

	return 53.85
end

local function GeneratePeyoteCoords()
	while true do
		Wait(1)

		local PeyoteCoordX, PeyoteCoordY

		math.randomseed(GetGameTimer())
		local modX = math.random(-20, 20)

		Wait(100)

		math.randomseed(GetGameTimer())
		local modY = math.random(-20, 20)

		PeyoteCoordX = Config.CircleZones.PeyoteField.coords.x + modX
		PeyoteCoordY = Config.CircleZones.PeyoteField.coords.y + modY

		local coordZ = GetCoordZPeyote(PeyoteCoordX, PeyoteCoordY)
		local coord = vector3(PeyoteCoordX, PeyoteCoordY, coordZ)

		if ValidatePeyoteCoord(coord) then
			return coord
		end
	end
end


local fx = 0
local function SpawnPeyotePlants()
	local model = `prop_peyote_lowland_01`
	local light = "proj_laser_player"
	while spawnedPeyote < 80 do
		Wait(0)
		local PeyoteCoords = GeneratePeyoteCoords()
		RequestModel(model)
		while not HasModelLoaded(model) do
			Wait(100)
		end
		if not HasNamedPtfxAssetLoaded("core") then
			RequestNamedPtfxAsset("core")
			while not HasNamedPtfxAssetLoaded("core") do
				Wait(1)
			end
		end
		local obj = CreateObject(model, PeyoteCoords.x, PeyoteCoords.y, PeyoteCoords.z, false, true, false)
		PlaceObjectOnGroundProperly(obj)
		UseParticleFxAssetNextCall("core") particles = StartParticleFxLoopedAtCoord(light, PeyoteCoords.x, PeyoteCoords.y, PeyoteCoords.z, 0.0, 0.0, 0.0, 0.02, false, false, false, false)
		FreezeEntityPosition(obj, true)
		PeyotePlants[#PeyotePlants+1] = obj
		spawnedPeyote += 1
	end
	SetModelAsNoLongerNeeded(model)
end

RegisterNetEvent('knoes-peyote:proccessing', function()
	local hasItem = QBCore.Functions.HasItem('peyote', Config.ToAmount)
	if hasItem then
		QBCore.Functions.Progressbar('peyote_processing',Lang:t("peyote.proccessing"), 5000, false, true, {
			disableMovement = true,
			disableCarMovement = true,
			disableMouse = false,
			disableCombat = true,
			}, {
			animDict = 'amb@prop_human_bbq@male@idle_a',
			anim = 'idle_b',
			flags = 16,
			}, {}, {}, function()
				TriggerServerEvent('knoes:peyoteprocessing')
				ClearPedTasks(PlayerPedId())
			end, function()
				ClearPedTasks(PlayerPedId())
				QBCore.Functions.Notify(Lang:t("peyote.cancel"), "error")
		end)
	else
		ClearPedTasks(PlayerPedId())
		QBCore.Functions.Notify(Lang:t("peyote.not_have_peyote"), "error")
	end
end)


RegisterNetEvent("knoes-peyote:pickPeyote", function()
	local playerPed = PlayerPedId()
	local coords = GetEntityCoords(playerPed)
	local nearbyObject, nearbyID

	for i=1, #PeyotePlants, 1 do
		if #(coords - GetEntityCoords(PeyotePlants[i])) < 2 then
			nearbyObject, nearbyID = PeyotePlants[i], i
		end
	end

	if nearbyObject and IsPedOnFoot(playerPed) then
		if not isPickingUp then
			isPickingUp = true
			QBCore.Functions.Progressbar("peyote_topla", Lang:t("peyote.progress"), 1300, false, true, {
				disableMovement = true,
				disableCarMovement = true,
				disableMouse = false,
				disableCombat = true,
			}, { 
				animDict = "random@domestic",
				anim = "pickup_low",
				flags = 16,
			}, {}, {}, function()
				ClearPedTasks(PlayerPedId())
				SetEntityAsMissionEntity(nearbyObject, false, true)
				DeleteObject(nearbyObject)
				StopParticleFxLooped(particles, 0)
				PeyotePlants[nearbyID] = nil
				spawnedPeyote -= 1
				TriggerServerEvent('knoes-peyote:pickedUpPeyote')
				isPickingUp = false
			end, function()
				ClearPedTasks(PlayerPedId())
				isPickingUp = false
				QBCore.Functions.Notify(Lang:t("peyote.leave"), "error")
			end)
		end
	end
end)

CreateThread(function()
	for _,v in pairs(Config.Peds) do
		RequestModel(v.model)
		while not HasModelLoaded(v.model) do Wait(1) end
		v.handle = CreatePed(4, v.model, v.coords.x, v.coords.y, v.coords.z-1.0, v.heading, false, false)
		SetPedFleeAttributes(v.handle, 0, 0)
		SetPedDropsWeaponsWhenDead(v.handle, false)
		SetPedDiesWhenInjured(v.handle, false)
		SetEntityInvincible(v.handle , true)
		FreezeEntityPosition(v.handle, true)
		SetBlockingOfNonTemporaryEvents(v.handle, true)
		if v.anim.type == 1 then
			TaskStartScenarioInPlace(v.handle, v.anim.name, 0, true)
		elseif v.anim.type == 2 then
			RequestAnimDict(v.anim.dict)
			TaskPlayAnim(v.handle, v.anim.dict, v.anim.name, 8.0, 1, -1, 49, 0, false, false, false)
		end
	end
end)

if Config.EnableBlips then
	CreateThread(function()
		for _,v in pairs(Config.Locations) do
			local blip = AddBlipForCoord(v.coord)
			SetBlipSprite(blip, v.sprite)
			SetBlipScale(blip, v.scale)
			SetBlipColour(blip, v.color)
			SetBlipAsShortRange(blip, true)
			BeginTextCommandSetBlipName("STRING")
			AddTextComponentString(v.label)
			EndTextCommandSetBlipName(blip)
		end
	end)
end
	

AddEventHandler('onResourceStop', function(resource)
	if resource == GetCurrentResourceName() then
		for _, v in pairs(PeyotePlants) do
			SetEntityAsMissionEntity(v, false, true)
			StopParticleFxLooped(particles, 0)
			DeleteObject(v)
		end
	end
end)

CreateThread(function()
	local peyoteZone = CircleZone:Create(Config.CircleZones.PeyoteField.coords, 10.0, {
		name = "peyote-plants",
		debugPoly = false
	})
	peyoteZone:onPlayerInOut(function(isPointInside, point, zone)
        if isPointInside then
            inPeyoteField = true
            SpawnPeyotePlants()
        else
            inPeyoteField = false
        end
    end)
end)
