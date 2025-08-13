-- Базовые настройки
vim.g.mapleader = " "  -- Пробел как leader-клавиша
vim.opt.number = true  -- Номера строк

-- Инициализация Lazy.nvim (менеджер плагинов)
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

-- Настройка плагинов
require("lazy").setup({
  -- Файловое дерево (минимальная конфигурация)
  {
    "nvim-tree/nvim-tree.lua",
    version = "*",  -- Последняя стабильная версия
    dependencies = { "nvim-tree/nvim-web-devicons" },
    config = function()
      -- Функция для открытия папки проекта
      local function open_project_folder()
        local path = vim.fn.getcwd()  -- Берем текущую рабочую директорию
        require("nvim-tree.api").tree.open({ path = path })
      end

      -- Настройки дерева
      require("nvim-tree").setup({
        view = {
          width = 30,
          side = "left",
        },
        filters = {
          dotfiles = false,  -- Показывать скрытые файлы
        },
      })

      -- Горячие клавиши
      vim.keymap.set("n", "<leader>e", open_project_folder, { desc = "Open project folder" })
    end,
  }
})

-- Автоматическое открытие папки при старте Neovim
vim.api.nvim_create_autocmd("VimEnter", {
  callback = function(data)
    -- Если открыли папку (nvim /path/to/folder)
    if vim.fn.isdirectory(data.file) == 1 then
      vim.cmd.cd(data.file)
      vim.cmd("NvimTreeOpen")
    -- Если открыли файл (nvim file.py)
    elseif vim.fn.filereadable(data.file) == 1 then
      vim.cmd("NvimTreeFindFile")
    end
  end
})
