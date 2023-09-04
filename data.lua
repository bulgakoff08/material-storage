require("prototypes.items")
require("prototypes.entities")
require("prototypes.recipes")

local GRAPHICS_PATH = "__material-storage__/graphics/"

data:extend({
    {
        type = "item-group",
        name = "ms-material-storage",
        icon_size = 128,
        icon = GRAPHICS_PATH .. "material-storage.png",
        inventory_order = "m",
        order = "m-a"
    },
    {
        type = "item-subgroup",
        name = "ms-items",
        group = "ms-material-storage",
        order = "a-a"
    },
    {
        type = "item-subgroup",
        name = "ms-logistics",
        group = "ms-material-storage",
        order = "b-a"
    },
    {
        type = "item-subgroup",
        name = "ms-inserters",
        group = "ms-material-storage",
        order = "d-a"
    },
    {
        type = "item-subgroup",
        name = "ms-pipes",
        group = "ms-material-storage",
        order = "c-a"
    },
    {
        type = "item-subgroup",
        name = "ms-buildings",
        group = "ms-material-storage",
        order = "e-a"
    },
    {
        type = "item-subgroup",
        name = "ms-tiles",
        group = "ms-material-storage",
        order = "f-a"
    },
    {
        type = "item-subgroup",
        name = "ms-modules",
        group = "ms-material-storage",
        order = "g-a"
    },
    {
        type = "item-subgroup",
        name = "ms-fluids",
        group = "ms-material-storage",
        order = "h-a"
    },
    {
        type = "item-subgroup",
        name = "ms-plates",
        group = "ms-material-storage",
        order = "i-a"
    },
    {
        type = "item-subgroup",
        name = "ms-parts",
        group = "ms-material-storage",
        order = "j-a"
    },
    {
        type = "item-subgroup",
        name = "ms-science",
        group = "ms-material-storage",
        order = "k-a"
    },
    {
        type = "item-subgroup",
        name = "ms-military",
        group = "ms-material-storage",
        order = "l-a"
    },
    {
        type = "item-subgroup",
        name = "ms-bees",
        group = "ms-material-storage",
        order = "m-a"
    }
})