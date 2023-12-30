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
SWEP.Primary.Distance = 10
SWEP.Primary.ClipSize = GetConVar("ttt2_explosive_crosstol_clipSize"):GetInt()
SWEP.Primary.DefaultClip = GetConVar("ttt2_explosive_crosstol_ammo"):GetInt()
SWEP.Primary.Automatic = GetConVar("ttt2_explosive_crosstol_automaticFire"):GetBool()
SWEP.Primary.RPS = GetConVar("ttt2_explosive_crosstol_rps"):GetFloat()
SWEP.Primary.Ammo = "XBowBolt"
BOLT_MODEL = "models/crossbow_bolt.mdl"
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
    if CLIENT then
        self:AddHUDHelp("ttt2_explosive_crosstol_help1", "ttt2_explosive_crosstol_help2", true)
    end

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
    if SERVER and IsValid(self.currentOwner) then
        self.currentOwner:StopSound("explosive_crosstol2.wav")
    end

    return true
end

function SWEP:OnRemove()
    if SERVER and IsValid(self.currentOwner) then
        self.currentOwner:StopSound("explosive_crosstol2.wav")
    end
end

function SWEP:OnDrop()
    if SERVER and IsValid(self.currentOwner) then
        self.currentOwner:StopSound("explosive_crosstol2.wav")
    end
end

function SWEP:Think()
end

if SERVER then
    function SWEP:PrimaryAttack()
        self:SetNextPrimaryFire(CurTime() + self.Primary.Delay / self.Primary.RPS)
        if not self:CanPrimaryAttack() then return end
        local eyetrace = self:GetOwner():GetEyeTrace()
        self.BaseClass.ShootEffects(self)
        local explode = ents.Create("env_explosion")
        explode:SetPos(eyetrace.HitPos)
        explode:SetOwner(self:GetOwner())
        explode:Spawn()
        explode:Fire("Explode", 0, 0)

        if GetConVar("ttt2_explosive_crosstol_attack_primary_sound"):GetBool() then
            explode:EmitSound("explosive_crosstol.wav", 400)
        end

        local tr = self:GetOwner():GetEyeTrace()
        local dmg = DamageInfo()
        dmg:SetDamageType(64)
        dmg:SetDamage(self.Primary.Damage / 2)
        dmg:SetAttacker(self:GetOwner())
        dmg:SetInflictor(self)
        util.BlastDamageInfo(dmg, tr.HitPos, 300)
        self:TakePrimaryAmmo(1)
    end
end

SWEP.NextSecondaryAttack = 0

function SWEP:SecondaryAttack()
    if self.NextSecondaryAttack > CurTime() then return end
    self.NextSecondaryAttack = CurTime() + self.Secondary.Delay

    if SERVER and GetConVar("ttt2_explosive_crosstol_attack_secondary_sound"):GetBool() then
        self.currentOwner = self:GetOwner()
        self:GetOwner():EmitSound("explosive_crosstol2.wav")
    end
end