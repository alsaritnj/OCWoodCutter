movement = require("robomvmt")
require("treeSearch")

treeGrowingWaitingTime = 10;
geolyserMaxRange = 5 -- default 32
area = {}
distMatrix = {}

function startUp(x, y, z, dir, areaWidth, areaHeight)
    if areaWidth > geolyserMaxRange * 2 or areaHeight > geolyserMaxRange * 2 or areaWidth < 1 or areaHeight < 1 then
        print("error: unavaliable area")
    end

    movement.setCoords(x, y, z, dir)
    area.width = areaWidth
    area.height = areaHeight
    area.widthCenter = math.ceil(areaWidth / 2)
    area.heightCenter = math.ceil(areaHeight / 2)
end

function fillDistMatrix()
    for x = -area.widthCenter, area.widthCenter do
        distMatrix[x] = {}
        for z = -area.heightCenter, area.heightCenter do
            --[[ "|x| + |z|" is simplified manhattan dist
            since we calculating distance relativly to center(which relative coords is 0, 0),
            the formula looks like "|0 - x| + | 0 - z|" --]]
            distMatrix[x][z] = math.abs(x) + math.abs(z)
        end
    end
end



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
startUp(0, 0, 0, 0, 10, 10)
fillDistMatrix()
local trees = getTreesInArea()
print(movement.x)
print(movement.z)
print(area.widthCenter)
for x, rows in pairs(trees) do
    for z, _ in pairs(rows) do
        print("x = " .. x .. " z = " .. z)
    end
end