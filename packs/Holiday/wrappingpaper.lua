SMODS.Joker {
    key = 'wrappingpaper',
    unlocked = true,
    discovered = true,
    blueprint_compat = false,
    rarity = 2,
    atlas = 'HolidayAtlas',
    pos = { x = 4, y = 0 },
    config = {extra = {max = 20}},
    cost = 7,
    in_pool = function(self, args)
        local check = G.cosmos.enabled.Holiday or false
        return check
    end,
    loc_vars = function(self, info_queue, card)
        return { vars = { card.ability.extra.max } }
    end,
    calculate = function(self, card, context)
        if context.end_of_round and not context.individual and not context.repetition and not context.blueprint then
            local my_pos = nil
            for i = 1, #G.jokers.cards do
                if G.jokers.cards[i] == card then
                    my_pos = i; break
                end
            end
            if G.jokers.cards[my_pos + 1] then
                local modcard = G.jokers.cards[my_pos + 1]
                local cost = card.sell_cost
                if card.sell_cost >= card.ability.extra.max then cost = card.ability.extra.max end
                modcard.ability.extra_value = (modcard.ability.extra_value or 0) + cost
                modcard:set_cost()
                card_eval_status_text(modcard, 'extra', nil, nil, nil, {
                    message = localize('k_val_up'),
                    colour = G.C.MONEY
                })
            end
        end
    end
}
