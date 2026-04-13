-- Autocmds are automatically loaded on the VeryLazy event
-- https://www.lazyvim.org/configuration/autocmds
--
-- LazyVim 已内置以下功能（无需重复定义）：
--   - TextYankPost 高亮
--   - 恢复光标位置
--   - 文件类型特定缩进

-- Nix 文件使用 2 空格缩进
vim.api.nvim_create_autocmd("FileType", {
  pattern = { "nix" },
  callback = function()
    vim.opt_local.tabstop = 2
    vim.opt_local.shiftwidth = 2
  end,
})
