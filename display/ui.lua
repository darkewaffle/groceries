local UIActive = false
local UIVisible = false

function CreateUI()
	if not UIActive then
		UIActive = true
		CreateBidLogDisplay()
		CreateReceiptDisplay()
		CreateProgressBar()
	else
		DestroyUI()
		CreateUI()
	end
end

function DestroyUI()
	if UIActive then
		UIActive = false
		UIVisible = false
		DestroyBidLogDisplay()
		DestroyReceiptDisplay()
		DestroyProgressBar()
	end
end

function ShowUI()
	if UIActive then
		UIVisible = true
		ShowBidLogDisplay()
		ShowReceiptDisplay()
		ShowProgressBar()
	end
end

function HideUI()
	if UIActive then
		UIVisible = false
		HideBidLogDisplay()
		HideReceiptDisplay()
		HideProgressBar()
	end
end

function UpdateUI()
	if UIActive then
		UpdateBidLogDisplay()
		UpdateReceiptDisplay()
		UpdateProgressBar()
	end

	if not UIVisible then
		ShowUI()
	end
end