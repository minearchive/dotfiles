#!/bin/sh
# Real Ubuntu x86_64 integration check; downloads packages into a temporary HOME.
# Requires curl, tar, bzip2, sha256sum, and an unprivileged user.
set -eu
if [ "$(id -u)" -eq 0 ]; then
    echo "Run this check as an unprivileged user." >&2
    exit 1
fi
repo=$(CDPATH='' cd -- "$(dirname -- "$0")/../.." && pwd)
work=$(mktemp -d)
trap 'rm -rf "$work"' 0
trap 'exit 1' HUP INT TERM
export HOME="$work/home"
unset XDG_CONFIG_HOME XDG_DATA_HOME XDG_STATE_HOME XDG_CACHE_HOME
mkdir -p "$HOME/.config/nvim" "$HOME/.config/pastel-lua" "$HOME/.local/bin"
printf '%s\n' 'existing user configuration' > "$work/original-config"
printf '%s\n' 'existing user launcher' > "$work/original-launcher"
cp "$work/original-config" "$HOME/.config/nvim/init.lua"
cp "$work/original-config" "$HOME/.config/pastel-lua/init.lua"
cp "$work/original-launcher" "$HOME/.local/bin/pnvim"

# Deploy only the two files, exactly as with scp into the user's home.
cp "$repo/install-neovim-ubuntu.sh" "$HOME/"
cp "$repo/pastel/programs/neovim/init.lua" "$HOME/init.lua"
sh "$HOME/install-neovim-ubuntu.sh"
cmp "$work/original-config" "$HOME/.config/nvim/init.lua"
cmp "$work/original-config" "$HOME/.config/pastel-lua/init.lua.~1~"
cmp "$work/original-launcher" "$HOME/.local/bin/pnvim.~1~"

# Reinstalling must preserve the deployed configuration in a second backup.
sh "$HOME/install-neovim-ubuntu.sh"
cmp "$HOME/init.lua" "$HOME/.config/pastel-lua/init.lua.~2~"

cd "$work"
"$HOME/.local/bin/pnvim" --headless -c "luafile $repo/tests/neovim/asm.lua"
printf '%s\n' 'PASS: non-root installation, two-file deployment, preservation, reinstall, ASM runtime'
