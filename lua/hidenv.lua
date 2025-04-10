local state = {
  bufread_id = nil,
  insertchar_id = nil,
  active = false,
  highlight = "Hidenv",
}

local M = {}

M.hide = function(hl_group)
  vim.cmd("highlight Hidenv guibg=black guifg=black")

  local id = vim.api.nvim_create_namespace("hidenv")

  local buf = vim.api.nvim_get_current_buf()

  local name = vim.api.nvim_buf_get_name(buf)

  if string.sub(name, -4) ~= ".env" then
    return
  end

  local start_line = 0
  local end_line = vim.api.nvim_buf_line_count(buf)

  for line_num = start_line, end_line - 1 do
    local map_line = vim.api.nvim_buf_get_lines(buf, line_num, line_num + 1, false)[1]

    local start_col = string.find(map_line, "[=]")

    if not start_col then
      goto continue
    end

    local end_col = string.find(map_line, "$") - 1

    vim.api.nvim_buf_set_extmark(buf, id, line_num, start_col, {
      hl_group = hl_group,
      end_col = end_col,
    })

    ::continue::
  end
end

M.start = function()
  M.stop()

  if not state.bufread_id then
    state.bufread_id = vim.api.nvim_create_autocmd("BufRead", {
      pattern = ".env",
      callback = function()
        M.hide(state.highlight)
      end,
    })
    state.insertchar_id = vim.api.nvim_create_autocmd({ "TextChangedI", "TextChanged" }, {
      pattern = ".env",
      callback = function()
        M.hide(state.highlight)
      end,
    })
  end
end

M.stop = function()
  if state.bufread_id then
    vim.cmd("highlight clear hidenv")
    vim.api.nvim_del_autocmd(state.insertchar_id)
    vim.api.nvim_del_autocmd(state.bufread_id)

    state.bufread_id = nil
    state.insertchar_id = nil
  end
end

M.setup = function(opts)
  state.active = opts.active
end

vim.api.nvim_create_autocmd("VimEnter", {
  callback = function()
    if state.active then
      M.start()
    end
  end,
})

vim.api.nvim_create_user_command("Hidenv", function()
  M.hide(state.highlight)
end, {})

vim.api.nvim_create_user_command("HidenvStart", function()
  M.hide(state.highlight)
  M.start()
end, {})

vim.api.nvim_create_user_command("HidenvStop", function()
  M.stop()
end, {})

return M
