local BidLog = {}

function WriteBidLog(Message, Class)
	local Timestamp = os.date("%X", os.time())
	table.insert(BidLog, {["Time"] = Timestamp, ["Message"] = Message, ["Class"] = Class})
end

function BidLogMessage(Message)
	WriteBidLog(Message)
end

function BidLogError(Message)
	WriteBidLog(Message, "Error")
end

function BidLogNotice(Message)
	WriteBidLog(Message, "Notice")
end

function BidLogComplete(Message)
	WriteBidLog(Message, "Complete")
end

function GetBidLog()
	return BidLog
end

function ResetBidLog()
	BidLog = {}
end