local utils = require("commons")

local function ingredient (itemId, count)
    if (count < 1) then
        return {type = utils.itemType(itemId), name = itemId, probability = count}
    else
        return {type = utils.itemType(itemId), name = itemId, amount = count}
    end
end

local function items (item1, amount1, item2, amount2, item3, amount3, item4, amount4)
    local result = {}
    if (item1 ~= nil) then table.insert(result, ingredient(item1, amount1)) end
    if (item2 ~= nil) then table.insert(result, ingredient(item2, amount2)) end
    if (item3 ~= nil) then table.insert(result, ingredient(item3, amount3)) end
    if (item4 ~= nil) then table.insert(result, ingredient(item4, amount4)) end
    return result
end

local function recipe (category, duration, recipeId, inputs, outputs)
    return {
        type = "recipe",
        name = recipeId,
        category = category,
        energy_required = duration,
        ingredients = inputs,
        results = outputs,
        main_product = outputs[1]["name"]
    }
end

local function hiddenRecipe (category, duration, recipeId, inputs, outputs)
    return {
        type = "recipe",
        name = recipeId,
        category = category,
        hide_from_player_crafting = true,
        energy_required = duration,
        ingredients = inputs,
        results = outputs,
        main_product = outputs[1]["name"]
    }
end

local templates = {
    ["ms-chemical-card-battery"] = {card = "ms-blank-chemical-card", itemId = "battery"},
    ["ms-chemical-card-explosives"] = {card = "ms-blank-chemical-card", itemId = "explosives"},
    ["ms-chemical-card-plastic-bar"] = {card = "ms-blank-chemical-card", itemId = "plastic-bar"},
    ["ms-chemical-card-solid-fuel-1"] = {card = "ms-blank-chemical-card", itemId = "solid-fuel"},
    ["ms-chemical-card-solid-fuel-2"] = {card = "ms-blank-chemical-card", itemId = "solid-fuel"},
    ["ms-chemical-card-solid-fuel-3"] = {card = "ms-blank-chemical-card", itemId = "solid-fuel"},
    ["ms-chemical-card-sulfur"] = {card = "ms-blank-chemical-card", itemId = "sulfur"},

    ["ms-crafting-card-assembling-machine-1"] = {card = "ms-blank-crafting-card", itemId = "assembling-machine-1"},
    ["ms-crafting-card-assembling-machine-2"] = {card = "ms-blank-crafting-card", itemId = "assembling-machine-2"},
    ["ms-crafting-card-automation-science-pack"] = {card = "ms-blank-crafting-card", itemId = "automation-science-pack"},
    ["ms-crafting-card-copper-cable"] = {card = "ms-blank-crafting-card", itemId = "copper-cable"},
    ["ms-crafting-card-electronic-circuit"] = {card = "ms-blank-crafting-card", itemId = "electronic-circuit"},
    ["ms-crafting-card-fast-inserter"] = {card = "ms-blank-crafting-card", itemId = "fast-inserter"},
    ["ms-crafting-card-fast-splitter"] = {card = "ms-blank-crafting-card", itemId = "fast-splitter"},
    ["ms-crafting-card-fast-transport-belt"] = {card = "ms-blank-crafting-card", itemId = "fast-transport-belt"},
    ["ms-crafting-card-fast-underground-belt"] = {card = "ms-blank-crafting-card", itemId = "fast-underground-belt"},
    --["ms-crafting-card-filter-inserter"] = {card = "ms-blank-crafting-card", itemId = "filter-inserter"},
    ["ms-crafting-card-firearm-magazine"] = {card = "ms-blank-crafting-card", itemId = "firearm-magazine"},
    ["ms-crafting-card-inserter"] = {card = "ms-blank-crafting-card", itemId = "inserter"},
    ["ms-crafting-card-iron-chest"] = {card = "ms-blank-crafting-card", itemId = "iron-chest"},
    ["ms-crafting-card-iron-gear-wheel"] = {card = "ms-blank-crafting-card", itemId = "iron-gear-wheel"},
    ["ms-crafting-card-iron-stick"] = {card = "ms-blank-crafting-card", itemId = "iron-stick"},
    ["ms-crafting-card-logistic-science-pack"] = {card = "ms-blank-crafting-card", itemId = "logistic-science-pack"},
    ["ms-crafting-card-long-handed-inserter"] = {card = "ms-blank-crafting-card", itemId = "long-handed-inserter"},
    ["ms-crafting-card-medium-electric-pole"] = {card = "ms-blank-crafting-card", itemId = "medium-electric-pole"},
    ["ms-crafting-card-pipe"] = {card = "ms-blank-crafting-card", itemId = "pipe"},
    ["ms-crafting-card-pipe-to-ground"] = {card = "ms-blank-crafting-card", itemId = "pipe-to-ground"},
    ["ms-crafting-card-rail"] = {card = "ms-blank-crafting-card", itemId = "rail"},
    ["ms-crafting-card-small-lamp"] = {card = "ms-blank-crafting-card", itemId = "small-lamp"},
    ["ms-crafting-card-splitter"] = {card = "ms-blank-crafting-card", itemId = "splitter"},
    ["ms-crafting-card-stack-inserter"] = {card = "ms-blank-crafting-card", itemId = "stack-inserter"},
    ["ms-crafting-card-stone-wall"] = {card = "ms-blank-crafting-card", itemId = "stone-wall"},
    ["ms-crafting-card-transport-belt"] = {card = "ms-blank-crafting-card", itemId = "transport-belt"},
    ["ms-crafting-card-underground-belt"] = {card = "ms-blank-crafting-card", itemId = "underground-belt"},

    ["ms-crafting-card-advanced-circuit"] = {card = "ms-blank-crafting-card", itemId = "advanced-circuit"},
    ["ms-crafting-card-chemical-science-pack"] = {card = "ms-blank-crafting-card", itemId = "chemical-science-pack"},
    ["ms-crafting-card-electric-furnace"] = {card = "ms-blank-crafting-card", itemId = "electric-furnace"},
    ["ms-crafting-card-engine-unit"] = {card = "ms-blank-crafting-card", itemId = "engine-unit"},
    ["ms-crafting-card-express-splitter"] = {card = "ms-blank-crafting-card", itemId = "express-splitter"},
    ["ms-crafting-card-express-transport-belt"] = {card = "ms-blank-crafting-card", itemId = "express-transport-belt"},
    ["ms-crafting-card-express-underground-belt"] = {card = "ms-blank-crafting-card", itemId = "express-underground-belt"},
    ["ms-crafting-card-grenade"] = {card = "ms-blank-crafting-card", itemId = "grenade"},
    ["ms-crafting-card-military-science-pack"] = {card = "ms-blank-crafting-card", itemId = "military-science-pack"},
    ["ms-crafting-card-piercing-rounds-magazine"] = {card = "ms-blank-crafting-card", itemId = "piercing-rounds-magazine"},
    ["ms-crafting-card-productivity-module"] = {card = "ms-blank-crafting-card", itemId = "productivity-module"},
    ["ms-crafting-card-speed-module"] = {card = "ms-blank-crafting-card", itemId = "speed-module"},
    ["ms-crafting-card-steel-chest"] = {card = "ms-blank-crafting-card", itemId = "steel-chest"},

    ["ms-crafting-card-assembling-machine-3"] = {card = "ms-blank-crafting-card", itemId = "assembling-machine-3"},
    ["ms-crafting-card-electric-engine-unit"] = {card = "ms-blank-crafting-card", itemId = "electric-engine-unit"},
    ["ms-crafting-card-flying-robot-frame"] = {card = "ms-blank-crafting-card", itemId = "flying-robot-frame"},
    ["ms-crafting-card-low-density-structure"] = {card = "ms-blank-crafting-card", itemId = "low-density-structure"},
    ["ms-crafting-card-processing-unit"] = {card = "ms-blank-crafting-card", itemId = "processing-unit"},
    ["ms-crafting-card-production-science-pack"] = {card = "ms-blank-crafting-card", itemId = "production-science-pack"},
    --["ms-crafting-card-rocket-control-unit"] = {card = "ms-blank-crafting-card", itemId = "rocket-control-unit"},
    ["ms-crafting-card-rocket-fuel"] = {card = "ms-blank-crafting-card", itemId = "rocket-fuel"},
    ["ms-crafting-card-utility-science-pack"] = {card = "ms-blank-crafting-card", itemId = "utility-science-pack"},

    ["ms-smelting-card-copper-plate"] = {card = "ms-blank-smelting-card", itemId = "copper-plate"},
    ["ms-smelting-card-iron-plate"] = {card = "ms-blank-smelting-card", itemId = "iron-plate"},
    ["ms-smelting-card-steel-plate"] = {card = "ms-blank-smelting-card", itemId = "steel-plate"},
    ["ms-smelting-card-stone-brick"] = {card = "ms-blank-smelting-card", itemId = "stone-brick"}
}

for cardId, metadata in pairs(templates) do
    data:extend({
        recipe("crafting", 1, cardId, items(metadata.card, 1, metadata.itemId, 1), items(cardId, 1)),
        hiddenRecipe("smelting", 1, cardId .. "-formatting", items(cardId, 1), items(metadata.card, 1))
    })
end

local fluidMap = require("fluid-map")
for fluidId, digitalFluidId in pairs(fluidMap) do
    data:extend({
        recipe("crafting-with-fluid", 1, digitalFluidId, items(fluidId, 100), items(digitalFluidId, 100)),
        recipe("crafting-with-fluid", 1, "ms-" .. fluidId, items(digitalFluidId, 100), items(fluidId, 100))
    })
end

for _, interfaceId in pairs({"a", "b", "c", "d", "e", "f"}) do
    data:extend({recipe(
            "crafting", 1, "ms-material-interface-" .. interfaceId,
            items("iron-chest", 1, "ms-material-crystal-charged", 1, "electronic-circuit", 1),
            items("ms-material-interface-" .. interfaceId, 1)
    )})
end

data:extend({
    recipe("advanced-crafting", 120, "ms-material-crystal-charged", items("ms-material-crystal", 1), items("ms-material-crystal-charged", 1)),
    recipe("advanced-crafting", 30, "ms-material-crystal", items("stone", 10), items("ms-material-crystal", 1)),
    recipe("crafting", 1, "ms-ejection-card", items("ms-material-crystal-charged", 1), items("ms-ejection-card", 1)),
    recipe("crafting", 1, "ms-infinity-water-card", items("pumpjack", 1, "ms-material-crystal-charged", 1), items("ms-infinity-water-card", 1)),
    recipe("crafting", 1, "ms-material-chest-solar-panel", items("ms-material-crystal-charged", 5, "solar-panel", 10), items("ms-material-chest-solar-panel", 1)),
    recipe("crafting", 1, "ms-material-battery", items("ms-material-crystal-charged", 5, "battery-equipment", 1), items("ms-material-battery", 1)),
    recipe("crafting", 1, "ms-material-combinator", items("constant-combinator", 1, "ms-material-crystal-charged", 1), items("ms-material-combinator", 1)),
    recipe("crafting", 1, "ms-material-storage", items("iron-chest", 1, "ms-material-crystal-charged", 10, "ms-memory-module-t1", 3, "electronic-circuit", 25), items("ms-material-storage", 1)),
    recipe("crafting", 1, "ms-memory-module-t1", items("ms-material-crystal-charged", 1, "electronic-circuit", 5, "copper-cable", 10), items("ms-memory-module-t1", 1)),
    recipe("crafting", 1, "ms-memory-module-t2", items("ms-memory-module-t1", 3, "ms-material-crystal-charged", 3, "advanced-circuit", 5), items("ms-memory-module-t2", 1)),
    recipe("crafting", 1, "ms-memory-module-t3", items("ms-memory-module-t2", 3, "ms-material-crystal-charged", 3, "processing-unit", 5), items("ms-memory-module-t3", 1)),
    recipe("crafting", 1, "ms-memory-subnet-card", items("ms-operation-cancelling-card", 1, "ms-memory-module-t3", 1, "processing-unit", 5), items("ms-memory-subnet-card", 1)),
    recipe("crafting", 1, "ms-operation-cancelling-card", items("ms-material-crystal-charged", 1), items("ms-operation-cancelling-card", 1)),
    recipe("crafting", 1, "ms-uncrafting-card", items("assembling-machine-3", 1, "ms-material-crystal-charged", 4, "processing-unit", 50), items("ms-uncrafting-card", 1)),

    recipe("crafting", 1, "ms-blank-chemical-card", items("chemical-plant", 1, "ms-material-crystal-charged", 1), items("ms-blank-chemical-card", 1)),
    recipe("crafting", 1, "ms-blank-crafting-card", items("assembling-machine-2", 1, "ms-material-crystal-charged", 1), items("ms-blank-crafting-card", 1)),
    recipe("crafting", 1, "ms-blank-smelting-card", items("electric-furnace", 1, "ms-material-crystal-charged", 1), items("ms-blank-smelting-card", 1)),

    recipe("crafting", 1, "ms-crafting-expansion-card-t1", items("assembling-machine-1", 50, "ms-material-crystal-charged", 50), items("ms-crafting-expansion-card-t1", 1)),
    recipe("crafting", 1, "ms-crafting-expansion-card-t2", items("assembling-machine-2", 50, "ms-material-crystal-charged", 50), items("ms-crafting-expansion-card-t2", 1)),
    recipe("crafting", 1, "ms-crafting-expansion-card-t3", items("assembling-machine-3", 50, "ms-material-crystal-charged", 50), items("ms-crafting-expansion-card-t3", 1)),

    recipe("crafting", 1, "ms-material-logistic-chest", items("buffer-chest", 1, "ms-material-crystal-charged", 1), items("ms-material-logistic-chest", 1)),

    recipe("crafting", 1, "ms-chemical-card-advanced-oil-processing", items("ms-digital-crude-oil", 1000, "oil-refinery", 1, "ms-material-crystal-charged", 1), items("ms-chemical-card-advanced-oil-processing", 1)),
    recipe("crafting", 1, "ms-chemical-card-heavy-oil-cracking", items("ms-digital-heavy-oil", 1000, "ms-blank-chemical-card", 1), items("ms-chemical-card-heavy-oil-cracking", 1)),
    recipe("crafting", 1, "ms-chemical-card-light-oil-cracking", items("ms-digital-light-oil", 1000, "ms-blank-chemical-card", 1), items("ms-chemical-card-light-oil-cracking", 1)),
    recipe("crafting", 1, "ms-chemical-card-lubricant", items("ms-digital-lubricant", 1000, "ms-blank-chemical-card", 1), items("ms-chemical-card-lubricant", 1)),
    recipe("crafting", 1, "ms-chemical-card-sulfuric-acid", items("ms-digital-sulfuric-acid", 1000, "ms-blank-chemical-card", 1), items("ms-chemical-card-sulfuric-acid", 1)),

    hiddenRecipe("smelting", 1, "ms-chemical-card-heavy-oil-cracking-formatting", items("ms-chemical-card-heavy-oil-cracking", 1), items("ms-blank-chemical-card", 1)),
    hiddenRecipe("smelting", 1, "ms-chemical-card-light-oil-cracking-formatting", items("ms-chemical-card-light-oil-cracking", 1), items("ms-blank-chemical-card", 1)),
    hiddenRecipe("smelting", 1, "ms-chemical-card-lubricant-formatting", items("ms-chemical-card-lubricant", 1), items("ms-blank-chemical-card", 1)),
    hiddenRecipe("smelting", 1, "ms-chemical-card-sulfuric-acid", items("ms-chemical-card-sulfuric-acid", 1), items("ms-blank-chemical-card", 1))
})