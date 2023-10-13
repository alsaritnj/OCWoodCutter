-- translate coords to robot relative
function tranformToRelative(x, z)
    return {math.abs(x) - math.abs(movement.x), ath.abs(movement.y) - math.abs(robotY)}
end