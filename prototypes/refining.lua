return {
    ["ms-chemical-card-advanced-oil-processing"] = {
        input = {["crude-oil"] = 100, ["water"] = 50},
        output = {["petroleum-gas"] = 55, ["heavy-oil"] = 25, ["light-oil"] = 45}
    },
    ["ms-chemical-card-heavy-oil-cracking"] = {
        input = {["heavy-oil"] = 40, ["water"] = 30},
        output = {["light-oil"] = 30}
    },
    ["ms-chemical-card-light-oil-cracking"] = {
        input = {["light-oil"] = 30, ["water"] = 30},
        output = {["petroleum-gas"] = 20}
    },
    ["ms-chemical-card-lubricant"] = {
        input = {["heavy-oil"] = 10},
        output = {["lubricant"] = 10}
    },
    ["ms-chemical-card-sulfuric-acid"] = {
        input = {["iron-plate"] = 1, ["sulfur"] = 5, ["water"] = 100},
        output = {["sulfuric-acid"] = 50}
    }
}