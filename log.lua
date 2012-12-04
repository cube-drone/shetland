module(..., package.seeall)

require "array"
require "config"

local log_levels = Array:new( { data={ "ERROR", "WARN", "INFO" } })

function log( log_type, log_level, message, ... )
    if config.log[log_type] then
        local type_level = config.log[log_type]
        local log_log_level = log_levels:indexOf( log_level )
        local display_log_level = log_levels:indexOf( type_level ) 
        if log_log_level <= display_log_level then
            print(string.format("[%s] %s: "..message, log_type, log_level, ...))
        end
    else
	print(string.format("[%s] %s: "..message, log_type, log_level, ...))
    end
end

function info( log_type, message, ... )
    log( log_type, "INFO", message, ... )
end

function warn( log_type, message, ... )
    log( log_type, "WARN", message, ... )
end

function error( log_type, message, ... )
    log( log_type, "ERROR", message, ... )
end

log( 'log', 'INFO', 'Logging initialized!' ) 
