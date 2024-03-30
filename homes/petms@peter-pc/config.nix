{
  "$mod" = "SUPER";
  bind =
    [
      "$mod, Return, exec, foot"
      "$mod, C, exec, chromium"
      ", Print, exec, grimblast copy area"
      "$mod, Q, killactive,"
      "$mod, F, fullscreen,"
      "$mod, Space, togglefloating,"
      "SUPER SHIFT, left, movewindow, l"
      "SUPER SHIFT, right, movewindow, r"
      "SUPER SHIFT, up, movewindow, u"
      "SUPER SHIFT, down, movewindow, d"
      "CTRL ALT, L, exec, swaylock"
    ] ++ (
      # workspaces
      # binds $mod + [shift +] {1..10} to [move to] workspace {1..10}
      builtins.concatLists (builtins.genList (
          x: let
            ws = let
              c = (x + 1) / 10;
            in
              builtins.toString (x + 1 - (c * 10));
          in [
            "$mod, ${ws}, workspace, ${toString (x + 1)}"
            "$mod SHIFT, ${ws}, movetoworkspace, ${toString (x + 1)}"
          ]
        )
        10)
    );
  bindr = [ "SUPER, SUPER_L, exec, pkill fuzzel || fuzzel" ];
  binde = [
      ", XF86AudioRaiseVolume, exec, wpctl set-volume -l 1.5 @DEFAULT_AUDIO_SINK@ 5%+"
      ", XF86AudioLowerVolume, exec, wpctl set-volume -l 1.5 @DEFAULT_AUDIO_SINK@ 5%-"
      ", XF86AudioMute, exec, wpctl set-mute @DEFAULT_AUDIO_SINK@ toggle"
      ", XF86AudioPause, exec, playerctl play-pause"
      ", XF86AudioPlay, exec, playerctl play-pause"
      ", XF86MonBrightnessUp, exec, brillo -A 2 -u 100000 -q"
      ", XF86MonBrightnessDown, exec, brillo -U 2 -u 100000 -q"
    ];
  bindm = [
    "SUPER, mouse:272, movewindow"
    "SUPER, mouse:273, resizewindow"
  ];
  misc = {
    disable_hyprland_logo = true;
    disable_splash_rendering = true;
    vfr = true;
    vrr = 1;
  };
  decoration = {
    rounding = 6;
    shadow_range = 64;
    shadow_ignore_window = true;
    shadow_render_power = 2;
    "col.shadow" = "0x10333333";
    blur.enabled = false;
    blur.xray = true;
    blur.size = 8;
  };
  general = {
    gaps_in = 9;
    gaps_out = 20;
    border_size = 1;
    "col.active_border" = "0xff446270";
    "col.inactive_border" = "0xff334759";
  };
  exec-once = [
      "dbus-update-activation-environment --systemd WAYLAND_DISPLAY XDG_CURRENT_DESKTOP"
      "eww daemon"
      "eww open bar"
      "swaybg -i ~/.wallpaper"
      "hyprctl setcursor 'Numix-Cursor' 24"
    ];
  monitor = [
    "eDP-1,2880x1920@120,1920x0,2,bitdepth,10"
    "DP-3,1920x1080@75,0x0,1"
  ];
  device = [{
    name = "microsoft-surface-045e:09af-touchpad";
    accel_profile = "custom 10 0 9 36 81 144";
    scroll_points = "0.2144477506 0.000 0.026 0.051 0.090 0.128 0.167 0.209 0.267 0.326 0.384 0.443 0.501 0.560 0.619 0.677 0.736 0.794 0.853 0.911 1.032";
    natural_scroll = true;
  }];
  dwindle = {
    no_gaps_when_only = 1;
  };
  animation = [
      "workspaces,1,3,default,slidefade 10%"
      "windows,1,4,default,popin"
      "fade,1,4,default"
    ];
  windowrule = [];
  layerrule = [
    "blur,^(eww-blur)$"
    "ignorezero,^(eww-blur)$"
    "xray 0,^(eww-blur)$"
    "blur,^(eww-blur-full)$"
  ];
}
