-- convars added with default values
CreateConVar("ttt2_explosive_crosstol_attack_primary_sound", "1", {FCVAR_ARCHIVE, FCVAR_NOTIFY}, "Sound of the primary attack")
CreateConVar("ttt2_explosive_crosstol_attack_secondary_sound", "1", {FCVAR_ARCHIVE, FCVAR_NOTIFY}, "Sound of the secondary attack")
CreateConVar("ttt2_explosive_crosstol_automaticFire", "0", {FCVAR_ARCHIVE, FCVAR_NOTIFY}, "Enable automatic fire")
CreateConVar("ttt2_explosive_crosstol_damage", "100", {FCVAR_ARCHIVE, FCVAR_NOTIFY}, "Damage dealt on impact")
CreateConVar("ttt2_explosive_crosstol_radius", "300", {FCVAR_ARCHIVE, FCVAR_NOTIFY}, "Radius of the explosion")
CreateConVar("ttt2_explosive_crosstol_ammo", "1", {FCVAR_ARCHIVE, FCVAR_NOTIFY}, "Default ammo the explosive crosstol has when bought")
CreateConVar("ttt2_explosive_crosstol_clipSize", "1", {FCVAR_ARCHIVE, FCVAR_NOTIFY}, "Clipsize of the explosive crosstol")
CreateConVar("ttt2_explosive_crosstol_rps", "1", {FCVAR_ARCHIVE, FCVAR_NOTIFY}, "Shots per second")
if CLIENT then
    -- Use string or string.format("%.f",<steamid64>) 
    -- addon dev emblem in scoreboard
    hook.Add("TTT2FinishedLoading", "TTT2RegistermexikoediAddonDev", function() AddTTT2AddonDev("76561198279816989") end)
end