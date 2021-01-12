-----------------------------------
-- Ability: Vivacious Pulse
-- Restores the caster's HP. 
-- Obtained: Rune Fencer Level 65
-- Recast Time: 1:00
-- Duration: Instant
-----------------------------------
require("scripts/globals/settings")
require("scripts/globals/status")
require("scripts/globals/msg")
-----------------------------------


function onAbilityCheck(player, target, ability)
    return 0, 0
end

--source https://www.bluegartr.com/threads/124844-Vivacious-Pulse-testing?p=6038534&viewfull=1#post6038534
function getRuneHealAmount(effect, target)
    local runeStatMap = { [tpz.effect.IGNIS]  = tpz.mod.STR,
                          [tpz.effect.GELUS]  = tpz.mod.DEX,
                          [tpz.effect.FLABRA] = tpz.mod.VIT,
                          [tpz.effect.TELLUS] = tpz.mod.AGI,
                          [tpz.effect.SULPOR] = tpz.mod.INT,
                          [tpz.effect.UNDA]   = tpz.mod.MND,
                          [tpz.effect.LUX]    = tpz.mod.CHR,
                        }

    local stat = runeStatMap[effect:getType()]
    if stat ~= nil then
	return math.floor(target:getStat(stat) * 0.5)
    end
    return 0
end

function calculateVivaciousPulseHealing(target)

    local divineMagicSkillLevel = target:getSkillLevel(tpz.skill.ENHANCING_MAGIC)
    local HPHealAmount = 10 + math.floor(divineMagicSkillLevel / 2)
    local MPHealAmount = 0
    local tenebraeRuneCount = 0
    local bonusPct = 1.0 --todo, add in bonus from augment attached to Futhark Claymore, Peord Claymore, and Morgelai.

    local debuffs = {}
    local i = 0

    local effects = target:getStatusEffects()
    for _, effect in ipairs(effects) do
        type = effect:getType()
        if type >= tpz.effect.IGNIS and type <= tpz.effect.LUX then -- runes that restore HP
            HPHealAmount = HPHealAmount + getRuneHealAmount(effect, target)
        elseif type == tpz.effect.TENEBRAE then -- runes that restore MP
            tenebraeRuneCount = tenebraeRuneCount + 1
	elseif type == tpz.effect.POISON or type == tpz.effect.PARALYSIS or type == tpz.effect.BLINDNESS
            or type == tpz.effect.SILENCE or type == tpz.effect.MUTE or type == tpz.effect.CURSE_I
            or type == tpz.effect.CURSE_II or type == tpz.effect.DOOM or type == tpz.effect.VIRUS
            or type == tpz.effect.PLAGUE or type == tpz.effect.PETRIFICATION then
             debuffs[i+1] = type
             i = i + 1
        end
    end

    if tenebraeRuneCount > 0 then --only restore MP if there's one or more tenebrae rune active
        local MPHealAmount = math.floor(divineMagicSkillLevel / 10) * (tenebraeRuneCount + 1)
	target:addMP(MPHealAmount) --does Morgelai etc apply a bonus here too?
    end

    if i > 0 and (target:getEquipID(tpz.slot.HEAD) == 26782 or target:getEquipID(tpz.slot.HEAD) == 26783) then --add random removal of Poison, Paralyze, Blind, Silence, Mute, Curse, Bane, Doom, Virus, Plague, Petrification via AF3 head
        target:delStatusEffect(debuffs[math.random(i)])
    end

    HPHealAmount = HPHealAmount * bonusPct
    if (target:getHP() + HPHealAmount > target:getMaxHP()) then
        HPHealAmount = target:getMaxHP() - target:getHP() --cap it
    end

    return HPHealAmount
end

function onUseAbility(player, target, ability, action)
	return calculateVivaciousPulseHealing(player, target)
end
