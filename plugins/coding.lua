-- 編碼相關插件
return {
  -- Git 整合
  "tpope/vim-fugitive",

  -- Go 支援
  {
    "fatih/vim-go",
    ft = "go",
    config = function()
      -- vim-go 的具體配置
    end,
  },
} 