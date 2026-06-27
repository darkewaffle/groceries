function ColorWrapForTexts(StringToWrap, Red, Green, Blue)
	Red = Red or 255
	Green = Green or 255
	Blue = Blue or 255

	local ColorPrefix = "\\cs(" .. Red .. "," .. Green .. "," .. Blue .. ")"
	local ColorSuffix = "\\cr"
	return ColorPrefix .. StringToWrap .. ColorSuffix
end

function NumberToStringWithCommas(Input, Output)
	if type(Input) ~= "string" then
		Input = tostring(Input)
	end

	if not Output then
		Output = ""
	end

	if #Input >= 4 then
		local Head = string.sub(Input, 1, #Input - 3)
		local Tail = string.sub(Input, #Input - 2, #Input)

		Output = "," .. Tail .. Output
		Output = NumberToStringWithCommas(Head, Output)
	else
		Output = Input .. Output
	end

	return Output
end