local coordsTransform = {}

-- translate coords to robot relative
function coordsTransform.relativeToRobot(coords)
    return {math.abs(coords.x) - math.abs(movement.x), math.abs(coords.y) - math.abs(movement.y)}
end

return coordsTransform