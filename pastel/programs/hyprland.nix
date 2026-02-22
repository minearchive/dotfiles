{ pkgs, ... }:
{
  wayland.windowManager.hyprland = {
    enable = true;
    settings = {
      monitor = [
        "HDMI-A-1,1920x1080@60,0x0,1"
        "DVI-D-1,1280x1024@60,1920x0,1"
        ", preferred, auto, 1"
      ];

      workspace = [
        "1,monitor:DVI-D-1,default:true"
      ];

      env = [
        "XCURSOR_THEME,breeze"
        "GTK_IM_MODULE,fcitx"
        "QT_IM_MODULE,fcitx"
        "XMODIFIERS,@im=fcitx"
        "GLFW_IM_MODULE,fcitx"
        "XCURSOR_THEME,Bibata-Modern-Ice"
        "XCURSOR_SIZE,24"
      ];

      input = {
        kb_layout = "jp";
        repeat_delay = 400;
        repeat_rate = 60;
        force_no_accel = true;
        touchpad = {
          natural_scroll = true;
          disable_while_typing = true;
          clickfinger_behavior = true;
          scroll_factor = 0.6;
        };
        sensitivity = 0.5;
      };

      cursor = {
        no_hardware_cursors = true;
      };

      gestures = {
        workspace_swipe_distance = 700;
        workspace_swipe_cancel_ratio = 0.2;
        workspace_swipe_min_speed_to_force = 5;
        workspace_swipe_direction_lock = true;
        workspace_swipe_direction_lock_threshold = 10;
        workspace_swipe_create_new = true;
      };

      decoration = {
        rounding = 2;
        shadow = {
          enabled = true;
          ignore_window = true;
          range = 20;
          offset = "0 2";
          render_power = 4;
          color = "rgba(0000002A)";
        };
      };

      misc = {
        disable_splash_rendering = true;
        disable_hyprland_logo = true;
      };

      general = {
        gaps_out = "10, 10, 10, 10";
        "col.active_border" = "rgba(3b4a8cff) rgba(3b4a8cff) 45deg";
      };

      ecosystem = {
        no_update_news = true;
      };

      animations = {
        enabled = true;
        bezier = [
          "linear, 0, 0, 1, 1"
          "md3_standard, 0.2, 0, 0, 1"
          "md3_decel, 0.05, 0.7, 0.1, 1"
          "md3_accel, 0.3, 0, 0.8, 0.15"
          "overshot, 0.05, 0.9, 0.1, 1.1"
          "crazyshot, 0.1, 1.5, 0.76, 0.92"
          "hyprnostretch, 0.05, 0.9, 0.1, 1.0"
          "menu_decel, 0.1, 1, 0, 1"
          "menu_accel, 0.38, 0.04, 1, 0.07"
          "easeInOutCirc, 0.85, 0, 0.15, 1"
          "easeOutCirc, 0, 0.55, 0.45, 1"
          "easeOutExpo, 0.16, 1, 0.3, 1"
          "softAcDecel, 0.26, 0.26, 0.15, 1"
          "md2, 0.4, 0, 0.2, 1"
          "vert_menu, 0.25, 0.9, 0.2, 1"
        ];
        animation = [
          "windows, 1, 3, md3_decel, popin 60%"
          "windowsIn, 1, 3, md3_decel, popin 60%"
          "windowsOut, 1, 3, md3_accel, popin 60%"
          "border, 1, 10, default"
          "fade, 1, 3, md3_decel"
          "layersIn, 1, 3, menu_decel, slide"
          "layersOut, 1, 1.6, menu_accel"
          "fadeLayersIn, 1, 2, menu_decel"
          "fadeLayersOut, 1, 0.5, menu_accel"
          "workspaces, 1, 7, menu_decel, slide"
        ];
      };

      gesture = [
        "3, horizontal, workspace"
        "3, swipe, mod: SUPER, resize"
        "4, pinch, fullscreen"
      ];

      bind = [
        "SUPER, T, exec, kitty --session ~/.bashrc"
        "SUPER, F, exec, zen-beta"
        "SUPER, Q, killactive"
        "CTRL+ALT, DEL, exec, hyprctl dispatch exit"
        "SUPER, E, exec, nautilus"
        "SUPER, L, exec, hyprlock"
        "SUPER, R, exec, rofi -show run"
        "SUPER, 1, workspace, 1"
        "SUPER, 2, workspace, 2"
        "SUPER, 3, workspace, 3"
        "SUPER, 4, workspace, 4"
        "SUPER, 5, workspace, 5"
        "SUPER, 6, workspace, 6"
        "SUPER, 7, workspace, 7"
        "SUPER, 8, workspace, 8"
        "SUPER, 9, workspace, 9"
        "SUPER+ALT, 1, exec, sh ~/.config/hypr/script/move_window_to_ws.sh 1 0"
        "SUPER+ALT, 2, exec, sh ~/.config/hypr/script/move_window_to_ws.sh 2 0"
        "SUPER+ALT, 3, exec, sh ~/.config/hypr/script/move_window_to_ws.sh 3 0"
        "SUPER+ALT, 4, exec, sh ~/.config/hypr/script/move_window_to_ws.sh 4 0"
        "SUPER+ALT, 5, exec, sh ~/.config/hypr/script/move_window_to_ws.sh 5 0"
        "SUPER+ALT, 6, exec, sh ~/.config/hypr/script/move_window_to_ws.sh 6 0"
        "SUPER+ALT, 7, exec, sh ~/.config/hypr/script/move_window_to_ws.sh 7 0"
        "SUPER+ALT, 8, exec, sh ~/.config/hypr/script/move_window_to_ws.sh 8 0"
        "SUPER+ALT, 9, exec, sh ~/.config/hypr/script/move_window_to_ws.sh 9 0"
        "SUPER+ALT+SHIFT, 1, exec, sh ~/.config/hypr/script/move_window_to_ws.sh 1 1"
        "SUPER+ALT+SHIFT, 2, exec, sh ~/.config/hypr/script/move_window_to_ws.sh 2 1"
        "SUPER+ALT+SHIFT, 3, exec, sh ~/.config/hypr/script/move_window_to_ws.sh 3 1"
        "SUPER+ALT+SHIFT, 4, exec, sh ~/.config/hypr/script/move_window_to_ws.sh 4 1"
        "SUPER+ALT+SHIFT, 5, exec, sh ~/.config/hypr/script/move_window_to_ws.sh 5 1"
        "SUPER+ALT+SHIFT, 6, exec, sh ~/.config/hypr/script/move_window_to_ws.sh 6 1"
        "SUPER+ALT+SHIFT, 7, exec, sh ~/.config/hypr/script/move_window_to_ws.sh 7 1"
        "SUPER+ALT+SHIFT, 8, exec, sh ~/.config/hypr/script/move_window_to_ws.sh 8 1"
        "SUPER+ALT+SHIFT, 9, exec, sh ~/.config/hypr/script/move_window_to_ws.sh 9 1"
        ", XF86AudioMute, exec, wpctl set-mute @DEFAULT_AUDIO_SINK@ toggle"
        "SUPER+CTRL, Right, workspace, +1"
        "SUPER+CTRL, Left, workspace, -1"
        "SUPER, RIGHT, swapwindow, r"
        "SUPER, LEFT, swapwindow, l"
        "SUPER, DOWN, swapwindow, d"
        "SUPER, UP, swapwindow, u"
        "SUPER, D, togglefloating"
        "SUPER, TAB, hyprexpo:expo, toggle"
        "SUPER+SHIFT+CTRL, T, exec, sh ~/.config/hypr/script/wallpaper_change.sh"
        "SUPER+SHIFT, s, exec, grim -g \"$(slurp)\" - | swappy -f -"
        "SHIFT, Print, exec, grim - | wl-copy && wl-paste > ~/Pictures/screenshots/Screenshot-$(date +%F_%T).png && dunstify \"Screenshot of the whole screen taken\" -t 1000"
        "Super, I, exec, XDG_CURRENT_DESKTOP=gnome gnome-control-center"
        "SUPER, N, exec, hyprpicker -a"
        "SUPER, P, exec, wlogout"
      ];

      binde = [
        ", XF86AudioRaiseVolume, exec, wpctl set-volume -l 1.4 @DEFAULT_AUDIO_SINK@ 5%+"
        ", XF86AudioLowerVolume, exec, wpctl set-volume -l 1.4 @DEFAULT_AUDIO_SINK@ 5%-"
      ];

      bindle = [
        ", XF86MonBrightnessUp, exec, hyprctl hyprsunset gamma +10"
        ", XF86MonBrightnessDown, exec, hyprctl hyprsunset gamma -10"
      ];

      bindm = [
        "SUPER, mouse:272, movewindow"
        "SUPER, mouse:273, resizewindow"
        "ALT, mouse:272, resizewindow"
        "Super, mouse:273, resizewindow"
      ];

      windowrule = [
        "float on, match:title ^(Open File).*$"
        "center on, match:title ^(Open File).*$"
        "float on, match:title ^(Select a File).*$"
        "center on, match:title ^(Select a File).*$"
        "float on, match:title ^(Choose wallpaper).*$"
        "center on, match:title ^(Choose wallpaper).*$"
        "size 60% 65%, match:title ^(Choose wallpaper).*$"
        "float on, match:title ^(Open Folder).*$"
        "center on, match:title ^(Open Folder).*$"
        "float on, match:title ^(Save As).*$"
        "center on, match:title ^(Save As).*$"
        "float on, match:title ^(Library).*$"
        "center on, match:title ^(Library).*$"
        "float on, match:title ^(File Upload).*$"
        "center on, match:title ^(File Upload).*$"
        "float on, match:title ^(.*)(wants to save)$"
        "center on, match:title ^(.*)(wants to save)$"
        "float on, match:title ^(.*)(wants to open)$"
        "center on, match:title ^(.*)(wants to open)$"
        "float on, match:class ^(org.gnome.clocks)$"
        "center on, match:class ^(org.gnome.clocks)$"
        "size 800 500, match:class ^(org.gnome.clocks)$"
        "no_anim on, match:class ^(wlogout)$"
        "suppress_event maximize, match:class .*"
        "stay_focused on, match:class ^(pinentry-)(.*)$"
      ];

      layerrule = [
        "ignore_alpha 0.2, match:namespace mywaybar-topbar"
        "no_anim on, match:namespace rofi"
        "no_anim on, match:namespace logout_dialog"
      ];

      plugin = {
        hyprexpo = {
          columns = 3;
          gap_size = 5;
          bg_col = "rgb(111111)";
          workspace_method = "center current";
          gesture_distance = 300;
        };
      };
    };

    extraConfig = ''
      exec-once = hyprctl plugin load "$HYPR_PLUGIN_DIR/lib/libhyprexpo.so"
      exec-once = swww-daemon
      exec-once = fcitx5
      exec-once = fcitx5-remote -r
      exec-once = fcitx5 -d --replace &
      exec-once = hyprsunset
      exec-once = swww img $(cat ~/.config/wallpaper.info) --transition-type none --transition-duration 0
      exec-once = cd ~/shell && sh /home/minearchive/shell/start.sh
    '';
  };

  xdg.configFile = {
    "hypr/script/move_window_to_ws.sh" = {
      text = ''
        if [ $2 == "0" ]; then
          hyprctl dispatch movetoworkspacesilent $1
        else
          hyprctl dispatch movetoworkspace $1
        fi
      '';
    };

    "hypr/script/wallpaper_change.sh" = {
      text = ''
        #!/usr/bin/env bash

        # Open zenity file selector for image files
        FILE=$(zenity --file-selection --title="Choose wallpaper" --file-filter="Images | *.png *.jpg *.jpeg *.bmp *.webp *.gif *.mp4")

        # Check if a file was selected
        if [ -z "$FILE" ]; then
          echo "No file selected, exiting."
          exit 1
        fi

        # Check if MATUGEN_SCHEME is set, otherwise default to dark

        if [ -z "$MATUGEN_SCHEME" ]; then
          MATUGEN_SCHEME="dark"
        fi

        echo "Using color scheme: $MATUGEN_SCHEME"

        matugen image "$FILE" -c ~/.config/matugen/config.toml --mode "$MATUGEN_SCHEME"

        swww img "$FILE" --transition-type outer --transition-pos 0.857,0.977 --transition-step 90 --transition-fps 60

        echo "$FILE" > ~/.config/wallpaper.info
      '';
    };
  };

  home.packages = with pkgs; [
    rofi
    zenity
    grim
  ];
}
