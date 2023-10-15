local geolyzer = {}
local settings = require("settings")

function geolyzer.scan()
    local arr = {}
    
    local str = "geolyzer: "
    for i = 1, 64 do
        arr[i] = tonumber(string.format("%.1f", (math.random(0, 15) / 10)))
        if i <= settings.geolyzerRange * 2 + 1 then
            str = str .. arr[i] .. "\t"
        end
    end
    print(str)
    return arr
end

return geolyzer