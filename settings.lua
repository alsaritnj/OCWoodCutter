local vectors = require("/lib/vectors.lua")
local sides = require("/lib/sides.lua")

return {
    area = vectors.new2d(10, 10),
    scanInterval = 10, -- in seconds
    geolyzerRange = 5, -- default: 32
    startPosition = vectors.new3d(5, 0, 5)
}