_addon = {
	name = 'Groceries',
	author = 'darkwaffle',
	version = '0.5.0',
	command = 'gro',
}

WINDOWER_PACKETS = require('packets')
WINDOWER_RESOURCES = require('resources')
WINDOWER_TEXTS = require('texts')
require "pack"

PLAYER_SETTINGS = require("settings")

require "bid/inject"
require "bid/log"
require "bid/queue"
require "bid/result"

require "display/content"
require "display/log"
require "display/progress_bar"
require "display/receipt"
require "display/ui"

require "libraries/chat"
require "libraries/get_item"
require "libraries/get_player"
require "libraries/modify_strings"

require "mapping/npcs"
require "mapping/zones"

local RegisteredEventIDs = {}
local DefaultShoppingList = "main"
--local BlockGroceriesInjected = true

function OnLoad()
	table.insert(RegisteredEventIDs, windower.register_event('unload', OnUnload))
	table.insert(RegisteredEventIDs, windower.register_event('logout', OnLogout))
	table.insert(RegisteredEventIDs, windower.register_event('addon command', OnCommand))
	table.insert(RegisteredEventIDs, windower.register_event('incoming chunk', OnChunkIn))
	--table.insert(RegisteredEventIDs, windower.register_event('outgoing chunk', OnChunkOut))
	CreateResourceItemNamesAsKeys()
	LoadPlayerLists()
end

function OnUnload()
	InterruptBidding("Addon is being unloaded.")

	for _, ID in ipairs(RegisteredEventIDs) do
		windower.unregister_event(ID)
	end
end

function OnLogout()
	InterruptBidding("Player is logging out.")
end

function OnCommand(...)
	local CommandParameters = {...}

	if CommandParameters[1] == "get" then
		GoShopping(CommandParameters[2])

	elseif CommandParameters[1] == "stop" then
		InterruptBidding("Stop command has been received.")

	elseif CommandParameters[1] == "demo" then
		ToggleBidDemo()
	
	elseif CommandParameters[1] == "r" or CommandParameters[1] == "refresh" then
		ReloadPlayerLists()
	
	elseif CommandParameters[1] == "c" or CommandParameters[1] == "confirm" then
		if not GetBiddingInProgress() then
			DestroyUI()
		end

	elseif CommandParameters[1] == "h" or CommandParameters[1] == "hide" then
		HideUI()
	
	elseif CommandParameters[1] == "show" then
		ShowUI()

	elseif CommandParameters[1] == "help" then
		ShowHelp()
	end

	--elseif CommandParameters[1] == "block" then
	--	ToggleBlockGroceriesInjected()
	--end

end

function OnChunkIn(id, original, modified, injected, blocked)
		-- Zone change
		if id == 0x00B then
			InterruptBidding("A zone change has started.")
		
		-- Player status update
		elseif id == 0x037 then
			local PlayerUpdatePacket = WINDOWER_PACKETS.parse('incoming', original)
			local PlayerUpdateFlags2 = { original:unpack("q8", 44) }
			local PlayerDisconnecting = PlayerUpdateFlags2[3]

			if PlayerUpdatePacket["Status"] ~= 0 then
				InterruptBidding("Bids may only be made when player is idle.")
			elseif PlayerDisconnecting then
				InterruptBidding("Bids will not continue when FFXI indicates there are connection issues.")
			end
		
		-- Auction result
		elseif id == 0x04C then
			if GetBiddingInProgress() or GetBidResultWindowOpen() then
				ParseBidResult(id, original, modified, injected, blocked)
				UpdateUI()
			end
		end
end


--[[
function OnChunkOut(id, original, modified, injected, blocked)
	if id == 0x04E then
		if GetBlockGroceriesInjected() and injected then
			return true
		end
	end
end

function ToggleBlockGroceriesInjected()
	if BlockGroceriesInjected then
		BlockGroceriesInjected = false
		ChatWarning("Groceries will not block any packets.")
	else
		BlockGroceriesInjected = true
		ChatWarning("Groceries will block all outgoing Auction House (0x04E) packets that have been injected.")
	end
end

function GetBlockGroceriesInjected()
	return BlockGroceriesInjected
end
]]

function GoShopping(ShoppingList)
	if not GetBiddingInProgress() then
		HideUI()
		ShoppingList = ShoppingList or DefaultShoppingList
		ValidateListIntoQueue(ShoppingList)
		InitiateBidding()
	else
		ChatError("'gro get' command failed.", "Bidding is still in progress from a previous command.")
	end
end

function LoadPlayerLists(Reload)
	if PLAYER_LISTS or package.loaded["shopping_lists"] then
		PLAYER_LISTS = nil
		package.loaded["shopping_lists"] = nil
	end

	PLAYER_LISTS = require("shopping_lists")

	if Reload then
		ChatNotice("shopping_lists.lua have been reloaded and updated.")
	end
end

function ReloadPlayerLists()
	if not GetBiddingInProgress() then
		LoadPlayerLists(true)
	else
		ChatError("'gro refresh' command failed.", "Shopping lists may not be updated while bidding is in progress.")
	end
end

function ShowHelp()
	local HelpText = 
	{
		" ",
		" - - - Groceries Help - - - ",
		"Groceries supports the following in-game commands.",
		"gro get [listname] - Process the shopping list and send bids",
		"gro stop - Force the current bidding process to end",
		"gro r / refresh - Reload the shopping_lists.lua file",
		"gro c / confirm - Hide the UI when bidding has ended",
		"gro h / hide - Hide the UI when bidding has ended",
		"gro demo - Toggle the demo mode. Bids are not sent and results are random.",
		" ",
		"Please consult the README file for more detail on creating shopping lists ",
		"as well as how to customize your settings.",
		" "
	}

	for _, Text in ipairs(HelpText) do
		windower.add_to_chat(1, Text)
		coroutine.sleep(.02)
	end
end

OnLoad()