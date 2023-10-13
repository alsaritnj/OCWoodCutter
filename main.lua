local movement = require("/lib/robomvmt.lua")
local vectors = require("/lib/vectors.lua")

local treelib = require("trees.lua")
local dm = require("distMatrix.lua")
local settings = require("settings.lua")

local distMatrix = {}


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

if settings.area.x > settings.geolyzerRange * 2 or
settings.area.y > settings.geolyzerRange * 2 or
settings.area.x < 1 or settings.area.y < 1 then
    error("unavaliable area")    
end

settings.areaCenter = vectors.new2d(math.ceil(settings.area.x / 2), math.ceil(settings.area.y / 2))

distMatrix = dm.new(settings.areaCenter)
local trees = treelib.getTreesInArea(movement.position, settings)
print(movement.position.x)
print(movement.position.z)
print(settings.areaCenter.x)
for x, rows in pairs(trees) do
    for z, _ in pairs(rows) do
        print("x = " .. x .. " z = " .. z)
    end
end
treelib.cut(movement)