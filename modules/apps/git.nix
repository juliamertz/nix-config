{ pkgs, settings, helpers, ... }:
let
  config = {
    init.defaultBranch = "main";
    core.editor = "nvim";
    pull.rebase = true;

    alias = {
      s = "status";
      a = "add";
      c = "commit -m";

      wa = "worktree add";
      wr = "worktree remove";
      wl = "worktree list";
    };

    url = {
      "https://github.com/" = { insteadOf = [ "gh:" "github:" ]; };
      "git@github.com:juliamertz/" = { insteadOf = [ "julia:" ]; };
    };

    user = with settings.user; {
      inherit email;
      name = fullName;
    };
  };

in (if helpers.isLinux then {
  programs.git = {
    enable = true;
    inherit config;
  };
} else {
  home.programs.git = {
    enable = true;
    extraConfig = config;
  };
})
