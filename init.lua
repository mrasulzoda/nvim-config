-- Basic settings 
vim.g.mapleader = " "  -- Space as leader key
vim.opt.number = true  -- Line numbers
vim.o.relativenumber = true -- Relative line numbers
-- Initializing Lazy.nvim (plugin manager)
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

-- Setting up plugins 
require("lazy").setup({
   -- File tree (minimal configuration)
   {
    "nvim-tree/nvim-tree.lua",
    version = "*",  --  Latest stable version
    dependencies = { "nvim-tree/nvim-web-devicons" },
    config = function()
       -- Function to open a project folder
       local function open_project_folder()
        local path = vim.fn.getcwd()  --  Take the current working directory
	require("nvim-tree.api").tree.open({ path = path })
      end

      --  Tree settings
      require("nvim-tree").setup({
        view = {
          width = 30,
          side = "left",
        },
        filters = {
          dotfiles = false,   -- Show hidden files
  	},
      })

      --  Hotkeys
      vim.keymap.set("n", "<leader>e", open_project_folder, { desc = "Open project folder" })
    end,
  }
})

--  Automatically open folder when Neovim starts 
vim.api.nvim_create_autocmd("VimEnter", {
  callback = function(data)
    --  If you opened a folder (nvim /path/to/folder)
    if vim.fn.isdirectory(data.file) == 1 then
      vim.cmd.cd(data.file)
      vim.cmd("NvimTreeOpen")
    --  If you opened a file (nvim file.py)
    elseif vim.fn.filereadable(data.file) == 1 then
      vim.cmd("NvimTreeFindFile")
    end
  end
})
