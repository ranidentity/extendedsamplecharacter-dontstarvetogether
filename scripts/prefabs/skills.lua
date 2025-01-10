local BASICPASSIVE = require("skills.basepassive")
local SWIMMING = require("skills.swimming")
local WORKSKILL = require("skills.work")

local SKILLS = {
    -- default passive
    hunger_plus = BASICPASSIVE.hunger_plus,
    sanity_plus = BASICPASSIVE.sanity_plus,
    health_plus = BASICPASSIVE.health_plus,
    swimming_skill = SWIMMING.swimming_skill,
    worker_plus = WORKSKILL.worker_plus,
    damage_boost = {
        name = "Damage Boost",
        description = "Increases damage by 10% per level.",
        max_level = 5,
        requirements= {},
        position={x=0,y=300},
        effect = function(inst, level)
            -- Calculate the damage boost
            local damage_increase = 0.1 * level -- 10% per level
            inst.damage_multiplier = 1 + damage_increase
            -- Increase damage by calculated amount
            inst.components.combat.externaldamagemultipliers:SetModifier(inst, "damage_boost", inst.damage_multiplier)
        end,
        on_remove = function(inst)
            -- Remove the damage boost when the skill is removed
            inst.components.combat.externaldamagemultipliers:RemoveModifier(inst, "damage_boost")
            inst.damage_multiplier = 1
        end,
    },
    -- active
    dash = {
        name = "Dash",
        description = "Leap forwards. CD: 10 seconds. Hunger Cost: 10-(2*level)",
        cooldown = 10,
        max_level = 5,
        requirements= {},
        position={x=0,y=400},
        effect = function(inst, level)
            if inst.dash_cd then
                print("Dash is on cooldown!")
                return
            end
            local base_cost = 10
            local hunger_cost = base_cost - (2 * level) -- Reduce 2 hunger per level
            hunger_cost = math.max(hunger_cost, 1) -- Minimum cost is 1 hunger

            if inst.components.hunger.current < hunger_cost then
                print("Not enough hunger to dash!")
                return
            end
            inst.components.hunger:DoDelta(-hunger_cost)

            local speed_boost = 2.0 + (level*0.3)
            inst.components.locomotor:SetExternalSpeedMultiplier(inst,"dash",speed_boost)

            inst:DoTaskInTime(0.5,function()
                inst.components.locomotor:RemoveExternalSpeedMultiplier(inst,"dash")
            end)
            -- inst.dash_cd = GetTime()+10
            inst.dash_cd = true
            inst:DoTaskInTime(10, function() 
                inst.dash_cd = nil 
                end)
        end,
    },

    smash = {
        name= "Smash",
        description= "Slam the ground. Level 3 and above inflict stun. CD: 15 seconds. Hunger Cost: 15 - (2*level). Sanity Cost: 15 - (2*level). ",
        cooldown = 15,
        max_level = 5,
        requirements= {},
        position={x=0,y=400},
        effect = function(inst, level)
            if inst.smash_ground_cd then
                print("Smash is on cooldown!")
                return
            end
            local base_cost = 15
            local hunger_cost = base_cost - (2 * level) -- Reduce 3 hunger per level
            hunger_cost = math.max(hunger_cost, 1) -- Minimum cost is 1 hunger
            if inst.components.hunger.current >= hunger_cost then
                inst.components.hunger:DoDelta(-hunger_cost)
            else
                print("Not enough hunger to smash ground!")
                return
            end
            local sanity_cost = base_cost - (2 * level) -- Reduce 3 hunger per level
            if inst.components.sanity.current >= sanity_cost then
                inst.components.sanity:DoDelta(-sanity_cost)
            else
                print("Not enough sanity to smash ground!")
                return
            end
            -- inst.AnimState:PlayAnimation("smash_ground")
            -- inst.SoundEmitter:PlaySound("dontstarve/common/deathpoof")
            local stun_duration = 0 + (0.5 * level) -- Increase stun duration by 0.5 seconds per level
            local radius = 2+ (0.5 * level)  -- Radius of the smash effect
            local x, y, z = inst.Transform:GetWorldPosition()
            local ents = TheSim:FindEntities(x, y, z, radius, { "combat" }, { "player", "INLIMBO" })

            -- Define damage based on base_damage
            local damage = inst.base_damage + (10 * level) -- Scale damage with level
            if inst.damage_multiplier then
                damage = damage * inst.damage_multiplier
            end
    
            for _, ent in ipairs(ents) do
                if ent.components.combat and ent ~= inst then
                    --damage
                    ent.components.combat:GetAttacked(inst, damage)
                    -- knock back
                    if ent.components.health and not ent.components.health:IsDead() then
                        local knockback = 1 + (0.2 * level)
                        local dx, dy, dz = ent.Transform:GetWorldPosition()
                        local angle = (inst:GetAngleToPoint(dx, dy, dz) + 180) * DEGREES -- Calculate knockback direction
                        local knockback_vector = Vector3(math.cos(angle), 0, -math.sin(angle)) * knockback
                        ent.components.locomotor:KnockBack(inst.Transform:GetWorldPosition(), knockback_vector)
                        -- ent:PushEvent("knockback", { knocker = inst, radius = radius, strengthmult = knockback })
                    end
                    -- stun
                    if level > 3 and ent.components.combat then
                        ent.components.combat:SetTarget(nil) -- Stop attacking
                        ent.components.combat:SetAttackPeriod(stun_duration) -- Prevent attacking for the stun duration
                    end
                end
            end
           
            inst.smash_ground_cd = true
            inst:DoTaskInTime(15, function() inst.smash_ground_cd = nil end)
        end
    },
}

-- Return the skills table so it can be imported elsewhere
return SKILLS
