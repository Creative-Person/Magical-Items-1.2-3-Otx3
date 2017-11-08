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
local showDesc = false
local showType = false

movement = function(name, itemid, slot, type, desc) return '\n\t\t<!-- '..name..(showType and ' | type = '..type..' ' or '')..(showDesc and (desc and ' | description = '..desc or '') or '')..' -->\n\t\t<movevent event="Equip" itemid="'..itemid..'" slot="'..slot..'" script="magical_items.lua" />\n\t\t<movevent event="DeEquip" itemid="'..itemid..'" slot="'..slot..'" script="magical_items.lua" />\n' end

local fileEx = cwd()..'movements.xml'
local s = {}
file = io.open(fileEx, "w+")
for name, t in pairs(items) do
    local sl = slotNum[isInTable(slots, t.slot)]
    if not sl then
    elseif not s[sl] then
      s[sl] = {}
    else
      table.insert(s[sl], movement(name, t.itemid, isInTable(slots, t.slot), t.slot, t.description))
    end
end

for i in pairs(s) do
   file:write('\n\t<!--  '..slotStr[i]..' -->\n')
    for x = 1, #s[i] do
        file:write(s[i][x])
    end
end
file:close()
