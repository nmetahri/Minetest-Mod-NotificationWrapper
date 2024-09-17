# Notification System API for Minetest
___

## Description

This project provides a simple Notification System API for Minetest mods. The goal is to create a temporary window that appears on the player's screen, displaying a message. This API can be called by any other mod to display various notifications, allowing for easy integration into multiple gameplay elements.

For example, if a player levels up in another mod, that mod can use this API to display the message "You have leveled up!" with the desired theme defined by the notification system.

## Features

* Customizable Messages: Display any message on the screen.
* Optional Icons: You can include an icon with the notification.
* Duration Control: Set how long the notification will stay on the screen.
* Modular: Can be called by any other mod to display notifications.

## Usage

To use the notification system, instantiate the Notification class, provide the message, an optional icon, and the duration for which the notification should be displayed. Then, call the display() method to render the notification on the player's screen.

Example

```lua
local notif = Notification:add("You have leveled up!", "level_up_icon.png", 10)
notif:display()
```

## Integration with Other Mods

This API can be used by other mods to trigger notifications based on in-game events. For instance, if a player earns a new level in a leveling mod, the notification system can be used to show a congratulatory message on the screen.

```lua
local function on_player_level_up(player)
    local notif = Notification:new("Congratulations! You have reached level 5!", "level_up_icon.png", 10)
    notif:display()
end
```

## Installation 

* Copy the Lua script into your Minetest mod directory.
* Load the API by requiring the script in your mod.
* Use the provided methods to display notifications as needed.

