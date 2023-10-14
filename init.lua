do
    function getComponent(name)
        return component.proxy(component.list(name)())
    end

    local eeprom = getComponent("eeprom")
    local fs = component.proxy(eeprom.getData())
    
    local gpu = getComponent("gpu")
    local screen = getComponent("screen")
    gpu.bind(screen.address)
    local rx, ry = gpu.getResolution()
    
    local line, cg = 1, 1
    local callstack = {"/init.lua"}
    local lc = ""

    function readall(fp)
        local str = ""
        while true do
            v = fs.read(fp, 128)
            if not v then break end
            str = str..v
        end
        return str
    end

    function table.str(tbl, sep)
        str = ""
        for _, v in pairs(tbl) do
            str = str..v..sep
        end
        return str:sub(1, #str - #sep)
    end

    function require(path)
        table.insert(callstack, path)
        local file, err = fs.open(path, "rb")
        if not file then error(err) end
        local code = readall(file)
        fs.close(file)
        lc = code
        local f, err = load(code)
        if f then
            local ok, cb = pcall(f)
            if ok then
                table.remove(callstack, #callstack)
                return cb
            end
            error("Runtime error: "..cb)
        else
            error(err)
        end
    end

    local function splitByChunk(text, chunkSize)
        local s = {}
        text = tostring(text)
        for i = 1, #text, chunkSize do
            s[#s + 1] = text:sub(i, i + chunkSize - 1)
        end
        return s
    end

    function split(str, char)
        local tbl = {}
        str:gsub("[^"..char.."]+", function(x) tbl[#tbl+1]=x end)
        return tbl
    end

    function clear() 
        gpu.fill(1, 1, rx, ry, " ")
    end

    function print(...)
        local values = {...}
        for _, data in ipairs(values) do
            for i, v in ipairs(splitByChunk(data, 1)) do
                if line == ry then
                    line = 1
                    cg = 1
                    computer.pullSignal("touch")
                    clear()
                end
                if cg > rx then
                    line = line + 1
                    cg = 1
                end
                if v == "\n" then
                    line = line + 1
                    cg = 1
                else
                    gpu.set(cg, line, v)
                    cg = cg + 1
                end
            end
        end
        line = line + 1
        cg = 1
    end

    function error(data, exception)
        exception = exception or "panic"
        data = exception..": "..debug.traceback()..": "..table.str(callstack, " -> ")..": "..data.."\n------- code dump -------\n"..lc
        --data = split(data, "\n")
        --data = splitByChunk(data, rx)
        print(data)
        while true do
            computer.pullSignal()
        end
    end

    require("/main.lua")
    print("[program ended]")
    while true do
        computer.pullSignal()
    end
end