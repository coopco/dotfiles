--task █▄▄ ▄▀█ █▀█
--task █▄█ █▀█ █▀▄

local awful = require("awful")
local wibox = require("wibox")
local beautiful = require("beautiful")
local xresources = require("beautiful.xresources")
local dpi = xresources.apply_dpi

return function(s)
  -- Import modules
  local layout, layout_popup = require("ui.bar.layout")()
  local taglist = require("ui.bar.taglist")
  local tasklist = require("ui.taskbar.tasklist")

  -- Assemble bar
  s.bar = awful.popup({
    screen = s,
    type = "dock",
    -- allow space for top of left bar
    minimum_width = s.geometry.width - dpi(40),
    maximum_width = s.geometry.width - dpi(40),
    minimum_height = dpi(40),
    maximum_height = dpi(40),
    placement = function(c)
      awful.placement.top_right(c)
    end,
    widget = {
      {
        {
          layout = wibox.layout.align.horizontal,
          expand = "none",
          tasklist(s),
          {
            {
              layout,
              spacing = dpi(8),
              layout = wibox.layout.fixed.horizontal,
            },
            bottom = dpi(6),
            widget = wibox.container.margin,
          },
        },
        left = dpi(3),
        right = dpi(3),
        widget = wibox.container.margin,
      },
      bg = beautiful.wibar_bg,
      widget = wibox.container.background,
    },
  })

  -- reserve screen space
  s.bar:struts({
    top = s.bar.maximum_height,
  })

  -- SETTINGS --
  -- Bar visibility
  local function remove_bar(c)
    if c.fullscreen or c.maximized then
      c.screen.bar.visible = false
    else
      c.screen.bar.visible = true
    end
  end

  -- i dont really understand this one
  local function add_bar(c)
    if c.fullscreen or c.maximized then
      c.screen.bar.visible = true
    end
  end

  --client.connect_signal("property::fullscreen", remove_bar)
  --client.connect_signal("request::unmanage", add_bar)
end
