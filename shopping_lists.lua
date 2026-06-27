-- Lists should take the form of Item Name, Bid Amount, Quantity, Max Purchased.
-- Item Name and Bid Amount are self explanatory however the Bid Amount can be numeric or a string with comma separators. 
-- Quantity represents if you are bidding on a single item or a stack.
-- Max Purchased represents how many times Groceries will try to successfully buy the item.
-- Quantity and Max Purchased are both optional, but if they are not present then they will
-- both default to 1. Zero is a valid Max Purchased amount if you want an item to remain in the list
-- but do not wish to make any bids on it currently.

-- Additionally please note that if you successfully purchase an item the Max Purchased amount in the list will not be altered by Groceries.
-- So if you want to purchase only 5 of an item and Groceries successfully purchases 2 then you may want to reduce the
-- Max Purchased amount for that item from 5 to 3 before you run that list again.

local ShoppingLists = {}


--  {"Item Name",             Bid Amount,      Quantity,    Max Purchased}
ShoppingLists.main =
{
	{"Grape Daifuku",              30000,             12,                2},
	{"Earth Crystal",               3000,             12,                5},
	{"Earth Cluster",             100000,             12,                0},
	{"Alexandrite",               200000,             99,                3},
	{"Dark Matter",               750000,              1,                2},
	{"Tiger King Hide",            50000,              1,                1},
	{"Hoxne Ampulla",        "25,000,000"}
}

ShoppingLists.fire =
{
	{"Fire Crystal",               5000,              12,               2},
	{"Fire Cluster",               5000,               1,               2},
}

return ShoppingLists