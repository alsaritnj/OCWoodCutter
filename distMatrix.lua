local distMatrix = {}

distMatrix.matrix = {}

function distMatrix.recalculate(areaCenter)
    distMatrix.matrix = distMatrix.new(areaCenter)
end

function distMatrix.new(areaCenter)
    matrix = {}
    for x = -areaCenter.x, areaCenter.y do
        matrix[x] = {}
        for z = -areaCenter.x, areaCenter.y do
            --[[ "|x| + |z|" is simplified manhattan dist
            since we calculating distance relativly to center(which relative coords is 0, 0),
            the formula looks like "|0 - x| + | 0 - z|" --]]
            matrix[x][z] = math.abs(x) + math.abs(z)
        end
    end
    return matrix
end

return distMatrix
