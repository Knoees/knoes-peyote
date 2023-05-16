# knoes-peyote
Discord:  https://discord.gg/PEXhhkYcW4
Preview: https://youtu.be/4GRq0lilbY0

- Low Resmon 

! [image] (https://cdn.discordapp.com/attachments/1081604119241969724/1108025609323548772/image.png)

- Setup

İmages >  
qb-inventory>html>images add

İtems >
qb-core>shared>items add
```
    -- Peyote
	['peyote'] 						 = {['name'] = 'peyote', 			 	  	  	['label'] = 'Peyote',                   ['weight'] = 200, 		['type'] = 'item', 		['image'] = 'peyote.png', 				['unique'] = false, 	['useable'] = true, 	['shouldClose'] = true,   ['combinable'] = nil,   ['description'] = 'Peyote'},
	['peyote_tea'] 				 = {['name'] = 'peyote_tea', 			     	['label'] = 'Peyote Tea',               ['weight'] = 200, 		['type'] = 'item', 		['image'] = 'peyote_tea.png', 			['unique'] = false, 	['useable'] = true, 	['shouldClose'] = true,   ['combinable'] = nil,   ['description'] = 'Peyote Tea'},

```
For Peyote Tea

qb-smallresources>config add
```
ConsumablesDrink = {
    ["peyote_tea"] = math.random(35, 54),
}
```
qb-smallresources>server>consumables add
```
QBCore.Functions.CreateUseableItem("peyote_tea", function(source, item)
    local Player = QBCore.Functions.GetPlayer(source)
	if not Player.Functions.RemoveItem(item.name, 1, item.slot) then return end
    TriggerClientEvent("consumables:client:Drink", source, item.name)
end)
```

Support : https://discord.gg/PEXhhkYcW4
