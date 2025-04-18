local generate_main_end = function(card)
    if not (G.your_collection and (card.area and card.area.config.collection)) then
        local active = card.ability.extra.active
        return {{
            n = G.UIT.C,
            config = {
                align = "bm",
                padding = 0.02
            },
            nodes = {{
                n = G.UIT.C,
                config = {
                    align = "m",
                    colour = active and G.C.GREEN or G.C.RED,
                    r = 0.05,
                    padding = 0.05
                },
                nodes = {{
                    n = G.UIT.T,
                    config = {
                        text = ' ' .. (active and localize('k_active') or localize('k_cosmos_inactive')) .. ' ',
                        colour = G.C.UI.TEXT_LIGHT,
                        scale = 0.3,
                        shadow = true
                    }
                }}
            }}
        }}
    end
end

SMODS.Joker {
    key = "rimshot",
    unlocked = true,
    discovered = true,
    blueprint_compat = true,
    eternal_compat = true,
    perishable_compat = true,
    rarity = 1,
    atlas = "MusicAtlas",
    pos = {
        x = 0,
        y = 2
    },
    cost = 5,
    config = {
        extra = {
            active = false
        }
    },
    in_pool = function(self, args)
        local check = G.cosmos.enabled.Music or false
        return check
    end,
    loc_vars = function(self, info_queue, card)
        return {
            main_end = generate_main_end(card)
        }
    end,
    calculate = function(self, card, context)
        if context.before and context.scoring_name == "Pair" and G.GAME.current_round.hands_played == 0 and
            not context.blueprint then
            card.ability.extra.active = true
            return {
                message = localize('k_active_ex')
            }
        elseif context.end_of_round and context.cardarea == G.jokers and card.ability.extra.active then
            card.ability.extra.active = false
            local candidates = {}
            for i = 1, #G.hand.cards do
                if G.hand.cards[i]:can_calculate(true) then
                    candidates[#candidates + 1] = G.hand.cards[i]
                end
            end
            if #candidates > 0 then
                local target_card = pseudorandom_element(candidates, pseudoseed('cosmos_rimshot'))
                target_card.ability.cosmos_destroy_this = true
                return {
                    message = "Tss!"
                }
            end
        end
    end
}
