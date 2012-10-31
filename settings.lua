module(..., package.seeall)

local settingsFile = MOAIEnvironment.documentDirectory .. "\\settings.lua" 

local defaultSettings = [[

-- Here are some settings! 
settings = { }
settings['log'] = {}
settings['log']['input'] = "ERROR"

]]

local function writeDefaultSettings()
    print("[settings] Writing settings to " .. settingsFile)
    local stream = MOAIFileStream.new()
    stream:open(settingsFile, MOAIFileStream.READ_WRITE_NEW)
    stream:write(defaultSettings)
    stream:flush()
    stream:close()
end

local local_settings = nil

function load()
    if not local_settings then
        local status, err = pcall(loadfile(settingsFile))
        if (not status) then
            print("[settings] " .. err )
            writeDefaultSettings()
            pcall(loadfile(settingsFile))
        end
        local_settings = settings 
    end
    return local_settings
end
