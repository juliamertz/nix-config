{ blender, ... }:
blender.overrideAttrs {
  cudaSupport = true;
}
