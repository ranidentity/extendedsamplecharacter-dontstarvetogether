local SWIMMING ={
    swimming_skill = {
        name = "Swimming",
        description = "Enables swimming. Reduce sanity, hunger, and speed based on level.",
        max_level = 5,
        requirements= {"hunger_plus","sanity_plus","health_plus"},
        position={x=150,y=100},
        on_level_up = function(inst, level)
            -- Enable swimming if not already enabled
            if not inst:HasTag("swimmer") then
                inst:AddTag("swimmer")
                -- Modify movement on water
                -- inst.components.locomotor:SetAllowPlatformHopping(true)
                inst.components.locomotor:SetWaterSpeedMultiplier(0.8) -- Default water speed_bonus 
            end
    
            -- Update effects based on level
            -- Apply speed bonus
            local speed_bonus = 0.1 * level -- +10% speed per level
            inst.components.locomotor:SetExternalSpeedMultiplier(inst, "swimming_speed", 1 + speed_bonus)

            -- Apply hunger and sanity consumption reduction
            local hunger_consumption_reduction = 0.05 * level -- 5% per level
            local sanity_consumption_reduction = 0.05 * level -- 5% per level
            inst.components.hunger.hungerrate = TUNING.WILSON_HUNGER_RATE * (1 - hunger_consumption_reduction)
            inst.components.sanity.dapperness = TUNING.WILSON_SANITY_DAPPERNESS * (1 - sanity_consumption_reduction)
        end,
        on_remove = function(inst)
            -- Remove swimming ability
            inst:RemoveTag("swimmer")
            -- inst.components.locomotor:SetAllowPlatformHopping(false)
            inst.components.locomotor:SetWaterSpeedMultiplier(0.5) -- Default water speed for non-swimmers
    
            -- Reset stats to default
            inst.components.sanity.max = TUNING.ESCTEMPLATE_SANITY
            inst.components.sanity:SetPercent(inst.components.sanity:GetPercent())
    
            inst.components.hunger.max = TUNING.ESCTEMPLATE_HUNGER
            inst.components.hunger:SetPercent(inst.components.hunger:GetPercent())
    
            inst.components.locomotor:RemoveExternalSpeedMultiplier(inst, "swimming_speed")
        end,
    },
}
return SWIMMING