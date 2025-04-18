SMODS.Joker {
    key = "ukulele",
    unlocked = true,
    discovered = true,
    blueprint_compat = true,
    eternal_compat = true,
    perishable_compat = true,
    rarity = 1,
    atlas = "MusicAtlas",
    pos = { x = 3, y = 1 },
    cost = 4,
    config = { extra = { chip_mod = 10, cards = 4 } },
    in_pool = function(self, args)
        local check = G.cosmos.enabled.Music or false
        return check
    end,
    loc_vars = function(self, info_queue, card)
        return {
            vars = { card.ability.extra.chip_mod, card.ability.extra.cards }
        }
    end,
    calculate = function(self, card, context)
        if context.joker_main and context.full_hand and #context.full_hand == 4 then
            local chips = card.ability.extra.chip_mod * #context.scoring_hand
            return {
                message = localize {
                    type = 'variable',
                    key = 'a_chips',
                    vars = {chips}
                },
                chip_mod = chips,
                colour = G.C.CHIPS
            }
        end
    end
}