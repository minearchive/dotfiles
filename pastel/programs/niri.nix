{ pkgs, ... }:
{
  xdg.configFile."niri/config.kdl".text = ''
    input {
        keyboard {
            xkb {
                layout "jp"
            }
            repeat-delay 400
            repeat-rate 60
        }

        mouse {
            accel-profile "flat"
            accel-speed 0.5
        }

        touchpad {
            natural-scroll
            tap
            dwt
            accel-speed 0.3
        }

        focus-follows-mouse max-scroll-amount="0%"
    }

    hotkey-overlay {
    	skip-at-startup
    }

    output "HDMI-A-1" {
        mode "1920x1080@60"
        position x=0 y=0
        scale 1.0
        // mirror "eDP-1"
    }

    output "DVI-D-1" {
        mode "1280x1024@60"
        position x=1920 y=0
        scale 1.0
    }

    output "eDP-1" {
        mode "1920x1200@60"
        position x=0 y=0
        scale 1.0
    }

    layout {
        gaps 10

        focus-ring {
            width 1
        }

        border {
            width 0
            active-color "#3b4a8cff"
            inactive-color "#33333355"
        }

        background-color "transparent"
    }

    cursor {
        xcursor-theme "Bibata-Modern-Ice"
        xcursor-size 24
    }

    environment {
        GTK_IM_MODULE "fcitx"
        QT_IM_MODULE "fcitx"
        XMODIFIERS "@im=fcitx"
        GLFW_IM_MODULE "fcitx"
        XCURSOR_THEME "Bibata-Modern-Ice"
        XCURSOR_SIZE "24"
        MATUGEN_SCHEME "dark"
        XDG_CURRENT_DESKTOP "niri"
        XDG_SESSION_TYPE "wayland"
        XDG_SESSION_DESKTOP "niri"
    }

    spawn-at-startup "swww-daemon"
    spawn-at-startup "sh" "-c" "fcitx5 -d --replace"
    spawn-at-startup "sh" "-c" "swww img $(cat ~/.config/wallpaper.info) --transition-type none --transition-duration 0"
    spawn-at-startup "sh" "-c" "cd ~/shell && quickshell -p shell.qml"

    animations {
        window-movement {
            duration-ms 300
            curve "cubic-bezier" 0.13 0.99 0.29 1.1
        }
    }

    prefer-no-csd

    binds {
        Mod+T { spawn "kitty"; }
        Mod+F { spawn "zen-beta"; }
        Mod+Q { close-window; }
        Ctrl+Alt+Delete { quit skip-confirmation=true; }
        Mod+E { spawn "nautilus"; }
        Mod+L { spawn "hyprlock"; }
        Mod+R { spawn "rofi" "-show" "run"; }
        Mod+D { toggle-window-floating; }
        Mod+G { maximize-column; }
        Mod+B { set-column-width "80%"; }
        Mod+P { spawn "wlogout"; }
        Mod+I { spawn "sh" "-c" "XDG_CURRENT_DESKTOP=gnome gnome-control-center"; }
        Mod+N { spawn "hyprpicker" "-a"; }
        Mod+Shift+S { spawn "sh" "-c" "grim -g \"$(slurp)\" - | wl-copy"; }
        Shift+Print { spawn "sh" "-c" "grim - | wl-copy && wl-paste > ~/Pictures/screenshots/Screenshot-$(date +%F_%T).png && dunstify \"Screenshot taken\" -t 1000"; }

        Mod+1 { focus-workspace 1; }
        Mod+2 { focus-workspace 2; }
        Mod+3 { focus-workspace 3; }
        Mod+4 { focus-workspace 4; }
        Mod+5 { focus-workspace 5; }
        Mod+6 { focus-workspace 6; }
        Mod+7 { focus-workspace 7; }
        Mod+8 { focus-workspace 8; }
        Mod+9 { focus-workspace 9; }

        // move window to workspace (stay on current workspace)
        Mod+Alt+1 { move-column-to-workspace 1; }
        Mod+Alt+2 { move-column-to-workspace 2; }
        Mod+Alt+3 { move-column-to-workspace 3; }
        Mod+Alt+4 { move-column-to-workspace 4; }
        Mod+Alt+5 { move-column-to-workspace 5; }
        Mod+Alt+6 { move-column-to-workspace 6; }
        Mod+Alt+7 { move-column-to-workspace 7; }
        Mod+Alt+8 { move-column-to-workspace 8; }
        Mod+Alt+9 { move-column-to-workspace 9; }

        // move window to workspace and follow
        Mod+Alt+Shift+1 { spawn "sh" "-c" "niri msg action move-column-to-workspace 1 && niri msg action focus-workspace 1"; }
        Mod+Alt+Shift+2 { spawn "sh" "-c" "niri msg action move-column-to-workspace 2 && niri msg action focus-workspace 2"; }
        Mod+Alt+Shift+3 { spawn "sh" "-c" "niri msg action move-column-to-workspace 3 && niri msg action focus-workspace 3"; }
        Mod+Alt+Shift+4 { spawn "sh" "-c" "niri msg action move-column-to-workspace 4 && niri msg action focus-workspace 4"; }
        Mod+Alt+Shift+5 { spawn "sh" "-c" "niri msg action move-column-to-workspace 5 && niri msg action focus-workspace 5"; }
        Mod+Alt+Shift+6 { spawn "sh" "-c" "niri msg action move-column-to-workspace 6 && niri msg action focus-workspace 6"; }
        Mod+Alt+Shift+7 { spawn "sh" "-c" "niri msg action move-column-to-workspace 7 && niri msg action focus-workspace 7"; }
        Mod+Alt+Shift+8 { spawn "sh" "-c" "niri msg action move-column-to-workspace 8 && niri msg action focus-workspace 8"; }
        Mod+Alt+Shift+9 { spawn "sh" "-c" "niri msg action move-column-to-workspace 9 && niri msg action focus-workspace 9"; }

        Mod+Right { focus-column-right; }
        Mod+Left { focus-column-left; }
        Mod+Down { focus-workspace-down; }
        Mod+Up { focus-workspace-up; }

        Mod+Shift+Right { move-column-right; }
        Mod+Shift+Left { move-column-left; }
        Mod+Shift+Down { move-window-down; }
        Mod+Shift+Up { move-window-up; }

        Mod+Tab repeat=false { toggle-overview; }

        Mod+Shift+Ctrl+T { spawn "sh" "/home/minearchive/.config/niri/wallpaper_change.sh"; }

        XF86AudioMute { spawn "wpctl" "set-mute" "@DEFAULT_AUDIO_SINK@" "toggle"; }
        XF86AudioRaiseVolume allow-when-locked=true { spawn "wpctl" "set-volume" "-l" "1.4" "@DEFAULT_AUDIO_SINK@" "5%+"; }
        XF86AudioLowerVolume allow-when-locked=true { spawn "wpctl" "set-volume" "-l" "1.4" "@DEFAULT_AUDIO_SINK@" "5%-"; }
        XF86MonBrightnessUp allow-when-locked=true { spawn "brightnessctl" "set" "+5%"; }
        XF86MonBrightnessDown allow-when-locked=true { spawn "brightnessctl" "set" "5%-"; }
    }

    window-rule {
        match title=r#"^(Open File)"#
        open-floating true
    }

    window-rule {
        match title=r#"^(Select a File)"#
        open-floating true
    }

    window-rule {
        match title=r#"^(Choose wallpaper)"#
        open-floating true
    }

    window-rule {
        match title=r#"^(Open Folder)"#
        open-floating true
    }

    window-rule {
        match title=r#"^(Save As)"#
        open-floating true
    }

    window-rule {
        match title=r#"^(Library)"#
        open-floating true
    }

    window-rule {
        match title=r#"^(File Upload)"#
        open-floating true
    }

    window-rule {
        match title=r#"(wants to save)$"#
        open-floating true
    }

    window-rule {
        match title=r#"(wants to open)$"#
        open-floating true
    }

    window-rule {
        match app-id=r#"^org\.gnome\.clocks$"#
        open-floating true
        default-column-width { fixed 800; }
    }

    window-rule {
        match app-id=r#"^pinentry-"#
        open-floating true
    }
  '';

  home.packages = with pkgs; [
    rofi
    zenity
    grim
    slurp
    hyprpicker
    brightnessctl
  ];

  xdg.configFile."niri/wallpaper_change.sh" = {
    executable = true;
    text = ''
      #!/usr/bin/env bash

      FILE=$(zenity --file-selection --title="Choose wallpaper" --file-filter="Images | *.png *.jpg *.jpeg *.bmp *.webp *.gif *.mp4")

      if [ -z "$FILE" ]; then
        echo "No file selected, exiting."
        exit 1
      fi

      echo "Using color scheme: $MATUGEN_SCHEME"

      matugen image "$FILE" -c ~/.config/matugen/config.toml --mode "$MATUGEN_SCHEME"

      swww img "$FILE" --transition-type outer --transition-pos 0.857,0.977 --transition-step 90 --transition-fps 60

      echo "$FILE" > ~/.config/wallpaper.info
    '';
  };

  xdg.configFile."niri/maximize_or_eighty.sh" = {
    executable = true;
    text = ''
      #!/usr/bin/env bash
      #
      # Maximizes or resizes the active window to 80% of the screen width
      #

      IS_MAXIMIZED=$(niri window get-property )
    '';
  };
}
