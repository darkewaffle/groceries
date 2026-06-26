function ColorWrapForTexts(StringToWrap, Red, Green, Blue)
	Red = Red or 255
	Green = Green or 255
	Blue = Blue or 255

	local ColorPrefix = "\\cs(" .. Red .. "," .. Green .. "," .. Blue .. ")"
	local ColorSuffix = "\\cr"
	return ColorPrefix .. StringToWrap .. ColorSuffix
end