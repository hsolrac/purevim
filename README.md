# PureVim - A Plugin-free Neovim Configuration

A clean, efficient Neovim configuration that leverages built-in features and
powerful external tools for a great editing experience.

<img width="1912" height="1017" alt="image" src="https://github.com/user-attachments/assets/dc70f57b-cd79-42ae-87ef-21a07ca8c118" />


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

You can install PureVim in three different ways, depending on how much control
or automation you prefer:

1 - With Nix — for a fully reproducible environment. 2 - With a helper script —
for quick setup and dependency checking. 3 - Manually (Purist way) — for full
control, no scripts or Nix.

### 1. Installation with Nix

This configuration uses [Nix](https://nixos.org/) with
[Flakes](https://nixos.wiki/wiki/Flakes) to provide a reproducible environment
with all necessary dependencies.

**Step 1. Install Nix**

First, [install Nix](https://nixos.org/download.html) on your system and
[enable Flakes](https://nixos.wiki/wiki/Flakes#Enable_flakes).

**Step 2. Clone the Repository**

Clone this repository to your Neovim configuration directory:

```bash
# Backup your existing config first if you have one
# mv ~/.config/nvim ~/.config/nvim.backup

git clone https://github.com/hsolrac/purevim.git ~/.config/nvim
```

**Step 3. Launch the Environment**

Navigate to the configuration directory and run `nix develop`. This will launch
a shell with Neovim and all the pre-configured language servers
(`rust-analyzer`, `lua-language-server`, `typescript-language-server`)
available in your `PATH`.

```bash cd ~/.config/nvim nix develop ```

Now, you can run `nvim` from within this shell, and everything will work out of
the box.

### 2. Installation with Helper Script

If you don’t want to use Nix, a convenience script is provided to handle the
setup and dependency checks for you.

Run the installer:

```bash bash <(curl -s
https://raw.githubusercontent.com/hsolrac/purevim/main/bin/purevim)
```
The script will:

- Back up your existing Neovim configuration (if any) to ~/.config/nvim.backup
- Clone this repository to ~/.config/nvim
- Check for the required dependencies and alert you if something is missing
- Dependencies checked by the script:
   - nvim
   - lazygit
   - rg (ripgrep)
   - fzf
   - lua-language-server
   - rust-analyzer
   - typescript-language-server
   - bat

### 3. Manual Installation

If you prefer a completely transparent setup — no scripts, no abstractions —
install manually:

```bash
git clone https://github.com/hsolrac/purevim.git ~/.config/nvim
```

Then manually ensure all dependencies are installed on your system:

- nvim (≥ 0.10.0)
- lazygit
- rg (ripgrep)
- fzf
- lua-language-server
- rust-analyzer
- typescript-language-server
- bat

Once everything is ready, just launch Neovim:

```bash 
nvim
```

And you’re good to go.

## Configuration - Optional User Files

This Neovim configuration supports **user-specific optional files** to
customize behavior without modifying the main config. All these files are
**git-ignored** by default.

If you'd like to customize **PureVim**, simply create these files in the same
folder as this config `init.lua`.

1. **`early_init.lua`** → runs first, can set globals or feature toggles.

2. **Core config + optional `private.lua`** → loads modules conditionally based
on feature toggles.

3. **`post_init.lua`** → runs last, for final tweaks and personal
customization.

> ⚡ If a file does not exist, it is simply skipped, and the config runs
> normally.

### 1. `early_init.lua`

- **Purpose:** Runs **before the main config**.

- **Use it for:** Setting global options, overriding defaults, changing leader
keys, or defining feature toggles.

- **Example:**

```lua -- ~/.config/nvim/early_init.lua

-- Set your own colorscheme option vim.cmd.colorscheme("retrobox")
```

### 2. `private.lua`

- **Purpose:** Optional feature toggle file, loaded by the main config.
- **Use it for:** Turning specific features ON or OFF.
- **Default behavior:** All features run if this file does not exist.
- **Example:**

```lua -- ~/.config/nvim/private.lua

return { lsp = false,         -- disable LSP treesitter = true,   -- enable
    treesitter colorscheme = false, -- disable custom pure vim colorscheme }
```

### 3. `post_init.lua`

- **Purpose:** Runs **after all core modules** have loaded.
- **Use it for:** Adding personal keymaps, tweaks, custom autocommands, or
modifying highlights after the colorscheme.
- **Example:**

```lua -- ~/.config/nvim/post_init.lua

-- Custom keymap vim.keymap.set("n", "<leader>tt", ":split | terminal<CR>", {
desc = "Open terminal" })

-- Tweak statusline colors after colorscheme vim.api.nvim_set_hl(0,
"StatusLine", { fg = "#cdd6f4", bg = "#11111b" }) vim.api.nvim_set_hl(0,
    "StatusLineNC", { fg = "#a6adc8", bg = "#292c3c" })
```

## Contributing

Feel free to fork this repository and customize it to your needs. Pull requests
for improvements are welcome!

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
