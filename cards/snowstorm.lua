SMODS.Joker {
    key = "snowstorm",
    loc_txt = {
        name = "Snowstorm",
        text = {
            "Each {C:attention}Enhanced{} card",
            "{C:attention}held in hand",
            "gives {C:chips}+#1#{} Chips"
        },
    },
    unlocked = true,
    discovered = true,
    blueprint_compat = true,
    eternal_compat = true,
    perishable_compat = true,
    config = { extra = { chips = 25 } },
    rarity = 2,
    atlas = "JJPack",
    pos = { x = 5, y = 0 },
    cost = 5,
    loc_vars = function(self, info_queue, card)
        return {
            vars = { card.ability.extra.chips }
        }
    end,
    calculate = function(self, card, context)
        if context.cardarea == G.hand and context.individual == true and not context.end_of_round then
            if context.other_card.ability.set == 'Enhanced' then
                if context.other_card.debuff then
                    return {
                        message = localize('k_debuffed'),
                        colour = G.C.RED,
                        card = card,
                    }
                else
                    return {
                            chips = card.ability.extra.chips,
                            card = card
                        }
                end
            end
        end
    end
}
