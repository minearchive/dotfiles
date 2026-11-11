-- Standalone equivalent of ../neovim.nix. Requires Neovim >= 0.12 and Git.
assert(vim.fn.has("nvim-0.12") == 1, "This configuration requires Neovim >= 0.12")

vim.g.mapleader = " "
vim.g.maplocalleader = " "

for name, value in pairs({
    tabstop = 4,
    shiftwidth = 4,
    expandtab = true,
    number = true,
    signcolumn = "yes",
    termguicolors = true,
    splitbelow = true,
    splitright = true,
}) do
    vim.opt[name] = value
end

vim.g.rustaceanvim = {
    server = {
        cmd = { "rust-analyzer" },
        default_settings = {
            ["rust-analyzer"] = {
                cargo = { allFeatures = true, buildScripts = { enable = true } },
                procMacro = { enable = true },
                checkOnSave = true,
                lens = { enable = true },
                inlayHints = {
                    bindingModeHints = { enable = true },
                    closureReturnTypeHints = { enable = "always" },
                    lifetimeElisionHints = { enable = "always", useParameterNames = true },
                    parameterHints = { enable = true },
                    typeHints = { enable = true },
                },
            },
        },
    },
}

-- Native package management; no Nix store paths or separate plugin manager.
vim.pack.add({
    "https://github.com/nvim-lua/plenary.nvim",
    "https://github.com/MunifTanjim/nui.nvim",
    "https://github.com/nvim-tree/nvim-web-devicons",
    "https://github.com/tpope/vim-repeat",
    "https://github.com/mfussenegger/nvim-dap",
    "https://github.com/catppuccin/nvim",
    "https://github.com/nvim-lualine/lualine.nvim",
    { src = "https://github.com/nvim-neo-tree/neo-tree.nvim", version = "v3.x" },
    "https://github.com/nvim-mini/mini.nvim",
    "https://github.com/sphamba/smear-cursor.nvim",
    "https://github.com/andweeb/presence.nvim",
    "https://github.com/nvim-java/nvim-java",
    "https://github.com/neovim/nvim-lspconfig",
    "https://github.com/nvim-flutter/flutter-tools.nvim",
    { src = "https://github.com/mrcjkb/rustaceanvim", version = vim.version.range("^9") },
    "https://github.com/saecki/crates.nvim",
    "https://github.com/akinsho/toggleterm.nvim",
    "https://github.com/nvim-telescope/telescope.nvim",
    "https://github.com/akinsho/bufferline.nvim",
    "https://github.com/hrsh7th/nvim-cmp",
    "https://github.com/hrsh7th/cmp-nvim-lsp",
    "https://github.com/hrsh7th/cmp-buffer",
    "https://github.com/hrsh7th/cmp-path",
    "https://github.com/L3MON4D3/LuaSnip",
    "https://github.com/saadparwaiz1/cmp_luasnip",
    "https://github.com/stevearc/conform.nvim",
}, { confirm = false })

require("catppuccin").setup({})
vim.env.BAT_THEME = "catppuccin"
vim.cmd.colorscheme("catppuccin")
require("nvim-web-devicons").setup({})
require("lualine").setup({})
require("neo-tree").setup({})
-- Nixvim enables mini.nvim without configuring any individual modules.
require("smear_cursor").setup({})
require("presence").setup({})
require("luasnip").config.setup({})
require("crates").setup({})

local cmp = require("cmp")
cmp.setup({
    sources = {
        { name = "nvim_lsp" },
        { name = "luasnip" },
        { name = "buffer" },
        { name = "path" },
    },
    snippet = {
        expand = function(args)
            require("luasnip").lsp_expand(args.body)
        end,
    },
    mapping = {
        ["<C-Space>"] = cmp.mapping.complete(),
        ["<C-e>"] = cmp.mapping.abort(),
        ["<C-d>"] = cmp.mapping.scroll_docs(-4),
        ["<C-u>"] = cmp.mapping.scroll_docs(4),
        ["<CR>"] = cmp.mapping.confirm({ select = true }),
        ["<Tab>"] = cmp.mapping(cmp.mapping.select_next_item(), { "i", "s" }),
        ["<S-Tab>"] = cmp.mapping(cmp.mapping.select_prev_item(), { "i", "s" }),
    },
})

local capabilities = require("cmp_nvim_lsp").default_capabilities()
vim.lsp.config("asm_lsp", { filetypes = { "asm", "nasm", "vmasm" } })
-- Java must be configured before enabling jdtls.
require("java").setup({ spring_boot_tools = { enable = false } })
vim.lsp.config("jdtls", {
    root_markers = {
        "settings.gradle",
        "settings.gradle.kts",
        "pom.xml",
        "build.gradle",
        "mvnw",
        "gradlew",
        "build.gradle.kts",
        ".git",
    },
})
for _, server in ipairs({ "asm_lsp", "clangd", "jdtls", "tinymist" }) do
    vim.lsp.config(server, { capabilities = capabilities })
    vim.lsp.enable(server)
end

-- These plugins own dartls and rust-analyzer; do not enable duplicate clients.
require("flutter-tools").setup({
    lsp = { capabilities = capabilities },
})

require("toggleterm").setup({
    direction = "horizontal",
    size = 15,
    shade_terminals = true,
    start_in_insert = true,
    persist_size = true,
    close_on_exit = true,
})
require("telescope").setup({})
require("bufferline").setup({
    options = {
        diagnostics = "nvim_lsp",
        separator_style = "slant",
        show_buffer_close_icons = true,
        show_close_icon = false,
        offsets = {
            {
                filetype = "neo-tree",
                text = "File Explorer",
                highlight = "Directory",
                separator = true,
            },
        },
    },
})
require("conform").setup({
    formatters_by_ft = { rust = { "rustfmt" }, dart = { "dart_format" } },
    formatters = { dart_format = { command = "dart" } },
    format_on_save = { timeout_ms = 500, lsp_format = "fallback" },
})

vim.api.nvim_create_autocmd("LspAttach", {
    group = vim.api.nvim_create_augroup("pastel_lsp", { clear = true }),
    desc = "Enable inlay hints + code lenses when an LSP attaches",
    callback = function(args)
        local client = vim.lsp.get_client_by_id(args.data.client_id)
        if client and client.server_capabilities.inlayHintProvider then
            vim.lsp.inlay_hint.enable(true, { bufnr = args.buf })
        end
        if client and client.server_capabilities.codeLensProvider then
            vim.lsp.codelens.enable(true, { bufnr = args.buf })
        end
    end,
})

vim.keymap.set({ "n", "v" }, "<A-CR>", vim.lsp.buf.code_action, { desc = "Code actions" })
vim.keymap.set({ "n", "t" }, "<C-\\>", "<cmd>ToggleTerm<CR>", { desc = "Toggle terminal" })
vim.keymap.set("t", "<Esc>", "<C-\\><C-n>", { desc = "Terminal: leave insert mode" })
vim.keymap.set("n", "<C-Tab>", "<cmd>BufferLineCycleNext<CR>", { desc = "Next buffer" })
vim.keymap.set("n", "<C-S-Tab>", "<cmd>BufferLineCyclePrev<CR>", { desc = "Previous buffer" })
vim.keymap.set("n", "<S-l>", "<cmd>BufferLineCycleNext<CR>", { desc = "Next buffer" })
vim.keymap.set("n", "<S-h>", "<cmd>BufferLineCyclePrev<CR>", { desc = "Previous buffer" })
vim.keymap.set("n", "<leader>c", "<cmd>bdelete<CR>", { desc = "Close buffer" })
vim.keymap.set("n", "<C-f>", "<cmd>Telescope current_buffer_fuzzy_find<CR>", { desc = "Find in current buffer" })
vim.keymap.set("n", "<C-S-f>", "<cmd>Telescope live_grep<CR>", { desc = "Grep across all files" })
vim.keymap.set("n", "<leader>ff", "<cmd>Telescope find_files<CR>", { desc = "Find files" })
vim.keymap.set("n", "<leader>fb", "<cmd>Telescope buffers<CR>", { desc = "List buffers" })
