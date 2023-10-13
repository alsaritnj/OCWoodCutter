movement = require("robomvmt")
require("treeSearch")
require("startUp")
require("fillDistMatrix")

treeGrowingWaitingTime = 10;
geolyserMaxRange = 5 -- default 32
area = {}
distMatrix = {}

function main()
    startUp(robotCords, robotDir, areaWidth, areaHeight)
    while true do
        trea = getNearestTree()
        if trea then
            cutTheTree(trea)
        else
            goToCenter()
            os.sleep(treeGrowingWaitingTime)
        end
    end
end

--main()
-- tests:
startUp(0, 0, 0, 0, 10, 10)
fillDistMatrix()
local trees = getTreesInArea()
print(movement.position.x)
print(movement.position.z)
print(area.widthCenter)
for x, rows in pairs(trees) do
    for z, _ in pairs(rows) do
        print("x = " .. x .. " z = " .. z)
    end
end