return {
    ["ms-chemical-card-advanced-oil-processing"] = {
        filter = "ms-digital-petroleum-gas",
        input = {["ms-digital-crude-oil"] = 100, ["ms-digital-water"] = 50},
        output = {["ms-digital-petroleum-gas"] = 55, ["ms-digital-heavy-oil"] = 25, ["ms-digital-light-oil"] = 45}
    },
    ["ms-chemical-card-heavy-oil-cracking"] = {
        filter = "ms-digital-light-oil",
        input = {["ms-digital-heavy-oil"] = 40, ["ms-digital-water"] = 30},
        output = {["ms-digital-light-oil"] = 30}
    },
    ["ms-chemical-card-light-oil-cracking"] = {
        filter = "ms-digital-petroleum-gas",
        input = {["ms-digital-light-oil"] = 30, ["ms-digital-water"] = 30},
        output = {["ms-digital-petroleum-gas"] = 20}
    },
    ["ms-chemical-card-lubricant"] = {
        filter = "ms-digital-lubricant",
        input = {["ms-digital-heavy-oil"] = 10},
        output = {["ms-digital-lubricant"] = 10}
    },
    ["ms-chemical-card-sulfuric-acid"] = {
        filter = "ms-digital-sulfuric-acid",
        input = {["iron-plate"] = 1, ["sulfur"] = 5, ["ms-digital-water"] = 100},
        output = {["ms-digital-sulfuric-acid"] = 50}
    }
}