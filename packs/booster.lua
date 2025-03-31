SMODS.Atlas {
    key = "cosmos_boosters",
    path = "items/Boosters.png",
    px = 71,
    py = 95
}

for i, v in ipairs(G.cosmos.packs) do
    local pack = v.key
    local choice = { choose = 1, extra = 4 }
    local cost = 6
    if #v.cards < 10 then
        choice = { choose = 1, extra = 2 }
        cost = 4
    end
    local pos = { x = (i - 1) % 5, y = math.floor((i - 1) / 5) }
    SMODS.Booster {
        key = pack .. '_booster',
        weight = G.cosmos.config['booster weight'] or 0,
        cost = cost,
        config = choice,
        atlas = "cosmos_boosters",
        pos = pos,
        discovered = true,
        group_key = 'k_cosmos_pack',
        kind = 'cosmos_pack',
        in_pool = function(self, args)
            if G.cosmos.enabled[pack] then
                return true
            end
        end,
        loc_vars = function(self, info_queue, card)
            return { vars = { (card and card.ability.choose or self.config.choose), (card and card.ability.extra or self.config.extra) } }
        end,
        create_card = function(self, card, i)
            return create_card("Joker", G.pack_cards, nil, nil, true, true,
                pseudorandom_element(cosmos_pool(v.cards), pseudoseed(pack)), nil)
        end
    }
end



---- THANK YOU ORTALAB ----
function cosmos_pool(cards)
    --create the pool
    G.ARGS.TEMP_POOL = EMPTY(G.ARGS.TEMP_POOL)
    local _pool, _starting_pool, _pool_key, _pool_size = G.ARGS.TEMP_POOL, nil, '', 0

    _starting_pool, _pool_key = G.P_CENTER_POOLS['Joker'], 'cosmos_pool'


    --cull the pool
    for k, v in ipairs(_starting_pool) do
        local add = nil

        for k2, v2 in ipairs(cards) do
            if v.key == v2 then
                add = true
            end
        end
        -- Remove cards that are already present
        if add and G.GAME.used_jokers[v.key] and not (next(SMODS.find_card('j_showman'))) then
            add = nil
        end

        if add and not G.GAME.banned_keys[v.key] then
            _pool[#_pool + 1] = v.key
            _pool_size = _pool_size + 1
        end
    end

    --if pool is empty
    if _pool_size == 0 then
        _pool = EMPTY(G.ARGS.TEMP_POOL)
        _pool[#_pool + 1] = "j_joker"
    end

    return _pool, _pool_key .. G.GAME.round_resets.ante
end