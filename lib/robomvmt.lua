local sides = require("/lib/sides.lua")
local vec = require("/lib/vectors.lua")
local robot = getComponent("robot")

local robomvmt = {}

robomvmt.position, robomvmt.dir = vec.zero, sides.back

function robomvmt.setCoords(pos, dir)
    robomvmt.position = pos
    robomvmt.dir = dir or sides.back
    return robomvmt.position
end

function robomvmt.translate(a)
    robomvmt.position = vec.add(robomvmt.position, a)
    return robomvmt.position
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
        if robot.turn(true) then
            robomvmt.dir = sides.left
            return true, robomvmt.dir
        end
    elseif robomvmt.dir == sides.right then
        if robot.turn(true) then
            robomvmt.dir = sides.back
            return true, robomvmt.dir
        end
    elseif robomvmt.dir == sides.front then
        if robot.turn(true) then
            robomvmt.dir = sides.right
            return true, robomvmt.dir
        end
    elseif robomvmt.dir == sides.left then
        if robot.turn(true) then
            robomvmt.dir = sides.front
            return true, robomvmt.dir
        end
    end
    return false
end

local function step(dir, breakBlocks)
    local status, err = robot.move(sides[dir])
    if status then 
        if breakBlocks then
            robot.swing(sides[dir])
        else
            return false, err
        end
    end
    robomvmt.translate(vec[dir]) 
    return true
end

function robomvmt.forward(dist, breakBlocks)
    dist = math.abs(dist) or 1
    for i = 1, dist do
        status, err = step("front", breakBlocks)
        if not status then return status, i, err end
    end
    return true, dist
end

function robomvmt.up(dist, breakBlocks)
    dist = math.abs(dist) or 1
    for i = 1, dist do
        status, err = step("up", breakBlocks)
        if not status then return status, i, err end
    end
    return true, dist
end

function robomvmt.down(dist, breakBlocks)
    dist = math.abs(dist) or 1
    for i = 1, dist do
        status, err = step("down", breakBlocks)
        if not status then return status, i, err end
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

function robomvmt.goCoords(pos, order, breakBlocks)
    order = order or "xyz"
    local delta = vec.sub(pos, robomvmt.position)
    for dir in order:gmatch("%w") do
        local dist = delta[dir]
        if dir == "y" then
            if dist > 0 then
                robomvmt.up(dY, breakBlocks)
            elseif dist < 0 then
                robomvmt.down(dY, breakBlocks)
            end
        else
            if dist > 0 then
                robomvmt.align(sides[dir])
                robomvmt.forward(d, breakBlocks)
            elseif dist < 0 then
                robomvmt.align(sides["neg"..dir])
                robomvmt.forward(d, breakBlocks)
            end
        end
    end
    return true
end

function robomvmt.goRelative(delta, order, breakBlocks)
    delta = vec.add(delta, robomvmt.position)
    return robomvmt.goCoords(delta, order, breakBlocks)
end

return robomvmt