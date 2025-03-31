SMODS.Joker {
    key = 'pantomime',
    unlocked = true,
    discovered = true,
    blueprint_compat = true,
    config = { extra = { retrigger = 1, prev_ranks = {} } },
    rarity = 3,
    atlas = 'HolidayAtlas',
    pos = { x = 3, y = 0 },
    cost = 8,
    in_pool = function(self, args)
        local check = G.cosmos.enabled.Holiday or false
        return check
    end,
    calculate = function(self, card, context)
        if context.other_card and context.repetition then
            local playranks = {}
            local handranks = {}
            local cardrank = context.other_card:get_id()

            for i, v in ipairs(G.hand.cards) do
                table.insert(handranks, G.hand.cards[i]:get_id())
            end
            for i, v in ipairs(G.play.cards) do
                table.insert(playranks, G.play.cards[i]:get_id())
            end
            if context.cardarea == G.play then
            card.ability.extra.prev_ranks = playranks
            end
            local match = false
            for i, v in ipairs(handranks) do
                if cardrank == handranks[i] and context.cardarea == G.play then
                    match = true
                end
            end
            for i, v in ipairs(playranks) do
                if cardrank == playranks[i] and context.cardarea == G.hand and (next(context.card_effects[1]) or #context.card_effects > 1) then
                    match = true
                end
            end
            if match then
                if context.other_card.debuff then
                    return {
                        message = localize('k_debuffed'),
                        colour = G.C.RED,
                        card = card,
                    }
                else
                    return {
                        message = localize('k_again_ex'),
                        repetitions = card.ability.extra.retrigger,
                        card = card
                    }
                end
            end
        end
        if context.end_of_round and context.repetition and context.cardarea == G.hand then
            local id = context.other_card:get_id()
            local match = false
            for i, v in ipairs(card.ability.extra.prev_ranks) do
                if id == v then
                    match = true
                end
            end
            if match and (next(context.card_effects[1]) or #context.card_effects > 1) then
                return {
                    message = localize('k_again_ex'),
                    repetitions = card.ability.extra.retrigger,
                    card = card
                }
            end
        end
    end
}
