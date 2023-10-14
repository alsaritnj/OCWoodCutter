local coordsTransform = {}

-- translate coords to robot relative
function coordsTransform.relative(coords)
    return {math.abs(coords.x) - math.abs(movement.x), math.abs(coords.y) - math.abs(movement.y)}
end

return coordsTransform