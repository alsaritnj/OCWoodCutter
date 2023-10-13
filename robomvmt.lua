local sides = require("sides")
local robot = require("robot")

local robomvmt = {}

robomvmt.x, robomvmt.y, robomvmt.z, robomvmt.dir = 0, 0, 0, sides.back

function robomvmt.setCoords(x, y, z, dir)
    robomvmt.x = x or 0
    robomvmt.y = y or 0
    robomvmt.z = z or 0
    robomvmt.dir = dir or sides.back
    return robomvmt.x, robomvmt.y, robomvmt.z
end

function robomvmt.translate(x, y, z)
    robomvmt.x = robomvmt.x + x
    robomvmt.y = robomvmt.y + y
    robomvmt.z = robomvmt.z + z
    return robomvmt.x, robomvmt.y, robomvmt.z
end

function robomvmt.turnLeft()
    if robomvmt.dir == sides.back then
        if robot.turn(false) then robomvmt.dir = sides.right return true, robomvmt.dir end
    elseif robomvmt.dir == sides.right then
        if robot.turn(false) then robomvmt.dir = sides.front return true, robomvmt.dir end
    elseif robomvmt.dir == sides.front then
        if robot.turn(false) then robomvmt.dir = sides.left return true, robomvmt.dir end
    elseif robomvmt.dir == sides.left then
        if robot.turn(false) then robomvmt.dir = sides.back return true, robomvmt.dir end
    end
    return false
end

function robomvmt.turnRight()
    if robomvmt.dir == sides.back then
        if robot.turn(false) then robomvmt.dir = sides.left return true, robomvmt.dir end
    elseif robomvmt.dir == sides.right then
        if robot.turn(false) then robomvmt.dir = sides.back return true, robomvmt.dir end
    elseif robomvmt.dir == sides.front then
        if robot.turn(false) then robomvmt.dir = sides.right return true, robomvmt.dir end
    elseif robomvmt.dir == sides.left then
        if robot.turn(false) then robomvmt.dir = sides.front return true, robomvmt.dir end
    end
    return false
end

local function breakBehind()
    robomvmt.turnLeft()
    robomvmt.turnLeft()
    robot.swing(sides.front)
    robomvmt.turnLeft()
    robomvmt.turnLeft()
end

function robomvmt.forward(dist, breakBlocks)
    dist = math.abs(dist) or 1
    for i = 1, dist do
        if robomvmt.dir == sides.back then
            if not robot.move(sides.front) then 
                if breakBlocks then
                    robot.swing(sides.front)
                else
                    return false, i, "Path obstructed"
                end
            end
            robomvmt.translate(0, 0, -1)
        elseif robomvmt.dir == sides.right then
            if not robot.move(sides.front) then
                if breakBlocks then
                    robot.swing(sides.front)
                else
                    return false, i, "Path obstructed"
                end
            end
            robomvmt.translate(-1, 0, 0)
        elseif robomvmt.dir == sides.front then
            if not robot.move(sides.front) then 
                if breakBlocks then
                    robot.swing(sides.front)
                else
                    return false, i, "Path obstructed"
                end
            end
            robomvmt.translate(0, 0, 1)
        elseif robomvmt.dir == sides.left then
            if not robot.move(sides.front) then 
                if breakBlocks then
                    robot.swing(sides.front)
                else
                    return false, i, "Path obstructed"
                end
            end
            robomvmt.translate(1, 0, 0)
        end
    end
    return true, dist
end

function robomvmt.back(dist, breakBlocks)
    dist = math.abs(dist) or 1
    for i = 1, dist do
        if robomvmt.dir == sides.back then
            if not robot.move(sides.back) then
                if breakBlocks then
                    breakBehind()
                else
                    return false, i, "Path obstructed"
                end
            end
            robomvmt.translate(0, 0, 1)
        elseif robomvmt.dir == sides.right then
            if not robot.move(sides.back) then 
                if breakBlocks then
                    breakBehind()
                else
                    return false, i, "Path obstructed"
                end
            end
            robomvmt.translate(1, 0, 0)
        elseif robomvmt.dir == sides.front then
            if not robot.move(sides.back) then 
                if breakBlocks then
                    breakBehind()
                else
                    return false, i, "Path obstructed"
                end
            end
            robomvmt.translate(0, 0, -1)
        elseif robomvmt.dir == sides.left then
            if not robot.move(sides.back) then
                if breakBlocks then
                    breakBehind()
                else
                    return false, i, "Path obstructed"
                end
            end
            robomvmt.translate(-1, 0, 0)
        end
    end
    return true, dist
end

function robomvmt.up(dist, breakBlocks)
    dist = math.abs(dist) or 1
    for i = 1, dist do
        if not robot.move(sides.top) then
            if breakBlocks then
                robot.swing(sides.top)
            else
                return false, i, "Path obstructed"
            end
        end
        robomvmt.translate(0, 1, 0)
    end
    return true, dist
end

function robomvmt.down(dist, breakBlocks)
    dist = math.abs(dist) or 1
    for i = 1, dist do
        if not robot.move(sides.bottom) then
            if breakBlocks then
                robot.swing(sides.bottom)
            else
                return false, i, "Path obstructed"
            end
        end
        robomvmt.translate(0, -1, 0)
    end
    return true, dist
end

function robomvmt.align(dir)
    dir = dir or sides.back
    local i = 1
    while robomvmt.dir ~= dir do
        robomvmt.turnLeft()
        i = i + 1 
        if i > 4 then 
            return false, "Incorrect direction"
        end
    end
    return true
end

function robomvmt.goCoords(x, y, z, order, breakBlocks)
    order = order or "xyz"
    if order:len() ~= 3 then return false, "Order should be of length 3" end
    local dX, dY, dZ = x - robomvmt.x, y - robomvmt.y, z - robomvmt.z
    for dir in order:gmatch("%w") do
        if dir == "x" then
            if dX > 0 then
                robomvmt.align(sides.left)
                robomvmt.forward(dX, breakBlocks)
            elseif dX < 0 then
                robomvmt.align(sides.right)
                robomvmt.forward(dX, breakBlocks)
            end
        elseif dir == "y" then
            if dY > 0 then
                robomvmt.up(dY, breakBlocks)
            elseif dY < 0 then
                robomvmt.down(dY, breakBlocks)
            end
        elseif dir == "z" then
            if dZ > 0 then
                robomvmt.align(sides.front)
                robomvmt.forward(dZ, breakBlocks)
            elseif dZ < 0 then
                robomvmt.align(sides.back)
                robomvmt.forward(dZ, breakBlocks)
            end
        end
    end
    return true
end

return robomvmt