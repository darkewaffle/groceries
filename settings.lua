local Settings = {}
Settings.UI = {}
Settings.Bids = {}

-- All changes to settings will only be applied when the addon is (re)loaded.

-- Controls the starting point for UI. X increases from left to right, Y increases from top to bottom.
Settings.UI.X = 200
Settings.UI.Y = 200

Settings.UI.TextSize = 12
Settings.UI.Font = "Consolas"

-- You may wish to increase or decrease this depending on your TextSize or Font setting
Settings.UI.ProgessBarWidth = 1010

-- Controls the UI background
Settings.UI.BGAlpha = 192
Settings.UI.BGRed = 0
Settings.UI.BGGreen = 0
Settings.UI.BGBlue = 0

Settings.UI.Padding = 6


-- This controls the maximum amount you can bid. Any bid amounts found in a shopping list that are greater than MaxBid will not be added to the bid queue.
-- This can be formatted as a number or a string. This is simply a safety measure in case of typos.
-- If your MaxBid setting is "1,000,000" and you want to bid 200000 on an item but accidentally type 2000000 then the bid will not be submitted.
Settings.Bids.MaxBid = "1,000,000"

-- Controls if Groceries defaults to demo mode. In demo mode bids are not sent to the server and bid results are randomly generated.
-- This can be useful for testing how Groceries works, what your UI looks like and the conditions that will interrupt bidding.
-- Demo mode can also be toggled on and off with a 'gro demo' command.
Settings.Bids.DefaultDemo = true

-- Groceries will not send any bid packets to the server unless EnableBidding = true. You must change this yourself and then reload the addon to send real bids.
-- Groceries has been carefully put together to try to make sure only valid bids are submitted, bidding only takes place under
-- the correct conditions and the injected bid packets are indistinguishable from game packets but it is still a third-party tool
-- sending Auction House packets. Please bid and behave responsibly.
Settings.Bids.EnableBidding = false


return Settings