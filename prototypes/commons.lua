return {
    itemType = function (itemId)
        if itemId == "water" then
            return "fluid"
        end
        if itemId == "crude-oil" then
            return "fluid"
        end
        if itemId == "heavy-oil" then
            return "fluid"
        end
        if itemId == "light-oil" then
            return "fluid"
        end
        if itemId == "lubricant" then
            return "fluid"
        end
        if itemId == "petroleum-gas" then
            return "fluid"
        end
        if itemId == "sulfuric-acid" then
            return "fluid"
        end
        return "item"
    end
}