-- Keymaps are automatically loaded on the VeryLazy event
-- Default keymaps that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/keymaps.lua
-- Add any additional keymaps here
-- ~/.config/nvim/lua/config/keymaps.lua

-- ===========================================================================
--  C / C++ 编译运行配置（算法竞赛 & 工程通用）
--  改这里就能全局切换编译器和标准，无需动下面的逻辑
-- ===========================================================================
local cpp = {
  compiler = "g++-14", -- 可选: "g++-14" / "clang++-20"
  std = "c++23", -- 可选: "c++23" / "c++26"（<F6> 一键切换）
  flags = "-O2 -Wall -Wextra -Wshadow -fmax-errors=100",
}

-- 编译并运行当前文件；编译失败则不运行旧二进制
vim.keymap.set("n", "<F5>", function()
  vim.cmd("write")
  local file = vim.fn.expand("%:p") -- 源码绝对路径
  local out = vim.fn.expand("%:p:r") -- 去掉后缀的可执行文件路径

  local lines = {
    ("if ! command -v %s >/dev/null 2>&1; then"):format(cpp.compiler),
    ("  echo '❌ 找不到编译器 %s，请先执行 sudo apt install g++-14 clang-20'"):format(cpp.compiler),
    "  read; exit 1",
    "fi",
    ("echo '⚙  %s -std=%s %s'"):format(cpp.compiler, cpp.std, cpp.flags),
    ("%s -std=%s %s '%s' -o '%s' && { echo '▶ 运行结果:'; '%s'; } || echo '❌ 编译失败'"):format(
      cpp.compiler,
      cpp.std,
      cpp.flags,
      file,
      out,
      out
    ),
    "echo ''; echo '-----------------'; echo '程序运行结束，按回车键关闭...'; read",
  }
  Snacks.terminal.get(table.concat(lines, "\n"), { cwd = vim.fn.expand("%:p:h") })
end, { desc = "Compile and Run C++" })

-- 一键切换 C++23 / C++26
vim.keymap.set("n", "<F6>", function()
  cpp.std = (cpp.std == "c++23") and "c++26" or "c++23"
  vim.notify("C++ 标准切换为: " .. cpp.std)
end, { desc = "Toggle C++ standard (23/26)" })

-- 一键切换 g++-14 / clang++-20
vim.keymap.set("n", "<F7>", function()
  cpp.compiler = (cpp.compiler == "g++-14") and "clang++-20" or "g++-14"
  vim.notify("C++ 编译器切换为: " .. cpp.compiler)
end, { desc = "Toggle C++ compiler (gcc/clang)" })

-- Neovide 字体缩放配置
if vim.g.neovide then
  -- Ctrl + 鼠标滚轮向上滚动：放大
  vim.keymap.set("n", "<C-ScrollWheelUp>", function()
    vim.g.neovide_scale_factor = vim.g.neovide_scale_factor + 0.1
  end, { desc = "Increase Neovide scale factor" })

  -- Ctrl + 鼠标滚轮向下滚动：缩小
  vim.keymap.set("n", "<C-ScrollWheelDown>", function()
    vim.g.neovide_scale_factor = vim.g.neovide_scale_factor - 0.1
  end, { desc = "Decrease Neovide scale factor" })
end

-- Terminal shortcuts retained from the previous configuration.
-- Open a terminal for the directory currently selected in Explorer.
local function terminal_here(focus)
  local opts = { cwd = vim.fn.getcwd() }
  if focus then
    Snacks.terminal.focus(nil, opts)
  else
    Snacks.terminal(nil, opts)
  end
end

vim.keymap.set("n", "<leader>ft", function() terminal_here(false) end, { desc = "Terminal (Current Directory)" })
vim.keymap.set("n", "<leader>fT", function() terminal_here(false) end, { desc = "Terminal (Current Directory)" })
vim.keymap.set({ "n", "t" }, "<C-/>", function() terminal_here(true) end, { desc = "Terminal (Current Directory)" })
vim.keymap.set({ "n", "t" }, "<C-_>", function() terminal_here(true) end, { desc = "Terminal (Current Directory)" })
