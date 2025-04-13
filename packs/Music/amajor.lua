SMODS.Joker {
    key = "amajor",
    unlocked = true,
    discovered = true,
    blueprint_compat = true,
    eternal_compat = true,
    perishable_compat = true,
    rarity = 2,
    atlas = "MusicAtlas",
    pos = { x = 3, y = 2 },
    cost = 6,
    config = { extra = { mult_mod = 1} },
    in_pool = function(self, args)
        local check = G.cosmos.enabled.Music or false
        return check
    end,
    loc_vars = function(self, info_queue, card)
        return {
            vars = { card.ability.extra.mult_mod }
        }
    end,
    calculate = function(self, card, context)
    end
}