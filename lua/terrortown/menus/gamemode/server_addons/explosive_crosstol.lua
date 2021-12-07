CLGAMEMODESUBMENU.base = "base_gamemodesubmenu"
CLGAMEMODESUBMENU.priority = 0
CLGAMEMODESUBMENU.title = "submenu_addons_explosive_crosstol_title"

function CLGAMEMODESUBMENU:Populate(parent)
    local form = vgui.CreateTTT2Form(parent, "header_addons_explosive_crosstol")

    form:MakeCheckBox({
        serverConvar = "ttt2_explosive_crosstol_attack_primary_sound",
        label = "label_explosive_crosstol_primary_sound"
    })

    form:MakeCheckBox({
        serverConvar = "ttt2_explosive_crosstol_attack_secondary_sound",
        label = "label_explosive_crosstol_secondary_sound"
    })

    form:MakeCheckBox({
        serverConvar = "ttt2_explosive_crosstol_automaticFire",
        label = "label_explosive_crosstol_automaticFire"
    })

    form:MakeSlider({
        serverConvar = "ttt2_explosive_crosstol_damage",
        label = "label_explosive_crosstol_damage",
        min = 0,
        max = 200,
        decimal = 0
    })

    form:MakeSlider({
        serverConvar = "ttt2_explosive_crosstol_ammo",
        label = "label_explosive_crosstol_ammo",
        min = 0,
        max = 10,
        decimal = 0
    })

    form:MakeSlider({
        serverConvar = "ttt2_explosive_crosstol_clipSize",
        label = "label_explosive_crosstol_clipSize",
        min = 0,
        max = 10,
        decimal = 0
    })

    form:MakeSlider({
        serverConvar = "ttt2_explosive_crosstol_rps",
        label = "label_explosive_crosstol_rps",
        min = 0,
        max = 10,
        decimal = 1
    })
end