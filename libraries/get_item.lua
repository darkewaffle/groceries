-- Creates a table of {["ItemName_en"]=ItemIndex, ["ItemName_enl"]=BuffIndex} useful for simple validation of ItemNames.

MAP_ITEM_NAMES = {}

function CreateResourceItemNamesAsKeys()
	for ItemIndex, ItemProperties in pairs(WINDOWER_RESOURCES.items) do
		MAP_ITEM_NAMES[string.lower(ItemProperties.en)] = ItemIndex
		MAP_ITEM_NAMES[string.lower(ItemProperties.enl)] = ItemIndex
	end
end

function GetItemID(ItemName)
	if type(ItemName) == "number" and WINDOWER_RESOURCES.items[ItemName] then
		return ItemName
	elseif type(ItemName) == "string" and MAP_ITEM_NAMES[string.lower(ItemName)] then
		return MAP_ITEM_NAMES[string.lower(ItemName)]
	else
		return nil
	end
end

function GetItemName(ItemID)
	if WINDOWER_RESOURCES.items[ItemID] then
		return WINDOWER_RESOURCES.items[ItemID].en
	else
		return nil
	end
end

function GetItemAuctionable(ItemID)
	local Item = WINDOWER_RESOURCES.items[ItemID]

	if Item and Item.flags then
		if Item.flags["Exclusive"] or Item.flags["No Auction"] then
			return false
		else
			return true
		end
	else
		return false
	end
end

function GetItemRare(ItemID)
	local Item = WINDOWER_RESOURCES.items[ItemID]

	if Item and Item.flags then
		if Item.flags["Rare"] then
			return true
		else
			return false
		end
	else
		return false
	end
end

function GetItemStackSize(ItemID)
	local Item = WINDOWER_RESOURCES.items[ItemID]

	if Item and Item.stack then
		return Item.stack
	else
		return nil
	end
end