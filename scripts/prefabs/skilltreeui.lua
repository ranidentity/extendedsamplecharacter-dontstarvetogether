local SkillTreeUI = Class(function(self, owner)
    self.owner = owner
    self.root = self.owner.HUD.controls:AddChild(Widget("SkillTreeUI"))
    self.root:SetPosition(0, 0, 0) -- Position the UI
    self.root:SetScale(1, 1, 1) -- Scale the UI

    -- Background
    self.bg = self.root:AddChild(Image("images/ui/skilltree_bg.xml", "skilltree_bg.tex"))
    self.bg:SetSize(400, 400) -- Set size of the background

    -- Skill Buttons
    self.skillButtons = {}
    local skills = {
        { name = "Dash", pos = Vector3(-100, 100, 0) },
        { name = "Smash", pos = Vector3(100, 100, 0) },
        { name = "Royale Steps", pos = Vector3(0, -100, 0) },
    }

    for i, skill in ipairs(skills) do
        local button = self.root:AddChild(ImageButton("images/ui/skill_icon.xml", "skill_icon.tex"))
        button:SetPosition(skill.pos.x, skill.pos.y, skill.pos.z)
        button:SetOnClick(function()
            self:OnSkillClicked(skill.name)
        end)
        button:SetTooltip(skill.name) -- Add a tooltip
        table.insert(self.skillButtons, button)
    end

    -- Hide the UI by default
    self.root:Hide()
end)

-- Show the UI
function SkillTreeUI:Show()
    self.root:Show()
end

-- Hide the UI
function SkillTreeUI:Hide()
    self.root:Hide()
end

-- Handle skill button clicks
function SkillTreeUI:OnSkillClicked(skillName)
    print("Skill clicked:", skillName)
    -- Add logic to unlock or activate the skill
end

function SkillTreeUI:UpdateSkills()
    for i, button in ipairs(self.skillButtons) do
        local skillName = button.tooltip
        if self.owner.unlocked_skills[skillName] then
            button:SetText("Unlocked") -- Update button text or appearance
            -- button:SetNormalTexture("images/ui/skill_icon_unlocked.xml", "skill_icon_unlocked.tex")
        else
            button:SetText("Locked")
            -- button:SetNormalTexture("images/ui/skill_icon_locked.xml", "skill_icon_locked.tex")
        end
    end
end

-- handle skills requirements, branches
function SkillTreeUI:UnlockSkill(skillName)
    if not self.owner.unlocked_skills[skillName] then
        self.owner.unlocked_skills[skillName] = true
        self:UpdateSkills() -- Refresh the UI
    end
end

return SkillTreeUI
