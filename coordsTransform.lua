local vectors = require("lib/vectors")
local settings = require("settings")

local coordsTransform = {}

-- translate coords to robot relative
function coordsTransform.robotRelative(coords, position)
    return vectors.new2d(
        math.abs(coords.x) - math.abs(position.x), 
        math.abs(coords.y) - math.abs(position.y)
    )
end

-- transform coords from robot relative to global
function coordsTransform.robotGlobal(coords, position)
    return vectors.new2d(
        coords.x + position.x, 
        coords.y + position.y
    )
end

--[[ converts from global to geolyzer relative
while global coords begins from 0;0, geolyzer's begins from -geolyzerRange]]--
function coordsTransform.geolyzerRelative(globalCoords)
    return vectors.new2d(
        globalCoords.x - settings.geolyzerRange, 
        globalCoords.y - settings.geolyzerRange
    )
end

return coordsTransform