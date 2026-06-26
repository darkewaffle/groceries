-- Lists should take the form of Item Name, Bid Amount, Quantity, Max Purchased.
-- Item Name and Bid Amount are self explanatory. Quantity represents if you are bidding on
-- a single item or a stack. Max Purchased represents how many times Groceries will try to 
-- successfully buy the item.
-- Quantity and Max Purchased are both optional, but if they are not present then they will
-- both default to 1. Zero is a valid Max Purchased amount if you want an item to remain in the list
-- but do not wish to make any bids on it currently.


local ShoppingLists = {}


--  {"Item Name",             Bid Amount,      Quantity,    Max Purchased}
ShoppingLists.main =
{
	{"Grape Daifuku",              30000,             12,                2},
	{"Earth Crystal",               3000,             12,                5},
	{"Earth Cluster",             100000,             12,                1},
	{"Alexandrite",               200000,             99,                3},
	{"Dark Matter",               750000,              1,                2},
	{"Tiger King Hide",            50000,              1,                1}
}

ShoppingLists.fire =
{
	{"Fire Crystal",               5000,              12,               2},
	{"Fire Cluster",               5000,               1,               2},
}

return ShoppingLists