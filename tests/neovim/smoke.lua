-- Run with the standalone init.lua loaded, from an empty working directory:
-- nvim --headless -u /path/to/pastel/programs/neovim/init.lua \
--   -c 'luafile /path/to/tests/neovim/smoke.lua'
local ok, err = xpcall(function()
    assert(vim.v.errmsg == "", vim.v.errmsg)

    -- Exercise LuaSnip's LSP snippet expansion, not just its configuration.
    vim.api.nvim_buf_set_lines(0, 0, -1, false, { "" })
    vim.api.nvim_win_set_cursor(0, { 1, 0 })
    require("luasnip").lsp_expand("hello ${1:world}$0")
    assert(vim.api.nvim_get_current_line() == "hello world", "Snippet expansion failed")
    require("luasnip").unlink_current()
    vim.bo.modified = false

    -- Saving a real Rust file must invoke rustfmt via the save autocommand.
    local filename = vim.fn.tempname() .. ".rs"
    vim.cmd.edit(vim.fn.fnameescape(filename))
    vim.api.nvim_buf_set_lines(0, 0, -1, false, { 'fn main(){println!("hello");}' })
    vim.cmd.write()
    local formatted = table.concat(vim.fn.readfile(filename), "\n")
    assert(formatted == 'fn main() {\n    println!("hello");\n}', "Format on save failed: " .. formatted)

    -- Bufferline's commands must switch to the other listed buffer and back.
    local first = vim.api.nvim_get_current_buf()
    local second = vim.api.nvim_create_buf(true, false)
    vim.api.nvim_buf_set_name(second, "pastel-smoke-second")
    vim.api.nvim_eval_statusline(vim.o.tabline, { use_tabline = true })
    vim.cmd.BufferLineCycleNext()
    assert(vim.api.nvim_get_current_buf() == second, "Next-buffer command failed")
    vim.api.nvim_eval_statusline(vim.o.tabline, { use_tabline = true })
    vim.cmd.BufferLineCyclePrev()
    assert(vim.api.nvim_get_current_buf() == first, "Previous-buffer command failed")

    -- Open the actual picker and file tree, then inspect their active buffers.
    require("telescope.builtin").current_buffer_fuzzy_find()
    assert(vim.bo.filetype == "TelescopePrompt", "Telescope picker did not open")
    require("telescope.actions").close(vim.api.nvim_get_current_buf())
    vim.cmd("Neotree focus")
    assert(vim.bo.filetype == "neo-tree", "Neo-tree did not open")
    vim.cmd("Neotree close")

    vim.cmd.ToggleTerm()
    assert(vim.bo.buftype == "terminal", "Terminal did not open")
    assert(vim.api.nvim_win_get_height(0) == 15, "Terminal split height changed")
    vim.cmd.ToggleTerm()
    assert(vim.bo.buftype ~= "terminal", "Terminal did not close")
    vim.api.nvim_buf_delete(first, { force = true })
    vim.fn.delete(filename)

    assert(vim.v.errmsg == "", vim.v.errmsg)
    print("PASS: snippets, Rust format-on-save, buffer switching, Telescope, Neo-tree, terminal")
end, debug.traceback)
if not ok then
    vim.api.nvim_err_writeln(err)
    vim.cmd("cquit 1")
else
    vim.cmd("qa!")
end
