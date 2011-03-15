---------------------------------------------------
-- Licensed under the GNU General Public License v2
--  * (c) 2010, Adrian C. <anrxc@sysphere.org>
---------------------------------------------------

-- {{{ Grab environment
local tonumber = tonumber
local io = { popen = io.popen }
local setmetatable = setmetatable
local string = { match = string.match }
local helpers = require("ovicious.helpers")
-- }}}


-- Volume: provides volume levels and state of requested ALSA mixers
module("ovicious.widgets.volume")


-- {{{ Volume widget type
local function worker(format, warg)
    if not warg then return end

    local mixer_state = {
        ["on"]  = "♫", -- "",
        ["off"] = "♩"  -- "M"
    }

    -- Get mixer control contents
    local f = io.popen("mixerctl " .. warg)
    local mixer = f:read("*all")
    f:close()

    local voll, volr = string.match(mixer, "outputs.master=([%d]+),([%d]+)")
	local mute = string.match( mixer, "outputs.master.mute=([%a]+)" )
	local volu = helpers.topercent( voll, 255 )

    if mute == "off" then
       mute = mixer_state["off"]
    else
       mute = mixer_state["on"]
    end

    return { volu, mute }
end
-- }}}

setmetatable(_M, { __call = function(_, ...) return worker(...) end })
