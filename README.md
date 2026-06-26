# Groceries

[Example Groceries Bid UI](https://i.imgur.com/6MdNNVY.png)
[Example Shopping Lists]

## Summary
Groceries is designed to allow auction house users to define lists of items that they want to bid on repeatedly and then automatically bid on each item in a selected list. This could be useful for bidding on items needed in large quantities like currency or escutcheon spheres, obscure collections of items like Aeonic or Abyssea pop sets or just restocking your pantry with food, medicine and crystals.

## How To
1. Download groceries.lua, settings.lua, shopping_lists.lua and each folder. groceries.lua and the folders can be found in the zip file under [Releases](https://github.com/darkewaffle/groceries/releases). You only need to download the settings and shopping_lists file if you do not already have them, although the settings file could change over time if new settings are added.
2. Place them in Windower\addons\groceries.
3. Follow the instructions and examples in shopping_lists.lua to create your own shopping lists. 
4. Follow the instructions and examples in settings.lua to customize Groceries. You may want to leave them at their default settings until you've taken your shopping lists through a few demo runs.
5. Use a 'gro get [listname]' command and Groceries will try to bid on each item in your list.

## Commands
| Command | Usage |
| --- | --- |
| gro get [listname] | Process the shopping list and send bids. Listname is optional and Groceries will default to ShoppingLists.main. |
| gro stop | Force the current bidding process to end. |
| gro r / refresh | Reload the shopping_lists.lua file. This allows you to update your shopping lists without needing to reload Groceries entirely. |
| gro c / confirm | Hide the UI when bidding has ended. |
| gro h / hide | Hide the UI when bidding has ended. |
| gro demo | Toggle the demo mode. Bids are not sent and bid results are just determined randomly. It is recommended to first try using your shopping lists with demo mode to make sure the contents of your lists are valid and to get a feel for how to use Groceries. |

## Groceries' Flow Detailed
When you run a 'gro get' command there are a number of steps that take place before bidding actually begins as well as validation checks that occur before each individual bid. When Groceries detects that something is incorrect or should to be brought to your attention it will place a message in the Windower console or in your chat log. Typically the Windower console will report true errors whereas the chat log is usually used for 'just so you know' type of information.

First your shopping list will be evaluated item by item and turned into a bid queue. This process checks the data to ensure your item names are valid, the item can be placed on the auction house, you have enough gil, etc. Any item that does not pass each check will not be added to the queue and you should see a message explaining why.

Once your list has been processed and at least one bid has been added to the queue then the bidding can begin. However before every bid Groceries will perform another series of checks to ensure your character is able to place the bid. This includes the zone you are in, your proximity to an Auction House NPC, your status and whether or not your inventory is full. If any of those checks fail then the bidding process will be interrupted and no further bids will be sent. There are also a handful of other conditions that can interrupt bidding such as a zone change or logging out. Groceries will display a message if any of these checks fail or any interruption occurs and stop bidding entirely.

Assuming you are able to bid Groceries will then proceed to send bid packets. There is a 10 plus random 0-3 second delay between processing each item in the bid queue. Successful bids will cause the item to appear in your inventory momentarily and Groceries will monitor unsuccessful bids to skip repeating them.

Each bid, any bid-related messages and your bid results  will be displayed on screen in the 'Bid Log' and 'Bid Receipt'. Additionally atop the Bid Log there is progress bar that will indicate how much of the queue has been completed at any given time. 

## Caveat Emptor
Let the buyer beware. Groceries has been carefully put together to try to make sure only valid bids are submitted, bidding only takes place under the correct conditions and the injected bid packets are indistinguishable from game packets but it is still a third-party tool
sending Auction House packets. Please bid and behave responsibly.