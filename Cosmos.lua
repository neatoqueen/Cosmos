SMODS.Atlas {
    key = "cosmos_modicon",
    path = "mod_icon.png",
    px = 34,
    py = 34,
}

SMODS.Atlas {
    key = "JJPack",
    path = "JollyJokers.png",
    px = 71,
    py = 95,
}

local subdir = "cards"
local cards = NFS.getDirectoryItems(SMODS.current_mod.path .. subdir)
for _, filename in pairs(cards) do
    local file, exception = SMODS.load_file(subdir .. "/" .. filename)
    if exception then
        error(exception)
    end
    file()
end
