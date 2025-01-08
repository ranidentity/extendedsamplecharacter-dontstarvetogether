local SKILLS = require("skills") -- Import skills

local Keybinds = {}

Keybinds.Register = function()
    -- Helper function to register a keybind for a skill
    local function RegisterSkillKeybind(key, skill_name, skill)
        GLOBAL.TheInput:AddKeyDownHandler(key, function()
            local player = GLOBAL.ThePlayer -- Get the current player
            if player and player.unlocked_skills and player.unlocked_skills[skill_name] then
                -- Trigger the skill
                if skill and not skill.on_cooldown then
                    skill.effect(player) -- Call the skill's effect function
                    skill.on_cooldown = true

                    -- Start the cooldown timer
                    player:DoTaskInTime(skill.cooldown or 0, function()
                        skill.on_cooldown = false
                    end)
                end
            else
                print(skill_name .. " not learnt!")
            end
        end)
    end

    -- Register keybinds for each skill
    RegisterSkillKeybind(GLOBAL.KEY_X, "dash", SKILLS.dash)
    RegisterSkillKeybind(GLOBAL.KEY_C, "smash", SKILLS.smash)
    RegisterSkillKeybind(GLOBAL.KEY_F, "royale_steps", SKILLS.royale_steps)
end

return Keybinds
