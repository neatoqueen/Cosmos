SMODS.Joker {
    key = "seashanty",
    unlocked = true,
    discovered = true,
    blueprint_compat = true,
    eternal_compat = true,
    perishable_compat = true,
    rarity = 1,
    atlas = "MusicAtlas",
    pos = { x = 4, y = 1 },
    cost = 5,
    config = { extra = { gain = 2, lose = 2, gain_on_play = true} },
    in_pool = function(self, args)
        local check = G.cosmos.enabled.Music or false
        return check
    end,
    loc_vars = function(self, info_queue, card)
        local key = "j_cosmos_seashanty_discard"
        if card.ability.extra.gain_on_play then
            key = "j_cosmos_seashanty_play"
        end
        return {
            key = key,
            vars = { card.ability.extra.gain, card.ability.extra.lose }
        }

    end,
    calculate = function(self, card, context)
        if context.discard and not context.blueprint and context.other_card and context.other_card == context.full_hand[#context.full_hand] then
            local ret = {}
            if card.ability.extra.gain_on_play then
                card.ability.extra_value = math.max(0, (card.ability.extra_value or 0) - card.ability.extra.lose)
                ret = {
                    message = "-$"..card.ability.extra.lose,
                    colour = G.C.RED,
                    card = card
                }
            else
                card.ability.extra_value = (card.ability.extra_value or 0) + card.ability.extra.gain
                ret = {
                    message = "+$"..card.ability.extra.gain,
                    colour = G.C.GOLD,
                    card = card
                }
            end
            card:set_cost()
            card.ability.extra.gain_on_play = not card.ability.extra.gain_on_play
            return ret
        end
        if context.after and not context.blueprint then
            local ret = {}
            if card.ability.extra.gain_on_play then
                card.ability.extra_value = (card.ability.extra_value or 0) + card.ability.extra.gain
                ret = {
                    message = "+$"..card.ability.extra.gain,
                    colour = G.C.GOLD,
                    card = card
                }
            else
                card.ability.extra_value = math.max(0, (card.ability.extra_value or 0) - card.ability.extra.lose)
                ret = {
                    message = "-$"..card.ability.extra.lose,
                    colour = G.C.RED,
                    card = card
                }
            end
            card:set_cost()
            card.ability.extra.gain_on_play = not card.ability.extra.gain_on_play
            return ret
        end
    end
}