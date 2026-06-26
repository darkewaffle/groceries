function GetPlayerGil()
	return windower.ffxi.get_items().gil
end

function GetPlayerStatus()
	return windower.ffxi.get_player().status
end

function GetPlayerZone()
	return windower.ffxi.get_info().zone
end

function GetPlayerZoneCanBid()
	return GetZoneHasAuctionHouse(GetPlayerZone())
end

function GetPlayerLocationCanBid()
	local CanBid = false

	local MobArray = windower.ffxi.get_mob_array()
	for Index, MobData in pairs(MobArray) do
		if AUCTION_NPCS[MobData.name] and math.sqrt(MobData.distance) < 4 then
			CanBid = true
			break
		end
	end

	if CanBid then
		return true
	else
		return false
	end
end

function GetPlayerStatusCanBid()
	if GetPlayerStatus() ~= 0 then
		return false
	else
		return true
	end
end

function GetPlayerInventoryFull()
	local InventoryInfo = windower.ffxi.get_bag_info(0)
	local InventoryOpenSlots = InventoryInfo.max - InventoryInfo.count
	return InventoryOpenSlots == 0
end

function GetPlayerCanBid()
	if GetBiddingInterrupted() then
		return false

	elseif not GetPlayerZoneCanBid() then
		BidLogError("This zone has no auction house.")
		return false

	elseif not GetPlayerLocationCanBid() then
		BidLogError("You are not close enough to an auction NPC.")
		return false

	elseif not GetPlayerStatusCanBid() then
		BidLogError("Bids may only be made when player is idle.")
		return false

	elseif GetPlayerInventoryFull() then
		BidLogError("Inventory is full.")
		return false
	end

	return true
end

local BagToIndexMap =
	{
		["inventory"]=0,
		["safe"]=1,
		["storage"]=2,
		["locker"]=4,
		["satchel"]=5,
		["sack"]=6,
		["case"]=7,
		["wardrobe"]=8, ["wardrobe1"]=8,
		["safe2"]=9,
		["wardrobe2"]=10,
		["wardrobe3"]=11,
		["wardrobe4"]=12,
		["wardrobe5"]=13,
		["wardrobe6"]=14,
		["wardrobe7"]=15,
		["wardrobe8"]=16
	}

function GetPlayerHasItem(ItemID)
	local HasItem = false
	local PlayerBags = windower.ffxi.get_bag_info()
	local PopulatedBags = {}
	ItemID = tonumber(ItemID)

	for BagName, BagData in pairs(PlayerBags) do
		if BagData.count > 0 then
			table.insert(PopulatedBags, BagToIndexMap[BagName])
		end
	end

	for _, BagIndex in ipairs(PopulatedBags) do

		local BagContents = windower.ffxi.get_items(BagIndex)
		for ItemIndex, ItemData in ipairs(BagContents) do	
			if ItemID == ItemData.id then
				HasItem = true
				break
			end
		end

		if HasItem then
			break
		end
	end

	return HasItem
end