#!/bin/sh

font=$(fzf << EOF
0xProto
3270
Agave
AnonymousPro
Arimo
AurulentSansMono
BigBlueTerminal
BitstreamVeraSansMono
CascadiaCode
CascadiaMono
CodeNewRoman
ComicShannsMono
CommitMono
Cousine
D2Coding
DaddyTimeMono
DejaVuSansMono
DroidSansMono
EnvyCodeR
FantasqueSansMono
FiraCode
FiraMono
FontPatcher
GeistMono
Go-Mono
Gohu
Hack
Hasklig
HeavyData
Hermit
iA-Writer
IBMPlexMono
Inconsolata
InconsolataGo
InconsolataLGC
IntelOneMono
Iosevka
IosevkaTerm
IosevkaTermSlab
JetBrainsMono
Lekton
LiberationMono
Lilex
MartianMono
Meslo
Monaspace
Monofur
Monoid
Mononoki
MPlus
NerdFontsSymbolsOnly
Noto
OpenDyslexic
Overpass
ProFont
ProggyClean
RobotoMono
ShareTechMono
SourceCodePro
SpaceMono
Terminus
Tinos
Ubuntu
UbuntuMono
VictorMono
EOF
)

if [ -z "${font}" ]; then
	echo "No font selected!"
	exit 1
fi

file="${font}.tar.xz"
version="3.2.1"
url="https://github.com/ryanoasis/nerd-fonts/releases/download/v${version}/${file}"
tempdir="/tmp/nerd_dl"

mkdir -p ${tempdir}

echo "Downloading ${font}.."
wget -q --output-document="${tempdir}/${file}" "${url}"
mkdir -p "${HOME}/.local/share/fonts/${font}"
echo "Unpacking archive.."
tar -axf ${tempdir}/${file} --directory="${HOME}/.local/share/fonts/${font}"

echo "Refreshing font-cache.."
fc-cache -fv

echo "Done!"
