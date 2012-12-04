module(..., package.seeall)

require "array"
require "settings"

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

function info( log_type, message )
    log( log_type, "INFO", message )    
end

function warn( log_type, message )
    log( log_type, "WARN", message )
end

function error( log_type, message )
    log( log_type, "ERROR", message )
end

log( 'log', 'INFO', 'Logging initialized!' ) 
