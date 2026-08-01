#!/bin/bash
BLOCK='```'

cat <<EOF >README.md
# [sysz](https://github.com/rorph/sysz)

A [fzf](https://github.com/junegunn/fzf) terminal UI for systemctl

Fork of [joehillen/sysz](https://github.com/joehillen/sysz) with Debian packaging,
back-navigation from the command picker, and improved log follow.

# Demo

[![asciicast](https://asciinema.org/a/BLsJz73uF7DdQj7FVGqLPhqCa.svg)](https://asciinema.org/a/BLsJz73uF7DdQj7FVGqLPhqCa)

# Features

VERSION: $(cat VERSION)

- See and filter both system and user units simultaneously.
- Supports all unit types.
- Units ordered by service, timer, socket, and the rest.
- Runs \`sudo\` automatically and only if necessary.
- Filter units by state using \`ctrl-s\` or the \`--state\` option.
- Run \`daemon-reload\` with \`ctrl-r\`.
- Follow unit logs with \`ctrl-f\` or the \`follow\` / \`f\` command.
- Back from the Commands menu (ESC / ctrl-b / ← / select **back**) returns to Units.
- After any action, returns to the unit list instead of dropping to the shell.
- Has short versions of systemctl commands to reduce typing.
- Runs status after other commands (start, stop, restart, etc).
- Select multiple units, states, and commands using \`TAB\`.
- Only prompts commands based on current state
  (e.g. show "start" only if the unit is inactive).

# Requirements

- [fzf](https://github.com/junegunn/fzf) >= [0.27.1](https://github.com/junegunn/fzf/blob/master/CHANGELOG.md#0244)
- bash > 4.3 (released 2009)
- awk

# Installation

## Debian / Ubuntu (.deb)

Build a package that declares the \`fzf\` dependency:

${BLOCK}sh
git clone https://github.com/rorph/sysz.git
cd sysz
make deb                    # → dist/sysz_*_all.deb
sudo apt install ./dist/sysz_*_all.deb
${BLOCK}

\`Depends: bash (>= 4.3), fzf (>= 0.27.1)\` — apt will pull \`fzf\` if missing.

CI builds the same package on every push/PR (GitHub Actions workflow artifact
\`sysz-deb\`) and attaches \`sysz_*.deb\` to [GitHub Releases](https://github.com/rorph/sysz/releases)
next to the bare script.

## Arch Linux

${BLOCK}
paru -S sysz
${BLOCK}

## NixOS

${BLOCK}
nix-env -iA nixos.sysz
${BLOCK}

## Using Nix

${BLOCK}
nix-env -iA nixpkgs.sysz
${BLOCK}

## Using [\`bin\`](https://github.com/marcosnils/bin)

${BLOCK}
bin install https://github.com/rorph/sysz
${BLOCK}

## Direct Download

${BLOCK}sh
wget -O ~/.bin/sysz https://github.com/rorph/sysz/releases/latest/download/sysz
chmod +x ~/.bin/sysz
${BLOCK}

## From Source

${BLOCK}sh
git clone https://github.com/rorph/sysz.git
cd sysz
sudo make install # /usr/local/bin/sysz
${BLOCK}

# Usage

${BLOCK}text
$(./sysz -h 2>&1 | sed -e 's:/home/[a-z]\+/.cache:$XDG_CACHE_HOME:')
${BLOCK}

# Acknowledgements

Upstream: [joehillen/sysz](https://github.com/joehillen/sysz).
Inspired by [fuzzy-sys](https://github.com/NullSense/fuzzy-sys) by [NullSense](https://github.com/NullSense/).

Thank you for [ShellCheck](https://github.com/koalaman/shellcheck) without which this would be a buggy mess.
EOF
