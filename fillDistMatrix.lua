function fillDistMatrix()
    for x = -area.widthCenter, area.widthCenter do
        distMatrix[x] = {}
        for z = -area.heightCenter, area.heightCenter do
            --[[ "|x| + |z|" is simplified manhattan dist
            since we calculating distance relativly to center(which relative coords is 0, 0),
            the formula looks like "|0 - x| + | 0 - z|" --]]
            distMatrix[x][z] = math.abs(x) + math.abs(z)
        end
    end
end
