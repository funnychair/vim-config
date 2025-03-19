return {
  {
    'nvim-telescope/telescope.nvim',
    tag = '0.1.5',
    dependencies = {
      'nvim-lua/plenary.nvim',
      {
        'nvim-telescope/telescope-fzf-native.nvim',
        build = 'make',
        cond = function()
          return vim.fn.executable('make') == 1
        end,
      },
    },
    cmd = "Telescope", -- 延遲加載，只在執行 Telescope 命令時才加載
    config = function()
      local telescope = require('telescope')
      telescope.setup({
        defaults = {
          mappings = {
            i = {
              ['<C-u>'] = false,
              ['<C-d>'] = false,
            },
          },
          preview = {
            timeout = 200,  -- 設置預覽超時時間
          },
          cache_picker = {
            num_pickers = 3,  -- 限制快取的選擇器數量
          },
        },
        pickers = {
          find_files = {
            hidden = false,  -- 不搜索隱藏文件
          },
        },
      })
      -- 安全地加載 fzf 擴展
      pcall(telescope.load_extension, 'fzf')
    end,
    keys = {
      { "<leader>ff", "<cmd>Telescope find_files<cr>", desc = "Find Files" },
      { "<leader>fg", "<cmd>Telescope live_grep<cr>", desc = "Live Grep" },
      { "<leader>fb", "<cmd>Telescope buffers<cr>", desc = "Buffers" },
      { "<leader>fh", "<cmd>Telescope help_tags<cr>", desc = "Help Tags" },
    },
  }
} 