{ helpers, pkgs, ... }:
(helpers.wrapPackage {
  name = "ffmpeg";
  package = pkgs.ffmpeg-full;
  extraFlags =
    "-hwaccel cuda -hwaccel_output_format cuda"; # (https://docs.nvidia.com/video-technologies/video-codec-sdk/12.0/ffmpeg-with-nvidia-gpu/index.html#hwaccel-transcode-without-scaling)
})

