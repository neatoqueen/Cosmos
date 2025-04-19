SMODS.Joker {
    key = "hahapedal",
    unlocked = true,
    discovered = true,
    blueprint_compat = true,
    eternal_compat = true,
    perishable_compat = true,
    rarity = 2,
    atlas = "MusicAtlas",
    pos = { x = 3, y = 0 },
    cost = 5,
    config = { extra = {} },
    in_pool = function(self, args)
        local check = G.cosmos.enabled.Music or false
        return check
    end,
    loc_vars = function(self, info_queue, card)
        info_queue[#info_queue+1] = G.P_CENTERS.e_foil
        info_queue[#info_queue+1] = G.P_CENTERS.e_holo
        info_queue[#info_queue+1] = G.P_CENTERS.e_polychrome
        return {
            vars = {}
        }
    end,
    calculate = function(self, card, context)
        if context.selling_card and context.card ~= card and context.card.ability.set == 'Joker' then
            local valid_cards = {}
            for i, v in ipairs(G.playing_cards) do
                if not v.edition then
                    valid_cards[#valid_cards+1] = v
                end
            end
            if #valid_cards == 0 then
                return
            end
            local target = pseudorandom_element(valid_cards, pseudoseed('haha'..G.GAME.round_resets.ante))

            local card_ = context.blueprint and context.blueprint_card or card
            local colour = nil
            if card_ ~= card then
                if card_.config.center.key == "j_blueprint" then
                    colour = G.C.BLUE
                elseif card_.config.center.key == "j_brainstorm" then
                    colour = G.C.RED
                end
            end
            local edition = poll_edition('jj_haha_edition', nil, true, true, { "e_foil", "e_holo", "e_polychrome" })
            -- G.E_MANAGER:add_event(Event({
            --     trigger = 'immediate',
            --     delay = 0.0,
            --     blockable = true,
            --     blocking = true,
            --     func = function()
            target.cosmos_hide_edition = true
            target:set_edition(edition, true, true)
            --        return true
            --     end
            --   }))
            G.E_MANAGER:add_event(Event({
                trigger = 'immediate',
                delay = 0.0,
                blockable = true,
                blocking = true,
                func = function()
                    target.cosmos_hide_edition = nil
                    return true
                end
            }))
            G.E_MANAGER:add_event(Event({
                trigger = 'after',
                delay = 0.0,
                blockable = true,
                func = function()
                    card_:juice_up(1, 0.5)
                    target:juice_up(1, 0.5)
                    if target.edition.foil then play_sound('foil1', 1.2, 0.4) end
                    if target.edition.holo then play_sound('holo1', 1.2*1.58, 0.4) end
                    if target.edition.polychrome then play_sound('polychrome1', 1.2, 0.7) end
                    return true
                end
                }))
            if edition == 'e_polychrome' then
                card_eval_status_text(target, 'extra', nil, nil, nil, {
                    message = localize("k_upgrade_ex"),
                    colour = colour or G.C.GREEN
                })
            elseif edition == 'e_holo' then
                card_eval_status_text(target, 'extra', nil, nil, nil, {
                    message = localize("k_upgrade_ex"),
                    colour = colour or G.C.RED
                })
            else
                card_eval_status_text(target, 'extra', nil, nil, nil, {
                    message = localize("k_upgrade_ex"),
                    colour = colour or G.C.BLUE
                })
            end
        end
    end
}