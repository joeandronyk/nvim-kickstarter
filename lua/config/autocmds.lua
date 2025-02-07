-- Automatically close the terminal window when the process exits sucessfully
vim.api.nvim_create_autocmd('TermClose', {
  callback = function()
    if vim.v.event.status == 0 then
      vim.cmd 'close'
    end
  end,
})

vim.api.nvim_create_user_command('RuffCheck', function()
  -- Run Ruff and capture the output
  local output = vim.fn.systemlist 'ruff check .'

  -- Clear the quickfix list
  vim.fn.setqflist({}, 'r')

  -- Parse the output and add it to the quickfix list
  for _, line in ipairs(output) do
    local filename, lnum, col, text = string.match(line, '([^:]+):(%d+):(%d+): (.+)')
    if filename and lnum and col and text then
      vim.fn.setqflist({
        {
          filename = filename,
          lnum = tonumber(lnum),
          col = tonumber(col),
          text = text,
        },
      }, 'a')
    end
  end

  -- Open the quickfix list
  vim.cmd 'copen'
end, {})

vim.api.nvim_set_keymap('n', '<leader>rc', ':RuffCheck<CR>', { noremap = true, silent = true })
