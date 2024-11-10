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

local SETTING_COMBINATORS_PER_BATCH = "ms-combinator-batch-size"

local function getSetting (settingId)
    return settings.startup[settingId].value
end

local fluidMap = require("prototypes.fluid-map")

local function safeTable (reference)
    if reference == nil then
        return {}
    end
    return reference
end

local function cleanupStorage ()
    for itemId, amount in pairs(storage.storage) do
        if prototypes.item[itemId] == nil and prototypes.fluid[itemId] == nil then
            storage.storage[itemId] = nil
            storage.antiCapacity = storage.antiCapacity - amount
        end
        if fluidMap[itemId] then
            storage.storage[fluidMap[itemId]] = storage.storage[itemId]
            storage.storage[itemId] = nil
        end
    end
end

local function initStorage ()
    if storage.capacity == nil then
        storage.capacity = getSetting(SETTING_DIGITAL_STORAGE_BASE_VOLUME)
    end
    if storage.antiCapacity == nil then
        storage.antiCapacity = 0
    end
    if storage.energy == nil then
        storage.energy = 10000
    end
    if storage.storage == nil then
        storage.storage = {}
    end
    if storage.combinators == nil then
        storage.combinators = {}
    end
    if storage.chests == nil then
        storage.chests = {}
    end
    if storage.craftMultiplier == nil then
        storage.craftMultiplier = 1
    end
    if game ~= nil then
        cleanupStorage()
    end
    for _, interfaceId in pairs(interfaces) do
        if storage["storage-" .. interfaceId] == nil then
            storage["storage-" .. interfaceId] = {antiCapacity = 0, items = {}}
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
    player.gui.top.storage.caption = string.format("STORAGE: %s / %s, ENERGY: %s, x%d CRAFT",
            formatStorage(storage.antiCapacity), formatStorage(storage.capacity),
            formatEnergy(storage.energy), storage.craftMultiplier)
end

local function isStorable (wrapper)
    local quality = wrapper["quality"]["level"]
    if quality ~= nil then
        if quality > 1 then
            return false
        end
    end
    return recipes[wrapper.name] == nil and modules[wrapper.name] == nil and refining[wrapper.name] == nil
end

local function isAvailable (itemId, amount)
    return storage.storage[itemId] ~= nil and amount ~= nil and storage.storage[itemId] >= amount
end

local function getItemCount (itemId)
    if storage.storage[itemId] == nil then
        storage.storage[itemId] = 0
    end
    return storage.storage[itemId]
end

local function createPlan (inventory, inventorySize)
    local result = {}
    if inventory.is_filtered() then
        for index = 1, inventorySize do
            local filter = inventory.get_filter(index)
            if filter ~= nil then
                local itemId = filter.name
                if result[itemId] == nil then
                    result[itemId] = prototypes.item[itemId].stack_size
                else
                    result[itemId] = result[itemId] + prototypes.item[itemId].stack_size
                end
            end
        end
    end
    return result
end

local function modifyStorage (itemId, amount)
    if (storage.storage[itemId] == nil) then
        storage.storage[itemId] = 0
    end
    storage.storage[itemId] = storage.storage[itemId] + amount
    storage.antiCapacity = storage.antiCapacity + amount
end

local function putItem (inventory, itemId, amount)
    local freeSpace = storage.capacity - storage.antiCapacity
    if freeSpace > 0 then
        local intention = amount
        if freeSpace < intention then
            intention = freeSpace
        end
        local removed = inventory.remove({name = itemId, count = intention})
        modifyStorage(itemId, removed)
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

local function ejectDigitalStorage (inventory)
    local keys = {}
    for itemId, count in pairs(storage.storage) do
        if count > 0 then
            table.insert(keys, itemId)
        end
    end
    table.sort(keys)
    for _, itemId in pairs(keys) do
        if utils.itemType(itemId) == "item" then
            modifyStorage(itemId, inventory.insert({name = itemId, count = storage.storage[itemId]}) * -1)
        end
    end
end

local function emptyInventory (inventory)
    if inventory.get_item_count("ms-operation-cancelling-card") > 0 then
        return
    end
    if inventory.get_item_count("ms-ejection-card") == 0 then
        for _, wrapper in pairs(inventory.get_contents()) do
            if isStorable(wrapper) then
                putItem(inventory, wrapper.name, wrapper.count)
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
            getItem(inventory, itemId, amount)
        end
    end
end

local function updateEnergy (inventory)
    local energyCap = 10000 + (inventory.get_item_count("ms-material-battery") * 1000)
    storage.energy = storage.energy + (inventory.get_item_count("ms-material-chest-solar-panel") * getSetting(SETTING_SOLAR_PANEL_ENERGY_RATE))

    if storage.energy > energyCap then
        storage.energy = energyCap
        return
    end
    if storage.energy <= 1000 then
        if inventory.get_item_count("ms-material-crystal-charged") > 0 then
            storage.energy = storage.energy + getSetting(SETTING_CRYSTAL_ENERGY_VALUE)
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
    if (storage.capacity - storage.antiCapacity) < (recipe.amount * amount - storageUse) then
        craftItem(recipe, amount - 1)
        return
    end
    if storage.energy < #recipe.input then
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
        end
    end
    storage.energy = storage.energy - #recipe.input
end

local function uncraftItem (recipe, amount, plan)
    if amount == 0 then
        return
    end
    if plan[recipe.result] then
        if recipe.amount * amount > getItemCount(recipe.result) then
            uncraftItem(recipe, amount - 1, plan)
            return
        end
        local storageUse = 0
        for _, count in pairs(recipe.input) do
            storageUse = storageUse + count
        end
        if (storageUse * 4 - 1) > (storage.capacity - storage.antiCapacity) then
            uncraftItem(recipe, amount - 1, plan)
            return
        end
        for itemId, count in pairs(recipe.input) do
            modifyStorage(itemId, count * amount)
        end
        modifyStorage(recipe.result, recipe.amount * amount * -1)
        storage.energy = storage.energy - (#recipe.input * 4)
    end
end

local function refineFluid (recipe, amount, plan)
    if amount == 0 then
        return
    end
    local conditions = 2
    if isAvailable(recipe.filter, plan[recipe.filter]) then
        conditions = conditions - 1
    end
    if recipe.secondaryFilter == nil then
        conditions = conditions - 1
    elseif plan[recipe.secondaryFilter] then
        if isAvailable(recipe.secondaryFilter, plan[recipe.secondaryFilter]) then
            conditions = conditions - 1
        end
    else
        conditions = conditions - 1
    end
    if conditions == 0 then
        return
    end
    for fluidId, count in pairs(recipe.input) do
        if not isAvailable(fluidId, count * amount) then
            refineFluid(recipe, amount - 1, plan)
            return
        end
    end
    if storage.energy < recipe.energy then
        refineFluid(recipe, amount - 1, plan)
        return
    end
    for fluidId, count in pairs(recipe.input) do
        modifyStorage(fluidId, count * amount * -1)
    end
    for fluidId, count in pairs(recipe.output) do
        modifyStorage(fluidId, count * amount)
    end
    storage.energy = storage.energy - recipe.energy
end

local function craftItems (inventory, plan)
    if inventory.get_item_count("ms-operation-cancelling-card") > 0 then
        return
    end
    for _ = 1, inventory.get_item_count("ms-infinity-water-card") * storage.craftMultiplier do
        if storage.energy >= 5 then
            if not isAvailable("ms-digital-water", 1000) then
                modifyStorage("ms-digital-water", 100)
                storage.energy = storage.energy - 1
            end
        end
    end
    for _, item in pairs(inventory.get_contents()) do
        if storage.energy > 1 then
            if recipes[item.name] ~= nil then
                local recipe = recipes[item.name]
                if storage.uncrafting then
                    uncraftItem(recipe, item.count * storage.craftMultiplier, plan)
                else
                    if plan[recipe.result] ~= nil then
                        local request = plan[recipe.result] - getItemCount(recipe.result)
                        if request > 0 then
                            -- this is too bad, need less nested levels!
                            local intention = math.ceil(request / recipe.amount) -- how many craft operations we need
                            if intention > item.count * storage.craftMultiplier then
                                intention = item.count * storage.craftMultiplier
                            end
                            craftItem(recipe, intention)
                        end
                    end
                end
            elseif refining[item.name] ~= nil then
                if plan[refining[item.name].filter] or plan[refining[item.name].secondaryFilter] then
                    refineFluid(refining[item.name], item.count * storage.craftMultiplier, plan)
                end
            end
        end
    end
end

local function createSignal (itemId, amount)
    return {min = amount, value = itemId}
end

local function updateCombinator (combinator)
    combinator.get_control_behavior().remove_section(1);
    local section = combinator.get_control_behavior().add_section();

    section.set_slot(1, createSignal("signal-C", storage.capacity))
    section.set_slot(2, createSignal("signal-E", storage.energy))
    section.set_slot(3, createSignal("signal-S", storage.antiCapacity))
    section.set_slot(4, createSignal("signal-P", 100 - (storage.antiCapacity / storage.capacity * 100)))

    local index = 5
    for name, count in pairs(storage.storage) do
        if count > 0 then
            section.set_slot(index, createSignal(name, count))
            index = index + 1
        end
    end
end

local function updateCombinatorBatch ()
    local combinators = safeTable(storage.combinators)
    if #combinators == 0 then return end
    storage.lastUpdatedCombinator = storage.lastUpdatedCombinator or 1
    local start = storage.lastUpdatedCombinator
    local end_index = math.min(start + getSetting(SETTING_COMBINATORS_PER_BATCH) - 1, #combinators)
    for i = start, end_index do
        if combinators[i] and combinators[i].valid then
            updateCombinator(combinators[i])
        end
    end
    storage.lastUpdatedCombinator = end_index + 1
    if storage.lastUpdatedCombinator > #combinators then
        storage.lastUpdatedCombinator = 1
    end
end

local function updateLogisticChest (chest)
    if chest and chest.valid then
        local inventory = chest.get_inventory(defines.inventory.chest)
        if inventory then
            emptyInventory(inventory)
            local plan = createPlan(inventory, 48)
            craftItems(inventory, plan)
            refillInventory(inventory, plan)
        end
    end
end

local function emptySubnetInventory (inventory, storage)
    if inventory.get_item_count("ms-operation-cancelling-card") > 0 then
        return
    end
    if inventory.get_item_count("ms-ejection-card") == 0 then
        for _, wrapper in pairs(inventory.get_contents()) do
            if isStorable(wrapper) then
                local intention = wrapper.count
                local freeSpace = 65536 - storage.antiCapacity
                if intention > freeSpace then
                    intention = freeSpace
                end
                if storage.items[wrapper.name] == nil then
                    storage.items[wrapper.name] = intention
                else
                    storage.items[wrapper.name] = storage.items[wrapper.name] + intention
                end
                if intention > 0 then
                    storage.antiCapacity = storage.antiCapacity + intention
                    inventory.remove({name = wrapper.name, count = intention})
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
            emptySubnetInventory(interfaceInventory, storage["storage-" .. interfaceId])
            refillSubnetInventory(interfaceInventory, storage["storage-" .. interfaceId], createPlan(interfaceInventory, getSetting(SETTING_INTERFACE_CHEST_SIZE)))
        end
    end
    for _, logisticChest in pairs(safeTable(storage.chests)) do
        updateLogisticChest(logisticChest)
    end
    refillInventory(inventory, plan)
    updateLabel(player)
    updateCombinatorBatch()
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
    for _, wrapper in pairs(inventory.get_contents()) do
        if wrapper.name == "ms-memory-module-t1" then
            capacity = capacity + (wrapper.count * 4096)
        end
        if wrapper.name == "ms-memory-module-t2" then
            capacity = capacity + (wrapper.count * 16384)
        end
        if wrapper.name == "ms-memory-module-t3" then
            capacity = capacity + (wrapper.count * 65536)
        end
        if wrapper.name == "ms-memory-subnet-card" then
            capacity = capacity + (wrapper.count * 65536)
        end
    end
    storage.capacity = capacity
    storage.antiCapacity = countItems(storage.storage)
    for _, interfaceId in pairs(interfaces) do
        storage["storage-" .. interfaceId].antiCapacity = countItems(storage["storage-" .. interfaceId].items)
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
    storage.craftMultiplier = craftMultiplier
    storage.uncrafting = inventory.get_item_count("ms-uncrafting-card") > 0
end)

local function entityPlacementHandler (entity)
    if entity ~= nil and entity.valid then
        if entity.name == "ms-material-combinator" then
            if storage.combinators == nil then
                storage.combinators = {}
            end
            table.insert(storage.combinators, entity)
        end
        if entity.name == "ms-material-logistic-chest" then
            if storage.chests == nil then
                storage.chests = {}
            end
            table.insert(storage.chests, entity)
        end
    end
end

script.on_event(defines.events.on_built_entity, function(event) entityPlacementHandler(event.entity) end)
script.on_event(defines.events.on_robot_built_entity, function(event) entityPlacementHandler(event.entity) end)
script.on_event(defines.events.on_entity_cloned, function(event) entityPlacementHandler(event.destination) end)

local function entityRemovalHandler (event)
    if event.entity and event.entity.valid and event.entity.name == "ms-material-combinator" then
        if storage.combinators == nil then
            storage.combinators = {}
        end
        for counter = 1, #storage.combinators do
            if storage.combinators[counter] == event.entity then
                table.remove(storage.combinators, counter)
                return
            end
        end
    end
    if event.entity and event.entity.valid and event.entity.name == "ms-material-logistic-chest" then
        if storage.chests == nil then
            storage.chests = {}
        end
        for counter = 1, #storage.chests do
            if storage.chests[counter] == event.entity then
                table.remove(storage.chests, counter)
                return
            end
        end
    end
end

script.on_event({
    defines.events.on_entity_died,
    defines.events.on_player_mined_entity,
    defines.events.on_robot_mined_entity
}, entityRemovalHandler)

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
        printStorage(player, storage.storage, storage.capacity, "Main Digital Storage")
        return
    end
    if event.message == "!storage-A" then
        printStorage(player, storage["storage-a"].items, 65536, "Subnet-A Storage")
        return
    end
    if event.message == "!storage-B" then
        printStorage(player, storage["storage-b"].items, 65536, "Subnet-B Storage")
        return
    end
    if event.message == "!storage-C" then
        printStorage(player, storage["storage-c"].items, 65536, "Subnet-C Storage")
        return
    end
    if event.message == "!storage-D" then
        printStorage(player, storage["storage-d"].items, 65536, "Subnet-D Storage")
        return
    end
    if event.message == "!storage-E" then
        printStorage(player, storage["storage-e"].items, 65536, "Subnet-E Storage")
        return
    end
    if event.message == "!storage-F" then
        printStorage(player, storage["storage-f"].items, 65536, "Subnet-F Storage")
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
end)