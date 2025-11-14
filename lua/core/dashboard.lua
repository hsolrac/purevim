local M = {}
local api = vim.api
local fn = vim.fn

local elapsed = (vim.loop.hrtime() - (_G.start_time or vim.loop.hrtime())) / 1e6 -- convert nanoseconds to milliseconds

local config = {
  disable = false,
  hide_title = false,
  hide_buttons = false,
  hide_footer = false,
  hide_footer_info = false,
  title = nil,

  buttons = {
    { key = 'e', label = ' New file ',   action = ':enew<CR>' },
    { key = 'f', label = ' Find file',   action = ':PureFzfProject<CR>' },
    { key = 's', label = ' Settings ',    action = ':e $MYVIMRC<CR>' },
    { key = 'q', label = ' Quit     ',    action = ':qa!<CR>' },
  },

  footer = string.format("[PureVim] loaded in %.2f ms", elapsed),
}

function generate_header_title(title)
  local header_title = title or config.title or "Purevim"

  local ok, handle = pcall(io.popen, "figlet -f dos-rebel '%s'", header_title)

  if ok and handle then
    local result = handle:read("*a")
    handle:close()
    if result and #result > 0 then
      local lines = {}
      for line in result:gmatch("[^\n]+") do
        table.insert(lines, line)
      end
      return lines
    end
  end

  if header_title == "Purevim" then
    return {
      "     ███████████  █████  █████ ███████████   ██████████ █████   █████ █████ ██████   ██████",
      "    ░░███░░░░░███░░███  ░░███ ░░███░░░░░███ ░░███░░░░░█░░███   ░░███ ░░███ ░░██████ ██████ ",
      "     ░███    ░███ ░███   ░███  ░███    ░███  ░███  █ ░  ░███    ░███  ░███  ░███░█████░███ ",
      "     ░██████████  ░███   ░███  ░██████████   ░██████    ░███    ░███  ░███  ░███░░███ ░███ ",
      "     ░███░░░░░░   ░███   ░███  ░███░░░░░███  ░███░░█    ░░███   ███   ░███  ░███ ░░░  ░███ ",
      "     ░███         ░███   ░███  ░███    ░███  ░███ ░   █  ░░░█████░    ░███  ░███      ░███ ",
      "     █████        ░░████████   █████   █████ ██████████    ░░███      █████ █████     █████",
      "    ░░░░░          ░░░░░░░░   ░░░░░   ░░░░░ ░░░░░░░░░░      ░░░      ░░░░░ ░░░░░     ░░░░░ ",
    }
  else
    return { "", header_title, "" }
  end
end

config.header = { title = generate_header_title() }

-- UTIL
local function buf_set_opts(buf)
  api.nvim_buf_set_option(buf, 'buftype', 'nofile')
  api.nvim_buf_set_option(buf, 'bufhidden', 'wipe')
  api.nvim_buf_set_option(buf, 'modifiable', false)
  api.nvim_buf_set_option(buf, 'swapfile', false)
  api.nvim_buf_set_option(buf, 'filetype', 'dashboard')
end

local function center_text(win_w, line)
  local len = vim.fn.strdisplaywidth(line)
  local pad = math.floor((win_w - len) / 2)

  if pad < 0 then pad = 0 end
  return string.rep(' ', pad) .. line
end

local function sanitize_string(str)
  if not str then return '' end
  return str:gsub('[\n\r\t]', ' '):gsub('%s+', ' ')
end

local function make_lines(win_w)
  local lines = {}

  if not config.hide_title then
    local header = config.header.title

    for _, l in ipairs(header) do
      table.insert(lines, center_text(win_w, l))
    end
    table.insert(lines, "")
  end

  if not config.hide_buttons then
    for _, b in ipairs(config.buttons) do
      table.insert(lines, "")
      table.insert(lines, center_text(win_w, string.format('%s%s[%s]', b.label, string.rep(' ', 16 - vim.fn.strdisplaywidth(b.label)), b.key)))
    end
    table.insert(lines, "")
  end

  if not config.hide_footer then
    table.insert(lines, center_text(win_w, config.footer))
    table.insert(lines, "")
  end

  if not config.hide_footer_info then
    local datetime = os.date('%a %d %b %Y  %H:%M')
    local nvimv = 'Neovim ' .. vim.version().major .. '.' .. vim.version().minor .. '.' .. vim.version().patch
    local cwd = sanitize_string(vim.fn.fnamemodify(vim.fn.getcwd(), ':~'))
    local info = string.format('%s  •  %s  •  %s', datetime, nvimv, cwd)
    table.insert(lines, center_text(win_w, info))
  end

  return lines
end

local function draw_dashboard(buf, win)
  local api = vim.api
  if not api.nvim_win_is_valid(win) or not api.nvim_buf_is_valid(buf) then return end

  local win_w = api.nvim_win_get_width(win)
  local win_h = api.nvim_win_get_height(win)

  local lines = make_lines(win_w)

  local pad_top = math.floor((win_h - #lines) / 2)
  if pad_top < 0 then pad_top = 0 end

  local padding = {}
  for _ = 1, pad_top do
    table.insert(padding, "")
  end
  local centered_lines = vim.list_extend(padding, lines)

  buf_set_opts(buf)

  api.nvim_buf_set_option(buf, "modifiable", true)

  api.nvim_buf_set_lines(buf, 0, -1, false, centered_lines)

  api.nvim_buf_set_option(buf, "modifiable", false)
  api.nvim_buf_set_option(buf, "readonly", true)
end


local function create_dashboard()
  local buf = api.nvim_create_buf(false, true)

  local win = api.nvim_get_current_win()

  api.nvim_win_set_option(win, 'number', false)
  api.nvim_win_set_option(win, 'relativenumber', false)

  M._buf = buf
  M._win = win

  draw_dashboard(buf, win)

  api.nvim_win_set_buf(win, buf)

  -- keymaps local to buffer
  for _, b in ipairs(config.buttons) do
    api.nvim_buf_set_keymap(buf, 'n', b.key, b.action, { nowait = true, noremap = true, silent = true })
  end

  api.nvim_buf_set_keymap(buf, 'n', '<CR>', [[<Cmd>lua require('core.dashboard').on_enter()<CR>]], { noremap = true, silent = true })

  return buf, win
end

function M.on_enter()
  local buf = M._buf
  if not buf or not api.nvim_buf_is_valid(buf) then return end
  local row = api.nvim_win_get_cursor(0)[1]
  local line = api.nvim_buf_get_lines(buf, row - 1, row, false)[1] or ''
  for _, b in ipairs(config.buttons) do
    if line:find(' %[' .. b.key .. '%]') then
      vim.cmd(b.action)
      return
    end
  end
end

local function setup_autocmds()
  if M._au then return end
  M._au = true

  api.nvim_create_autocmd({'VimResized'}, {
    pattern = '*',
    callback = function()
      if M._buf and api.nvim_buf_is_valid(M._buf) and api.nvim_win_is_valid(M._win) then
        if api.nvim_get_current_buf() == M._buf then
          draw_dashboard(M._buf, M._win)
        end
      end
    end
  })

  api.nvim_create_autocmd({'BufEnter'}, {
    pattern = '*',
    callback = function(args)
      if args.buf == M._buf and M._win and api.nvim_win_is_valid(M._win) then
        draw_dashboard(M._buf, M._win)
      end
    end
  })
end

function M.setup(opts)
  opts = opts or {}
  local redraw_needed = false

  for k, v in pairs(opts) do
    if config[k] ~= v then
      config[k] = v
      if k == 'title' or k:find('hide') then
        redraw_needed = true
      end
    end
  end

  config.header.title = generate_header_title(config.title)

  if config.disable then
    return
  end

  setup_autocmds()

  if redraw_needed and M._buf and api.nvim_buf_is_valid(M._buf) and api.nvim_win_is_valid(M._win) then
    draw_dashboard(M._buf, M._win)
  end

  api.nvim_create_autocmd('VimEnter', {
    callback = function()
      local no_args = (#vim.fn.argv() == 0)
      if not no_args then return end
      if vim.fn.exists('g:loaded_dashboard_from_plugin') == 1 then return end
      create_dashboard()
    end
  })
end


function M.open_oldfile(idx)
  local f = vim.v.oldfiles[idx]
  if f and #f > 0 then
    vim.cmd('edit ' .. fn.fnameescape(f))
  end
end

return M
