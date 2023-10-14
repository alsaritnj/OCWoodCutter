local sides = require("lib/sides.lua")

local vectors = {}

function vectors.new3d(x, y, z)
    return {x = x, y = y, z = z}
end

function vectors.new2d(x, y)
    return {x = x, y = y}
end

vectors.front = vectors.new3d(0, 0, 1)
vectors.back = vectors.new3d(0, 0, -1)
vectors.left = vectors.new3d(1, 0, 0)
vectors.right = vectors.new3d(-1, 0, 0)
vectors.up = vectors.new3d(0, 1, 0)
vectors.down = vectors.new3d(0, -1, 0)

vectors.x = vectors.left
vectors.y = vectors.up
vectors.z = vectors.front
vectors.negx = vectors.right
vectors.negy = vectors.down
vectors.negz = vectors.back

vectors.zero = vectors.new3d(0, 0, 0)
vectors.one = vectors.new3d(1, 1, 1)

for k, v in pairs(sides) do
    vectors.sides = {}
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

function vectors.manhattan(a, b)
    return math.abs(a.x - b.x) + math.abs(a.y - b.y) + math.abs(a.z - b.z)
end

function vectors.euclidean(a, b)
    return math.sqrt((a.x - b.x) ^ 2 + (a.y - b.y) ^ 2 + (a.z - b.z) ^ 2)
end

function vectors.mag(a)
    return a.x + a.y + a.z
end

function vectors.slice(a, pattern)
    pattern = pattern or "xz"
    result = {}
    for dim in pattern:gmatch("%w") do
        result[dim] = a[dim] or 0
    end
    return result
end

function vectors.each(a, callback)
    b = {}
    for dim in pairs(a) do
        b[dim] = callback(a, dim)
    end
    return b
end

return vectors