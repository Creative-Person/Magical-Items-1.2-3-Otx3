local attr = {
    'itemid',
    'weight',
    'suppressDrown',
    'leveldoor',
    'skillAxe',
    'magiclevelpoints',
    'manashield',
    'description',
    'shootType',
    'healthGain',
    'fluidsource',
    'absorbPercentPhysical',
    'transformEquipTo',
    'absorbPercentDeath',
    'absorbPercentFire',
    'manaGain',
    'absorbPercentEarth',
    'skillShield',
    'speed',
    'suppressDrunk',
    'damage',
    'range',
    'fluidSource',
    'maleSleeper',
    'rotateTo',
    'stopduration',
    'destroyTo',
    'runeSpellName',
    'floorchange',
    'type',
    'count',
    'blocking',
    'skillFist',
    'walkStack',
    'containerSize',
    'femaleSleeper',
    'showcharges',
    'allowpickupable',
    'maxHitChance',
    'partnerDirection',
    'elementEnergy',
    'absorbPercentManaDrain',
    'showattributes',
    'fieldabsorbpercentfire',
    'absorbPercentIce',
    'hitChance',
    'showduration',
    'replaceable',
    'corpseType',
    'absorbPercentDrown',
    'ticks',
    'decayTo',
    'defense',
    'showcount',
    'absorbPercentHoly',
    'skillDist',
    'maxTextLen',
    'ammoType',
    'armor',
    'elementEarth',
    'elementIce',
    'transformDeEquipTo',
    'invisible',
    'duration',
    'writeable',
    'skillClub',
    'effect',
    'blockprojectile',
    'field',
    'extradef',
    'absorbPercentMagic',
    'attack',
    'pickupable',
    'start',
    'absorbPercentLifeDrain',
    'absorbPercentEnergy',
    'writeOnceItemId',
    'readable',
    'allowDistRead',
    'skillSword',
    'charges',
    'elementFire',
    'healthTicks',
    'manaTicks',
}

local slots = {
  [{'head'}] = "head",
  [{'neck', 'necklace'}] = "necklace",
  [{'backpack', 'bag'}] = "backpack",
  [{'armor', 'body'}] = "armor",
  [{'right-hand', 'right', 'shield', 'hand'}] = "right-hand", -- hand
  [{'left-hand', 'left','distance','two-handed','club','sword','wand','axe'}] = "left-hand", -- hand
  [{'legs'}] = 'legs',
  [{'feet'}] = 'feet',
  [{'ring'}] = 'ring',
  [{'ammo', 'ammunition'}] = 'ammo'
}

--[[
    Slot Id's of equipment
    1 - helmet
    2 - necklace slot (amulet of loss etc.)
    3 - backpack, bag
    4 - armor
    5 - left hand
    6 - right hand
    7 - legs
    8 - boots
    9 - ring slot
    10 - ammo slot (arrows etc.)
]]

local slotNum = {
  ["head"] = 1,
  ["necklace"] = 2,
  ["backpack"] = 3,
  ["armor"] = 4,
  ["left-hand"] = 5,
  ["right-hand"] = 6,
  ['legs'] = 7,
  ['feet'] = 8,
  ['ring'] = 9,
  ['ammo'] = 10
}

local slotStr = {
  [1] = "head",
  [2] = "necklace",
  [3] = "backpack",
  [4] = "armor",
  [5] = "left-hand",
  [6] = "right-hand",
  [7] = 'legs',
  [8] = 'feet',
  [9] = 'ring',
  [10] = 'ammo'
}

function isInArray(a, f)
  for k, v in pairs(a) do
    if v == f then
      return true
    end
  end
  return false
end

function isInTable(t, f)
  for n, m in pairs(t) do
      if isInArray(n, f) then
        return m
      end
  end
  return 0
end


function cwd(name)
    local chr = os.tmpname():sub(1,1)
    if chr == "/" then
      -- linux
      chr = "/[^/]*$"
    else
      -- windows
      chr = "\\[^\\]*$"
    end
    return arg[0]:sub(1, arg[0]:find(chr))..(name or '')
end
local path = cwd('items.lua')

dofile(path)

function gen(atr, item)
  local newLine = "\n\t\t\t"
  local value = nil
  --print(atr)
  if atr == 'slot' then
    value = isInTable(slots, item.slot)
  else
    value = item[atr]
  end
  return (value and newLine..atr.." = "..(type(tonumber(value)) == 'number' and value or "\""..value.."\"")..',' or '')
end

function at(name, item, x)
    local d = '--[['
    for i = 1, #attr do
        d = d ..gen(attr[i], item)
    end
    d = d .. '\n\t]]'
    return d
end

-- set this to true if you want to see all the items attributes
local attributes = false

local fileEx = cwd()..'magical_items.lua'
local s, ss = {}, {}
file = io.open(fileEx, "w+")
for name, t in pairs(items) do
    local sl = slotNum[isInTable(slots, t.slot)]
    if not sl then
      
    elseif not s[sl] then
      s[sl] = {}
    elseif not ss[sl] then
      ss[sl] = {}
    else
      table.insert(s[sl], name) 
      if attributes then 
          table.insert(ss[sl], at(name, t, sl))
      end
    end
end
file:write('x = EQ()\n')
for i in pairs(s) do
    file:write('\n -- Slot ' .. slotStr[i] .. "\n")
    file:write(' -- x:setTier(slot, name, tier)\n')
    for x = 1, #s[i] do
        file:write('\tx:setTier(' .. slotNum[slotStr[i]] .. ', "'.. s[i][x] .. '", 1)\n')
        if attributes then 
            file:write('\t'..ss[i][x] ..'\n')
        end
    end
end
file:close()
