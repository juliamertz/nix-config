# Switching to this configuration
```bash
sudo nixos-rebuild switch --flake .#workstation
```

# Switching to this home configuration
```bash
home-manager switch --flake .#julia
```

# Update & switch
```bash
nix flake update && sudo nixos-rebuild switch --flake .#workstation
```
