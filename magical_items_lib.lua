---------------------------------------------------------
--  MAGICAL ITEMS by Codex NG aka Yodex :)
---------------------------------------------------------
--  DROP THIS IN data/items/ 
---------------------------------------------------------

unpack = _VERSION == 'Lua 5.1' and unpack or table.unpack

EQ = {}
EQ.__index = EQ

setmetatable(EQ, {
  __call = function(cls, ...)
      return cls.new(...)
    end,
  })

function EQ.new()
    local self = setmetatable({}, EQ)
    self.conditions = {
      ['manashield'] = CONDITION_MANASHIELD,
      ['invisible'] = CONDITION_INVISIBLE,
      ['outfit'] = CONDITION_OUTFIT,
      ['haste'] = CONDITION_HASTE,
      ['paralyze'] = CONDITION_PARALYZE,
      ['regen'] = CONDITION_REGENERATION,
      ['attributes'] = CONDITION_ATTRIBUTES,
      ['light'] = CONDITION_LIGHT,    
      ['soul'] = CONDITION_SOUL,
      ['fire'] = CONDITION_FIRE,
      ['energy'] = CONDITION_ENERGY,
      ['poison'] = CONDITION_POISON,
      ['drown'] = CONDITION_DROWN,
      ['freeze'] = CONDITION_FREEZING,
      ['dazzle'] = CONDITION_DAZZLED,
      ['cursed'] = CONDITION_CURSED,
      ['bleed'] = CONDITION_BLEEDING,
      ['combat physical'] = COMBAT_PHYSICALDAMAGE,
      ['combat energy'] = COMBAT_ENERGYDAMAGE,
      ['combat earth'] = COMBAT_EARTHDAMAGE,
      ['combat fire'] = COMBAT_FIREDAMAGE,
      ['combat undefined'] = COMBAT_UNDEFINEDDAMAGE,
      ['combat life'] = COMBAT_LIFEDRAIN,
      ['combat mana'] = COMBAT_MANADRAIN,
      ['combat heal'] = COMBAT_HEALING,
      ['combat drown'] = COMBAT_DROWNDAMAGE,
      ['combat ice'] = COMBAT_ICEDAMAGE,
      ['combat holy'] = COMBAT_HOLYDAMAGE,
      ['combat death'] = COMBAT_DEATHDAMAGE,
      ['defense physical'] = COMBAT_PHYSICALDAMAGE,
      ['defense energy'] = COMBAT_ENERGYDAMAGE,
      ['defesne earth'] = COMBAT_EARTHDAMAGE,
      ['defense fire'] = COMBAT_FIREDAMAGE,
      ['defense undefined'] = COMBAT_UNDEFINEDDAMAGE,
      ['defense life'] = COMBAT_LIFEDRAIN,
      ['defense mana'] = COMBAT_MANADRAIN,
      ['defense heal'] = COMBAT_HEALING,
      ['defense drown'] = COMBAT_DROWNDAMAGE,
      ['defense ice'] = COMBAT_ICEDAMAGE,
      ['defense holy'] = COMBAT_HOLYDAMAGE,
      ['defense death'] = COMBAT_DEATHDAMAGE
    }
    self.subtypes = {
      ["manashield"] = 1,
      ['invisible'] = 2,
      ["outfit"] = 3,
      ["haste"] = 4,
      ["regen"] = 5,
      ["attributes"] = 6,
      ["light"] = 7,
      ["soul"] = 8,
      ["fire"] = 9,
      ["energy"] = 10,
      ["poison"] = 11,
      ["drown"] = 12,
      ["freeze"] = 13,
      ["dazzle"] = 14,
      ["cursed"] = 15,
      ["bleed"] = 16,
      ["paralyze"] = 17,
      ['attack'] = 18,
      ['defense'] = 19,
      ['critical'] = 20,
      ['combat physical'] = 21,
      ['combat energy'] = 22,
      ['combat earth'] = 23,
      ['combat fire'] = 24,
      ['combat undefined'] = 25,
      ['combat life'] = 26,
      ['combat mana'] = 27,
      ['combat heal'] = 28,
      ['combat drown'] = 29,
      ['combat ice'] = 30,
      ['combat holy'] = 31,
      ['combat death'] = 32,
      ['defense physical'] = 33,
      ['defense energy'] = 34,
      ['defense earth'] = 35,
      ['defense fire'] = 36,
      ['defense undefined'] = 37,
      ['defense life'] = 38,
      ['defense mana'] = 39,
      ['defense heal'] = 41,
      ['defense drown'] = 42,
      ['defense ice'] = 43,
      ['defense holy'] = 44,
      ['defense death'] = 45,
      ['spells'] = 46,
      ['transform'] = 47,
    }
    self.spells = {}
    self.slot = 1
    self.name = ''
    self.tier = 1
    self.subid = {}
    self.description = {}
    self.const = {}
    self.condition = {}
    self.transform = {}
    self.serialTable = {}
    self.serial = ''
    self.weapon = {}
    self.words = {}
    self.chance = 100
    self.itemSlots = {}
    self.shield = {}
    self.reduction = {}
    return self
end

function generateSerial(length)
    local str = ''
    for i = 1, length do
        str = str .. '0|'
    end
    return str:sub(1, #str-1)
end

BASESERIAL = generateSerial(47)

function EQ.getSubType(self, sub)
    return self.subtypes[sub]
end

function EQ.getAllSubTypes(self)
    return self.subtypes
end

-- if we change this it will change all items associated with it
-- this is only used as a base value, do not use this on items
function EQ.setSerial(self, name)
    if not self.serialTable[name] then
        self.serialTable[name] = BASESERIAL
    end
end

function EQ.getSerial(self, name)
    return self.serialTable[name] and self.serialTable[name] or ''
end

-- use to intialize an item at a specific slot and tier
--[[
Example Usage:

x:setTier(1, "ancient tiara", 1)
    x:attributes({'max health', 'max mana', 'sword','club', 'axe'}, {50, 50, 5, 5, 5})
    x:regen('hp', 5)
x:setTier(1, "ancient tiara", 2)
    x:attributes({'max health', 'max mana', 'sword','club', 'axe'}, {100, 100, 10, 10, 10})
    x:regen({'hp', 'mana'}, 10)
x:setTier(1, "ancient tiara", 3)
    x:attributes({'max health', 'max mana', 'sword','club', 'axe', 'distance'}, {150, 150, 15, 15, 15, 15})
    x:regen({'hp', 'mana'}, 15)

x:setTier(6, 'thunder hammer', 1)
  x:directDamage(nil, nil, 'combat ice', 170)
  x:damageReduction('defense fire', 500)

x:setTier(5, 'brass shield', 1)
  x:haste(3)
  x:directDamage('combat fire', 50)
  x:damageReduction('defense physical', 500, 'defense death', 2)

]]

-- x:setTier(slot, name, tier) 
function EQ.setTier(self, slot, name, tier)
    self.slot = slot
    self.name = name
    self.tier = tier
end

function EQ.updateTable(self, t, typ, val)

    if not t[self.slot] then
        t[self.slot] = {}
    end

    if not t[self.slot][self.name] then
        t[self.slot][self.name] = {}
    end
    if not t[self.slot][self.name][typ] then
        t[self.slot][self.name][typ] = {}
    end

    if not t[self.slot][self.name][typ][self.tier] then
        t[self.slot][self.name][typ][self.tier] = val or {}
    end

    return t
end

function EQ.updateOtherTable(self, t, val)
    if not t[self.slot] then
        t[self.slot] = {}
    end
    
    if not t[self.slot][self.name] then
        t[self.slot][self.name] = {}
    end

    if not t[self.slot][self.name][self.tier] then
        t[self.slot][self.name][self.tier] = val or {}
    end
    return t
end


function EQ.updateDescription(self, name, type, tier)
    if not self.description[name] then
        self.description[name] = {}
    end

    if not self.description[name][type] then
        self.description[name][type] = {}
    end

    if not self.description[name][type][tier] then
        self.description[name][type][tier] = ''
    end
end

function f(v)
    if v and v ~= '' then
        if tonumber(v) >= 0 then
            return '+'..v
        end
    end
    return v
end

function EQ.setSlots(item, slot)
    local name = item:getName()
    if not self.itemSlots[name] then
      self.itemSlots[name] = {}
      self.itemSlots[name].slot = slot
    end
end

function EQ.sp(self, str, p)
    local words = {}
    for word in str:gmatch("([^"..p.."]+)") do
        table.insert(words, word)
    end
    return words
end

function EQ.getArgs(self, arg, delimiter)
    local t = {}
    local s = self:sp(arg, "|")
    for _, v in pairs(s) do
      table.insert(t, self:sp(v, delimiter or ","))
    end
    return t
end

function EQ.updateFlags(self, str, index, replace)
    local attr = {}
    local i = 1
    for value in str:gmatch("([^|]+)") do
        if i == index then
          table.insert(attr, replace)
        else
          table.insert(attr, value)
        end
        i = i + 1
    end
    return table.concat(attr, "|")
end

-- returns a number the tier value or position rather of the serial or text
function Player:getMagicItemTier(item, subtype)
  local itemText = item:getAttribute(ITEM_ATTRIBUTE_TEXT)
  itemText = itemText == '' and x:getSerial(item:getName()) or itemText 
    if itemText and itemText ~= '' then
        local flags = x:getArgs(itemText)
        local tier = flags[x:getSubType(subtype)]
        if tier and next(tier) then
            return tonumber(tier[1])
        end
    end
    return 1
end

function Player:upradeItem(item, subtype, tier)
    local t = tier or 1
    local nextTier = self:getMagicItemTier(item, subtype) + t
    if nextTier < self:getMaxTier(item, subtype) then
        x:setMagicItemTier(item, subtype, nextTier)
    end
end


-- this returns the description of all the buffs, damage type/reductions
function Player:getMagicItemDescription(item)
  if not item:isItem() then
    return ''
  end
  local itemText = item:getAttribute(ITEM_ATTRIBUTE_TEXT)
  local name = item:getName()
  itemText = (itemText and itemText ~= '') and itemText or x:getSerial(name)
    if itemText and itemText ~= '' then
      local subtypes, desc = x:getAllSubTypes(), {}
        local flags = x:getArgs(itemText)
        for flagName, flagIndex in  pairs(subtypes) do
          local tier = flags[flagIndex]
          if tier and next(tier) then
            tier = tonumber(tier[1])
            if tier and tier ~= 0 then
              print(name, flagName, tier)
              desc[#desc+1] = x.description[name][flagName][tier]
            end
          end
        end
        return next(desc) and table.concat(desc) or ''
    end
    return ''
end


function Player:getMaxTier(item, subtype)
    if item then
        local name = item:getName()
        local tiers = x.description[name][subtype]
        if tiers and #tiers > 1 then
            return #tiers
        end
    end
    return 0
end

-- this method allows you to upgrade an item which uses this system
-- it will not work on items which are not defined in magical_items.lua
--[[
Example Usage:

function onUse(player, item, fromPosition, target, toPosition, isHotkey)
    if target then
        x:setMagicItemTier(target, 'attributes', 2)
    end
    return true
end

]]

-- x:setMagicItemTier(item, subtype, tier) 
function EQ.setMagicItemTier(self, item, subtype, tier) 
    local index = self.subtypes[subtype]
    if index and item then
        local name = item:getName()
        if name then
            if item:getAttribute(ITEM_ATTRIBUTE_TEXT) == '' then
                local attrText = self:getSerial(name)
                if attrText and attrText ~= '' then 
                    item:setAttribute(ITEM_ATTRIBUTE_TEXT, attrText)
                else
                    return
                end
            end
            if tier then
                local text = item:getAttribute(ITEM_ATTRIBUTE_TEXT)
                item:setAttribute(ITEM_ATTRIBUTE_TEXT, self:updateFlags(text, index, tier))
            end
        end
    end
end

function EQ.getTier(self)
    return self.tier
end


-- manashield does not stack or scale
-- x:manashield([description[, isCustomItem]])
function EQ.manashield(self, description, isCustomItem)
    local slot = self.slot
    local name = self.name
    local tier = self.tier
    local t = 'manashield'
    self:setSerial(name)
    self.condition = self:updateTable(self.condition, t)
    self.const = self:updateTable(self.const, t)
    self.subid = self:updateTable(self.subid, t, 0)
    self:updateDescription(name, t, tier)
    self.condition[slot][name][t][tier] = Condition(self.conditions[t], self.subid[slot][name][t][tier])
    self.condition[slot][name][t][tier]:setTicks(-1)
    self.const[slot][name][t][tier] = self.conditions[t]
    self.description[name][t][tier] = (description or "\nYe who bears this mystical "..name.." is granted an ancient magical shield.")
    if tier == 1 or isCustomItem then
        self.serialTable[name] = self:updateFlags(self.serialTable[name], self:getSubType(t), tier)
    end
end

-- invisible does not stack or scale
-- x:invisible([description[, isCustomItem]])
function EQ.invisible(self, description, isCustomItem)
    local slot = self.slot
    local name = self.name
    local tier = self.tier
    local t = 'invisible'
    self:setSerial(name)
    self.condition = self:updateTable(self.condition, t)
    self.const = self:updateTable(self.const, t)
    self.subid = self:updateTable(self.subid, t, 0)
    self:updateDescription(name, t, tier)
    self.condition[slot][name][t][tier] = Condition(self.conditions[t], self.subid[slot][name][t][tier])
    self.condition[slot][name][t][tier]:setTicks(-1)
    self.const[slot][name][t][tier] = self.conditions[t]
    self.description[name][t][tier] = (description or "\nThose who adorn this magical "..name.." can slip into the shadows.")
    if tier == 1 or isCustomItem then
        self.serialTable[name] = self:updateFlags(self.serialTable[name], self:getSubType(t), tier)
    end
end

-- outfit does not stack or scale
-- the outfitIndex corresponds to both v & d table's index
-- x:outfit(outfitIndex[, description[, isCustomItem]])
function EQ.outfit(self, lt, description, isCustomItem)
    local slot = self.slot
    local name = self.name
    local tier = self.tier
    local t = 'outfit'
    self:setSerial(name)
    local v = { -- value
          -- these are examples, list all the outfits u want to use for all the items
          [1] = {{lookType = 116}},     -- creature lookType
          [2] = {1, 899},         -- player outfits
          [3] = 2175,           -- item lookTypes
          [4] = {0, 230, 0, 0, 0, 0, 0} -- not sure yet :p 
     }
    
    self.condition = self:updateTable(self.condition, t)
    self.const = self:updateTable(self.const, t)
    self.subid = self:updateTable(self.subid, t, 0)
    self:updateDescription(name, t, tier)
    self.condition[slot][name][t][tier] = Condition(self.conditions[t], self.subid[slot][name][t][tier])
    local value = type(v[lt or 1]) ~= 'table' and {v[lt or 1]} or v[lt or 1]
    local d = { -- examples
          [1] = "\nPutting on this "..name.." will mask your true identity.",
          [2] = "\nBy dressing "..name.." your true identity will be masked.",
          [3] = "\nAdorning the "..name.." grants the wearer an illusion of a ".. ItemType(v[3]):getName() .. ".",
          [4] = "\nPutting on this "..name.." will mask your true identity."
    } 
    self.condition[slot][name][t][tier]:setOutfit(unpack(value))
    self.condition[slot][name][t][tier]:setTicks(-1)
    self.const[slot][name][t][tier] = self.conditions[t]
    self.description[name][t][tier] = (description or d[lt])
    if tier == 1 or isCustomItem then
        self.serialTable[name] = self:updateFlags(self.serialTable[name], self:getSubType(t), tier)
    end
end

-- the hasteIndex corresponds to the v table's index
-- x:haste(hasteIndex[, description[, isCustomItem]])
function EQ.haste(self, h, description, isCustomItem)
    local slot = self.slot
    local name = self.name
    local tier = self.tier
    local t = 'haste'
    local v = { -- put all your haste formulas here
          {0.3, -24, 0.3, -24},             -- haste
          {0.7, -56, 0.7, -56},             -- strong haste
          {0.8, -64, 0.8, -64},             -- swift foot
          {0.9, -72, 0.9, -72},             -- charge
        }
    self:setSerial(name)
    self.condition = self:updateTable(self.condition, t)
    self.const = self:updateTable(self.const, t)
    self.subid = self:updateTable(self.subid, t, 1)
    self:updateDescription(name, t, tier)
    self.condition[slot][name][t][tier] = Condition(self.conditions[t], self.subid[slot][name][t][tier])
    local value = type(v[h]) == 'function' and {v[h]()} or v[h] 
    self.condition[slot][name][t][tier]:setFormula(unpack(value))
    self.condition[slot][name][t][tier]:setTicks(-1)
    self.const[slot][name][t][tier] = self.conditions[t]
    self.description[name][t][tier] = (description or "\nPutting on this "..name.." will increase your speed significantly.")
    if tier == 1 or isCustomItem then
        self.serialTable[name] = self:updateFlags(self.serialTable[name], self:getSubType(t), tier)
    end
end

-- the paralyzeIndex corresponds to the v table's index
-- x:paralyze(paralyzeIndex[, description[, isCustomItem]])
function EQ.paralyze(self, p, description, isCustomItem)
    local slot = self.slot
    local name = self.name
    local tier = self.tier
    local t = 'paralyze'
    self:setSerial(name)
    local v = { -- put all your paralyze formulas here
          {-1, 80, -1, 80},           
          {-1, 80, -1, 80},             
          function() return -1, 80, -1, 80 end,   
          {-1, 80, -1, 80},
          {-1, 80, -1, 80}, 
        }
    self.condition = self:updateTable(self.condition, t)
    self.const = self:updateTable(self.const, t)
    self.subid = self:updateTable(self.subid, t, slot)
    self:updateDescription(name, t, tier)
    self.condition[slot][name][t][tier] = Condition(self.conditions[t], self.subid[slot][name][t][tier])
    local value = type(v[p]) == 'function' and {v[p]()} or v[p] 
    self.condition[slot][name][t][tier]:setFormula(unpack(value))
    self.condition[slot][name][t][tier]:setTicks(-1)
    self.const[slot][name][t][tier] = self.conditions['paralyze']
    self.description[name][t][tier] = (description or "")
    if tier == 1 or isCustomItem then
        self.serialTable[name] = self:updateFlags(self.serialTable[name], self:getSubType(t), tier)
    end
end

function capitalize(str)
    return str:gsub("(%l)(%w*)", function(a, b) return string.upper(a)..b end)
end

function tableconcat(a, b, d)
  local l = ''
  for i = 1, #a do
      l = l .. '[' ..capitalize(a[i]) .. d .. (type(b) == 'table' and b[i] or b) .. '] '
  end
  return l
end

-- both attributeType & attribute can be a table/variable, if attributeType is a variable so should attribute
-- x:regen(attributeType, attribute[, description[, isCustomItem]])
function EQ.regen(self, typ, attribute, description, isCustomItem)
    local slot = self.slot
    local name = self.name
    local tier = self.tier
    local t = 'regen'
    self:setSerial(name)
    local desc = ''
    local v = { 
          ['hp'] = CONDITION_PARAM_HEALTHGAIN,
          ['mana'] = CONDITION_PARAM_MANAGAIN 
    }
    self.condition = self:updateTable(self.condition, t)
    self.const = self:updateTable(self.const, t)
    self.subid = self:updateTable(self.subid, t, slot)
    self:updateDescription(name, t, tier)
    self.condition[slot][name][t][tier] = Condition(self.conditions[t], self.subid[slot][name][t][tier])
    if type(typ) == 'table' then
        for i = 1, #typ do
            self.condition[slot][name][t][tier]:setParameter(v[typ[i]], type(attribute) == 'table' and attribute[i] or attribute)
        end
        desc = tableconcat(typ, attribute, ':') 
    else
        self.condition[slot][name][t][tier]:setParameter(v[typ], attribute)
        desc = '['..capitalize(typ) .. ":" .. attribute..'] '
    end
    self.condition[slot][name][t][tier]:setTicks(-1)
    self.const[slot][name][t][tier] = self.conditions[t]
    self.description[name][t][tier] = (description or "\nWearing this "..name.." will grant the bearer a boost in " .. desc .."regen.")
    if tier == 1 or isCustomItem then
        self.serialTable[name] = self:updateFlags(self.serialTable[name], self:getSubType(t), tier)
    end
end

-- both type and attribute can be a table/variable, if type is not a table then attribute has to be a variable
-- x:attributes(type, attribute[, description[, isCustomItem]])
function EQ.attributes(self, typ, attribute, description, isCustomItem)
    local slot = self.slot
    local name = self.name
    local tier = self.tier
    local t = 'attributes'
    self:setSerial(name)
    local desc = ''
    local v = {
      ['melee'] = CONDITION_PARAM_SKILL_MELEE,
      ['fist'] = CONDITION_PARAM_SKILL_FIST,
      ['club'] = CONDITION_PARAM_SKILL_CLUB,
      ['sword'] = CONDITION_PARAM_SKILL_SWORD,
      ['axe'] = CONDITION_PARAM_SKILL_AXE,
      ['distance'] = CONDITION_PARAM_SKILL_DISTANCE,
      ['shielding'] = CONDITION_PARAM_SKILL_SHIELD,
      ['fishing'] = CONDITION_PARAM_SKILL_FISHING,
      ['max health'] = CONDITION_PARAM_STAT_MAXHITPOINTS,
      ['max mana'] = CONDITION_PARAM_STAT_MAXMANAPOINTS,
      ['magic'] = CONDITION_PARAM_STAT_MAGICPOINTS,
      ['max health%'] = CONDITION_PARAM_STAT_MAXHITPOINTSPERCENT,
      ['max mana%'] = CONDITION_PARAM_STAT_MAXMANAPOINTSPERCENT,
      ['magic%'] = CONDITION_PARAM_STAT_MAGICPOINTSPERCENT,
      ['melee%'] = CONDITION_PARAM_SKILL_MELEEPERCENT,
      ['fist%'] = CONDITION_PARAM_SKILL_FISTPERCENT,
      ['club%'] = CONDITION_PARAM_SKILL_CLUBPERCENT,
      ['sword%'] = CONDITION_PARAM_SKILL_SWORDPERCENT,
      ['axe%'] = CONDITION_PARAM_SKILL_AXEPERCENT,
      ['distance%'] = CONDITION_PARAM_SKILL_DISTANCEPERCENT,
      ['shield%'] = CONDITION_PARAM_SKILL_SHIELDPERCENT,
      ['fishing%'] = CONDITION_PARAM_SKILL_FISHINGPERCENT,
    }
    self.condition = self:updateTable(self.condition, t)
    self.const = self:updateTable(self.const, t)
    self.subid = self:updateTable(self.subid, t, slot)
    self:updateDescription(name, t, tier)
    self.condition[slot][name][t][tier] = Condition(self.conditions[t], self.subid[slot][name][t][tier])
    if type(typ) == 'table' then
        for i = 1, #typ do
            self.condition[slot][name][t][tier]:setParameter(v[typ[i]], type(attribute) == 'table' and attribute[i] or attribute)
        end
        desc = tableconcat(typ, attribute, ':') 
    else
        self.condition[slot][name][t][tier]:setParameter(v[typ], attribute)
        desc = '['..capitalize(typ) .. ":" .. attribute..'] '
    end
    self.condition[slot][name][t][tier]:setTicks(-1)
    self.const[slot][name][t][tier] = self.conditions[t]
    self.description[name][t][tier] = (description or "\nWearing this "..name.." will grant the bearer these attributes " .. desc .."in stats.")
    if tier == 1 or isCustomItem then
        self.serialTable[name] = self:updateFlags(self.serialTable[name], self:getSubType(t), tier)
    end
end

-- color is anything in the v table, level is a range value of 1 being the lowest and 8 possibly being the highest
-- x:light([color[, level[, description[, isCustomItem]]]])
function EQ.light(self, color, level, description, isCustomItem)
    local slot = self.slot
    local name = self.name
    local tier = self.tier
    local t = 'light'
    self:setSerial(name)
    local v = {
          ["blue"] = 5,
          ["light green"] = 30,
          ['light blue'] = 35,
          ['maya blue'] = 95,
          ['dark red'] = 108,
          ['light grey'] = 129,
          ['sky blue'] = 143,
          ['purple'] = 155,
          ['red'] = 180,
          ['orange'] = 198,
          ['yellow'] = 210,
          ['white'] = 215,
    }
    self.condition = self:updateTable(self.condition, t)
    self.const = self:updateTable(self.const, t)
    self.subid = self:updateTable(self.subid, t, slot)
    self:updateDescription(name, t, tier)
    self.condition[slot][name][t][tier] = Condition(self.conditions[t], self.subid[slot][name][t][tier])
    self.condition[slot][name][t][tier]:setParameter(CONDITION_PARAM_LIGHT_LEVEL, level or 8)
    self.condition[slot][name][t][tier]:setParameter(CONDITION_PARAM_LIGHT_COLOR, v[color] or v['yellow'])
    self.condition[slot][name][t][tier]:setTicks((60 * 1000) * 60 * 24)
    self.const[slot][name][t][tier] = self.conditions[t]
    self.description[name][t][tier] = (description or "\nThis "..name.." is inbued with the power of a mighty "..(color or "yellow" ).." star.")
    if tier == 1 or isCustomItem then
        self.serialTable[name] = self:updateFlags(self.serialTable[name], self:getSubType(t), tier)
    end
end

-- gain is how much soul to gain and ticks is how often to gain them
-- x:soul(gain, ticks[, description[, isCustomItem]])
function EQ.soul(self, gain, ticks, description, isCustomItem)
    local slot = self.slot
    local name = self.name
    local tier = self.tier
    local t = 'soul'
    self:setSerial(name)
    local tickstime = (ticks * 1000)
    self.condition = self:updateTable(self.condition, t)
    self.const = self:updateTable(self.const, t)
    self.subid = self:updateTable(self.subid, t, slot)
    self:updateDescription(name, t, tier)
    self.condition[slot][name][t][tier] = Condition(self.conditions[t], self.subid[slot][name][t][tier])
    self.condition[slot][name][t][tier]:setParameter(CONDITION_PARAM_SOULGAIN, value)
    self.condition[slot][name][t][tier]:setParameter(CONDITION_PARAM_SOULTICKS, tickstime)
    self.condition[slot][name][t][tier]:setTicks(-1)
    self.const[slot][name][t][tier] = self.conditions[t]
    self.description[name][t][tier] = (description or "\nThe "..name.." grants the bearer [Soul:"..value.."].")
    if tier == 1 or isCustomItem then
        self.serialTable[name] = self:updateFlags(self.serialTable[name], self:getSubType(t), tier)
    end
end

-- time, round or interval can be a table/variable, if time is a variable the rest should be aswell
-- this can not be applied to weapon damage... yet ;)
-- x:dot(time, round, interval, damage[, description[, isCustomItem]])
function EQ.dot(self, t, round, interval, damage, description, isCustomItem)
    local slot = self.slot
    local name = self.name
    local tier = self.tier
    local desc = ''
    self:setSerial(name)
    self:updateDescription(name, t, tier)
    if type(t) == 'table' then
        for i = 1, #t do
            self.condition = self:updateTable(self.condition, t[i])
            self.const = self:updateTable(self.const, t[i])
            self.subid = self:updateTable(self.subid, t[i], slot)
            self.condition[slot][name][t[i]][tier] = Condition(self.conditions[t[i]], self.subid[slot][name][t[i]][tier])
            self.condition[slot][name][t[i]][tier]:addDamage( (type(round) == 'table' and round[i] or round),  (type(interval) == 'table' and interval[i] or interval), (type(damage) == 'table' and damage[i] or damage) )
            self.const[slot][name][t[i]][tier] = self.conditions[t[i]]
            if tier == 1 or isCustomItem then
                self.serialTable[name] = self:updateFlags(self.serialTable[name], self:getSubType(t[i]), tier)
            end
        end
        desc = tableconcat(t, damage, ':')
    else
        self.condition = self:updateTable(self.condition, t)
        self.const = self:updateTable(self.const, t)
        self.subid = self:updateTable(self.subid, t, slot)
        self.condition[slot][name][t][tier] = Condition(self.conditions[t], self.subid[slot][name][t][tier])
        self.condition[slot][name][t][tier]:addDamage(round, interval, damage)
        self.const[slot][name][t][tier] = self.conditions[t]
        if tier == 1 or isCustomItem then
            self.serialTable[name] = self:updateFlags(self.serialTable[name], self:getSubType(t), tier)
        end
        desc = '['..capitalize(t) .. ":" .. damage ..'] '
    end
    self.description[name][t][tier] = (description or "\nYe who adorns this "..name.."is doomed to forever be cursed in, " .. desc .."damage.")
end

damageTypes = {
  [1] = "physical damage",
  [2] = 'energy damage',
  [4] = 'poison damage',
  [8] = 'fire damage',
  [16] = 'undefined damage',
  [32] = 'life drain',
  [64] = 'mana drain',
  [128] = 'healing',
  [256] = 'drowning damage',
  [512] = 'ice damage',
  [1024] = 'holy damage',
  [2048] = 'death damage',
}

-- manashield doesn't seem to work like it use to, this is the reason for this code
function EQ.hasManashield(self, cid, aid, primaryDamage, primaryType, secondaryDamage, secondaryType, origin)
    local creature = Creature(cid)
    local attacker = Creature(aid)
    if creature and creature:isPlayer() then
        if creature:getCondition(CONDITION_MANASHIELD) then
            local mana = 0
            local total = primaryDamage + secondaryDamage
            local test = creature:getMana()
            if total > 0 and test > total then
                local thing = (attacker and attacker:isCreature()) and 'an attack by a ' .. attacker:getName():lower() or damageTypes[primaryType]
                local text = "You lose "..total.." mana points due to "..thing.."."
                if primaryDamage ~= 0 then
                    mana = creature:getMana()
                    if mana >= primaryDamage then
                        creature:addMana(-primaryDamage)
                        primaryDamage = 0
                    else
                        creature:addMana(-mana)
                        primaryDamage = primaryDamage - mana
                    end
                end
                if secondaryDamage ~= 0 then
                    mana = creature:getMana()
                    if mana >= secondaryDamage then
                        creature:addMana(-secondaryDamage)
                        secondaryDamage = 0
                    else
                        creature:addMana(-mana)
                        secondaryDamage = secondaryDamage - mana
                    end
                end
                creature:sendTextMessage(MESSAGE_DAMAGE_RECEIVED, text, creature:getPosition(), total, TEXTCOLOR_PURPLE)
                creature:getPosition():sendMagicEffect(CONST_ME_LOSEENERGY)
            else
                if primaryDamage > 0 then
                    if primaryDamage >= test then
                        creature:addMana(-primaryDamage)
                        primaryDamage = primaryDamage - test
                    else
                        creature:addMana(-primaryDamage)
                        primaryDamage = test - primaryDamage
                    end
                    test = primaryDamage
                end
                if secondaryDamage > 0 then
                    if secondaryDamage >= test then
                        creature:addMana(-secondaryDamage)
                        secondaryDamage = secondaryDamage - test
                    else
                        creature:addMana(-secondaryDamage)
                        secondaryDamage = test - secondaryDamage
                    end
                end     
            end
        end
        self:autoHeal(creature:getId(), nil, 'mana') magicItems
    end
    return primaryDamage, primaryType, secondaryDamage, secondaryType, origin
end


combat_t = {
    ['combat physical'] = 21,
    ['combat energy'] = 22,
    ['combat earth'] = 23,
    ['combat fire'] = 24,
    ['combat undefined'] = 25,
    ['combat life'] = 26,
    ['combat mana'] = 27,
    ['combat heal'] = 28,
    ['combat drown'] = 29,
    ['combat ice'] = 30,
    ['combat holy'] = 31,
    ['combat death'] = 32
}

 combat_const = {
    ['combat physical'] = COMBAT_PHYSICALDAMAGE,
    ['combat energy'] = COMBAT_ENERGYDAMAGE,
    ['combat earth'] = COMBAT_EARTHDAMAGE,
    ['combat fire'] = COMBAT_FIREDAMAGE,
    ['combat undefined'] = COMBAT_UNDEFINEDDAMAGE,
    ['combat life'] = COMBAT_LIFEDRAIN,
    ['combat mana'] = COMBAT_MANADRAIN,
    ['combat heal'] = COMBAT_HEALING,
    ['combat drown'] = COMBAT_DROWNDAMAGE,
    ['combat ice'] = COMBAT_ICEDAMAGE,
    ['combat holy'] = COMBAT_HOLYDAMAGE,
    ['combat death'] = COMBAT_DEATHDAMAGE
}

function EQ.updateWeaponTable(self, primaryType, secondaryType, primaryDamage, secondaryDamage)
    if not self.weapon[self.name] then
        self.weapon[self.name] = {}
    end

    if primaryType then
        if not self.weapon[self.name][primaryType] then
            self.weapon[self.name][primaryType] = {}
        end

        if not self.weapon[self.name][primaryType][self.tier] then
            self.weapon[self.name][primaryType][self.tier] = {
                primaryType =  combat_const[primaryType] or nil,
                primaryDamage = primaryDamage or 0
            }
        end
    end

    if secondaryType then
        if not self.weapon[self.name][secondaryType] then
            self.weapon[self.name][secondaryType] = {}
        end

        if not self.weapon[self.name][secondaryType][self.tier] then
            self.weapon[self.name][secondaryType][self.tier] = {
                secondaryType =  combat_const[secondaryType] or nil,
                secondaryDamage = secondaryDamage or 0
            }
        end
    end
end


-- x:directDamage(primaryType, primaryValue, secondaryType, secondaryValue, isCustomItem)
function EQ.directDamage(self, primaryType, primaryValue, secondaryType, secondaryValue, isCustomItem)
    local slot = self.slot
    local name = self.name
    local tier = self.tier
    local chance = chance or 100
    local words = words or {}
    local cid = cid or 0
    local desc = '\nAttack Damage '
    self:setSerial(name)
    local d = {
      ['combat physical'] = "Physical: ",
      ['combat energy'] = "Energy: ",
      ['combat earth'] = "Earth: ",
      ['combat fire'] = "Fire: ",
      ['combat undefined'] = "Undefined: ",
      ['combat life'] = "Life: ",
      ['combat mana'] = "Mana: ",
      ['combat heal'] = "Heal: ",
      ['combat drown'] = "Drown: ",
      ['combat ice'] = "Ice: ",
      ['combat holy'] = "Holy: ",
      ['combat death'] = "Death: ",
    }

    self:updateWeaponTable(primaryType, secondaryType, primaryValue, secondaryValue)
    if primaryType and primaryValue then
        self:updateDescription(name, primaryType, tier)
        self.description[name][primaryType][tier] = '\nPD [' .. d[primaryType] .. f(primaryValue) .. ']'
        if tier == 1 or isCustomItem then
            self.serialTable[name] = self:updateFlags(self.serialTable[name], combat_t[primaryType], tier)
        end
    end
    if secondaryType and secondaryValue then
        self:updateDescription(name, secondaryType, tier)
        self.description[name][secondaryType][tier] = '\nSD [' .. d[secondaryType] .. f(secondaryValue) .. ']'
        if tier == 1 or isCustomItem then
            self.serialTable[name] = self:updateFlags(self.serialTable[name], combat_t[secondaryType], tier)
        end
    end 
end

 defense_const = {
    ['defense physical'] = COMBAT_PHYSICALDAMAGE,
    ['defense energy'] = COMBAT_ENERGYDAMAGE,
    ['defense earth'] = COMBAT_EARTHDAMAGE,
    ['defense fire'] = COMBAT_FIREDAMAGE,
    ['defense undefined'] = COMBAT_UNDEFINEDDAMAGE,
    ['defense life'] = COMBAT_LIFEDRAIN,
    ['defense mana'] = COMBAT_MANADRAIN,
    ['defense heal'] = COMBAT_HEALING,
    ['defense drown'] = COMBAT_DROWNDAMAGE,
    ['defense ice'] = COMBAT_ICEDAMAGE,
    ['defense holy'] = COMBAT_HOLYDAMAGE,
    ['defense death'] = COMBAT_DEATHDAMAGE
}

function EQ.updateDefenseTable(self, primaryType, secondaryType, primaryDamage, secondaryDamage)
    if not self.shield[self.name] then
        self.shield[self.name] = {}
    end

    if primaryType then
        if not self.shield[self.name][primaryType] then
            self.shield[self.name][primaryType] = {}
        end

        if not self.shield[self.name][primaryType][self.tier] then
            self.shield[self.name][primaryType][self.tier] = {
                primaryType =  defense_const[primaryType] or nil,
                primaryDamage = primaryDamage or 0
            }
        end
    end

    if secondaryType then
        if not self.shield[self.name][secondaryType] then
            self.shield[self.name][secondaryType] = {}
        end

        if not self.shield[self.name][secondaryType][self.tier] then
            self.shield[self.name][secondaryType][self.tier] = {
                secondaryType =  defense_const[secondaryType] or nil,
                secondaryDamage = secondaryDamage or 0
            }
        end
    end
end

defense_t = {
  ['defense physical'] = 33,
  ['defense energy'] = 34,
  ['defense earth'] = 35,
  ['defense fire'] = 36,
  ['defense undefined'] = 37,
  ['defense life'] = 38,
  ['defense mana'] = 39,
  ['defense heal'] = 41,
  ['defense drown'] = 42,
  ['defense ice'] = 43,
  ['defense holy'] = 44,
  ['defense death'] = 45,
}

defenseTypes = {
  [1] = "defense physical",
  [2] = 'defense energy',
  [4] = 'defense poison',
  [8] = 'defense fire',
  [16] = 'defense undefined',
  [32] = 'defense life',
  [64] = 'defense mana',
  [128] = 'defense heal',
  [256] = 'defense drown',
  [512] = 'defense ice',
  [1024] = 'defense holy',
  [2048] = 'defense death',
}


-- x:damageReduction(primaryType, secondaryType, primaryValue, secondaryValue, isCustomItem)
function EQ.damageReduction(self, primaryType, primaryValue, secondaryType, secondaryValue, isCustomItem)
    local slot = self.slot
    local name = self.name
    local tier = self.tier
    local chance = chance or 100
    local words = words or {}
    local cid = cid or 0
    local desc = '\nDamage Reduction '
    self:setSerial(name)

    local d = {
      ['defense physical'] = "Physical: ",
      ['defense energy'] = "Energy: ",
      ['defense earth'] = "Earth: ",
      ['defense fire'] = "Fire: ",
      ['defense undefined'] = "Undefined: ",
      ['defense life'] = "Life: ",
      ['defense mana'] = "Mana: ",
      ['defense heal'] = "Heal: ",
      ['defense drown'] = "Drown: ",
      ['defense ice'] = "Ice: ",
      ['defense holy'] = "Holy: ",
      ['defense death'] = "Death: ",
    }

    self:updateDefenseTable(primaryType, secondaryType, primaryValue, secondaryValue)
    if primaryType and primaryValue then
        self:updateDescription(name, primaryType, tier)
        self.description[name][primaryType][tier] = '\nPDR[' .. d[primaryType] .. f(primaryValue) .. ']'
        if tier == 1 or isCustomItem then
            self.serialTable[name] = self:updateFlags(self.serialTable[name], defense_t[primaryType], tier)
        end
    end
    if secondaryType and secondaryValue then
        self:updateDescription(name, secondaryType, tier)
        self.description[name][secondaryType][tier] = '\nSDR[' .. d[secondaryType] .. f(secondaryValue) .. ']'
        if tier == 1 or isCustomItem then
            self.serialTable[name] = self:updateFlags(self.serialTable[name], defense_t[secondaryType], tier)
        end
    end
end


function Player:getWeaponOrShield(primaryDamage, primaryType, secondaryDamage, secondaryType)
    local p, cp, s, cs = 0, nil, 0, nil
    local tier = 0
    for k, slot in pairs({5, 6}) do
        local item = self:getSlotItem(slot)
        if item then
            local name = item:getName()
            if x.weapon[name] then
                for const, xtbl in  pairs(x.weapon[name]) do
                    tier = self:getMagicItemTier(item, const)
                    for realtier, l in pairs(xtbl) do
                        for property, v in pairs(l) do
                            if tier ~= 0 then
                                local value = x.weapon[name][const][tier][property]
                                if property == 'primaryDamage' then
                                  if not cp  then
                                    cp = combat_const[const]
                                  end

                                  if cp and cp == combat_const[const] then
                                      p = p + value
                                    end
                                end

                                if property == 'secondaryDamage' then
                                  if not cs then
                                    cs = combat_const[const]
                                  end
                                  if cs and cs == combat_const[const] then
                                      s = s + value
                                    end
                                end                          
                            end
                        end
                    end
                end
            end
        end
    end
    primaryDamage = primaryDamage and (p and p + primaryDamage or primaryDamage) or 0
    primaryType = cp or primaryType
    secondaryDamage = secondaryDamage and (s and s + secondaryDamage or secondaryDamage) or 0
    secondaryType = cs or secondaryType
    return primaryDamage, primaryType, secondaryDamage, secondaryType
end


function Player:getEquipmentDefense(primaryDamage, primaryType, secondaryDamage, secondaryType)
    local p, s = 0, 0
    local slots = {1,2,3,4,5,6,7,8,9,10}
    local tier = 0
    for k, slot in pairs(slots) do
        local item = self:getSlotItem(slot)
        if item then
            local name = item:getName()
            if x.shield[name] then
                for const, xtbl in  pairs(x.shield[name]) do
                    tier = self:getMagicItemTier(item, const)
                    for realtier, l in pairs(xtbl) do
                        for property, v in pairs(l) do
                          local value = 0
                            if tier ~= 0 then
                                value = x.shield[name][const][tier][property]
                                if property == 'primaryDamage' then
                                  if defenseTypes[primaryType] == const then
                                    p = p + value
                                  end
                                end
                                if property == 'secondaryDamage' then
                                  if defenseTypes[secondaryType] == const then
                                    s = s + value
                                  end
                                end
                            end
                        end
                    end
                end
            end
        end
    end
    primaryDamage = (primaryDamage - p)  > 0 and (primaryDamage - p) or 0
    secondaryDamage = (secondaryDamage - s) > 0 and (secondaryDamage - s) or 0
  return primaryDamage, primaryType, secondaryDamage, secondaryType
end



function EQ.updateSpellsTable(self, t, spells, permanent)
    if not self.spells[self.slot] then
        self.spells[self.slot] = {}
    end
    
    if not self.spells[self.slot][self.name] then
        self.spells[self.slot][self.name] = {}
    end

    if not self.spells[self.slot][self.name][self.tier] then
      self.spells[self.slot][self.name][self.tier] = {
        spells = spells,
        permanent = permanent or false,
        type_ = t
      }
    end
end
-- x:setSpells(spells[, permanent[, isCustomItem]])
function EQ.setSpells(self, spells, permanent, isCustomItem)
    local slot = self.slot
    local name = self.name
    local tier = self.tier
    local desc = '\nThe '.. name ..' is blessed with spells '
    local t = 'spells'
    self:setSerial(name)
    self:updateDescription(name, t, tier)
    self:updateSpellsTable(t, type(spells) == 'table' and spells or {spells}  , permanent)
    if type(spells) == 'table' then
        for i = 1, #spells do
          desc = desc .. spells[i]:lower() .. ', '
        end
    else
        desc = desc .. spells:lower() .. ', '
    end
    if tier == 1 or isCustomItem then
        self.serialTable[name] = self:updateFlags(self.serialTable[name], self:getSubType(t), tier)
    end
    self.description[name][t][tier] = desc .. 'for tier ' .. tier .. '.'
end

function Player:setMagicItemCondition(item, slot, name)
    if x.condition[slot] and next(x.condition[slot]) then
        local magicCondition = x.condition[slot][name]
        if magicCondition and next(magicCondition) then
            for conditionType, conditionTable in pairs(magicCondition) do
                local tier = self:getMagicItemTier(item, conditionType)
                local condition = conditionTable[tier]
                if type(condition) == 'userdata' then
                    self:addCondition(condition)
                end
            end
        end
    end
end

function Player:unsetMagicItemCondtion(item, slot, name, infight)
    if x.const[slot] and next(x.const[slot]) then
        local magicConst = x.const[slot][name]
        if magicConst and next(magicConst) then
            for constType, constTable in pairs(magicConst) do
                for tier, const in pairs(constTable) do
                    self:removeCondition(const, x.subid[slot][name][constType][tier])
                    if infight then
                        self:removeCondition(CONDITION_INFIGHT, CONDITIONID_DEFAULT)
                    end
                end
            end
        end
    end
end

function Player:setMagicItemSpells(item, slot, name)
    if x.spells[slot] and next(x.spells[slot]) then
        local magicSpells = x.spells[slot][name]
        if magicSpells and next(magicSpells) then
            for _, tbl in pairs(magicSpells) do
                for property, value in pairs(tbl) do
                    if property == 'type_' then
                        local tier = self:getMagicItemTier(item, value)
                        if tier and tier ~= 0 then
                            local spells = x.spells[slot][name][tier].spells
                            if spells and next(spells) then
                                for i = 1, #spells do
                                    if not self:hasLearnedSpell(spells[i]) then
                                        self:learnSpell(spells[i])
                                    end
                                end
                            end
                        end
                    end
                end
            end
        end
    end
end

function Player:unsetMagicItemSpells(item, slot, name)
    if x.spells[slot] and next(x.spells[slot]) then
        local magicSpells = x.spells[slot][name]
        if magicSpells and next(magicSpells) then
            for _, tbl in pairs(magicSpells) do
                for property, value in pairs(tbl) do
                    if property == 'type_' then
                        local tier = self:getMagicItemTier(item, value)
                        if tier and tier ~= 0 then
                            local permanent = x.spells[slot][name][tier].permanent
                            if not permanent then
                                local spells = x.spells[slot][name][tier].spells
                                if spells and next(spells) then
                                    for i = 1, #spells do
                                        self:forgetSpell(spells[i])
                                    end
                                end
                            end
                        end
                    end
                end
            end
        end
    end
end

function Player:transformMagicItemTo(item, slot, name)
    if x.transform[slot] and next(x.transform[slot]) then
        local myItem = x.transform[slot][name]
        if myItem and next(myItem) then
            for _, tbl in pairs(myItem) do
                for property, value in pairs(tbl) do
                    if property == 'on' then
                        item:transform(value)
                    end
                end
            end
        end
    end
end

function Player:transformMagicItemFrom(item, slot, name) 
    if x.transform[slot] and next(x.transform[slot]) then
        local myItem = x.transform[slot][name]
        if myItem and next(myItem) then
            for _, tbl in pairs(myItem) do
                for property, value in pairs(tbl) do
                    if property == 'off' then
                        item:transform(value)
                    end
                end
            end
        end
    end
end

function EQ.updateTransformationTable(self, name, slot, tier)
  local slot = slot or self.slot
  local name = name or self.name
  local tier = tier or self.tier
    if not self.transform[slot] then
        self.transform[slot] = {}
    end
    
    if not self.transform[slot][name] then
        self.transform[slot][name] = {}
    end

    if not self.transform[slot][name][tier] then
        self.transform[slot][name][tier] = {}
    end
end

-- name is the name of the item you want this item to transform to
-- keep is if you want to keep this item as is and not change it back
-- x:setTransformItem(name[, keep[, isCustomItem]])
function EQ.setTransformItem(self, toName, keep, isCustomItem)
    local slot = self.slot
    local name = self.name
    local tier = self.tier
    local t = 'transform'
    if toName then
      self:updateTransformationTable(toName, slot, tier)
      self:setSerial(toName)
      self:updateDescription(toName, tier)
      self.transform[slot][toName][tier].off = ItemType(name):getId()
      local desc = '\nUnequipping this '  .. toName .. ' will transform it to a ' .. name .. '.'
      self.description[tier][toName] = desc
      if tier == 1 or isCustomItem then
        self.serialTable[toName] = self:updateFlags(self.serialTable[toName], self:getSubType(t), tier)
      end
      if not keep then
        self:updateTransformationTable()
        self:setSerial(name)
        self:updateDescription(name, t, tier)
        self.transform[slot][name][tier].on = ItemType(toName):getId()
        local desc = '\nEquipping this '  .. name .. ' will transform it to a ' .. toName .. '.'
        self.description[name][t][tier] = desc
        if tier == 1 or isCustomItem then
          self.serialTable[name] = self:updateFlags(self.serialTable[name], self:getSubType(t), tier)
        end
      end
    end
end


function EQ.attack(self, cid, aid, primaryDamage, primaryType, secondaryDamage, secondaryType, origin)
    local creature = Creature(cid)
    local attacker = Creature(aid)
    if attacker and attacker:isPlayer() then
        return attacker:getWeaponOrShield(primaryDamage, primaryType, secondaryDamage, secondaryType)
    end
    return primaryDamage, primaryType, secondaryDamage, secondaryType, origin
end


function EQ.defense(self, cid, aid, primaryDamage, primaryType, secondaryDamage, secondaryType, origin)
    local creature = Creature(cid)
    local attacker = Creature(aid)
    if creature and creature:isPlayer() then
        if creature and creature:isPlayer() then
            return creature:getEquipmentDefense(primaryDamage, primaryType, secondaryDamage, secondaryType)
        end
    end
    return primaryDamage, primaryType, secondaryDamage, secondaryType, origin
end

function EQ.magicItems(self, cid, aid, primaryDamage, primaryType, secondaryDamage, secondaryType, origin)
    x:autoHeal(cid)
    return self:hasManashield(cid, aid, self:attack(cid, aid, self:defense(cid, aid, primaryDamage, primaryType, secondaryDamage, secondaryType, origin)))
end

function EQ.onUpGradeTransition()
end

function EQ.onDownGradeTransition()
end
-- needs re-write for simplification
potions = {
  [7439] = {mana = {0, 0}, health = {250, 350}, flask = 7634, name = 'berserker', status = ''}, -- berserker
  [7440] = {mana = {0, 0}, health = {250, 350}, flask = 7634, name = 'mastermind', status = ''}, -- mastermind
  [7443] = {mana = {0, 0}, health = {250, 350}, flask = 7634, name = 'bullseye', status = ''}, -- bullseye
  [7588] = {mana = {0, 0}, health = {250, 350}, flask = 7634, name = 'strong health', status = ''}, -- strong hp
  [7589] = {mana = {115, 185}, health = {0, 0}, flask = 7634, name = 'strong mana', status = ''}, -- strong mana
  [7590] = {mana = {150, 250}, health = {0, 0}, flask = 7635, name = 'great mana', status = ''}, -- great mana
  [7591] = {mana = {0, 0}, health = {425, 575}, flask = 7635, name = 'great health', status = ''}, -- great hp
  [7618] = {mana = {0, 0}, health = {125, 175}, flask = 7636, name = 'health', status = ''}, -- hp 
  [7620] = {mana = {75, 125}, health = {0, 0}, flask = 7636, name = 'small mana', status = ''}, -- small mana
  [8472] = {mana = {100, 200}, health = {250, 350}, flask = 7635, name = 'great spirit', status = ' heals both hp/mana'}, -- great spirit
  [8473] = {mana = {0, 0}, health = {650, 850}, flask = 7635, name = 'ultimate health', status = ''}, -- ultimate hp
  [8474] = {combat = antidote, flask = 7636}, -- antidote
  [8704] = {mana = {0, 0}, health = {60, 90}, flask = 7636, name = 'small health', status = ''}, -- small hp
  [26029] = {mana = {425, 575}, health = {0, 0}, flask = 7635, name = 'ultimate mana', status = ''}, -- ultimate mana
  [26030] = {mana = {250, 350}, health = {420, 580}, flask = 7635, name = 'ultimate spirit', status = ' heals both hp/mana'}, -- ultimate spirit 
  [26031] = {mana = {875, 1125}, health = {875, 1125}, flask = 7635, name = 'super ultimate health', status = ' heals both hp/mana'}, -- super ultimate hp
}

function EQ.returnIDs(self)
  local ids = {}
  for itemid in pairs(potions) do
    table.insert(ids, itemid)
  end
  return ids
end

function EQ.hasCon(self, cid)
  local player = Player(cid)
  -- gettting the player's conditon doesn't seem to work
  local con = {
    {CONDITION_MANASHIELD, 'mana'}, 
    {CONDITION_PARALYZE, 'health'}, 
    {CONDITION_POISON, 'poison'} 
  }
  if player:getHealth() < player:getMaxHealth() then
    return 'health'
  elseif player:getMana() < player:getMaxMana() then
    return 'mana'
  else
    return 'health'
  end
end

storage = 123456
active = 123457
warning = 1234568

function EQ.hasItem(self, cid, count, type_)
  local itemids = self:returnIDs() 
  for _, itemid in pairs(itemids) do
    if potions[itemid][type_] then
      local amount = getPlayerItemCount(cid, itemid)
      if potions[itemid][type_][1] > 0 and amount >= count then
        return itemid, amount
      end
    end
  end
  if Player(cid):getStorageValue(warning) <= 0 then
      Player(cid):say("You are out of "..type_.." potions!", TALKTYPE_MONSTER_SAY)
  end
  return nil
end


-- this goes in onLogin
function EQ.onLogin(self, cid)
    local msgs = {
        {active, 'autoheal is not active', 'autoheal is active'},
        {warning, 'the warning msg is on', 'the warning msg is off'},
        {storage, 'has not been set, it is at its default of 50%', 'healing is set to '}
    }
    local msg = {}
    local player = Player(cid)
    if player then
        for _, m in pairs(msgs) do
            local d = player:getStorageValue(m[1])
            if m[1] == storage then
                table.insert(msg, d <= 0 and m[2] or m[3]..d.."%")
            else
                table.insert(msg, d <= 0 and m[2] or m[3])
            end
        end
        local w = table.concat(msg, ', ')
        player:sendTextMessage(MESSAGE_STATUS_CONSOLE_ORANGE, "Your " .. w .. ", for more info type /autoheal help.")
    end
end

-- x:autoHeal(cid[, threshold[, type_]])
function EQ.autoHeal(self, cid, threshold, type_, count)
  count = count or 1
  local player = Player(cid)
  if player then
    local activated = player:getStorageValue(active)
    if activated > 0 then
      local store = player:getStorageValue(storage)
      store = store < 1 and 50 or store
      threshold = threshold and (threshold * .01) or (store * 0.01)
      local d, p = 1, 0
      local condition = type_ or self:hasCon(cid)
      local itemid, amount = self:hasItem(cid, count, condition)
      local mLevel = player:getMagicLevel()
      local potion = itemid and potions[itemid] or nil
      if potion and next(potion) then
        if potion.health or potion.mana or potion.combat then
          if condition == 'mana' then
            d = player:getMana()
            local maxMana = player:getMaxMana()
            p = math.floor(maxMana * threshold)
            if d <= p then
              --print(potion.mana[1], potion.mana[2], itemid, 'mana')
              player:addMana(math.random(potion.mana[1], potion.mana[2]))
              player:getPosition():sendMagicEffect(CONST_ME_MAGIC_BLUE)
            end
          elseif condition == 'health' then
            d = player:getHealth()
            local maxHealth = player:getMaxHealth()
            p = math.floor(maxHealth * threshold)
            if d <= p then
              --print(potion.health[1], potion.health[2], itemid, 'health')
              player:addHealth(math.random(potion.health[1], potion.health[2]))
              player:removeCondition(CONDITION_PARALYZE)
              player:getPosition():sendMagicEffect(CONST_ME_MAGIC_BLUE)
            end
          end
          if d <= p then
            doPlayerRemoveItem(cid, itemid, count)
            player:addItem(potion.flask, count)
            player:say("Healing "..condition.." at "..(threshold * 100).."%", TALKTYPE_MONSTER_SAY)
            player:sendTextMessage(MESSAGE_STATUS_CONSOLE_BLUE, "Using "..count.." of " .. amount .. "x " .. potion.name .. " potions"..potion.status..".")
          end
        end
      end
    end
  end
end

function EQ.autoFish(self, cid)
    local player = Player(cid)
    if player then
        local active = player:getStorageValue(sv) > 0
        if active then
            -- 
        end
    end
end
