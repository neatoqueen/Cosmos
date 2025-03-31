SMODS.Joker {
    key = "snowstorm",
    unlocked = true,
    discovered = true,
    blueprint_compat = true,
    eternal_compat = true,
    perishable_compat = true,
    config = { extra = { chips = 25 } },
    rarity = 2,
    atlas = "HolidayAtlas",
    pos = { x = 0, y = 1 },
    cost = 5,
    in_pool = function(self, args)
        local check = G.cosmos.enabled.Holiday or false
        return check
    end,
    loc_vars = function(self, info_queue, card)
        return {
            vars = { card.ability.extra.chips }
        }
    end,
    calculate = function(self, card, context)
        if context.cardarea == G.hand and context.individual == true and not context.end_of_round then
            if context.other_card.label ~= 'Base Card' then
                if context.other_card.debuff then
                    return {
                        message = localize('k_debuffed'),
                        colour = G.C.RED,
                        card = context.other_card,
                    }
                else
                    return {
                            h_chips = card.ability.extra.chips,
                            card = context.other_card
                        }
                end
            end
        end
    end
}
