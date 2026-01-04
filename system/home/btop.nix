{
  pkgs,
  osConfig,
  ...
}:
let
  flk = osConfig.flake;
in
{
  programs.btop = {
    enable = true;
    package =
      if (flk.hw.amdgpu.enable) then
        (pkgs.btop.override { rocmSupport = true; })
      else if (flk.hw.nvidia.enable) then
        (pkgs.btop.override { cudaSupport = true; })
      else
        pkgs.btop;
    settings = {
      clock_format = "[/host] %X";
      proc_filter_kernel = true;
      proc_left = true;
      proc_sorting = "cpu lazy";
      vim_keys = true;
    };
  };
}
