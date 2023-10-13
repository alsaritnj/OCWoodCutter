local sides = require("sides")
local robot = require("robot")
local vec = require("vectors")

local robomvmt = {}

robomvmt.position, robomvmt.dir = vectors.zero, sides.back

function robomvmt.setCoords(vec, dir)
    robomvmt.position = vec
    robomvmt.dir = dir or sides.back
    return robomvmt.position
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
    robot.turnAround()
    robot.swing(sides.front)
    robot.turnAround()
end

local function step(dir, breakBlocks, translateDir)
    local translateDir = translateDir or robomvmt.dir
    local status, err = robot.move(sides[dir])
    if not status then 
        if breakBlocks then
            robot.swing(sides[dir])
        else
            return false, i, err
        end
    end
    robomvmt.translate(vectors.sides[translateDir])
    return true
end

function robomvmt.forward(dist, breakBlocks)
    dist = math.abs(dist) or 1
    for i = 1, dist do
        status, dist, err = step("front", breakBlocks)
        if not status then return status, dist, err end
    end
    return true, dist
end

function robomvmt.back(dist, breakBlocks)
    turnAround()
    step("front", )
end

function robomvmt.up(dist, breakBlocks)
    dist = math.abs(dist) or 1
    for i = 1, dist do
        status, dist, err = step("up", breakBlocks, sides.up)
        if not status then return status, dist, err end
    end
    return true, dist
end

function robomvmt.down(dist, breakBlocks)
    dist = math.abs(dist) or 1
    for i = 1, dist do
        status, dist, err = step("down", breakBlocks, sides.down)
        if not status then return status, dist, err end
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

function robomvmt.goRelative(dX, dY, dZ, order, breakBlocks)
    dX, dY, dZ = dX + robomvmt.x, dY + robomvmt.y, dZ + robomvmt.z
    return robomvmt.goCoords(dX, dY, dZ, order, breakBlocks)
end

return robomvmt