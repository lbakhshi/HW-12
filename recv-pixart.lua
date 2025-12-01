local args = { ... }

if #args < 1 then
    print("Usage: recv-pixart <logID>")
    return
end

local logID = args[1]
local width = 8
local height = 8

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

print("Connecting to log: " .. logID)
local url = "https://cedar.fogcloud.org/api/logs/" .. logID
local response = http.get(url)

if not response then
    print("Error: Could not connect.")
    return
end

local rawData = response.readAll()
response.close()

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

local index = 1

for y = 1, height do
    for x = 1, width do
        
        local colorName = colors[index]
        
        if colorName and colorSlots[colorName] then
            turtle.select(colorSlots[colorName])
            turtle.placeDown()
        end

        index = index + 1

        if x < width then
            turtle.forward()
        end
    end

    if y < height then
        if y % 2 == 1 then
            -- Odd Row (Right Side) -> Turn Left
            turtle.turnLeft()
            turtle.forward()
            turtle.turnLeft()
        else
            turtle.turnRight()
            turtle.forward()
            turtle.turnRight()
        end
    end
end


print("Done!")
