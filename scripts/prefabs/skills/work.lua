local WORKSKILL = {
    worker_plus = {
        name = "Worker+",
        description = "Increases working performance by 10%.",
        max_level = 1,
        effect = function(inst, level)
            -- Increase gathering speed by 10%
            if inst.components.worker then
                inst.components.worker.gather_speed_mult = (inst.components.worker.gather_speed_mult or 1) + 0.10
            end
            -- Add a hook to modify the yield when planting
            if inst.components.planter then
                inst:ListenForEvent("on_plant", function(inst, data)
                    -- Check for a random chance to double the yield
                    if math.random() < 0.20 then -- 20% chance to double
                        data.yield = data.yield * 2
                    end
                end)
            end
        end,
        on_remove = function(inst, level)
            -- Revert the gathering speed increase
            if inst.components.worker then
                inst.components.worker.gather_speed_mult = (inst.components.worker.gather_speed_mult or 1) - 0.10
            end
            -- Remove the hook when the skill is removed
            if inst.components.planter then
                inst:RemoveEventCallback("on_plant", nil, inst)
            end
        end,
    },
}
return WORKSKILL