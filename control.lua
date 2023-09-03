local specialItems = {
    "ms-memory-module-t1",
    "ms-memory-module-t2",
    "ms-memory-module-t3",
    "ms-material-crystal-charged",
    "ms-material-chest-solar-panel"
}

local recipes = {
    -- TEMPLATES FOR COPY/PASTE
    -- [""] = {result = "", amount = 1, inputs = {[""] = 1}},

    ["ms-chemical-card-battery"] = {result = "battery", amount = 1, inputs = {["copper-plate"] = 1, ["iron-plate"] = 1, ["sulfuric-acid"] = 20}},
    ["ms-chemical-card-plastic-bar"] = {result = "plastic-bar", amount = 1, inputs = {["coal"] = 1, ["petroleum-gas"] = 20}},
    ["ms-chemical-card-solid-fuel-1"] = {result = "solid-fuel", amount = 1, inputs = {["petroleum-gas"] = 20}},
    ["ms-chemical-card-solid-fuel-2"] = {result = "solid-fuel", amount = 1, inputs = {["light-oil"] = 10}},
    ["ms-chemical-card-solid-fuel-3"] = {result = "solid-fuel", amount = 1, inputs = {["heavy-oil"] = 20}},
    ["ms-chemical-card-sulfur"] = {result = "sulfur", amount = 2, inputs = {["petroleum-gas"] = 30, ["water"] = 30}},

    ["ms-crafting-card-advanced-circuit"] = {result = "advanced-circuit", amount = 1, inputs = {["copper-cable"] = 4, ["electronic-circuit"] = 2, ["plastic-bar"] = 1}},
    ["ms-crafting-card-automation-science-pack"] = {result = "automation-science-pack", amount = 1, inputs = {["copper-plate"] = 1, ["iron-gear-wheel"] = 1}},
    ["ms-crafting-card-chemical-science-pack"] = {result = "chemical-science-pack", amount = 1, inputs = {["advanced-circuit"] = 3, ["engine-unit"] = 2, ["sulfur"] = 1}},
    ["ms-crafting-card-copper-cable"] = {result = "copper-cable", amount = 2, inputs = {["copper-plate"] = 1}},
    ["ms-crafting-card-electric-engine-unit"] = {result = "electric-engine-unit", amount = 1, inputs = {["electronic-circuit"] = 2, ["engine-unit"] = 1, ["lubricant"] = 15}},
    ["ms-crafting-card-electric-furnace"] = {result = "electric-furnace", amount = 1, inputs = {["advanced-circuit"] = 5, ["steel-plate"] = 10, ["stone-brick"] = 10}},
    ["ms-crafting-card-electronic-circuit"] = {result = "electronic-circuit", amount = 1, inputs = {["copper-cable"] = 3, ["iron-plate"] = 1}},
    ["ms-crafting-card-engine-unit"] = {result = "engine-unit", amount = 1, inputs = {["iron-gear-wheel"] = 1, ["pipe"] = 2, ["steel-plate"] = 1}},
    ["ms-crafting-card-firearm-magazine"] = {result = "firearm-magazine", amount = 1, inputs = {["iron-plate"] = 4}},
    ["ms-crafting-card-flying-robot-frame"] = {result = "flying-robot-frame", amount = 1, inputs = {["battery"] = 2, ["electric-engine-unit"] = 1, ["electronic-circuit"] = 3, ["steel-plate"] = 1}},
    ["ms-crafting-card-grenade"] = {result = "grenade", amount = 1, inputs = {["coal"] = 10, ["iron-plate"] = 5}},
    ["ms-crafting-card-inserter"] = {result = "inserter", amount = 1, inputs = {["electronic-circuit"] = 1, ["iron-gear-wheel"] = 1, ["iron-plate"] = 1}},
    ["ms-crafting-card-iron-gear-wheel"] = {result = "iron-gear-wheel", amount = 1, inputs = {["iron-plate"] = 2}},
    ["ms-crafting-card-iron-stick"] = {result = "iron-stick", amount = 2, inputs = {["iron-plate"] = 1}},
    ["ms-crafting-card-logistic-science-pack"] = {result = "logistic-science-pack", amount = 1, inputs = {["inserter"] = 1, ["transport-belt"] = 1}},
    ["ms-crafting-card-low-density-structure"] = {result = "low-density-structure", amount = 1, inputs = {["copper-plate"] = 20, ["plastic-bar"] = 5, ["steel-plate"] = 2}},
    ["ms-crafting-card-military-science-pack"] = {result = "military-science-pack", amount = 1, inputs = {["grenade"] = 1, ["piercing-rounds-magazine"] = 1, ["stone-wall"] = 2}},
    ["ms-crafting-card-piercing-rounds-magazine"] = {result = "piercing-rounds-magazine", amount = 1, inputs = {["copper-plate"] = 5, ["firearm-magazine"] = 1, ["steel-plate"] = 1}},
    ["ms-crafting-card-pipe"] = {result = "pipe", amount = 1, inputs = {["iron-plate"] = 1}},
    ["ms-crafting-card-processing-unit"] = {result = "processing-unit", amount = 1, inputs = {["advanced-circuit"] = 2, ["electronic-circuit"] = 20, ["sulfuric-acid"] = 5}},
    ["ms-crafting-card-production-science-pack"] = { result = "production-science-pack", amount = 3, inputs = {["electric-furnace"] = 1, ["productivity-module"] = 1, ["rail"] = 30}},
    ["ms-crafting-card-productivity-module"] = {result = "productivity-module", amount = 1, inputs = {["electronic-circuit"] = 5, ["advanced-circuit"] = 5}},
    ["ms-crafting-card-rail"] = {result = "rail", amount = 1, inputs = {["iron-stick"] = 1, ["steel-plate"] = 1, ["stone"] = 1}},
    ["ms-crafting-card-rocket-control-unit"] = {result = "rocket-control-unit", amount = 1, inputs = {["processing-unit"] = 1, ["speed-module"] = 1}},
    ["ms-crafting-card-rocket-fuel"] = {result = "rocket-fuel", amount = 1, inputs = {["light-oil"] = 10, ["solid-fuel"] = 10}},
    ["ms-crafting-card-speed-module"] = {result = "speed-module", amount = 1, inputs = {["electronic-circuit"] = 5, ["advanced-circuit"] = 5}},
    ["ms-crafting-card-stone-wall"] = {result = "stone-wall", amount = 1, inputs = {["stone-brick"] = 5}},
    ["ms-crafting-card-transport-belt"] = {result = "transport-belt", amount = 2, inputs = {["iron-gear-wheel"] = 1, ["iron-plate"] = 1}},
    ["ms-crafting-card-utility-science-pack"] = {result = "utility-science-pack", amount = 3, inputs = {["flying-robot-frame"] = 1, ["low-density-structure"] = 3, ["processing-unit"] = 2}},

    ["ms-smelting-card-copper-plate"] = {result = "copper-plate", amount = 1, inputs = {["copper-ore"] = 1}},
    ["ms-smelting-card-iron-plate"] = {result = "iron-plate", amount = 1, inputs = {["iron-ore"] = 1}},
    ["ms-smelting-card-steel-plate"] = {result = "steel-plate", amount = 1, inputs = {["iron-plate"] = 5}},
    ["ms-smelting-card-stone-brick"] = {result = "stone-brick", amount = 1, inputs = {["stone"] = 2}}
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
    for cardId, amount in pairs(inventory.get_contents()) do
        if recipes[cardId] ~= nil and plan[recipes[cardId].result] ~= nil then
            for _ = 1, amount do
                if global.energy > 0 then
                    if not available(recipes[cardId].result, plan[recipes[cardId].result]) then
                        craft(cardId)
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
    refillAll(inventory, plan)
    processCrafts(inventory, plan)
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
    end
end)
