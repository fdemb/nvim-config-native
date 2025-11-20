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
vim.opt.cmdheight = 0

-- disable unneeded providers
vim.g.loaded_node_provider = 0
vim.g.loaded_python3_provider = 0
vim.g.loaded_perl_provider = 0
vim.g.loaded_ruby_provider = 0

-- Plugins
vim.pack.add({
    -- theme
    "https://github.com/catppuccin/nvim",

    -- completion
    "https://github.com/rafamadriz/friendly-snippets",
    { src = "https://github.com/saghen/blink.cmp", version = "v1.8.0" },

    -- mini
    "https://github.com/echasnovski/mini.statusline",
    "https://github.com/echasnovski/mini.pick",
    "https://github.com/echasnovski/mini.icons",
    "https://github.com/echasnovski/mini-git",

    -- file "tree"
    "https://github.com/stevearc/oil.nvim",

    -- formatting
    "https://github.com/stevearc/conform.nvim",

    -- syntax highlighting
    "https://github.com/nvim-treesitter/nvim-treesitter",

    -- lsp
    "https://github.com/neovim/nvim-lspconfig",

    -- ai completion
    "https://github.com/nvim-lua/plenary.nvim",
    "https://github.com/milanglacier/minuet-ai.nvim"
})

-- Plugin setup
require("mini.icons").setup()
require("mini.statusline").setup()
require("mini.pick").setup()
require("mini.git").setup()
require("oil").setup()

require("conform").setup({
    formatters_by_ft = {
        javascript = { "prettierd", "prettier", stop_after_first = true },
        typescript = { "prettierd", "prettier", stop_after_first = true },
        typescriptreact = { "prettierd", "prettier", stop_after_first = true },
    }
})

require("nvim-treesitter.configs").setup({
    ensure_installed = { "vue", "typescript", "javascript", "lua" },
    highlight = { enable = true },
})
vim.cmd.colorscheme("catppuccin-mocha")

require('minuet').setup({
    provider = "gemini",
})

require('blink-cmp').setup {
    keymap = {
        -- Manually invoke minuet completion.
        ['<C-a>'] = require('minuet').make_blink_map(),
    },
    sources = {
        -- Enable minuet for autocomplete
        default = { 'lsp', 'path', 'buffer', 'snippets', 'minuet' },
        providers = {
            minuet = {
                name = 'minuet',
                module = 'minuet.blink',
                async = true,
                -- Should match minuet.config.request_timeout * 1000,
                -- since minuet.config.request_timeout is in seconds
                timeout_ms = 3000,
                score_offset = 50, -- Gives minuet higher priority among suggestions
            },
        },
    },
    -- Recommended to avoid unnecessary request
    completion = { trigger = { prefetch_on_insert = false } },
}

-- Custom commands and autocmds
vim.api.nvim_create_user_command("Format", function(args)
    local range = nil
    if args.count ~= -1 then
        local end_line = vim.api.nvim_buf_get_lines(0, args.line2 - 1, args.line2, true)[1]
        range = {
            start = { args.line1, 0 },
            ["end"] = { args.line2, end_line:len() },
        }
    end
    require("conform").format({ async = true, lsp_format = "fallback", range = range })
end, { range = true })

vim.api.nvim_create_user_command('Wbd', function()
  if vim.bo.modified and vim.bo.modifiable and vim.fn.expand('%') ~= '' then
    vim.cmd('write')
  end
  vim.cmd('bdelete')
end, { desc = 'Save (if possible) and close buffer' })

-- Keybindings
vim.keymap.set("n", "<Leader>q", ":Wbd<CR>")
vim.keymap.set("n", "<Leader>h", MiniPick.builtin.help)
vim.keymap.set("n", "<Leader><Leader>", MiniPick.builtin.buffers)
vim.keymap.set("n", "<Leader>p", MiniPick.builtin.files)
vim.keymap.set("n", "<Leader>g", MiniPick.builtin.grep_live)
vim.keymap.set("n", "<Leader>ec", ":e ~/.config/nvim/init.lua<CR>")
vim.keymap.set("n", "<Leader>w", ":w<CR>")
vim.keymap.set("n", "-", ":Oil<CR>")
vim.keymap.set("n", "<Leader>fm", ":Format<CR>")
vim.keymap.set({ "n", "i" }, "gd", vim.lsp.buf.definition)

-- LSP
vim.lsp.enable("lua_ls")
vim.lsp.enable("intelephense")
vim.lsp.enable('vue_ls')
vim.lsp.enable('vtsls')
vim.lsp.enable('ts_ls')
vim.lsp.enable('astro')
vim.lsp.enable('tailwindcss')

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
