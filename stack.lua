--堆栈实现
stack = stack or {}

function stack.create()
    local data = {}

    local function push(v)
        assert(v)
        table.insert(data, v)
    end

    local function pop()
        assert(#data > 0)
        table.remove(data)
    end

    local function peek()
        return #data > 0 and data[#data] or nil
    end

    local function clear()
        for i=1,#data do
            data[i] = nil
        end
    end

    

    local __tostring = function()
        local tmp = {}
        for i,v in ipairs(data) do
            tmp[#data+1 - i] = v
        end
        return table.concat(tmp, ",")
    end

    local __index = function(i_t, key)
        error(">> Dee: Limited access")
    end

    local __len = function()
        return #data
    end

    local __newindex = function(i_t, key, v)
        error(">> Dee: Limited access")
    end

    local __ipairs = function()
        error(">> Dee: Limited access")
    end

    local mt = {__tostring = __tostring, __index = __index, __newindex = __newindex, __ipairs = __ipairs, __pairs = __ipairs, __len = __len}

    local t = {
        push = push,
        pop = pop,
        peek = peek,
        clear = clear
    }

    setmetatable(t, mt)

    return t
end

return stack