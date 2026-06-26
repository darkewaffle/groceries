local BidLogDisplay = 0
local BidLogSettings = {}
BidLogSettings.pos = {}
BidLogSettings.bg = {}
BidLogSettings.flags = {}
BidLogSettings.text = {}
BidLogSettings.text.fonts = {}
BidLogSettings.text.stroke = {}

BidLogSettings.pos.x = PLAYER_SETTINGS.UI.X or 200
BidLogSettings.pos.y = PLAYER_SETTINGS.UI.Y or 200

BidLogSettings.bg.alpha   = PLAYER_SETTINGS.UI.BGAlpha or 192
BidLogSettings.bg.red     = PLAYER_SETTINGS.UI.BGRed or 0
BidLogSettings.bg.green   = PLAYER_SETTINGS.UI.BGGreen or 0
BidLogSettings.bg.blue    = PLAYER_SETTINGS.UI.BGBlue or 0
BidLogSettings.bg.visible = true

BidLogSettings.flags.right     = false
BidLogSettings.flags.bottom    = false
BidLogSettings.flags.bold      = false
BidLogSettings.flags.draggable = true
BidLogSettings.flags.italic    = false

BidLogSettings.padding = PLAYER_SETTINGS.UI.Padding or 6

BidLogSettings.text.size  = PLAYER_SETTINGS.UI.TextSize or 12
BidLogSettings.text.font  = PLAYER_SETTINGS.UI.Font or "Consolas"
BidLogSettings.text.alpha = 192
BidLogSettings.text.red   = 255
BidLogSettings.text.green = 255
BidLogSettings.text.blue  = 255

BidLogSettings.text.stroke.width = 0
BidLogSettings.text.stroke.alpha = 255
BidLogSettings.text.stroke.red   = 0
BidLogSettings.text.stroke.green = 0
BidLogSettings.text.stroke.blue  = 0

function CreateBidLogDisplay()
	BidLogDisplay = WINDOWER_TEXTS.new("Default Log", BidLogSettings)
	BidLogDisplay:text(GetBidLogEmptyLine())
	HideBidLogDisplay()
end

function DestroyBidLogDisplay()
	BidLogDisplay:destroy()
end

function ShowBidLogDisplay()
	BidLogDisplay:visible(true)
end

function HideBidLogDisplay()
	BidLogDisplay:visible(false)
end

function UpdateBidLogDisplay()
	BidLogDisplay:text(GetBidLogText())
end

function GetBidLogBackground()
	return BidLogSettings.bg.alpha, BidLogSettings.bg.red, BidLogSettings.bg.green, BidLogSettings.bg.blue
end