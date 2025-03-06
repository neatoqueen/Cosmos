--STANN.co
SMODS.Joker {
    key = "coalstocking",
    loc_txt = {
        name = "Coal Stocking",
        text = {
            "This Joker gains {C:mult}+#2#{} Mult",
            "when scoring a {C:attention}Stone{} Card",
            "{C:inactive}(Currently {C:mult}+#1#{C:inactive} Mult)"
        },
    },
    unlocked = true,
    discovered = true,
    blueprint_compat = true,
    eternal_compat = true,
    perishable_compat = false,
    enhancement_gate = 'm_stone',
    rarity = 1,
    atlas = "JJPack",
    pos = { x = 7, y = 0 },
    cost = 6,
    config = { extra = { mult = 0, mult_gain = 2 } },
    loc_vars = function(self, info_queue, card)
          info_queue[#info_queue+1] = G.P_CENTERS.m_stone
          return {
              vars = { card.ability.extra.mult, card.ability.extra.mult_gain }
          }
    end,
    calculate = function(self, card, context)
        -- checks if scoring card is stone card
    	if context.individual and not context.blueprint and context.cardarea == G.play then
        	if SMODS.has_enhancement(context.other_card, 'm_stone') then
            	card.ability.extra.mult = card.ability.extra.mult + card.ability.extra.mult_gain
            	return {
	                message = 'Coal...',
	                colour = G.C.BLACK,
                    focus = card
	            }
	        end
	    end

        --adds mult after hand is played
		if context.joker_main and card.ability.extra.mult > 0 then
			return {
				mult = card.ability.extra.mult
			}
        end
    end
}
