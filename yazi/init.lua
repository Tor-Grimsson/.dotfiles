-- init.lua — yazi's Lua entry point. Runs at startup; used to set up plugins
-- that need initialization (those invoked purely by keybind don't go here).

-- full-border: draw rounded borders around the parent/current/preview panes.
require("full-border"):setup({
	type = ui.Border.ROUNDED,
})

-- md-preview's mode in the status line, ONLY while a markdown file is hovered —
-- on every other file type it would be permanent clutter. Reads the SAME
-- ~/.cache/md-preview.mode that bin/md-preview reads per render, so there is no
-- second source of truth to drift. Like the preview itself, it updates on yazi's
-- next redraw: after `prefix v` you still move the cursor to see it change.
--
-- The idiom below (self._current.hovered · bare `return ""` for nothing ·
-- self:style() for the theme's colours) is copied from yazi's own Status:name
-- and Status:size children rather than invented.
Status:children_add(function(self)
	local h = self._current.hovered
	if not h then
		return ""
	end
	if not (h.name:match("%.md$") or h.name:match("%.markdown$")) then
		return ""
	end

	local f = io.open(os.getenv("HOME") .. "/.cache/md-preview.mode")
	local mode = f and f:read("*l") or ""
	if f then
		f:close()
	end
	mode = (mode or ""):match("^%s*(.-)%s*$")
	-- Same fallback as bin/md-preview's read_mode: an unreadable or unknown
	-- value is `full`, so the badge can never disagree with what is rendering.
	if mode ~= "full" and mode ~= "mdcat" and mode ~= "glow" then
		mode = "full"
	end

	-- The powerline separators are NOT decoration — without them this is the one
	-- flat rectangle in a bar of slanted segments, which is exactly how it shipped
	-- first (user caught it 2026-08-05). Leading `sep_right.open` mirrors
	-- Status:percent (the `Bot` segment next to this one); the trailing
	-- `sep_right.close` tapers back onto the bar because what follows — perm —
	-- draws as plain text with no background of its own. `fg` is always this
	-- block's own background: that is what makes the glyph read as its edge.
	local style = self:style()
	return ui.Line({
		ui.Span(" " .. th.status.sep_right.open):fg(style.alt:bg()),
		ui.Span(" md:" .. mode .. " "):style(style.alt),
		ui.Span(th.status.sep_right.close):fg(style.alt:bg()),
	})
end, 500, Status.RIGHT)
