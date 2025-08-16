-- =============================================
-- Basic Settings
-- =============================================
vim.g.mapleader = " "  -- Set space as leader key
vim.opt.number = true  -- Enable line numbers
vim.opt.relativenumber = true  -- Relative line numbers
vim.opt.termguicolors = true  -- Enable true color support

-- =============================================
-- Lazy.nvim Initialization (Plugin Manager)
-- =============================================
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
  vim.fn.system({
    "git",
    "clone",
    "--filter=blob:none",
    "https://github.com/folke/lazy.nvim.git",
    "--branch=stable",
    lazypath,
  })
end
vim.opt.rtp:prepend(lazypath)  -- Add to runtime path

-- =============================================
-- Plugin Configurations
-- =============================================
require("lazy").setup({
  -- File Tree Configuration
  {
    "nvim-tree/nvim-tree.lua",
    dependencies = { "nvim-tree/nvim-web-devicons" },
    config = function()
      require("nvim-tree").setup({
        view = {
          width = 30,  -- Tree width
          side = "left",  -- Position on left side
        },
        filters = {
          dotfiles = false,  -- Show hidden files
        },
      })
      -- Toggle file tree with <leader>e
      vim.keymap.set("n", "<leader>e", ":NvimTreeToggle<CR>", { silent = true })
    end,
  },

  -- Python Syntax Highlighting (Your Custom Version)
  {
    "nvim-treesitter/nvim-treesitter",
    build = ":TSUpdate",  -- Command to install parsers
    config = function()
      require("nvim-treesitter.configs").setup({
        ensure_installed = { "python" },  -- Only Python parser
        highlight = {
          enable = true,
          additional_vim_regex_highlighting = false,  -- Disable legacy regex
          -- Custom highlight groups
          custom_captures = {
            ["function"] = "Function",
            ["keyword"] = "Keyword",
            ["string"] = "String",
            ["number"] = "Number",
          },
        },
      })
      -- Custom color overrides
      vim.cmd([[
        hi @function guifg=#FF5555  " Bright red functions
        hi @keyword guifg=#FF79C6  " Pink keywords
        hi @string guifg=#F1FA8C  " Yellow strings
        hi @number guifg=#BD93F9  " Purple numbers
        hi @parameter guifg=#50FA7B  " Green parameters
      ]])
    end
  },
  
  -- Auto-closing brackets and tags
  {
    "windwp/nvim-autopairs",
    config = function()
      require("nvim-autopairs").setup({
        check_ts = true,  -- Use treesitter
        fast_wrap = {},    -- Enable fast wrap
      })
    end
  }
})

-- =============================================
-- Auto Commands
-- =============================================
-- Automatically open file tree when starting in directory
vim.api.nvim_create_autocmd("VimEnter", {
  callback = function(data)
    if vim.fn.isdirectory(data.file) == 1 then
      vim.cmd.cd(data.file)  -- Change to directory
      vim.cmd("NvimTreeOpen")  -- Open file tree
    end
  end
})
