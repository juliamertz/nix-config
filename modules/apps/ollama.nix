{
  pkgs,
  ...
}:
{
  services.ollama = {
    enable = true;
    user = "ollama";
    group = "ollama";

    package = pkgs.ollama-cuda;
    # this option causes ollama to be re-compiled which takes VERY long
    # acceleration = "cuda";

    home = "/games/ollama";
    models = "/games/ollama/models";
  };
}
