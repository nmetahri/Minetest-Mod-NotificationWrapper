notifications = {}
local active_notifications = {}
local hudElements = {}
local pending_notifications = {}

function notifications.create(playerName, title, text, image, timeout)
    if playerName == "" then
        return
    end

    local notification = {
        playerName = playerName,
        title = title or "Notification",
        text = text or "",
        image = image or "default-bg.jpg",
        timeout = timeout or 10
    }

    table.insert(active_notifications, notification)
    return notification
end

function notifications.does_image_exists(image_name)
    local complete_name = minetest.get_modpath("notifications_wrapper") .. '/textures/' .. image_name
    local image = io.open(complete_name)
    return image ~= nil
end

local function split_text_into_lines(text, max_length)
    local lines = {}
    for i = 1, #text, max_length do
        table.insert(lines, text:sub(i, i + max_length - 1))
    end
    return lines
end

function notifications.show(notification)
    local player = minetest.get_player_by_name(notification.playerName)
    if not player then return end

    hudElements[notification.playerName] = hudElements[notification.playerName] or {}

    table.insert(hudElements[notification.playerName], player:hud_add({
        hud_elem_type = "image",
        position = { x = 0.83, y = 0.1 },
        offset = { x = 0, y = 0 },
        text = notifications.does_image_exists(notification.image) and notification.image or "default_bg.png",
        scale = { x = 0.75, y = 0.75 },
        alignment = { x = 0, y = 0 },
    }))

    table.insert(hudElements[notification.playerName], player:hud_add({
        hud_elem_type = "text",
        position      = { x = 0.83, y = 0.06 }, 
        offset        = { x = 0, y = 0 },
        text          = notification.title,
        alignment     = { x = 0, y = 0 },
        scale         = { x = 100, y = 100 },
        number        = 0xFFFFFF
    }))

    table.insert(hudElements[notification.playerName], player:hud_add({
        hud_elem_type = "text",
        position      = { x = 0.83, y = 0.068 }, 
        offset        = { x = 0, y = 0 },
        text          = string.rep("-", #notification.title),
        alignment     = { x = 0, y = 0 },
        scale         = { x = 100, y = 100 },
        number        = 0xFFFFFF
    }))

    local lines = split_text_into_lines(notification.text, 75) 
    for i, line in ipairs(lines) do
        table.insert(hudElements[notification.playerName], player:hud_add({
            hud_elem_type = "text",
            position      = { x = 0.83, y = 0.085 + (i - 1) * 0.02 }, 
            offset        = { x = 0, y = 0 },
            text          = line,
            alignment     = { x = 0, y = 0 },
            scale         = { x = 100, y = 100 },
            number        = 0xFFFFFF
        }))
    end

    minetest.after(notification.timeout, function()
        notifications.clear_hud_elements(notification.playerName)
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

function notifications.queue(notification_params)
    local notification = notifications.create(notification_params.playerName, notification_params.title, notification_params.text, notification_params.image, notification_params.timeout)
    table.insert(pending_notifications, notification)
    notifications.process_queue(notification.playerName)
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
        notifications.queue(
            {
                playerName = name,
                title = "This is the title",
                text = param,
                image = "dfs.jpg",
                timeout = 10
            }
        )
    end
})

minetest.log("Mod 'notification_wrapper' démarré")
