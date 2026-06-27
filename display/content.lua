local NameLength = 24
local QuantityLength = 3
local BidAmountLength = 11
local Buffer = " "
local BufferBetweenQtyAmt = 3

local BidLogCharacterWidth = 110
local BidLogEmptyLine = string.rep(" ", BidLogCharacterWidth)
-- +1 = the "x" added to the quantity display
local ReceiptCharacterWidth = NameLength + QuantityLength + 1 + BufferBetweenQtyAmt + BidAmountLength
local ReceiptEmptyLine = "- Bid Receipt -"
local EmptyPadding = string.rep(" ", math.floor(.5*(ReceiptCharacterWidth - #ReceiptEmptyLine)))
ReceiptEmptyLine = EmptyPadding .. ReceiptEmptyLine .. EmptyPadding

local ReceiptSpentHeader = "Total"

local Green = {0, 237, 0}
local GreenPale = {119, 237, 119}
local GreenLime = {102, 255, 7}
local Red = {237, 0, 0}
local RedPale = {237, 119, 119}
local Yellow = {237, 237, 0}
local BluePale = {119, 119, 237}

function GetReceiptText()
	local Results = GetAllBidResults()
	local ReceiptText = ReceiptEmptyLine .. "\n"
	local TotalSpent = 0

	if #Results > 0 then
		for i = 1, #Results do
			local Bid = Results[i]
			local Name = Bid["Name"] .. string.rep(Buffer, NameLength - #Bid["Name"])

			local Quantity = string.format("%" .. QuantityLength - 1 .. "s", "x" .. Bid["Quantity"]) 
			if #Quantity == 2 then
				Quantity = Buffer .. Quantity
			end
			Quantity = Quantity .. string.rep(Buffer, BufferBetweenQtyAmt)

			local BidAmount = NumberToStringWithCommas(Bid["BidAmount"]) .. "g"
			BidAmount = string.rep(Buffer, BidAmountLength - #BidAmount + 1) .. BidAmount

			local LineItem = Name .. Quantity .. BidAmount
			if i < #Results then
				LineItem = LineItem .. "\n"
			end

			if Bid["Purchased"] then
				LineItem = WrapPurchase(LineItem)
				TotalSpent = TotalSpent + Bid["BidAmount"]
			else
				LineItem = WrapNoPurchase(LineItem)
			end

			ReceiptText = ReceiptText .. LineItem

			if i == #Results then
				local SpentString = NumberToStringWithCommas(TotalSpent) .. "g"
				local SpentLine = "\n\n" .. ReceiptSpentHeader .. string.rep(Buffer, ReceiptCharacterWidth - #ReceiptSpentHeader - #SpentString) .. SpentString
				ReceiptText = ReceiptText .. SpentLine
			end
		end
	end

	return ReceiptText
end

function GetBidLogText()
	local BidLog = GetBidLog()
	local LogText = ""
	local MessageInstances = 1

	if #BidLog > 0 then

		for Index, Entry in ipairs(BidLog) do

			local LogLine = ""
			local IsDuplicate = false

			if BidLog[Index+1] and (Entry["Message"] == BidLog[Index+1]["Message"]) then
				MessageInstances = MessageInstances + 1
				IsDuplicate = true
			else

				LogLine = Entry["Time"] .. " - " .. Entry["Message"]

				if MessageInstances > 1 then
					LogLine = LogLine .. string.format(" (x%d)", MessageInstances)
					MessageInstances = 1
				end

				LogLine = LogLine .. string.rep(" ", BidLogCharacterWidth - #LogLine)

				if Entry["Class"] == "Notice" then
					LogLine = WrapNotice(LogLine)
				elseif Entry["Class"] == "Error" then
					LogLine = WrapError(LogLine)
				elseif Entry["Class"] == "Complete" then
					LogLine = WrapComplete(LogLine)
				end

			end

			if not IsDuplicate then
				LogLine = LogLine .. "\n"
				LogText = LogText .. LogLine
			end
		end

	else
		LogText = string.rep(" ", GetBidLogCharacterWidth())
	end

	return LogText
end

function GetBidLogCharacterWidth()
	return BidLogCharacterWidth
end

function GetReceiptCharacterWidth()
	return ReceiptCharacterWidth
end

function GetBidLogEmptyLine()
	return BidLogEmptyLine
end

function GetReceiptEmptyLine()
	return ReceiptEmptyLine
end

function WrapPurchase(Text)
	return ColorWrapForTexts(Text, GreenLime[1], GreenLime[2], GreenLime[3])
end

function WrapNoPurchase(Text)
	return ColorWrapForTexts(Text, RedPale[1], RedPale[2], RedPale[3])
end

function WrapError(Text)
	return ColorWrapForTexts(Text, Red[1], Red[2], Red[3])
end

function WrapNotice(Text)
	return ColorWrapForTexts(Text, Yellow[1], Yellow[2], Yellow[3])
end

function WrapComplete(Text)
	return ColorWrapForTexts(Text, BluePale[1], BluePale[2], BluePale[3])
end