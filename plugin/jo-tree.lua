-- Check if the global variable 'g:loaded_jo_tree' exists and finish if it does.
if vim.g.loaded_jo_tree then
    return
end

-- Define a command called 'Jotree' with custom completion.
vim.cmd[[
    command! -nargs=* -complete=custom,v:lua.require'jo-tree.command'.complete_args Jotree lua require("jo-tree.command")._command(<f-args>)
]]

-- Set the global variable 'g:loaded_jo_tree' to 1.
vim.g.loaded_jo_tree = 1