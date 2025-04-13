cosmos_scalejoker_ranks_debug = {
    'Ace', '2', '3', '4', '5', '6', '7', '8', '9', '10', 'Jack', 'Queen', 'King', 'Ace'
}

SMODS.Joker {
    key = "musicscale",
    unlocked = true,
    discovered = true,
    blueprint_compat = true,
    eternal_compat = true,
    perishable_compat = true,
    rarity = 1,
    atlas = "MusicAtlas",
    pos = { x = 1, y = 2 },
    cost = 5,
    config = { extra = { target = 2, mult = 0, mult_mod = 1} },
    in_pool = function(self, args)
        local check = G.cosmos.enabled.Music or false
        return check
    end,
    loc_vars = function(self, info_queue, card)
        local target_next = card.ability.extra.target == 14 and 2 or math.min(card.ability.extra.target+1, 14)
        return {
            vars = {
                card.ability.extra.mult_mod,
                localize(cosmos_scalejoker_ranks_debug[card.ability.extra.target], 'ranks'),
                localize(cosmos_scalejoker_ranks_debug[target_next], 'ranks'),
                card.ability.extra.mult
            }
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
            for i, v in ipairs(context.scoring_hand) do
                if v:get_id() == card.ability.extra.target then
                    card.ability.extra.mult = card.ability.extra.mult + card.ability.extra.mult_mod
                    card.ability.extra.target = card.ability.extra.target == 14 and 2 or math.min(card.ability.extra.target+1, 14)
                    return {
                        message = localize { type = 'variable', key = 'a_mult', vars={card.ability.extra.mult_mod} },
                        colour = G.C.RED
                    }
                end
            end
        end
    end
}