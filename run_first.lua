

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

local path = cwd()
 
table.find = function(table, value)
    for i, v in pairs(table) do
        if v == value then
            return i
        end
    end
    return false
end

function gen(name, i, items)
  local newLine = "\n\t\t\t"
  local value = items[i][name]
  return (value and newLine..name.." = "..(type(tonumber(value)) == 'number' and value or "\""..value.."\"")..',' or '')
end
local storage = 18000
local attr = {
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

function parseItems()
    -- location of items.xml
    local file = path..'items.xml'
    -- save location of items.lua
    local fileEx = path..'items.lua'
    local outputFile = fileEx
    local items = {}
     
    for line in io.lines(file) do
        for mi,id,mid,name in line:gmatch('<(%a-)%s*id%s*=%s*"(%d+)"%s*(.-)%s*name%s*=%s*"(.-)"') do
        if mi == 'item' then
            table.insert(items, {id = id, name = name})
        end
        end
 
        for key,value in line:gmatch('<attribute key="(.-)" value="(.-)"') do
            if key == "slotType" or key == "weaponType" then
                items[#items].slot = value
            end
            for a = 1, #attr do
                if key == attr[a] then
                    items[#items][attr[a]] = value
                end
            end
        end
    end
 
    local types = {}
    for i = 1, #items do
        if items[i].slot then
        if not table.find(types, items[i].slot) then
            table.insert(types, items[i].slot)
        end
        end
    end
 
    fileEx = io.open(fileEx, "w+")
    fileEx:write("items = {\n")
    for i = 1, #items do
        if items[i].slot then
            fileEx:write("\t[\"" .. items[i].name .. "\"] = {\n\t\t\titemid = " .. items[i].id .. ",\n\t\t\tslot = \"" .. items[i].slot .. "\", ")
            for b = 1, #attr do
              fileEx:write(gen(attr[b], i, items))
            end
            fileEx:write("\n\t},\n")
        end
    end

    fileEx:write("}")
    fileEx:close()
 
    print("#############################")
    print("File saved as " .. outputFile)
    print("----")
    print("Items loaded: " .. #items)
    print("Types loaded: " .. #types)
return true
end
 
parseItems()