local recipes = require("prototypes.crafting-templates")
local specialItems = {
    "ms-memory-module-t1",
    "ms-memory-module-t2",
    "ms-memory-module-t3",
    "ms-uncrafting-card",
    "ms-void-card",
    "ms-material-crystal-charged",
    "ms-material-chest-solar-panel"
}

local function initStorage ()
    if global.capacity == nil then
        global.capacity = 4096
    end
    if global.antiCapacity == nil then
        global.antiCapacity = 0
    end
    if global.energy == nil then
        global.energy = 10000
    end
    if global.storage == nil then
        global.storage = {}
    end
    if global.combinators == nil then
        global.combinators = {}
    end
end

local function type(itemId) -- todo: this must be moved into common utils
    if itemId == "water" then
        return "fluid"
    end
    if itemId == "crude-oil" then
        return "fluid"
    end
    if itemId == "heavy-oil" then
        return "fluid"
    end
    if itemId == "light-oil" then
        return "fluid"
    end
    if itemId == "lubricant" then
        return "fluid"
    end
    if itemId == "petroleum-gas" then
        return "fluid"
    end
    if itemId == "sulfuric-acid" then
        return "fluid"
    end
    return "item"
end

local function setSignals (combinator)
    local control = combinator.get_control_behavior()
    local signals = {}
    table.insert(signals, {count = global.capacity, index = 1, signal = {name = "signal-C", type = "virtual"}})
    table.insert(signals, {count = global.energy, index = 2, signal = {name = "signal-E", type = "virtual"}})
    table.insert(signals, {count = global.antiCapacity, index = 3, signal = {name = "signal-S", type = "virtual"}})
    table.insert(signals, {count = 100 - (global.antiCapacity / global.capacity * 100), index = 4, signal = {name = "signal-P", type = "virtual"}})
    local index = 5
    for name, count in pairs(global.storage) do
        table.insert(signals, {count = count, index = index, signal = {name = name, type = type(name)}})
        index = index + 1
    end
    control.parameters = signals
end

local function updateCombinators ()
    for _, combinator in pairs(global.combinators) do
        setSignals(combinator)
    end
end

local function addCombinator (entity)
    if entity then
        if entity.valid then
            if entity.name == "ms-material-combinator" then
                table.insert(global.combinators, entity)
            end
        end
    end
end

script.on_event(defines.events.on_built_entity, function(event) addCombinator(event.created_entity) end)
script.on_event(defines.events.on_robot_built_entity, function(event) addCombinator(event.created_entity) end)
script.on_event(defines.events.on_entity_cloned, function(event) addCombinator(event.destination) end)

script.on_event({defines.events.on_entity_died, defines.events.on_player_mined_entity, defines.events.on_robot_mined_entity}, function(event)
    if event.entity then
        if event.entity.valid then
            if event.entity.name == "ms-material-combinator" then
                for counter = 1, #global.combinators do
                    if global.combinators[counter] == event.entity then
                        table.remove(global.combinators, counter)
                        return
                    end
                end
            end
        end
    end
end)

local function updateLabel (player)
    if player.gui.top.storage == nil then
        local label = player.gui.top.add({type = "label", name = "storage", caption = ""})
        label.style.font = "default-bold"
        label.style.left_margin = 16
        label.style.right_margin = 16
        label.style.top_margin = 16
        label.style.bottom_margin = 16
    end
    player.gui.top.storage.caption = "STORAGE: " .. global.antiCapacity .. " / " .. global.capacity .. ", ENERGY: " .. global.energy
end

local function canStore (itemId)
    if recipes[itemId] ~= nil then
        return false
    end
    for _, specialId in pairs(specialItems) do
        if specialId == itemId then
            return false
        end
    end
    return true
end

local function initItem (itemId)
    if global.storage[itemId] == nil then
        global.storage[itemId] = 0
    end
end

local function totalCount ()
    local total = 0
    for _, count in pairs(global.storage) do
        total = total + count
    end
    return total
end

local digitalFluids = {
    ["ms-digital-heavy-oil"] = "heavy-oil",
    ["ms-digital-light-oil"] = "light-oil",
    ["ms-digital-lubricant"] = "lubricant",
    ["ms-digital-petroleum-gas"] = "petroleum-gas",
    ["ms-digital-sulfuric-acid"] = "sulfuric-acid",
    ["ms-digital-water"] = "water"
}

local function putFluid (inventory, itemId)
    if global.capacity - global.antiCapacity >= 1024 then
        initItem(digitalFluids[itemId])
        -- only put 1024 fluid if there is less than 1024 fluid already. That means only 2048 each fluid max cen be stored
        if global.storage[digitalFluids[itemId]] <= 1024 then
            global.storage[digitalFluids[itemId]] = global.storage[digitalFluids[itemId]] + 1024
            global.antiCapacity = global.antiCapacity + 1024
            inventory.remove({name = itemId, count = 1})
        end
    end
end

local function putItem (inventory, itemId, amount)
    if digitalFluids[itemId] ~= nil then
        -- processing one at the time
        putFluid(inventory, itemId)
        return
    end
    local freeSpace = global.capacity - global.antiCapacity
    local desiredAmount = amount
    if freeSpace < desiredAmount then
        desiredAmount = freeSpace
    end
    if desiredAmount > 0 then
        initItem(itemId)
        global.storage[itemId] = global.storage[itemId] + desiredAmount
        global.antiCapacity = global.antiCapacity + desiredAmount
        inventory.remove({name = itemId, count = desiredAmount})
    end
end

local function getItem (inventory, itemId, amount)
    local desiredAmount = amount
    initItem(itemId)
    if global.storage[itemId] < desiredAmount then
        desiredAmount = global.storage[itemId]
    end
    if desiredAmount > 0 then
        global.storage[itemId] = global.storage[itemId] - desiredAmount
        global.antiCapacity = global.antiCapacity - desiredAmount
        inventory.insert({name = itemId, count = desiredAmount})
    end
end

local function available (itemId, count)
    return global.storage[itemId] ~= nil and global.storage[itemId] >= count
end

local function craft (cardId)
    local recipe = recipes[cardId]
    local energyUse = 1
    for itemId, count in pairs(recipe.inputs) do
        energyUse = energyUse + count
        if not available(itemId, count) then
            return
        end
    end
    for itemId, count in pairs(recipe.inputs) do
        global.storage[itemId] = global.storage[itemId] - count
        global.antiCapacity = global.antiCapacity - count
    end
    initItem(recipe.result)
    global.storage[recipe.result] = global.storage[recipe.result] + recipe.amount
    global.antiCapacity = global.antiCapacity + recipe.amount
    global.energy = global.energy - energyUse
end

local function unCraft (cardId)
    local recipe = recipes[cardId]
    if not available(recipe.result, recipe.amount) then
        return -- quit if nothing to uncraft
    end
    local storageRequire = 0
    for _, count in pairs(recipe.inputs) do
        storageRequire = storageRequire + count
    end
    if storageRequire <= global.antiCapacity and storageRequire <= global.energy then
        for itemId, count in pairs(recipe.inputs) do
            initItem(itemId)
            global.storage[itemId] = global.storage[itemId] + count
        end
        global.energy = global.energy - (storageRequire * 4)
        global.storage[recipe.result] = global.storage[recipe.result] - recipe.amount
        global.antiCapacity = global.antiCapacity + recipe.amount - storageRequire
    end
end

local function putAll (inventory)
    for itemId, amount in pairs(inventory.get_contents()) do
        if canStore(itemId) then
            putItem(inventory, itemId, amount)
        end
    end
end

local function refillAll (inventory, plan)
    for itemId, planned in pairs(plan) do
        local needed = planned - inventory.get_item_count(itemId)
        if needed > 0 then
            getItem(inventory, itemId, needed)
        end
    end
end

local function createPlan (inventory)
    local plan = {}
    for index = 1, 150 do
        local filter = inventory.get_filter(index)
        if filter ~= nil then
            if plan[filter] == nil then
                plan[filter] = game.item_prototypes[filter].stack_size
            else
                plan[filter] = plan[filter] + game.item_prototypes[filter].stack_size
            end
        end
    end
    return plan
end

local function processCrafts (inventory, plan)
    local uncraftFlag = inventory.get_item_count("ms-uncrafting-card") > 0
    for cardId, amount in pairs(inventory.get_contents()) do
        if recipes[cardId] ~= nil and plan[recipes[cardId].result] ~= nil then
            for _ = 1, amount do
                if global.energy > 0 then
                    if uncraftFlag then
                        unCraft(cardId)
                    else
                        if not available(recipes[cardId].result, plan[recipes[cardId].result]) then
                            craft(cardId)
                        end
                    end
                end
            end
        end
    end
end

script.on_nth_tick(600, function()
    initStorage()
    local player = game.get_player(1)
    local inventory = player.force.get_linked_inventory("ms-material-storage", 0)
    local capacity = 4096
    for itemId, count in pairs(inventory.get_contents()) do
        if itemId == "ms-memory-module-t1" then
            capacity = capacity + (count * 4096)
        end
        if itemId == "ms-memory-module-t2" then
            capacity = capacity + (count * 16384)
        end
        if itemId == "ms-memory-module-t3" then
            capacity = capacity + (count * 65536)
        end
    end
    global.capacity = capacity
    global.antiCapacity = totalCount()
end)

script.on_nth_tick(60, function()
    initStorage()
    local player = game.get_player(1)
    local inventory = player.force.get_linked_inventory("ms-material-storage", 0)
    global.energy = global.energy + inventory.get_item_count("ms-material-chest-solar-panel")
    if global.energy > 10000 then
        global.energy = 10000
    end
    if global.energy <= 9000 then
        if inventory.get_item_count("ms-material-crystal-charged") > 0 then
            global.energy = global.energy + 1000
            inventory.remove({name = "ms-material-crystal-charged", count = 1})
        end
    end
    putAll(inventory)
    local plan = createPlan(inventory)
    processCrafts(inventory, plan)
    refillAll(inventory, plan)
    if global.energy < 0 then
        global.energy = 0
    end
    updateCombinators()
    updateLabel(player)
end)

script.on_event(defines.events.on_console_chat, function(event)
    local player = game.get_player(1)
    if event.message == "!storage" then
        for itemId, amount in pairs(global.storage) do
            if amount > 0 then
                player.print(itemId .. ": " .. amount)
            end
        end
        return
    end
    if event.message == "!give" then
        local inventory = player.force.get_linked_inventory("ms-material-storage", 0)
        for index = 1, 150 do
            local filter = inventory.get_filter(index)
            if filter ~= nil then
                local stackSize = game.item_prototypes[filter].stack_size
                initItem(filter)
                local required = stackSize - global.storage[filter]
                if required > 0 then
                    putItem(inventory, filter, required)
                    player.print("Cheat applied. Given " .. required .. " " .. filter)
                end
            end
        end
    end
end)
