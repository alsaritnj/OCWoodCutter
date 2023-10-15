local geolyzer = {}

function geolyzer.scan()
    local arr = {}
    print("geolyzer.scan()")
    for i = -32, 32 do
        arr[i] = 0
    end
    return arr
end