SMODS.Joker {
    key = "sgtjoker",
    unlocked = true,
    discovered = true,
    blueprint_compat = true,
    eternal_compat = true,
    perishable_compat = true,
    rarity = 1,
    atlas = "MusicAtlas",
    pos = { x = 2, y = 1 },
    cost = 5,
    config = { extra = { mult = 0, mult_mod = 2, hearts = 1 } },
    in_pool = function(self, args)
        local check = G.cosmos.enabled.Music or false
        return check
    end,
    loc_vars = function(self, info_queue, card)
        return {
            vars = { card.ability.extra.mult_mod, card.ability.extra.hearts+1, card.ability.extra.mult }
        }
    end,
    calculate = function(self, card, context)
        if context.joker_main then
            return {
                message = localize{type='variable', key='a_mult', vars={card.ability.extra.mult}},
                mult_mod = card.ability.extra.mult
            }
        end
        if context.before and context.scoring_hand then
            local targets = 0
            for i, v in ipairs(context.scoring_hand) do
                if v:is_suit('Hearts') then
                    targets = targets + 1
                end
            end
            if targets == 1 then
                card.ability.extra.mult = card.ability.extra.mult + card.ability.extra.mult_mod
                return {
                    message = localize {
                        type = 'variable',
                        key = 'a_mult',
                        vars = {card.ability.extra.mult_mod}
                    }
                }
            elseif targets > 1 then
                card.ability.extra.mult = 0
                return {
                    message = localize('k_staylonely_ex'),
                    colour = G.C.RED
                }
            end
        end
    end
}