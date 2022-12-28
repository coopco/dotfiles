
-- task █░░ █ █▀ ▀█▀ 
-- task █▄▄ █ ▄█ ░█░ 

local awful = require("awful")
local gears = require("gears")
local wibox = require("wibox")
local beautiful = require("beautiful")
local xresources = require("beautiful.xresources")
local dpi = xresources.apply_dpi
local animation = require("modules.animation")

return function(s)
  local modkey = "Mod4"

  local tasklist_buttons = gears.table.join(
    awful.button({ }, 1, function (c)
                             if c == client.focus then
                                 c.minimized = true
                             else
                                 c:emit_signal(
                                     "request::activate",
                                     "tasklist",
                                     {raise = true}
                                 )
                             end
                         end),
    awful.button({ }, 3, function()
                             awful.menu.client_list({ theme = { width = 250 } })
                         end),
    awful.button({ }, 4, function ()
                             awful.client.focus.byidx(1)
                         end),
    awful.button({ }, 5, function ()
                             awful.client.focus.byidx(-1)
                         end))


  local function task_list()
    local tasklist = awful.widget.tasklist({
      screen   = s,
      filter   = awful.widget.tasklist.filter.currenttags,
      buttons  = tasklist_buttons,
      style    = {
      --    shape_border_width = 1,
      --    shape_border_color = '#777777',
        shape  = function(cr, width, height)
                   gears.shape.rounded_rect(cr, width, height, 4)
                 end,
      },
      layout   = {
        -- tasks buttons have same width, regardless of text
        layout  = wibox.layout.flex.horizontal,
        spacing = dpi(8),
      },
      -- Notice that there is *NO* wibox.wibox prefix, it is a template,
      -- not a widget instance.
      widget_template = {
          {
              {
                  {
                      {
                          id     = 'icon_role',
                          widget = wibox.widget.imagebox,
                      },
                      margins = dpi(2),
                      widget  = wibox.container.margin,
                  },
                  {
                      id     = 'text_role',
                      widget = wibox.widget.textbox,
                  },
                  layout = wibox.layout.fixed.horizontal,
              },
              left  = dpi(10),
              right = dpi(10),
              widget = wibox.container.margin
          },
          id     = 'background_role',
          widget = wibox.container.background,
      },
    })

  	return wibox.widget({
  		tasklist,
  		margins = dpi(8),
  		widget = wibox.container.margin,
  	})
  end

  return task_list()
end
