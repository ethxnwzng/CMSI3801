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


return {
    find_first = find_first,
    powers_generator = powers_generator,
    count_lines = count_lines,
    say = say
}