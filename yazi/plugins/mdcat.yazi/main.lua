-- mdcat previewer for yazi 26 — renders Markdown to the preview pane.
-- Hand-written (not a `ya pkg` dep), so no package.toml entry and no upgrade churn.
-- mdcat flags: --ansi (force formatting when stdout is a pipe, no TTY), --local
-- (skip remote image fetches so the preview never stalls), --columns (pane width).
local M = {}

function M:peek(job)
	-- left+right margin: inset the render area, and narrow --columns to match so wrapping fits.
	local pad = 2
	local area = job.area:pad(ui.Pad.x(pad))

	local child = Command("mdcat")
		:arg({ "--ansi", "--local", "--columns", tostring(area.w), tostring(job.file.url) })
		:env("CLICOLOR_FORCE", "1")
		:stdout(Command.PIPED)
		:stderr(Command.PIPED)
		:spawn()

	if not child then
		return require("code").peek(job)
	end

	local limit = job.area.h
	local i, lines = 0, ""
	repeat
		local next, event = child:read_line()
		if event == 1 then
			return require("code").peek(job)
		elseif event ~= 0 then
			break
		end

		i = i + 1
		if i > job.skip then
			lines = lines .. next
		end
	until i >= job.skip + limit

	child:start_kill()
	if job.skip > 0 and i < job.skip + limit then
		ya.emit("peek", {
			tostring(math.max(0, i - limit)),
			only_if = job.file.url,
			upper_bound = true,
		})
	else
		lines = lines:gsub("\t", string.rep(" ", rt.preview.tab_size))
		ya.preview_widget(job, ui.Text.parse(lines):area(area))
	end
end

function M:seek(job)
	local h = cx.active.current.hovered
	if not h or h.url ~= job.file.url then
		return
	end
	ya.emit("peek", {
		math.max(0, cx.active.preview.skip + job.units),
		only_if = job.file.url,
	})
end

return M
