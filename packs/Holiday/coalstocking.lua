--STANN.co
SMODS.Joker {
    key = "coalstocking",
    unlocked = true,
    discovered = true,
    blueprint_compat = true,
    eternal_compat = true,
    perishable_compat = false,
    rarity = 1,
    atlas = "HolidayAtlas",
    pos = { x = 2, y = 1 },
    cost = 6,
    config = { extra = { mult = 0, mult_gain = 1 } },
    in_pool = function(self, args)
        local check = G.cosmos.enabled.Holiday or false
        return check
    end,
    enhancement_gate = 'm_stone',

    loc_vars = function(self, info_queue, card)
          info_queue[#info_queue+1] = G.P_CENTERS.m_stone
          return {
              vars = { card.ability.extra.mult, card.ability.extra.mult_gain }
          }
    end,
    calculate = function(self, card, context)
        -- checks if scoring card is stone card
    	if context.individual and context.cardarea == G.play then
        	if context.other_card.ability.effect == 'Stone Card' then
            	card.ability.extra.mult = card.ability.extra.mult + card.ability.extra.mult_gain
            	return {
	                extra = {
	                message = 'Coal...',
	                colour = G.C.BLACK,
	                focus = card,
	            },
	            card = card,
	            }
	        end
	    end

        --adds mult after hand is played
		if context.joker_main and card.ability.extra.mult > 0 then
			return {
				mult_mod = card.ability.extra.mult,
				message = localize { type = 'variable', key = 'a_mult', vars = { card.ability.extra.mult } },
				card = card
			}
        end
    end
}
