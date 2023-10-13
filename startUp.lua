local vectors = require("lib/vectors")

function startUp(pos, dir, areaWidth, areaHeight, settings, movement)
    if areaWidth > settings.geolyzerRange * 2 or areaHeight > settings.geolyzerRange * 2 or areaWidth < 1 or areaHeight < 1 then
        print("error: unavaliable area")
    end


    movement.setCoords(pos, dir)
    settings.area.width = areaWidth
    settings.area.height = areaHeight
    settings.areaCenter = vectors.new2d(math.ceil(settings.area.x / 2), math.ceil(settings.area.y / 2))
end