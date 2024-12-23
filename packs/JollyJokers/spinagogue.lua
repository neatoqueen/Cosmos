--[[ Need to figure out events better, it currently has an
issue where it immediately removes and adds new editions
on all cards at the same time, instead of going one by
one. Perfectly functional, just looks weird at the moment.]]

SMODS.Joker {
    key = "spinagogue",
    loc_txt = {
        name = "Spinagogue Champion",
        text = {
            "{C:green}#1# in #2#{} chance to remove",
            "editions from {C:attention}scored cards",
            "{C:green}#3# in #4#{} chance to add {C:dark_edition}Foil,",
            "{C:dark_edition}Holographic{}, or {C:dark_edition}Polychrome",
            "editions to {C:attention}scored cards" },
    },
    unlocked = true,
    discovered = true,
    blueprint_compat = true,
    eternal_compat = false,
    perishable_compat = true,
    config = { extra = { remove_odds = 4, add_odds = 4 } },
    rarity = 1,
    atlas = "JollyJokers",
    pos = { x = 6, y = 0 },
    cost = 6,
    loc_vars = function(self, info_queue, card)
        return {
            vars = {G.GAME.probabilities.normal, card.ability.extra.remove_odds, G.GAME.probabilities.normal, card.ability.extra.add_odds}
        }
    end,
    calculate = function(self, card, context)
        if context.before and context.full_hand then
            for i, v in ipairs(context.scoring_hand) do
                if pseudorandom('spinagogueR') < G.GAME.probabilities.normal / card.ability.extra.remove_odds then
                    if v.edition then
                        v:set_edition(nil)
                        card_eval_status_text(v, 'extra', nil, nil, nil, {
                            message = 'SHIN!',
                            colour = G.C.GREEN
                        })
                    else
                        card_eval_status_text(v, 'extra', nil, nil, nil, {
                            message = 'NUN!',
                            colour = G.C.GREEN
                        })
                    end
                end
                if not v.edition then
                    if pseudorandom('spinagogueA') < G.GAME.probabilities.normal / card.ability.extra.add_odds then
                        v:set_edition(poll_edition('spinagogueE', nil, true, true,
                            { "e_foil", "e_holo", "e_polychrome" }))
                        if v.edition.key == 'e_polychrome' then
                            card_eval_status_text(v, 'extra', nil, nil, nil, {
                                message = 'GIMEL!',
                                colour = G.C.GREEN
                            })
                        else
                            card_eval_status_text(v, 'extra', nil, nil, nil, {
                                message = "HEY!",
                                colour = G.C.GREEN
                            })
                        end
                    end
                end
            end
        end
    end
}
