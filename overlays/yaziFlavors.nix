final: prev: {
  yaziFlavors = {
    catppuccin-frappe = prev.callPackage ../pkgs/yaziFlavors/catppuccin-frappe.nix { };
    catppuccin-mocha = prev.callPackage ../pkgs/yaziFlavors/catppuccin-mocha.nix { };
  };
}
