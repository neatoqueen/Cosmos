local cosmos = G.cosmos.mod or SMODS.current_mod
local config = cosmos.config

function generate_cosmos_config_packs(args)
    local output = { n = G.UIT.C, config = { minw = 2.5, minh = 4, align = 'tm', padding = 0.2 }, nodes = {} }
    for i, v in ipairs(G.cosmos.packs) do
        v.colour = v.colour or G.C.L_BLACK
        v.name = v.name or 'NO NAME PROVIDED'
        --        v.options = v.options or 'enabled'
        v.back_colour = v.back_colour or G.cosmos.C.TRANSPARENT_DARK
        v.key = v.key or 'test'
        local page = create_cosmos_mini_page({ key = v.key })
        local node = {
            n = G.UIT.R,
            config = { minw = 2, minh = 0.8, colour = v.back_colour, padding = 0.2, r = 0.1 },
            nodes = {
                {
                    n = G.UIT.C,
                    config = { maxw = 2.5, maxh = 0.8, minw = 2.5, colour = v.colour, r = 1, hover = true, can_collide = true, button = page, outline = 0.6, outline_colour = G.C.WHITE, emboss = 0.1, align = 'cm' },
                    nodes = {
                        { n = G.UIT.T, config = { text = v.name, scale = 0.3, colour = G.C.UI.TEXT_LIGHT, shadow = true } }
                    }
                },
                {
                    n = G.UIT.C,
                    config = {},
                    nodes = {
                        create_cosmos_toggle { shadow = true, ref_table = config.packs[v.key], ref_value = 'enabled', pack = v.key }
                        --                        create_toggle { label = '', active_colour = v.colour, scale = 1, w = 0,  }
                    }
                }
            }
        }
        table.insert(output.nodes, node)
    end
    return output
end

function create_cosmos_toggle(args)
    args = args or {}
    args.active_colour = args.active_colour or G.C.L_BLACK
    args.inactive_colour = args.inactive_colour or G.C.BLACK
    args.w = args.w or 0
    args.h = args.h or 0.5
    args.scale = args.scale or 1
    args.label = args.label or ''
    args.label_scale = args.label_scale or 0.4
    args.ref_table = args.ref_table or {}
    args.ref_value = args.ref_value or 'test'
    args.pack = args.pack or 'test'

    local check = Sprite(0, 0, 0.5 * args.scale, 0.5 * args.scale, G.ASSET_ATLAS["icons"], { x = 1, y = 0 })
    check.states.drag.can = false
    check.states.visible = false

    local info = nil
    if args.info then
        info = {}
        for k, v in ipairs(args.info) do
            table.insert(info, {
                n = G.UIT.R,
                config = { align = "cm", minh = 0.05 },
                nodes = {
                    { n = G.UIT.T, config = { text = v, scale = 0.25, colour = G.C.UI.TEXT_LIGHT } }
                }
            })
        end
        info = { n = G.UIT.R, config = { align = "cm", minh = 0.05 }, nodes = info }
    end

    local t =
    {
        n = args.col and G.UIT.C or G.UIT.R,
        config = { align = "cm", padding = 0.1, r = 0.1, colour = G.C.CLEAR, focus_args = { funnel_from = true } },
        nodes = {
            {
                n = G.UIT.C,
                config = { align = "cr", minw = args.w },
                nodes = {
                    { n = G.UIT.T, config = { text = args.label, scale = args.label_scale, colour = G.C.UI.TEXT_LIGHT } },
                    { n = G.UIT.B, config = { w = 0.1, h = 0.1 } },
                }
            },
            {
                n = G.UIT.C,
                config = { align = "cl", minw = 0.3 * args.w },
                nodes = {
                    {
                        n = G.UIT.C,
                        config = { align = "cm", r = 0.1, colour = G.C.BLACK },
                        nodes = {
                            {
                                n = G.UIT.C,
                                config = {
                                    align = "cm",
                                    r = 0.1,
                                    padding = 0.03,
                                    minw = 0.4 * args.scale,
                                    minh = 0.4 * args.scale,
                                    outline_colour = G.C.WHITE,
                                    outline = 1.2 * args.scale,
                                    line_emboss = 0.5 * args.scale,
                                    ref_table = args,
                                    colour = args.inactive_colour,
                                    button = 'cosmos_toggle_button',
                                    button_dist = 0.2,
                                    hover = true,
                                    toggle_callback = args.callback,
                                    func = 'toggle',
                                    focus_args = { funnel_to = true },
                                    pack = args.pack
                                },
                                nodes = {
                                    { n = G.UIT.O, config = { object = check } },
                                }
                            },
                        }
                    }
                }
            },
        }
    }
    if args.info then
        t = {
            n = args.col and G.UIT.C or G.UIT.R,
            config = { align = "cm" },
            nodes = {
                t,
                info,
            }
        }
    end
    return t
end

function G.FUNCS.cosmos_toggle_button(e)
    G.FUNCS.toggle_button(e)
    local exist = { false }
    G.cosmos.enabled[e.config.pack] = e.config.ref_table.ref_table[e.config.ref_table.ref_value]
    for i = 1, #G.cosmos.ConfigBoosterArea.cards do
        if G.cosmos.ConfigBoosterArea.cards[i].config.center.key == 'p_' .. G.cosmos.mod.prefix .. '_' .. e.config.pack .. '_booster' then
            exist = { true, G.cosmos.ConfigBoosterArea.cards[i] }
        end
    end
    if exist[1] and not e.config.ref_table.ref_table[e.config.ref_table.ref_value] then
        local card = exist[2]
        G.E_MANAGER:add_event(Event({
            trigger = 'after',
            delay = 0,
            blockable = false,
            func = function()
                G.cosmos.ConfigBoosterArea:remove_card(card)
                card:remove()
                card = nil
                return true
            end
        }))
    else
        local scale = 1.2
        local booster = Card(
            40,
            0,
            G.CARD_W * 1.27 * scale,
            G.CARD_H * 1.27 * scale,
            G.P_CARDS.empty,
            G.P_CENTERS['p_' .. G.cosmos.mod.prefix .. '_' .. e.config.pack .. '_booster'],
            { bypass_discovery_center = true, bypass_discovery_ui = true }
        )
        G.cosmos.ConfigBoosterArea:emplace(booster)
    end
end

function create_cosmos_mini_page(info)
    local func = 'generate_cosmos_' .. info.key .. '_page'
    G.FUNCS[func] = function(info)
        G.FUNCS.overlay_menu({
            definition = create_UIBox_generic_options({
                back_func = 'cosmos_page_exit',
                contents = {
                    {
                        n = G.UIT.R,
                        config = { colour = G.C.BLACK, r = 1, padding = 0.3 },
                        nodes = {
                            {
                                n = G.UIT.R,
                                config = { minh = 7, minw = 10, colour = G.C.RED, r = 1, align = 'cl' },
                                nodes = {
                                    {
                                        n = G.UIT.C,
                                        config = { minh = 6, minw = 3, colour = G.C.GREEN, r = 1, align = 'tm', padding = 0.3 },
                                        nodes = {
                                            {
                                                n = G.UIT.R,
                                                config = { minh = 2, minw = 2.7, colour = G.C.RED },
                                                nodes = {
                                                    {
                                                        n = G.UIT.R,
                                                        config = {},
                                                        nodes = {
                                                            { n = G.UIT.T, config = { text = 'Jolly', colour = G.C.UI.TEXT_LIGHT, scale = 1 } }
                                                        }
                                                    },
                                                    {
                                                        n = G.UIT.R,
                                                        config = {},
                                                        nodes = {
                                                            { n = G.UIT.T, config = { text = 'Jokers', colour = G.C.UI.TEXT_LIGHT, scale = 1 } },

                                                            -- Start
                                                            {
                                                                n = G.UIT.C,
                                                                config = { minw = 2.5, minh = 4, align = 'tm', padding = 0.2 },
                                                                nodes = {
                                                                    {
                                                                        n = G.UIT.R,
                                                                        config = { minw = 2, minh = 0.8, colour = G.C.L_BLACK, padding = 0.2, r = 0.1 },
                                                                        nodes = {
                                                                            {
                                                                                n = G.UIT.C,
                                                                                config = { minw = 2.5, colour = G.C.L_BLACK, r = 1, hover = true, can_collide = true, button = 'generate_cosmos_holiday_page', outline = 0.6, outline_colour = G.C.WHITE, emboss = 0.1, align = 'cm' },
                                                                                nodes = {
                                                                                    { n = G.UIT.T, config = { text = "Holiday Pack", scale = 1.5, colour = G.C.UI.TEXT_LIGHT, shadow = true } }
                                                                                }
                                                                            },
                                                                            {
                                                                                n = G.UIT.C,
                                                                                config = {},
                                                                                nodes = {
                                                                                    create_cosmos_toggle { shadow = true, ref_table = config.packs.Holiday, ref_value = 'enabled' }
                                                                                    --                        create_toggle { label = '', active_colour = v.colour, scale = 1, w = 0,  }
                                                                                }
                                                                            }
                                                                        }
                                                                    } }
                                                            } -- END
                                                        }
                                                    }
                                                }
                                            }
                                        }
                                    }
                                }
                            }
                        }
                    }
                },
            })
        })
    end
    return func
end

function G.FUNCS.cosmos_page_exit()
    G.SETTINGS.paused = true
    SMODS.save_mod_config(cosmos)
    SMODS.LAST_SELECTED_MOD_TAB = "config"
    G.FUNCS.overlay_menu({
        definition = create_UIBox_mods(cosmos)
    })
end

G.FUNCS.cosmos_general_config_page = function(e)
    G.FUNCS.overlay_menu({
        definition = create_UIBox_generic_options({
            back_func = 'cosmos_page_exit',
            contents = {
                {
                    n = G.UIT.R,
                    config = { colour = G.C.BLACK, r = 1, padding = 0.3 },
                    nodes = {
                        create_option_cycle{options = {"Can't Appear", "A quarter as common as Spectral Packs", "Half as common as Spectral Packs", "As common as Spectral Packs", "As common as Buffoon Packs", "As common as consumable packs"}}
                    }
                }}
        })
    })
end

G.FUNCS.cosmos_save_and_apply = function(e)
    G.ACTIVE_MOD_UI = nil
    SMODS.save_all_config()
    SMODS.restart_game()
    SMODS.IN_MODS_TAB = nil
end

function G.FUNCS.init_cosmos_config_booster_area()
    G.cosmos.ConfigBoosterArea = CardArea(
        0,
        0,
        2.4 * G.CARD_W * 2,
        1.15 * G.CARD_H * 1,
        { card_limit = 10, type = 'title_2', highlight_limit = 1, card_w = 1.27 * G.CARD_W }
    )
    for i, v in ipairs(G.cosmos.packs) do
        if G.cosmos.enabled[v.key] then
            local scale = 1.2
            local booster = Card(
                0,
                0,
                G.CARD_W * 1.27 * scale,
                G.CARD_H * 1.27 * scale,
                G.P_CARDS.empty,
                G.P_CENTERS['p_' .. G.cosmos.mod.prefix .. '_' .. v.key .. '_booster'],
                { bypass_discovery_center = true, bypass_discovery_ui = true }
            )
            G.cosmos.ConfigBoosterArea:emplace(booster)
        end
    end
    return G.cosmos.ConfigBoosterArea
end
