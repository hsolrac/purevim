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

## Features

- [x] Intuitive keymaps
- [ ] Native LSP support
- [ ] Useful autocommands
- [ ] Fast file finder (fzf + fd)
- [ ] Powerful text search (ripgrep + fzf)

## Requirements

- Neovim >= 0.8.0
- A terminal with true color support
- ripgrep (rg)
- fzf
- fd

## Installation

1. Install required tools:
```bash
# Arch Linux
sudo pacman -S ripgrep fzf fd bat

# Ubuntu/Debian
sudo apt install ripgrep fzf fd-find bat
```

2. Backup your existing Neovim configuration:
```bash
mv ~/.config/nvim ~/.config/nvim.backup
```

3. Clone this repository:
```bash
git clone https://github.com/yourusername/purevim.git ~/.config/nvim
```

### LSP Features

- Go to definition: `gd`
- Show documentation: `K`
- Rename symbol: `<leader>rn`
- Code actions: `<leader>ca`

## Performance

This configuration is designed to be lightweight and fast:

- No external plugins
- Lazy redraw enabled
- Optimized updatetime
- Efficient autocommands
- Fast external tools (ripgrep, fzf, fd)

## Contributing

Feel free to fork this repository and customize it to your needs. Pull requests for improvements are welcome!

## License

MIT License - feel free to use and modify as you like.

---

Made with love by a Neovim enthusiast 
