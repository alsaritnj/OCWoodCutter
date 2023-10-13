require("coordsTransform")

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
    trees[-4] = {}
    trees[-4][-4] = 1
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
            local treeRelative = transformToRelative(x, z)
            if (not nearestTree.x or not nearestTree.z) 
                or (distMatrix[treeRelative.x][treeRelative.z] < 
                distMatrix[nearestTree.x][nearestTree.z]) then
                nearestTree.x = x
                nearestTree.z = z
            end
        end
    end

    print("x = " .. nearestTree.x .. " z = " .. nearestTree.z)

    if nearestTree.x and nearestTree.z then
        -- transfer to global coords
        nearestTree.x = nearestTree.x + movement.x
        nearestTree.z = nearestTree.z + movement.z

        return nearestTree
    end 
end