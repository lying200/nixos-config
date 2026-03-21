{ pkgs, ... }:

{
  programs.neovim = {
    enable = true;
    defaultEditor = true;
    viAlias = true;
    vimAlias = true;

    extraPackages = with pkgs; [
      wl-clipboard
      xclip  # X11 兼容性
    ];

    initLua = ''
      -- ============================================================================
      -- 基础设置
      -- ============================================================================

      -- 行号
      vim.opt.number = true
      vim.opt.relativenumber = true  -- 便于跳转

      -- 缩进
      vim.opt.tabstop = 4
      vim.opt.shiftwidth = 4
      vim.opt.expandtab = true
      vim.opt.smartindent = true
      vim.opt.autoindent = true

      -- 搜索
      vim.opt.ignorecase = true
      vim.opt.smartcase = true  -- 有大写时区分大小写
      vim.opt.hlsearch = true
      vim.opt.incsearch = true

      -- 界面
      vim.opt.cursorline = true
      vim.opt.termguicolors = true
      vim.opt.signcolumn = "yes"
      vim.opt.wrap = false
      vim.opt.scrolloff = 8
      vim.opt.sidescrolloff = 8

      -- 分割窗口
      vim.opt.splitright = true
      vim.opt.splitbelow = true

      -- 文件编码
      vim.opt.encoding = "utf-8"
      vim.opt.fileencoding = "utf-8"

      -- 备份和交换文件
      vim.opt.backup = false
      vim.opt.writebackup = false
      vim.opt.swapfile = false

      -- 其他
      vim.opt.mouse = "a"
      vim.opt.clipboard = "unnamedplus"
      vim.opt.undofile = true
      vim.opt.updatetime = 300
      vim.opt.timeoutlen = 500

      -- ============================================================================
      -- 按键映射
      -- ============================================================================

      vim.g.mapleader = " "
      vim.g.maplocalleader = " "

      vim.keymap.set("n", "<leader>w", ":w<CR>", { desc = "保存文件" })
      vim.keymap.set("n", "<leader>q", ":q<CR>", { desc = "退出" })
      vim.keymap.set("n", "<leader>Q", ":qa!<CR>", { desc = "强制退出所有" })
      vim.keymap.set("n", "<Esc>", ":nohlsearch<CR>", { silent = true })

      -- Ctrl + hjkl 窗口导航
      vim.keymap.set("n", "<C-h>", "<C-w>h", { desc = "移动到左侧窗口" })
      vim.keymap.set("n", "<C-j>", "<C-w>j", { desc = "移动到下方窗口" })
      vim.keymap.set("n", "<C-k>", "<C-w>k", { desc = "移动到上方窗口" })
      vim.keymap.set("n", "<C-l>", "<C-w>l", { desc = "移动到右侧窗口" })

      vim.keymap.set("n", "<C-Up>", ":resize +2<CR>", { desc = "增加窗口高度" })
      vim.keymap.set("n", "<C-Down>", ":resize -2<CR>", { desc = "减少窗口高度" })
      vim.keymap.set("n", "<C-Left>", ":vertical resize -2<CR>", { desc = "减少窗口宽度" })
      vim.keymap.set("n", "<C-Right>", ":vertical resize +2<CR>", { desc = "增加窗口宽度" })

      vim.keymap.set("v", "<", "<gv", { desc = "左缩进并保持选择" })
      vim.keymap.set("v", ">", ">gv", { desc = "右缩进并保持选择" })
      vim.keymap.set("v", "J", ":m '>+1<CR>gv=gv", { desc = "向下移动选中行" })
      vim.keymap.set("v", "K", ":m '<-2<CR>gv=gv", { desc = "向上移动选中行" })

      -- 粘贴后不覆盖寄存器
      vim.keymap.set("x", "<leader>p", '"_dP', { desc = "粘贴不覆盖寄存器" })

      vim.keymap.set("n", "<leader>y", '"+y', { desc = "复制到系统剪贴板" })
      vim.keymap.set("v", "<leader>y", '"+y', { desc = "复制到系统剪贴板" })
      vim.keymap.set("n", "<leader>Y", '"+Y', { desc = "复制整行到系统剪贴板" })
      vim.keymap.set("n", "<leader>P", '"+p', { desc = "从系统剪贴板粘贴" })
      vim.keymap.set("v", "<leader>P", '"+p', { desc = "从系统剪贴板粘贴" })

      vim.keymap.set("n", "<leader>d", '"_d', { desc = "删除不进入寄存器" })
      vim.keymap.set("v", "<leader>d", '"_d', { desc = "删除不进入寄存器" })
      vim.keymap.set("n", "H", "^", { desc = "跳转到行首" })
      vim.keymap.set("n", "L", "$", { desc = "跳转到行尾" })

      vim.keymap.set("n", "<leader>bn", ":bnext<CR>", { desc = "下一个 buffer" })
      vim.keymap.set("n", "<leader>bp", ":bprevious<CR>", { desc = "上一个 buffer" })
      vim.keymap.set("n", "<leader>bd", ":bdelete<CR>", { desc = "关闭 buffer" })
      vim.keymap.set("n", "<leader>sv", ":vsplit<CR>", { desc = "垂直分屏" })
      vim.keymap.set("n", "<leader>sh", ":split<CR>", { desc = "水平分屏" })
      vim.keymap.set("n", "<leader>sc", ":close<CR>", { desc = "关闭当前窗口" })

      -- ============================================================================
      -- 自动命令
      -- ============================================================================

      vim.api.nvim_create_autocmd("TextYankPost", {
        callback = function()
          vim.highlight.on_yank({ higroup = "IncSearch", timeout = 200 })
        end,
      })

      vim.api.nvim_create_autocmd("BufReadPost", {
        callback = function()
          local mark = vim.api.nvim_buf_get_mark(0, '"')
          if mark[1] > 1 and mark[1] <= vim.api.nvim_buf_line_count(0) then
            vim.api.nvim_win_set_cursor(0, mark)
          end
        end,
      })

      -- ============================================================================
      -- 文件类型特定设置
      -- ============================================================================

      vim.api.nvim_create_autocmd("FileType", {
        pattern = { "javascript", "typescript", "json", "yaml", "html", "css", "lua", "nix" },
        callback = function()
          vim.opt_local.tabstop = 2
          vim.opt_local.shiftwidth = 2
        end,
      })

      -- ============================================================================
      -- 状态栏
      -- ============================================================================

      vim.opt.laststatus = 2
      vim.opt.showmode = false
      vim.opt.statusline = [[%f %m %r %= %l:%c %p%% ]]
    '';
  };
}
