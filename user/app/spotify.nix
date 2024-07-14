{ pkgs, ... }:
let 
  spotify_player = pkgs.spotify-player.override {
    withSixel = false;
  };
in {
  home.packages = [ 
    pkgs.spotify
    spotify_player
  ];

  home.file.".config/spotify-player/app.toml".text = /* toml */ ''
    seek_duration_secs = 10
    modal_search = true 
    client_id = "5719b1978d88493c88963fd2378c5292"
    client_port = 8080
    tracks_playback_limit = 50
    playback_format = "{track} • {artists}\n{album}\n{metadata}"
    notify_format = { summary = "{track} • {artists}", body = "{album}" }
    notify_timeout_in_secs = 0
    app_refresh_duration_in_ms = 32
    playback_refresh_duration_in_ms = 0
    page_size_in_rows = 20
    notify_streaming_only = false

    enable_media_control = true
    enable_streaming = "DaemonOnly"
    enable_notify = false
    enable_cover_image_cache = true

    play_icon = "▶"
    pause_icon = "▌▌"
    liked_icon = ""
    playback_window_position = "Bottom"
    cover_img_scale = 1 
    cover_img_length = 9
    cover_img_width = 5
    playback_window_width = 6
    border_type="Rounded"

    default_device = "spotify-player"

    [device]
    name = "spotify-player"
    device_type = "speaker"
    volume = 100
    bitrate = 320
    audio_cache = false
    normalization = false
  '';

  home.file.".config/spotify-player/keymap.toml".text = /* toml */ ''
    [[keymaps]]
    command = "PageSelectNextOrScrollDown"
    key_sequence = "d"

    [[keymaps]]
    command = "PageSelectPreviousOrScrollUp"
    key_sequence = "u"

    [[keymaps]]
    command = "PageSelectNextOrScrollDown"
    key_sequence = "C-d"

    [[keymaps]]
    command = "PageSelectPreviousOrScrollUp"
    key_sequence = "C-u"

    [[keymaps]]
    command = "FocusNextWindow"
    key_sequence = "l"

    [[keymaps]]
    command = "FocusPreviousWindow"
    key_sequence = "h"

    [[actions]]
    action = "GoToArtist"
    key_sequence = "B"

    [[actions]]
    action = "GoToAlbum"
    key_sequence = "A"

    [[actions]]
    action = "ToggleLiked"
    key_sequence = "C-l"
  '';
}
