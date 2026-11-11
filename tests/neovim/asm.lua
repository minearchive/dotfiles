-- Requires asm-lsp, gcc and nasm on PATH. Run with either Neovim config loaded:
-- nvim --headless -u /path/to/init.lua -c 'luafile /path/to/tests/neovim/asm.lua'
local root = vim.fn.tempname()
local ok, err = xpcall(function()
    for _, dialect in ipairs({ "gas", "nasm" }) do
        local dir = root .. "/" .. dialect
        vim.fn.mkdir(dir, "p")
        vim.fn.writefile({
            "[default_config]",
            'assembler = "' .. dialect .. '"',
            'instruction_set = "x86-64"',
            "[default_config.opts]",
            'compiler = "' .. (dialect == "gas" and "gcc" or "nasm") .. '"',
            "diagnostics = true",
            "default_diagnostics = true",
        }, dir .. "/.asm-lsp.toml")
        local filename = dir .. (dialect == "gas" and "/main.s" or "/main.nasm")
        local source = dialect == "gas" and { ".text", "    mov %rax, %rbx", "    ret" }
            or { "bits 64", "    mov rax, rbx", "    ret" }
        vim.fn.writefile(source, filename)
        vim.cmd.edit(vim.fn.fnameescape(filename))
        local bufnr = vim.api.nvim_get_current_buf()
        local client
        assert(vim.wait(15000, function()
            client = vim.lsp.get_clients({ bufnr = bufnr, name = "asm_lsp" })[1]
            return client and client.initialized
        end, 50), "asm-lsp did not attach to " .. filename)

        local params = {
            textDocument = { uri = vim.uri_from_bufnr(bufnr) },
            position = { line = 1, character = 5 },
        }
        local hover = client:request_sync("textDocument/hover", params, 10000, bufnr)
        assert(hover and not hover.err and hover.result, "No instruction hover for " .. dialect)
        local text = table.concat(vim.lsp.util.convert_input_to_markdown_lines(hover.result.contents), "\n")
        assert(text:lower():find("mov", 1, true), "Hover did not describe MOV: " .. text)

        params.position.character = 6
        local completion = client:request_sync("textDocument/completion", params, 10000, bufnr)
        assert(completion and not completion.err and completion.result, "No completions for " .. dialect)
        local items = completion.result.items or completion.result
        local has_mov = false
        for _, item in ipairs(items) do
            if item.label:lower():match("^mov") then
                has_mov = true
                break
            end
        end
        assert(has_mov, "MOV instruction completion missing for " .. dialect)

        -- A real compiler error must reach Neovim, then clear after fixing it.
        vim.api.nvim_buf_set_lines(bufnr, 1, 2, false, { "    pastel_invalid_opcode" })
        vim.cmd.write()
        assert(vim.wait(15000, function()
            for _, diagnostic in ipairs(vim.diagnostic.get(bufnr)) do
                if diagnostic.lnum == 1 and diagnostic.severity == vim.diagnostic.severity.ERROR then
                    return true
                end
            end
            return false
        end, 50), "Compiler diagnostic missing for " .. dialect .. ": " .. vim.inspect(vim.diagnostic.get(bufnr)))
        vim.api.nvim_buf_set_lines(bufnr, 0, -1, false, source)
        vim.cmd.write()
        assert(vim.wait(15000, function()
            return #vim.diagnostic.get(bufnr) == 0
        end, 50), "Diagnostics did not clear after fixing " .. dialect)
        print("PASS: " .. dialect .. " attachment, MOV hover/completion, diagnostics and recovery")
        client:stop(true)
        vim.api.nvim_buf_delete(bufnr, { force = true })
    end
end, debug.traceback)
vim.fn.delete(root, "rf")
if not ok then
    vim.api.nvim_err_writeln(err)
    vim.cmd("cquit 1")
else
    vim.cmd("qa!")
end
