local vectors = require("lib/vectors")
local sides = require("/lib/sides")
local robot = require("lib/robot")
local coordsTransform = require("coordsTransform")
local treeLib = {}

local function getMinBoarder(position)
    return coordsTransform.geolyzerRelative(vectors.new2d(
        math.max(position.x - settings.geolyzerRange, 0),
        math.max(position.y - settings.geolyzerRange, 0))
    )
end

local function getMaxBoarder(position)
    return coordsTransform.geolyzerRelative(vectors.new2d(
        math.min(position.x + settings.geolyzerRange, settings.area.x),
        math.min(position.y + settings.geolyzerRange, settings.area.y))
    )
end

function treeLib.getTrees()
    local trees = {}
    trees[-7] = {}
    trees[-7][1] = 1
    trees[-7][6] = 1
    trees[-7][14] = 1

    trees[0] = {}
    trees[0][-1] = 1
    trees[0][1] = 1
    trees[0][10] = 1
    trees[3] = {}
    trees[3][3] = 1
    --trees[6] = {}
    return trees
end

function treeLib.getTreesInArea(position, settings)
    local trees = treeLib.getTrees()
    local treesInArea = {}

    -- calculating either trees zone xor scanned zone is closer. then converting it to relative coord
    local minBoarder = getMinBoarder(position)
    local maxBoarder = getMaxBoarder(position)

    for x, rows in pairs(trees) do
        for y, _ in pairs(rows) do
            if (x >= minBoarder.x and x <= maxBoarder.x) and (y >= minBoarder.y and y <= maxBoarder.x) then
                table.insert(treesInArea, vectors.new2d(x, y))
            end
        end
    end

    return treesInArea
end

function treeLib.getNearestTree(position, settings, distMatrix)
    local trees = treeLib.getTreesInArea(position, settings)

    local nearestTree = nil
    for x, rows in pairs(trees) do
        for z, _ in pairs(rows) do
            if (not nearestTree or not nearestTree.x or not nearestTree.z) 
                or (distMatrix.matrix[x][z] < distMatrix.matrix[nearestTree.x][nearestTree.z]) then
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
    local h = movement.position.y
    while robot.detect(sides.front) do
        movement.up(1, true)
    end
    for i = movement.position.y, h + 1, -1 do
        movement.down(1, false)
        robot.swing(sides.front)
    end
    return true
end

return treeLib