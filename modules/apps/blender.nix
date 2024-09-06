{ pkgs }:
{
  nixpkgs.config.packageOverrides = self: rec {
    blender = self.blender.override { cudaSupport = true; };
  };

  environment.systemPackages = with pkgs; [ blender ];
}
