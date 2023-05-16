local Translations = {
    peyote = {
        leave = 'Stopped Collecting.',
        progress = 'Collect Peyote.',
        getitem = 'x Collected Peyote.',
        pickpeyote = 'Collect Peyote',
        proccessing = 'You are making tea',
        cancel = 'Cancelled',
        not_have_peyote = 'Not have peyote',
        not_have_trowel = 'Not have trowel',
        you_made_tea = 'You made peyote tea',
        make_tea = 'Make Tea',
        sellpeyotetea = 'Sell Peyote and Tea',
        you_sold_peyote = 'You sold peyote',
    }
}

Lang = Lang or Locale:new({
    phrases = Translations,
    warnOnMissing = true
})
