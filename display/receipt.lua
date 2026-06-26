local ReceiptDisplay = 0
local ReceiptOffsetY = 22
local ReceiptOffsetX = (PLAYER_SETTINGS.UI.ProgessBarWidth or 1010) + 50
local ReceiptSettings = {}
ReceiptSettings.pos = {}
ReceiptSettings.bg = {}
ReceiptSettings.flags = {}
ReceiptSettings.text = {}
ReceiptSettings.text.fonts = {}
ReceiptSettings.text.stroke = {}

ReceiptSettings.pos.x = (PLAYER_SETTINGS.UI.X or 200) + ReceiptOffsetX
ReceiptSettings.pos.y = (PLAYER_SETTINGS.UI.Y or 200) - ReceiptOffsetY

ReceiptSettings.bg.alpha   = PLAYER_SETTINGS.UI.BGAlpha or 192
ReceiptSettings.bg.red     = PLAYER_SETTINGS.UI.BGRed or 0
ReceiptSettings.bg.green   = PLAYER_SETTINGS.UI.BGGreen or 0
ReceiptSettings.bg.blue    = PLAYER_SETTINGS.UI.BGBlue or 0
ReceiptSettings.bg.visible = true

ReceiptSettings.flags.right     = false
ReceiptSettings.flags.bottom    = false
ReceiptSettings.flags.bold      = false
ReceiptSettings.flags.draggable = true
ReceiptSettings.flags.italic    = false

ReceiptSettings.padding = PLAYER_SETTINGS.UI.Padding or 6

ReceiptSettings.text.size  = PLAYER_SETTINGS.UI.TextSize or 12
ReceiptSettings.text.font  = PLAYER_SETTINGS.UI.Font or "Consolas"
ReceiptSettings.text.alpha = 192
ReceiptSettings.text.red   = 255
ReceiptSettings.text.green = 255
ReceiptSettings.text.blue  = 255

ReceiptSettings.text.stroke.width = 0
ReceiptSettings.text.stroke.alpha = 255
ReceiptSettings.text.stroke.red   = 0
ReceiptSettings.text.stroke.green = 0
ReceiptSettings.text.stroke.blue  = 0

function CreateReceiptDisplay()
	ReceiptDisplay = WINDOWER_TEXTS.new("Default Receipt", ReceiptSettings)
	ReceiptDisplay:text(GetReceiptEmptyLine())

	HideReceiptDisplay()
end

function DestroyReceiptDisplay()
	ReceiptDisplay:destroy()
end

function ShowReceiptDisplay()
	ReceiptDisplay:visible(true)
end

function HideReceiptDisplay()
	ReceiptDisplay:visible(false)
end

function UpdateReceiptDisplay()
	local Content = GetReceiptText()
	ReceiptDisplay:text(GetReceiptText())
end