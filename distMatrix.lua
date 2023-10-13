local distMatrix = {}

function distMatrix.new(areaCenter)
    dm = {}
    for x = -areaCenter.x, areaCenter.y do
        dm[x] = {}
        for z = -areaCenter.x, areaCenter.y do
            --[[ "|x| + |z|" is simplified manhattan dist
            since we calculating distance relativly to center(which relative coords is 0, 0),
            the formula looks like "|0 - x| + | 0 - z|" --]]
            dm[x][z] = math.abs(x) + math.abs(z)
        end
    end
    return dm
end

return distMatrix
