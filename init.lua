local movement = require("/lib/robomvmt")
local vectors = require("/lib/vectors")

local trees = require("trees")
local dm = require("distMatrix")
local settings = require("settings")

require("startUp")

local distMatrix = {}


-- startUp(robotCords, robotDir, areaWidth, areaHeight)
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
startUp({x = 0,  y = 0, z = 0}, 0, 10, 10, settings, movement)
distMatrix = dm.new(settings.areaCenter)
local trees = trees.getTreesInArea(movement.position, settings)
print(movement.position.x)
print(movement.position.z)
print(settings.areaCenter.x)
for x, rows in pairs(trees) do
    for z, _ in pairs(rows) do
        print("x = " .. x .. " z = " .. z)
    end
end