local barrels = require("prototypes.barrels")
local modules = require("prototypes.modules")
local recipes = require("prototypes.crafting-templates")
local refining = require("prototypes.refining")
local utils = require("prototypes.commons")
local interfaces = {"a", "b", "c", "d", "e", "f"}

local SETTING_MATERIAL_CHEST_SIZE = "ms-material-chest-size"
local SETTING_INTERFACE_CHEST_SIZE = "ms-interface-chest-size"
local SETTING_CRYSTAL_ENERGY_VALUE = "ms-crystal-energy-value"
local SETTING_SOLAR_PANEL_ENERGY_RATE = "ms-solar-panel-energy-rate"
local SETTING_DIGITAL_STORAGE_BASE_VOLUME = "ms-digital-storage-base-volume"

local function getSetting (settingId)
    return settings.startup[settingId].value
end

local fluidMap = {
    ["crude-oil"] = "ms-digital-crude-oil",
    ["heavy-oil"] = "ms-digital-heavy-oil",
    ["light-oil"] = "ms-digital-light-oil",
    ["lubricant"] = "ms-digital-lubricant",
    ["petroleum-gas"] = "ms-digital-petroleum-gas",
    ["sulfuric-acid"] = "ms-digital-sulfuric-acid",
    ["water"] = "ms-digital-water"
}

local function cleanupStorage ()
    for itemId, amount in pairs(global.storage) do
        if game.item_prototypes[itemId] == nil and game.fluid_prototypes[itemId] then
            global.storage[itemId] = nil
            global.antiCapacity = global.antiCapacity - amount
        end
        if fluidMap[itemId] then
            global.storage[fluidMap[itemId]] = global.storage[itemId]
            global.storage[itemId] = nil
        end
    end
end

local function initStorage ()
    if global.capacity == nil then
        global.capacity = getSetting(SETTING_DIGITAL_STORAGE_BASE_VOLUME)
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
    for _, interfaceId in pairs(interfaces) do
        if global["storage-" .. interfaceId] == nil then
            global["storage-" .. interfaceId] = {antiCapacity = 0, items = {}}
        end
    end
end

local function formatStorage (amount)
    if amount >= 1048576 then
        return string.format("%.2fMB", amount / 1048576)
    elseif amount >= 10240 then
        return string.format("%.2fKB", amount / 1024)
    else
        return tostring(amount) .. "B"
    end
end

local function formatEnergy (amount)
    if amount >= 1000 then
        return string.format("%.2fK", amount / 1000)
    else
        return tostring(amount)
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
    player.gui.top.storage.caption = "STORAGE: " .. formatStorage(global.antiCapacity) .. " / " .. formatStorage(global.capacity) ..
            ", ENERGY: " .. formatEnergy(global.energy) .. ", x" .. global.craftMultiplier .. " CRAFT"
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
    if inventory.is_filtered() then
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
        inventory.remove({name = itemId, count = intention})
    end
end

local function getItem (inventory, itemId, amount)
    local intention = amount
    local actualAmount = inventory.get_item_count(itemId)
    if actualAmount >= intention then
        return
    else
        intention = intention - actualAmount
    end
    if not isAvailable(itemId, intention) then
        intention = getItemCount(itemId)
    end
    if intention > 0 then
        modifyStorage(itemId, intention * -1)
        inventory.insert({name = itemId, count = intention})
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

local function ejectDigitalStorage (inventory)
    local keys = {}
    for itemId, count in pairs(global.storage) do
        if count > 0 then
            table.insert(keys, itemId)
        end
    end
    table.sort(keys)
    for _, itemId in pairs(keys) do
        if utils.itemType(itemId) == "item" then
            modifyStorage(itemId, inventory.insert({name = itemId, count = global.storage[itemId]}) * -1)
        end
    end
end

local function emptyInventory (inventory)
    if inventory.get_item_count("ms-operation-cancelling-card") > 0 then
        return
    end
    if inventory.get_item_count("ms-ejection-card") == 0 then
        for itemId, amount in pairs(inventory.get_contents()) do
            if isStorable(itemId) then
                putItem(inventory, itemId, amount)
            end
        end
    end
end

local function refillInventory (inventory, plan)
    if inventory.get_item_count("ms-operation-cancelling-card") > 0 then
        return
    end
    if inventory.get_item_count("ms-ejection-card") > 0 then
        ejectDigitalStorage(inventory)
    else
        for itemId, amount in pairs(plan) do
            if barrels[itemId] == nil then
                getItem(inventory, itemId, amount)
            elseif global.barreling then
                getBarrel(inventory, itemId, amount)
            else
                getItem(inventory, itemId, amount)
            end
        end
    end
end

local function updateEnergy (inventory)
    global.energy = global.energy + (inventory.get_item_count("ms-material-chest-solar-panel") * getSetting(SETTING_SOLAR_PANEL_ENERGY_RATE))
    if global.energy > 10000 then
        global.energy = 10000
        return
    end
    if global.energy <= 10000 - getSetting(SETTING_CRYSTAL_ENERGY_VALUE) then
        if inventory.get_item_count("ms-material-crystal-charged") > 0 then
            global.energy = global.energy + getSetting(SETTING_CRYSTAL_ENERGY_VALUE)
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

local function refineFluid (recipe, amount, plan)
    if amount == 0 then
        return
    end
    if isAvailable(recipe.filter, plan[recipe.filter]) then
        return
    end
    local storageUse = 0
    local energyUse = 0
    for fluidId, count in pairs(recipe.input) do
        storageUse = storageUse + count * amount
        if not isAvailable(fluidId, count * amount) then
            refineFluid(recipe, amount - 1, plan)
            return
        end
    end
    for fluidId, count in pairs(recipe.output) do
        energyUse = energyUse + math.floor(count / 10)
        if getItemCount(fluidId) + count * amount > 2048 then
            refineFluid(recipe, amount - 1, plan)
            return
        end
    end
    if global.energy < energyUse then
        refineFluid(recipe, amount - 1, plan)
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
    if inventory.get_item_count("ms-operation-cancelling-card") > 0 then
        return
    end
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
                if plan[refining[templateId].filter] then
                    refineFluid(refining[templateId], count * global.craftMultiplier, plan)
                end
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

local function emptySubnetInventory (inventory, storage)
    if inventory.get_item_count("ms-operation-cancelling-card") > 0 then
        return
    end
    if inventory.get_item_count("ms-ejection-card") == 0 then
        for itemId, amount in pairs(inventory.get_contents()) do
            if isStorable(itemId) then
                local intention = amount
                local freeSpace = 65536 - storage.antiCapacity
                if intention > freeSpace then
                    intention = freeSpace
                end
                if storage.items[itemId] == nil then
                    storage.items[itemId] = intention
                else
                    storage.items[itemId] = storage.items[itemId] + intention
                end
                if intention > 0 then
                    storage.antiCapacity = storage.antiCapacity + intention
                    inventory.remove({name = itemId, count = intention})
                end
            end
        end
    end
end

local function refillSubnetInventory (inventory, storage, plan)
    if inventory.get_item_count("ms-operation-cancelling-card") > 0 then
        return
    end
    for itemId, amount in pairs(plan) do
        local intention = amount
        local actualAmount = inventory.get_item_count(itemId)
        if actualAmount >= intention then
            return
        else
            intention = intention - actualAmount
        end

        if storage.items[itemId] == nil then
            storage.items[itemId] = 0
        end

        if intention > storage.items[itemId] then
            intention = storage.items[itemId]
        end

        if intention > 0 then
            storage.items[itemId] = storage.items[itemId] - intention
            storage.antiCapacity = storage.antiCapacity - intention
            inventory.insert({name = itemId, count = intention})
        end
    end
end

script.on_nth_tick(60, function()
    local player = game.get_player(1)
    local inventory = player.force.get_linked_inventory("ms-material-storage", 0)
    updateEnergy(inventory)
    emptyInventory(inventory)
    local plan = createPlan(inventory, getSetting(SETTING_MATERIAL_CHEST_SIZE))
    craftItems(inventory, plan)
    for _, interfaceId in pairs(interfaces) do
        local interfaceInventory = player.force.get_linked_inventory("ms-material-interface-" .. interfaceId, 0)
        if interfaceInventory.get_item_count("ms-memory-subnet-card") == 0 then
            emptyInventory(interfaceInventory)
            refillInventory(interfaceInventory, createPlan(interfaceInventory, getSetting(SETTING_INTERFACE_CHEST_SIZE)))
        else
            emptySubnetInventory(interfaceInventory, global["storage-" .. interfaceId])
            refillSubnetInventory(interfaceInventory, global["storage-" .. interfaceId], createPlan(interfaceInventory, getSetting(SETTING_INTERFACE_CHEST_SIZE)))
        end
    end
    refillInventory(inventory, plan)
    updateLabel(player)
    for _, combinator in pairs(global.combinators) do
        updateCombinator(combinator)
    end
end)

local function countItems (storage)
    local result = 0
    for _, count in pairs(storage) do
        result = result + count
    end
    return result
end

script.on_init(initStorage)
script.on_configuration_changed(initStorage)
script.on_nth_tick(600, function()
    local player = game.get_player(1)
    local inventory = player.force.get_linked_inventory("ms-material-storage", 0)
    local capacity = getSetting(SETTING_DIGITAL_STORAGE_BASE_VOLUME)
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
    global.antiCapacity = countItems(global.storage)
    for _, interfaceId in pairs(interfaces) do
        global["storage-" .. interfaceId].antiCapacity = countItems(global["storage-" .. interfaceId].items)
    end
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

local function printStorage (player, storage, capacity, storageTitle)
    player.print("Contents of " .. storageTitle .. ":")
    for itemId, amount in pairs(storage) do
        if amount > 0 then
            player.print(itemId .. " = " .. amount)
        end
    end
    player.print(tostring(formatStorage(countItems(storage))) .. " of " .. formatStorage(capacity) .. " occupied")
end

script.on_event(defines.events.on_console_chat, function(event)
    local player = game.get_player(1)
    if event.message == "!storage" then
        printStorage(player, global.storage, global.capacity, "Main Digital Storage")
        return
    end
    if event.message == "!storage-A" then
        printStorage(player, global["storage-a"].items, 65536, "Subnet-A Storage")
        return
    end
    if event.message == "!storage-B" then
        printStorage(player, global["storage-b"].items, 65536, "Subnet-B Storage")
        return
    end
    if event.message == "!storage-C" then
        printStorage(player, global["storage-c"].items, 65536, "Subnet-C Storage")
        return
    end
    if event.message == "!storage-D" then
        printStorage(player, global["storage-d"].items, 65536, "Subnet-D Storage")
        return
    end
    if event.message == "!storage-E" then
        printStorage(player, global["storage-e"].items, 65536, "Subnet-E Storage")
        return
    end
    if event.message == "!storage-F" then
        printStorage(player, global["storage-f"].items, 65536, "Subnet-F Storage")
        return
    end
    if event.message == "!give" then
        local inventory = player.force.get_linked_inventory("ms-material-storage", 0)
        for itemId, count in pairs(createPlan(inventory, getSetting(SETTING_MATERIAL_CHEST_SIZE))) do
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