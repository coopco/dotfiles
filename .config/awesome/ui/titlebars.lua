local awful = require("awful")
local wibox = require("wibox")
local beautiful = require("beautiful")
local xresources = require("beautiful.xresources")
local dpi = xresources.apply_dpi

-- TODO use beautiful
local config = require("config")
local theme_name = config.theme_name
local theme_style = config.theme_style
local colorscheme = require("theme.colorschemes." .. theme_name .. "." .. theme_style)
local colors = colorscheme.colors

local function setup_titlebar(c)
    awful.titlebar(c, { position = "left", size = dpi(3) }) : setup {
      -- INDICATORS
      -- Project
      -- Floating
      -- Sticky
      -- On top
      -- Misc (e.g. Red for alert)
      -- Hide when maximised?
      -- focused?

      --{
      --  -- TODO Project
      --  bg = colors.bg,
      --  forced_height = 0,
      --  widget = wibox.container.background,
      --},
      c.floating and {
        --bg = c.floating and colors.accents[2] or colors.bg,
        bg = colors.accents[2],
        widget = wibox.container.background,
        --widget = c.floating and wibox.container.background or wibox.container.margin,
      } or nil,
      c.ontop and {
        bg = colors.accents[4],
        widget = wibox.container.background,
      } or nil,
      c.sticky and {
        bg = colors.accents[6],
        widget = wibox.container.background,
      } or nil,
      c.urgent and {
        bg = colors.accents[7],
        widget = wibox.container.background,
      } or nil,
      layout = wibox.layout.flex.vertical
    }
end

-- Add a titlebar if titlebars_enabled is set to true in the rules.
client.connect_signal("request::titlebars", setup_titlebar)
client.connect_signal("property::floating", setup_titlebar)
client.connect_signal("property::ontop", setup_titlebar)
client.connect_signal("property::maximised", setup_titlebar)
client.connect_signal("property::urgent", setup_titlebar)
client.connect_signal("property::sticky", setup_titlebar)
client.connect_signal("property::fullscreen", setup_titlebar)
