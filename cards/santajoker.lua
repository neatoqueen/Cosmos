SMODS.Joker {
    key = "santajoker",
    loc_txt = {
        name = "Santa",
        text = {
            "{C:green}#1# in #2#{} chance to",
            "create a {C:red}Coupon Tag",
            "at {C:attention}end of round"
        },
    },
    unlocked = true,
    discovered = true,
    blueprint_compat = true,
    eternal_compat = true,
    perishable_compat = true,
    config = { extra = { odds = 3 } },
    rarity = 2,
    atlas = "JJPack",
    pos = { x = 0, y = 0 },
    cost = 6,
    loc_vars = function(self, info_queue, card)
        local numerator, denominator = SMODS.get_probability_vars(card, 1, card.ability.extra.odds, 'santa')
        info_queue[#info_queue + 1] = G.P_TAGS.tag_coupon
        return {
            vars = {numerator, denominator}
        }
    end,
    calculate = function(self, card, context)
        if context.end_of_round and not context.individual and not context.repetition then
            local success = SMODS.pseudorandom_probability(card, 'santa', 1, card.ability.extra.odds, 'santa')
            if not success then
                return
            end

            G.E_MANAGER:add_event(Event({
                func = (function()
                    add_tag(Tag('tag_coupon'))
                    play_sound('generic1', 0.9 + math.random() * 0.1, 0.8)
                    play_sound('holo1', 1.2 + math.random() * 0.1, 0.4)
                    return true
                end)
            }))
            return {
                message = "Ho ho ho!",
                colour = G.C.MULT
            }
        end
    end
}
