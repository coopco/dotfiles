
-- ▀█▀ ▄▀█ █▀▀ █░░ █ █▀ ▀█▀ 
-- ░█░ █▀█ █▄█ █▄▄ █ ▄█ ░█░ 

local awful = require("awful")
local bling = require("modules.bling")
local gears = require("gears")
local wibox = require("wibox")
local beautiful = require("beautiful")
local xresources = require("beautiful.xresources")
local dpi = xresources.apply_dpi
local animation = require("modules.animation")

-- enable tag preview
bling.widget.tag_preview.enable {
    show_client_content = true,  -- Whether or not to show the client content
    x = 10,                       -- The x-coord of the popup
    y = 10,                       -- The y-coord of the popup
    scale = 0.25,                 -- The scale of the previews compared to the screen
    honor_padding = false,        -- Honor padding when creating widget size
    honor_workarea = false,       -- Honor work area when creating widget size
    placement_fn = function(c)    -- Place the widget using awful.placement (this overrides x & y)
        --awful.placement.top_left(c, {
        --    margins = {
        --        top = 30,
        --        left = 30
        --    }
        --})
      -- awful.placement.next_to_mouse(c)
      awful.placement.align(c, {
        position = "left",
        parent = awful.screen.focused(),
        margins = {
          left = dpi(50),
        }
      })
    end,
    background_widget = wibox.widget {    -- Set a background image (like a wallpaper) for the widget 
        image = beautiful.wallpaper,
        horizontal_fit_policy = "fit",
        vertical_fit_policy   = "fit",
        widget = wibox.widget.imagebox
    },
}

return function(s)
  local modkey = "Mod4"
  local taglist_buttons = gears.table.join(
  	awful.button({}, 1, function(t)
  		t:view_only()
  	end),
  	awful.button({ modkey }, 1, function(t)
  		if client.focus then
  			client.focus:move_to_tag(t)
  		end
  	end),
  	awful.button({}, 3, awful.tag.viewtoggle),
  	awful.button({ modkey }, 3, function(t)
  		if client.focus then
  			client.focus:toggle_tag(t)
  		end
  	end),
  	awful.button({}, 4, function(t)
  		awful.tag.viewnext(t.screen)
  	end),
  	awful.button({}, 5, function(t)
  		awful.tag.viewprev(t.screen)
  	end)
  )

  local function tag_list()
  	local taglist = awful.widget.taglist({
  		screen = s,
  		filter = awful.widget.taglist.filter.all,
  		layout = { layout = wibox.layout.fixed.vertical },
  		widget_template = {
  			widget = wibox.container.margin,
  			forced_width = dpi(15),
  			forced_height = dpi(40),
  			create_callback = function(self, c3, _)
  				local indicator = wibox.widget({
  					widget = wibox.container.place,
  					valign = "center",
  					{
  						widget = wibox.container.background,
  						forced_width = dpi(5),
  						shape = gears.shape.rounded_bar,
  					},
  				})

  				self.indicator_animation = animation:new({
  					duration = 0.125,
  					easing = animation.easing.linear,
  					update = function(self, pos)
  						indicator.children[1].forced_height = pos
  					end,
  				})

  				self:set_widget(indicator)

  				if c3.selected then
  					self.widget.children[1].bg = beautiful.wibar_focused,
  					self.indicator_animation:set(dpi(20))
  				elseif #c3:clients() == 0 then
  					self.widget.children[1].bg = beautiful.wibar_empty,
  					self.indicator_animation:set(dpi(10))
  				else
  					self.widget.children[1].bg = beautiful.wibar_occupied,
  					self.indicator_animation:set(dpi(10))
          end

          self:connect_signal('mouse::enter', function()
            -- BLING: Only show widget when there are clients in the tag
            if #c3:clients() > 0 then
                -- BLING: Update the widget with the new tag
                awesome.emit_signal("bling::tag_preview::update", c3)
                -- BLING: Show the widget
                awesome.emit_signal("bling::tag_preview::visibility", s, true)
            end
          end)
          self:connect_signal('mouse::leave', function()
            -- BLING: Turn the widget off
            awesome.emit_signal("bling::tag_preview::visibility", s, false)
          end)

  			end,
  			update_callback = function(self, c3, _)
  				if c3.selected then
  					self.widget.children[1].bg = beautiful.wibar_focused,
  					self.indicator_animation:set(dpi(20))
  				elseif #c3:clients() == 0 then
  					self.widget.children[1].bg = beautiful.wibar_empty,
  					self.indicator_animation:set(dpi(10))
  				else
  					self.widget.children[1].bg = beautiful.wibar_occupied,
  					self.indicator_animation:set(dpi(10))
  				end
  			end,
  		},
  		buttons = taglist_buttons,
  	})

  	return wibox.widget({
  		taglist,
  		margins = dpi(8),
  		widget = wibox.container.margin,
  	})
  end

  return tag_list()
end
