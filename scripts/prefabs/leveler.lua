local Leveler = {}
local SKILLS = require("skills")

MIN_HEALTH = 100
MAX_HEALTH = 400
MIN_HUNGER = 100
MAX_HUNGER = 600
MIN_SANITY = 100
MAX_SANITY = 200
MIN_DAMAGE_MULT = 1
MAX_DAMAGE_MULT = 5
MIN_SPEED_MULT = 1
MAX_SPEED_MULT = 3
function Leveler.Init(inst)
	-- Example: Add level system
	inst.level = inst.level or 1
	inst.experience = inst.experience or 0
	inst.skillpoints = inst.skillpoints or 0
    inst.unlocked_skills = inst.unlocked_skills or {}

	-- Level up function
	function inst:LevelUp()
		self.level = self.level + 1
		self.skillpoints = self.skillpoints + 1
		self.components.health:SetMaxHealth(self.components.health.maxhealth + 10)
		self.components.sanity:SetMax(self.components.sanity.max + 10)
		self.components.hunger:SetMax(self.components.hunger.max + 10)
	end

	-- Gain experience function
	function inst:GainExperience(amount)
		self.experience = self.experience + amount
		if self.experience >= 100 * self.level then
			self.experience = self.experience - 100 * self.level
			self:LevelUp()
		end
	end

	function inst:UnlockSkill(skill_name)
        if self.skillpoints > 0 and SKILLS[skill_name] then
			local current_level = self.unlocked_skills[skill_name] or 0
			if current_level >= SKILLS[skill_name].max_level then
				print(SKILLS[skill_name].name .. " is already at max level!")
				return
			end
            self.skillpoints = self.skillpoints - 1
            self.unlocked_skills[skill_name] = (self.unlocked_skills[skill_name] or 0) + 1
            SKILLS[skill_name].effect(self, self.unlocked_skills[skill_name])
            print("Unlocked " .. SKILLS[skill_name].name .. " at level " .. tostring(self.unlocked_skills[skill_name]))
        else
            print("Not enough skill points or invalid skill.")
        end
    end

	-- default level up buff
	function Leveler.ApplyBuffs(inst)
        if inst.level >= 5 then
            -- Example: Faster movement speed at level 5+
            inst.components.locomotor:SetExternalSpeedMultiplier(inst, "level_buff", 1.25) -- 25% faster
        end

        if inst.level >= 10 then
            -- Example: Damage multiplier at level 10+
            if inst.components.combat then
                inst.components.combat.externaldamagemultipliers:SetModifier("level_buff", 1.5) -- 50% more damage
            end
        end

        if inst.level >= 15 then
            -- Example: Regenerate health slowly at level 15+
            if not inst.components.healthregen then
                inst:AddComponent("healthregen")
            end
            inst.components.healthregen:SetRate(1) -- Regenerate 1 health per second
        end
    end

	inst.OnSave = function(inst, data)
		data.Level = inst.level
		data.experience = inst.experience
		data.skillpoints = inst.skillpoints
        data.unlocked_skills = inst.unlocked_skills
	end
	inst.OnLoad = function(inst, data)
        if data then
            inst.level = data.level or 1
            inst.experience = data.experience or 0
			inst.skillpoints = data.skillpoints or 0
            inst.unlocked_skills = data.unlocked_skills or {}
			Leveler.ApplyBuffs(inst)
			 -- Reapply skills on load
			 for skill_name, level in pairs(inst.unlocked_skills) do
                if SKILLS[skill_name] then
                    SKILLS[skill_name].effect(inst, level)
                end
            end
        end
    end
	-- Hook into kills (example)
	inst:ListenForEvent("killed", function(_, data)
		if data.victim and data.victim.prefab then
			inst:GainExperience(10) -- Gain XP for kills
		end
	end)

	Leveler.ApplyBuffs(inst)
end

return Leveler
