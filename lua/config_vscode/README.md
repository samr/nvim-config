# Visual Studio Code and Neovim Config

This directory is for settings used to configure Neovim when it is running within the context of VSCode using the
[vscode-neovim plugin](https://github.com/vscode-neovim/vscode-neovim).

Notably most of the configuration for VSCode is found in Windows under the
`C:\Users\$USERNAME\AppData\Roaming\Code\User` directory or in Linux under `~/.vscode`.


## VSCode Specific Settings

Some key mappings are only possible by specifying them in the `keybindings.json`, such as those that use the `Alt` key,
or at the very least they require a passthrough defined.

Theme and color overrides are found in `settings.json`.

In the `nvim` root directory there is a `vscode` directory. It contains a `sync.sh` script that can be used to back up
the user configuration to that directory. Then the configs can be checked into this repo.


## Plugins of Note

In addition to the primary [vscode-neovim plugin](https://github.com/vscode-neovim/vscode-neovim), I tend to install
the following VSCode plugins to compliment this config (for development in C++ and Python):

- [Ayu color theme](https://github.com/ayu-theme/vscode-ayu)
- [Output Colorizer by IBM](https://github.com/IBM-Cloud/vscode-log-output-colorizer)
- Micorosft's plugins:
    - C/C++, C/C++ Extension Pack and C/C++ Themes
    - Pylance, Python and Python Debugger
    - CMake Tools
    - WSL
- [CMake by twxs](https://github.com/twxs/vs.language.cmake)
- [GitLens by GitKraken](https://github.com/gitkraken/vscode-gitlens)
- [Clang-Format by Xaver Hellauer](https://github.com/xaverh/vscode-clang-format)
- [vscode-proto3 by zxh404](https://github.com/zxh0/vscode-proto3)
