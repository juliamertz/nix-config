{ pkgs, settings, config, lib, ... }:
{
  home.packages = with pkgs; [ tmux git ];

  home.activation.install-tpm = lib.hm.dag.entryAfter [ "writeBoundary" ] /* sh */ ''
      TARGET_DIR=${config.xdg.configHome}/tmux/plugins/tpm
      REPO=https://github.com/tmux-plugins/tpm

      rm -rf $TARGET_DIR &> /dev/null;
      mkdir -p $TARGET_DIR;
      ${pkgs.git}/bin/git clone --depth=1 --single-branch $REPO $TARGET_DIR;
  '';

  home.file.".tmux.conf".text = /* tmux */ ''
    source-file ~/.config/tmux/tmux.reset.conf

    set -g prefix ^A
    set -g default-shell ${pkgs.fish}/bin/fish

    bind-key -r f run-shell "tmux neww ~/.config/tmux/scripts/sessionizer"
    bind C-s display-popup -h 90% -w 80% -E "spotify_player"

    # Plugins
    set -g @plugin 'tmux-plugins/tpm'
    set -g @plugin 'tmux-plugins/tmux-sensible'
    set -g @plugin 'tmux-plugins/tmux-yank'
    set -g @plugin 'sainnhe/tmux-fzf'
    set -g @plugin 'jorismertz/tmux-rosepine'

    set -g @sessionx-zoxide-mode 'on'

    # Appearance options
    set -g @rosepine_flavour 'moon' 
    set -g @rosepine_window_left_separator ""
    set -g @rosepine_window_right_separator " "
    set -g @rosepine_window_middle_separator " █"
    set -g @rosepine_window_number_position "right"
    set -g @rosepine_window_default_fill "number"
    set -g @rosepine_window_default_text "#W"
    set -g @rosepine_window_current_fill "number"
    set -g @rosepine_window_current_text "#W"
    # set -g @rosepine_status_modules_right "directory host session"
    set -g @rosepine_status_modules_right "host session"
    set -g @rosepine_status_left_separator  " "
    set -g @rosepine_status_right_separator ""
    set -g @rosepine_status_right_separator_inverse "no"
    set -g @rosepine_status_fill "icon"
    set -g @rosepine_status_connect_separator "no"
    set -g @rosepine_directory_text '#(dirs)'
    set -g status-bg default
    set -g status-style bg=default

    run '~/.config/tmux/plugins/tpm/tpm'
  '';

  home.file.".config/tmux/tmux.reset.conf".text = /* tmux */ ''
    set-environment -g TMUX_PLUGIN_MANAGER_PATH '~/.config/tmux/plugins'

    set -g base-index 1
    set -g detach-on-destroy off
    set -g escape-time 0
    set -g history-limit 1000000
    set -g renumber-windows on
    set -g set-clipboard on
    set -g status-position top
    set -g default-terminal "${settings.system.term}"
    set -g pane-active-border-style 'fg=magenta,bg=default'
    set -g pane-border-style 'fg=brightblack,bg=default'

    set-option -g terminal-overrides ',xterm-256color:RGB'
    set-option -g default-terminal "xterm-256color"

    bind ^X lock-server
    bind ^C new-window -c "#{pane_current_path}"
    bind ^D detach
    bind * list-clients
    bind H previous-window
    bind L next-window
    bind r command-prompt "rename-window %%"
    bind R source-file ~/.config/tmux/tmux.conf
    bind ^A last-window
    bind ^W list-windows
    bind w list-windows
    bind z resize-pane -Z
    bind ^L refresh-client
    bind l refresh-client
    bind | split-window
    bind H split-window -v -c "#{pane_current_path}"
    bind v split-window -h -c "#{pane_current_path}"
    bind s choose-session
    bind '"' choose-window
    bind h select-pane -L
    bind j select-pane -D
    bind k select-pane -U
    bind l select-pane -R
    bind -r -T prefix , resize-pane -L 10
    bind -r -T prefix . resize-pane -R 10
    bind -r -T prefix - resize-pane -D 7
    bind -r -T prefix = resize-pane -U 7
    bind : command-prompt
    bind * setw synchronize-panes
    bind P set pane-border-status
    bind c kill-pane
    bind x kill-session

    # Vim bindings
    setw -g mode-keys vi
    bind -T copy-mode-vi v send -X begin-selection
    bind -T copy-mode-vi C-v send -X rectangle-toggle
    bind -T copy-mode-vi y send -X copy-selection-and-cancel
    bind -T copy-mode-vi Escape send -X clear-selection
  '';
}
