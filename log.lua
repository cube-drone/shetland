module(..., package.seeall)

require "array"
require "settings"

settings = settings.load()

local log_levels = Array:new( { data={ "ERROR", "WARN", "INFO" } })

function log( log_type, log_level, message )
    if settings['log'][log_type] then
        local type_level = settings['log'][log_type]
        local log_log_level = log_levels:indexOf( log_level )
        local display_log_level = log_levels:indexOf( type_level ) 
        if log_log_level <= display_log_level then
            print( "["..log_type.."]".." "..log_level..": "..message )
        end
    else
        print( "["..log_type.."]".." "..log_level..": "..message )
    end
end

log( 'log', 'INFO', 'Logging initialized!' ) 
