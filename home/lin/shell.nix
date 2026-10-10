# home/lin/shell.nix
# Bash shell configuration (imported from Debian .bashrc + .bash_aliases)

{ config, pkgs, lib, ... }:

{
  # ── Bash ─────────────────────────────────────────────────────────────
  programs.bash = {
    enable = true;
    enableCompletion = true;
    historyControl = [ "ignoredups" "ignorespace" ];
    historyFileSize = 100000;
    historySize = 100000;
    shellOptions = [
      "histappend"
      "checkwinsize"
      "globstar"
      "cdspell"
      "dirspell"
    ];

    # ── Environment variables ────────────────────────────────────────
    sessionVariables = {
      HISTTIMEFORMAT = "%F %T ";
      PROMPT_DIRTRIM = "3";
      LESS = "-R --mouse";
      EDITOR = "nvim";
      VISUAL = "nvim";
      BROWSER = "firefox";
      MOZ_ENABLE_WAYLAND = "1";
      NIXOS_OZONE_WL = "1";
      QT_QPA_PLATFORM = "wayland;xcb";
    };

    # ── Bash aliases (condensed from .bash_aliases audit) ──────────
    shellAliases = {
      # Safety nets
      cp = "cp -iv";
      mv = "mv -iv";
      rm = "rm -Iv";
      mkdir = "mkdir -pv";
      ln = "ln -iv";

      # Navigation
      ".." = "cd ..";
      "..." = "cd ../..";
      "...." = "cd ../../..";
      "~" = "cd ~";
      "-" = "cd -";

      # Listing (eza)
      ls = "eza --icons --group-directories-first";
      la = "eza -a --icons --group-directories-first";
      ll = "eza -l --icons --group-directories-first";
      lt = "eza -T --icons --group-directories-first --level=2";
      lla = "eza -la --icons --group-directories-first";
      lgit = "eza -la --icons --git --git-ignore";

      # Search
      f = "fzf --preview 'bat --color=always --line-range :500 {}'";
      rg = "rg --smart-case --follow --hidden --glob '!.git'";
      fd = "fd --hidden --follow --exclude .git";

      # Archives
      untar = "tar -xvf";
      untgz = "tar -xzvf";
      unbz2 = "tar -xjvf";
      unzip = "unzip -q";

      # Process
      psx = "ps auxf";
      psg = "ps aux | grep -i";
      top = "btop";
      htop = "btop";
      mem = "free -h";
      df = "df -hT | grep -v tmpfs";

      # System
      reboot = "sudo reboot";
      shutdown = "sudo shutdown -h now";
      update = "sudo nixos-rebuild switch --flake ~/lin";
      upgrade = "sudo nixos-rebuild switch --upgrade --flake ~/lin";
      nix-gc = "sudo nix-collect-garbage -d";
      optimise = "sudo nix-store --optimise";

      # Nix
      nix-search = "nix search nixpkgs";
      nix-shell-p = "nix-shell -p";
      nix-info = "nix-shell --run 'nix-info -m'";

      # Git
      g = "git";
      ga = "git add";
      gaa = "git add --all";
      gc = "git commit";
      gcm = "git commit -m";
      gco = "git checkout";
      gb = "git branch";
      gba = "git branch -a";
      gbd = "git branch -d";
      gbD = "git branch -D";
      gd = "git diff";
      gds = "git diff --staged";
      gf = "git fetch";
      gl = "git log --oneline --graph --decorate --all";
      gm = "git merge";
      gp = "git push";
      gpl = "git pull";
      gr = "git remote -v";
      grs = "git reset";
      grsh = "git reset --hard";
      gs = "git status -sb";
      gst = "git stash";
      gsta = "git stash apply";
      gsw = "git switch";
      gswc = "git switch -c";

      # Docker / Podman
      d = "podman";
      dc = "podman-compose";
      di = "podman images";
      dps = "podman ps -a";
      drm = "podman rm";
      drmi = "podman rmi";
      ds = "podman start";
      dst = "podman stop";
      dl = "podman logs";
      dexec = "podman exec -it";

      # Network
      ping = "ping -c 5";
      ports = "ss -tulanp";
      myip = "curl -s https://ipinfo.io/ip";
      flush-dns = "sudo systemd-resolve --flush-caches";

      # Security
      ports-listen = "sudo ss -tulanp | grep LISTEN";
      lsof-net = "sudo lsof -i";
      audit-system = "sudo lynis audit system";

      # Quick edits
      bashrc = "$EDITOR ~/.bashrc";
      zshrc = "$EDITOR ~/.zshrc";
      vimrc = "$EDITOR ~/.config/nvim/init.lua";
    };

    # ── Bash init extra ──────────────────────────────────────────────
    # initExtra managed via simpler session variables
  };
}
