function InjectBidPacket(ItemID, BidAmount, StackSize)
	--packets.new(direction, id, data, args)
	--args passes through the packets library from .new > .fields > packets.raw_fields > .parse
	--this defines how the packet is structured when there are known to be multiple types/purposes within a packet ID

	local BidPacket = WINDOWER_PACKETS.new('outgoing', 0x04E,
	{
	["Type"] = 0x0E,
	["Slot"] = 7,
	["Price"] = BidAmount,
	["Item"] = ItemID,
	["Stack"] = StackSize,
	["_junk"] = string.char(0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0)
	}, 0x0E)

	if PLAYER_SETTINGS.Bids.EnableBidding == true then
		--WINDOWER_PACKETS.inject(BidPacket)
		print("we bidding")
	end
end