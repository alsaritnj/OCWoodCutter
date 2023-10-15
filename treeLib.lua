local vectors = require("lib/vectors")
local sides = require("/lib/sides")
local robot = require("lib/robot")
local geolyzer = require("lib/geolyzer")
local coordsTransform = require("coordsTransform")
local settings = require("settings")
local treeLib = {}

local function getMinBoarder(position)
    return vectors.new2d(
        math.max(position.x - settings.geolyzerRange, 0),
        math.max(position.z - settings.geolyzerRange, 0)
    )
end

local function getMaxBoarder(position)
    return vectors.new2d(
        math.min(position.x + settings.geolyzerRange, settings.area.x),
        math.min(position.z + settings.geolyzerRange, settings.area.y)
    )
end

local function isInArea(vector2d, minBoarder, maxBoarder)
    return (vector2d.x >= minBoarder.x and vector2d.x <= maxBoarder.x) and 
            (vector2d.y >= minBoarder.y and vector2d.y <= maxBoarder.x)
end

function treeLib.getTrees()
    local trees = {}

    for x = 0, settings.geolyzerRange * 2 do
        local scan = geolyzer.scan(x, -settings.geolyzerRange, 0, 1, settings.geolyzerRange * 2, 1)
        for y = 1, settings.geolyzerRange * 2 do
            if scan[y] >= settings.woodMinHardness then
                table.insert(trees, vectors.new2d(x, y - 1)) -- decrease y, because geolyzer returns array, in which eleemnts' ids begins with 1
            end
        end
    end

    --[[ 
        There is cases in which geolyzer dont scan the part of area it can scan.
        It happens when scaning radius is set to 32(maximum). Geolyzer can scan 65 lines(radius * 2 + (1 block on which robot stands)),
        but it doesn't do it, because it always returns array of 64 blocks
     ]]--
    
    return trees
end

function treeLib.getTreesInArea(position)
    local trees = treeLib.getTrees()
    local treesInArea = {}

    -- calculating either trees zone xor scanned zone is closer
    local minBoarder = getMinBoarder(position)
    local maxBoarder = getMaxBoarder(position)

    for i, tree in pairs(trees) do
        if isInArea(tree, minBoarder, maxBoarder) then
            table.insert(treesInArea, tree)
        end
    end

    return treesInArea
end

function treeLib.getNearestTree(position, distMatrix)
    local trees = treeLib.getTreesInArea(position)

    local nearestTree = trees[1]

    if(not nearestTree) or (not nearestTree.x) or (not nearestTree.y) then
        return nil
    end

    nearestTree = coordsTransform.robotRelative(nearestTree, position)

    for _, tree in pairs(trees) do
        tree = coordsTransform.robotRelative(tree, position)
        if (distMatrix.matrix[tree.x][tree.y] < distMatrix.matrix[nearestTree.x][nearestTree.y]) then
            nearestTree = tree
        end
    end
    return coordsTransform.robotGlobal(nearestTree, position)
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