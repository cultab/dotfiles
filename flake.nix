{
  description = "All programs from dotfiles/deploy.sh, installed declaratively with Nix";

  inputs.nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";

  outputs = { nixpkgs, ... }: let
    system = "x86_64-linux";
    pkgs = nixpkgs.legacyPackages.${system};
    themrPkg = pkgs.buildGoModule rec {
      pname = "themr";
      version = "0.2.5";
      src = pkgs.fetchFromGitHub {
        owner = "cultab";
        repo = "themr";
        rev = "v${version}";
        hash = "sha256-QrbRHaPmAqyyTzbLpqwOK5nEAPpk3Bksnx3yK9uNoyY=";
      };
      vendorHash = "sha256-ZxEIQdTJwVPX9DCmSp2NfyQVaXo+xlIMZUSjHDZHGo8=";
      ldflags = [ "-s" "-w" "-X=main.Version=${version}" ];
      meta.mainProgram = "themr";
    };
  in {
    packages.${system}.default = pkgs.buildEnv {
      name = "my-packages";
      paths = with pkgs; [
        # deploy.sh brew branch (Bazzite)
        git
        stow
        gnumake # make
        fzf
        zsh
        curl
        keychain
        mandoc
        rustup
        gcc
        carapace
        procs
        sd
        bat
        pipx
        go # golang
        delta # git-delta
        dua # dua-cli
        bob-nvim # bob, neovim version manager
        television
        dust # du-dust
        bottom
        choose
        lsd
        just
        gum
        trash-cli
        tealdeer # tldr

        # deploy.sh cargo / go / pip extras
        ripgrep
        nap
        rura
        yt-dlp
        neovim # installed via `bob use stable` in deploy.sh
        python3
        tree-sitter
        themrPkg
        # nvim-colorscheme # handled by `themr catppuccin-light`
      ];
    };

    # ships ~/.config/nvim/lua/user/colorscheme.lua
    # packages.${system}.nvim-colorscheme = pkgs.writeTextDir ".config/nvim/lua/user/colorscheme.lua" ''return "default"'';

    apps.${system}.setup = {
      type = "app";
      program = "${pkgs.writeShellScript "themr-setup" ''
        ${pkgs.nix}/bin/nix profile install .#
        stow themr
        themr catppuccin-light
      ''}";
    };
  };
}
