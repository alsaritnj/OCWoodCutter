local geolyzer = {}
local settings = require("settings")

function geolyzer.scan()
    local arr = {}
    
    local str = "geolyzer: "
    for i = 1, 64 do
        arr[i] = tonumber(string.format("%.1f", (math.random(0, 15) / 10)))
        str = str .. arr[i] .. "\t"
    end
    print(str)
    return arr
end

return geolyzer