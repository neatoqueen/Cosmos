SMODS.Joker {
    key = "hrockhmetal",
    unlocked = true,
    discovered = true,
    blueprint_compat = true,
    eternal_compat = true,
    perishable_compat = true,
    rarity = 1,
    atlas = "MusicAtlas",
    pos = {
        x = 4,
        y = 0
    },
    cost = 4,
    config = {
        extra = {
            chips = 25,
            x_mult = 1.25,
        }
    },

    in_pool = function(self, args)
        local check = G.cosmos.enabled.Music or false
        local enhancement_gate = false
        for i = 1, #G.playing_cards do
            local v = G.playing_cards[i]
            if SMODS.has_enhancement(v, 'm_stone') or SMODS.has_enhancement(v, 'm_steel') then
                enhancement_gate = true
                break
            end
        end
        return check and enhancement_gate
    end,

    loc_vars = function(self, info_queue, card)
        info_queue[#info_queue + 1] = G.P_CENTERS.m_stone
        info_queue[#info_queue + 1] = G.P_CENTERS.m_steel
        return {
            vars = {card.ability.extra.chips, card.ability.extra.x_mult}
        }
    end,

    calculate = function(self, card, context)
        if context.individual and context.scoring_hand then
            if context.cardarea == G.play and SMODS.has_enhancement(context.other_card, 'm_stone') then
                return {
                    chips = card.ability.extra.chips
                }
            end
            if context.cardarea == G.hand and SMODS.has_enhancement(context.other_card, 'm_steel') then
                return {
                    x_mult = card.ability.extra.x_mult
                }
            end
        end
    end
}
