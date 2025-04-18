SMODS.Joker {
    key = "snowman",
    loc_txt = {
        name = "Snowman",
        text = {
            "This string should get replaced by loc_vars"
        },
    },
    unlocked = true,
    discovered = true,
    blueprint_compat = true,
    eternal_compat = false,
    perishable_compat = true,
    config = { extra = {
        chips = 0,
        chip_gain = 5,
        chip_lose = 10,
        melt_state = false,
        chip_threshold = 150,
        destroyed = false
    } },
    rarity = 1,
    atlas = "JJPack",
    pos = { x = 9, y = 0 },
    cost = 5,
    loc_vars = function(self, info_queue, card)
        local key = "cosmos_j_snowman_gain"
        if card.ability.extra.melt_state then
            key = 'cosmos_j_snowman_melt'
        end
        return {
            key = key,
            vars = { card.ability.extra.chips, card.ability.extra.chip_gain, card.ability.extra.chip_lose, card.ability.extra.chip_threshold }
        }
    end,
    calculate = function(self, card, context)
        if context.joker_main then
            if card.ability.extra.chips > 0 then
                return {
                    message = localize { type = 'variable', key = 'a_chips', vars = { card.ability.extra.chips } },
                    chip_mod = card.ability.extra.chips,
                    colour = G.C.CHIPS
                }
            end
        end

        if context.individual and context.cardarea == G.play and not context.blueprint and context.other_card and not card.ability.extra.destroyed then
            local snowman = function()
            if card.ability.extra.melt_state then
                card.ability.extra.chips = card.ability.extra.chips - card.ability.extra.chip_lose
                card_eval_status_text(card, 'extra', nil, nil, nil,
                    {
                        message = localize { type = 'variable', key = 'a_chips_minus', vars = { card.ability.extra.chip_lose } },
                        colour = G.C.CHIPS,
                    }
                )
            elseif card.ability.extra.chips < card.ability.extra.chip_threshold then
                card.ability.extra.chips = card.ability.extra.chips + card.ability.extra.chip_gain
                card_eval_status_text(card, 'extra', nil, nil, nil,
                    {
                        message = localize { type = 'variable', key = 'a_chips', vars = { card.ability.extra.chip_gain } },
                        colour = G.C.CHIPS,
                    }
                )
            end
            if card.ability.extra.chips >= card.ability.extra.chip_threshold and not card.ability.extra.melt_state then
                card.ability.extra.melt_state = true
                card_eval_status_text(card, 'extra', nil, nil, nil,
                    {
                        message = 'Melting...',
                        colour = G.C.PURPLE
                    }
                )
                card:juice_up()
            end
            if card.ability.extra.chips <= 0 and card.ability.extra.melt_state then
                card.ability.extra.destroyed = true
                card_eval_status_text(card, 'extra', nil, nil, nil,
                    {
                        message = 'Melted away...',
                        colour = G.C.PURPLE
                    }
                )
                G.E_MANAGER:add_event(Event({
                    func = function()
                        play_sound('tarot1')
                        card.T.r = -0.2
                        card:juice_up(0.3, 0.4)
                        card.states.drag.is = true
                        card.children.center.pinch.x = true
                        G.E_MANAGER:add_event(Event({
                            trigger = 'after',
                            delay = 0.3,
                            blockable = false,
                            func = function()
                                G.jokers:remove_card(card)
                                card:remove()
                                card = nil
                                return true;
                            end
                        }))
                        return true
                    end
                }))
            end
        end
        -- , focus = card, volume = 0, delay = 0, colour = G.C.CLEAR, sound = nil, no_juice = true, amt = 0,
        return {extra = {func = snowman, no_status = true}}
    end
    end
}
