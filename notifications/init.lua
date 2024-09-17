local isDisplaying = false

local notifications = {}

local hudElements = {}

local pendingNotifications = {}

function notifications.create(playerName, text, image, timeout)
    if playerName == "" then
        return 
    end

    local notification = {
        playerName = playerName,
        text = text or "",
        image = image or "",
        timeout = timeout or 10
    }

    return notification
end

function notifications.show(notification)
    local player = minetest.get_player_by_name(notification.playerName)

    table.insert(hudElements, player:hud_add({
        hud_elem_type = "image",
        position = { x = 0.5, y = 0.5 },
        offset = { x = 0, y = 0 },
        text = notification.image,
        scale = { x = 1, y = 0.5 },
        alignment = { x = 0, y = 0 },
    }))

    table.insert(hudElements, player:hud_add({
        hud_elem_type = "text",
        position      = {x = 0.5, y = 0.5},
        offset        = {x = 0,   y = 0},
        text          = notification.text,
        alignment     = {x = 0, y = 0}, 
        scale         = {x = 100, y = 100},
        number    = 0xFFFFFF
    }))

    return minetest.after(notification.timeout, function()
        notifications.clear_hud_elements(notification.playerName)
        notifications.remove(notification)
        return true
    end)
end

function notifications.clear_hud_elements(playerName)
    local player = minetest.get_player_by_name(playerName)
    for _, v in ipairs(hudElements) do
        player:hud_remove(v)
    end
end

function notifications.remove(notification)
    for k, v in ipairs(notifications) do
        if notification == v then 
            table.remove(notification, k)
        end
    end
end

minetest.register_chatcommand("test", {
    func = function(name, param)
        local notification = notifications.create(name, "This is a test message !", "test_bg.jpg", 3)
        notifications.show(notification)
    end
})

minetest.log("Started mod: notifications")