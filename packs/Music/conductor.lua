cosmos_get_most_played_hand_types = function()
    local highest_count = 0
    local highest_name = {}
    for k, v in pairs(G.GAME.hands) do
        if v.played > highest_count then
            highest_count = v.played
            highest_name = {k}
        elseif v.played == highest_count then
            highest_name[#highest_name+1] = k
        end
    end
    -- sendDebugMessage(table.concat(highest_name,", "))
    return highest_name
end

SMODS.Joker {
    key = "conductor",
    unlocked = true,
    discovered = true,
    blueprint_compat = true,
    eternal_compat = true,
    perishable_compat = true,
    rarity = 1,
    atlas = "MusicAtlas",
    pos = { x = 4, y = 2 },
    cost = 5,
    config = { extra = { hand_size_mod = 2, initialized = false } },
    in_pool = function(self, args)
        local check = G.cosmos.enabled.Music or false
        return check
    end,
    loc_vars = function(self, info_queue, card)
        return {
            vars = { card.ability.extra.hand_size_mod, card.ability.h_size }
        }
    end,
    calculate = function(self, card, context)
        if context.cardarea == G.jokers then
            if (not card.ability.extra.initialized) or context.joker_main then
                card.ability.extra.initialized = true
                local active = 0
                local highest_name = cosmos_get_most_played_hand_types()
                for k, v in ipairs(highest_name) do
                    if v == "Straight" or v == "Straight Flush" then
                        active = card.ability.extra.hand_size_mod
                    end
                end
                local diff = active-card.ability.h_size
                if diff ~= 0 then
                    G.hand:change_size(active-card.ability.h_size)
                    card.ability.h_size = active
                    if diff > 0 then
                        return {
                            message = localize("k_active_ex"),
                            colour = G.C.RED
                        }
                    else
                        return {
                            message = localize("k_inactive_ex"),
                            colour = G.C.RED
                        }
                    end
                end
            end
        end
    end
}