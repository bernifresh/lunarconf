-- Read the docs: https://www.lunarvim.org/docs/configuration
-- Example configs: https://github.com/LunarVim/starter.lvim
-- Video Tutorials: https://www.youtube.com/watch?v=sFA9kX-Ud_c&list=PLhoH5vyxr6QqGu0i7tt_XoVK9v-KvZ3m6
-- Forum: https://www.reddit.com/r/lunarvim/
-- Discord: https://discord.com/invite/Xb9B4Ny

-- keybindings
local opts = { noremap = true, silent = true }
local keymap = vim.api.nvim_set_keymap
keymap("n", "<A-Left>", ":BufferLineCyclePrev<CR>", opts)
keymap("n", "<A-Right>", ":BufferLineCycleNext<CR>", opts)
keymap("n", "<A-f>", ":NvimTreeFocus<CR>", opts)

-- General Settings
lvim.autosave = true
lvim.format_on_save = true
lvim.builtin.nvimtree.setup.view = {
  adaptive_size = true,
}

-- Colorscheme global variables for "rafamadriz/neon" scheme
vim.g.neon_style = "dark"
vim.g.neon_italic_keyword = true

-- Colorscheme
lvim.colorscheme = "neon"

-- Plugins
lvim.plugins = {
  { "nvim-treesitter/nvim-treesitter-angular" },
  { "rafamadriz/neon" },
  'shaunsingh/moonlight.nvim',
  { "lunarvim/colorschemes" },
  "mfussenegger/nvim-jdtls",
  {
    "sindrets/diffview.nvim",
    event = "BufRead",
  },
  {
    "rmagatti/goto-preview",
    config = function()
      require('goto-preview').setup {
        width = 120,             -- Width of the floating window
        height = 25,             -- Height of the floating window
        default_mappings = true, -- Bind default mappings
        debug = false,           -- Print debug information
        opacity = nil,           -- 0-100 opacity level of the floating window where 100 is fully transparent.
        post_open_hook = nil,    -- A function taking two arguments, a buffer and a window to be ran as a hook.
        -- You can use "default_mappings = true" setup option
        -- Or explicitly set keybindings
        -- vim.cmd("nnoremap gpd <cmd>lua require('goto-preview').goto_preview_definition()<CR>")
        -- vim.cmd("nnoremap gpi <cmd>lua require('goto-preview').goto_preview_implementation()<CR>")
        -- vim.cmd("nnoremap gP <cmd>lua require('goto-preview').close_all_win()<CR>")
      }
    end
  },
  {
    "nacro90/numb.nvim",
    event = "BufRead",
    config = function()
      require("numb").setup {
        show_numbers = true,    -- Enable 'number' for the window while peeking
        show_cursorline = true, -- Enable 'cursorline' for the window while peeking
      }
    end,
  },
}

-- CSharp Config
local enabled_csharp_ls = "omnisharp"
local disabled_csharp_ls = "csharp_ls"
lvim.lsp.installer.setup.ensure_installed =
    vim.list_extend(lvim.lsp.installer.setup.ensure_installed, { enabled_csharp_ls })
lvim.lsp.automatic_configuration.skipped_servers =
    vim.list_extend(lvim.lsp.automatic_configuration.skipped_servers, { disabled_csharp_ls })

-- Configure omnisharp
if enabled_csharp_ls == "omnisharp" then
  local omnisharp_opts = {}
  local status_ok, omnisharp_extended = pcall(require, "omnisharp_extended")
  if status_ok then
    omnisharp_opts = {
      handlers = {
        ["textDocument/definition"] = omnisharp_extended.handler,
      },
      organize_imports_on_format = true,
      sdk_include_prereleases = false,
      enable_roslyn_analyzers = true,
      analyze_open_documents_only = true,
    }
  end
  require("lvim.lsp.manager").setup("omnisharp", omnisharp_opts)
  --
  -- OmniSharp is used and configured. Return.
  return
end

--
-- Omnisharp not used
--
local csharp_ls_opts = {}
require("lspconfig")[enabled_csharp_ls].setup(csharp_ls_opts)


-- Skip LSP servervs
--vim.list_extend(lvim.lsp.automatic_configuration.skipped_servers, { "csharp_ls" })
--lvim.lsp.automatic_configuration.skipped_servers = vim.tbl_filter(
--  function(server) return server ~= "omnisharp" end,
--  lvim.lsp.automatic_configuration.skipped_servers)

vim.list_extend(lvim.lsp.automatic_configuration.skipped_servers, { "clangd" })
lvim.lsp.automatic_configuration.skipped_servers = vim.tbl_filter(
  function(server) return server ~= "ccls" end,
  lvim.lsp.automatic_configuration.skipped_servers)

vim.list_extend(lvim.lsp.automatic_configuration.skipped_servers, { "groovyls" })
lvim.lsp.automatic_configuration.skipped_servers = vim.tbl_filter(
  function(server) return server ~= "gradle_ls" end,
  lvim.lsp.automatic_configuration.skipped_servers)

vim.list_extend(lvim.lsp.automatic_configuration.skipped_servers, { "jdtls" })
lvim.lsp.automatic_configuration.skipped_servers = vim.tbl_filter(
  function(server) return server ~= "java" end,
  lvim.lsp.automatic_configuration.skipped_servers)

-- Java configuration
lvim.builtin.treesitter.ensure_installed = {
  "java",
}

-- C Lang configuration
require("lvim.lsp.manager").setup("ccls")

-- Move between buffer views
keymap("n", "<A-Left>", ":BufferLineCyclePrev<CR>", opts)
keymap("n", "<A-Right>", ":BufferLineCycleNext<CR>", opts)

-- Nvim Tree keybinding settings
keymap("n", "<A-f>", ":NvimTreeFocus<CR>", opts)
