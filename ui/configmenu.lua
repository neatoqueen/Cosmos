local cosmos = G.cosmos.mod or SMODS.current_mod
local config = cosmos.config

SMODS.current_mod.config_tab = function()
    -- Load locals
    local l_scale = 8
    local logo_h = Sprite(0, 0, l_scale*1, l_scale*1*(G.ASSET_ATLAS["cosmos_logo_h"].py/G.ASSET_ATLAS["cosmos_logo_h"].px), G.ASSET_ATLAS["cosmos_logo_h"], { x = 0, y = 0 })
    logo_h.states.drag.can = false
    local boosterarea = G.FUNCS.init_cosmos_config_booster_area()
    -- CardArea
    
    -- Return node
    return {n = G.UIT.ROOT, config = {colour = G.C.L_BLACK, padding = -0.1, r = 0.2}, nodes = {
        -- Left Side
        {n = G.UIT.C, config = {minh = 8, minw = 15, colour = G.C.L_BLACK, r = 0.5, align = 'cl', padding = 0}, nodes = {
            -- Make dark area
            {n = G.UIT.C, config = {minh = 6, minw = 2.5, colour = G.C.BLACK, r = 0.5, align = 'tm', padding = 0.2}, nodes = {
                -- Pack Selection title thing
                {n = G.UIT.R, config = {minh = 1.5, minw = 2.5, colour = G.C.L_BLACK, r = 0.5, emboss = 0.1, align = 'cm'}, nodes = {
                    {n = G.UIT.R, config = {minw = 2, padding = -0.05}, nodes = {
                        {n = G.UIT.T, config = {text = 'Pack', colour = G.C.UI.TEXT_LIGHT, scale = 0.8}}
                    }},
                    {n = G.UIT.R, config = {minw = 2.5, padding = -0.05}, nodes = {
                        {n = G.UIT.T, config = {text = 'Selection', colour = G.C.UI.TEXT_LIGHT, scale = 0.8}}
                    }}
                }},
                -- Load up buttons through function
                {n = G.UIT.R, config = {minw = 0, minh = 2.5, r = 1, padding = 0, align = 'cl'}, nodes = {
                    generate_cosmos_config_packs()
                }},
                -- Need a cycle option here
            }},
            -- Right Side
            {n = G.UIT.C, config = {minh = 7, minw = 10, colour = G.C.CLEAR, r = 0.5, align = 'cm', padding = 0.2}, nodes = {
                -- Logo and general options button
                {n = G.UIT.R, config = {minh = 1.7, maxh = 1.7, minw = 10, colour = G.C.CLEAR, r = 0.5, align = 'cl', padding = 0.2}, nodes = {
                    {n = G.UIT.C, config = {minh = 1, minw = 0, align = 'cl', padding = 0}, nodes = {
                    {n = G.UIT.O, config = {object = logo_h}}
                    }},
                    {n = G.UIT.C, config = {align = 'cm', padding = 0,minw = 0.5}, nodes = {}},
                    {n = G.UIT.C, config = {align = 'br', padding = 0}, nodes = {
                        {n = G.UIT.R, config = {minh = 1.5, maxh = 1.5, minw = 1.5, maxw = 1.5,  align = 'bm', padding = 0.2, colour = G.C.BLACK, r = 1}, nodes = {
                            {n = G.UIT.R, config = { tooltip = { text = { 'General Options' } }, hover = true, minh = 1, minw = 1, align = 'cm', emboss = 0.05, colour = G.C.L_BLACK, button = "cosmos_general_config_page", outline = 0.3, outline_colour = G.C.WHITE, r = 0.5, shadow = true }, nodes = {
                                {n = G.UIT.O, config = {object = Sprite(0,0,1,1, G.ASSET_ATLAS['cosmos_gear_icon'], {x=0,y=0})}}
                            }}
                        }}
                    }}

                }},
                -- Card area for loaded boosters
                {n = G.UIT.R, config = {minh = 5.7, minw = 10, colour = G.C.BLACK, r = 0.5, align = 'cm', padding = 0.3}, nodes = {
                    -- Card area goes here
                    {n = G.UIT.O, config = {object = boosterarea}}
                }},
                -- Save and load button
            }}
        }}
    }}
end