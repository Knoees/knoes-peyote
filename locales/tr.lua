local Translations = {
    peyote = {
        leave = 'Toplamayı bıraktın.',
        progress = 'Peyote Topluyorsun.',
        getitem = 'x Adet Peyote Topladın.',
        pickpeyote = 'Peyote Topla',
        proccessing = 'Çay yapıyorsun',
        cancel = 'İptal edildi',
        not_have_peyote = 'Hiç peyoten yok',
        not_have_trowel = 'Toplamak için küreğe ihtiyacın var',
        you_made_tea = 'Peyote çayı yaptın',
        make_tea = 'Çay Yap',
        sellpeyotetea = 'Peyote ve çayını sat',
        you_sold_peyote = 'Peyote sattın',
    }
}

Lang = Lang or Locale:new({
    phrases = Translations,
    warnOnMissing = true
})
