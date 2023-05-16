local QBCore = exports['qb-core']:GetCoreObject()

RegisterServerEvent('knoes-peyote:pickedUpPeyote', function()
	local src = source
	local Player = QBCore.Functions.GetPlayer(src)
	if Player.Functions.AddItem(Config.PeyoteItem, Config.GiveAmount) then
		TriggerClientEvent('inventory:client:ItemBox', src, QBCore.Shared.Items[Config.PeyoteItem], "add")
		TriggerClientEvent('QBCore:Notify', src, Config.GiveAmount..Lang:t("peyote.getitem"), "success")
	end
end)

RegisterServerEvent("knoes:peyoteprocessing")
AddEventHandler("knoes:peyoteprocessing", function()
	local src = source
    local Player = QBCore.Functions.GetPlayer(src)
    if Player.Functions.RemoveItem("peyote", Config.Neededfortea) then
			TriggerClientEvent('inventory:client:ItemBox', src, QBCore.Shared.Items["peyote"], 'remove')
			QBCore.Functions.Notify(Lang:t('peyote.you_made_tea'), "success")
			if Player.Functions.AddItem("peyote_tea", Config.GiveTea) then
			    TriggerClientEvent('inventory:client:ItemBox', src, QBCore.Shared.Items["peyote_tea"], 'add')
            else
                TriggerClientEvent('QBCore:Notify', src, Lang:t('peyote.not_have_peyote'))
            end
        else
    end
end)

RegisterNetEvent('knoes:peyotesellItems', function()
    local src = source
    local price = 0
    local Player = QBCore.Functions.GetPlayer(src)
    if Player.PlayerData.items and next(Player.PlayerData.items) then
        for k, v in pairs(Player.PlayerData.items) do
            if Player.PlayerData.items[k] then
                local itemname = Player.PlayerData.items[k].name
                local itemamount = Player.PlayerData.items[k].amount
                if Config.Sell[itemname] then
                    price = (Config.Sell[itemname].price * itemamount)
                    if Player.Functions.RemoveItem(itemname, itemamount, k) then
                        TriggerClientEvent('inventory:client:ItemBox', src, QBCore.Shared.Items[itemname], "remove")
                    end
                end
            end
        end
        Player.Functions.AddMoney("cash", price)
		TriggerClientEvent('QBCore:Notify', src, Lang:t('peyote.you_sold_peyote'))
	end
end)



if GetCurrentResourceName() ~= "knoes-peyote" then
    print("Error: Change the resource name to \"knoes-peyote\" or it won't work!")
end