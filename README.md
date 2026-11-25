# my-vimrc

For a fresh Neovim Qt setup, follow these steps in order. Keep a local copy of this repository for the configuration files and fonts.

1. [Install Neovim and Neovim Qt](#install-neovim-qt).
2. [Install the Neovim configuration and plugins](#configure-neovim).
3. [Install Universal Ctags](#install-universal-ctags) to use Tagbar.
4. [Install ripgrep](#install-ripgrep) for text search.
5. [Install the bundled font](#set-up-the-bundled-font).

## Install Universal Ctags

### Windows

1. Download the ZIP for your architecture (`x64` for 64-bit Intel or AMD systems) from the [official Windows releases](https://github.com/universal-ctags/ctags-win32/releases).
2. Extract it to a folder such as `C:\Tools\ctags`. In Windows **Environment Variables**, add the directory containing `ctags.exe` to your user `Path`.
3. Open a new PowerShell window and run `ctags --version`. The output should identify it as Universal Ctags.

Restart Neovim Qt and run `:echo exepath('ctags')` to check that it can find `ctags.exe`.

### Linux (Debian and Ubuntu)

```sh
sudo apt install universal-ctags
```

## Install Neovim Qt

### Windows

Run these commands in PowerShell to install Neovim and its Qt frontend with WinGet.

```powershell
winget install --id Git.Git --exact
winget install --id Neovim.Neovim --exact
winget install --id equalsraf.neovim-qt --exact
```

Open a new PowerShell window and run `nvim-qt`.

### Linux (build from source)

Build Neovim and Neovim Qt from source to use a recent Neovim with Denops and ddc. On Debian and Ubuntu, install the build dependencies with APT. On other distributions, install the equivalent compiler, build tools, and Qt 6 development packages.

```sh
sudo apt update
sudo apt install build-essential cmake ninja-build gettext curl git \
  qt6-base-dev qt6-svg-dev unzip fontconfig
```

Build and install stable Neovim under `/usr/local`.

```sh
git clone --branch stable https://github.com/neovim/neovim.git
make -C neovim CMAKE_BUILD_TYPE=Release
sudo cmake --install neovim/build
/usr/local/bin/nvim --version
```

Build Neovim Qt and launch it with the Neovim binary you just installed.

```sh
git clone --branch v0.2.20 https://github.com/equalsraf/neovim-qt.git
cmake -S neovim-qt -B neovim-qt/build -G Ninja \
  -DCMAKE_BUILD_TYPE=Release -DCMAKE_INSTALL_PREFIX=/usr/local \
  -DNEOVIM_EXEC=/usr/local/bin/nvim
cmake --build neovim-qt/build
sudo cmake --install neovim-qt/build
/usr/local/bin/nvim-qt --nvim /usr/local/bin/nvim
```

See the upstream [Neovim build guide](https://github.com/neovim/neovim/blob/stable/BUILD.md) and [Neovim Qt build guide](https://github.com/equalsraf/neovim-qt#building-from-source) for additional options.

## Configure Neovim

Install Deno 2.3.0 or later for ddc completion. On Windows, run this command in PowerShell, then open a new PowerShell window. See the [Deno installation guide](https://docs.deno.com/runtime/getting_started/installation/).

```powershell
winget install --id DenoLand.Deno --exact
```

On Linux, run these commands.

```sh
curl -fsSL https://deno.land/install.sh | sh
export PATH="$HOME/.deno/bin:$PATH"
```

Run `deno --version` to check the installation.

Install vim-plug for Neovim. In PowerShell, run `nvim --clean`. On Linux, run `/usr/local/bin/nvim --clean` to use the build installed above. Then paste this command into Neovim.

```vim
:call mkdir(stdpath('data') . '/site/autoload', 'p')
```

Download [plug.vim](https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim) into that directory. Run `:echo stdpath('data') . '/site/autoload'` to get the full path.

1. Run `:echo stdpath('config')` and create that directory if needed. The default is `%LOCALAPPDATA%\nvim` on Windows and `~/.config/nvim` on Linux.
2. On a fresh setup, copy this repository's [init.vim](init.vim) into that directory. If you already have an `init.vim` or `init.lua`, merge the settings into your existing configuration.
3. Exit Neovim and launch `nvim-qt` on Windows or `/usr/local/bin/nvim-qt --nvim /usr/local/bin/nvim` on Linux. Run `:PlugInstall` and restart Neovim Qt when the installation finishes. This installs denops.vim and ddc along with the other plugins.
4. Run `:checkhealth denops` to check Denops. If it cannot find Deno, check `:echo exepath('deno')` and launch Neovim Qt from a shell where `deno --version` works.

### Telescope

| Mapping | Action |
| --- | --- |
| `<leader>ff` | Find files in the working directory |
| `<leader>fg` | Search file contents with ripgrep |
| `<leader>fb` | Switch buffers |
| `<leader>fh` | Search help tags |

Use `:Telescope oldfiles` for recently opened files and `:Telescope registers` for registers.

## Install ripgrep

Telescope's `live_grep` and the `gr` mapping require [ripgrep](https://github.com/BurntSushi/ripgrep#installation) on your `PATH`.

### Windows

```powershell
winget install --id BurntSushi.ripgrep.MSVC --exact
```

> **Note**: On Windows, the `gr` mapping requires PowerShell Core (`pwsh`) to be installed. If `pwsh` is not installed, you can install it via winget:
> ```powershell
> winget install --id Microsoft.PowerShell --exact
> ```

### Linux (Debian and Ubuntu)

```sh
sudo apt update
sudo apt install ripgrep
```

Open a new terminal and run `rg --version`. Restart Neovim Qt and run `:echo exepath('rg')` to verify that it can find ripgrep.

## Set up the bundled font

This repository includes the Regular and Bold faces of [HackGen Console v2.10.0](https://github.com/yuru7/HackGen/releases/tag/v2.10.0) in [fonts/hackgen-console](fonts/hackgen-console). The fonts are distributed under the [SIL Open Font License 1.1](fonts/hackgen-console/LICENSE).

- **Windows**. Open each bundled `.ttf` file and click **Install**.
- **Linux**. Run these commands from the repository root.

  ```sh
  font_dir="${XDG_DATA_HOME:-$HOME/.local/share}/fonts/hackgen-console"
  mkdir -p "$font_dir"
  cp fonts/hackgen-console/*.ttf "$font_dir/"
  fc-cache -f "$font_dir"
  ```

Copy [ginit.vim](ginit.vim) into the directory shown by `:echo stdpath('config')` in Neovim. The default is `%LOCALAPPDATA%\nvim` on Windows and `~/.config/nvim` on Linux. If you already have a `ginit.vim`, merge the font setting into it. Restart Neovim Qt to use HackGen Console at 11 pt.
