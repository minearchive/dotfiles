#!/usr/bin/env bash
set -e

# Available hosts and profiles
HOSTS=(msiLaptop desktop wsl)
PROFILES=(material pastel wsl)

echo "=== dotfiles init ==="

# Select host
echo ""
echo "Select host:"
select HOST in "${HOSTS[@]}"; do
  [[ -n "$HOST" ]] && break
done

# Select home manager profile
echo ""
echo "Select Home Manager profile:"
select PROFILE in "${PROFILES[@]}"; do
  [[ -n "$PROFILE" ]] && break
done

# Generate rebuild.sh
cat > rebuild.sh <<EOF
#!/usr/bin/env bash
sudo nixos-rebuild switch --flake .#${HOST}
EOF
chmod +x rebuild.sh

# Generate update-home.sh
cat > update-home.sh <<EOF
#!/usr/bin/env bash
nix run nixpkgs#home-manager -- switch --flake .#${PROFILE} -b backup
EOF
chmod +x update-home.sh

echo ""
echo "Generated rebuild.sh (host: ${HOST}) and update-home.sh (profile: ${PROFILE})"
