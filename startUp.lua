function startUp(pos, dir, areaWidth, areaHeight)
    if areaWidth > geolyserMaxRange * 2 or areaHeight > geolyserMaxRange * 2 or areaWidth < 1 or areaHeight < 1 then
        print("error: unavaliable area")
    end

    movement.setCoords(pos, dir)
    area.width = areaWidth
    area.height = areaHeight
    settings.areaCenter = vectors.new2d(math.ceil(settings.area.x / 2), math.ceil(settings.area.y / 2))
end