{ pkgs, configPath, inputs, settings, ... }: 
let
  wrapPackage = pkgs.callPackage ./wrap.nix { inherit pkgs; };
  setXdgConfigHome = "--set XDG_CONFIG_HOME '${configPath}'";
in {
  lazygit = wrapPackage {
    name = "lazygit";
    package = pkgs.lazygit;
    extraFlags = "--use-config-file ${configPath}/lazygit/config.yml";
    dependencies = with pkgs; [ delta ];
  };
  wezterm = wrapPackage {
    name = "wezterm";
    package = inputs.wezterm.packages.${settings.system.platform}.default;
    extraFlags = "--config-file ${configPath}/wezterm/wezterm.lua";
    extraArgs = setXdgConfigHome;
  };
  nvim = wrapPackage {
    name = "nvim";
    package = pkgs.neovim;
    dependencies = with pkgs; [ ripgrep ];
    extraFlags = "-u ${configPath}/nvim/init.lua";
    extraArgs = setXdgConfigHome;
    extraCommands = /*sh*/ ''
      ln -sf $out/bin/nvim $out/bin/vim
    '';
  };
  kitty = wrapPackage {
    name = "kitty";
    package = pkgs.kitty;
    extraFlags = "--config ${configPath}/kitty/kitty.conf";
  };
  tmux = wrapPackage {
    name = "tmux";
    package = pkgs.tmux;
    extraArgs = setXdgConfigHome;
    extraFlags = "-f ${configPath}/tmux/tmux.conf";
  };
  spotify-player = let
    basePkg =  pkgs.spotify-player.override { withSixel = false; };
    customPkg = basePkg.overrideAttrs (oldAttrs:  {
      name = "spotify_player";
      src = pkgs.fetchFromGitHub {
        owner = "juliamertz";
        repo = "spotify-player";
        rev = "d68c80cf7d6711e611ba3e58e83679fbd44601ac";
        sha256 = "sha256-NC2WfwFiJGFqojCQJ9WPblyDU2K+pF7ahkLl/gQ8x7Y=";
      };
      cargoHash = "sha256-R9N/+29YNWlNnl2+q/MMUZ/MbfFL538z5DLBZxDeaUM=";
      cargoDeps = oldAttrs.cargoDeps.overrideAttrs (pkgs.lib.const {
        name = "${customPkg.name}-vendor.tar.gz";
        src = customPkg.src;
        outputHash = customPkg.cargoHash;
      });
    });
  in wrapPackage {
    name = "spotify_player";
    package = customPkg;
    extraFlags = "--config-folder ${configPath}/spotify-player";
  };
  fish = wrapPackage {
    name = "fish";
    package = pkgs.fish;
    extraArgs = setXdgConfigHome;
    dependencies = with pkgs; [ bat jq ];
  };
  # hyprland = wrapPackage {
  #   name = "Hyprland";
  #   package = pkgs.hyprland;
  #   extraArgs = setXdgConfigHome;
  #   dependencies = with pkgs; [ nvidia-vaapi-driver swww ];
  # };
  awesome =  wrapPackage {
    name = "awesome";
    package = pkgs.awesome;
    extraArgs = setXdgConfigHome;
    dependencies = with pkgs; [];
  };
}

# tmux install step
# TARGET_DIR=${settings.user.home}/.config/tmux/plugins/tpm
# REPO=https://github.com/tmux-plugins/tpm
# 
# if [ ! -e "$TARGET_DIR" ]; then
#   mkdir -p $TARGET_DIR;
#   ${pkgs.git}/bin/git clone --depth=1 --single-branch $REPO $TARGET_DIR;
# fi
# nix-shell -p tmux git --run "$TARGET_DIR/bin/install_plugins"
