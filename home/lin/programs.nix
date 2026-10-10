# home/lin/programs.nix
# Program-specific configurations

{ config, pkgs, lib, ... }:

{
  # ── Bat (syntax-highlighted cat) ─────────────────────────────────────
  programs.bat = {
    enable = true;
    config = {
      theme = "Dracula";
      style = "numbers,changes,header";
      pager = "less -FR";
    };
  };

  # ── Btop (system monitor) ──────────────────────────────────────────
  programs.btop = {
    enable = true;
    settings = {
      color_theme = "Default";
      theme_background = true;
      truecolor = true;
      force_tty = false;
    };
  };

  # ── Eza (modern ls) ──────────────────────────────────────────────
  programs.eza = {
    enable = true;
    enableAliases = true;
    icons = true;
    git = true;
  };

  # ── FZF (fuzzy finder) ─────────────────────────────────────────────
  programs.fzf = {
    enable = true;
    enableBashIntegration = true;
    defaultOptions = [
      "--height 40%"
      "--layout=reverse"
      "--border"
      "--preview 'bat --color=always --line-range :500 {}'"
    ];
  };

  # ── Zoxide (smart cd) ──────────────────────────────────────────────
  programs.zoxide = {
    enable = true;
    enableBashIntegration = true;
    options = [ "--cmd cd" ];
  };

  # ── Starship (prompt) ──────────────────────────────────────────────
  programs.starship = {
    enable = true;
    enableBashIntegration = true;
    settings = {
      format = "$all$directory$character";
      directory = {
        truncation_length = 3;
        truncate_to_repo = true;
      };
      git_branch = {
        symbol = "🌱 ";
        truncation_length = 40;
      };
      nix_shell = {
        symbol = "❄️ ";
        format = "via [$symbol$state]($style) ";
      };
    };
  };

  # ── Direnv ─────────────────────────────────────────────────────────
  programs.direnv = {
    enable = true;
    nix-direnv.enable = true;
  };

  # ── Kitty (terminal emulator) ────────────────────────────────────
  programs.kitty = {
    enable = true;
    settings = {
      font_family = "JetBrainsMono Nerd Font";
      font_size = "11.0";
      cursor_shape = "block";
      cursor_blink_interval = "0";
      scrollback_lines = 10000;
      enable_audio_bell = false;
      background_opacity = "0.95";
      background = "#1e1e2e";
      foreground = "#cdd6f4";
      color0 = "#45475a";
      color1 = "#f38ba8";
      color2 = "#a6e3a1";
      color4 = "#89b4fa";
      color7 = "#bac2de";
      color8 = "#585b70";
      color15 = "#a6adc8";
    };
  };

  # ── Neovim (already system default, but user config here) ──────────
  programs.neovim = {
    enable = true;
    defaultEditor = true;
    viAlias = true;
    vimAlias = true;
    extraLuaConfig = ''''
      -- Minimal init.lua for lin
      vim.opt.number = true
      vim.opt.relativenumber = true
      vim.opt.expandtab = true
      vim.opt.shiftwidth = 2
      vim.opt.tabstop = 2
      vim.opt.smartindent = true
      vim.opt.termguicolors = true
      vim.opt.mouse = 'a'
      vim.opt.clipboard = 'unnamedplus'
      vim.opt.undofile = true
      vim.opt.ignorecase = true
      vim.opt.smartcase = true
    ''';
    plugins = with pkgs.vimPlugins; [
      nvim-treesitter
      nvim-lspconfig
      plenary-nvim
      telescope-nvim
      dracula-nvim
    ];
  };

  # ── Git (user-level overrides) ───────────────────────────────────
  programs.git = {
    enable = true;
    userName = "stefan-hacks";
    userEmail = "stefan-hacks@users.noreply.github.com";
    aliases = {
      st = "status -sb";
      ci = "commit";
      co = "checkout";
      br = "branch";
      lg = "log --oneline --graph --decorate --all";
      last = "log -1 HEAD";
    };
    extraConfig = {
      init.defaultBranch = "main";
      push.autoSetupRemote = true;
      pull.rebase = true;
      core.editor = "nvim";
      core.pager = "delta";
      interactive.diffFilter = "delta --color-only";
      delta = {
        navigate = true;
        light = false;
        side-by-side = true;
      };
    };
  };

  # ── Delta (git diff viewer) ────────────────────────────────────────
  programs.git.delta = {
    enable = true;
    options = {
      syntax-theme = "Dracula";
      line-numbers = true;
      side-by-side = true;
    };
  };

  # ── GnuPG ──────────────────────────────────────────────────────────
  programs.gpg = {
    enable = true;
    homedir = "${config.home.homeDirectory}/.gnupg";
  };

  # ── SSH ──────────────────────────────────────────────────────────────
  programs.ssh = {
    enable = true;
    forwardAgent = false;
    serverAliveInterval = 60;
    hashKnownHosts = true;
    matchBlocks = {
      "github.com" = {
        user = "git";
        identityFile = "~/.ssh/lin";
        identitiesOnly = true;
      };
      "*.local" = {
        user = "lin";
        extraOptions = {
          StrictHostKeyChecking = "no";
        };
      };
    };
  };

  # ── VSCode ─────────────────────────────────────────────────────────
  programs.vscode = {
    enable = true;
    package = pkgs.vscodium;
    extensions = with pkgs.vscode-extensions; [
      dracula-theme.theme-dracula
      vscodevim.vim
      rust-lang.rust-analyzer
      golang.go
      ms-python.python
      bbenoist.nix
      jnoortheen.nix-ide
      kamadorueda.alejandra
      tamasfe.even-better-toml
      serayuzgur.crates
      github.copilot
    ];
    userSettings = {
      "editor.fontFamily" = "'JetBrainsMono Nerd Font', 'monospace'";
      "editor.fontSize" = 13;
      "editor.lineHeight" = 22;
      "editor.renderWhitespace" = "boundary";
      "editor.rulers" = [ 80 120 ];
      "editor.wordWrap" = "on";
      "editor.formatOnSave" = true;
      "editor.defaultFormatter" = "jnoortheen.nix-ide";
      "workbench.colorTheme" = "Dracula";
      "workbench.iconTheme" = "material-icon-theme";
      "terminal.integrated.fontFamily" = "JetBrainsMono Nerd Font";
      "git.confirmSync" = false;
      "nix.enableLanguageServer" = true;
      "nix.serverPath" = "nixd";
      "nix.formatterPath" = "nixpkgs-fmt";
    };
  };

  # ── Zellij (terminal multiplexer) ──────────────────────────────────
  programs.zellij = {
    enable = true;
    settings = {
      theme = "dracula";
      default_layout = "compact";
      pane_frames = false;
      copy_on_select = true;
      scrollback_editor = "nvim";
    };
  };

  # ── Tmux ─────────────────────────────────────────────────────────────
  programs.tmux = {
    enable = true;
    baseIndex = 1;
    escapeTime = 0;
    historyLimit = 10000;
    keyMode = "vi";
    mouse = true;
    prefix = "C-a";
    plugins = with pkgs.tmuxPlugins; [
      resurrect
      continuum
      dracula
    ];
    extraConfig = ''''
      # Easy config reload
      bind r source-file ~/.config/tmux/tmux.conf \\; display-message "Config reloaded!"

      # Pane splitting
      bind | split-window -h
      bind - split-window -v

      # Pane navigation (vim-style)
      bind h select-pane -L
      bind j select-pane -D
      bind k select-pane -U
      bind l select-pane -R

      # Enable 24-bit color
      set -ga terminal-overrides ",xterm-256color:Tc"
    ''';
  };
}
