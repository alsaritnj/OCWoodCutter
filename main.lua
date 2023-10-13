movement = require("robomvmt")

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

function getTrees()
    local trees = {}
    trees[-7] = {}
    trees[-7][1] = 1
    trees[-7][6] = 1
    trees[-7][14] = 1

    trees[0] = {}
    trees[0][-1] = 1
    trees[0][3] = 1
    trees[0][10] = 1
    --trees[3] = {}
    --trees[6] = {}
    return trees
end

function getTreesInArea()
    local trees = getTrees()
    local treesInArea = {}

    -- calculating either trees zone xor scanned zone is closer. then converting it to relative coord
    xMin = math.max(movement.x - geolyserMaxRange, 0) - area.widthCenter
    zMin = math.max(movement.z - geolyserMaxRange, 0) - area.heightCenter

    xMax = math.min(movement.x + geolyserMaxRange, area.width) - area.widthCenter
    zMax = math.min(movement.z + geolyserMaxRange, area.height) - area.heightCenter

    for x, rows in pairs(trees) do
        treesInArea[x] = {}
        for z, _ in pairs(rows) do
            if (x >= xMin and x <= xMax) and (z >= zMin and z <= zMax) then
                treesInArea[x][z] = 1
            end
        end
    end

    return treesInArea
end

function getNearestTree()
    local trees = getTreesInArea()

    nearestTree = {}
    for x, rows in pairs(trees) do
        for z, _ in pairs(rows) do
            if (not nearestTree.x or not nearestTree.z) 
                or (distMatrix[x][z] < distMatrix[nearestTree.x][nearestTree.z]) then
                nearestTree.x = x
                nearestTree.z = z
            end
        end
    end

    
    if not nearestTree.x and not nearestTree.z then
        -- transfer to global coords
        nearestTree.x = nearestTree.x + movement.x
        nearestTree.z = nearestTree.z + movement.z

        return nearestTree
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