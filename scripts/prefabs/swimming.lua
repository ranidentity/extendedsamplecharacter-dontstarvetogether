local function UpdateSwimmingEffects(inst, level)
    -- Define scaling values
    local sanity_bonus = 10 * level -- +10 sanity per level
    local hunger_bonus = 5 * level  -- +5 hunger per level
    local speed_bonus = 0.1 * level -- +10% speed per level

    -- Reduce hunger and sanity consumption by 5% per level
    local hunger_consumption_reduction = 0.05 * level -- 5% per level
    local sanity_consumption_reduction = 0.05 * level -- 5% per level

    -- Apply sanity bonus
    inst.components.sanity.max = TUNING.ESCTEMPLATE_SANITY + sanity_bonus
    inst.components.sanity:SetPercent(inst.components.sanity:GetPercent()) -- Maintain current percentage

    -- Apply hunger bonus
    inst.components.hunger.max = TUNING.ESCTEMPLATE_HUNGER + hunger_bonus
    inst.components.hunger:SetPercent(inst.components.hunger:GetPercent()) -- Maintain current percentage

    -- Apply speed bonus
    inst.components.locomotor:SetExternalSpeedMultiplier(inst, "swimming_speed", 1 + speed_bonus)

    -- Apply hunger and sanity consumption reduction
    inst.components.hunger.hungerrate = TUNING.WILSON_HUNGER_RATE * (1 - hunger_consumption_reduction)
    inst.components.sanity.dapperness = TUNING.WILSON_SANITY_DAPPERNESS * (1 - sanity_consumption_reduction)
end