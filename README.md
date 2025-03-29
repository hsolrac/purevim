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

![image](https://github.com/user-attachments/assets/754119f0-42fa-4dcc-ade0-45e5eb4ac7ca)
![image](https://github.com/user-attachments/assets/838a282a-6df9-4f10-b998-58c80ab433b3)

> [!WARNING]  
> **Incomplete Setup**  
> This configuration is not yet production-ready.  
> • Pending LSP adjustments  
> • Runtime path errors detected  


## Features

- [x] Intuitive keymaps
- [x] Native LSP support
  - [x] Go to definition: `gd`
  - [x] Show documentation: `K`
  - [x] Rename symbol: `<leader>rn`
  - [x] Code actions: `<leader>ca`
- [x] Useful autocommands
  - [x] Diagnostics float mouse hover
  - [x] autoformat
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
