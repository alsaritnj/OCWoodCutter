function startUp(x, y, z, dir, areaWidth, areaHeight)
    if areaWidth > geolyserMaxRange * 2 or areaHeight > geolyserMaxRange * 2 or areaWidth < 1 or areaHeight < 1 then
        print("error: unavaliable area")
    end

    movement.setCoords(x, y, z, dir)
    area.width = areaWidth
    area.height = areaHeight
    area.widthCenter = math.ceil(areaWidth / 2)
    area.heightCenter = math.ceil(areaHeight / 2)
end