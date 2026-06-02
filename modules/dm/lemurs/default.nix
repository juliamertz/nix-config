{lib}: {
  services.displayManager.lemurs = {
    enable = true;
    settings = lib.importTOML ./config.toml;
  };
}
