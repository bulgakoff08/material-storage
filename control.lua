local barrels = require("prototypes.barrels")
local modules = require("prototypes.modules")
local recipes = require("prototypes.crafting-templates")
local refining = require("prototypes.refining")
local utils = require("prototypes.commons")

local function cleanupStorage ()
    for itemId, amount in pairs(global.storage) do
        if game.item_prototypes[itemId] == nil and game.fluid_prototypes[itemId] then
            global.storage[itemId] = nil
            global.antiCapacity = global.antiCapacity - amount
        end
    end
end

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
    if global.craftMultiplier == nil then
        global.craftMultiplier = 1
    end
    if game ~= nil then
        cleanupStorage()
    end
end

local function updateLabel (player)
    if player.gui.top.storage == nil then
        local label = player.gui.top.add({type = "label", name = "storage", caption = ""})
        label.style.font = "default-bold"
        label.style.left_margin = 16
        label.style.right_margin = 16
        label.style.top_margin = 16
        label.style.bottom_margin = 16
    end
    player.gui.top.storage.caption = "STORAGE: " .. global.antiCapacity .. " / " .. global.capacity ..
            "\nENERGY: " .. global.energy ..
            "\nCRAFT CAPACITY: " .. global.craftMultiplier
end

local function isStorable (itemId)
    return recipes[itemId] == nil and modules[itemId] == nil and refining[itemId] == nil
end

local function isAvailable (itemId, amount)
    return global.storage[itemId] ~= nil and global.storage[itemId] >= amount
end

local function getItemCount (itemId)
    if global.storage[itemId] == nil then
        global.storage[itemId] = 0
    end
    return global.storage[itemId]
end

local function createPlan (inventory, inventorySize)
    local result = {}
    for index = 1, inventorySize do
        local itemId = inventory.get_filter(index)
        if itemId ~= nil then
            if result[itemId] == nil then
                result[itemId] = game.item_prototypes[itemId].stack_size
            else
                result[itemId] = result[itemId] + game.item_prototypes[itemId].stack_size
            end
        end
    end
    return result
end

local function modifyStorage (itemId, amount)
    if (global.storage[itemId] == nil) then
        global.storage[itemId] = 0
    end
    global.storage[itemId] = global.storage[itemId] + amount
    global.antiCapacity = global.antiCapacity + amount
end

local function putItem (inventory, itemId, amount)
    local freeSpace = global.capacity - global.antiCapacity
    if freeSpace > 0 then
        local intention = amount
        if freeSpace < intention then
            intention = freeSpace
        end
        modifyStorage(itemId, intention)
        inventory.remove({name = itemId, count = intention })
    end
end

local function putBarrel (inventory, itemId, amount)
    for _ = 1, amount do
        if global.capacity - global.antiCapacity > 51 then
            modifyStorage(barrels[itemId], 50)
            modifyStorage("empty-barrel", 1)
            inventory.remove({name = itemId, count = 1})
        else
            return
        end
    end
end

local function getItem (inventory, itemId, amount)
    local intention = amount
    if not isAvailable(itemId, intention) then
        intention = getItemCount(itemId)
    end
    if intention > 0 then
        modifyStorage(itemId, intention * -1)
        inventory.insert({name = itemId, count = intention })
    end
end

local function getBarrel (inventory, itemId, amount)
    for _ = 1, amount do
        if isAvailable(barrels[itemId], 50) and isAvailable("empty-barrel", 1) then
            modifyStorage(barrels[itemId], -50)
            modifyStorage("empty-barrel", -1)
            inventory.insert({name = itemId, count = 1})
        end
    end
end

local function emptyInventory (inventory)
    for itemId, amount in pairs(inventory.get_contents()) do
        if isStorable(itemId) then
            if barrels[itemId] == nil then
                putItem(inventory, itemId, amount)
            elseif global.barreling then
                putBarrel(inventory, itemId, amount)
            end
        end
    end
end

local function refillInventory (inventory, plan)
    for itemId, amount in pairs(plan) do
        if barrels[itemId] == nil then
            getItem(inventory, itemId, amount)
        elseif global.barreling then
            getBarrel(inventory, itemId, amount)
        end
    end
end

local function updateEnergy (inventory)
    global.energy = global.energy + inventory.get_item_count("ms-material-chest-solar-panel")
    if global.energy > 10000 then
        global.energy = 10000
        return
    end
    if global.energy <= 9000 then
        if inventory.get_item_count("ms-material-crystal-charged") > 0 then
            global.energy = global.energy + 1000
            inventory.remove({name = "ms-material-crystal-charged", count = 1})
        end
    end
end

local function calculateAmount (amount)
    if amount >= 1 then
        return amount
    end
    if math.random(1, 100) < amount * 100 then
        return 1
    end
    return 0
end

local function craftItem (recipe, amount)
    if amount == 0 then
        return
    end
    local storageUse = 0
    for itemId, count in pairs(recipe.input) do
        storageUse = storageUse + count * amount
        if not isAvailable(itemId, count * amount) then
            craftItem(recipe, amount - 1)
            return
        end
    end
    if (global.capacity - global.antiCapacity) < (recipe.amount * amount - storageUse) then
        craftItem(recipe, amount - 1)
        return
    end
    if global.energy < storageUse + 2 then
        craftItem(recipe, amount - 1)
        return
    end
    for itemId, count in pairs(recipe.input) do
        modifyStorage(itemId, count * amount * -1)
    end
    modifyStorage(recipe.result, recipe.amount * amount)
    if recipe.secondaryResult ~= nil then
        local secondaryAmount = calculateAmount(recipe.secondaryAmount)
        if secondaryAmount > 0 then
            modifyStorage(recipe.secondaryResult, secondaryAmount)
            global.energy = global.energy - secondaryAmount
        end
    end
    global.energy = global.energy - storageUse - 1
end

local function uncraftItem (recipe, amount)
    if amount == 0 then
        return
    end
    if recipe.amount * amount > getItemCount(recipe.result) then
        uncraftItem(recipe, amount - 1)
        return
    end
    local storageUse = 0
    for _, count in pairs(recipe.input) do
        storageUse = storageUse + count
    end
    if (storageUse * 4 - 1) > (global.capacity - global.antiCapacity) then
        uncraftItem(recipe, amount - 1)
        return
    end
    for itemId, count in pairs(recipe.input) do
        modifyStorage(itemId, count * amount)
    end
    modifyStorage(recipe.result, recipe.amount * amount * -1)
    global.energy = global.energy - 1 - storageUse * 4
end

local function refineFluid (recipe, amount)
    if amount == 0 then
        return
    end
    local storageUse = 0
    local energyUse = 0
    for fluidId, count in pairs(recipe.input) do
        storageUse = storageUse + count * amount
        if not isAvailable(fluidId, count * amount) then
            refineFluid(recipe, amount - 1)
            return
        end
    end
    for fluidId, count in pairs(recipe.output) do
        energyUse = energyUse + math.floor(count / 10)
        if getItemCount(fluidId) + count * amount > 2048 then
            refineFluid(recipe, amount - 1)
            return
        end
    end
    if global.energy < energyUse then
        refineFluid(recipe, amount - 1)
        return
    end
    for fluidId, count in pairs(recipe.input) do
        modifyStorage(fluidId, count * amount * -1)
    end
    for fluidId, count in pairs(recipe.output) do
        modifyStorage(fluidId, count * amount)
    end
    global.energy = global.energy - energyUse
end

local function craftItems (inventory, plan)
    for templateId, count in pairs(inventory.get_contents()) do
        if global.energy > 1 then
            if recipes[templateId] ~= nil then
                local recipe = recipes[templateId]
                if global.uncrafting then
                    uncraftItem(recipe, count * global.craftMultiplier)
                else
                    if plan[recipe.result] ~= nil then
                        local request = plan[recipe.result] - getItemCount(recipe.result)
                        if request > 0 then
                            -- this is too bad, need less nested levels!
                            local intention = math.ceil(request / recipe.amount) -- how many craft operations we need
                            if intention > count * global.craftMultiplier then
                                intention = count * global.craftMultiplier
                            end
                            craftItem(recipe, intention)
                        end
                    end
                end
            elseif refining[templateId] ~= nil then
                refineFluid(refining[templateId], count * global.craftMultiplier)
            end
        end
    end
end

local function updateCombinator (combinator)
    local control = combinator.get_control_behavior()
    local signals = {}
    table.insert(signals, {
        count = global.capacity,
        index = 1,
        signal = {name = "signal-C", type = "virtual"}
    })
    table.insert(signals, {
        count = global.energy,
        index = 2,
        signal = {name = "signal-E", type = "virtual"}
    })
    table.insert(signals, {
        count = global.antiCapacity,
        index = 3, signal = {name = "signal-S", type = "virtual"}
    })
    table.insert(signals, {
        count = 100 - (global.antiCapacity / global.capacity * 100),
        index = 4,
        signal = {name = "signal-P", type = "virtual"}
    })
    local index = 5
    for name, count in pairs(global.storage) do
        if count > 0 then
            table.insert(signals, {
                count = count,
                index = index,
                signal = {name = name, type = utils.itemType(name)}
            })
            index = index + 1
        end
    end
    control.parameters = signals
end

script.on_nth_tick(60, function()
    local player = game.get_player(1)
    local inventory = player.force.get_linked_inventory("ms-material-storage", 0)
    updateEnergy(inventory)
    emptyInventory(inventory)
    local plan = createPlan(inventory, 150)
    craftItems(inventory, plan)
    for _, interfaceId in pairs({"a", "b", "c", "d", "e", "f"}) do
        local interfaceInventory = player.force.get_linked_inventory(
                "ms-material-interface-" .. interfaceId, 0)
        emptyInventory(interfaceInventory)
        refillInventory(interfaceInventory, createPlan(interfaceInventory, 10))
    end
    refillInventory(inventory, plan)
    updateLabel(player)
    for _, combinator in pairs(global.combinators) do
        updateCombinator(combinator)
    end
end)

script.on_init(initStorage)
script.on_load(initStorage)
script.on_configuration_changed(initStorage)
script.on_nth_tick(600, function()
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
    local antiCapacity = 0
    for _, count in pairs(global.storage) do
        antiCapacity = antiCapacity + count
    end
    global.antiCapacity = antiCapacity
    local craftMultiplier = 1
    if inventory.get_item_count("ms-crafting-expansion-card-t1") > 0 then
        craftMultiplier = 2
        if inventory.get_item_count("ms-crafting-expansion-card-t2") > 0 then
            craftMultiplier = 4
            if inventory.get_item_count("ms-crafting-expansion-card-t3") > 0 then
                craftMultiplier = 8
            end
        end
    end
    global.craftMultiplier = craftMultiplier
    global.barreling = inventory.get_item_count("ms-barreling-card") > 0
    global.uncrafting = inventory.get_item_count("ms-uncrafting-card") > 0
end)

local function combinatorPlacementHandler (entity)
    if entity and entity.valid and entity.name == "ms-material-combinator" then
        table.insert(global.combinators, entity)
    end
end

script.on_event(defines.events.on_built_entity, function(event) combinatorPlacementHandler(event.created_entity) end)
script.on_event(defines.events.on_robot_built_entity, function(event) combinatorPlacementHandler(event.created_entity) end)
script.on_event(defines.events.on_entity_cloned, function(event) combinatorPlacementHandler(event.destination) end)

local function combinatorRemovalHandler (event)
    if event.entity and event.entity.valid and event.entity.name == "ms-material-combinator" then
        for counter = 1, #global.combinators do
            if global.combinators[counter] == event.entity then
                table.remove(global.combinators, counter)
                return
            end
        end
    end
end

script.on_event({
    defines.events.on_entity_died,
    defines.events.on_player_mined_entity,
    defines.events.on_robot_mined_entity
}, combinatorRemovalHandler)

script.on_event(defines.events.on_console_chat, function(event)
    local player = game.get_player(1)
    if event.message == "!storage" then
        player.print("Contents of digital storage:")
        for itemId, amount in pairs(global.storage) do
            if amount > 0 then
                player.print("- " .. itemId .. " = " .. amount)
            end
        end
        return
    end
    if event.message == "!give" then
        local inventory = player.force.get_linked_inventory("ms-material-storage", 0)
        player.print("Items cheat applied")
        for itemId, count in pairs(createPlan(inventory, 150)) do
            local required = count - getItemCount(itemId)
            if required > 0 then
                modifyStorage(itemId, required)
                player.print(required .. " " .. itemId .. " added to digital storage")
            end
        end
    end
    if event.message == "!clear" then
        player.print("Cleaning digital storage")
        for itemId, _ in pairs(global.storage) do
            global.storage[itemId] = nil
        end
        global.antiCapacity = 0
    end
end)