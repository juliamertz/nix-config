{ helpers, pkgs, ... }:
(helpers.wrapPackage {
  name = "ffmpeg";
  package = pkgs.ffmpeg-full;
  # (https://docs.nvidia.com/video-technologies/video-codec-sdk/12.0/ffmpeg-with-nvidia-gpu/index.html#hwaccel-transcode-without-scaling)
  extraFlags = "-hwaccel cuda -hwaccel_output_format cuda";
})
