local movement = require("/lib/robomvmt")
local vectors = require("/lib/vectors")

local trees = require("trees")
local dm = require("distMatrix")
local settings = require("settings")

local distMatrix = {}

if settings.area.x > settings.geolyzerRange * 2 or
settings.area.y > settings.geolyzerRange * 2 or
settings.area.x < 1 or settings.area.y < 1 then
    print("error: unavaliable area")
    return
end

settings.areaCenter = vectors.new2d(math.ceil(settings.area.x / 2), math.ceil(settings.area.y / 2))
movement.setCoords(settings.startPosition)

-- startUp(robotCords, robotDir, areaWidth, areaHeight)
-- while true do
--     tree = getNearestTree()
--     if tree then
--         cutTree(tree)
--     else
--         movement.goCoords(vectors.zero)
--         os.sleep(treeGrowingWaitingTime)
--     end
-- end

-- tests:


distMatrix = dm.new(settings.areaCenter)
local trees = trees.getNearestTree(movement.position, settings)
print(movement.position.x)
print(movement.position.z)
print(settings.areaCenter.x)
for x, rows in pairs(trees) do
    for z, _ in pairs(rows) do
        print("x = " .. x .. " z = " .. z)
    end
end