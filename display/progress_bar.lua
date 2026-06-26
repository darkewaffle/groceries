local ProgressBarWidth = PLAYER_SETTINGS.UI.ProgessBarWidth or 1010
local ProgressBarHeight = 22
local ProgressBarPaddingX = PLAYER_SETTINGS.UI.Padding or 6
local ProgressBarPaddingY = PLAYER_SETTINGS.UI.Padding or 6

local ProgressBarInner = "ProgBarInner"
local ProgressBarOuter = "ProgBarOuter"

local OuterX = 0
local OuterY = 0
local InnerX = 0
local InnerY = 0
local InnerHeight = 0
local InnerMaxWidth = 0

local BGAlpha, BGRed, BGGreen, BGBlue = GetBidLogBackground()

function SetProgressBarParameters()
	OuterX, OuterY = PLAYER_SETTINGS.UI.X, PLAYER_SETTINGS.UI.Y
	OuterY = OuterY - ProgressBarHeight

	InnerX = OuterX + ProgressBarPaddingX
	InnerY = OuterY + ProgressBarPaddingY
	InnerMaxWidth = ProgressBarWidth - (2 * ProgressBarPaddingX)
	InnerHeight = ProgressBarHeight - (2 * ProgressBarPaddingY)
end

function CreateProgressBar()
	SetProgressBarParameters()

	windower.prim.create(ProgressBarOuter)
	windower.prim.set_position(ProgressBarOuter, OuterX, OuterY)
	windower.prim.set_size(ProgressBarOuter, ProgressBarWidth, ProgressBarHeight)
	windower.prim.set_color(ProgressBarOuter, PLAYER_SETTINGS.UI.BGAlpha or 192, PLAYER_SETTINGS.UI.BGRed or 0, PLAYER_SETTINGS.UI.BGGreen or 0, PLAYER_SETTINGS.UI.BGBlue or 0)

	windower.prim.create(ProgressBarInner)
	windower.prim.set_position(ProgressBarInner, InnerX, InnerY)
	windower.prim.set_size(ProgressBarInner, InnerMaxWidth, InnerHeight)
	windower.prim.set_color(ProgressBarInner, PLAYER_SETTINGS.UI.BGAlpha or 192, 0, 237, 0)

	HideProgressBar()
end

function DestroyProgressBar()
	windower.prim.delete(ProgressBarOuter)
	windower.prim.delete(ProgressBarInner)
end

function ShowProgressBar()
	windower.prim.set_visibility(ProgressBarOuter, true)
	windower.prim.set_visibility(ProgressBarInner, true)
end

function HideProgressBar()
	windower.prim.set_visibility(ProgressBarOuter, false)
	windower.prim.set_visibility(ProgressBarInner, false)
end

function UpdateProgressBar()
	local PercentComplete = GetBiddingPercentComplete()
	local InnerWidth = math.floor(PercentComplete * InnerMaxWidth)
	windower.prim.set_size(ProgressBarInner, InnerWidth, InnerHeight)

	if PercentComplete == 1 then
		windower.prim.set_color(ProgressBarInner, BGAlpha, 119, 119, 237)
	end
end

function SetProgressBarError()
	windower.prim.set_color(ProgressBarInner, BGAlpha, 237, 0, 0)
end