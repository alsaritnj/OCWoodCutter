local movement = require("/lib/robomvmt")
local vectors = require("/lib/vectors")

local treelib = require("treeLib")
local distMatrix = require("distMatrix")
local settings = require("settings")

if settings.area.x > settings.geolyzerRange * 2 or
        settings.area.y > settings.geolyzerRange * 2 or
        settings.area.x < 1 or settings.area.y < 1 then
    error("unavaliable area")    
end

settings.areaCenter = vectors.new2d(math.ceil(settings.area.x / 2), math.ceil(settings.area.y / 2))

distMatrix.recalculate(settings.areaCenter)

movement.setCoords(settings.startPosition)

-- while true do
--     tree = getNearestTree()
--     if tree then
--         cutTree(tree)
--     else
--         movement.goCoords(vectors.zero)
--         os.sleep(treeGrowingWaitingTime)
--     end
-- end

-- tests:

math.randomseed(os.clock())
print("robot x = " .. movement.position.x .. "\trobot z = " .. movement.position.z .. "\tscaning zone = " .. settings.geolyzerRange .. "\tarea center = " .. settings.areaCenter.x)

local tree = treelib.getNearestTree(movement.position, distMatrix)
print("nearest tree: x = " .. tree.x .. " z = " .. tree.y)