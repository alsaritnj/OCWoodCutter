-- Placeholder library

local robot = {}

function robot.turn()
    print("robot.turn")
    return true
end

function robot.swing()
    print("robot.swing")
    return true
end

function robot.move()
    print("robot.move")
    return true
end

robot.debug = {} -- TODO: Fill this with tests

return robot
