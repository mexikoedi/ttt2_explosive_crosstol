if SERVER then
    AddCSLuaFile()
    resource.AddFile("materials/vgui/ttt/weapon_explosive_crosstol.vmt")
    resource.AddFile("sound/explosive_crosstol.wav")
    resource.AddFile("sound/explosive_crosstol2.wav")
end

SWEP.Base = "weapon_tttbase"
SWEP.Kind = WEAPON_EQUIP1
SWEP.HoldType = "pistol"
SWEP.InLoadoutFor = nil
SWEP.CanBuy = {ROLE_TRAITOR}
SWEP.LimitedStock = true
SWEP.Icon = "vgui/ttt/weapon_explosive_crosstol"
SWEP.EquipMenuData = {
    type = "item_weapon",
    name = "ttt2_explosive_crosstol_name",
    desc = "ttt2_explosive_crosstol_desc"
}

SWEP.PrintName = "Explosive Crosstol"
SWEP.Author = "mexikoedi"
SWEP.Contact = "Steam"
SWEP.Instructions = "Left click to shoot an explosive crossbow arrow and secondary attack to play a sound."
SWEP.Purpose = "Create a massive explosion and afterwards taunt you enemies with secondary attack."
SWEP.ViewModelFOV = 74
SWEP.ViewModelFlip = true
SWEP.NoSights = false
SWEP.AllowDrop = true
SWEP.AllowPickup = true
SWEP.IsSilent = false
SWEP.Spawnable = false
SWEP.AdminOnly = false
SWEP.AdminSpawnable = false
SWEP.AutoSpawnable = false
SWEP.Primary.Recoil = 50
SWEP.Primary.Damage = GetConVar("ttt2_explosive_crosstol_damage"):GetInt()
SWEP.Primary.NumShots = -1
SWEP.Primary.Delay = 1
SWEP.Primary.Radius = GetConVar("ttt2_explosive_crosstol_radius"):GetInt()
SWEP.Primary.ClipSize = GetConVar("ttt2_explosive_crosstol_clipSize"):GetInt()
SWEP.Primary.DefaultClip = GetConVar("ttt2_explosive_crosstol_ammo"):GetInt()
SWEP.Primary.Automatic = GetConVar("ttt2_explosive_crosstol_automaticFire"):GetBool()
SWEP.Primary.RPS = GetConVar("ttt2_explosive_crosstol_rps"):GetFloat()
SWEP.Primary.Ammo = "XBowBolt"
SWEP.Secondary.ClipSize = -1
SWEP.Secondary.DefaultClip = -1
SWEP.Secondary.Automatic = false
SWEP.Secondary.Ammo = "none"
SWEP.Secondary.Delay = 5
SWEP.UseHands = true
SWEP.ViewModel = "models/weapons/v_pist_fiveseven.mdl"
SWEP.WorldModel = "models/weapons/w_pist_fiveseven.mdl"
SWEP.IronSightsPos = Vector(-5.95, -4, 2.799)
SWEP.IronSightsAng = Vector(0, 0, 0)
function SWEP:Initialize()
    if CLIENT then self:AddTTT2HUDHelp("ttt2_explosive_crosstol_help1", "ttt2_explosive_crosstol_help2") end
    if SERVER then
        self.Primary.ClipSize = GetConVar("ttt2_explosive_crosstol_clipSize"):GetInt()
        self.Primary.DefaultClip = GetConVar("ttt2_explosive_crosstol_ammo"):GetInt()
        self.Primary.Automatic = GetConVar("ttt2_explosive_crosstol_automaticFire"):GetBool()
        self.Primary.RPS = GetConVar("ttt2_explosive_crosstol_rps"):GetFloat()
    end
end

function SWEP:DrawWorldModel()
    self:DrawModel()
end

function SWEP:Reload()
end

function SWEP:Holster()
    if SERVER and IsValid(self.currentOwner) then self.currentOwner:StopSound("explosive_crosstol2.wav") end
    return true
end

function SWEP:OnRemove()
    if SERVER and IsValid(self.currentOwner) then self.currentOwner:StopSound("explosive_crosstol2.wav") end
end

function SWEP:OnDrop()
    if SERVER and IsValid(self.currentOwner) then self.currentOwner:StopSound("explosive_crosstol2.wav") end
end

function SWEP:Think()
end

if SERVER then
    function SWEP:PrimaryAttack()
        self:SetNextPrimaryFire(CurTime() + self.Primary.Delay / self.Primary.RPS)
        if not self:CanPrimaryAttack() then return end
        local owner = self:GetOwner()
        if not IsValid(owner) then return end
        local eyetrace = owner:GetEyeTrace()
        local hitPos = eyetrace.HitPos
        self:ShootEffects()
        local explode = ents.Create("env_explosion")
        explode:SetPos(hitPos)
        explode:SetOwner(owner)
        explode:Spawn()
        explode:Fire("Explode", "", 0)
        if GetConVar("ttt2_explosive_crosstol_attack_primary_sound"):GetBool() then explode:EmitSound("explosive_crosstol.wav", 400) end
        local radius = self.Primary.Radius
        local maxDamage = self.Primary.Damage
        local entities = ents.FindInSphere(hitPos, radius)
        for _, ent in ipairs(entities) do
            if IsValid(ent) and ent:IsPlayer() and ent:IsActive() then
                local distance = hitPos:Distance(ent:GetPos())
                local damage = maxDamage
                if distance > 0 then damage = maxDamage * math.max(0, 1 - distance / radius) end
                if ent == eyetrace.Entity then damage = maxDamage end
                local dmgInfo = DamageInfo()
                dmgInfo:SetDamage(damage)
                dmgInfo:SetAttacker(owner)
                dmgInfo:SetInflictor(self)
                dmgInfo:SetDamageType(DMG_BLAST)
                ent:TakeDamageInfo(dmgInfo)
            end
        end

        self:TakePrimaryAmmo(1)
    end
end

SWEP.NextSecondaryAttack = 0
function SWEP:SecondaryAttack()
    if self.NextSecondaryAttack > CurTime() then return end
    self.NextSecondaryAttack = CurTime() + self.Secondary.Delay
    if SERVER and GetConVar("ttt2_explosive_crosstol_attack_secondary_sound"):GetBool() then
        self.currentOwner = self:GetOwner()
        if IsValid(self.currentOwner) then self.currentOwner:EmitSound("explosive_crosstol2.wav") end
    end
end

if CLIENT then
    function SWEP:AddToSettingsMenu(parent)
        local form = vgui.CreateTTT2Form(parent, "header_equipment_additional")
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
            serverConvar = "ttt2_explosive_crosstol_radius",
            label = "label_explosive_crosstol_radius",
            min = 0,
            max = 500,
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
end