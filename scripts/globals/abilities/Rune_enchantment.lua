-----------------------------------
-- Ability: Rune Enchantment
-- Allows you to harbor runes
-- Obtained: Rune Fencer Level 5
-- Recast Time: 0:10
-- Duration: 5:00
-----------------------------------
require("scripts/globals/settings")
require("scripts/globals/status")
require("scripts/globals/msg")
-----------------------------------


function getRUNLevel(player)
    return player:getMainJob() == tpz.job.RUN and player:getMainLvl() or player:getSubLvl()
end

function applyRuneEnhancement(effectType, player)
    local RUNLevel = getRUNLevel(player)
    local meritBonus = player:getMerit(tpz.merit.MERIT_RUNE_ENHANCE)
    printf("RUN level = " .. tostring(RUNLevel))
    printf("Effect Type = " .. tostring(effectType))
    local power = math.floor((49 * RUNLevel / 99) + 5.5) + meritBonus
    printf("power = " .. tostring(power))
    player:addStatusEffect(effectType, power, 0, 300, 0, 0)
end

function enforceRuneCounts(target)
    local RUNLevel = getRUNLevel(target)
    local maxRunes = RUNLevel >= 65 and 3 or RUNLevel >= 35 and 2 or 1
    local effects = target:getStatusEffects()
    local runes = { }
    local i = 0

    for _, effect in ipairs(effects) do
        printf("type = " .. tostring(effect:getType()))
        type = effect:getType()
        if type >= tpz.effect.IGNIS and type <= tpz.effect.TENEBRAE then
            runes[i+1] = effect
            i = i + 1
        end
    end

    if i >= maxRunes then --delete the first rune in the list with the least duration
        target:delStatusEffect(runes[1]:getType())
    end
end
