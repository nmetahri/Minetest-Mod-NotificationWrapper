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

To use the notification system, you can use the `notifications.queue(playerName, text, image, timeout)` function, provide the message, an optional icon, and the duration for which the notification should be displayed. This will render a notification on the specified player's screen.

Example

```lua
notifications.queue("player_name", "This is a message !", "my_background.jpg", 10)
```

This function call will display a notification on the screen of the player naed `player_name` with the message `This is a test message !` and the background `my_background.jpg` for `10 seconds`.
Note that the `my_background.jpg` needs to be located in the `notifications/textures` folder.

## Integration with Other Mods

### How to display notifications from other mods ?
To use the notifications system in other mods, you will need to refer it as a dependency of your mod.
In your `depends.txt` file, just put the name of the mod : `notifications_wrapper`

Then, in your code, you can use the `notifications` table and call the appropriate methods.

### Basic example 
This API can be used by other mods to trigger notifications based on in-game events. For instance, if a player earns a new level in a leveling mod, the notification system can be used to show a congratulatory message on the screen.

```lua
local function on_player_level_up(player)
    if minetest.get_modpath("notifications_wrapper") then
        notifications.queue("player_name", "Congratulations! You have reached level 5!", "level_up_icon.png", 10)
    end
end
```

## Installation 

* Copy the Lua script into your Minetest mod directory.
* Load the API by requiring the script in your mod.
* Use the provided methods to display notifications as needed.

