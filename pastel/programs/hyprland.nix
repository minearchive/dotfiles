{ pkgs, ... }:
{
  wayland.windowManager.hyprland = {
    enable = true;
    configType = "lua";
    systemd.enable = false;
    extraConfig = ''
      -- Monitors
      hl.monitor({ output = "HDMI-A-1", mode = "1920x1080@60", position = "0x0",    scale = 1, mirror = "eDP-1" })
      hl.monitor({ output = "DVI-D-1",  mode = "1280x1024@60",  position = "1920x0", scale = 1 })
      hl.monitor({ output = "",          mode = "preferred",     position = "auto",   scale = 1 })

      -- Workspace rules
      hl.workspace_rule({ workspace = 1, monitor = "DVI-D-1", default = true })

      -- Environment
      hl.env("GTK_IM_MODULE",       "fcitx")
      hl.env("QT_IM_MODULE",        "fcitx")
      hl.env("XMODIFIERS",          "@im=fcitx")
      hl.env("GLFW_IM_MODULE",      "fcitx")
      hl.env("XCURSOR_THEME",       "Bibata-Modern-Ice")
      hl.env("XCURSOR_SIZE",        "24")
      hl.env("MATUGEN_SCHEME",      "dark")
      hl.env("XDG_CURRENT_DESKTOP", "Hyprland")
      hl.env("XDG_SESSION_TYPE",    "wayland")
      hl.env("XDG_SESSION_DESKTOP", "Hyprland")

      -- Config
      hl.config({
        general = {
          gaps_out = 10,
          col = {
            active_border = { colors = { "rgba(3b4a8cff)", "rgba(3b4a8cff)" }, angle = 45 },
          },
        },
        decoration = {
          rounding = 2,
          shadow = {
            enabled      = true,
            range        = 20,
            offset       = "0 2",
            render_power = 4,
            color        = "rgba(0000002A)",
          },
        },
        misc = {
          disable_splash_rendering = true,
          disable_hyprland_logo    = true,
        },
        input = {
          kb_layout      = "jp",
          repeat_delay   = 400,
          repeat_rate    = 60,
          force_no_accel = true,
          accel_profile  = "flat",
          sensitivity    = -0.3,
          touchpad = {
            natural_scroll       = true,
            disable_while_typing = true,
            clickfinger_behavior = true,
            scroll_factor        = 0.6,
          },
        },
        cursor = {
          no_hardware_cursors = true,
        },
        gestures = {
          workspace_swipe_distance              = 700,
          workspace_swipe_cancel_ratio          = 0.2,
          workspace_swipe_min_speed_to_force    = 5,
          workspace_swipe_direction_lock        = true,
          workspace_swipe_direction_lock_threshold = 10,
          workspace_swipe_create_new            = true,
        },
        ecosystem = {
          no_update_news = true,
        },
        animations = {
          enabled = true,
        },
      })

      -- Curves
      hl.curve("linear",              { type = "bezier", points = { {0, 0},       {1, 1}       } })
      hl.curve("md3_standard",        { type = "bezier", points = { {0.2, 0},     {0, 1}       } })
      hl.curve("md3_decel",           { type = "bezier", points = { {0.05, 0.7},  {0.1, 1}     } })
      hl.curve("md3_accel",           { type = "bezier", points = { {0.3, 0},     {0.8, 0.15}  } })
      hl.curve("overshot",            { type = "bezier", points = { {0.05, 0.9},  {0.1, 1.1}   } })
      hl.curve("crazyshot",           { type = "bezier", points = { {0.1, 1.5},   {0.76, 0.92} } })
      hl.curve("hyprnostretch",       { type = "bezier", points = { {0.05, 0.9},  {0.1, 1.0}   } })
      hl.curve("menu_decel",          { type = "bezier", points = { {0.1, 1},     {0, 1}       } })
      hl.curve("menu_accel",          { type = "bezier", points = { {0.38, 0.04}, {1, 0.07}    } })
      hl.curve("easeInOutCirc",       { type = "bezier", points = { {0.85, 0},    {0.15, 1}    } })
      hl.curve("easeOutCirc",         { type = "bezier", points = { {0, 0.55},    {0.45, 1}    } })
      hl.curve("easeOutExpo",         { type = "bezier", points = { {0.16, 1},    {0.3, 1}     } })
      hl.curve("softAcDecel",         { type = "bezier", points = { {0.26, 0.26}, {0.15, 1}    } })
      hl.curve("md2",                 { type = "bezier", points = { {0.4, 0},     {0.2, 1}     } })
      hl.curve("vert_menu",           { type = "bezier", points = { {0.25, 0.9},  {0.2, 1}     } })
      hl.curve("buttery",             { type = "bezier", points = { {0.13, 0.99}, {0.29, 1.1}  } })
      hl.curve("appleSmooth",         { type = "bezier", points = { {0.16, 1},    {0.3, 1}     } })
      hl.curve("workspaceGlideQuiet", { type = "bezier", points = { {0.2, 1},     {0.2, 1}     } })

      -- Animations
      hl.animation({ leaf = "windows",       enabled = true, speed = 5,   bezier = "md3_decel",  style = "popin 85%" })
      hl.animation({ leaf = "windowsIn",     enabled = true, speed = 4,   bezier = "md3_decel",  style = "popin 85%" })
      hl.animation({ leaf = "windowsOut",    enabled = true, speed = 4,   bezier = "md3_accel",  style = "popin 85%" })
      -- hl.animation({ leaf = "windowsMove",   enabled = true, speed = 4,   bezier = "buttery"                      })
      hl.animation({ leaf = "border",        enabled = true, speed = 10,  bezier = "default"                         })
      hl.animation({ leaf = "fade",          enabled = true, speed = 3,   bezier = "appleSmooth"                     })
      hl.animation({ leaf = "layersIn",      enabled = true, speed = 3,   bezier = "menu_decel", style = "slide"     })
      hl.animation({ leaf = "layersOut",     enabled = true, speed = 1.6, bezier = "menu_accel"                      })
      hl.animation({ leaf = "fadeLayersIn",  enabled = true, speed = 2,   bezier = "menu_decel"                      })
      hl.animation({ leaf = "fadeLayersOut", enabled = true, speed = 0.5, bezier = "menu_accel"                      })
      hl.animation({ leaf = "workspaces",    enabled = true, speed = 7,   bezier = "menu_decel", style = "slide"     })

      -- Touch gestures
      hl.gesture({ fingers = 3, direction = "horizontal", action = "workspace" })

      -- Keybinds
      hl.bind("SUPER + T",        hl.dsp.exec_cmd("kitty"))
      hl.bind("SUPER + F",        hl.dsp.exec_cmd("zen-beta"))
      hl.bind("SUPER + Q",        hl.dsp.window.close())
      -- hl.bind("CTRL + ALT + DEL", hl.dsp.exec_cmd("hyprctl dispatch exit"))
      hl.bind("SUPER + E",        hl.dsp.exec_cmd("nautilus"))
      hl.bind("SUPER + L",        hl.dsp.exec_cmd("hyprlock"))
      hl.bind("SUPER + R",        hl.dsp.exec_cmd("rofi -show run"))
      hl.bind("SUPER + D",        hl.dsp.window.float({ action = "toggle" }))
      hl.bind("SUPER + N",        hl.dsp.exec_cmd("hyprpicker -a"))
      hl.bind("SUPER + P",        hl.dsp.exec_cmd("wlogout"))
      hl.bind("SUPER + I",        hl.dsp.exec_cmd("XDG_CURRENT_DESKTOP=gnome gnome-control-center"))
      hl.bind("SUPER + SHIFT + CTRL + T", hl.dsp.exec_cmd("sh ~/.config/hypr/script/wallpaper_change.sh"))
      hl.bind("SUPER + SHIFT + s",        hl.dsp.exec_cmd("hyprshot -m region --clipboard-only"))
      hl.bind("SHIFT + Print",            hl.dsp.exec_cmd('grim - | wl-copy && wl-paste > ~/Pictures/screenshots/Screenshot-$(date +%F_%T).png && dunstify "Screenshot of the whole screen taken" -t 1000'))

      hl.bind("SUPER + ALT + 1",         hl.dsp.exec_cmd("sh ~/.config/hypr/script/move_window_to_ws.sh 1 0"))

      for i = 1, 9 do
        hl.bind("SUPER + " .. i,               hl.dsp.focus({ workspace = i }))
        hl.bind("SUPER + ALT + " .. i,         hl.dsp.exec_cmd("sh ~/.config/hypr/script/move_window_to_ws.sh " .. i .. " 0"))
        hl.bind("SUPER + ALT + SHIFT + " .. i, hl.dsp.exec_cmd("sh ~/.config/hypr/script/move_window_to_ws.sh " .. i .. " 1"))
      end

      hl.bind("SUPER + CTRL + right", hl.dsp.focus({ workspace = "e+1" }))
      hl.bind("SUPER + CTRL + left",  hl.dsp.focus({ workspace = "e-1" }))
      hl.bind("SUPER + right",        hl.dsp.exec_cmd("hyprctl dispatch swapwindow r"))
      hl.bind("SUPER + left",         hl.dsp.exec_cmd("hyprctl dispatch swapwindow l"))
      hl.bind("SUPER + down",         hl.dsp.exec_cmd("hyprctl dispatch swapwindow d"))
      hl.bind("SUPER + up",           hl.dsp.exec_cmd("hyprctl dispatch swapwindow u"))

      hl.bind("XF86AudioMute",         hl.dsp.exec_cmd("wpctl set-mute @DEFAULT_AUDIO_SINK@ toggle"))
      hl.bind("XF86AudioRaiseVolume",  hl.dsp.exec_cmd("wpctl set-volume -l 1.4 @DEFAULT_AUDIO_SINK@ 5%+"), { repeating = true })
      hl.bind("XF86AudioLowerVolume",  hl.dsp.exec_cmd("wpctl set-volume -l 1.4 @DEFAULT_AUDIO_SINK@ 5%-"), { repeating = true })
      hl.bind("XF86MonBrightnessUp",   hl.dsp.exec_cmd("hyprctl hyprsunset gamma +10"), { locked = true, repeating = true })
      hl.bind("XF86MonBrightnessDown", hl.dsp.exec_cmd("hyprctl hyprsunset gamma -10"), { locked = true, repeating = true })

      hl.bind("SUPER + mouse:272", hl.dsp.window.drag(),   { mouse = true })
      hl.bind("SUPER + mouse:273", hl.dsp.window.resize(), { mouse = true })
      hl.bind("ALT + mouse:272",   hl.dsp.window.resize(), { mouse = true })

      -- Window rules
      hl.window_rule({ match = { title = "^(Open File).*$"        }, float = true, center = true })
      hl.window_rule({ match = { title = "^(Select a File).*$"    }, float = true, center = true })
      hl.window_rule({ match = { title = "^(Choose wallpaper).*$" }, float = true, center = true, size = "60% 65%" })
      hl.window_rule({ match = { title = "^(Open Folder).*$"      }, float = true, center = true })
      hl.window_rule({ match = { title = "^(Save As).*$"          }, float = true, center = true })
      hl.window_rule({ match = { title = "^(Library).*$"          }, float = true, center = true })
      hl.window_rule({ match = { title = "^(File Upload).*$"      }, float = true, center = true })
      hl.window_rule({ match = { title = "^(.*)(wants to save)$"  }, float = true, center = true })
      hl.window_rule({ match = { title = "^(.*)(wants to open)$"  }, float = true, center = true })
      hl.window_rule({ match = { class = "^(org.gnome.clocks)$"   }, float = true, center = true, size = "800 500" })
      hl.window_rule({ match = { class = "^(wlogout)$"            }, no_anim = true })
      hl.window_rule({ match = { class = ".*"                     }, suppress_event = "maximize" })
      hl.window_rule({ match = { class = "^(pinentry-)(.*)$"      }, stay_focused = true })

      -- Layer rules
      hl.layer_rule({ match = { namespace = "mywaybar-topbar" }, ignore_alpha = 0.2 })
      hl.layer_rule({ match = { namespace = "rofi"            }, no_anim = true })
      hl.layer_rule({ match = { namespace = "logout_dialog"   }, no_anim = true })

      -- Autostart
      hl.on("hyprland.start", function()
        hl.exec_cmd("swww-daemon")
        hl.exec_cmd("fcitx5")
        hl.exec_cmd("fcitx5-remote -r")
        hl.exec_cmd("fcitx5 -d --replace &")
        hl.exec_cmd("hyprsunset")
        hl.exec_cmd("swww img $(cat ~/.config/wallpaper.info) --transition-type none --transition-duration 0")
        hl.exec_cmd("cd ~/shell && quickshell -p shell.qml")
      end)
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
