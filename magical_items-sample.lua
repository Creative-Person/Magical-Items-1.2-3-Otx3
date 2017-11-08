dofile('data/items/magical_items_lib.lua')

x = EQ()
-- Example
--[[

-- tier 1
x:setTier(1, "ancient tiara", 1)
    x:attributes({'max health', 'max mana', 'sword','club', 'axe'}, {50, 50, 5, 5, 5})
    x:manashield()
    x:regen('hp', 5)
    
-- tier 2
x:setTier(1, "ancient tiara", 2)
    x:attributes({'max health', 'max mana', 'sword','club', 'axe'}, {100, 100, 10, 10, 10})
    x:regen({'hp', 'mana'}, 10)
x:setTier(1, "ancient tiara", 3)
    x:attributes({'max health', 'max mana', 'sword','club', 'axe', 'distance'}, {150, 150, 15, 15, 15, 15})
    x:regen({'hp', 'mana'}, 15)

-- tier 1
x:setTier(6, 'thunder hammer', 1)
	x:directDamage(nil, nil, 'combat ice', 170)
	x:damageReduction('defense fire', 500)
	x:regen('hp', 50)
	x:attributes('magic', 10)

-- tier 1
x:setTier(5, 'brass shield', 1)
	x:haste(3)
	x:directDamage('combat fire', 50)
	x:damageReduction('defense physical', 500, 'defense death', 2)
	x:regen('mana', 100)
]]