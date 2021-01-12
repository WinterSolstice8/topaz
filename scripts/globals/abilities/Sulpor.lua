-----------------------------------
-- Ability: Sulpor
-- Increases resistance against earth and deals thunder damage.
-- Obtained: Rune Fencer Level 5
-- Recast Time: 0:10
-- Duration: 5:00
-----------------------------------
require("scripts/globals/settings")
require("scripts/globals/status")
require("scripts/globals/msg")
require("scripts/globals/abilities/Rune_enchantment")
-----------------------------------

function onAbilityCheck(player, target, ability)
	return 0, 0
end

function onUseAbility(caster, target, ability, action)
    local effect = tpz.effect.SULPOR
    enforceRuneCounts(target)
    applyRuneEnhancement(effect, target)
    return effect
end
