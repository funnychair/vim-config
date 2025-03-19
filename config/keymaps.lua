-- 按鍵映射
local keymap = vim.keymap.set

-- 基礎按鍵映射
keymap('i', ';;', '<Esc>')
keymap('n', 'zz', '<C-w>')
vim.g.mapleader = ','

-- Buffer 導航
keymap('n', 'zx<Right>', ':bn<CR>')
keymap('n', 'zx<Left>', ':bp<CR>')
keymap('n', 'zx<Up>', ':bp<CR>:bd #<CR>')
keymap('n', 'zxl', ':bn<CR>')
keymap('n', 'zxh', ':bp<CR>')
keymap('n', 'zxk', ':bp<CR>:bd #<CR>')

-- 補全相關按鍵映射
keymap('i', '<CR>', 'pumvisible() ? "\\<C-y>" : "\\<CR>"', { expr = true })
keymap('i', '<Down>', 'pumvisible() ? "\\<C-n>" : "\\<Down>"', { expr = true })
keymap('i', '<Up>', 'pumvisible() ? "\\<C-p>" : "\\<Up>"', { expr = true })
keymap('i', '<PageDown>', 'pumvisible() ? "\\<PageDown>\\<C-p>\\<C-n>" : "\\<PageDown>"', { expr = true })
keymap('i', '<PageUp>', 'pumvisible() ? "\\<PageUp>\\<C-p>\\<C-n>" : "\\<PageUp>"', { expr = true })

-- Telescope 快捷鍵
keymap('n', '<leader>ff', '<cmd>Telescope find_files<cr>')     -- 搜尋檔案
keymap('n', '<leader>fg', '<cmd>Telescope live_grep<cr>')      -- 搜尋文字內容
keymap('n', '<leader>fb', '<cmd>Telescope buffers<cr>')        -- 搜尋 buffers
keymap('n', '<leader>fh', '<cmd>Telescope help_tags<cr>')      -- 搜尋說明文件 

-- 新增組合快捷鍵
keymap('n', '<leader>e', function()
    local has_other_win = false
    -- 檢查並關閉已存在的 NvimTree 和 Tagbar
    for _, win in pairs(vim.api.nvim_list_wins()) do
        local buf = vim.api.nvim_win_get_buf(win)
        local buf_name = vim.api.nvim_buf_get_name(buf)
        if buf_name:match("NvimTree_") or buf_name:match("__Tagbar__") then
            vim.api.nvim_win_close(win, true)
            has_other_win = true
        end
    end
    
    -- 如果已經有窗口被關閉，直接返回
    if has_other_win then
        return
    else
        -- 記住當前窗口（主編輯窗口）
        local main_win = vim.api.nvim_get_current_win()
        
        -- 打開 Tagbar
        vim.cmd('TagbarOpen')
        
        -- 打開 NvimTree
        vim.cmd('NvimTreeOpen')
        
        -- 等待窗口完全打開
        vim.defer_fn(function()
            -- 找到 NvimTree 窗口並移動到 Tagbar 下方
            for _, win in pairs(vim.api.nvim_list_wins()) do
                local buf = vim.api.nvim_win_get_buf(win)
                local buf_name = vim.api.nvim_buf_get_name(buf)
                if buf_name:match("NvimTree_") then
                    vim.api.nvim_set_current_win(win)
                    vim.cmd('wincmd J')  -- 移到下方
                    break
                end
            end
            
            -- 移動主編輯窗口到最右側
            vim.api.nvim_set_current_win(main_win)
            vim.cmd('wincmd L')

            -- 調整 NvimTree 和 Tagbar 的窗口大小
            for _, win in pairs(vim.api.nvim_list_wins()) do
                local buf = vim.api.nvim_win_get_buf(win)
                local buf_name = vim.api.nvim_buf_get_name(buf)
                if buf_name:match("NvimTree_") then
                    vim.api.nvim_set_current_win(win)
                    vim.cmd('vertical resize 30')  -- 設定寬度
                elseif buf_name:match("__Tagbar__") then
                    vim.api.nvim_set_current_win(win)
                    vim.cmd('horizontal resize 20')  -- 設定高度
                end
            end
        end, 10)
    end
end) 