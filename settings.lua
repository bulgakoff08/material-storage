-- Material Chest Inventory Size
-- Interface (Chanel A - F) Inventory Size
-- Charged Material Crystal energy value
-- Digital Storage initial volume

local SETTING_MATERIAL_CHEST_SIZE = "ms-material-chest-size"
local SETTING_INTERFACE_CHEST_SIZE = "ms-interface-chest-size"
local SETTING_CRYSTAL_ENERGY_VALUE = "ms-crystal-energy-value"
local SETTING_SOLAR_PANEL_ENERGY_RATE = "ms-solar-panel-energy-rate"
local SETTING_DIGITAL_STORAGE_BASE_VOLUME = "ms-digital-storage-base-volume"
local SETTING_COMBINATORS_PER_BATCH = "ms-combinator-batch-size"

data:extend({
    {
        type = "int-setting",
        name = SETTING_MATERIAL_CHEST_SIZE,
        setting_type = "startup",
        default_value = 150,
        minimum_value = 1,
        maximum_value = 5000
    },
    {
        type = "int-setting",
        name = SETTING_INTERFACE_CHEST_SIZE,
        setting_type = "startup",
        default_value = 10,
        minimum_value = 1,
        maximum_value = 5000
    },
    {
        type = "int-setting",
        name = SETTING_CRYSTAL_ENERGY_VALUE,
        setting_type = "startup",
        default_value = 1000,
        minimum_value = 1,
        maximum_value = 5000
    },
    {
        type = "int-setting",
        name = SETTING_SOLAR_PANEL_ENERGY_RATE,
        setting_type = "startup",
        default_value = 1,
        minimum_value = 1,
        maximum_value = 5000
    },
    {
        type = "int-setting",
        name = SETTING_DIGITAL_STORAGE_BASE_VOLUME,
        setting_type = "startup",
        default_value = 4096,
        minimum_value = 1024,
        maximum_value = 1048576
    },
    {
        type = "int-setting",
        name = SETTING_COMBINATORS_PER_BATCH,
        setting_type = "startup",
        default_value = 25,
        minimum_value = 10,
        maximum_value = 100
    }
})