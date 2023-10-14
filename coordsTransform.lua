local coordsTransform = {}

-- translate coords to robot relative
function coordsTransform.relative(x, z)
    return {math.abs(x) - math.abs(movement.x), math.abs(y) - math.abs(movement.y)}
end

return coordsTransform