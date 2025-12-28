#!/bin/sh
set -o errexit   # abort on nonzero exitstatus
# set -o nounset   # abort on unbound variable

#todo
# rustup from source if not up to date
# remember successful steps
# packages for each distro
#	add homebrew

CUR_STEP=1
NUM_STEP=12

COLOR_RED='\033[1;31m'
COLOR_GREEN='\033[1;32m'
COLOR_BLUE='\033[1;34m'
COLOR_YELLOW='\033[1;33m'
COLOR_RESET='\033[m'

FAILED_AT=$(cat /tmp/failed_step || true)
if [ -z "$FAILED_AT" ]; then
	FAILED_AT=0
fi

try_cd() {
	if ! cd "$1"; then
		error Failed to cd into "$1"
	fi
	info pwd: "$(pwd)"
}

try() {
	if [ "$CUR_STEP" -le "$FAILED_AT" ]; then
		info "Skipping step.."
		return
	fi
	action=$1
	shift
	command="$*"
	if ! $command; then
		echo "write???"
		echo "$((CUR_STEP - 1))" > /tmp/failed_step
		error 'Failed' "$action"
	fi
}

step() {
	printf "%b%s [%s]:\n%b" "$COLOR_BLUE" "$*" "$CUR_STEP/$NUM_STEP" "$COLOR_RESET"
	CUR_STEP=$(( CUR_STEP+1 ))
}

info() {
	printf '%b%s %b' "$COLOR_YELLOW" "$1" "$COLOR_RESET"
	shift
	printf '%s\n' "$*"
}

error() {
	printf '%b%s\n%b' "$COLOR_RED" "$*" "$COLOR_RESET"
	exit 1
}

step "Installing packages"

info "Detecting distro.."
distro=$(grep '^NAME=' /etc/os-release | cut -d '"' -f 2)

case $distro in
	Void*)
		info 'chose' xbps
		pkg_install () {
			sudo xbps-install -yv "$@"
		}
		pkg_update () {
			sudo xbps-install -Syuv
		}
		try 'updating system' pkg_update
		try 'installing packages' pkg_install git stow make fzf zsh curl keychain man    rustup gcc carapace procs sd bat python3-pipx python3-devel go               dua-cli                dust    bottom choose lsd just gum trash-cli tldr
		;;
	Debian*|Ubuntu*)
		info 'chose' apt
		pkg_install() {
			sudo apt-get install -y --no-install-recommends "$@"
		}
		pkg_update() {
			sudo apt-get update -y && sudo apt-get upgrade -y
		}
		try 'updating system' pkg_update
		try 'installing packages' pkg_install git stow make fzf zsh curl keychain man    rustup gcc carapace procs sd bat         pipx               golang git-delta                        du-dust               lsd just gum trash-cli     
		;;
	Bazzite*)
		info 'chose' brew
		pkg_install() {
			brew install "$@"
		}
		pkg_update() {
			brew update
		}
		try 'updating system' pkg_update
		try 'installing packages' pkg_install git stow make fzf zsh curl keychain mandoc rustup gcc carapace procs sd bat         pipx               golang git-delta dua-cli bob television dust    bottom choose lsd just gum trash-cli tealdeer
		;;
	*)
		error "Unknown distro '$distro'"
esac

step "Cloning repos"

info 'change dir to' "$$HOME"
try_cd "$HOME"

info 'git clone' dotfiles
try 'cloning dotfiles repo' echo git clone 'https://github.com/cultab/dotfiles'

info 'create' "~/repos"
try 'creating repos directory' mkdir -p "$HOME/repos"

(
try_cd ~/repos
try 'cloning Navigator' git clone 'https://github.com/cultab/Navigator.nvim'
try 'cloning command.nvim' git clone 'https://github.com/cultab/command.nvim'
try 'cloning uniwa.nvim' git clone 'https://github.com/uniwa-community/uniwa.nvim'
)

step "Stow dotfiles"
(
	# info backing up default .bashrc and .profile
	mkdir -p ~/backup
	mv -f ~/.bashrc ~/backup/dotbashrc || true
	mv -f ~/.profile ~/backup/dotprofile|| true

	info cd in dotfiles
	(
		try_cd ~/dotfiles
		info remove problematic file # FIXME: just remove from repo
		try 'removing problematic file' rm -f ~/dotfiles/scripts/bin/dwm_bar.sh

		info stow files
		try 'stowing dotfiles' stow git ssh neovim themr wezterm X shell lsd zathura bat sxhkd scripts isort
	)

	info change shell to zsh
	if [ $distro != Bazzite ]; then
		try 'changing shell to zsh' sudo chsh -s /usr/bin/zsh "$USER"
	fi

)

step Run themr
(
	info installing: themr
	try_cd ~/repos
	try 'clone themr' git clone 'https://github.com/cultab/themr'
	try_cd themr
	try 'make' make
	try 'make install' sudo make install
	info 'setting theme to' tokyonight-night
	try 'setting themr themr' themr tokyonight-night
)

step Install xinst
(
	try_cd ~/repos
	try 'cloning xinst' git clone 'https://github.com/cultab/xinst'
	try_cd xinst
	try 'installing xinst' sudo make install
)

export RUSTUP_HOME="${XDG_DATA_HOME:-$HOME/.local/share}/rustup"
export CARGO_HOME="${XDG_DATA_HOME:-$HOME/.local/share}/cargo"

step "Rustup"
(
	true
	#try "rustup initialization" echo 1 | rustup-init
	#try "rustup default toolchain" rustup default stable
)

step Install cargo packages

try "update $$PATH" . "$CARGO_HOME/env"
info installing cargo-binstall


cargo_pkgs=$(grep '\*' < ~/dotfiles/misc/pkgs_cargo.md | cut -d ' ' -f 2 | tr '\n' ' ')

info "packages with cargo-binstall:" "$cargo_pkgs"
for pkg in $cargo_pkgs; do
	case $pkg in
		bob-nvim)
			bin=bob
			;;
		dua-cli)
			bin=dua
			;;
		git-delta)
			bin=delta
			;;
		du-dust)
			;;
		ripgrep)
			bin=rg
			;;
		*)      bin=$pkg
			;;
	esac
	if [ $(command -v $bin) ]; then
		info skipping "package $pkg as $bin exists in" '$PATH'
		continue
	fi
	try "installing $pkg with cargo-binstall" cargo binstall -y "$pkg"
done

step Install go packages
go_pkgs=$(grep '\*' < ~/dotfiles/misc/pkgs_go.md | cut -d ' ' -f 2 | tr '\n' ' ')

info "packages:" "$go_pkgs"
for pkg in $go_pkgs; do
	bin=$(echo $pkg | sed  -nE 's/.*\/([a-z]*)@.*/\1/p')
	if [ $(command -v $bin) ]; then
		info skipping "package $pkg as $bin exists in" '$PATH'
		continue
	fi
	echo $pkg
	try "installing $pkg with go install" go install "github.com/${pkg}"	
done

step Install pip packages
pip_pkgs=$(grep '\*' < ~/dotfiles/misc/pkgs_python.md | cut -d ' ' -f 2 | tr '\n' ' ')

info "packages:" "$pip_pkgs"
for pkg in $pip_pkgs; do
	case $pkg in
		trash-cli)
			bin=trash
			;;
		*)
			bin=$pkg
			;;
	esac
	if [ $(command -v $bin) ]; then
		info skipping "package $pkg as $bin exists in" '$PATH'
		continue
	fi
	try "installing $pkg with pipx" pipx install "$pkg"
done

step Install neovim

try 'installing neovim' "bob use stable"


step Generate new ssh key
choice=$(gum choose yes no --header="Generate new ssh key?")

case $choice in
	y*)
		ssh-keygen -t ed25519 -C "rroarck@gmail.com" -f ~/.ssh/github
		;;
	*)
		;;
esac

rm /tmp/failed_step
exec zsh -l
