function cosmos_reset_jpop_rank()
    G.GAME.current_round.cosmos_jpop_card.rank = 'Ace'
    local valid_cosmos_jpop_cards = {}
    for k, v in ipairs(G.playing_cards) do
        if v.ability.effect ~= 'Stone Card' then
            if not SMODS.has_no_rank(v) then
                valid_cosmos_jpop_cards[#valid_cosmos_jpop_cards+1] = v
            end
        end
    end
    if valid_cosmos_jpop_cards[1] then
        local cosmos_jpop_card = pseudorandom_element(valid_cosmos_jpop_cards, pseudoseed('mail'..G.GAME.round_resets.ante))
        G.GAME.current_round.cosmos_jpop_card.rank = cosmos_jpop_card.base.value
        G.GAME.current_round.cosmos_jpop_card.id = cosmos_jpop_card.base.id
    end
end

SMODS.Joker {
    key = "jpop",
    unlocked = true,
    discovered = true,
    blueprint_compat = true,
    eternal_compat = true,
    perishable_compat = true,
    rarity = 1,
    atlas = "MusicAtlas",
    pos = { x = 0, y = 1 },
    cost = 5,
    config = { extra = { retrigger = 1 }},
    in_pool = function(self, args)
        local check = G.cosmos.enabled.Music or false
        return check
    end,
    loc_vars = function(self, info_queue, card)
        return {
            vars = { localize(G.GAME.current_round.cosmos_jpop_card and G.GAME.current_round.cosmos_jpop_card.rank or 'Ace', 'ranks') }
        }
    end,
    calculate = function(self, card, context)
        if context.other_card and context.repetition then
            if context.other_card:get_id() == G.GAME.current_round.cosmos_jpop_card.id then
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
    end
}