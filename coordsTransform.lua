local vectors = require("lib/vectors")
local settings = require("settings")

local coordsTransform = {}

-- translate coords to robot relative
function coordsTransform.robotRelative(coords, position)
    return vectors.new2d(
        math.abs(coords.x) - math.abs(position.x), 
        math.abs(coords.y) - math.abs(position.z)
    )
end

-- transform coords from robot relative to global
function coordsTransform.robotGlobal(coords, position)
    return vectors.new2d(
        coords.x + position.x, 
        coords.y + position.z
    )
end


return coordsTransform