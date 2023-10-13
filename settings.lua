local vectors = require("/lib/vectors")
local sides = require("/lib/sides")

return {
    area = vectors.new2d(10, 10),
    scanInterval = 10, -- in seconds
    geolyzerRange = 5 -- default: 32
}