-- recv-pixart (8x8 Plain Text Version)
-- Usage: recv-pixart <logID>

local args = { ... }

if #args < 1 then
    print("Usage: recv-pixart <logID>")
    return
end

local logID = args[1]
local width = 8
local height = 8

-- 1. Map Colors
local colorSlots = {
    ["red"]    = 1,
    ["orange"] = 2,
    ["yellow"] = 3,
    ["green"]  = 4,
    ["blue"]   = 5,
    ["purple"] = 6,
    ["white"]  = 7,
    ["black"]  = 8
}

-- 2. Get Data
print("Connecting to log: " .. logID)
local url = "https://cedar.fogcloud.org/api/logs/" .. logID
local response = http.get(url)

if not response then
    print("Error: Could not connect.")
    return
end

local rawData = response.readAll()
response.close()

-- 3. Parse Data (Reads line by line)
local colors = {}
-- This looks for any text that isn't a newline character
for line in rawData:gmatch("[^\r\n]+") do
    table.insert(colors, line)
end

print("Found " .. #colors .. " pixels.")

if #colors < 64 then
    print("Warning: Found fewer than 64 pixels ("..#colors..").")
    print("The drawing might be incomplete.")
end

-- 4. Draw 8x8
local index = 1

for y = 1, height do
    for x = 1, width do
        
        local colorName = colors[index]
        
        -- Select slot and place
        if colorName and colorSlots[colorName] then
            turtle.select(colorSlots[colorName])
            turtle.placeDown()
        end

        index = index + 1

        -- Move Forward
        if x < width then
            turtle.forward()
        end
    end

    -- Zig-Zag Turn
    if y < height then
        if y % 2 == 1 then
            -- Odd Row (Right Side) -> Turn Left
            turtle.turnLeft()
            turtle.forward()
            turtle.turnLeft()
        else
            -- Even Row (Left Side) -> Turn Right
            turtle.turnRight()
            turtle.forward()
            turtle.turnRight()
        end
    end
end

print("Done!")