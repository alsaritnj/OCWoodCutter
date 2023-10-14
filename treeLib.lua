local vectors = require("lib/vectors")
local sides = require("/lib/sides")
local robot = require("lib/robot")
local coordsTransform = require("coordsTransform")
local settings = require("settings")
local treeLib = {}

local function getMinBoarder(position)
    return vectors.new2d(
        math.max(position.x - settings.geolyzerRange, 0),
        math.max(position.y - settings.geolyzerRange, 0)
    )
end

local function getMaxBoarder(position)
    return vectors.new2d(
        math.min(position.x + settings.geolyzerRange, settings.area.x),
        math.min(position.y + settings.geolyzerRange, settings.area.y)
    )
end

local function isInArea(vector2d, minBoarder, maxBoarder)
    return (vector2d.x >= minBoarder.x and vector2d.x <= maxBoarder.x) and 
            (vector2d.y >= minBoarder.y and vector2d.y <= maxBoarder.x)
end

function treeLib.getTrees()
    local trees = {
        vectors.new2d(-7, 1),
        vectors.new2d(-7, 6),
        vectors.new2d(-7, 1),

        vectors.new2d(0, 1),
        vectors.new2d(0, -1),
        vectors.new2d(0, 30),

        vectors.new2d(3, 2)
    }
    
    return trees
end

function treeLib.getTreesInArea(position)
    local trees = treeLib.getTrees()
    local treesInArea = {}

    -- calculating either trees zone xor scanned zone is closer. then converting it to relative coord
    local minBoarder = coordsTransform.geolyzerRelative(getMinBoarder(position))
    local maxBoarder = coordsTransform.geolyzerRelative(getMaxBoarder(position))

    for i, tree in pairs(trees) do
        if isInArea(tree, minBoarder, maxBoarder) then
            table.insert(treesInArea, tree)
        end
    end

    return treesInArea
end

function treeLib.getNearestTree(position, distMatrix)
    local trees = treeLib.getTreesInArea(position)

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