local M = {}

M.connections_file = vim.fn.stdpath("data") .. "/usql_connections.json"
M.connections = {}
M.last_connection = nil

M.load_connections = function()
  local file = io.open(M.connections_file, "r")
  if file then
    local content = file:read("*a")
    file:close()
    if content ~= "" then
      local success, data = pcall(vim.fn.json_decode, content)
      if success and data then
        M.connections = data.connections or {}
        M.last_connection = data.last_connection
      end
    end
  end
end

M.save_connections = function()
  local data = {
    connections = M.connections,
    last_connection = M.last_connection
  }
  local file = io.open(M.connections_file, "w")
  if file then
    file:write(vim.fn.json_encode(data))
    file:close()
  end
end

M.config = function()
  local connection_names = vim.tbl_keys(M.connections)
  table.sort(connection_names)

  vim.ui.select(connection_names, {
    prompt = "Select connection to edit (or press Enter to create new):",
    format_item = function(name)
      return name .. " (" .. string.sub(M.connections[name], 1, 30) .. "...)"
    end,
  }, function(selected)
    if selected then
      M.edit_connection(selected)
    else
      M.create_connection()
    end
  end)
end

M.create_connection = function()
  vim.ui.input({
    prompt = "Connection name: ",
  }, function(name)
    if not name or name == "" then return end
    vim.ui.input({
      prompt = "Connection string: ",
      default = M.connections[name] or "",
    }, function(conn_string)
      if conn_string and conn_string ~= "" then
        M.connections[name] = conn_string
        M.save_connections()
        print("✓ USQL: Connection '" .. name .. "' saved")
      end
    end)
  end)
end

M.edit_connection = function(name)
  vim.ui.input({
    prompt = "Edit connection string for '" .. name .. "': ",
    default = M.connections[name],
  }, function(new_conn_string)
    if new_conn_string and new_conn_string ~= "" then
      M.connections[name] = new_conn_string
      M.save_connections()
      print("✓ USQL: Connection '" .. name .. "' updated")
    elseif new_conn_string == "" then
      -- Remover conexão se string vazia
      M.connections[name] = nil
      M.save_connections()
      print("✓ USQL: Connection '" .. name .. "' removed")
    end
  end)
end

M.connect = function()
  local connection_names = vim.tbl_keys(M.connections)

  if #connection_names == 0 then
    print("✗ USQL: No connections saved. Use :PureSqlConfig first")
    return
  end

  table.sort(connection_names)

  vim.ui.select(connection_names, {
    prompt = "Select connection:",
    format_item = function(name)
      return name .. " (" .. string.sub(M.connections[name], 1, 30) .. "...)"
    end,
  }, function(selected)
    if selected then
      M.open_connection(selected, M.connections[selected])
    end
  end)
end

M.quick_connect = function()
  if M.last_connection and M.connections[M.last_connection] then
    M.open_connection(M.last_connection, M.connections[M.last_connection])
  else
    print("✗ USQL: No recent connection found")
    M.connect()
  end
end

M.open_connection = function(name, connection_string)
  local open_usql_term = function()
    local buf = vim.api.nvim_create_buf(false, true)
    vim.cmd("belowright 15split")
    local win = vim.api.nvim_get_current_win()
    vim.api.nvim_win_set_buf(win, buf)

    vim.api.nvim_buf_set_name(buf, "usql:" .. name)
    vim.api.nvim_win_set_option(win, "winbar", "USQL: " .. name)
    local cmd = "usql " .. vim.fn.shellescape(connection_string)
    vim.fn.termopen(cmd, {
      on_exit = function(_, code)
        if code ~= 0 then
          print("✗ USQL: Connection to '" .. name .. "' failed")
        end
      end
    })

    vim.defer_fn(function()
      if vim.b.terminal_job_id then
        vim.api.nvim_chan_send(vim.b.terminal_job_id, "\\pset null '(null)'\n")
        vim.api.nvim_chan_send(vim.b.terminal_job_id, "\\x auto\n")
				vim.api.nvim_chan_send(vim.b.terminal_job_id, "\x0c")
      end
    end, 200)

    vim.cmd("startinsert")
    M.last_connection = name
    M.save_connections()
    print("✓ USQL: Connected to '" .. name .. "'")
  end

  open_usql_term()
end

M.list = function()
  local connection_names = vim.tbl_keys(M.connections)
  if #connection_names == 0 then
    print("✗ USQL: No connections saved")
    return
  end

  table.sort(connection_names)

  print("USQL Saved Connections:")
  for _, name in ipairs(connection_names) do
    local marker = M.last_connection == name and " ← last used" or ""
    print("  • " .. name .. " - " .. M.connections[name] .. marker)
  end
end

M.remove = function()
  local connection_names = vim.tbl_keys(M.connections)

  if #connection_names == 0 then
    print("✗ USQL: No connections to remove")
    return
  end

  table.sort(connection_names)

  vim.ui.select(connection_names, {
    prompt = "Select connection to remove:",
    format_item = function(name)
      return name .. " (" .. M.connections[name] .. ")"
    end,
  }, function(selected)
    if selected then
      M.connections[selected] = nil
      if M.last_connection == selected then
        M.last_connection = nil
      end
      M.save_connections()
      print("✓ USQL: Connection '" .. selected .. "' removed")
    end
  end)
end

vim.api.nvim_create_user_command("PureSqlConnect", M.connect, {})
vim.api.nvim_create_user_command("PureSqlQuickConnect", M.quick_connect, {})
vim.api.nvim_create_user_command("PureSqlConfig", M.config, {})
vim.api.nvim_create_user_command("PureSqlList", M.list, {})
vim.api.nvim_create_user_command("PureSqlRemove", M.remove, {})

M.load_connections()

return M
