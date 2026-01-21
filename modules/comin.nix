{inputs, ...}: {
  imports = [
    inputs.comin.nixosModules.comin
  ];

  config = {
    services.comin = {
      enable = true;
      remotes = [
        {
          name = "origin";
          url = "https://github.com/juliamertz/nix-config.git";
          branches.main.name = "main";
        }
      ];
    };
  };
}
