-- Basic settings
vim.g.mapleader = " "
vim.opt.number = true
vim.opt.relativenumber = true
vim.opt.termguicolors = true 

-- Initialize Lazy.nvim
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
vim.opt.rtp:prepend(lazypath)

-- Plugins
require("lazy").setup({
  -- NVIM-TREE
  {
    "nvim-tree/nvim-tree.lua",
    dependencies = { "nvim-tree/nvim-web-devicons" },
    config = function()
      require("nvim-tree").setup({
        view = {
          width = 30,
          side = "left",
        },
        renderer = {
          highlight_opened_files = "name",
        },
      })

      vim.keymap.set("n", "<leader>e", ":NvimTreeToggle<CR>", { silent = true })
    end,
  },

  -- Treesitter
  {
    "nvim-treesitter/nvim-treesitter",
    build = ":TSUpdate",
    config = function()
      require("nvim-treesitter.configs").setup({
        ensure_installed = { "python" },
        highlight = {
          enable = true,
          additional_vim_regex_highlighting = false,
          custom_captures = {
            ["function"] = "Function",
            ["keyword"] = "Keyword",
            ["string"] = "String",
            ["number"] = "Number",
          },
        },
      })
      
      --  Color settings
      vim.cmd([[
        hi @function guifg=#FF5555
        hi @keyword guifg=#FF79C6
        hi @string guifg=#F1FA8C
        hi @number guifg=#BD93F9
        hi @parameter guifg=#50FA7B
      ]])
    end
  }
})

-- Autostart tree at startup
vim.api.nvim_create_autocmd("VimEnter", {
  callback = function(data)
    if vim.fn.isdirectory(data.file) == 1 then
      vim.cmd.cd(data.file)
      require("nvim-tree.api").tree.toggle()
    end
  end
})

-- Fallback syntax
vim.cmd([[
  syntax on
  filetype plugin indent on
  autocmd FileType python setlocal syntax=python
]])
