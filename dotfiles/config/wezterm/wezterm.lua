local wzt = require("wezterm")
local cfg = {}

-- General settings
cfg.show_update_window = false
cfg.window_close_confirmation = "NeverPrompt"
cfg.term = "xterm-256color"
cfg.color_scheme = "tokyonight"

-- window settings
cfg.enable_tab_bar = false
cfg.max_fps = 175
cfg.initial_cols = 120
cfg.initial_rows = 35
cfg.window_background_opacity = 0.8
cfg.macos_window_background_blur = 20

-- font settings
cfg.font = wzt.font_with_fallback({
	{ family = "Iosevka Nerd Font Mono" },
	{ family = "FiraCode Nerd Font Mono" },
})
cfg.font_size = 14.0

-- Cursor settings
cfg.default_cursor_style = "BlinkingBlock"
cfg.cursor_blink_rate = 600
cfg.cursor_blink_ease_in = "Constant"
cfg.cursor_blink_ease_out = "Constant"

return cfg
