-- Keymaps are automatically loaded on the VeryLazy event
-- https://www.lazyvim.org/configuration/keymaps
--
-- LazyVim 已内置的快捷键（无需重复定义）：
--   <leader>qq  退出所有
--   Ctrl+hjkl   窗口导航
--   Ctrl+箭头   调整窗口大小
--   </>         Visual 模式缩进
--   Alt+j/k     移动行
--   <S-h>/<S-l> Buffer 切换
--   <leader>bd  关闭 buffer

vim.keymap.set("n", "<leader>w", "<cmd>w<CR>", { desc = "保存文件" })
