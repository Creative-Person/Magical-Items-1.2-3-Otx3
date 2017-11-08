function onHealthChange(creature, attacker, primaryDamage, primaryType, secondaryDamage, secondaryType, origin)
	if isInArray({primaryType, secondaryType}, COMBAT_HEALING) then
		return primaryDamage, primaryType, secondaryDamage, secondaryType
	end
    local cid = creature and creature:getId() or 0
    local aid = attacker and attacker:getId() or 0 
	return x:magicItems(cid, aid, primaryDamage, primaryType, secondaryDamage, secondaryType, origin)
end