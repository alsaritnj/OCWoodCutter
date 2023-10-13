-- translate coords to robot relative
function transformToRelative(x, z)
    return {math.abs(x) - math.abs(movement.x), math.abs(movement.y) - math.abs(robotY)}
end