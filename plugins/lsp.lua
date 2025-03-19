-- LSP 相關插件
return {
  {
    "williamboman/mason.nvim",
    lazy = false,
    build = function()
      pcall(vim.cmd, "MasonUpdate")
    end,
    config = function()
      require("mason").setup({
        install_root_dir = vim.fn.stdpath("data") .. "/mason",
        max_concurrent_installers = 4,
      })
    end
  },
  {
    "williamboman/mason-lspconfig.nvim",
    lazy = false,
    dependencies = {
      "williamboman/mason.nvim",
    },
    config = function()
      require("mason-lspconfig").setup({
        ensure_installed = { "pyright" },
        automatic_installation = true,
      })
    end
  },
  {
    "neovim/nvim-lspconfig",
    lazy = false,
    event = { "BufReadPre", "BufNewFile" },
    dependencies = {
      "williamboman/mason.nvim",
      "williamboman/mason-lspconfig.nvim",
      "hrsh7th/nvim-cmp",
      "hrsh7th/cmp-nvim-lsp",
      "hrsh7th/cmp-buffer",
      "hrsh7th/cmp-path",
      "hrsh7th/cmp-cmdline",
      "L3MON4D3/LuaSnip",
      "saadparwaiz1/cmp_luasnip",
      "rafamadriz/friendly-snippets",
      "onsails/lspkind.nvim",
    },
    config = function()
      local lspconfig = require("lspconfig")
      local capabilities = require('cmp_nvim_lsp').default_capabilities()

      -- 設置按鍵映射的函數
      local on_attach = function(client, bufnr)
        local opts = { noremap = true, silent = true, buffer = bufnr }
        
        -- 跳轉相關
        vim.keymap.set('n', 'gD', vim.lsp.buf.declaration, opts)     -- 跳轉到聲明
        vim.keymap.set('n', 'gd', vim.lsp.buf.definition, opts)      -- 跳轉到定義
        vim.keymap.set('n', 'gi', vim.lsp.buf.implementation, opts)  -- 跳轉到實現
        vim.keymap.set('n', 'gr', vim.lsp.buf.references, opts)      -- 查找所有引用

        -- 文檔/幫助相關
        vim.keymap.set('n', 'K', vim.lsp.buf.hover, opts)           -- 顯示懸浮文檔
        vim.keymap.set('n', '<C-k>', vim.lsp.buf.signature_help, opts) -- 顯示函數簽名幫助

        -- 工作區相關
        vim.keymap.set('n', '<space>wa', vim.lsp.buf.add_workspace_folder, opts)    -- 添加工作區文件夾
        vim.keymap.set('n', '<space>wr', vim.lsp.buf.remove_workspace_folder, opts) -- 移除工作區文件夾
        vim.keymap.set('n', '<space>wl', function()
          print(vim.inspect(vim.lsp.buf.list_workspace_folders()))
        end, opts)                                                    -- 列出工作區文件夾

        -- 代碼操作相關
        vim.keymap.set('n', '<space>D', vim.lsp.buf.type_definition, opts) -- 跳轉到類型定義
        vim.keymap.set('n', '<space>rn', vim.lsp.buf.rename, opts)         -- 重命名
        vim.keymap.set('n', '<space>ca', vim.lsp.buf.code_action, opts)    -- 代碼操作
        vim.keymap.set('n', '<space>f', function() 
          vim.lsp.buf.format { async = true } 
        end, opts)                                                    -- 格式化代碼

        -- 診斷相關
        vim.keymap.set('n', '<space>e', vim.diagnostic.open_float, opts)   -- 顯示浮動診斷
        vim.keymap.set('n', '[d', vim.diagnostic.goto_prev, opts)          -- 跳轉到上一個診斷
        vim.keymap.set('n', ']d', vim.diagnostic.goto_next, opts)          -- 跳轉到下一個診斷
        vim.keymap.set('n', '<space>q', vim.diagnostic.setloclist, opts)   -- 在位置列表中顯示診斷
      end

      -- 設置診斷圖標
      local signs = {
        Error = " ",
        Warn = " ",
        Hint = " ",
        Info = " ",
      }
      for type, icon in pairs(signs) do
        local hl = "DiagnosticSign" .. type
        vim.fn.sign_define(hl, { text = icon, texthl = hl, numhl = hl })
      end

      -- 添加內聯診斷顯示
      vim.diagnostic.config({
        virtual_text = {
          prefix = '●',
          spacing = 4,
          source = "always",
        },
        float = {
          source = "always",
          border = "rounded",
          header = "",
          prefix = "",
        },
        signs = true,
        underline = true,
        update_in_insert = false,
        severity_sort = true,
      })

      -- 添加文檔符號指示
      vim.api.nvim_create_autocmd("CursorHold", {
        callback = function()
          vim.diagnostic.open_float(nil, { focus = false })
        end
      })

      -- 修改退出處理邏輯
      vim.api.nvim_create_autocmd('VimLeavePre', {
        callback = function()
          -- 設置更短的超時時間
          local timeout = 300 -- 毫秒
          
          -- 強制殺死所有相關進程
          vim.fn.system('pkill -f pyright-langserver')
          
          -- 獲取當前活動的客戶端
          local clients = vim.lsp.get_active_clients()
          if #clients == 0 then
            return
          end

          -- 立即停止所有客戶端
          for _, client in ipairs(clients) do
            vim.notify('強制停止 LSP 客戶端: ' .. client.name)
            pcall(function()
              client.stop(true) -- 強制停止
              client.kill()     -- 強制殺死
            end)
          end

          -- 強制同步和清理
          vim.cmd('silent! wa')   -- 保存所有文件
          vim.cmd('silent! %bd!') -- 強制關閉所有緩衝區
          
          -- 設置超時強制退出
          local timer = vim.loop.new_timer()
          timer:start(timeout, 0, vim.schedule_wrap(function()
            timer:stop()
            timer:close()
            vim.notify('強制退出')
            vim.cmd('quit!')
          end))
        end,
        group = vim.api.nvim_create_augroup('LSPShutdown', { clear = true })
      })

      -- 修改 pyright 設置
      lspconfig.pyright.setup({
        capabilities = capabilities,
        on_attach = on_attach,
        flags = {
          debounce_text_changes = 150,
          exit_timeout = 300,    -- 降低退出超時時間
          allow_incremental_sync = false,  -- 禁用增量同步
        },
        settings = {
          python = {
            analysis = {
              autoSearchPaths = true,
              diagnosticMode = "workspace",
              useLibraryCodeForTypes = true,
              typeCheckingMode = "basic", -- 可選: "off", "basic", "strict"
              
              -- 添加更多分析選項
              diagnosticSeverityOverrides = {
                reportGeneralTypeIssues = "warning",
                reportOptionalMemberAccess = "warning",
                reportOptionalSubscript = "warning",
                reportPrivateImportUsage = "warning",
              },
              
              -- 智能導入管理
              autoImportCompletions = true,
              
              -- 更好的類型檢查
              inlayHints = {
                variableTypes = true,
                functionReturnTypes = true,
                parameterTypes = true,
              },
              
              -- 排除特定目錄
              exclude = {
                "**/node_modules",
                "**/__pycache__",
                "**/venv",
              },
            }
          }
        },
      })

      -- 設置 nvim-cmp
      local cmp = require('cmp')
      local luasnip = require('luasnip')
      local lspkind = require('lspkind')

      cmp.setup({
        snippet = {
          expand = function(args)
            luasnip.lsp_expand(args.body)
          end,
        },
        window = {
          completion = cmp.config.window.bordered(),
          documentation = cmp.config.window.bordered(),
        },
        mapping = cmp.mapping.preset.insert({
          -- 基本導航
          ['<C-n>'] = cmp.mapping.select_next_item(),     -- 下一個選項
          ['<C-p>'] = cmp.mapping.select_prev_item(),     -- 上一個選項
          ['<C-b>'] = cmp.mapping.scroll_docs(-4),        -- 文檔向上滾動
          ['<C-f>'] = cmp.mapping.scroll_docs(4),         -- 文檔向下滾動
          
          -- 觸發補全
          ['<C-Space>'] = cmp.mapping.complete(),         -- 手動觸發補全
          ['<C-e>'] = cmp.mapping.abort(),                -- 取消補全
          ['<CR>'] = cmp.mapping.confirm({                -- 確認選中
            behavior = cmp.ConfirmBehavior.Replace,
            select = true,
          }),
          
          -- Tab 鍵行為
          ['<Tab>'] = cmp.mapping(function(fallback)
            if cmp.visible() then
              cmp.select_next_item()
            elseif luasnip.expand_or_jumpable() then
              luasnip.expand_or_jump()
            else
              fallback()
            end
          end, { 'i', 's' }),
          
          ['<S-Tab>'] = cmp.mapping(function(fallback)
            if cmp.visible() then
              cmp.select_prev_item()
            elseif luasnip.jumpable(-1) then
              luasnip.jump(-1)
            else
              fallback()
            end
          end, { 'i', 's' }),
          
          -- 額外的快捷鍵
          ['<C-j>'] = cmp.mapping(function(fallback)
            if luasnip.jumpable(1) then
              luasnip.jump(1)
            else
              fallback()
            end
          end, { 'i', 's' }),
          
          ['<C-k>'] = cmp.mapping(function(fallback)
            if luasnip.jumpable(-1) then
              luasnip.jump(-1)
            else
              fallback()
            end
          end, { 'i', 's' }),
        }),
        
        -- 補全來源優先級
        sources = cmp.config.sources({
          { name = 'nvim_lsp', priority = 1000 },    -- LSP
          { name = 'luasnip', priority = 750 },      -- 程式碼片段
          { name = 'buffer', priority = 500 },        -- 緩衝區內容
          { name = 'path', priority = 250 },          -- 文件路徑
        }),
        
        -- 補全項格式化
        formatting = {
          format = require('lspkind').cmp_format({
            mode = 'symbol_text',
            maxwidth = 50,
            ellipsis_char = '...',
            -- 顯示來源
            menu = ({
              buffer = "[Buffer]",
              nvim_lsp = "[LSP]",
              luasnip = "[Snippet]",
              path = "[Path]",
            })
          })
        },
      })
    end,
  },
  
  -- 添加 Python 專用工具
  {
    "nvim-treesitter/nvim-treesitter",
    build = ":TSUpdate",
    config = function()
      require('nvim-treesitter.configs').setup({
        ensure_installed = { "python", "lua" },
        highlight = { enable = true },
        indent = { enable = true },
      })
    end
  },
} 