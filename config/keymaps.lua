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

-- 文件/代碼導航增強
keymap('n', '<leader>gu', '<cmd>lua vim.lsp.buf.references()<cr>')       -- 查找所有引用 (Go to Usage)
keymap('n', '<leader>gp', '<cmd>lua vim.lsp.diagnostic.goto_prev()<cr>') -- 上一個問題 (Go to Previous)
keymap('n', '<leader>gn', '<cmd>lua vim.lsp.diagnostic.goto_next()<cr>') -- 下一個問題 (Go to Next)
keymap('n', 'g.', '<cmd>lua vim.lsp.buf.code_action()<cr>')              -- 代碼操作
keymap('n', 'gR', '<cmd>lua vim.lsp.buf.rename()<cr>')                   -- 重命名 (Rename)

-- 代碼編輯和快速操作
keymap('n', '<leader>a', 'ggVG')                                         -- 全選 (All)
keymap('x', 'p', '"_dP')                                                 -- 不覆蓋寄存器的貼上
keymap('n', '<leader>y', '"+y')                                          -- 複製到系統剪貼簿
keymap('v', '<leader>y', '"+y')                                          -- 複製到系統剪貼簿
keymap('n', '<leader>Y', '"+Y')                                          -- 複製整行到系統剪貼簿
keymap('n', '<leader>d', '"_d')                                          -- 刪除但不保存到寄存器
keymap('v', '<leader>d', '"_d')                                          -- 刪除但不保存到寄存器
keymap('n', '<C-s>', '<cmd>w<cr>')                                       -- 保存文件
keymap('i', '<C-s>', '<Esc><cmd>w<cr>')                                  -- 從插入模式保存文件
keymap('n', '<leader>w', '<cmd>w<cr>')                                   -- 另一種保存方式
keymap('n', '<leader>cc', '<cmd>normal gcc<cr>')                         -- 註釋代碼行
keymap('v', '<leader>c', '<cmd>normal gc<cr>')                           -- 註釋選中代碼

-- 視窗管理優化
keymap('n', '<C-h>', '<C-w>h')                                           -- 左窗口
keymap('n', '<C-j>', '<C-w>j')                                           -- 下窗口
keymap('n', '<C-k>', '<C-w>k')                                           -- 上窗口
keymap('n', '<C-l>', '<C-w>l')                                           -- 右窗口
keymap('n', '<leader>sv', '<cmd>vsplit<cr>')                             -- 垂直分割窗口 (Split Vertical)
keymap('n', '<leader>sh', '<cmd>split<cr>')                              -- 水平分割窗口 (Split Horizontal)
keymap('n', '<leader>se', '<C-w>=')                                      -- 均衡窗口大小 (Split Equal)
keymap('n', '<leader>sx', '<cmd>close<cr>')                              -- 關閉當前窗口 (Split Close)

-- 文本操作
keymap('n', 'J', 'mzJ`z')                                                -- 保持光標位置的情況下加入行
keymap('n', '<leader>p', '"0p')                                          -- 從 0 號寄存器貼上
keymap('n', '<leader>P', '"0P')                                          -- 從 0 號寄存器貼上
keymap('v', '<', '<gv')                                                  -- 縮進並保持選中
keymap('v', '>', '>gv')                                                  -- 縮進並保持選中
keymap('v', 'J', ":m '>+1<CR>gv=gv")                                     -- 向下移動選中的行
keymap('v', 'K', ":m '<-2<CR>gv=gv")                                     -- 向上移動選中的行

-- 實用開發工具
keymap('n', '<leader>tt', '<cmd>TagbarToggle<cr>')                       -- 切換 Tagbar
keymap('n', '<leader>tn', '<cmd>NvimTreeToggle<cr>')                     -- 切換檔案樹
keymap('n', '<leader>th', '<cmd>nohlsearch<cr>')                         -- 關閉搜尋高亮 (Toggle Highlight)
keymap('n', '<leader>tf', '<cmd>lua vim.lsp.buf.format()<cr>')           -- 格式化文件 (Toggle Format)
keymap('n', '<Esc>', '<cmd>noh<cr><Esc>')                                -- 按 Esc 關閉搜尋高亮
keymap('n', '<leader>r', '<cmd>lua vim.lsp.buf.rename()<cr>')            -- 重命名變數/函數


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

-- AI 輔助功能快捷鍵
keymap('n', '<leader>ai', '<cmd>AvanteChat<cr>')                         -- 開啟 AI 聊天
keymap('v', '<leader>ai', '<cmd>AvanteChat<cr>')                         -- 選擇文本後開啟 AI 聊天

-- 會話與專案管理
keymap('n', '<leader>ss', '<cmd>SessionSave<cr>')                        -- 保存當前會話
keymap('n', '<leader>sl', '<cmd>SessionLoad<cr>')                        -- 載入會話
keymap('n', '<leader>q', '<cmd>qa<cr>')                                  -- 退出所有

-- 終端和執行命令
keymap('n', '<leader>t', '<cmd>terminal<cr>i')                           -- 開啟內建終端
keymap('t', '<Esc>', '<C-\\><C-n>')                                      -- 從終端模式退出
keymap('n', '<leader>rr', function()                                     -- 執行當前文件
    local ft = vim.bo.filetype
    if ft == 'python' then
        vim.cmd('!python %')
    elseif ft == 'lua' then
        vim.cmd('luafile %')
    elseif ft == 'sh' or ft == 'bash' or ft == 'zsh' then
        vim.cmd('!bash %')
    elseif ft == 'javascript' or ft == 'typescript' then
        vim.cmd('!node %')
    elseif ft == 'go' then
        vim.cmd('!go run %')
    else
        vim.notify('不支援自動運行此類文件', vim.log.levels.WARN)
    end
end)

-- Avante 特定功能
keymap('n', '<C-a>', '<cmd>AvanteMakeSuggestion<cr>')                   -- 觸發 Avante 建議
keymap('n', '<leader>ac', '<cmd>AvanteClear<cr>')                        -- 清除 Avante 建議
keymap('n', '<leader>ah', '<cmd>AvanteHistory<cr>')                      -- 顯示 Avante 歷史記錄

