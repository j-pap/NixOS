{
  dockApps,
}:
{
  location = "bottom"; # top, bottom, left, right, floating
  alignment = "center"; # left, center, right
  lengthMode = "fit"; # fill, fit, custom
  hiding = "autohide"; # normalpanel, autohide, dodgewindows, windowsgobelow
  opacity = "adaptive"; # adaptive, opaque, translucent
  floating = true;
  height = 50;
  widgets = [
    {
      iconTasks = {
        launchers = dockApps;
        iconsOnly = true;
        appearance = {
          showTooltips = true;
          #highlightWindows = false;
          indicateAudioStreams = true;
          fill = true;
          iconSpacing = "medium"; # small, medium, large
        };
        behavior = {
          grouping = {
            method = "byProgramName"; # none, byProgramName
            clickAction = "cycle"; # cycle, showTooltips, showPresentWindowsEffect, showTextualList
          };
          sortingMethod = "manually"; # none, manually, alphabetically, byDesktop, byActivity, byHorizontalPosition
          minimizeActiveTaskOnClick = false;
          middleClickAction = "newInstance"; # none, close, newInstance, toggleMinimized, toggleGrouping, bringToCurrentDesktop
          wheel = {
            switchBetweenTasks = false;
            ignoreMinimizedTasks = false;
          };
          showTasks = {
            onlyInCurrentDesktop = false;
            onlyInCurrentActivity = false;
            onlyInCurrentScreen = false;
            onlyMinimized = false;
          };
          unhideOnAttentionNeeded = true;
          newTasksAppearOn = "right"; # right, left
        };
      };
    }
  ];
}
