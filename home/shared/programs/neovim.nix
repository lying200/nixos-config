{ pkgs, ... }:

{
  programs.neovim = {
    enable = true;
    defaultEditor = true;  # 设置为默认编辑器
    viAlias = true;        # 创建 vi 别名
    vimAlias = true;       # 创建 vim 别名

    # 额外的软件包（用于系统剪贴板支持等）
    extraPackages = with pkgs; [
      wl-clipboard       # Wayland 剪贴板工具
      xclip             # X11 剪贴板工具（兼容性）
    ];

    # Neovim 配置
    initLua = ''
      -- ============================================================================
      -- 基础设置
      -- ============================================================================

      -- 行号
      vim.opt.number = true           -- 显示行号
      vim.opt.relativenumber = true   -- 相对行号（便于跳转）

      -- 缩进
      vim.opt.tabstop = 4             -- Tab 宽度
      vim.opt.shiftwidth = 4          -- 自动缩进宽度
      vim.opt.expandtab = true        -- 用空格替代 Tab
      vim.opt.smartindent = true      -- 智能缩进
      vim.opt.autoindent = true       -- 自动缩进

      -- 搜索
      vim.opt.ignorecase = true       -- 搜索忽略大小写
      vim.opt.smartcase = true        -- 智能大小写（有大写时区分）
      vim.opt.hlsearch = true         -- 高亮搜索结果
      vim.opt.incsearch = true        -- 增量搜索

      -- 界面
      vim.opt.cursorline = true       -- 高亮当前行
      vim.opt.termguicolors = true    -- 真彩色支持
      vim.opt.signcolumn = "yes"      -- 始终显示符号列
      vim.opt.wrap = false            -- 不自动换行
      vim.opt.scrolloff = 8           -- 滚动时保持 8 行上下文
      vim.opt.sidescrolloff = 8       -- 横向滚动时保持 8 列上下文

      -- 分割窗口
      vim.opt.splitright = true       -- 垂直分割在右边
      vim.opt.splitbelow = true       -- 水平分割在下边

      -- 文件编码
      vim.opt.encoding = "utf-8"
      vim.opt.fileencoding = "utf-8"

      -- 备份和交换文件
      vim.opt.backup = false
      vim.opt.writebackup = false
      vim.opt.swapfile = false

      -- 其他
      vim.opt.mouse = "a"             -- 启用鼠标支持
      vim.opt.clipboard = "unnamedplus"  -- 使用系统剪贴板
      vim.opt.undofile = true         -- 持久化撤销
      vim.opt.updatetime = 300        -- 更快的更新时间
      vim.opt.timeoutlen = 500        -- 映射序列等待时间

      -- ============================================================================
      -- 按键映射
      -- ============================================================================

      -- Leader 键设置为空格
      vim.g.mapleader = " "
      vim.g.maplocalleader = " "

      -- 快速保存和退出
      vim.keymap.set("n", "<leader>w", ":w<CR>", { desc = "保存文件" })
      vim.keymap.set("n", "<leader>q", ":q<CR>", { desc = "退出" })
      vim.keymap.set("n", "<leader>Q", ":qa!<CR>", { desc = "强制退出所有" })

      -- 取消搜索高亮
      vim.keymap.set("n", "<Esc>", ":nohlsearch<CR>", { silent = true })

      -- 窗口导航（Ctrl + hjkl）
      vim.keymap.set("n", "<C-h>", "<C-w>h", { desc = "移动到左侧窗口" })
      vim.keymap.set("n", "<C-j>", "<C-w>j", { desc = "移动到下方窗口" })
      vim.keymap.set("n", "<C-k>", "<C-w>k", { desc = "移动到上方窗口" })
      vim.keymap.set("n", "<C-l>", "<C-w>l", { desc = "移动到右侧窗口" })

      -- 窗口大小调整
      vim.keymap.set("n", "<C-Up>", ":resize +2<CR>", { desc = "增加窗口高度" })
      vim.keymap.set("n", "<C-Down>", ":resize -2<CR>", { desc = "减少窗口高度" })
      vim.keymap.set("n", "<C-Left>", ":vertical resize -2<CR>", { desc = "减少窗口宽度" })
      vim.keymap.set("n", "<C-Right>", ":vertical resize +2<CR>", { desc = "增加窗口宽度" })

      -- 更好的缩进
      vim.keymap.set("v", "<", "<gv", { desc = "左缩进并保持选择" })
      vim.keymap.set("v", ">", ">gv", { desc = "右缩进并保持选择" })

      -- 移动选中的行
      vim.keymap.set("v", "J", ":m '>+1<CR>gv=gv", { desc = "向下移动选中行" })
      vim.keymap.set("v", "K", ":m '<-2<CR>gv=gv", { desc = "向上移动选中行" })

      -- 更好的粘贴（粘贴后不覆盖寄存器）
      vim.keymap.set("x", "<leader>p", '"_dP', { desc = "粘贴不覆盖寄存器" })

      -- 复制到系统剪贴板
      vim.keymap.set("n", "<leader>y", '"+y', { desc = "复制到系统剪贴板" })
      vim.keymap.set("v", "<leader>y", '"+y', { desc = "复制到系统剪贴板" })
      vim.keymap.set("n", "<leader>Y", '"+Y', { desc = "复制整行到系统剪贴板" })

      -- 从系统剪贴板粘贴
      vim.keymap.set("n", "<leader>P", '"+p', { desc = "从系统剪贴板粘贴" })
      vim.keymap.set("v", "<leader>P", '"+p', { desc = "从系统剪贴板粘贴" })

      -- 删除不进入寄存器
      vim.keymap.set("n", "<leader>d", '"_d', { desc = "删除不进入寄存器" })
      vim.keymap.set("v", "<leader>d", '"_d', { desc = "删除不进入寄存器" })

      -- 快速跳转到行首/行尾
      vim.keymap.set("n", "H", "^", { desc = "跳转到行首" })
      vim.keymap.set("n", "L", "$", { desc = "跳转到行尾" })

      -- Buffer 操作
      vim.keymap.set("n", "<leader>bn", ":bnext<CR>", { desc = "下一个 buffer" })
      vim.keymap.set("n", "<leader>bp", ":bprevious<CR>", { desc = "上一个 buffer" })
      vim.keymap.set("n", "<leader>bd", ":bdelete<CR>", { desc = "关闭 buffer" })

      -- 分屏操作
      vim.keymap.set("n", "<leader>sv", ":vsplit<CR>", { desc = "垂直分屏" })
      vim.keymap.set("n", "<leader>sh", ":split<CR>", { desc = "水平分屏" })
      vim.keymap.set("n", "<leader>sc", ":close<CR>", { desc = "关闭当前窗口" })

      -- ============================================================================
      -- 自动命令
      -- ============================================================================

      -- 高亮复制的文本
      vim.api.nvim_create_autocmd("TextYankPost", {
        callback = function()
          vim.highlight.on_yank({ higroup = "IncSearch", timeout = 200 })
        end,
      })

      -- 打开文件时恢复光标位置
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

      -- 简单的状态栏配置
      vim.opt.laststatus = 2
      vim.opt.showmode = false

      -- 自定义状态栏
      vim.opt.statusline = [[%f %m %r %= %l:%c %p%% ]]
    '';
  };
}
