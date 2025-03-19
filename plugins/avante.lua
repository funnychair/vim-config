return {
    "yetone/avante.nvim",
    event = "VeryLazy",
    version = "*",  -- false 表示使用最新代碼，設置為 "*" 則使用最新發布版本
    lazy = false,
    
    -- 核心配置
    -- configs = {
    opts = {
        provider = "claude",
        auto_suggestions_provider = "claude",
        cursor_applying_provider = 'claude',
        behaviour = {
            --- ... existing behaviours
            enable_cursor_planning_mode = true, -- enable cursor planning mode!
        },
        claude = {
            endpoint = 'https://api.anthropic.com',
            model = 'claude-3-7-sonnet-20250219',
            max_tokens = 20000,
            thinking = {
                type = 'enabled',
                budget_tokens = 3600,
            },
            temperature = 1,
        },
        windows = {
            width = 45,
        },
        behaviour = {
            minimize_diff = false,
        },
    },

    
    -- 編譯設置
    build = "make",  -- Windows 用戶使用：powershell -ExecutionPolicy Bypass -File Build.ps1 -BuildFromSource false
    
    -- 依賴插件
    dependencies = {
        -- 必需依賴
        "nvim-treesitter/nvim-treesitter",
        "stevearc/dressing.nvim",
        "nvim-lua/plenary.nvim",
        "MunifTanjim/nui.nvim",
        
        -- 文件選擇器相關
        "echasnovski/mini.pick",          -- mini.pick 支持
        "nvim-telescope/telescope.nvim",   -- telescope 支持
        "ibhagwan/fzf-lua",               -- fzf 支持
        
        -- 功能增強
        "hrsh7th/nvim-cmp",              -- 自動完成
        "nvim-tree/nvim-web-devicons",    -- 圖標支持
        "zbirenbaum/copilot.lua",         -- Copilot 支持
        
        -- 圖片粘貼支持
        {
            "HakonHarnes/img-clip.nvim",
            event = "VeryLazy",
            opts = {
                default = {
                    embed_image_as_base64 = false,
                    prompt_for_file_name = false,
                    drag_and_drop = {
                        insert_mode = true,
                    },
                    use_absolute_path = true,  -- Windows 用戶必需
                },
            },
        },
        
        -- Markdown 渲染支持
        {
            'MeanderingProgrammer/render-markdown.nvim',
            opts = {
                file_types = { "markdown", "Avante" },
            },
            ft = { "markdown", "Avante" },
        },
    },
}
