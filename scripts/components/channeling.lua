local Channeling = Class(function(self, inst)
    self.inst = inst
    self.is_channeling = false
    self.channel_task = nil
end)

function Channeling:StartChanneling()
    if not self.is_channeling then
        self.is_channeling = true
        self.inst:StartUpdatingComponent(self)
    end
end

function Channeling:StopChanneling()
    if self.is_channeling then
        self.is_channeling = false
        self.inst:StopUpdatingComponent(self)
    end
end
function Channeling:OnUpdate(dt)
    if self.is_channeling then
        -- Call the skill's on_channeling function
        local skill = self.inst.components.skillable:GetSkill("royale_steps")
        if skill then
            skill.on_channeling(self.inst, skill.level, dt)
        end

        -- Stop channeling if the player moves
        if self.inst.components.locomotor:IsMoving() then
            self:StopChanneling()
        end
    end
end

return Channeling