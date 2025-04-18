function cosmos_reset_piano_rank()
    G.GAME.current_round.cosmos_piano_card.rank = 'Ace'
    local valid_cosmos_piano_cards = {}
    for k, v in ipairs(G.playing_cards) do
        if v.ability.effect ~= 'Stone Card' then
            if not SMODS.has_no_rank(v) then
                valid_cosmos_piano_cards[#valid_cosmos_piano_cards + 1] = v
            end
        end
    end
    if valid_cosmos_piano_cards[1] then
        local cosmos_piano_card = pseudorandom_element(valid_cosmos_piano_cards,
            pseudoseed('piano' .. G.GAME.round_resets.ante))
        G.GAME.current_round.cosmos_piano_card.rank = cosmos_piano_card.base.value
        G.GAME.current_round.cosmos_piano_card.id = cosmos_piano_card.base.id
    end
end

SMODS.Joker {
    key = "pianoroll",
    unlocked = true,
    discovered = true,
    blueprint_compat = true,
    eternal_compat = true,
    perishable_compat = true,
    rarity = 2,
    atlas = "MusicAtlas",
    pos = {
        x = 1,
        y = 1
    },
    cost = 5,
    config = {
        extra = {
            x_mult = 1,
            x_mult_mod = 0.5
        }
    },

    in_pool = function(self, args)
        local check = G.cosmos.enabled.Music or false
        return check
    end,

    loc_vars = function(self, info_queue, card)
        return {
            vars = {card.ability.extra.x_mult_mod, localize(G.GAME.current_round.cosmos_piano_card.rank, 'ranks'),
                    card.ability.extra.x_mult}
        }
    end,

    calculate = function(self, card, context)
        if context.joker_main and card.ability.extra.x_mult > 1 then
            return {
                message = localize {
                    type = 'variable',
                    key = 'a_xmult',
                    vars = {card.ability.extra.x_mult}
                },
                Xmult_mod = card.ability.extra.x_mult,
                colour = G.C.MULT
            }
        elseif context.remove_playing_cards and not context.blueprint then
            local targets = 0
            for k, val in ipairs(context.removed) do
                if val:get_id() == G.GAME.current_round.cosmos_piano_card.id then
                    targets = targets + 1
                end
            end
            if targets > 0 then
                card.ability.extra.x_mult = card.ability.extra.x_mult + targets * card.ability.extra.x_mult_mod
                cosmos_reset_piano_rank()
                return {
                    message = localize {
                        type = 'variable',
                        key = 'a_xmult',
                        vars = {card.ability.extra.x_mult}
                    }
                }
            end
        end
    end
}
