```ascii
██████╗ ██╗   ██╗██████╗ ███████╗██╗   ██╗██╗███╗   ███╗
██╔══██╗██║   ██║██╔══██╗██╔════╝██║   ██║██║████╗ ████║
██████╔╝██║   ██║██████╔╝█████╗  ██║   ██║██║██╔████╔██║
██╔═══╝ ██║   ██║██╔══██╗██╔══╝  ╚██╗ ██╔╝██║██║╚██╔╝██║
██║     ╚██████╔╝██║  ██║███████╗ ╚████╔╝ ██║██║ ╚═╝ ██║
╚═╝      ╚═════╝ ╚═╝  ╚═╝╚══════╝  ╚═══╝  ╚═╝╚═╝     ╚═╝
```

# PureVim - A Plugin-free Neovim Configuration

A clean, efficient Neovim configuration that leverages built-in features and powerful external tools for a great editing experience.

<div style="display: flex; justify-content: space-between;">
  <img src="https://github.com/user-attachments/assets/754119f0-42fa-4dcc-ade0-45e5eb4ac7ca" style="width: 48%;"/>
  <img src="https://github.com/user-attachments/assets/838a282a-6df9-4f10-b998-58c80ab433b3" style="width: 48%;"/>
</div>

> [!WARNING]  
> **Incomplete Setup**  
> This configuration is not yet production-ready.  
> • Pending LSP adjustments  
> • Runtime path errors detected

## Performance

This configuration is designed to be lightweight and fast:

- No external plugins
- Lazy redraw enabled
- Optimized updatetime
- Efficient autocommands

## Features

- [x] Intuitive keymaps
- [x] Native LSP support
  - [x] Go to definition: `gd`
  - [x] Show documentation: `K`
  - [x] Rename symbol: `<leader>rn`
  - [x] Code actions: `<leader>ca`
  - [x] Autocomplete
- [x] Useful autocommands
  - [x] Diagnostics float mouse hover
  - [ ] autoformat
- [x] File finder
- [x] Text search
- [x] Fuzzy Finding Files with preview on Project
- [x] Greeping with preview on Project

## TODOs

- [ ] Look for TODOs in the code
- [ ] Document how to install tree-sitter libraries
- [ ] Document how to install supported LSP servers
- [ ] Document how to add new LSP servers
- [ ] Document how to "auto complete"
- [ ] Document default bindings
- [ ] Customize auto-format functions
- [ ] Generalize symbols for errors, warnings, info to be global

## Requirements

- Neovim >= 0.10.0
- A terminal with true color support
- LSP servers for your languages
- [Lazygit (Install)](https://github.com/jesseduffield/lazygit)
- ripgrep
- fzf

## Installation

1. Backup your existing Neovim configuration:

```bash
mv ~/.config/nvim ~/.config/nvim.backup
```

3. Clone this repository:

```bash
git clone https://github.com/yourusername/purevim.git ~/.config/nvim
```

## Configuration - Optional User Files

This Neovim configuration supports **user-specific optional files** to
customize behavior without modifying the main config. All these files are
**git-ignored** by default.

If you'd like to customize **PureVim**, simply create these files in the same
folder as this config `init.lua`.

1. **`early_init.lua`** → runs first, can set globals or feature toggles.

2. **Core config + optional `private.lua`** → loads modules conditionally based
   on feature toggles.

3. **`post_init.lua`** → runs last, for final tweaks and personal customization.

> ⚡ If a file does not exist, it is simply skipped, and the config runs
> normally.

### 1. `early_init.lua`

- **Purpose:** Runs **before the main config**.

- **Use it for:** Setting global options, overriding defaults, changing leader
  keys, or defining feature toggles.

- **Example:**

```lua
-- ~/.config/nvim/early_init.lua

-- Set your own colorscheme option
vim.g.colorscheme = "retrobox"

```

### 2. `private.lua`

- **Purpose:** Optional feature toggle file, loaded by the main config.
- **Use it for:** Turning specific features ON or OFF.
- **Default behavior:** All features run if this file does not exist.
- **Example:**

```lua
-- ~/.config/nvim/private.lua

return {
  lsp = false,         -- disable LSP
  treesitter = true,   -- enable treesitter
  colorscheme = false, -- disable custom pure vim colorscheme
}
```

### 3. `post_init.lua`

- **Purpose:** Runs **after all core modules** have loaded.
- **Use it for:** Adding personal keymaps, tweaks, custom autocommands, or modifying highlights after the colorscheme.
- **Example:**

```lua
-- ~/.config/nvim/post_init.lua

-- Custom keymap
vim.keymap.set("n", "<leader>tt", ":split | terminal<CR>", { desc = "Open terminal" })

-- Tweak statusline colors after colorscheme
vim.api.nvim_set_hl(0, "StatusLine", { fg = "#cdd6f4", bg = "#11111b" })
vim.api.nvim_set_hl(0, "StatusLineNC", { fg = "#a6adc8", bg = "#292c3c" })
```

## Contributing

Feel free to fork this repository and customize it to your needs. Pull requests for improvements are welcome!

## FAQ

### Do folds work with tree-sitter?

Yes!

Here are some folding key hints:

- zc (fold)
- zo (unfold)
- zM (fold all)
- zR (unfold all)
- za (toggle current fold)

### How do I check if treesitter is turned on on my current buffer?

Focus the buffer you'd like more info to and run the command:

```
:PureCheckTreesitter
```

## License

MIT License - feel free to use and modify as you like.

---

Made with love by a Neovim enthusiast
