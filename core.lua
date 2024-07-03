local title = "RecipeLinkFix"

local coreFrame = CreateFrame("Frame");
local core = LibStub("AceAddon-3.0"):NewAddon(coreFrame, title, "AceHook-3.0")

local gsub = gsub
local string_find = string.find
local GetSpellLink = GetSpellLink or C_Spell.GetSpellLink;

-- Ace3 Functions
function core:OnInitialize()
    self:RawHook("SendChatMessage", true)
end

------------------------------------------------------------------
function core:SendChatMessage(...)
    -- Our hook to SendChatMessage. If msg contains enchant link, we fix it.

    local msg, chatType, language, channel = ...;
    if msg:find("|Henchant:") then --enchant link found
        local tempMsg = msg
        local found, _, enchantString = string_find(tempMsg, "Henchant:(%d+)")
        local link = nil
        while(found ~= nil) do --repeat untill all links are fixed
            link,_ = GetSpellLink(enchantString)
            if link == nil then
                break
            end
            tempMsg,_ = gsub(tempMsg, "(|%x-|Henchant:".. enchantString ..".-|r)", link)
            found, _, enchantString = string_find(tempMsg, "Henchant:(%d+)")
        end

        core.hooks.SendChatMessage(tempMsg, chatType, language, channel);
        return;
    end
    core.hooks.SendChatMessage(...)
end