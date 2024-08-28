{ settings, ... }: let
  inherit (settings) user;
in{
  home.programs.git = {
    enable = true;
    userName = user.fullName;
    userEmail = user.email;
  };

  # programs.git = {
  #   enable = true;
  #   config = {
  #     user = {
  #       name = settings.user.fullName;
  #       inherit (settings.user) email;
  #     };
  #     init.defaultBranch = "main";
  #     core.editor = settings.user.editor;
  #     pull.rebase = true;
  #     url = {
  #       "https://github.com/" = { insteadOf = [ "gh:" "github:" ]; };
  #       "git@github.com:juliamertz/" = { insteadOf = [ "julia:" ]; };
  #     };
  #     alias = {
  #       s = "status";
  #       a = "add";
  #       c = "commit -m";
  #
  #       wa = "worktree add";
  #       wr = "worktree remove";
  #       wl = "worktree list";
  #     };
  #   };
  #
  # };

}
