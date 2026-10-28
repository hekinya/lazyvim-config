return {
  {
    "folke/snacks.nvim",
    opts = {
      picker = {
        sources = {
          explorer = {
            on_change = function(_, item)
              if not item or not item.file then
                return
              end
              local dir = item.dir and item.file or vim.fn.fnamemodify(item.file, ":h")
              if vim.fn.isdirectory(dir) == 1 and dir ~= vim.fn.getcwd() then
                vim.cmd("noautocmd cd " .. vim.fn.fnameescape(dir))
                -- A running shell keeps its own cwd; hide stale terminal panels.
                for _, terminal in ipairs(Snacks.terminal.list()) do
                  local info = vim.b[terminal.buf].snacks_terminal
                  if terminal:win_valid() and info and info.cwd ~= dir then
                    terminal:hide()
                  end
                end
                vim.cmd.redrawstatus()
              end
            end,
          },
        },
      },
    },
  },
}




