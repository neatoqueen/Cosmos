SMODS.Joker {
    key = "krampusjoker",
    loc_txt = {
        name = "Krampus",
        text = {
            "When {C:attention}purchasing{} from the Shop,",
            "this Joker gains {X:mult,C:white}X#2#{} Mult",
            "{s:0.33} ",
            "{C:red,E:2}Items cost {C:money}$#1#{C:red,E:2} more",
            "{C:inactive}(Currently {X:mult,C:white}X#3#{C:inactive} Mult)"
        },
    },
    unlocked = true,
    discovered = true,
    blueprint_compat = true,
    eternal_compat = true,
    perishable_compat = false,
    config = { extra = { x_mult = 1, mult_gain = 0.1, inflation = 2 } },
    rarity = 3,
    atlas = "JJPack",
    pos = { x = 1, y = 0 },
    cost = 8,
    loc_vars = function(self, info_queue, card)
        return {
            vars = { card.ability.extra.inflation, card.ability.extra.mult_gain, card.ability.extra.x_mult }
        }
    end,
    add_to_deck = function(self, card, from_debuff)
        G.GAME.inflation = G.GAME.inflation + card.ability.extra.inflation
        for k, v in pairs(G.I.CARD) do
            if v.set_cost and v ~= card then
                v:set_cost()
            end
        end
    end,
    remove_from_deck = function(self, card, from_debuff)
        G.GAME.inflation = G.GAME.inflation - card.ability.extra.inflation
        for k, v in pairs(G.I.CARD) do
            if v.set_cost then
                v:set_cost()
            end
        end
    end,
    calculate = function(self, card, context)
        if (context.buying_card or (context.open_booster and not context.card.from_tag)) and not context.blueprint and context.card ~= card then
            card.ability.extra.x_mult = card.ability.extra.x_mult + card.ability.extra.mult_gain
            card_eval_status_text(card, 'extra', nil, nil, nil,
                {
                    message = localize('k_upgrade_ex'),
                    colour = G.C.MULT
                }
            )
        end

        if context.joker_main and card.ability.extra.x_mult ~= 1 then
            return {
                xmult = card.ability.extra.x_mult
            }
        end
    end
}
