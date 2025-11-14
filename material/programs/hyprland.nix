{ pkgs, ... }:
{
  xdg.configFile = {
    "hypr/hyprland.conf" = {
      text = ''
        source=~/.config/hypr/hyprland/animation.conf
        source=~/.config/hypr/hyprland/general.conf
        source=~/.config/hypr/hyprland/keybind.conf
        source=~/.config/hypr/hyprland/startup.conf
        source=~/.config/hypr/hyprland/plugins.conf
        source=~/.config/hypr/hyprland/rule.conf
      '';
    };

    "hypr/hyprland/animation.conf" = {
      text = ''
        animations {
          enabled = true
          # Animation curves
          bezier = linear, 0, 0, 1, 1
          bezier = md3_standard, 0.2, 0, 0, 1
          bezier = md3_decel, 0.05, 0.7, 0.1, 1
          bezier = md3_accel, 0.3, 0, 0.8, 0.15
          bezier = overshot, 0.05, 0.9, 0.1, 1.1
          bezier = crazyshot, 0.1, 1.5, 0.76, 0.92
          bezier = hyprnostretch, 0.05, 0.9, 0.1, 1.0
          bezier = menu_decel, 0.1, 1, 0, 1
          bezier = menu_accel, 0.38, 0.04, 1, 0.07
          bezier = easeInOutCirc, 0.85, 0, 0.15, 1
          bezier = easeOutCirc, 0, 0.55, 0.45, 1
          bezier = easeOutExpo, 0.16, 1, 0.3, 1
          bezier = softAcDecel, 0.26, 0.26, 0.15, 1
          bezier = md2, 0.4, 0, 0.2, 1 # use with .2s duration
          bezier = vert_menu, 0.25, 0.9, 0.2, 1
          # Animation configs
          animation = windows, 1, 3, md3_decel, popin 60%
          animation = windowsIn, 1, 3, md3_decel, popin 60%
          animation = windowsOut, 1, 3, md3_accel, popin 60%
          animation = border, 1, 10, default
          animation = fade, 1, 3, md3_decel
          animation = layersIn, 1, 3, menu_decel, slide
          animation = layersOut, 1, 1.6, menu_accel
          animation = fadeLayersIn, 1, 2, menu_decel
          animation = fadeLayersOut, 1, 0.5, menu_accel
          animation = workspaces, 1, 7, menu_decel, slide
        }

      '';
    };

    "hypr/hyprland/general.conf" = {
      text = ''
                monitor = eDP-1, 1920x1200@60, 0x0, 1

                env=XCURSOR_THEME,breeze

                env=GTK_IM_MODULE=fcitx
                env=QT_IM_MODULE=fcitx
                env=XMODIFIERS=@im=fcitx
                env=GLFW_IM_MODULE=fcitx

                input {
                  kb_layout = jp
                  repeat_delay = 400
                  repeat_rate = 60

                  touchpad {
                    natural_scroll = yes
                    disable_while_typing = true
                    clickfinger_behavior = true
                    scroll_factor = 0.6
                  }

                  sensitivity = 0

                }

        	cursor {
        	  no_hardware_cursors = true
        	}

                gestures {
                  #workspace_swipe = true
                  workspace_swipe_distance = 700
                  #workspace_swipe_fingers = 3
                  workspace_swipe_cancel_ratio = 0.2
                  workspace_swipe_min_speed_to_force = 5
                  workspace_swipe_direction_lock = true
                  workspace_swipe_direction_lock_threshold = 10
                  workspace_swipe_create_new = true
                }

                decoration {
                  rounding = 15

                  shadow {
                    enabled = true
                    ignore_window = true
                    range = 20
                    offset = 0 2
                    render_power = 4
                    color = rgba(0000002A)
                  }
                }

                misc {
                  disable_splash_rendering = true
                  disable_hyprland_logo = true
                }

                general {
                  gaps_out = 10, 10, 10, 10
                  col.active_border = rgba(3b4a8cff) rgba(3b4a8cff) 45deg
                }

                ecosystem {
                  no_update_news = true
                }
      '';
    };

    "hypr/hyprland/keybind.conf" = {
      text = ''
        gesture = 3, horizontal, workspace
        gesture = 3, swipe, mod: SUPER, resize
        gesture = 4, pinch, fullscreen

        # hyprexpo-gesture = 3, up, expo, on
        # hyprexpo-gesture = 3, down, expo, off

        bind = SUPER, T, exec, kitty --session ~/.bashrc
        bind = SUPER, F, exec, zen
        bind = SUPER, Q, killactive
        bind = SUPER, M, exec, hyprctl dispatch exit
        bind = SUPER, E, exec, nautilus
        bind = SUPER, L, exec, hyprlock

        bind = SUPER, R, exec, rofi -show run

        bindm = SUPER, mouse:272, movewindow
        bindm = SUPER, mouse:273, resizewindow
        bindm = ALT, mouse:272, resizewindow

        # Win + num to switch workspace
        bind = SUPER, 1, workspace, 1
        bind = SUPER, 2, workspace, 2
        bind = SUPER, 3, workspace, 3
        bind = SUPER, 4, workspace, 4
        bind = SUPER, 5, workspace, 5
        bind = SUPER, 6, workspace, 6
        bind = SUPER, 7, workspace, 7
        bind = SUPER, 8, workspace, 8
        bind = SUPER, 9, workspace, 9

        #Win + Alt + num to move window silent to another workspace
        bind = SUPER+ALT, 1, exec, sh ~/.config/hypr/script/move_window_to_ws.sh 1 0
        bind = SUPER+ALT, 2, exec, sh ~/.config/hypr/script/move_window_to_ws.sh 2 0
        bind = SUPER+ALT, 3, exec, sh ~/.config/hypr/script/move_window_to_ws.sh 3 0
        bind = SUPER+ALT, 4, exec, sh ~/.config/hypr/script/move_window_to_ws.sh 4 0
        bind = SUPER+ALT, 5, exec, sh ~/.config/hypr/script/move_window_to_ws.sh 5 0
        bind = SUPER+ALT, 6, exec, sh ~/.config/hypr/script/move_window_to_ws.sh 6 0
        bind = SUPER+ALT, 7, exec, sh ~/.config/hypr/script/move_window_to_ws.sh 7 0
        bind = SUPER+ALT, 8, exec, sh ~/.config/hypr/script/move_window_to_ws.sh 8 0
        bind = SUPER+ALT, 9, exec, sh ~/.config/hypr/script/move_window_to_ws.sh 9 0

        #Win + Alt + Shift + num to move window to another workspace
        bind = SUPER+ALT+SHIFT, 1, exec, sh ~/.config/hypr/script/move_window_to_ws.sh 1 1
        bind = SUPER+ALT+SHIFT, 2, exec, sh ~/.config/hypr/script/move_window_to_ws.sh 2 1
        bind = SUPER+ALT+SHIFT, 3, exec, sh ~/.config/hypr/script/move_window_to_ws.sh 3 1
        bind = SUPER+ALT+SHIFT, 4, exec, sh ~/.config/hypr/script/move_window_to_ws.sh 4 1
        bind = SUPER+ALT+SHIFT, 5, exec, sh ~/.config/hypr/script/move_window_to_ws.sh 5 1
        bind = SUPER+ALT+SHIFT, 6, exec, sh ~/.config/hypr/script/move_window_to_ws.sh 6 1
        bind = SUPER+ALT+SHIFT, 7, exec, sh ~/.config/hypr/script/move_window_to_ws.sh 7 1
        bind = SUPER+ALT+SHIFT, 8, exec, sh ~/.config/hypr/script/move_window_to_ws.sh 8 1
        bind = SUPER+ALT+SHIFT, 9, exec, sh ~/.config/hypr/script/move_window_to_ws.sh 9 1

        binde =, XF86AudioRaiseVolume, exec, wpctl set-volume -l 1.4 @DEFAULT_AUDIO_SINK@ 5%+
        binde =, XF86AudioLowerVolume, exec, wpctl set-volume -l 1.4 @DEFAULT_AUDIO_SINK@ 5%-
        bind =, XF86AudioMute, exec, wpctl set-mute @DEFAULT_AUDIO_SINK@ toggle

        bindle=, XF86MonBrightnessUp, exec, hyprctl hyprsunset gamma +10
        bindle=, XF86MonBrightnessDown, exec, hyprctl hyprsunset gamma -10

        bindm = Super, mouse:273, resizewindow # Resize

        bind = SUPER+CTRL, Right, workspace, +1
        bind = SUPER+CTRL, Left, workspace, -1

        bind = SUPER, RIGHT, swapwindow, r
        bind = SUPER, LEFT, swapwindow, l
        bind = SUPER, DOWN, swapwindow, d
        bind = SUPER, UP, swapwindow, u

        bind = SUPER, D, togglefloating
        # bind = SUPER, D, resizeactive, exact 1000 700

        bind = SUPER, TAB, hyprexpo:expo, toggle

        bind = SUPER+SHIFT+CTRL, T, exec, sh ~/.config/hypr/script/wallpaper_change.sh

        bind = SUPER+SHIFT, s, exec, grim -g "$(slurp)" - | swappy -f -
        bind = SHIFT, Print, exec, grim - | wl-copy && wl-paste > ~/Pictures/screenshots/Screenshot-$(date +%F_%T).png && dunstify "Screenshot of the whole screen taken" -t 1000
        bind = Super, I, exec, XDG_CURRENT_DESKTOP=gnome gnome-control-center
        bind = SUPER, N, exec, hyprpicker -a
        bind = SUPER, P, exec, wlogout
      '';
    };

    "hypr/hyprland/startup.conf" = {
      text = ''
        exec-once = hyprctl plugin load "$HYPR_PLUGIN_DIR/lib/libhyprexpo.so"

        exec-once = swww-daemon
        exec-once = fcitx5
        exec-once = fcitx5-remote -r
        exec-once = fcitx5 -d --replace &
        exec-once = hyprsunset
        exec-once = quickshell -p ~/.local/share/qs-bar/
      '';
    };

    "hypr/hyprland/rule.conf" = {
      text = ''
        layerrule = blur, gtk-layer-shell

        # Some of config are from end-4 dotfile

        layerrule = blur, session[0-9]*
        layerrule = blur, bar[0-9]*
        layerrule = ignorealpha 0.6, bar[0-9]*
        layerrule = blur, barcorner.*
        layerrule = ignorealpha 0.6, barcorner.*
        layerrule = blur, dock[0-9]*
        layerrule = ignorealpha 0.6, dock[0-9]*
        layerrule = blur, indicator.*
        layerrule = ignorealpha 0.6, indicator.*
        layerrule = blur, overview[0-9]*
        layerrule = ignorealpha 0.6, overview[0-9]*
        layerrule = blur, cheatsheet[0-9]*
        layerrule = ignorealpha 0.6, cheatsheet[0-9]*
        layerrule = blur, sideright[0-9]*
        layerrule = ignorealpha 0.6, sideright[0-9]*
        layerrule = blur, sideleft[0-9]*
        layerrule = ignorealpha 0.6, sideleft[0-9]*
        layerrule = blur, indicator.*
        layerrule = ignorealpha 0.6, indicator.*
        layerrule = blur, osk[0-9]*
        layerrule = ignorealpha 0.6, osk[0-9]*
        layerrule = noanim, hyprpicker

        windowrulev2 = center, title:^(Open File)(.*)$
        windowrulev2 = float, title:^(Open File)(.*)$
        windowrulev2 = center, title:^(Select a File)(.*)$
        windowrulev2 = float, title:^(Select a File)(.*)$
        windowrulev2 = center, title:^(Choose wallpaper)(.*)$
        windowrulev2 = float, title:^(Choose wallpaper)(.*)$
        windowrulev2 = size 60% 65%, title:^(Choose wallpaper)(.*)$
        windowrulev2 = center, title:^(Open Folder)(.*)$
        windowrulev2 = float, title:^(Open Folder)(.*)$
        windowrulev2 = center, title:^(Save As)(.*)$
        windowrulev2 = float, title:^(Save As)(.*)$
        windowrulev2 = center, title:^(Library)(.*)$
        windowrulev2 = float, title:^(Library)(.*)$
        windowrulev2 = center, title:^(File Upload)(.*)$
        windowrulev2 = float, title:^(File Upload)(.*)$
        windowrulev2 = center, title:^(.*)(wants to save)$
        windowrulev2 = float, title:^(.*)(wants to save)$
        windowrulev2 = center, title:^(.*)(wants to open)$
        windowrulev2 = float, title:^(.*)(wants to open)$

        windowrulev2 = center, class:org.gnome.clocks
        windowrulev2 = float, class:org.gnome.clocks
        windowrulev2 = size 800 500, class:org.gnome.clocks

        windowrulev2 = noanim, class:^(wlogout)$
      '';
    };

    "hypr/hyprland/plugins.conf" = {
      text = ''
        plugin {
            hyprexpo {
                columns = 3
                gap_size = 5
                bg_col = rgb(111111)
                workspace_method = center current # [center/first] [workspace] e.g. first 1 or center m+1

                gesture_distance = 300 # how far is the "max" for the gesture
            }
        }
      '';
    };

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
