if SERVER then
    AddCSLuaFile()
    resource.AddFile("materials/vgui/ttt/weapon_explosive_crosstol.vmt")
    resource.AddFile("sound/explosive_crosstol.wav")
    resource.AddFile("sound/explosive_crosstol2.wav")
end

SWEP.Author = "mexikoedi"
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
SWEP.ViewModelFOV = 54
SWEP.ViewModelFlip = true
SWEP.NoSights = false
SWEP.AllowDrop = true
SWEP.AllowPickup = true
SWEP.IsSilent = false
SWEP.Spawnable = true
SWEP.AdminSpawnable = true
SWEP.AutoSpawnable = false
SWEP.Primary.Sound = Sound("explosive_crosstol.wav")
SWEP.Primary.Recoil = 50
SWEP.Primary.Damage = 100
SWEP.Primary.NumShots = -1
SWEP.Primary.Delay = 5
SWEP.Primary.Distance = 10
SWEP.Primary.ClipSize = 1
SWEP.Primary.DefaultClip = 1
SWEP.Primary.Automatic = false
SWEP.Primary.Ammo = "XBowBolt"
BOLT_MODEL = "models/crossbow_bolt.mdl"
SWEP.Secondary.Sound = Sound("explosive_crosstol2.wav")
SWEP.Secondary.ClipSize = -1
SWEP.Secondary.DefaultClip = -1
SWEP.Secondary.Automatic = false
SWEP.Secondary.Ammo = "none"
SWEP.Secondary.Delay = 5
SWEP.UseHands = true
SWEP.ViewModel = "models/weapons/cstrike/c_pist_fiveseven.mdl"
SWEP.WorldModel = "models/weapons/w_pist_fiveseven.mdl"
SWEP.IronSightsPos = Vector(-5.95, -4, 2.799)
SWEP.IronSightsAng = Vector(0, 0, 0)

function SWEP:Initialize()
    if CLIENT then
        self:AddHUDHelp("ttt2_explosive_crosstol_help1", "ttt2_explosive_crosstol_help2", true)
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
        if (not self:CanPrimaryAttack()) then return end
        local tr = self:GetOwner():GetEyeTrace()
        local dmg = DamageInfo()
        dmg:SetDamageType(64)
        dmg:SetDamage(100)
        dmg:SetAttacker(self:GetOwner())
        dmg:SetInflictor(self)
        util.BlastDamageInfo(dmg, tr.HitPos, 300)
        local eyetrace = self:GetOwner():GetEyeTrace()
        self:EmitSound("explosive_crosstol.wav")
        self.BaseClass.ShootEffects(self)
        local explode = ents.Create("env_explosion")
        explode:SetPos(eyetrace.HitPos)
        explode:SetOwner(self:GetOwner())
        explode:Spawn()
        explode:Fire("Explode", 0, 0)
        explode:EmitSound("explosive_crosstol.wav", 400, 400)
        self:SetNextPrimaryFire(CurTime() + 5)
        self:SetNextSecondaryFire(CurTime() + 5)
        self:TakePrimaryAmmo(1)
    end
end

SWEP.NextSecondaryAttack = 0

function SWEP:SecondaryAttack()
    if self.NextSecondaryAttack > CurTime() then return end
    self.NextSecondaryAttack = CurTime() + self.Secondary.Delay

    if SERVER then
        self.currentOwner = self:GetOwner()
        self:GetOwner():EmitSound("explosive_crosstol2.wav")
    end
end
