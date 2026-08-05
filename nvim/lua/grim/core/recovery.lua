-- Recovery — find swap files holding unsaved text, and open one.
--
-- nvim never goes looking for these. It notices a swap only when you open that
-- exact file, and after the 2026-08-04 tmux crash four of the six surviving
-- swaps had no file name at all ([No Name] scratch buffers) — so nothing could
-- ever prompt for them. `nvim -r` is the only built-in discovery and it is a
-- manual, numbered list. This is that list, in the editor, on a command.
--
-- Built on nvim's own swapinfo(). Two things that cost a wrong answer first:
--   * swapinfo().pid reads 0 for every swap on this machine, so it cannot be
--     used to tell whether the owning nvim is still running.
--   * a swap's NAME is its origin path with `/` written as `%` — and `%` is
--     the Ex command line's "current file" token, so `:recover <path>` dies
--     with E499 unless the path goes through fnameescape().

local M = {}

local swap_dir = vim.fn.stdpath("state") .. "/swap/"

-- ponytail: "written in the last minute" stands in for "its nvim is still
-- running". swapinfo().pid would be exact; it reports 0. Swap it in if that
-- ever starts returning a real pid.
local LIVE_WINDOW = 60

--- Every swap file that holds unsaved text, newest first.
function M.list()
  local out = {}
  if vim.fn.isdirectory(swap_dir) == 0 then
    return out
  end
  for _, name in ipairs(vim.fn.readdir(swap_dir)) do
    local path = swap_dir .. name
    local info = vim.fn.swapinfo(path)
    if info.dirty == 1 then
      local origin = name:gsub("%%", "/"):gsub("%.sw[a-z]$", "")
      local mtime = vim.fn.getftime(path)
      table.insert(out, {
        path = path,
        fname = info.fname ~= "" and info.fname or nil,
        origin = origin,
        mtime = mtime,
        live = (os.time() - mtime) < LIVE_WINDOW,
      })
    end
  end
  table.sort(out, function(a, b)
    return a.mtime > b.mtime
  end)
  return out
end

local function label(s)
  return table.concat({
    os.date("%d/%m %H:%M", s.mtime),
    s.fname or (s.origin .. "  [No Name]"),
    s.live and "  ← open right now, do NOT recover" or "",
  }, "  ")
end

--- Pick a swap and recover it into a buffer.
function M.open()
  local swaps = M.list()
  if #swaps == 0 then
    vim.notify("Recovery: nothing holds unsaved text", vim.log.levels.INFO)
    return
  end
  vim.ui.select(swaps, { prompt = "Recover unsaved text:", format_item = label }, function(choice)
    if not choice then
      return
    end
    -- :recover refuses to run over a modified buffer, so give it a clean one.
    if vim.bo.modified then
      vim.cmd("tabnew")
    end
    vim.cmd("recover " .. vim.fn.fnameescape(choice.path))
    vim.notify("Recovered — this buffer is UNSAVED. :w <path> to keep it.", vim.log.levels.WARN)
  end)
end

vim.api.nvim_create_user_command("Recovery", M.open, {
  desc = "List swap files holding unsaved text and recover one",
})

return M
