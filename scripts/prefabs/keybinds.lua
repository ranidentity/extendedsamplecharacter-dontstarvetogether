local SKILLS = require("skills") -- Import skills

local Keybinds = {}

Keybinds.Register = function(inst)
-- Dash Keybind
    GLOBAL.TheInput:AddKeyDownHandler(GLOBAL.KEY_X, function()
        if inst and inst.unlocked_skills and inst.unlocked_skills["dash"] then
            SKILLS.dash.effect(inst) -- Trigger Dash skill
        else
            print("Dash not learnt!")
        end
    end)
    GLOBAL.TheInput:AddKeyDownHandler(GLOBAL.KEY_C, function()
        if inst and inst.unlocked_skills and inst.unlocked_skills["smash"] then
            SKILLS.smash.effect(inst) -- Trigger Dash skill
        else
            print("Smash not learnt!")
        end
    end)
end

return Keybinds
