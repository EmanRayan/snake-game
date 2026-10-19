-- events.lua -- Observer pattern
local Events = {}
local listeners = {}

function Events:subscribe(event, callback)
    listeners[event] = listeners[event] or {}
    table.insert(listeners[event], callback)
    return callback
end

function Events:unsubscribe(event, callback)
    local list = listeners[event]
    if not list then return end
    for i = #list, 1, -1 do
        if list[i] == callback then table.remove(list, i) end
    end
end

function Events:emit(event, data)
    local list = listeners[event]
    if not list then return end
    for _, callback in ipairs(list) do
        callback(data)
    end
end

return Events
