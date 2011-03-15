---------------------------------------------------
-- Licensed under the GNU General Public License v2
--  * (c) 2010, Adrian C. <anrxc@sysphere.org>
---------------------------------------------------

-- {{{ Grab environment
local tonumber = tonumber
local tostring = tostring
local setmetatable = setmetatable
local io = { popen = io.popen }
local string = { 
	format = string.format,
	gsub = string.gsub
}
local helpers = require("ovicious.helpers")
local math = {
    min = math.min,
    floor = math.floor
}
-- }}}


-- Bat: provides state, charge, and remaining time for a requested battery
module("ovicious.widgets.bat")


-- {{{ Battery widget type
local function worker(format, warg)
	local b = io.popen( 'apm -a' )
    local bs = b:read("*all")

    local p = io.popen( 'apm -l' )
    local percent = p:read("*all")
	percent = string.gsub( percent, "\n", "" )
	percent = string.gsub( percent, "\r", "" )

    local t = io.popen( 'apm -m' )
    local time = t:read("*all")

    local battery_state = {
        ["255\n"]	= "⌁",
        ["1\n"]		= "+",
        ["0\n"]		= "-"
    }

    -- Get state information
    local state = battery_state[bs]

    return {state, percent, time}
end
-- }}}

setmetatable(_M, { __call = function(_, ...) return worker(...) end })
