local BidResult = {["ID"]= 0, ["BidAmount"] = 0, ["Quantity"] = 0, ["Purchased"]=false}
local AllBidResults = {}

function ParseBidResult(id, original, modified, injected, blocked)
	local BidResultPacket = WINDOWER_PACKETS.parse('incoming', original)
	local Type = BidResultPacket["Type"]
	local BuyStatus = BidResultPacket["Buy Status"]

	if Type == 14 and (BuyStatus == 1 or BuyStatus == 197) then

		local Purchased = BuyStatus == 1
		local BidAmount = BidResultPacket["Price"]
		local ItemID = BidResultPacket["Item ID"]
		local Quantity = BidResultPacket["Count"]

		RecordBidResult(ItemID, BidAmount, Quantity, Purchased)
	end
end

function RecordBidResult(ItemID, BidAmount, Quantity, Purchased)
	BidResult["ID"] = ItemID
	BidResult["BidAmount"] = BidAmount
	BidResult["Quantity"] = Quantity
	BidResult["Purchased"] = Purchased

	table.insert(AllBidResults, {["Name"]=GetItemName(ItemID), ["ID"]=ItemID, ["BidAmount"]=BidAmount, ["Quantity"]=Quantity, ["Purchased"]=Purchased})
end

function GetBidResult()
	return BidResult
end

function GetAllBidResults()
	return AllBidResults
end

function ResetBidResults()
	BidResult = {}
	AllBidResults = {}
end