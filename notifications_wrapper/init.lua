notifications = {}
local active_notifications = {}
local hudElements = {}
local pending_notifications = {}

function notifications.create(playerName, text, image, timeout)
    if playerName == "" then
        return
    end

    local notification = {
        playerName = playerName,
        text = text or "",
        image = image or "default-bg.jpg",
        timeout = timeout or 10
    }

    table.insert(active_notifications, notification)
    return notification
end

function notifications.show(notification)
    local player = minetest.get_player_by_name(notification.playerName)
    if not player then return end

    hudElements[notification.playerName] = hudElements[notification.playerName] or {}

    table.insert(hudElements[notification.playerName], player:hud_add({
        hud_elem_type = "image",
        position = { x = 0.5, y = 0.5 },
        offset = { x = 0, y = -20 },
        text = notification.image,
        scale = { x = 1, y = 1 },
        alignment = { x = 0, y = 0 },
    }))

    table.insert(hudElements[notification.playerName], player:hud_add({
        hud_elem_type = "text",
        position      = { x = 0.5, y = 0.5 },
        offset        = { x = 0, y = 20 },
        text          = notification.text,
        alignment     = { x = 0, y = 0 },
        scale         = { x = 100, y = 100 },
        number        = 0xFFFFFF
    }))

    minetest.after(notification.timeout, function()
        notifications.clear_hud_elements(notification.playerName)
        notifications.remove(notification)
    end)
end

function notifications.clear_hud_elements(playerName)
    local player = minetest.get_player_by_name(playerName)
    if not player or not hudElements[playerName] then return end
    for _, hud_id in ipairs(hudElements[playerName]) do
        player:hud_remove(hud_id)
    end
    hudElements[playerName] = {}
    notifications.process_queue(playerName)
end

function notifications.remove(notification)
    for k, v in ipairs(active_notifications) do
        if notification == v then
            table.remove(active_notifications, k)
            break
        end
    end
end

function notifications.queue(playerName, text, image, timeout)
    local notification = notifications.create(playerName, text, image, timeout)
    table.insert(pending_notifications, notification)
    notifications.process_queue(playerName)
end

function notifications.process_queue(playerName)
    if hudElements[playerName] and #hudElements[playerName] > 0 then
        return
    end

    for i, notification in ipairs(pending_notifications) do
        if notification.playerName == playerName then
            table.remove(pending_notifications, i)
            notifications.show(notification)
            break
        end
    end
end

minetest.register_chatcommand("notify", {
    params = "<message>",
    description = "Teste une notification",
    func = function(name, param)
        notifications.queue(name, param, "test_bg.jpg", 5)
    end
})

minetest.log("Mod 'notification_wrapper' démarré")
