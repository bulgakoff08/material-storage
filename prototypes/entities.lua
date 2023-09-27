local GRAPHICS_PATH = "__material-storage__/graphics/"
local SETTING_MATERIAL_CHEST_SIZE = "ms-material-chest-size"
local SETTING_INTERFACE_CHEST_SIZE = "ms-interface-chest-size"

local function generateMaterialCombinator (prototype)
    prototype.sprites = make_4way_animation_from_spritesheet({
        layers = {
           {
               scale = 0.5,
               filename = GRAPHICS_PATH .. "entities/material-combinator.png",
               width = 114,
               height = 102,
               frame_count = 1,
               shift = util.by_pixel(0, 5)
           },
           {
               scale = 0.5,
               filename = GRAPHICS_PATH .. "entities/material-combinator-shadow.png",
               width = 98,
               height = 66,
               frame_count = 1,
               shift = util.by_pixel(8.5, 5.5),
               draw_as_shadow = true
           }
       }
    })
    prototype.activity_led_sprites = {
        north = util.draw_as_glow({
            scale = 0.5,
            filename = "__base__/graphics/entity/combinator/activity-leds/hr-constant-combinator-LED-N.png",
            width = 14,
            height = 12,
            frame_count = 1,
            shift = util.by_pixel(9, -11.5)
        }),
        east = util.draw_as_glow({
            scale = 0.5,
            filename = "__base__/graphics/entity/combinator/activity-leds/hr-constant-combinator-LED-E.png",
            width = 14,
            height = 14,
            frame_count = 1,
            shift = util.by_pixel(7.5, -0.5)
        }),
        south = util.draw_as_glow({
            scale = 0.5,
            filename = "__base__/graphics/entity/combinator/activity-leds/hr-constant-combinator-LED-S.png",
            width = 14,
            height = 16,
            frame_count = 1,
            shift = util.by_pixel(-9, 2.5)
        }),
        west = util.draw_as_glow({
            scale = 0.5,
            filename = "__base__/graphics/entity/combinator/activity-leds/hr-constant-combinator-LED-W.png",
            width = 14,
            height = 16,
            frame_count = 1,
            shift = util.by_pixel(-7, -15)
        })
    }
    prototype.circuit_wire_connection_points = {
        {
            shadow = {red = util.by_pixel(7, -6), green = util.by_pixel(23, -6)},
            wire = {red = util.by_pixel(-8.5, -17.5), green = util.by_pixel(7, -17.5)}
        },
        {
            shadow = {red = util.by_pixel(32, -5), green = util.by_pixel(32, 8)},
            wire = {red = util.by_pixel(16, -16.5), green = util.by_pixel(16, -3.5)}
        },
        {
            shadow = {red = util.by_pixel(25, 20), green = util.by_pixel(9, 20)},
            wire = {red = util.by_pixel(9, 7.5), green = util.by_pixel(-6.5, 7.5)}
        },
        {
            shadow = {red = util.by_pixel(1, 11), green = util.by_pixel(1, -2)},
            wire = {red = util.by_pixel(-15, -0.5), green = util.by_pixel(-15, -13.5)}
        }
    }
    return prototype
end

local function createMaterialInterface (identifier, linkId)
    return {
        type = "linked-container",
        name = "ms-material-interface-" .. identifier,
        icon = GRAPHICS_PATH .. "icons/ms-material-interface-" .. identifier .. ".png",
        icon_size = 64,
        flags = {"placeable-neutral", "player-creation"},
        minable = {
            mining_time = 0.5,
            results = {
                {type = "item", name = "ms-material-interface-" .. identifier, amount = 1}
            }
        },
        max_health = 250,
        corpse = "iron-chest-remnants",
        dying_explosion = "iron-chest-explosion",
        vehicle_impact_sound = {filename = "__base__/sound/car-metal-impact.ogg", volume = 0.65},
        resistances = {
            {type = "fire", percent = 90},
            {type = "explosion", percent = 30},
            {type = "impact", percent = 30}
        },
        collision_box = {{-0.35, -0.35}, {0.35, 0.35}},
        selection_box = {{-0.5, -0.5}, {0.5, 0.5}},
        picture = {
            layers = {
                {
                    filename = GRAPHICS_PATH .. "entities/material-interface-" .. identifier .. ".png",
                    priority = "extra-high",
                    width = 66,
                    height = 76,
                    shift = util.by_pixel(-0.5, -0.5),
                    scale = 0.5
                },
                {
                    filename = GRAPHICS_PATH .. "entities/material-interface-shadow.png",
                    priority = "extra-high",
                    width = 110,
                    height = 50,
                    shift = util.by_pixel(10.5, 6),
                    draw_as_shadow = true,
                    scale = 0.5
                }
            }
        },
        link_id = linkId,
        inventory_size = settings.startup[SETTING_INTERFACE_CHEST_SIZE].value,
        inventory_type = "with_filters_and_bar",
        gui_mode = "none",
        circuit_wire_connection_point = circuit_connector_definitions["chest"].points,
        circuit_connector_sprites = circuit_connector_definitions["chest"].sprites,
        circuit_wire_max_distance = default_circuit_wire_max_distance,
        open_sound = {filename = "__base__/sound/machine-open.ogg", volume = 0.85},
        close_sound = {filename = "__base__/sound/machine-close.ogg", volume = 0.75}
    }
end

data:extend({
    {
        type = "linked-container",
        name = "ms-material-storage",
        icon = GRAPHICS_PATH .. "icons/ms-material-storage.png",
        icon_size = 64,
        flags = {"placeable-neutral", "player-creation"},
        minable = {
            mining_time = 0.5,
            results = {
                {type = "item", name = "ms-material-storage", amount = 1}
            }
        },
        max_health = 250,
        corpse = "iron-chest-remnants",
        dying_explosion = "iron-chest-explosion",
        resistances = {
            {type = "fire", percent = 90},
            {type = "explosion", percent = 30},
            {type = "impact", percent = 30}
        },
        collision_box = {{-0.35, -0.35}, {0.35, 0.35}},
        selection_box = {{-0.5, -0.5}, {0.5, 0.5}},
        picture = {
            layers = {
                {
                    filename = GRAPHICS_PATH .. "entities/material-storage.png",
                    priority = "extra-high",
                    width = 66,
                    height = 74,
                    shift = util.by_pixel(-0.5, -0.5),
                    scale = 0.5
                },
                {
                    filename = GRAPHICS_PATH .. "entities/material-storage-shadow.png",
                    priority = "extra-high",
                    width = 112,
                    height = 46,
                    shift = util.by_pixel(12, 4.5),
                    draw_as_shadow = true,
                    scale = 0.5
                }
            }
        },
        link_id = 4910,
        inventory_size = settings.startup[SETTING_MATERIAL_CHEST_SIZE].value,
        inventory_type = "with_filters_and_bar",
        gui_mode = "none",
        circuit_wire_connection_point = circuit_connector_definitions["chest"].points,
        circuit_connector_sprites = circuit_connector_definitions["chest"].sprites,
        circuit_wire_max_distance = default_circuit_wire_max_distance,
        vehicle_impact_sound = {filename = "__base__/sound/car-metal-impact.ogg", volume = 0.65},
        open_sound = {filename = "__base__/sound/machine-open.ogg", volume = 0.85},
        close_sound = {filename = "__base__/sound/machine-close.ogg", volume = 0.75}
    },
    generateMaterialCombinator({
        type = "constant-combinator",
        name = "ms-material-combinator",
        icon = GRAPHICS_PATH .. "icons/ms-material-combinator.png",
        icon_size = 64, icon_mipmaps = 4,
        flags = {"placeable-neutral", "player-creation"},
        minable = {mining_time = 0.1, result = "ms-material-combinator"},
        max_health = 120,
        corpse = "constant-combinator-remnants",
        dying_explosion = "constant-combinator-explosion",
        collision_box = {{-0.35, -0.35}, {0.35, 0.35}},
        selection_box = {{-0.5, -0.5}, {0.5, 0.5}},
        fast_replaceable_group = "constant-combinator",
        activity_led_light_offsets = {
            {0.296875, -0.40625},
            {0.25, -0.03125},
            {-0.296875, -0.078125},
            {-0.21875, -0.46875}
        },
        item_slot_count = 2000,
        circuit_wire_max_distance = default_circuit_wire_max_distance,
        vehicle_impact_sound = {filename = "__base__/sound/car-metal-impact.ogg", volume = 0.65},
        open_sound = {filename = "__base__/sound/machine-open.ogg", volume = 0.85},
        close_sound = {filename = "__base__/sound/machine-close.ogg", volume = 0.75}
    }),
    createMaterialInterface("a", 4910),
    createMaterialInterface("b", 4911),
    createMaterialInterface("c", 4912),
    createMaterialInterface("d", 4913),
    createMaterialInterface("e", 4914),
    createMaterialInterface("f", 4915)
})