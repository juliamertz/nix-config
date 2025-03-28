# My system configurations

## Structure
- `hardware` - Hardware specific configurations per machine
- `helpers` - Utility functions put in the global namespace
- `modules` 
- `profiles` - Configurations for nixos/nix-darwin system
    - `base` - Shared files that should be imported for all system profiles
        - `darwin.nix`
        - `nixos.nix`
        - `shared.nix`
    - `homelab`
    - `laptop` - Nix darwin configuration for laptop
    - `workstation` - NixOS configuration for workstation
- `scripts` - Shell scripts to automate some parts of bootstapping NixOS/nix-darin systems
- `secrets` - Per system runtime secrets encrypted with [sops](https://github.com/getsops/sops)

## Bootstrapping a new system

### SSH Keys

Before you try building a nix configuration make sure you've generated a ssh key and derived the sops age key

```sh
KEY=~/.ssh/id_ed25519
# Optionally generate a new ssh key if you don't have one
ssh-keygen -t ed25519 -a 32 -C "Name you@email.com" -f $KEY
# Outputs sops age key to ~/.config/sops/age/keys.txt
./scripts/derive-key $KEY
```

### Get Nix

This step can be skipped for NixOS systems...


### 2. Install Nix

```sh
curl --proto '=https' --tlsv1.2 -sSf -L https://install.determinate.systems/nix | sh -s -- install
```
After installation, open a new terminal session to make the `nix` executable available in your `$PATH`. You'll need this in the steps ahead.

### Rebuilding system

> [!IMPORTANT]
> If you're on a new system make sure to generate a hardware configuration
>
> ```sh
> NAME=myname nixos-generate-config --show-hardware-config > ./hardware/$NAME.nix
> ```
> 
> Then import it for your system configuration in `./flake.nix`
> 
> ```nix
>   {
>     workstation = nixosSystem {
>       ...
>       modules = base ++ [
>         ...
>         ./hardware/myname.nix
>       ];
>     };
>   }
> ```

To build a configuration and switch to it for the first time run the script in `./scripts/rebuild-switch`
passing the desired profile name to it as the first argument like this:

```sh
./scripts/rebuild-switch homelab
```

The avaiable system configurations are:
- NixOS
    - workstation
    - homelab
    - vps
    - work
- Nix Darwin
    - laptop

> [!NOTE]
> Consider setting up your home directory on a fresh system with `./scripts/setup-home`
> This will clone my dotfiles to the home directory and create ~/notes ~/projects etc..

## Dotfiles

All my favourite programs are wrapped and exported from my [dotfiles repo](https://github.com/juliamertz/dotfiles) 
These are also included as a flake input in this repository and avaiable under `dotfiles.pkgs` in the global namespace

```sh
# Open up new shell with all my configured software
nix develop github:juliamertz/dotfiles
```
