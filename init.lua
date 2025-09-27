-- Base settings
vim.loader.enable()
vim.o.signcolumn = "yes"
vim.o.undofile = true
vim.o.number = true
vim.o.tabstop = 4
vim.o.relativenumber = true
vim.g.mapleader = " "
vim.o.wrap = false
vim.o.smartindent = true
vim.o.incsearch = true
vim.o.winborder = "rounded"
vim.o.smartcase = true
vim.o.ignorecase = true
vim.o.shiftwidth = 4
vim.o.expandtab = true

-- disable unneeded providers
vim.g.loaded_node_provider = 0
vim.g.loaded_python3_provider = 0
vim.g.loaded_perl_provider = 0
vim.g.loaded_ruby_provider = 0

-- Plugins
vim.pack.add({
    "https://github.com/rebelot/kanagawa.nvim",
    "https://github.com/echasnovski/mini.statusline",
    "https://github.com/echasnovski/mini.pick",
    "https://github.com/echasnovski/mini.completion",
    "https://github.com/echasnovski/mini.icons",
    "https://github.com/echasnovski/mini-git",
    "https://github.com/stevearc/oil.nvim",
    "https://github.com/nvim-treesitter/nvim-treesitter",
    "https://github.com/neovim/nvim-lspconfig",
})

-- Plugin setup
require("mini.icons").setup()
require("mini.statusline").setup()
require("mini.pick").setup()
require("mini.completion").setup()
require("mini.git").setup()
require("oil").setup()
require("nvim-treesitter.configs").setup({
    ensure_installed = { "vue", "typescript", "javascript", "lua" },
    highlight = { enable = true },
})
require("kanagawa").setup({
    colors = {
        theme = {
            all = {
                ui = {
                    bg_gutter = "none"
                }
            }
        }
    }
})
vim.cmd.colorscheme("kanagawa-wave")

-- Keybindings
vim.keymap.set("n", "<Leader>h", MiniPick.builtin.help)
vim.keymap.set("n", "<Leader><Leader>", MiniPick.builtin.buffers)
vim.keymap.set("n", "<Leader>p", MiniPick.builtin.files)
vim.keymap.set("n", "<Leader>g", MiniPick.builtin.grep_live)
vim.keymap.set("n", "<Leader>ec", ":e ~/.config/nvim/init.lua<CR>")
vim.keymap.set("n", "<Leader>w", ":w<CR>")
vim.keymap.set("n", "-", ":Oil<CR>")
vim.keymap.set("n", "<Leader>fm", vim.lsp.buf.format)
vim.keymap.set({"n", "i"}, "gd", vim.lsp.buf.definition)

-- LSP
vim.lsp.enable("lua_ls")
vim.lsp.enable("intelephense")
vim.lsp.enable('vue_ls')
vim.lsp.enable('vtsls')
vim.lsp.enable('ts_ls')
vim.lsp.enable('astro')

local vue_language_server_path = '/opt/homebrew/lib/node_modules/@vue/language-server'
local vue_plugin = {
    name = '@vue/typescript-plugin',
    location = vue_language_server_path,
    languages = { 'vue' },
    configNamespace = 'typescript',
}

vim.lsp.config('vtsls', {
    settings = {
        vtsls = {
            tsserver = {
                globalPlugins = {
                    vue_plugin,
                },
            },
        },
    },
    filetypes = { 'typescript', 'javascript', 'javascriptreact', 'typescriptreact', 'vue' },
})

vim.lsp.config("lua_ls", {
    settings = {
        Lua = {
            workspace = {
                library = vim.api.nvim_get_runtime_file("", true)
            }
        }
    }
})

-- Neovide specific settings
if vim.g.neovide then
    vim.opt.linespace = 10
    vim.g.neovide_text_contrast = 1.0
    vim.g.neovide_padding_top = 10
    vim.g.neovide_padding_bottom = 10
    vim.g.neovide_padding_left = 10
    vim.g.neovide_padding_right = 10
    vim.g.neovide_floating_shadow = true
    vim.g.neovide_position_animation_length = 0
    vim.g.neovide_scroll_animation_length = 0
    vim.g.neovide_cursor_animation_length = 0
    vim.g.neovide_cursor_short_animation_length = 0
    vim.g.neovide_cursor_trail_size = 0
end


