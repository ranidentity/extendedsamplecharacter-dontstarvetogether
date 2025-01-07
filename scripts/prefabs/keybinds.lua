local SKILLS = require("skills") -- Import skills

local Keybinds = {}

Keybinds.Register = function(inst)
-- Dash Keybind
    GLOBAL.TheInput:AddKeyDownHandler(GLOBAL.KEY_X, function()
        if inst and inst.unlocked_skills and inst.unlocked_skills["dash"] then
            SKILLS.dash.effect(inst) -- Trigger Dash skill
        else
            print("Dash not unlocked!")
        end
    end)
end

return Keybinds
