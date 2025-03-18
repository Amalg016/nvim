function run_js(mode)
    local start_pos, end_pos

    if mode == 'v' or mode == 'V' or mode == '' then
        -- Get the visually selected lines
        start_pos = vim.fn.getpos("'<")
        end_pos = vim.fn.getpos("'>")
        local lines = vim.fn.getline(start_pos[2], end_pos[2])
        local line_count = end_pos[2] - start_pos[2] + 1

        -- Join the lines to form the command
        local cmd = table.concat(lines, '\n')

        -- Execute the command and capture the output
        output = vim.fn.systemlist('node', cmd)

        -- Append the selected lines and the output below the original lines
        -- vim.fn.append(end_pos[2], lines)
        vim.fn.append(end_pos[2], output)

        -- Move the cursor to the first newly pasted line
        vim.cmd(tostring(end_pos[2] + 1) .. 'normal! 0')
    else
        -- Get the current line
        local current_line = vim.fn.getline('.')

        -- Append the current line below
        vim.fn.append('.', current_line)

        -- Move the cursor to the newly pasted line
        vim.cmd('normal! j')

        -- Execute the pasted line with the shell command
        vim.cmd('.!node')
    end
end

function execute_js_file(js_file)
    local command = 'node ' .. js_file
    local output = vim.fn.system(command)

    -- Check if there's any output or error
    if output ~= nil and output ~= '' then
        print(output)
    else
        print('JavaScript file executed successfully.')
    end
end

function execute_current_js_file()
    -- Get the path of the current file
    local current_file = vim.fn.expand('%:p')
    execute_js_file(current_file)
end

vim.keymap.set("n", "<F9>", ':lua run_js("n")<CR>')
vim.keymap.set("v", "<F9>", ':lua run_js("v")<CR>')

vim.keymap.set("n", "<F10>", ':lua execute_current_js_file()<CR>')
