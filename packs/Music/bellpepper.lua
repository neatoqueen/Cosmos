function cosmos_reset_pepper_card()
    local cosmos_pepper_suits = {}
    for k, v in ipairs({'Spades','Hearts','Clubs','Diamonds'}) do
        if v ~= G.GAME.current_round.cosmos_pepper_card.suit then cosmos_pepper_suits[#cosmos_pepper_suits + 1] = v end
    end
    local cosmos_pepper_card = pseudorandom_element(cosmos_pepper_suits, pseudoseed('pep'..G.GAME.round_resets.ante))
    G.GAME.current_round.cosmos_pepper_card.suit = cosmos_pepper_card
end

SMODS.Joker {
    key = "bellpepper",
    unlocked = true,
    discovered = true,
    blueprint_compat = true,
    eternal_compat = true,
    perishable_compat = true,
    rarity = 1,
    atlas = "MusicAtlas",
    pos = { x = 0, y = 0 },
    cost = 5,
    config = { extra = { chips = 1, chip_mod = 1 } },
    in_pool = function(self, args)
        local check = G.cosmos.enabled.Music or false
        return check
    end,
    loc_vars = function(self, info_queue, card)
        return {
            vars = { localize(G.GAME.current_round.cosmos_pepper_card.suit or 'Spades', 'suits_singular'),
                math.max(card.ability.extra.chips,0),
                card.ability.extra.chip_mod,
                colours = {G.C.SUITS[G.GAME.current_round.cosmos_pepper_card.suit or 'Spades']} }
        }
    end,
    calculate = function(self, card, context)
        if context.individual and context.cardarea == G.play and not context.blueprint and context.other_card and
        context.other_card:is_suit(G.GAME.current_round.cosmos_pepper_card.suit) then
            card.ability.extra.chips = card.ability.extra.chips - card.ability.extra.chip_mod
            if card.ability.extra.chips < 0 then
                return
            end
            return {
                chips = card.ability.extra.chips + 1,
                card = card
            }
        elseif context.after then
            if card.ability.extra.chips <= 0 then
                G.E_MANAGER:add_event(Event({
                    func = function()
                        play_sound('tarot1')
                        card.T.r = -0.2
                        card:juice_up(0.3, 0.4)
                        card.states.drag.is = true
                        card.children.center.pinch.x = true
                        G.E_MANAGER:add_event(Event({trigger = 'after', delay = 0.3, blockable = false,
                            func = function()
                                    G.jokers:remove_card(card)
                                    card:remove()
                                    card = nil
                                return true; end}))
                        return true
                    end
                }))
                return {
                    message = localize('k_eaten_ex'),
                    colour = G.C.RED
                }
            end
        end
    end
}