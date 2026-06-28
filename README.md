# Groceries

[Example Groceries Bid UI](https://i.imgur.com/VBA1e8k.png)

[Example Shopping Lists](https://github.com/darkewaffle/groceries/blob/main/shopping_lists.lua)

## Summary
Groceries is designed to allow auction house users to define lists of items that they want to bid on repeatedly and then automatically bid on each item in a selected list. This could be useful for bidding on items needed in large quantities like currency or escutcheon spheres, obscure collections of items like Aeonic or Abyssea pop sets or just restocking your food, medicine and crystals.

## How To
1. Download groceries.lua, settings.lua, shopping_lists.lua and each folder. groceries.lua and the folders can be found in the zip file under [Releases](https://github.com/darkewaffle/groceries/releases). You only need to download the settings and shopping_lists files if you do not already have them, although the settings file could change over time if new settings are implemented.
2. Place them in Windower\addons\groceries.
3. Follow the instructions and examples in shopping_lists.lua to create your own shopping lists. 
4. Follow the instructions and examples in settings.lua to customize Groceries. You may want to leave them at their default settings until you've taken your shopping lists through a few demo runs.
5. Enter a zone that contains an Auction House and then stand closer than 4 yalms to an Auction Counter or Auction NPC.
6. Use the 'gro get [listname]' command and Groceries will try to bid on each item in your list.

## Commands
| Command | Usage |
| --- | --- |
| gro get [listname] | Process the shopping list and send bids. Listname is optional and if omitted Groceries will default to ShoppingLists.main. |
| gro stop | Force the current bidding process to end. |
| gro r / refresh | Reload the shopping_lists.lua file. This allows you to update your shopping lists without needing to reload Groceries entirely. |
| gro c / confirm | Hide the UI when bidding has ended. It will be deleted and cannot be shown again. |
| gro h / hide | Hide the UI when bidding has ended. It can be shown again. |
| gro show | Show the UI if it has been hidden. |
| gro demo | Toggle the demo mode. In demo mode bids are not sent and bid results are just determined randomly. It is recommended to first try using your shopping lists with demo mode to make sure the contents of your lists are valid and to get a feel for how to use Groceries. |

## Groceries' Flow Detailed
When you run a 'gro get' command there are a number of steps that take place before bidding actually begins. In addition there are validation checks that will occur before each individual bid. Anytime Groceries detects that something is incorrect or should be brought to your attention it will place a message in the Windower console or in your chat log. Typically the Windower console will report true errors whereas the chat log is usually used for 'just so you know' type of information.

First your shopping list will be evaluated item by item and turned into a bid queue. This process checks the data to ensure your item names are valid, the item can be placed on the auction house, you have enough gil, etc. Any item that does not pass each check will not be added to the queue and you should see a message explaining why.

Once your list has been processed and at least one bid has been added to the queue then the bidding can begin. However before every bid Groceries will perform another series of checks to ensure your character is able to place the bid. This includes the zone you are in, your proximity to an Auction House NPC, your status and whether or not your inventory is full. If any of those checks fail then the bidding process will be interrupted and no further bids will be sent. There are also a handful of other conditions that can interrupt bidding such as a zone change or logging out. Groceries will display a message if any of these checks fail or if any interruptions occur and stop the bidding process completely.

Assuming you are able to bid Groceries will then proceed to send bid packets. There is a 10 plus random 0-5 second delay between processing each item in the bid queue. Successful bids will cause the item to appear in your inventory shortly after the bid is sent and Groceries will monitor unsuccessful bids to skip repeating them.

Each bid that is placed, any bid-related messages and your bid results will be displayed on screen in the 'Bid Log' and 'Bid Receipt'. Additionally on top of the Bid Log there is progress bar that will indicate how much of the queue has been completed at any given time. The progress bar will be green while bidding is in progress and it will become blue when all bids have been completed. If an error or interruption is encountered the bar will turn red and bidding will not continue.

## Best Practices
Before attempting to place any real bids you should first create a shopping list of your own and try to 'gro get' it with demo mode enabled. This will go through the process of testing and validating your list. Please pay attention to any messages and resolve them if necessary. Once your list has been successfully read and loaded into a bid queue then demo mode will simulate sending bids and receiving results - but no packets will be sent yet. Using demo mode you can get a feel for how long bidding takes, what the UI means and what can cause bidding to be interrupted. 

Once that all makes sense to you then you can change the EnableBidding setting so that you can actually start to send bids and buy items. You will need to reload the entire Groceries addon for setting changes to take effect.

When placing real bids the best way to use Groceries is probably to move your character close to an Auction House, make sure you have sufficient gil and inventory space, run the get command and then go get a snack. You should not manipulate your inventory, place any Auction House bids by hand, trade, move around or generally do anything that you can't normally do while using the Auction House. Groceries tries to look like regular Auction House behavior and that's likely the safest way to use it.

## Caveat Emptor
Let the buyer beware. Groceries has been carefully put together to try to make sure only valid bids are submitted, bidding only takes place under the correct conditions and the injected bid packets are indistinguishable from game packets but it is still a third-party tool sending Auction House packets. Please bid and behave responsibly.