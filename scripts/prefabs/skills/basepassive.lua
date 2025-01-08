local BASICPASSIVE ={
    hunger_plus = {
        name = "Hunger+",
        description = "Increases hunger capacity by 5 per level.",
        max_level = 5,
        effect = function(inst, level)
            local increase = 5 * level
            inst.components.hunger:SetMax(inst.components.hunger.max + increase)
        end,
        on_remove = function(inst, level)
            local decrease = 5 * level
            inst.components.hunger:SetMax(inst.components.hunger.max - decrease)
        end,
    },
    sanity_plus = {
        name = "Sanity+",
        description = "Increases sanity capacity by 5 per level.",
        max_level = 5,
        effect = function(inst, level)
            local increase = 5 * level
            inst.components.sanity:SetMax(inst.components.sanity.max + increase)
        end,
        on_remove = function(inst, level)
            local decrease = 5 * level
            inst.components.sanity:SetMax(inst.components.sanity.max - decrease)
        end,
    },
    health_plus = {
        name = "Health+",
        description = "Increases health capacity by 10 per level.",
        max_level = 5,
        effect = function(inst, level)
            local increase = 10 * level
            inst.components.health:SetMaxHealth(inst.components.health.maxhealth + increase)
        end,
        on_remove = function(inst, level)
            local decrease = 5 * level
            inst.components.health:SetMax(inst.components.health.maxhealth - decrease)
        end,
    },
}
return BASICPASSIVE
