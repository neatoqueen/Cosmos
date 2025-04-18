SMODS.Joker {
    key = "marchingband",
    unlocked = true,
    discovered = true,
    blueprint_compat = true,
    eternal_compat = true,
    perishable_compat = true,
    rarity = 1,
    atlas = "MusicAtlas",
    pos = { x = 2, y = 2 },
    cost = 5,
    config = { extra = { x_mult_mod = 0.05, numbered_cards = 40 } },
    in_pool = function(self, args)
        local check = G.cosmos.enabled.Music or false
        return check
    end,
    loc_vars = function(self, info_queue, card)
        return {
            vars = { card.ability.extra.x_mult_mod, 1 + card.ability.extra.x_mult_mod*(card.ability.extra.numbered_cards or 40) }
        }
    end,
    calculate = function(self, card, context)
        if context.joker_main then
            local v = 1 + card.ability.extra.x_mult_mod*card.ability.extra.numbered_cards
            if v > 1 then
                return {
                    message = localize {
                        type = 'variable',
                        key = 'a_xmult',
                        vars = {v}
                    },
                    Xmult_mod = v,
                    colour = G.C.MULT
                }
            end
        end
    end,
    update = function(self, card, context)
        if G.deck then
            local c = 0
            for k, v in ipairs(G.deck.cards) do
                if not v:is_face() then
                    c = c + 1
                end
            end
            card.ability.extra.numbered_cards = c
        end
    end
}