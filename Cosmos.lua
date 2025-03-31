---- DEFINE THINGS TO USE BETWEEN FILES ----
G.cosmos = {
    mod = SMODS.current_mod,
    config = SMODS.current_mod.config,
    packs = {
        -- The card table gets filled with all related card keys based on the file names
        { key = 'Holiday', name = "Holiday Pack",  cards = {} },
        { key = 'Music',    name = "Music Mixtape", cards = {} },
    },
    C = {
        TRANSPARENT_DARK = HEX('11111133')
    },
    -- Packs will send their key here with an = true or false to tell whether they're inactive or active
    enabled = {}
}

---- LOAD IN PACKS ----
sendInfoMessage('Loading in packs...', 'Cosmos')
for i, v in ipairs(G.cosmos.packs) do
    ---- SET PACKS TO ENABLED OR DISABLED ----
    sendInfoMessage('Loading in ' .. v.name .. '...', 'Cosmos')
    if G.cosmos.config.packs[v.key] and G.cosmos.config.packs[v.key].enabled then
        sendInfoMessage(v.name .. ' is enabled.', 'Cosmos')
        G.cosmos.enabled[v.key] = true
    else
        sendInfoMessage(v.name .. ' is disabled, re-enable through the config menu if desired.', 'Cosmos')
        G.cosmos.enabled[v.key] = false
    end
    ---- ITEM ATLASES (BOOSTERS IN boosters.lua) ----
    SMODS.Atlas {
        key = v.key .. "Atlas",
        path = "items/" .. v.key .. ".png",
        px = 71,
        py = 95
    }
    ---- ACTUALLY LOAD PACKS ----
    local packs = NFS.getDirectoryItems(G.cosmos.mod.path .. 'packs/' .. v.key)
    for _, filename in pairs(packs) do
        local file, exception = SMODS.load_file('packs/' .. v.key .. "/" .. filename)
        if exception then
            error(exception)
        end
        file()
        table.insert(G.cosmos.packs[i].cards, "j_cosmos_" .. filename:gsub(".lua", ""))
    end
end
sendInfoMessage('All packs loaded.', 'Cosmos')

---- LOAD BOOSTER ATLAS AND CREATE BOOSTER PACKS ----
local file, exception = SMODS.load_file('packs/booster.lua')
if exception then
    error(exception)
end
file()

---- LOAD UI ATLASES ----
SMODS.Atlas {
    key = 'cosmos_logo_h',
    path = 'ui/' .. 'cosmos_logo_horizontal.png',
    px = 178,
    py = 49,
    prefix_config = { key = false }
}
SMODS.Atlas {
    key = 'cosmos_gear_icon',
    path = 'ui/' .. 'cosmos_gear_icon.png',
    px = 102,
    py = 102,
    prefix_config = { key = false }
}
SMODS.Atlas {
    key = 'modicon',
    path = 'ui/' .. 'mod_icon.png',
    px = 32,
    py = 32
}
---- LOAD UI FILES ----
local items = NFS.getDirectoryItems(G.cosmos.mod.path .. 'ui')
for _, filename in pairs(items) do
    local file, exception = SMODS.load_file('ui/' .. filename)
    if exception then
        error(exception)
    end
    file()
end



---- TODO ----
--[[
    Need to finish the general options page
        Figure out better names for weight differences
        Make a function to change the value of the weight and the values
            Maybe make a function to find the weight from a string and throw it in booster.lua
    
    Finish mini mod page constructor
    Make deactivated cards show in collection
        Card keys are already stored in G.cosmos.pack[pack numbered index].cards
        Check if G.cosmos.enabled[pack_key], then iterate over stores cards or something
]]--