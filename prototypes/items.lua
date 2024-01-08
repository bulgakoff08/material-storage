local GRAPHICS_PATH = "__material-storage__/graphics/"

local function item (itemId, stackSize, subgroup)
    return {
        type = "item",
        name = itemId,
        icon = GRAPHICS_PATH .. "icons/" .. itemId .. ".png",
        icon_size = 64,
        subgroup = subgroup,
        stack_size = stackSize
    }
end

local function machine (itemId, stackSize, subgroup)
    local result = item(itemId, stackSize, subgroup)
    result["place_result"] = itemId
    return result
end

data:extend({
    -- items 1st row
    item("ms-crafting-expansion-card-t1", 1, "ms-items"),
    item("ms-crafting-expansion-card-t2", 1, "ms-items"),
    item("ms-crafting-expansion-card-t3", 1, "ms-items"),
    item("ms-ejection-card", 1, "ms-items"),
    item("ms-infinity-water-card", 1, "ms-items"),
    item("ms-material-chest-solar-panel", 1, "ms-items"),
    item("ms-material-crystal", 50, "ms-items"),
    item("ms-material-crystal-charged", 50, "ms-items"),
    item("ms-memory-module-t1", 1, "ms-items"),
    item("ms-memory-module-t2", 1, "ms-items"),
    item("ms-memory-module-t3", 1, "ms-items"),
    item("ms-memory-subnet-card", 1, "ms-items"),
    item("ms-operation-cancelling-card", 1, "ms-items"),
    item("ms-uncrafting-card", 1, "ms-items"),

    -- machines
    machine("ms-material-combinator", 10, "ms-machines"),
    machine("ms-material-logistic-chest", 10, "ms-machines"),
    machine("ms-material-storage", 10, "ms-machines"),
    machine("ms-material-interface-a", 10, "ms-machines"),
    machine("ms-material-interface-b", 10, "ms-machines"),
    machine("ms-material-interface-c", 10, "ms-machines"),
    machine("ms-material-interface-d", 10, "ms-machines"),
    machine("ms-material-interface-e", 10, "ms-machines"),
    machine("ms-material-interface-f", 10, "ms-machines"),

    -- logistics
    item("ms-crafting-card-express-splitter", 1, "ms-logistics"),
    item("ms-crafting-card-express-transport-belt", 1, "ms-logistics"),
    item("ms-crafting-card-express-underground-belt", 1, "ms-logistics"),
    item("ms-crafting-card-fast-splitter", 1, "ms-logistics"),
    item("ms-crafting-card-fast-transport-belt", 1, "ms-logistics"),
    item("ms-crafting-card-fast-underground-belt", 1, "ms-logistics"),
    item("ms-crafting-card-splitter", 1, "ms-logistics"),
    item("ms-crafting-card-transport-belt", 1, "ms-logistics"),
    item("ms-crafting-card-underground-belt", 1, "ms-logistics"),

    -- inserters
    item("ms-crafting-card-fast-inserter", 1, "ms-inserters"),
    item("ms-crafting-card-filter-inserter", 1, "ms-inserters"),
    item("ms-crafting-card-inserter", 1, "ms-inserters"),
    item("ms-crafting-card-long-handed-inserter", 1, "ms-inserters"),
    item("ms-crafting-card-stack-inserter", 1, "ms-inserters"),

    -- pipes
    item("ms-crafting-card-pipe", 1, "ms-pipes"),
    item("ms-crafting-card-pipe-to-ground", 1, "ms-pipes"),

    -- buildings other
    item("ms-crafting-card-assembling-machine-1", 1, "ms-buildings"),
    item("ms-crafting-card-assembling-machine-2", 1, "ms-buildings"),
    item("ms-crafting-card-assembling-machine-3", 1, "ms-buildings"),
    item("ms-crafting-card-electric-furnace", 1, "ms-buildings"),
    item("ms-crafting-card-iron-chest", 1, "ms-buildings"),
    item("ms-crafting-card-medium-electric-pole", 1, "ms-buildings"),
    item("ms-crafting-card-rail", 1, "ms-buildings"),
    item("ms-crafting-card-small-lamp", 1, "ms-buildings"),
    item("ms-crafting-card-steel-chest", 1, "ms-buildings"),

    -- tiles
    item("ms-smelting-card-stone-brick", 1, "ms-tiles"),

    -- modules
    item("ms-crafting-card-speed-module", 1, "ms-modules"),
    item("ms-crafting-card-productivity-module", 1, "ms-modules"),

    -- fluids
    item("ms-digital-crude-oil", 1000, "ms-fluids"),
    item("ms-digital-heavy-oil", 1000, "ms-fluids"),
    item("ms-digital-light-oil", 1000, "ms-fluids"),
    item("ms-digital-lubricant", 1000, "ms-fluids"),
    item("ms-digital-petroleum-gas", 1000, "ms-fluids"),
    item("ms-digital-sulfuric-acid", 1000, "ms-fluids"),
    item("ms-digital-water", 1000, "ms-fluids"),

    item("ms-chemical-card-advanced-oil-processing", 1, "ms-fluids"),
    item("ms-chemical-card-heavy-oil-cracking", 1, "ms-fluids"),
    item("ms-chemical-card-light-oil-cracking", 1, "ms-fluids"),
    item("ms-chemical-card-lubricant", 1, "ms-fluids"),
    item("ms-chemical-card-sulfuric-acid", 1, "ms-fluids"),

    -- plates
    item("ms-smelting-card-copper-plate", 1, "ms-plates"),
    item("ms-smelting-card-iron-plate", 1, "ms-plates"),
    item("ms-smelting-card-steel-plate", 1, "ms-plates"),
    item("ms-chemical-card-solid-fuel-1", 1, "ms-plates"),
    item("ms-chemical-card-solid-fuel-2", 1, "ms-plates"),
    item("ms-chemical-card-solid-fuel-3", 1, "ms-plates"),
    item("ms-chemical-card-plastic-bar", 1, "ms-plates"),
    item("ms-chemical-card-sulfur", 1, "ms-plates"),
    item("ms-chemical-card-battery", 1, "ms-plates"),

    -- parts
    item("ms-crafting-card-copper-cable", 1, "ms-parts"),
    item("ms-crafting-card-iron-stick", 1, "ms-parts"),
    item("ms-crafting-card-iron-gear-wheel", 1, "ms-parts"),
    item("ms-crafting-card-electronic-circuit", 1, "ms-parts"),
    item("ms-crafting-card-advanced-circuit", 1, "ms-parts"),
    item("ms-crafting-card-processing-unit", 1, "ms-parts"),
    item("ms-crafting-card-engine-unit", 1, "ms-parts"),
    item("ms-crafting-card-electric-engine-unit", 1, "ms-parts"),
    item("ms-crafting-card-flying-robot-frame", 1, "ms-parts"),
    item("ms-crafting-card-rocket-control-unit", 1, "ms-parts"),
    item("ms-crafting-card-low-density-structure", 1, "ms-parts"),
    item("ms-crafting-card-rocket-fuel", 1, "ms-parts"),

    -- science
    item("ms-crafting-card-automation-science-pack", 1, "ms-science"),
    item("ms-crafting-card-logistic-science-pack", 1, "ms-science"),
    item("ms-crafting-card-chemical-science-pack", 1, "ms-science"),
    item("ms-crafting-card-production-science-pack", 1, "ms-science"),
    item("ms-crafting-card-utility-science-pack", 1, "ms-science"),
    item("ms-crafting-card-military-science-pack", 1, "ms-science"),

    -- military
    item("ms-crafting-card-firearm-magazine", 1, "ms-military"),
    item("ms-crafting-card-grenade", 1, "ms-military"),
    item("ms-crafting-card-piercing-rounds-magazine", 1, "ms-military"),
    item("ms-crafting-card-stone-wall", 1, "ms-military"),

    -- TEMPLATES FOR COPY/PASTE
    -- item("", 1, "other"),
    -- item("", 1, "other"),
    -- item("", 1, "other"),
    -- item("", 1, "other"),
    -- item("", 1, "other"),
    -- item("", 1, "other"),
})