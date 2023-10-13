-- translate coords to robot relative
function transformToRelative(x, z)
    local result = { } 
    result.x = math.abs(x) - math.abs(movement.x)
    result.y = math.abs(z) - math.abs(movement.z)
    return result
end