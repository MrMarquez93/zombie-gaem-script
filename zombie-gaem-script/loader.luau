-- MM93 Hub Loader for Untitled Zombie Gaem
-- Place in StarterPlayer > StarterPlayerScripts

local repo = "https://raw.githubusercontent.com/MrMarquez93/zombie-gaem-script/main/"
local HttpService = game:GetService("HttpService")
local Players = game:GetService("Players")

local LocalPlayer = Players.LocalPlayer
local PlayerGui = LocalPlayer:WaitForChild("PlayerGui")

-- Fetch GUI library
local function loadLib()
    local url = repo .. "lib/init.luau"
    local success, response = pcall(function()
        return game:HttpGet(url)
    end)
    if success then
        local libFunc = loadstring(response)
        return libFunc and libFunc()
    else
        warn("Failed to load GUI library:", response)
        return nil
    end
end

-- Fetch game script
local function loadGameScript(scriptName)
    local url = repo .. "places/" .. scriptName .. ".luau"
    local success, response = pcall(function()
        return game:HttpGet(url)
    end)
    if success then
        local scriptFunc = loadstring(response)
        if scriptFunc then
            coroutine.wrap(scriptFunc)()
        else
            warn("Failed to load game script function")
        end
    else
        warn("Failed to load game script:", response)
    end
end

-- Load index.json to know which script to run
local indexUrl = repo .. "places/index.json"
local success, indexJson = pcall(function()
    return game:HttpGet(indexUrl)
end)

if success then
    local index = HttpService:JSONDecode(indexJson)
    local placeId = tostring(game.PlaceId)
    local scriptFile = index[placeId]
    if scriptFile then
        local guiLib = loadLib()
        loadGameScript(scriptFile)
    else
        warn("Game not supported in MM93 Hub")
    end
else
    warn("Failed to load index.json")
end