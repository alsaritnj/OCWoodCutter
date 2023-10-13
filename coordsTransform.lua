-- translate coords to robot relative
function tranformToRelative(robotX, robotZ, x, z)
    return {math.abs(x) - math.abs(robotX), ath.abs(y) - math.abs(robotY)}
end