local sides = require("sides")
local vectors = {}

function vectors.new3d(x, y, z)
    return {x = x, y = y, z = z}
end

function vectors.new2d(x, y)
    return {x = x, y = y}
end

vectors.front = vectors.new3d(0, 0, 1),
vectors.back = vectors.new3d(0, 0, -1),
vectors.left = vectors.new3d(1, 0, 0),
vectors.right = vectors.new3d(-1, 0, 0),
vectors.up = vectors.new3d(0, 1, 0),
vectors.down = vectors.new3d(0, -1, 0)

vectors.zero = vectors.new3d(0, 0, 0)
vectors.one = vectors.new3d(1, 1, 1)

for k, v in pairs(sides) do
    vectors.sides[v] = vectors[k]
end


function vectors.mul(a, b)
    return vectors.new3d(a.x * b.x, a.y * b.y, a.z * b.z)
end

function vectors.mulS(a, mul)
    return vectors.new3d(a.x * mul, a.y * mul, a.z * mul)
end

function vectors.add(a, b)
    return vectors.new3d(a.x + b.x, a.y + b.y, a.z + b.z)
end

function vectors.sub(a, b)
    return vectors.new3d(a.x - b.x, a.y - b.y, a.z - b.z)
end

function vectors.invert(a)
    return vectors.mulS(a, -1)
end

function vectors.dist(a, b)
    return math.abs((b.x - a.x) + (b.y - a.y) + (b.z - a.z))
end

function vectors.mag(a)
    return a.x + a.y + a.z
end

return vectors