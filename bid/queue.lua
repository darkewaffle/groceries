local BidQueue = {}
local PreviousBid = {["ID"]= 0, ["BidAmount"] = 0, ["Quantity"]=0}

local BiddingInProgress = false
local TerminateBidding = false
local BidDemo = PLAYER_SETTINGS.Bids.DefaultDemo == true
local BidDelay = 10
local BidDelayFuzz = 3
local BidResultWindowEnd = 0
local BidResultWindowDuration = 3

local ListPosition_Name = 1
local ListPosition_BidAmount = 2
local ListPosition_Quantity = 3
local ListPosition_MaxPurchased = 4

local MaximumBid = 99999999
local QueueItemsComplete = 0

function ValidateListIntoQueue(ListName)
	local ListTable = PLAYER_LISTS[ListName]
	local CurrentGil = GetPlayerGil()
	local ListLabel = ListName .. " >"

	if not ListTable or #ListTable == 0 then
		ChatError(ListLabel, "List is not found or is empty.")
		return
	end

	for Index, ItemData in ipairs(ListTable) do

		local ItemName = ItemData[ListPosition_Name]
		local BidAmount = ItemData[ListPosition_BidAmount]
		local ItemQuantity = ItemData[ListPosition_Quantity] or 1
		local MaxPurchased = ItemData[ListPosition_MaxPurchased] or 1

		if not ItemName or not BidAmount or type(BidAmount) ~= "number" then
			ChatError(ListLabel,"Record " .. Index .. " contains invalid name or bid amount.")
		else

			local ItemID = GetItemID(ItemName)
			local ValidID = ItemID and ItemID > 0
			local ValidAmount = BidAmount > 0 and BidAmount <= MaximumBid

			local PlayerMaxBid = PLAYER_SETTINGS.Bids.MaxBid or MaximumBid
			local AmountAllowedByPlayer = BidAmount <= PlayerMaxBid

			local CanAfford = CurrentGil >= BidAmount
			local ItemStackSize = GetItemStackSize(ItemID)
			local ValidQuantity = ItemQuantity == 1 or ItemQuantity == ItemStackSize
			local ItemRare = GetItemRare(ItemID)
			local ValidRare = not ItemRare or not GetPlayerHasItem(ItemID)

			if not ValidID then
				ChatError(ListLabel, ItemName .. " item ID lookup failed.")
			elseif not GetItemAuctionable(ItemID) then
				ChatError(ListLabel, ItemName .. " cannot be auctioned.")
			elseif not ValidAmount then
				ChatError(ListLabel, ItemName .. " bid amount is not valid: " .. BidAmount)
			elseif not CanAfford then
				ChatError(ListLabel, ItemName .. " bid amount is higher than current gil.")
			elseif not AmountAllowedByPlayer then
				ChatError(ListLabel, ItemName .. " bid amount is higher than MaxBid setting.")
			elseif not ValidQuantity then
				ChatError(ListLabel, ItemName .. " quantity is not valid: " .. ItemQuantity)
			elseif not ValidRare then
				ChatWarning(ListLabel, ItemName .. " is rare and you already possess it. Not added to queue.")
			else

				if ItemRare and MaxPurchased > 1 then
					MaxPurchased = 1
					ChatWarning(ListLabel, ItemName .. " is rare. Max purchased set to 1.")
				end

				for j = 1, MaxPurchased do
					table.insert(BidQueue, {["Name"]=ItemName, ["ID"]=ItemID, ["BidAmount"]=BidAmount, ["Quantity"]=ItemQuantity, ["StackSize"]=QuantityToStackSize(ItemQuantity)})
				end
			end
		end
	end
end

function InitiateBidding()
	if #BidQueue > 0 then
		ResetBidResults()
		ResetBidLog()
		CreateUI()
		SetBiddingInProgress()
		SendBids()
	else
		ChatError("'gro get' cannot proceed.", "No list items populated the bidding queue, please check the entries in your list.")
	end
end

function SendBids()
	local Interrupt = false

	for Index, BidData in ipairs(BidQueue) do
		if not GetPlayerCanBid() then
			Interrupt = true
			break
		end

		local ItemName = BidData["Name"]
		local ItemID = BidData["ID"]
		local BidAmount = BidData["BidAmount"]
		local Quantity = BidData["Quantity"]
		local StackSize = BidData["StackSize"]
		local ItemRare = GetItemRare(ItemID)

		local ChatLabel = ItemName .. " x" .. Quantity .. " for " .. BidAmount .. "g"
		local SleepAfterBid = false

		local CurrentGil = GetPlayerGil()
		if BidAmount > CurrentGil then
			BidLogError(ChatLabel .. " - Insufficient gil to bid.")
		elseif ItemRare and GetPlayerHasItem(ItemID) then
			BidLogNotice(ChatLabel .. " - Item is rare and player already possesses it.")
		elseif CurrentBidSameAsPreviousBid(ItemID, BidAmount, Quantity) and not GetPreviousBidSuccessful() then
			BidLogNotice(ChatLabel .. " - Previous identical bid was unsuccessful. Skipping bid.")
		else
			if BidDemo then
				BidLogMessage("DEMO " .. ChatLabel)

				local DemoPurchase = math.random(0,1) == 1
				RecordBidResult(ItemID, BidAmount, Quantity, DemoPurchase)
			else
				BidLogMessage(ChatLabel)
				InjectBidPacket(ItemID, BidAmount, StackSize)
			end

			SleepAfterBid = true
			PreviousBid = {["ID"]=ItemID, ["BidAmount"]=BidAmount, ["Quantity"]=Quantity}
		end

		QueueItemsComplete = QueueItemsComplete + 1
		UpdateUI()

		if Index == #BidQueue then
			-- Queue ended, skip the sleep.
		elseif SleepAfterBid then
			coroutine.sleep(BidDelay + math.random(0, BidDelayFuzz))
		end
	end

	if Interrupt then
		BidLogError("Bidding has ended due to an error.")
		SetProgressBarError()
	else
		BidLogComplete("Bidding has concluded.")
	end

	EndBidding()
end

function EndBidding()
	UpdateUI()
	SetBidResultWindow()
	BidQueue = {}
	PreviousBid = {}
	QueueItemsComplete = 0
	BiddingInProgress = false
	TerminateBidding = false
end

function CurrentBidSameAsPreviousBid(CurrentID, CurrentAmount, CurrentQuantity)
	if CurrentID == PreviousBid["ID"] and CurrentAmount == PreviousBid["BidAmount"] and CurrentQuantity == PreviousBid["Quantity"] then
		return true
	else
		return false
	end
end

function GetPreviousBidSuccessful()
	local BidResult = GetBidResult()

	if BidResult["Purchased"] and PreviousBid["ID"] == BidResult["ID"] and PreviousBid["BidAmount"] == BidResult["BidAmount"] and PreviousBid["Quantity"] == BidResult["Quantity"] then
		return true
	else
		return false
	end
end

function QuantityToStackSize(Quantity)
	-- Easier to think of Packet["Stack"] as "Stack size" rather than true/false.
	-- So 'stack size' == 1 == true to buy a single.
	-- And 'stack size' ~= 1 == false to buy a stack, however many that may be.

	if Quantity == 1 then
		return true
	elseif Quantity ~= 1 then
		return false
	end
end

function SetBiddingInProgress()
	BiddingInProgress = true
end

function GetBiddingInProgress()
	return BiddingInProgress
end

function InterruptBidding(Reason)
	if GetBiddingInProgress() and not GetBiddingInterrupted() then
		TerminateBidding = true
		BidLogError("Bidding has been interrupted. " .. Reason)
	end
end

function GetBiddingInterrupted()
	return TerminateBidding
end

function ToggleBidDemo()
	BidDemo = not BidDemo

	if BidDemo then
		ChatNotice("Demo mode enabled.", "List will be processed but bids will not be sent and fake results will be generated.")
	else
		ChatNotice("Demo mode disabled.", "Bids will be sent.")
	end
end

function GetBidDemo()
	return BidDemo
end

function GetBiddingPercentComplete()
	if #BidQueue > 0 then
		return QueueItemsComplete / #BidQueue
	else
		return 0
	end
end

function GetBidResultWindowOpen()
	if os.clock() <= BidResultWindowEnd then
		return true
	else
		return false
	end
end

function SetBidResultWindow()
	BidResultWindowEnd = os.clock() + BidResultWindowDuration
end

function PrintQueue()
	for Index, BidData in ipairs(BidQueue) do

-- table.insert(BidQueue, {["Name"]=ItemName, ["ID"]=ItemID, ["BidAmount"]=BidAmount, ["Quantity"]=ItemQuantity, ["StackSize"]=QuantityToStackSize(Quantity)})

		local ItemName = BidData["Name"]
		local ItemID = BidData["ID"]
		local BidAmount = BidData["BidAmount"]
		local Quantity = BidData["Quantity"]
		local StackSize = BidData["StackSize"]

		--[[
		local ItemRare = GetItemRare(ItemID)

			local ItemID = GetItemID(ItemName)
			local ValidID = ItemID and ItemID > 0
			local ValidAmount = BidAmount > 0 and BidAmount <= MaximumBid

			local PlayerMaxBid = PLAYER_SETTINGS.Bids.MaxBid or MaximumBid
			local AmountAllowedByPlayer = BidAmount <= PlayerMaxBid

			local CanAfford = CurrentGil >= BidAmount
			local ItemStackSize = GetItemStackSize(ItemID)
			local ValidQuantity = ItemQuantity == 1 or ItemQuantity == ItemStackSize
			local ItemRare = GetItemRare(ItemID)
			local ValidRare = not ItemRare or not GetPlayerHasItem(ItemID)
		]]

		print(ItemName, ItemID, BidAmount, Quantity, StackSize)

	end
end