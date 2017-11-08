local storage = 123456
local active = 123457
local warning = 1234568

function onSay(player, words, param)
	local g = player:getStorageValue(active)
	local s = player:getStorageValue(storage)
	s = s < 0 and 50 or s
	if param == 'on' then
		if g ~= 1 then
			player:setStorageValue(active, 1)
			player:say("Auto Heal is now activated!", TALKTYPE_MONSTER_SAY)
		else
			player:say("Auto Heal is already activated.", TALKTYPE_MONSTER_SAY)
		end
	elseif param == 'off' then
		if g > 0 then
			player:setStorageValue(active, 0)
			player:say("Auto Heal is now de-activated!", TALKTYPE_MONSTER_SAY)
		else
			player:say("Auto Heal is already de-activated.", TALKTYPE_MONSTER_SAY)
		end
	elseif param == 'help' then
		player:sendTextMessage(MESSAGE_STATUS_CONSOLE_BLUE, "To see the status autoheal type:")
		player:sendTextMessage(MESSAGE_STATUS_CONSOLE_ORANGE, "/autoheal status")
		player:sendTextMessage(MESSAGE_STATUS_CONSOLE_BLUE, "To turn on autoheal type:")
		player:sendTextMessage(MESSAGE_STATUS_CONSOLE_ORANGE, "/autoheal on")
		player:sendTextMessage(MESSAGE_STATUS_CONSOLE_BLUE, "To turn off autoheal type:")
		player:sendTextMessage(MESSAGE_STATUS_CONSOLE_ORANGE, "/autoheal off")
		player:sendTextMessage(MESSAGE_STATUS_CONSOLE_BLUE, "To toggle the warning message you get when out of potions type:")
		player:sendTextMessage(MESSAGE_STATUS_CONSOLE_ORANGE, "/autoheal warning toggle")
		player:sendTextMessage(MESSAGE_STATUS_CONSOLE_BLUE, "To change the percentage of healing type:")
		player:sendTextMessage(MESSAGE_STATUS_CONSOLE_ORANGE, "/autoheal n")
		player:sendTextMessage(MESSAGE_STATUS_CONSOLE_BLUE, "Where n is a number, the number must be between 1 - 100.")
		player:sendTextMessage(MESSAGE_STATUS_CONSOLE_BLUE, "If the number is the same, less than 1 or greater than 100, then no change will take place.")
	elseif param == 'status' then
		local status = g > 0 and " active & will execute when your health/mana falls below "..s.."%." or " not active."
		player:sendTextMessage(MESSAGE_STATUS_CONSOLE_ORANGE, "Your autoheal is" .. status)
	elseif param == 'warning toggle' then
		local w = player:getStorageValue(warning)
		player:setStorageValue(warning, (w <= 0 and 1 or 0))
		player:sendTextMessage(MESSAGE_STATUS_CONSOLE_ORANGE, "Potion warning has been turned "..(w < 0 and 'off' or 'on')..".")
	elseif param ~= '' and tonumber(param) > 0 then
		if g > 0 then
			local n = tonumber(param)
			if n > 0 and n < 100 then
				player:setStorageValue(storage, n)
			end
			
			if s == n then
				player:sendTextMessage(MESSAGE_STATUS_CONSOLE_BLUE, "Auto Heal Percentage has not changed from "..s.."%.")
			else
				player:sendTextMessage(MESSAGE_STATUS_CONSOLE_BLUE, "Your autoheal value has been set from "..s.."% to "..n.."%.")
			end
		else
			player:sendTextMessage(MESSAGE_STATUS_CONSOLE_BLUE, "You need to activate autoheal before you can use it!")
			player:sendTextMessage(MESSAGE_STATUS_CONSOLE_ORANGE, "For more info type: /autoheal help")
		end
	end
	return false
end
