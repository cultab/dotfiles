#!/bin/sh
set -o errexit   # abort on nonzero exitstatus
# set -o nounset   # abort on unbound variable
# set -o pipefail  # don't hide errors within pipes

CUR_STEP=1
NUM_STEP=12

COLOR_RED='\033[1;31m'
COLOR_GREEN='\033[1;32m'
COLOR_BLUE='\033[1;34m'
COLOR_YELLOW='\033[1;33m'
COLOR_RESET='\033[m'

DRY_RUN() {
	DRY=-n
	fake() {
		# info faking command: $(printf '\t%s\n' "$*")
		printf '%bfaking command%b `%s`\n' "$COLOR_GREEN" "$COLOR_RESET" "$*"
	}
}

# DRY_RUN

try_cd() {
	if ! cd $1; then
		error Failed to cd into "$1"
	fi
	info pwd: "$(pwd)"
}

try() {
	action=$1
	shift
	command="$*"
	# if [ $DRY ]; then
		# printf '%bfaking command%b `%s`..\n' "$COLOR_GREEN" "$COLOR_RESET" "$command"
		# return
	# fi
	if ! $command; then
		error 'Failed to' "$action"
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

step "Choosing package manager"

info "Detecting distro.."
distro=$(grep '^NAME=' /etc/os-release | cut -d '"' -f 2)

case $distro in
	Void*)
		info 'chose' xbps
		pkg_install () {
			xbps-install -yv "$@"
		}
		pkg_update () {
			xbps-install -Syuv
		}
		;;
	Debian*)
		info 'chose' apt
		pkg_install() {
			apt-get install -y --no-install-recommends "$@"
		}
		pkg_update() {
			apt-get update -y && apt-get upgrade -y
		}
		;;
	*)
		error "Uknown distro '$distro'"
esac

step "Updating"
try 'update system' pkg_update

step "Installing important packages"
try 'install pkgs' pkg_install git stow make golang fzf cargo pipx zsh curl keychain man

step "Cloning repos"

info 'change dir to' '$HOME'
try_cd "$HOME"

info 'git clone' dotfiles
try 'clone dotfiles repo' git clone 'https://github.com/cultab/dotfiles'

info 'create' "~/repos"
try 'creating repos directory' mkdir -p "$HOME/repos"

(
try_cd ~/repos
try 'clone Navigator' git clone 'https://github.com/cultab/Navigator.nvim'
try 'clone command.nvim' git clone 'https://github.com/cultab/command.nvim'
try 'clone uniwa.nvim' git clone 'https://github.com/uniwa-community/uniwa.nvim'
)

step "Stow dotfiles"

info backing up default .bashrc and .profile
mv -f ~/.bashrc ~/.bashrc_pre_dotfile_deploy || true
mv -f ~/.profile ~/.profile_pre_dotfile_deploy || true

info cd in dotfiles
(
try_cd ~/dotfiles
info remove problematic file # FIXME: just remove from repo
try 'remove problematic file' rm -f ~/dotfiles/scripts/bin/dwm_bar.sh

info stow files
try 'stow dotfiles' stow git ssh neovim themr wezterm X shell lsd zathura bat sxhkd scripts isort
)

info change shell to zsh
try 'change shell to zsh' chsh -s /usr/bin/zsh "$USER"

step Run themr

(
info installing: themr
try_cd ~/repos
try 'clone themr' git clone 'https://github.com/cultab/themr'
try_cd themr
try 'make' make
try 'make install' make install
info 'setting theme to' tokyonight-night
try 'setting themr themr' themr tokyonight-night
)

step Install xinst
(
try_cd ~/repos
try 'clone xinst' git clone 'https://github.com/cultab/xinst'
try_cd xinst
try 'installing xinst' make install
)

step Install cargo packages

info installing cargo-binstall
try 'cargo installing cargo-binstall' cargo install cargo-binstall

cargo_pkgs=$(grep '\*' < ~/dotfiles/misc/pkgs_cargo.md | cut -d ' ' -f 2 | tr '\n' ' ')

info "packages with cargo-binstall:" "$cargo_pkgs"
for pkg in $cargo_pkgs; do
	try "installing $pkg with cargo-binstall" cargo binstall -y "$pkg"
done

step Install go packages
go_pkgs=$(grep '\*' < ~/dotfiles/misc/pkgs_go.md | cut -d ' ' -f 2 | tr '\n' ' ')

info "packages:" "$go_pkgs"
for pkg in $go_pkgs; do
	try "installing $pkg with go install" go install "github.com/${pkg}"	
done

step Install pip packages
pip_pkgs=$(grep '\*' < ~/dotfiles/misc/pkgs_python.md | cut -d ' ' -f 2 | tr '\n' ' ')

info "packages:" "$pip_pkgs"
for pkg in $pip_pkgs; do
	try "installing $pkg with pipx" pipx install "$pkg"
done

step Install neovim

try 'installing neovim' "$HOME/.cargo/bin/bob use stable"

# TODO:
# step Generate ssh key for github
# ask if we want to generate w/ gum
# ask for email w/ gum
# ssh-keygen -t ed25519 -C "your_email@example.com" -f ~/.ssh/github
# save to ~/.ssh/github

exec zsh -l
