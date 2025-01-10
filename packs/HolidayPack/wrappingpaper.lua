SMODS.Joker {
    key = 'wrappingpaper',
    loc_txt = {
        name = 'Wrapping Paper',
        text = {
            "At the {C:attention}end of round{},",
            "add this Joker's {C:attention}sell value",
            "to the one to the right",
            --"{C:inactive}(Currently at {C:money}$#1#{C:inactive} value)"
        }
    },
    unlocked = true,
    discovered = true,
    blueprint_compat = false,
    rarity = 2,
    atlas = 'HolidayPackAtlas',
    pos = { x = 4, y = 0 },
    cost = 7,
    in_pool = function(self, args)
        local check = G.cosmos.enabled.HolidayPack or false
        print(inspectDepth(G.cosmos.enabled))
        print(check)
        return check
    end,
    loc_vars = function(self, info_queue, card)
        return { vars = { card.sell_cost } }
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
                modcard.ability.extra_value = (modcard.ability.extra_value or 0) + card.sell_cost
                modcard:set_cost()
                card_eval_status_text(modcard, 'extra', nil, nil, nil, {
                    message = localize('k_val_up'),
                    colour = G.C.MONEY
                })
            end
        end
    end
}
