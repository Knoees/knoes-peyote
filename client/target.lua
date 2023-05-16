local QBCore = exports['qb-core']:GetCoreObject()

CreateThread(function()
    exports['qb-target']:AddTargetModel("prop_peyote_lowland_01", {
        options = {
            {
                type = "client",
                event = "knoes-peyote:pickPeyote",
                icon = Config.TargetIcon,
                label = Lang:t("peyote.pickpeyote"),
            },
        },
        distance = 2.0
    })
end)


exports['qb-target']:AddBoxZone("makepeyotetea", ProcessingPeyote.targetZone, 1.4, 1.4, {
	name="makepeyotetea",
	heading = ProcessingPeyote.heading,
	debugPoly = false,
	minZ = ProcessingPeyote.minZ,
	maxZ = ProcessingPeyote.maxZ,
	}, {
		options = {
			{
				event = "knoes-peyote:proccessing",
                icon = Config.TargetIcon,
				label = Lang:t("peyote.make_tea"),
			},
		},
	   distance = 1.5
  })

  exports['qb-target']:AddBoxZone("sellpeyote", SellPeyote.targetZone, 1.4, 1.4, {
	name="sellpeyote",
	heading = SellPeyote.heading,
	debugPoly = false,
	minZ = SellPeyote.minZ,
	maxZ = SellPeyote.maxZ,
	}, {
		options = {
			{
				type = "server",
				event = "knoes:peyotesellItems",
                icon = Config.TargetIcon,
				label = Lang:t("peyote.sellpeyotetea"),
			},
		},
	   distance = 1.5
  })

