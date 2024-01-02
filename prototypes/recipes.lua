local utils = require("commons")

local function ingredient(itemId, count)
    if (count < 1) then
        return {type = utils.itemType(itemId), name = itemId, probability = count}
    else
        return {type = utils.itemType(itemId), name = itemId, amount = count}
    end
end

local function items(item1, amount1, item2, amount2, item3, amount3, item4, amount4)
    local result = {}
    if (item1 ~= nil) then table.insert(result, ingredient(item1, amount1)) end
    if (item2 ~= nil) then table.insert(result, ingredient(item2, amount2)) end
    if (item3 ~= nil) then table.insert(result, ingredient(item3, amount3)) end
    if (item4 ~= nil) then table.insert(result, ingredient(item4, amount4)) end
    return result
end

local function recipe(category, duration, recipeId, inputs, outputs)
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

data:extend({
    recipe("advanced-crafting", 120, "ms-material-crystal-charged", items("ms-material-crystal", 1), items("ms-material-crystal-charged", 1)),
    recipe("advanced-crafting", 30, "ms-material-crystal", items("stone", 10), items("ms-material-crystal", 1)),
    recipe("crafting", 1, "ms-ejection-card", items("ms-material-crystal-charged", 1), items("ms-ejection-card", 1)),
    recipe("crafting", 1, "ms-infinity-water-card", items("pumpjack", 1, "ms-material-crystal-charged", 1), items("ms-infinity-water-card", 1)),
    recipe("crafting", 1, "ms-material-chest-solar-panel", items("ms-material-crystal-charged", 5, "solar-panel", 10), items("ms-material-chest-solar-panel", 1)),
    recipe("crafting", 1, "ms-material-combinator", items("constant-combinator", 1, "ms-material-crystal-charged", 1), items("ms-material-combinator", 1)),
    recipe("crafting", 1, "ms-material-storage", items("iron-chest", 1, "ms-material-crystal-charged", 10, "ms-memory-module-t1", 3, "electronic-circuit", 25), items("ms-material-storage", 1)),
    recipe("crafting", 1, "ms-memory-module-t1", items("ms-material-crystal-charged", 1, "electronic-circuit", 5, "copper-cable", 10), items("ms-memory-module-t1", 1)),
    recipe("crafting", 1, "ms-memory-module-t2", items("ms-memory-module-t1", 3, "ms-material-crystal-charged", 3, "advanced-circuit", 5), items("ms-memory-module-t2", 1)),
    recipe("crafting", 1, "ms-memory-module-t3", items("ms-memory-module-t2", 3, "ms-material-crystal-charged", 3, "processing-unit", 5), items("ms-memory-module-t3", 1)),
    recipe("crafting", 1, "ms-memory-subnet-card", items("ms-operation-cancelling-card", 1, "ms-memory-module-t3", 1, "processing-unit", 5), items("ms-memory-subnet-card", 1)),
    recipe("crafting", 1, "ms-operation-cancelling-card", items("ms-material-crystal-charged", 1), items("ms-operation-cancelling-card", 1)),
    recipe("crafting", 1, "ms-uncrafting-card", items("assembling-machine-3", 1, "ms-material-crystal-charged", 4, "processing-unit", 50), items("ms-uncrafting-card", 1)),

    recipe("crafting", 1, "ms-crafting-expansion-card-t1", items("assembling-machine-1", 50, "ms-material-crystal-charged", 50), items("ms-crafting-expansion-card-t1", 1)),
    recipe("crafting", 1, "ms-crafting-expansion-card-t2", items("assembling-machine-2", 50, "ms-material-crystal-charged", 50), items("ms-crafting-expansion-card-t2", 1)),
    recipe("crafting", 1, "ms-crafting-expansion-card-t3", items("assembling-machine-3", 50, "ms-material-crystal-charged", 50), items("ms-crafting-expansion-card-t3", 1)),

    recipe("crafting", 1, "ms-material-interface-a", items("iron-chest", 1, "ms-material-crystal-charged", 1, "electronic-circuit", 1), items("ms-material-interface-a", 1)),
    recipe("crafting", 1, "ms-material-interface-b", items("iron-chest", 1, "ms-material-crystal-charged", 1, "electronic-circuit", 1), items("ms-material-interface-b", 1)),
    recipe("crafting", 1, "ms-material-interface-c", items("iron-chest", 1, "ms-material-crystal-charged", 1, "electronic-circuit", 1), items("ms-material-interface-c", 1)),
    recipe("crafting", 1, "ms-material-interface-d", items("iron-chest", 1, "ms-material-crystal-charged", 1, "electronic-circuit", 1), items("ms-material-interface-d", 1)),
    recipe("crafting", 1, "ms-material-interface-e", items("iron-chest", 1, "ms-material-crystal-charged", 1, "electronic-circuit", 1), items("ms-material-interface-e", 1)),
    recipe("crafting", 1, "ms-material-interface-f", items("iron-chest", 1, "ms-material-crystal-charged", 1, "electronic-circuit", 1), items("ms-material-interface-f", 1)),

    recipe("crafting", 1, "ms-chemical-card-battery", items("battery", 100, "chemical-plant", 1, "ms-material-crystal-charged", 1), items("ms-chemical-card-battery", 1)),
    recipe("crafting", 1, "ms-chemical-card-plastic-bar", items("plastic-bar", 100, "chemical-plant", 1, "ms-material-crystal-charged", 1), items("ms-chemical-card-plastic-bar", 1)),
    recipe("crafting", 1, "ms-chemical-card-solid-fuel-1", items("solid-fuel", 100, "chemical-plant", 1, "ms-material-crystal-charged", 1), items("ms-chemical-card-solid-fuel-1", 1)),
    recipe("crafting", 1, "ms-chemical-card-solid-fuel-2", items("solid-fuel", 100, "chemical-plant", 1, "ms-material-crystal-charged", 1), items("ms-chemical-card-solid-fuel-2", 1)),
    recipe("crafting", 1, "ms-chemical-card-solid-fuel-3", items("solid-fuel", 100, "chemical-plant", 1, "ms-material-crystal-charged", 1), items("ms-chemical-card-solid-fuel-3", 1)),
    recipe("crafting", 1, "ms-chemical-card-sulfur", items("sulfur", 50, "chemical-plant", 1, "ms-material-crystal-charged", 1), items("ms-chemical-card-sulfur", 1)),

    recipe("crafting", 1, "ms-chemical-card-advanced-oil-processing", items("ms-digital-crude-oil", 1000, "oil-refinery", 1, "ms-material-crystal-charged", 1), items("ms-chemical-card-advanced-oil-processing", 1)),
    recipe("crafting", 1, "ms-chemical-card-heavy-oil-cracking", items("ms-digital-heavy-oil", 1000, "chemical-plant", 1, "ms-material-crystal-charged", 1), items("ms-chemical-card-heavy-oil-cracking", 1)),
    recipe("crafting", 1, "ms-chemical-card-light-oil-cracking", items("ms-digital-light-oil", 1000, "chemical-plant", 1, "ms-material-crystal-charged", 1), items("ms-chemical-card-light-oil-cracking", 1)),
    recipe("crafting", 1, "ms-chemical-card-lubricant", items("ms-digital-lubricant", 1000, "chemical-plant", 1, "ms-material-crystal-charged", 1), items("ms-chemical-card-lubricant", 1)),
    recipe("crafting", 1, "ms-chemical-card-sulfuric-acid", items("ms-digital-sulfuric-acid", 1000, "chemical-plant", 1, "ms-material-crystal-charged", 1), items("ms-chemical-card-sulfuric-acid", 1)),

    -- digital fluids
    recipe("crafting-with-fluid", 1, "ms-digital-crude-oil", items("crude-oil", 100), items("ms-digital-crude-oil", 100)),
    recipe("crafting-with-fluid", 1, "ms-digital-heavy-oil", items("heavy-oil", 100), items("ms-digital-heavy-oil", 100)),
    recipe("crafting-with-fluid", 1, "ms-digital-light-oil", items("light-oil", 100), items("ms-digital-light-oil", 100)),
    recipe("crafting-with-fluid", 1, "ms-digital-lubricant", items("lubricant", 100), items("ms-digital-lubricant", 100)),
    recipe("crafting-with-fluid", 1, "ms-digital-petroleum-gas", items("petroleum-gas", 100), items("ms-digital-petroleum-gas", 100)),
    recipe("crafting-with-fluid", 1, "ms-digital-sulfuric-acid", items("sulfuric-acid", 100), items("ms-digital-sulfuric-acid", 100)),
    recipe("crafting-with-fluid", 1, "ms-digital-water", items("water", 100), items("ms-digital-water", 100)),

    -- analog fluids
    recipe("crafting-with-fluid", 1, "ms-crude-oil", items("ms-digital-crude-oil", 100), items("crude-oil", 100)),
    recipe("crafting-with-fluid", 1, "ms-heavy-oil", items("ms-digital-heavy-oil", 100), items("heavy-oil", 100)),
    recipe("crafting-with-fluid", 1, "ms-light-oil", items("ms-digital-light-oil", 100), items("light-oil", 100)),
    recipe("crafting-with-fluid", 1, "ms-lubricant", items("ms-digital-lubricant", 100), items("lubricant", 100)),
    recipe("crafting-with-fluid", 1, "ms-petroleum-gas", items("ms-digital-petroleum-gas", 100), items("petroleum-gas", 100)),
    recipe("crafting-with-fluid", 1, "ms-sulfuric-acid", items("ms-digital-sulfuric-acid", 100), items("sulfuric-acid", 100)),
    recipe("crafting-with-fluid", 1, "ms-water", items("ms-digital-water", 100), items("water", 100)),

    recipe("crafting", 1, "ms-crafting-card-advanced-circuit", items("advanced-circuit", 200, "assembling-machine-2", 1, "ms-material-crystal-charged", 1), items("ms-crafting-card-advanced-circuit", 1)),
    recipe("crafting", 1, "ms-crafting-card-assembling-machine-1", items("assembling-machine-1", 51, "ms-material-crystal-charged", 1), items("ms-crafting-card-assembling-machine-1", 1)),
    recipe("crafting", 1, "ms-crafting-card-assembling-machine-2", items("assembling-machine-1", 1, "assembling-machine-2", 50, "ms-material-crystal-charged", 1), items("ms-crafting-card-assembling-machine-2", 1)),
    recipe("crafting", 1, "ms-crafting-card-assembling-machine-3", items("assembling-machine-2", 1, "assembling-machine-3", 50, "ms-material-crystal-charged", 1), items("ms-crafting-card-assembling-machine-3", 1)),
    recipe("crafting", 1, "ms-crafting-card-automation-science-pack", items("automation-science-pack", 200, "assembling-machine-1", 1, "ms-material-crystal-charged", 1), items("ms-crafting-card-automation-science-pack", 1)),
    recipe("crafting", 1, "ms-crafting-card-chemical-science-pack", items("chemical-science-pack", 200, "assembling-machine-2", 1, "ms-material-crystal-charged", 1), items("ms-crafting-card-chemical-science-pack", 1)),
    recipe("crafting", 1, "ms-crafting-card-copper-cable", items("copper-cable", 200, "assembling-machine-1", 1, "ms-material-crystal-charged", 1), items("ms-crafting-card-copper-cable", 1)),
    recipe("crafting", 1, "ms-crafting-card-electric-engine-unit", items("electric-engine-unit", 50, "assembling-machine-3", 1, "ms-material-crystal-charged", 1), items("ms-crafting-card-electric-engine-unit", 1)),
    recipe("crafting", 1, "ms-crafting-card-electric-furnace", items("electric-furnace", 50, "assembling-machine-2", 1, "ms-material-crystal-charged", 1), items("ms-crafting-card-electric-furnace", 1)),
    recipe("crafting", 1, "ms-crafting-card-electronic-circuit", items("electronic-circuit", 200, "assembling-machine-1", 1, "ms-material-crystal-charged", 1), items("ms-crafting-card-electronic-circuit", 1)),
    recipe("crafting", 1, "ms-crafting-card-engine-unit", items("engine-unit", 50, "assembling-machine-2", 1, "ms-material-crystal-charged", 1), items("ms-crafting-card-engine-unit", 1)),
    recipe("crafting", 1, "ms-crafting-card-express-splitter", items("assembling-machine-2", 1, "express-splitter", 50, "ms-material-crystal-charged", 1), items("ms-crafting-card-express-splitter", 1)),
    recipe("crafting", 1, "ms-crafting-card-express-transport-belt", items("assembling-machine-2", 1, "express-transport-belt", 100, "ms-material-crystal-charged", 1), items("ms-crafting-card-express-transport-belt", 1)),
    recipe("crafting", 1, "ms-crafting-card-express-underground-belt", items("assembling-machine-2", 1, "express-underground-belt", 50, "ms-material-crystal-charged", 1), items("ms-crafting-card-express-underground-belt", 1)),
    recipe("crafting", 1, "ms-crafting-card-fast-inserter", items("assembling-machine-1", 1, "fast-inserter", 50, "ms-material-crystal-charged", 1), items("ms-crafting-card-fast-inserter", 1)),
    recipe("crafting", 1, "ms-crafting-card-fast-splitter", items("assembling-machine-1", 1, "fast-splitter", 50, "ms-material-crystal-charged", 1), items("ms-crafting-card-fast-splitter", 1)),
    recipe("crafting", 1, "ms-crafting-card-fast-transport-belt", items("assembling-machine-1", 1, "fast-transport-belt", 100, "ms-material-crystal-charged", 1), items("ms-crafting-card-fast-transport-belt", 1)),
    recipe("crafting", 1, "ms-crafting-card-fast-underground-belt", items("assembling-machine-1", 1, "fast-underground-belt", 50, "ms-material-crystal-charged", 1), items("ms-crafting-card-fast-underground-belt", 1)),
    recipe("crafting", 1, "ms-crafting-card-filter-inserter", items("assembling-machine-1", 1, "filter-inserter", 50, "ms-material-crystal-charged", 1), items("ms-crafting-card-filter-inserter", 1)),
    recipe("crafting", 1, "ms-crafting-card-firearm-magazine", items("firearm-magazine", 200, "assembling-machine-1", 1, "ms-material-crystal-charged", 1), items("ms-crafting-card-firearm-magazine", 1)),
    recipe("crafting", 1, "ms-crafting-card-flying-robot-frame", items("flying-robot-frame", 100, "assembling-machine-3", 1, "ms-material-crystal-charged", 1), items("ms-crafting-card-flying-robot-frame", 1)),
    recipe("crafting", 1, "ms-crafting-card-grenade", items("grenade", 100, "assembling-machine-2", 1, "ms-material-crystal-charged", 1), items("ms-crafting-card-grenade", 1)),
    recipe("crafting", 1, "ms-crafting-card-inserter", items("inserter", 50, "assembling-machine-1", 1, "ms-material-crystal-charged", 1), items("ms-crafting-card-inserter", 1)),
    recipe("crafting", 1, "ms-crafting-card-iron-chest", items("assembling-machine-1", 1, "iron-chest", 50, "ms-material-crystal-charged", 1), items("ms-crafting-card-iron-chest", 1)),
    recipe("crafting", 1, "ms-crafting-card-iron-gear-wheel", items("iron-gear-wheel", 100, "assembling-machine-1", 1, "ms-material-crystal-charged", 1), items("ms-crafting-card-iron-gear-wheel", 1)),
    recipe("crafting", 1, "ms-crafting-card-iron-stick", items("iron-stick", 100, "assembling-machine-1", 1, "ms-material-crystal-charged", 1), items("ms-crafting-card-iron-stick", 1)),
    recipe("crafting", 1, "ms-crafting-card-logistic-science-pack", items("logistic-science-pack", 200, "assembling-machine-1", 1, "ms-material-crystal-charged", 1), items("ms-crafting-card-logistic-science-pack", 1)),
    recipe("crafting", 1, "ms-crafting-card-long-handed-inserter", items("assembling-machine-1", 1, "long-handed-inserter", 50, "ms-material-crystal-charged", 1), items("ms-crafting-card-long-handed-inserter", 1)),
    recipe("crafting", 1, "ms-crafting-card-low-density-structure", items("low-density-structure", 100, "assembling-machine-3", 1, "ms-material-crystal-charged", 1), items("ms-crafting-card-low-density-structure", 1)),
    recipe("crafting", 1, "ms-crafting-card-medium-electric-pole", items("assembling-machine-1", 1, "medium-electric-pole", 50, "ms-material-crystal-charged", 1), items("ms-crafting-card-medium-electric-pole", 1)),
    recipe("crafting", 1, "ms-crafting-card-military-science-pack", items("military-science-pack", 200, "assembling-machine-2", 1, "ms-material-crystal-charged", 1), items("ms-crafting-card-military-science-pack", 1)),
    recipe("crafting", 1, "ms-crafting-card-piercing-rounds-magazine", items("piercing-rounds-magazine", 200, "assembling-machine-2", 1, "ms-material-crystal-charged", 1), items("ms-crafting-card-piercing-rounds-magazine", 1)),
    recipe("crafting", 1, "ms-crafting-card-pipe", items("pipe", 100, "assembling-machine-1", 1, "ms-material-crystal-charged", 1), items("ms-crafting-card-pipe", 1)),
    recipe("crafting", 1, "ms-crafting-card-pipe-to-ground", items("assembling-machine-1", 1, "pipe-to-ground", 50, "ms-material-crystal-charged", 1), items("ms-crafting-card-pipe-to-ground", 1)),
    recipe("crafting", 1, "ms-crafting-card-processing-unit", items("processing-unit", 200, "assembling-machine-3", 1, "ms-material-crystal-charged", 1), items("ms-crafting-card-processing-unit", 1)),
    recipe("crafting", 1, "ms-crafting-card-production-science-pack", items("production-science-pack", 200, "assembling-machine-3", 1, "ms-material-crystal-charged", 1), items("ms-crafting-card-production-science-pack", 1)),
    recipe("crafting", 1, "ms-crafting-card-productivity-module", items("productivity-module", 50, "assembling-machine-2", 1, "ms-material-crystal-charged", 1), items("ms-crafting-card-productivity-module", 1)),
    recipe("crafting", 1, "ms-crafting-card-rail", items("rail", 100, "assembling-machine-1", 1, "ms-material-crystal-charged", 1), items("ms-crafting-card-rail", 1)),
    recipe("crafting", 1, "ms-crafting-card-rocket-control-unit", items("rocket-control-unit", 100, "assembling-machine-3", 1, "ms-material-crystal-charged", 1), items("ms-crafting-card-rocket-control-unit", 1)),
    recipe("crafting", 1, "ms-crafting-card-rocket-fuel", items("rocket-fuel", 100, "assembling-machine-3", 1, "ms-material-crystal-charged", 1), items("ms-crafting-card-rocket-fuel", 1)),
    recipe("crafting", 1, "ms-crafting-card-small-lamp", items("assembling-machine-1", 1, "small-lamp", 50, "ms-material-crystal-charged", 1), items("ms-crafting-card-small-lamp", 1)),
    recipe("crafting", 1, "ms-crafting-card-speed-module", items("speed-module", 50, "assembling-machine-2", 1, "ms-material-crystal-charged", 1), items("ms-crafting-card-speed-module", 1)),
    recipe("crafting", 1, "ms-crafting-card-splitter", items("assembling-machine-1", 1, "splitter", 50, "ms-material-crystal-charged", 1), items("ms-crafting-card-splitter", 1)),
    recipe("crafting", 1, "ms-crafting-card-stack-inserter", items("assembling-machine-1", 1, "stack-inserter", 100, "ms-material-crystal-charged", 1), items("ms-crafting-card-stack-inserter", 1)),
    recipe("crafting", 1, "ms-crafting-card-steel-chest", items("assembling-machine-2", 1, "steel-chest", 50, "ms-material-crystal-charged", 1), items("ms-crafting-card-steel-chest", 1)),
    recipe("crafting", 1, "ms-crafting-card-stone-wall", items("stone-wall", 100, "assembling-machine-1", 1, "ms-material-crystal-charged", 1), items("ms-crafting-card-stone-wall", 1)),
    recipe("crafting", 1, "ms-crafting-card-transport-belt", items("transport-belt", 100, "assembling-machine-1", 1, "ms-material-crystal-charged", 1), items("ms-crafting-card-transport-belt", 1)),
    recipe("crafting", 1, "ms-crafting-card-underground-belt", items("assembling-machine-1", 1, "underground-belt", 50, "ms-material-crystal-charged", 1), items("ms-crafting-card-underground-belt", 1)),
    recipe("crafting", 1, "ms-crafting-card-utility-science-pack", items("utility-science-pack", 200, "assembling-machine-3", 1, "ms-material-crystal-charged", 1), items("ms-crafting-card-utility-science-pack", 1)),

    recipe("crafting", 1, "ms-smelting-card-copper-plate", items("copper-plate", 100, "electric-furnace", 1, "ms-material-crystal-charged", 1), items("ms-smelting-card-copper-plate", 1)),
    recipe("crafting", 1, "ms-smelting-card-iron-plate", items("iron-plate", 100, "electric-furnace", 1, "ms-material-crystal-charged", 1), items("ms-smelting-card-iron-plate", 1)),
    recipe("crafting", 1, "ms-smelting-card-steel-plate", items("steel-plate", 100, "electric-furnace", 1, "ms-material-crystal-charged", 1), items("ms-smelting-card-steel-plate", 1)),
    recipe("crafting", 1, "ms-smelting-card-stone-brick", items("stone-brick", 100, "electric-furnace", 1, "ms-material-crystal-charged", 1), items("ms-smelting-card-stone-brick", 1)),

    -- TEMPLATES FOR COPY/PASTE
    -- recipe("crafting", 1, "", {}, items("", 1)),
    -- recipe("crafting", 1, "", {}, items("", 1)),
    -- recipe("crafting", 1, "", {}, items("", 1)),
    -- recipe("crafting", 1, "", {}, items("", 1)),
    -- recipe("crafting", 1, "", {}, items("", 1)),
    -- recipe("crafting", 1, "", {}, items("", 1)),
    -- recipe("crafting", 1, "", {}, items("", 1)),
    -- recipe("crafting", 1, "", {}, items("", 1)),
})