local movement = require("/lib/robomvmt")
local vectors = require("/lib/vectors")

local trees = require("trees")
local dm = require("distMatrix")
local settings = require("settings")

require("startUp")

local distMatrix = {}

function main()
    startUp(robotCords, robotDir, areaWidth, areaHeight)
    while true do
        tree = getNearestTree()
        if tree then
            cutTree(tree)
        else
            movement.goCoords(vectors.zero)
            os.sleep(treeGrowingWaitingTime)
        end
    end
end

--main()
-- tests:
startUp(0, 0, 0, 0, 10, 10)
distMatrix = dm.new(settings.areaCenter)
local trees = getTreesInArea()
print(movement.position.x)
print(movement.position.z)
print(settings.areaCenter)
for x, rows in pairs(trees) do
    for z, _ in pairs(rows) do
        print("x = " .. x .. " z = " .. z)
    end
end