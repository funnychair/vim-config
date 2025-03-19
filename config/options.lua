-- 基礎設置
local opt = vim.opt

-- 顯示相關
opt.termguicolors = true
opt.list = true
opt.listchars = {
  eol = '$',
  tab = '>.',
  trail = '~',
  extends = '>',
  precedes = '<'
}

-- 補全相關
opt.completeopt = 'longest,menu'

-- 其他設置
vim.cmd([[
  autocmd InsertLeave * if pumvisible() == 0|pclose|endif
]])

-- 關閉滑鼠
opt.mouse = ""          -- 完全禁用滑鼠
opt.mousemoveevent = false  -- 禁用滑鼠移動事件
opt.mousescroll = "ver:0,hor:0"  -- 禁用滑鼠滾動 