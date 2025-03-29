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
- [x] Native LSP support
- [ ] Useful autocommands
- [ ] File finder 
- [ ] Text search 

## Requirements

- Neovim >= 0.10.0
- A terminal with true color support
- LSP servers for your languages

## Installation

1. Backup your existing Neovim configuration:
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

## Contributing

Feel free to fork this repository and customize it to your needs. Pull requests for improvements are welcome!

## License

MIT License - feel free to use and modify as you like.

---

Made with love by a Neovim enthusiast 
