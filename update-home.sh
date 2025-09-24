#!/usr/bin/env bash

nix run nixpkgs#home-manager -- switch --flake .#defaultSetup  -b backup;