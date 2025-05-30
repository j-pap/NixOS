{
  myUser,
  ...
}: {
  home-manager.users.${myUser} = {
    programs.zathura = {
      enable = true;
      mappings = { };
    };

    stylix.targets.zathura.enable = true;
  };
}
