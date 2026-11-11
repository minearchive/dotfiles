#!/bin/sh
# Ubuntu x86_64, no sudo. Run: sh install-neovim-ubuntu.sh
set -eu

if [ "$(uname -s)" != Linux ] || [ "$(uname -m)" != x86_64 ]; then
    echo "This installer requires x86_64 Linux (Ubuntu)." >&2
    exit 1
fi
for cmd in curl tar bzip2 sha256sum; do
    if ! command -v "$cmd" >/dev/null 2>&1; then
        echo "Required command not found: $cmd" >&2
        exit 1
    fi
done

repo=$(CDPATH='' cd -- "$(dirname -- "$0")" && pwd)
source_config="$repo/pastel/programs/neovim/init.lua"
if [ ! -r "$source_config" ]; then
    source_config="$repo/init.lua"
fi
if [ ! -r "$source_config" ]; then
    echo "Missing init.lua: place it beside this script, or run from the dotfiles repository." >&2
    exit 1
fi

work=$(mktemp -d)
trap 'rm -rf "$work"' 0
trap 'exit 1' HUP INT TERM

export MAMBA_ROOT_PREFIX="$HOME/.local/share/micromamba"
mamba="$HOME/.local/bin/micromamba"
tools="$HOME/.local/share/nvim-tools"
nvim_dir="$HOME/.local/opt/nvim-0.12.6"
config_dir="${XDG_CONFIG_HOME:-$HOME/.config}/pastel-lua"
mkdir -p "$HOME/.local/bin" "$config_dir"

if [ ! -x "$mamba" ]; then
    curl -fL https://micro.mamba.pm/api/micromamba/linux-64/latest \
        -o "$work/micromamba.tar.bz2"
    tar -xjf "$work/micromamba.tar.bz2" -C "$work" bin/micromamba
    install -m 755 "$work/bin/micromamba" "$mamba"
fi

if [ -d "$tools/conda-meta" ]; then
    action=install
else
    action=create
fi
"$mamba" "$action" -y -p "$tools" --override-channels -c conda-forge \
    git ripgrep asm-lsp gcc nasm unzip

if [ ! -x "$nvim_dir/bin/nvim" ]; then
    curl -fL https://github.com/neovim/neovim/releases/download/v0.12.6/nvim-linux-x86_64.tar.gz \
        -o "$work/nvim.tar.gz"
    printf '%s  %s\n' \
        474430d53e6264f6d6dd18db42d6dc9df3a1b56ca9e88a325bbf860e1a811d87 \
        "$work/nvim.tar.gz" | sha256sum -c -
    mkdir -p "$nvim_dir"
    tar -xzf "$work/nvim.tar.gz" -C "$nvim_dir" --strip-components=1
fi

# Keep numbered backups when reinstalling over an existing config or launcher.
cp --backup=numbered "$source_config" "$config_dir/init.lua"
cat > "$work/pnvim" <<'EOF'
#!/bin/sh
export MAMBA_ROOT_PREFIX="$HOME/.local/share/micromamba"
exec "$HOME/.local/bin/micromamba" run \
    -p "$HOME/.local/share/nvim-tools" \
    env NVIM_APPNAME=pastel-lua \
    "$HOME/.local/opt/nvim-0.12.6/bin/nvim" "$@"
EOF
chmod 755 "$work/pnvim"
cp --backup=numbered --preserve=mode "$work/pnvim" "$HOME/.local/bin/pnvim"

"$HOME/.local/bin/pnvim" --version
printf '\nInstalled. Start with: %s/.local/bin/pnvim\n' "$HOME"
printf '%s\n' 'If ~/.local/bin is not on PATH, add this to your shell configuration:' \
    "export PATH=\"\$HOME/.local/bin:\$PATH\"" \
    'Plugins are downloaded on first launch. Existing ~/.config/nvim is unchanged.'
