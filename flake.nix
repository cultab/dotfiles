{
  description = "All programs from dotfiles/deploy.sh, installed declaratively with Nix";

  inputs.nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";

  outputs = { nixpkgs, ... }: let
    system = "x86_64-linux";
    pkgs = nixpkgs.legacyPackages.${system};
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
      ];
    };
  };
}
