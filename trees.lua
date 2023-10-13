local treeLib = {}

function treeLib.getTrees()
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

function treeLib.getTreesInArea(position, settings)
    local trees = treeLib.getTrees()
    local treesInArea = {}

    -- calculating either trees zone xor scanned zone is closer. then converting it to relative coord
    local xMin = math.max(position.x - settings.geolyzerRange, 0) - settings.areaCenter.x
    local zMin = math.max(position.z - settings.geolyzerRange, 0) - settings.areaCenter.y

    local xMax = math.min(position.x + settings.geolyzerRange, settings.area.x) - settings.areaCenter.x
    local zMax = math.min(position.z + settings.geolyzerRange, settings.area.y) - settings.areaCenter.y

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

function treeLib.getNearestTree(position, settings)
    local trees = getTreesInArea(position, settings)

    local nearestTree = nil
    for x, rows in pairs(trees) do
        for z, _ in pairs(rows) do
            if (not nearestTree or not nearestTree.x or not nearestTree.z) 
                or (distMatrix[x][z] < distMatrix[nearestTree.x][nearestTree.z]) then
                nearestTree = vectors.new3d(x, 0, z)
            end
        end
    end
    
    if nearestTree then
        -- transform to origin coords
        nearestTree = vectors.slice(vectors.add(nearestTree, position))
        return nearestTree
    end 
    return nil, "No trees in specified area"
end

function treeLib.cut(movement)
    movement.up(10, true)
    movement.forward(1, true)
    movement.down(10, true)
    movement.turnLeft()
    movement.turnLeft()
    movement.forward()
    movement.turnLeft()
    movement.turnLeft()
    return true
end

return treeLib