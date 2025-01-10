

local DANCE ={
    royale_steps = {
        name = "Royale Steps",
        description = "Dancing.",
        max_level = 1,
        channel_time = 5, -- Channeling duration in seconds
        requirements= {"worker_plus"},
        position={x=150,y=200},
        on_start = function(inst, level)
            -- Start channeling
            inst.components.channeling:StartChanneling()
        end,
        on_channeling = function(inst, level, dt)
            if inst.components.farmingmodifier then
                inst.components.farmingmodifier:SetStressModifier("moisture", 0.9) -- Reduce moisture stress by 10%
                inst.components.farmingmodifier:SetStressModifier("nutrient", 0.9) -- Reduce nutrient stress by 10%
                inst.components.farmingmodifier:SetStressModifier("family", 0.9) -- Reduce family stress by 10%
                inst.components.farmingmodifier:SetStressModifier("season", 0.9) -- Reduce seasonal stress by 10%
            end
        end,
        on_stop = function(inst, level)
            -- Stop channeling
            inst.components.channeling:StopChanneling()
            -- if inst.components.farmingmodifier then
            --     inst.components.farmingmodifier:SetStressModifier("moisture", 1.0) -- Reset moisture stress
            --     inst.components.farmingmodifier:SetStressModifier("nutrient", 1.0) -- Reset nutrient stress
            --     inst.components.farmingmodifier:SetStressModifier("family", 1.0) -- Reset family stress
            --     inst.components.farmingmodifier:SetStressModifier("season", 1.0) -- Reset seasonal stress
            -- end
        end,
    },
}
return DANCE