SMODS.Joker {
    key = "magi",
    loc_txt = {
        name = "Magi",
        text = {
            "Creates a {C:tarot}Charm Tag{} if",
            "winning poker hand",
            "is {C:attention}Three of a Kind"
        },
    },
    unlocked = true,
    discovered = true,
    blueprint_compat = true,
    eternal_compat = true,
    perishable_compat = true,
    rarity = 2,
    atlas = "JJPack",
    pos = { x = 8, y = 0 },
    cost = 7,
    loc_vars = function(self, info_queue, card)
        info_queue[#info_queue + 1] = G.P_TAGS.tag_charm
    end,
    calculate = function(self, card, context)
        if context.end_of_round and not context.individual and not context.repetition and G.GAME.last_hand_played == 'Three of a Kind' then
            G.E_MANAGER:add_event(Event({
                func = (function()
                    add_tag(Tag('tag_charm'))
                    play_sound('generic1', 0.9 + math.random() * 0.1, 0.8)
                    play_sound('holo1', 1.2 + math.random() * 0.1, 0.4)
                    return true
                end)
            }))
            return {
                message = localize('k_active_ex'),
                colour = G.C.PURPLE
            }
        end
    end
}
