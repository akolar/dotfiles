-- Standard awesome library
local gears = require("gears")
local awful = require("awful")
awful.rules = require("awful.rules")
require("awful.autofocus")

-- Widget and layout library
local wibox = require("wibox")
local vicious = require("vicious")
local lain = require("lain")

-- Theme handling library
local beautiful = require("beautiful")

-- Notification library
local naughty = require("naughty")
local menubar = require("menubar")

-- {{{ Error handling
if awesome.startup_errors then
    naughty.notify({ preset = naughty.config.presets.critical,
                     title = "Oops, there were errors during startup!",
                     text = awesome.startup_errors })
end

-- Handle runtime errors after startup
do
    local in_error = false
    awesome.connect_signal("debug::error", function (err)
        -- Make sure we don't go into an endless error loop
        if in_error then return end
        in_error = true

        naughty.notify({ preset = naughty.config.presets.critical,
                         title = "Oops, an error happened!",
                         text = err })
        in_error = false
    end)
end
-- }}}

-- {{{ Defaults

-- Load theme
beautiful.init("/home/anze/.config/awesome/theme.lua")

-- Default applicationst@github.com:akolar/dotfiles.git
terminal = "termite"
menubar.utils.terminal = terminal -- Set the terminal for applications that require it

-- Default modkey.
modkey = "Mod4"

-- Table of layouts to cover with awful.layout.inc, order matters.
local layouts = {
    awful.layout.suit.floating,         -- 1
    awful.layout.suit.tile,             -- 2
    awful.layout.suit.tile.left,        -- 3
    awful.layout.suit.tile.bottom,      -- 4
    awful.layout.suit.tile.top,         -- 5
    awful.layout.suit.fair,             -- 6
    awful.layout.suit.fair.horizontal,  -- 7
    lain.layout.uselessfair,            -- 8
}
-- }}}

-- {{{ Wallpaper
if beautiful.wallpaper then
    for s = 1, screen.count() do
        gears.wallpaper.maximized(beautiful.wallpaper, s, false)
    end
end
-- }}}

-- {{{ Tags
-- Define a tag table which will hold all screen tags.
tags = {
  names  = { "web", "fs·", "dev", "dev", "msg", "etc", "vm·", "gtd" },
  layout = { layouts[1],  -- web   floating
             layouts[6],  -- files fair
             layouts[8],  -- dev   floating
             layouts[8],  -- dev   floating
             layouts[5],  -- im    tile.top
             layouts[8],  -- etc   tile.top
             layouts[1],  -- vm    floating
             layouts[6],  -- gtd   fair
}}
-- Apply tags to each screen
for s = 1, screen.count() do
    tags[s] = awful.tag(tags.names, s, tags.layout)
end
-- }}}

-- {{{ Wibox
markup = lain.util.markup
separators = lain.util.separators

-- Textclock
timewidget = wibox.widget.textbox()
vicious.register(timewidget, vicious.widgets.date, ' %a %d %b %H:%M:%S', 1)

-- MPD
-- TODO: Disable notification
mpdicon = wibox.widget.imagebox(beautiful.widget_music)
mpdwidget = wibox.widget.textbox()
vicious.register(mpdwidget, vicious.widgets.mpd,
    function (widget, args)
        if args["{state}"] == "Play" then             
            artist = args["{Artist}"] .. " "
            title  = args["{Title}"]
            if #title >= 30 then
              last_space = string.find(title, ' ', 25) or #title + 1
              title = string.sub(title, 0, last_space - 1) .. "…"
            end
            title = title .. " "
            mpdicon:set_image(beautiful.widget_music_on)
        elseif args["{state}"] == "Pause" then
            artist = "mpd "
            title  = "paused "
        else
            artist = ""
            title  = ""
            mpdicon:set_image(beautiful.widget_music)
        end
        return markup("#EA6F81", artist) .. title
    end, 5)

-- MEM
memicon = wibox.widget.imagebox(beautiful.widget_mem)
memwidget = wibox.widget.textbox()
vicious.register(memwidget, vicious.widgets.mem, '$2M ', 1)

-- CPU
cpuicon = wibox.widget.imagebox(beautiful.widget_cpu)
cpuwidget = wibox.widget.textbox()
vicious.register(cpuwidget, vicious.widgets.cpu, '$1% ', 1)

-- / fs
fsicon = wibox.widget.imagebox(beautiful.widget_hdd)
fswidget = wibox.widget.textbox()
vicious.register(fswidget, vicious.widgets.fs,
  '${/ avail_gb}G | ${/home avail_gb}G ', 60)

-- Battery
baticon = wibox.widget.imagebox(beautiful.widget_battery)

bat0widget = wibox.widget.textbox()
vicious.register(bat0widget, vicious.widgets.bat, '$1$2', 60, "BAT0")
bat1widget = wibox.widget.textbox()
vicious.register(bat1widget, vicious.widgets.bat, ' | $1$2% ', 60, "BAT1")

-- Net
neticon = wibox.widget.imagebox(beautiful.widget_net)
ssidwidget = wibox.widget.textbox()
vicious.register(ssidwidget, vicious.widgets.wifi, ' ${ssid} ', 5, "wlp3s0")
netwidget = lain.widgets.net({
    settings = function()
        widget:set_markup(markup("#7AC82E", " " .. net_now.received)
                          .. " " ..
                          markup("#46A8C3", " " .. net_now.sent .. " "))
    end
})

-- Separators
spr = wibox.widget.textbox(' ')
arrl = wibox.widget.imagebox()
arrl:set_image(beautiful.arrl)
arrl_dl = separators.arrow_left(beautiful.bg_focus, "alpha")
arrl_ld = separators.arrow_left("alpha", beautiful.bg_focus)

-- Create a wibox for each screen and add it
mywibox = {}
mypromptbox = {}
mylayoutbox = {}
mytaglist = {}
mytaglist.buttons = awful.util.table.join(
                    awful.button({ }, 1, awful.tag.viewonly),
                    awful.button({ modkey }, 1, awful.client.movetotag),
                    awful.button({ }, 3, awful.tag.viewtoggle),
                    awful.button({ modkey }, 3, awful.client.toggletag)
                    )

for s = 1, screen.count() do

    -- Create a promptbox for each screen
    mypromptbox[s] = awful.widget.prompt()

    -- We need one layoutbox per screen.
    mylayoutbox[s] = awful.widget.layoutbox(s)
    mylayoutbox[s]:buttons(awful.util.table.join(
                            awful.button({ }, 1, function () awful.layout.inc(layouts, 1) end),
                            awful.button({ }, 3, function () awful.layout.inc(layouts, -1) end),
                            awful.button({ }, 4, function () awful.layout.inc(layouts, 1) end),
                            awful.button({ }, 5, function () awful.layout.inc(layouts, -1) end)))

    -- Create a taglist widget
    mytaglist[s] = awful.widget.taglist(s, awful.widget.taglist.filter.all, mytaglist.buttons)

    -- Create the wibox
    mywibox[s] = awful.wibox({ position = "top", screen = s, height = 18 })

    -- Widgets that are aligned to the upper left
    local left_layout = wibox.layout.fixed.horizontal()
    left_layout:add(spr)
    left_layout:add(mytaglist[s])
    left_layout:add(spr)

    -- Widgets that are aligned to the upper right
    local right_layout_toggle = true
    local function right_layout_add (...)
        local arg = {...}
        if right_layout_toggle then
            right_layout:add(arrl_ld)
            for i, n in pairs(arg) do
                right_layout:add(wibox.widget.background(n ,beautiful.bg_focus))
            end
        else
            right_layout:add(arrl_dl)
            for i, n in pairs(arg) do
                right_layout:add(n)
            end
        end
        right_layout_toggle = not right_layout_toggle
    end

    right_layout = wibox.layout.fixed.horizontal()
    right_layout:add(spr)
    right_layout:add(arrl)
    right_layout_add(mpdicon, mpdwidget)
    right_layout_add(memicon, memwidget)
    right_layout_add(cpuicon, cpuwidget)
    right_layout_add(fsicon, fswidget)
    right_layout_add(baticon, bat0widget, bat1widget)
    right_layout_add(neticon, netwidget, ssidwidget)
    right_layout_add(timewidget, spr)
    right_layout_add(mylayoutbox[s])

    -- Now bring it all together (with the tasklist in the middle)
    local layout = wibox.layout.align.horizontal()
    layout:set_left(left_layout)
    layout:set_right(right_layout)
    mywibox[s]:set_widget(layout)

end
-- 
-- }}}

-- {{{ Key bindings
globalkeys = awful.util.table.join(
    -- {{{ Awesome-related
    awful.key({ modkey,           }, "Left",   awful.tag.viewprev       ),
    awful.key({ modkey,           }, "Right",  awful.tag.viewnext       ),
    awful.key({ "Mod1",           }, "Tab",  -- Same as modkey + k
        function ()
            awful.client.focus.byidx(-1)
            if client.focus then client.focus:raise() end
        end),

    -- Layout manipulation
    awful.key({ modkey, "Shift"   }, "j", function () awful.client.swap.byidx(  1)    end),
    awful.key({ modkey, "Shift"   }, "k", function () awful.client.swap.byidx( -1)    end),
    awful.key({ modkey, "Shift"   }, "h", function () 
      awful.tag.incnmaster( 1)
      naughty.notify({ title = 'Master', text = tostring(awful.tag.getnmaster()), timeout = 1 }) 
    end),
    awful.key({ modkey, "Shift"   }, "l", function () 
      awful.tag.incnmaster(-1)
      naughty.notify({ title = 'Master', text = tostring(awful.tag.getnmaster()), timeout = 1 })
    end),
    awful.key({ modkey, "Control" }, "h", function () 
      awful.tag.incncol( 1)
      naughty.notify({ title = 'Columns', text = tostring(awful.tag.getncol()), timeout = 1 })
    end),
    awful.key({ modkey, "Control" }, "l", function () 
      awful.tag.incncol(-1)
      naughty.notify({ title = 'Columns', text = tostring(awful.tag.getncol()), timeout = 1 }) 
    end),


    awful.key({ modkey,           }, "space", function () awful.layout.inc(layouts,  1) end),
    awful.key({ modkey, "Shift"   }, "space", function () awful.layout.inc(layouts, -1) end),

    -- Standard program
    awful.key({ modkey, "Control" }, "r", awesome.restart),
    awful.key({ modkey, "Control" }, "q", awesome.quit),

    -- Prompt
    awful.key({ modkey },            "r",     function () mypromptbox[mouse.screen]:run() end),

    -- Menubar
    awful.key({ modkey }, "p",  function () awful.util.spawn("/home/anze/.dotfiles/awesome/spawn_with_path.sh rofi -lines 10 -show run") end),
    --- }}}

    -- {{{ Application shortcuts

    -- Terminal
    awful.key({ "Mod1", "Control" }, "t", function () awful.util.spawn(terminal) end),

    -- Web
    awful.key({ "Mod1", "Control" }, "w", function () awful.util.spawn("firefox") end),
    awful.key({ "Mod1", "Control" }, "f", function () awful.util.spawn("chromium") end),
    awful.key({ "Mod1", "Control" }, "g", function () 
	  local matcher = function (c)
		return awful.rules.match(c, {name = 'Todoist'})
	  end
	  awful.client.run_or_raise('chromium --app=https://todoist.com --class todoist', matcher)
    end),
    awful.key({ "Mod1", "Control" }, "h", function () 
	  local matcher = function (c)
		return awful.rules.match(c, {name = 'Toggl'})
	  end
	  awful.client.run_or_raise('chromium --app=https://toggl.com/app/track --class toggl', matcher)
    end),
    awful.key({ "Mod1", "Control" }, "n", function () 
	  local matcher = function (c)
		return awful.rules.match(c, {name = 'db-paper'})
	  end
	  awful.client.run_or_raise('chromium --app=https://paper.dropbox.com --class db-paper', matcher)
    end),
    awful.key({ "Mod1", "Control" }, "m", function () 
	  local matcher = function (c)
		return awful.rules.match(c, {name = 'messages'})
	  end
	  awful.client.run_or_raise('chromium --app=https://messages.android.com --class messages', matcher)
    end),

    -- Rofi
    awful.key({ "Mod1", "Control" }, "p", function () awful.util.spawn("rofi-pass") end),
    awful.key({ "Mod1", "Control" }, "v", function () awful.util.spawn("/home/anze/.dotfiles/bin/pick-vm") end),
    awful.key({ modkey }, "e", function () awful.util.spawn("rofi -show emoji -modi emoji") end),

    -- Files
    awful.key({ "Mod1", "Control" }, "q", function () awful.util.spawn("atom") end),
    awful.key({ "Mod1", "Control" }, "e", function () 
	  local matcher = function (c)
		return awful.rules.match(c, {class = 'ranger'})
	  end
	  awful.client.run_or_raise("termite -e ranger", matcher) 
	end),

    -- Music
    awful.key({ "Mod1", "Control" }, "a", function () awful.util.spawn("mpc prev") end),
    awful.key({ "Mod1", "Control" }, "s", function () awful.util.spawn("mpc toggle") end),
    awful.key({ "Mod1", "Control" }, "d", function () awful.util.spawn("mpc next") end),

    -- Misc
    awful.key({ modkey            }, "l", function () awful.util.spawn("xautolock -locknow") end),
    awful.key({                   }, "Print", function () awful.util.spawn_with_shell("scrot") end),

    -- Volume
    awful.key({ }, "XF86AudioRaiseVolume", function () awful.util.spawn("amixer set Master 3%+") end),
    awful.key({ }, "XF86AudioLowerVolume", function () awful.util.spawn("amixer set Master 3%-") end),
    awful.key({ }, "XF86AudioMute", function () awful.util.spawn_with_shell("amixer get Master | grep off > /dev/null && amixer set Master unmute || amixer set Master mute") end),

    -- Backlight
    awful.key({ }, "XF86MonBrightnessUp", function () awful.util.spawn("xbacklight -inc 10") end),
    awful.key({ }, "XF86MonBrightnessDown", function () awful.util.spawn("xbacklight -dec 10") end),

    -- Touchpad
    awful.key({ }, "F3", function () awful.util.spawn("/home/anze/.dotfiles/bin/toggle-touchpad") end)
    -- }}}
)

-- {{{ Client keys
clientkeys = awful.util.table.join(
    awful.key({ modkey,           }, "f",      function (c) c.fullscreen = not c.fullscreen end),
    awful.key({ "Mod1",           }, "F4",     function (c) c:kill()                        end),
    awful.key({ modkey,           }, "d",      awful.client.floating.toggle                    ),
    awful.key({ modkey,           }, "t",      function (c) c.ontop = not c.ontop           end),
    awful.key({ modkey,           }, "m",
        function (c)
            c.maximized_horizontal = not c.maximized_horizontal
            c.maximized_vertical   = not c.maximized_vertical
        end),
    awful.key({ modkey, "Shift"   }, "Left",
      function (c)
        local curidx = awful.tag.getidx()
        if curidx == 1 then
           awful.client.movetotag(tags[client.focus.screen][#awful.tag.gettags(client.focus.screen)])
        else
           awful.client.movetotag(tags[client.focus.screen][curidx - 1])
        end
        awful.tag.viewprev()
    end),
    awful.key({ modkey, "Shift"   }, "Right",
      function (c)
        local curidx = awful.tag.getidx()
        if curidx == #awful.tag.gettags(client.focus.screen) then
           awful.client.movetotag(tags[client.focus.screen][1])
        else
           awful.client.movetotag(tags[client.focus.screen][curidx + 1])
        end
        awful.tag.viewnext()
    end)
-- }}}
)

-- Bind all key numbers to tags.
-- Be careful: we use keycodes to make it works on any keyboard layout.
-- This should map on the top row of your keyboard, usually 1 to 9.
for i = 1, 9 do
    globalkeys = awful.util.table.join(globalkeys,
        awful.key({ modkey }, "#" .. i + 9,
                  function ()
                        local screen = mouse.screen
                        local tag = awful.tag.gettags(screen)[i]
                        if tag then
                           awful.tag.viewonly(tag)
                        end
                  end),
        awful.key({ modkey }, "`",
                  function ()
                      local screen = mouse.screen
                      local tag = awful.tag.gettags(screen)[8]
                      if tag then
                         awful.tag.viewonly(tag)
                      end
                  end),
        awful.key({ modkey, "Control" }, "#" .. i + 9,
                  function ()
                      local screen = mouse.screen
                      local tag = awful.tag.gettags(screen)[i]
                      if tag then
                         awful.tag.viewtoggle(tag)
                      end
                  end),
        awful.key({ modkey, "Shift" }, "#" .. i + 9,
                  function ()
                      if client.focus then
                          local tag = awful.tag.gettags(client.focus.screen)[i]
                          if tag then
                              awful.client.movetotag(tag)
                          end
                     end
                  end),
        awful.key({ modkey, "Control", "Shift" }, "#" .. i + 9,
                  function ()
                      if client.focus then
                          local tag = awful.tag.gettags(client.focus.screen)[i]
                          if tag then
                              awful.client.toggletag(tag)
                          end
                      end
                  end))
end

clientbuttons = awful.util.table.join(
    awful.button({ }, 1, function (c) client.focus = c; c:raise() end),
    awful.button({ modkey }, 1, awful.mouse.client.move),
    awful.button({ modkey }, 3, awful.mouse.client.resize))

-- Set keys
root.keys(globalkeys)
-- }}}

-- {{{ Rules
awful.rules.rules = {
    { rule = { },  -- All clients will match this rule.
      properties = { border_width = beautiful.border_width,
                     border_color = beautiful.border_normal,
                     focus = awful.client.focus.filter,
                     keys = clientkeys,
                     size_hints_honor = false,
                     buttons = clientbuttons } },
    { rule = { class = "mpv" },
      properties = { floating = true } },
    { rule = { class = "Pinentry-gtk-2" },
      properties = { floating = true } },
    { rule = { class = "Firefox"},
      properties = { border_width = 0, maximized_vertical = true, maximized_horizontal = true } },
    { rule = { class = "termite"},
      properties = { border_width = 0} },
    { rule_any = { class = { "rtorrent", "htop", "ncmpcpp", "maze" } },
      properties = { tag = tags[1][6] } },
    { rule = { class = "weechat" },
      properties = { tag = tags[1][5] } },
    { rule = { class = "ranger" },
      properties = { tag = tags[1][2] } },
    { rule = { class = "todoist.com" },
      properties = { tag = tags[1][7] } },
    { rule = { class = "toggl.com" },
      properties = { tag = tags[1][7] } }
}
-- }}}

-- {{{ Signals
-- Signal function to execute when a new client appears.
client.connect_signal("manage", function (c, startup)
    -- Focus on mouseover
    c:connect_signal("mouse::enter", function(c)
        if awful.layout.get(c.screen) ~= awful.layout.suit.magnifier
            and awful.client.focus.filter(c) then
            client.focus = c
        end
    end)

    if not startup then
        -- Put windows in a smart way, only if they does not set an initial position.
        if not c.size_hints.user_position and not c.size_hints.program_position then
            awful.placement.no_overlap(c)
            awful.placement.no_offscreen(c)
        end
    end
end)

client.connect_signal("focus", function(c) c.border_color = beautiful.border_focus end)
client.connect_signal("unfocus", function(c) c.border_color = beautiful.border_normal end)
-- }}}

-- {{{ Battery
local function trim(s)
  return s:find'^%s*$' and '' or s:match'^%s*(.*%S)'
end

local function bat_notification()
  local f_capacity0 = assert(io.open("/sys/class/power_supply/BAT0/capacity", "r"))
  local f_capacity1 = assert(io.open("/sys/class/power_supply/BAT1/capacity", "r"))
  local f_status0 = assert(io.open("/sys/class/power_supply/BAT0/status", "r"))
  local f_status1 = assert(io.open("/sys/class/power_supply/BAT1/status", "r"))

  local bat_capacity = tonumber(f_capacity0:read("*all")) + tonumber(f_capacity1:read("*all"))
  local bat_status0 = trim(f_status0:read("*all")) == "Discharging"
  local bat_status1 = trim(f_status1:read("*all")) == "Discharging"

  if (bat_capacity <= 20 and (bat_status0 or bat_status1)) then
    naughty.notify({ 
      preset     = naughty.config.presets.critical,
      title      = "Battery Warning",
      text       = "Battery low! " .. bat_capacity / 2 .."%" .. " left!",
      timeout    = 30,
      position   = "top_left"
    })
  end
end

battimer = timer({timeout = 120})
battimer:connect_signal("timeout", bat_notification)
battimer:start()
-- }}}
-- vim: set syntax=lua foldmethod=marker foldenable:
