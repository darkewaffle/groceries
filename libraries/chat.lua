local ChatBlue = 1
local ChatGreen = 204
local ChatGrey = 161
local ChatPurple = 209
local ChatRed = 39
local ChatWhite = 1
local ChatYellow = 36

function Chat(Prefix, Label, Message, Color)
	Prefix = tostring(Prefix)
	if Prefix ~= "nil" then
		Prefix = Prefix .. ": "
	else
		Prefix = ""
	end

	Label = tostring(Label)
	if Label ~= "nil" then
		Label = Label .. " "
	else
		Label = ""
	end

	Message = tostring(Message)
	if Message ~= "nil" then
		Message = Message
	else
		Message = ""
	end

	Color = Color or 1
	windower.add_to_chat(Color, Prefix .. Label .. Message)
end

function ChatDebug(Label, Message)
	Chat("DEBUG", Label, Message, ChatGrey)
end

function ChatBlankLine()
	windower.add_to_chat(1, " ")
end

function ChatDashLine()
	local Line = string.rep(" -", 80)
	windower.add_to_chat(1, Line)
end

function ChatError(Label, Message)
	if Message then
		Message = tostring(Message)
	else
		Message = ""
	end

	print("ERROR " .. tostring(Label) .. " " .. tostring(Message))
end

function ChatNotice(Label, Message)
	Chat("Notice", Label, Message, ChatGreen)
end

function ChatWarning(Label, Message)
	Chat("WARNING", Label, Message, ChatYellow)
end

function ChatMessage(Label, Message)
	Chat(nil, Label, Message, ChatWhite)
end