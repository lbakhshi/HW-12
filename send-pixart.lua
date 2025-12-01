local args = { ... }
if #args < 1 then
    print("Usage: send-pixart <logID>")
    return
end

local logID = args[1]
local url = "https://cedar.fogcloud.org/api/logs/" .. logID
local body = "line=white" 

local function whatColor()
    for i = 1, 8 do    
        local success, data = turtle.inspectDown()
        
        body = "line=white"

        -- 2. Check for colors
        if success and data.name then
            if data.name:find("red") then body = "line=red"
            elseif data.name:find("blue") then body = "line=blue"
            elseif data.name:find("yellow") then body = "line=yellow"
            elseif data.name:find("green") then body = "line=green"
            elseif data.name:find("black") then body = "line=black"
            elseif data.name:find("orange") then body = "line=orange"
            end
        end
        
        print("Sending: " .. body)
        http.post(url, body)
        
        if i < 8 then -- Only move forward if not at the end of the line
            turtle.forward()
        end
    end
end

whatColor()
turtle.turnLeft()
turtle.forward()
turtle.turnLeft()

whatColor()
turtle.turnRight()
turtle.forward()
turtle.turnRight()

whatColor()
turtle.turnLeft()
turtle.forward()
turtle.turnLeft()

whatColor()
turtle.turnRight()
turtle.forward()
turtle.turnRight()

whatColor()
turtle.turnLeft()
turtle.forward()
turtle.turnLeft()

whatColor()
turtle.turnRight()
turtle.forward()
turtle.turnRight()

whatColor()
turtle.turnLeft()
turtle.forward()
turtle.turnLeft()

whatColor()


print("Scan Complete")
