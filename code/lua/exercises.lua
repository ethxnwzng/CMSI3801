--written by Ethan Wong
-- function that finds first element in a satisfying predicate p
function find_first(a, p)
    for i, element in ipairs(a) do
        if p(element) then
            return element
        end
    end
    return nil -- non existence
end 

-- generator for powers of base 
function powers_generator(base, limit)
    local current = 1
    return function()
        if current <= limit then
            local result = current
            current = current * base
            return result
        else
            return nil
        end
    end
end

-- count non-empty, non-comment lines in a file
function count_lines(filename)
    local file = io.open(filename, "r")
    if not file then
        return 0
    end

    local count = 0
    for line in file:lines() do
        if line:match("%S") then 
            local first_non_space = line:match("^%s*(.)")
            if first_non_space ~= "#" then
                count = count + 1
            end
        end
    end

    file:close()
    return count
end

-- sentence builder
function say(word)
    local words = {}

    if word then 
        table.insert(words, word)
    end

    local function chain(next_word)
        if next_word then
            table.insert(words, next_word)
            return chain
        else
            return table.concat(words, " ")
        end
    end

    return chain
end

--quaternion datatype, help from https://www.lua.org/pil/16.1.html
local Quaternion = {}
Quaternion.__index = Quaternion --so the quaternion inherits everything from the metatable in the constructor

function Quaternion.new(w, x, y, z) -- constructor
    local self = setmetatable({}, Quaternion) -- metatable representing Quaternion vals like a vector with a scalar
    self.w = w or 0 --scalar
    self.x = x or 0 -- i j and k
    self.y = y or 0
    self.z = z or 0

    return self
end

function Quaternion:add(other) --sum this quaternion with another
    return Quaternion.new(
        self.w + other.w,
        self.x + other.x,
        self.y + other.y,
        self.z + other.z
    )
end

function Quaternion:multiply(other)
    --i^2 = j^2 = k^2 = ijk = -1, then:
    --ij = k, jk = i, ki = j, or ji = -k, kj = -i, ik = -j
    local w = self.w * other.w - self.x * other.x - self.y * other.y - self.z * other.z
    local x = self.w * other.x + self.x * other.w + self.y * other.z - self.z * other.y
    local y = self.w * other.y - self.x * other.z + self.y * other.w + self.z * other.x
    local z = self.w * other.z + self.x * other.y - self.y * other.x + self.z * other.w
    return Quaternion.new(w, x, y, z)
end

function Quaternion:coefficients()
    return {self.w, self.x, self.y, self.z}
end

function Quaternion:conjugate() -- a + bi + cj + dk (DONKEY KONG) = a - bi - cj - dk (DONKEY KONG)
    return Quaternion.new(self.w, -self.x, -self.y, -self.z)
end

function Quaternion:__eq(other)
    return self.w == other.w and self.x == other.x and self.y == other.y and self.z == other.z 
end

function Quaternion:__toString()
    return string.format("Quaternion(%.2f, %.2f, %.2f, %.2f)",   --https://www.lua.org/pil/2.4.html
                        self.w, self.x, self.y, self.z)
end
    
return {
    find_first = find_first,
    powers_generator = powers_generator,
    count_lines = count_lines,
    say = say,
    Quaternion = Quaternion
}