-- init.lua — yazi's Lua entry point. Runs at startup; used to set up plugins
-- that need initialization (those invoked purely by keybind don't go here).

-- full-border: draw rounded borders around the parent/current/preview panes.
require("full-border"):setup({
	type = ui.Border.ROUNDED,
})
