{ ... }:
{
  programs.plasma =
    let
      system-notification-sounds = false;
    in
    {
      enable = true;
      overrideConfig = true;
      workspace = {
        wallpaper = ../assets/animals.png;
        theme = "breeze-dark";
        colorScheme = "BreezeDark";
        cursor.theme = "Bibata-Modern-Ice";
        splashScreen = {
          theme = "Illusion";
        };
      };
      kwin = {
        effects = {
          translucency.enable = true;
          wobblyWindows.enable = true;
          desktopSwitching = {
            navigationWrapping = true;
          };
          blur = {
            enable = true;
            strength = 2;
            noiseStrength = 0;
          };
          minimization = {
            animation = "magiclamp";
            duration = 200;
          };
          windowOpenClose.animation = "fade";
        };
        virtualDesktops = {
          rows = 1;
          names = [
            "Desktop 1"
            "Desktop 2"
            "Desktop 3"
          ];
        };
        nightLight = {
          enable = true;
          mode = "times";
          time = {
            morning = "07:00";
            evening = "19:00";
          };
          transitionTime = 30;
        };
        tiling = {
          padding = 4;
        };
      };
      powerdevil = {
        AC = {
          whenSleepingEnter = "standbyThenHibernate";
        };
        battery = {
          whenSleepingEnter = "standbyThenHibernate";
          displayBrightness = 85;
        };
        lowBattery = {
          whenSleepingEnter = "standbyThenHibernate";
          displayBrightness = 30;
        };
        general = {
          pausePlayersOnSuspend = true;
        };
        batteryLevels = {
          criticalAction = "hibernate";
          criticalLevel = 10;
          lowLevel = 20;
        };
      };
      hotkeys.commands."launch-kitty" = {
        name = "Launch Kitty";
        key = "Ctrl+Alt+T";
        command =
          # bash
          "kitty --start-as maximized";
      };
      hotkeys.commands."launch-brave" = {
        name = "Launch Brave";
        key = "Ctrl+Alt+B";
        command = "brave";
      };
      spectacle.shortcuts = {
        captureActiveWindow = "Meta+Print";
        captureRectangularRegion = "Meta+Shift+Print";
      };
      input = {
        touchpads = [
          {
            enable = true;
            # NOTE: Change if hardware changes
            vendorId = "093a";
            productId = "0274";
            name = "PIXA3854:00 093A:0274 Touchpad";
            naturalScroll = true;
            tapToClick = false;
            middleButtonEmulation = false;
            rightClickMethod = "twoFingers";
          }
        ];
        keyboard = {
          repeatDelay = 250;
        };
      };
      # NOTE: In order to get everything running, you sometimes may have to run
      # `systemctl --user restart plasma-plasmashell`
      shortcuts = {
        "ActivityManager"."switch-to-activity-18729546-c057-4fd4-a4fd-9a9aa7b4a44a" = [ ];
        "KDE Keyboard Layout Switcher"."Switch to Next Keyboard Layout" = "Meta+Alt+K";
        "kaccess"."Toggle Screen Reader On and Off" = "Meta+Alt+S";
        "kcm_touchpad"."Disable Touchpad" = "Touchpad Off";
        "kcm_touchpad"."Enable Touchpad" = "Touchpad On";
        "kcm_touchpad"."Toggle Touchpad" = "Touchpad Toggle";
        "kded5"."Show System Activity" = [ ];
        "kded5"."display" = [
          "Display"
          "Meta+P"
        ];
        "khotkeys"."{d03619b6-9b3c-48cc-9d9c-a2aadb485550}" = [ ];
        "kmix"."decrease_microphone_volume" = "Microphone Volume Down";
        "kmix"."decrease_volume" = "Volume Down";
        "kmix"."increase_microphone_volume" = "Microphone Volume Up";
        "kmix"."increase_volume" = "Volume Up";
        "kmix"."mic_mute" = [
          "Microphone Mute"
          "Meta+Volume Mute"
        ];
        "kmix"."mute" = "Volume Mute";
        "ksmserver"."Halt Without Confirmation" = [ ];
        "ksmserver"."Lock Session" = "Screensaver";
        "ksmserver"."Log Out" = "Ctrl+Alt+Del";
        "ksmserver"."Log Out Without Confirmation" = [ ];
        "ksmserver"."Reboot Without Confirmation" = [ ];
        "kwin"."Activate Window Demanding Attention" = "Meta+Ctrl+A";
        "kwin"."Decrease Opacity" = [ ];
        "kwin"."Edit Tiles" = "Meta+T";
        "kwin"."Expose" = "Ctrl+F9";
        "kwin"."ExposeAll" = [
          "Ctrl+F10"
          "Launch (C)"
        ];
        "kwin"."ExposeClass" = "Ctrl+F7";
        "kwin"."ExposeClassCurrentDesktop" = [ ];
        "kwin"."Increase Opacity" = [ ];
        "kwin"."Kill Window" = "Meta+Ctrl+Esc";
        "kwin"."Move Tablet to Next Output" = [ ];
        "kwin"."MoveMouseToCenter" = "Meta+F6";
        "kwin"."MoveMouseToFocus" = "Meta+F5";
        "kwin"."MoveZoomDown" = [ ];
        "kwin"."MoveZoomLeft" = [ ];
        "kwin"."MoveZoomRight" = [ ];
        "kwin"."MoveZoomUp" = [ ];
        "kwin"."Overview" = "Meta+W";
        "kwin"."Setup Window Shortcut" = [ ];
        "kwin"."Show Desktop" = "Meta+D";
        "kwin"."ShowDesktopGrid" = "Meta+F8";
        "kwin"."Suspend Compositing" = "Alt+Shift+F12";
        "kwin"."Switch One Desktop Down" = "Meta+Shift+J";
        "kwin"."Switch One Desktop Up" = "Meta+Shift+K";
        "kwin"."Switch One Desktop to the Left" = "Meta+Shift+H";
        "kwin"."Switch One Desktop to the Right" = "Meta+Shift+L";
        "kwin"."Switch Window Down" = "Meta+Alt+Down";
        "kwin"."Switch Window Left" = "Meta+Alt+Left";
        "kwin"."Switch Window Right" = "Meta+Alt+Right";
        "kwin"."Switch Window Up" = "Meta+Alt+Up";
        "kwin"."Switch to Desktop 1" = "Ctrl+F1";
        "kwin"."Switch to Desktop 10" = [ ];
        "kwin"."Switch to Desktop 11" = [ ];
        "kwin"."Switch to Desktop 12" = [ ];
        "kwin"."Switch to Desktop 13" = [ ];
        "kwin"."Switch to Desktop 14" = [ ];
        "kwin"."Switch to Desktop 15" = [ ];
        "kwin"."Switch to Desktop 16" = [ ];
        "kwin"."Switch to Desktop 17" = [ ];
        "kwin"."Switch to Desktop 18" = [ ];
        "kwin"."Switch to Desktop 19" = [ ];
        "kwin"."Switch to Desktop 2" = "Ctrl+F2";
        "kwin"."Switch to Desktop 20" = [ ];
        "kwin"."Switch to Desktop 3" = "Ctrl+F3";
        "kwin"."Switch to Desktop 4" = "Ctrl+F4";
        "kwin"."Switch to Desktop 5" = [ ];
        "kwin"."Switch to Desktop 6" = [ ];
        "kwin"."Switch to Desktop 7" = [ ];
        "kwin"."Switch to Desktop 8" = [ ];
        "kwin"."Switch to Desktop 9" = [ ];
        "kwin"."Switch to Next Desktop" = [ ];
        "kwin"."Switch to Next Screen" = [ ];
        "kwin"."Switch to Previous Desktop" = [ ];
        "kwin"."Switch to Previous Screen" = [ ];
        "kwin"."Switch to Screen 0" = [ ];
        "kwin"."Switch to Screen 1" = [ ];
        "kwin"."Switch to Screen 2" = [ ];
        "kwin"."Switch to Screen 3" = [ ];
        "kwin"."Switch to Screen 4" = [ ];
        "kwin"."Switch to Screen 5" = [ ];
        "kwin"."Switch to Screen 6" = [ ];
        "kwin"."Switch to Screen 7" = [ ];
        "kwin"."Switch to Screen Above" = [ ];
        "kwin"."Switch to Screen Below" = [ ];
        "kwin"."Switch to Screen to the Left" = [ ];
        "kwin"."Switch to Screen to the Right" = [ ];
        "kwin"."Toggle Night Color" = [ ];
        "kwin"."Toggle Window Raise/Lower" = [ ];
        "kwin"."Walk Through Desktop List" = [ ];
        "kwin"."Walk Through Desktop List (Reverse)" = [ ];
        "kwin"."Walk Through Desktops" = [ ];
        "kwin"."Walk Through Desktops (Reverse)" = [ ];
        "kwin"."Walk Through Windows" = "Alt+Tab";
        "kwin"."Walk Through Windows (Reverse)" = "Alt+Shift+Backtab";
        "kwin"."Walk Through Windows Alternative" = [ ];
        "kwin"."Walk Through Windows Alternative (Reverse)" = [ ];
        "kwin"."Walk Through Windows of Current Application" = "Alt+`";
        "kwin"."Walk Through Windows of Current Application (Reverse)" = "Alt+~";
        "kwin"."Walk Through Windows of Current Application Alternative" = [ ];
        "kwin"."Walk Through Windows of Current Application Alternative (Reverse)" = [ ];
        "kwin"."Window Above Other Windows" = [ ];
        "kwin"."Window Below Other Windows" = [ ];
        "kwin"."Window Close" = "Alt+F4";
        "kwin"."Window Fullscreen" = [ ];
        "kwin"."Window Grow Horizontal" = [ ];
        "kwin"."Window Grow Vertical" = [ ];
        "kwin"."Window Lower" = [ ];
        "kwin"."Window Maximize" = "Meta+U";
        "kwin"."Window Maximize Horizontal" = [ ];
        "kwin"."Window Maximize Vertical" = [ ];
        "kwin"."Window Minimize" = "Meta+PgDown";
        "kwin"."Window Move" = [ ];
        "kwin"."Window Move Center" = [ ];
        "kwin"."Window No Border" = [ ];
        "kwin"."Window On All Desktops" = [ ];
        "kwin"."Window One Desktop Down" = "Meta+Ctrl+Shift+J";
        "kwin"."Window One Desktop Up" = "Meta+Ctrl+Shift+K";
        "kwin"."Window One Desktop to the Left" = "Meta+Ctrl+Shift+H";
        "kwin"."Window One Desktop to the Right" = "Meta+Ctrl+Shift+L";
        "kwin"."Window One Screen Down" = [ ];
        "kwin"."Window One Screen Up" = [ ];
        "kwin"."Window One Screen to the Left" = [ ];
        "kwin"."Window One Screen to the Right" = [ ];
        "kwin"."Window Operations Menu" = "Alt+F3";
        "kwin"."Window Pack Down" = [ ];
        "kwin"."Window Pack Left" = [ ];
        "kwin"."Window Pack Right" = [ ];
        "kwin"."Window Pack Up" = [ ];
        "kwin"."Window Quick Tile Bottom" = "Meta+J";
        "kwin"."Window Quick Tile Bottom Left" = [ ];
        "kwin"."Window Quick Tile Bottom Right" = [ ];
        "kwin"."Window Quick Tile Left" = "Meta+H";
        "kwin"."Window Quick Tile Right" = "Meta+L";
        "kwin"."Window Quick Tile Top" = "Meta+K";
        "kwin"."Window Quick Tile Top Left" = [ ];
        "kwin"."Window Quick Tile Top Right" = [ ];
        "kwin"."Window Raise" = [ ];
        "kwin"."Window Resize" = [ ];
        "kwin"."Window Shade" = [ ];
        "kwin"."Window Shrink Horizontal" = [ ];
        "kwin"."Window Shrink Vertical" = [ ];
        "kwin"."Window to Desktop 1" = [ ];
        "kwin"."Window to Desktop 10" = [ ];
        "kwin"."Window to Desktop 11" = [ ];
        "kwin"."Window to Desktop 12" = [ ];
        "kwin"."Window to Desktop 13" = [ ];
        "kwin"."Window to Desktop 14" = [ ];
        "kwin"."Window to Desktop 15" = [ ];
        "kwin"."Window to Desktop 16" = [ ];
        "kwin"."Window to Desktop 17" = [ ];
        "kwin"."Window to Desktop 18" = [ ];
        "kwin"."Window to Desktop 19" = [ ];
        "kwin"."Window to Desktop 2" = [ ];
        "kwin"."Window to Desktop 20" = [ ];
        "kwin"."Window to Desktop 3" = [ ];
        "kwin"."Window to Desktop 4" = [ ];
        "kwin"."Window to Desktop 5" = [ ];
        "kwin"."Window to Desktop 6" = [ ];
        "kwin"."Window to Desktop 7" = [ ];
        "kwin"."Window to Desktop 8" = [ ];
        "kwin"."Window to Desktop 9" = [ ];
        "kwin"."Window to Next Desktop" = [ ];
        "kwin"."Window to Next Screen" = "Meta+Shift+Right";
        "kwin"."Window to Previous Desktop" = [ ];
        "kwin"."Window to Previous Screen" = "Meta+Shift+Left";
        "kwin"."Window to Screen 0" = [ ];
        "kwin"."Window to Screen 1" = [ ];
        "kwin"."Window to Screen 2" = [ ];
        "kwin"."Window to Screen 3" = [ ];
        "kwin"."Window to Screen 4" = [ ];
        "kwin"."Window to Screen 5" = [ ];
        "kwin"."Window to Screen 6" = [ ];
        "kwin"."Window to Screen 7" = [ ];
        "kwin"."view_actual_size" = "Meta+0";
        "kwin"."view_zoom_in" = [
          "Meta++"
          "Meta+="
        ];
        "kwin"."view_zoom_out" = "Meta+-";
        "mediacontrol"."mediavolumedown" = [ ];
        "mediacontrol"."mediavolumeup" = [ ];
        "mediacontrol"."nextmedia" = "Media Next";
        "mediacontrol"."pausemedia" = "Media Pause";
        "mediacontrol"."playmedia" = [ ];
        "mediacontrol"."playpausemedia" = "Media Play";
        "mediacontrol"."previousmedia" = "Media Previous";
        "mediacontrol"."stopmedia" = "Media Stop";
        "org.kde.dolphin.desktop"."_launch" = "Meta+E";
        "org.kde.krunner.desktop"."RunClipboard" = "Alt+Shift+F2";
        "org.kde.krunner.desktop"."_launch" = [
          "Alt+Space"
          "Alt+F2"
          "Search"
        ];
        "org.kde.plasma.emojier.desktop"."_launch" = [
          "Meta+."
          "Meta+Ctrl+Alt+Shift+Space"
        ];
        "org.kde.spectacle.desktop"."ActiveWindowScreenShot" = "Meta+Print";
        "org.kde.spectacle.desktop"."CurrentMonitorScreenShot" = [ ];
        "org.kde.spectacle.desktop"."FullScreenScreenShot" = "Shift+Print";
        "org.kde.spectacle.desktop"."OpenWithoutScreenshot" = [ ];
        "org.kde.spectacle.desktop"."RectangularRegionScreenShot" = "Meta+Shift+Print";
        "org.kde.spectacle.desktop"."WindowUnderCursorScreenShot" = "Meta+Ctrl+Print";
        "org.kde.spectacle.desktop"."_launch" = "Print";
        "org_kde_powerdevil"."Decrease Keyboard Brightness" = "Keyboard Brightness Down";
        "org_kde_powerdevil"."Decrease Screen Brightness" = "Monitor Brightness Down";
        "org_kde_powerdevil"."Hibernate" = "Hibernate";
        "org_kde_powerdevil"."Increase Keyboard Brightness" = "Keyboard Brightness Up";
        "org_kde_powerdevil"."Increase Screen Brightness" = "Monitor Brightness Up";
        "org_kde_powerdevil"."PowerDown" = "Power Down";
        "org_kde_powerdevil"."PowerOff" = "Power Off";
        "org_kde_powerdevil"."Sleep" = "Sleep";
        "org_kde_powerdevil"."Toggle Keyboard Backlight" = "Keyboard Light On/Off";
        "org_kde_powerdevil"."Turn Off Screen" = [ ];
        "plasmashell"."activate task manager entry 1" = "Meta+1";
        "plasmashell"."activate task manager entry 10" = [ ];
        "plasmashell"."activate task manager entry 2" = "Meta+2";
        "plasmashell"."activate task manager entry 3" = "Meta+3";
        "plasmashell"."activate task manager entry 4" = "Meta+4";
        "plasmashell"."activate task manager entry 5" = "Meta+5";
        "plasmashell"."activate task manager entry 6" = "Meta+6";
        "plasmashell"."activate task manager entry 7" = "Meta+7";
        "plasmashell"."activate task manager entry 8" = "Meta+8";
        "plasmashell"."activate task manager entry 9" = "Meta+9";
        "plasmashell"."clear-history" = [ ];
        "plasmashell"."clipboard_action" = "Meta+Ctrl+X";
        "plasmashell"."cycle-panels" = "Meta+Alt+P";
        "plasmashell"."cycleNextAction" = [ ];
        "plasmashell"."cyclePrevAction" = [ ];
        "plasmashell"."edit_clipboard" = [ ];
        "plasmashell"."manage activities" = "Meta+Q";
        "plasmashell"."next activity" = [ ];
        "plasmashell"."previous activity" = "Meta+Shift+Tab";
        "plasmashell"."repeat_action" = "Meta+Ctrl+R";
        "plasmashell"."show dashboard" = "Ctrl+F12";
        "plasmashell"."show-barcode" = [ ];
        "plasmashell"."show-on-mouse-pos" = "Meta+V";
        "plasmashell"."stop current activity" = "Meta+S";
        "plasmashell"."switch to next activity" = [ ];
        "plasmashell"."switch to previous activity" = [ ];
        "plasmashell"."toggle do not disturb" = [ ];
        "systemsettings.desktop"."_launch" = "Tools";
        "systemsettings.desktop"."kcm-kscreen" = [ ];
        "systemsettings.desktop"."kcm-lookandfeel" = [ ];
        "systemsettings.desktop"."kcm-users" = [ ];
        "systemsettings.desktop"."powerdevilprofilesconfig" = [ ];
        "systemsettings.desktop"."screenlocker" = [ ];
      };
      configFile = {
        "baloofilerc"."Basic Settings"."Indexing-Enabled".value = false;
        "baloofilerc"."General"."dbVersion".value = 2;
        "baloofilerc"."General"."exclude filters".value =
          "*~,*.part,*.o,*.la,*.lo,*.loT,*.moc,moc_*.cpp,qrc_*.cpp,ui_*.h,cmake_install.cmake,CMakeCache.txt,CTestTestfile.cmake,libtool,config.status,confdefs.h,autom4te,conftest,confstat,Makefile.am,*.gcode,.ninja_deps,.ninja_log,build.ninja,*.csproj,*.m4,*.rej,*.gmo,*.pc,*.omf,*.aux,*.tmp,*.po,*.vm*,*.nvram,*.rcore,*.swp,*.swap,lzo,litmain.sh,*.orig,.histfile.*,.xsession-errors*,*.map,*.so,*.a,*.db,*.qrc,*.ini,*.init,*.img,*.vdi,*.vbox*,vbox.log,*.qcow2,*.vmdk,*.vhd,*.vhdx,*.sql,*.sql.gz,*.ytdl,*.class,*.pyc,*.pyo,*.elc,*.qmlc,*.jsc,*.fastq,*.fq,*.gb,*.fasta,*.fna,*.gbff,*.faa,po,CVS,.svn,.git,_darcs,.bzr,.hg,CMakeFiles,CMakeTmp,CMakeTmpQmake,.moc,.obj,.pch,.uic,.npm,.yarn,.yarn-cache,__pycache__,node_modules,node_packages,nbproject,.venv,venv,core-dumps,lost+found";
        "baloofilerc"."General"."exclude filters version".value = 8;
        "kactivitymanagerdrc"."activities"."18729546-c057-4fd4-a4fd-9a9aa7b4a44a".value = "Default";
        "kactivitymanagerdrc"."main"."currentActivity".value = "18729546-c057-4fd4-a4fd-9a9aa7b4a44a";
        "kded5rc"."Module-browserintegrationreminder"."autoload".value = false;
        "kded5rc"."Module-device_automounter"."autoload".value = false;
        "kded5rc"."PlasmaBrowserIntegration"."shownCount".value = 4;
        "kdeglobals"."General"."AllowKDEAppsToRememberWindowPositions".value = true;
        "kdeglobals"."General"."AccentColor" = "233,157,69";
        "kdeglobals"."General"."BrowserApplication".value = "brave-browser.desktop";
        "kdeglobals"."General"."UseSystemBell".value = false;
        "kdeglobals"."General"."TerminalApplication".value = "ghostty";
        "kdeglobals"."General"."TerminalService".value = "com.mitchellh.ghostty.desktop";
        # TODO: Set the appropriate value in `xsettingsd`?
        "kdeglobals"."Sounds"."Enable".value = system-notification-sounds;
        "gtk-3.0/settings.ini"."Settings"."gtk-enable-event-sounds".value = system-notification-sounds;
        "gtk-4.0/settings.ini"."Settings"."gtk-enable-event-sounds".value = system-notification-sounds;
        "kdeglobals"."KDE"."SingleClick".value = false;
        "kdeglobals"."KFileDialog Settings"."Allow Expansion".value = false;
        "kdeglobals"."KFileDialog Settings"."Automatically select filename extension".value = true;
        "kdeglobals"."KFileDialog Settings"."Breadcrumb Navigation".value = true;
        "kdeglobals"."KFileDialog Settings"."Decoration position".value = 2;
        "kdeglobals"."KFileDialog Settings"."LocationCombo Completionmode".value = 5;
        "kdeglobals"."KFileDialog Settings"."PathCombo Completionmode".value = 5;
        "kdeglobals"."KFileDialog Settings"."Show Bookmarks".value = false;
        "kdeglobals"."KFileDialog Settings"."Show Full Path".value = false;
        "kdeglobals"."KFileDialog Settings"."Show Inline Previews".value = true;
        "kdeglobals"."KFileDialog Settings"."Show Speedbar".value = true;
        "kdeglobals"."KFileDialog Settings"."Show hidden files".value = true;
        "kdeglobals"."KFileDialog Settings"."Sort by".value = "Name";
        "kdeglobals"."KFileDialog Settings"."Sort directories first".value = true;
        "kdeglobals"."KFileDialog Settings"."Sort hidden files last".value = false;
        "kdeglobals"."KFileDialog Settings"."Sort reversed".value = false;
        "kdeglobals"."KFileDialog Settings"."Speedbar Width".value = 138;
        "kdeglobals"."KFileDialog Settings"."View Style".value = "DetailTree";
        "kdeglobals"."KScreen"."ScreenScaleFactors".value =
          "eDP-1=1;DP-1=1;DP-2=1;DP-3=1;DP-4=1;DP-5=1;DP-6=1;DP-7=1;DP-8=1;";
        "kdeglobals"."WM"."activeBackground".value = "49,54,59";
        "kdeglobals"."WM"."activeBlend".value = "252,252,252";
        "kdeglobals"."WM"."activeForeground".value = "252,252,252";
        "kdeglobals"."WM"."inactiveBackground".value = "42,46,50";
        "kdeglobals"."WM"."inactiveBlend".value = "161,169,177";
        "kdeglobals"."WM"."inactiveForeground".value = "161,169,177";
        "kglobalshortcutsrc"."ActivityManager"."_k_friendly_name".value = "Activity Manager";
        "kglobalshortcutsrc"."KDE Keyboard Layout Switcher"."_k_friendly_name".value =
          "Keyboard Layout Switcher";
        "kglobalshortcutsrc"."kaccess"."_k_friendly_name".value = "Accessibility";
        "kglobalshortcutsrc"."kcm_touchpad"."_k_friendly_name".value = "Touchpad";
        "kglobalshortcutsrc"."kded5"."_k_friendly_name".value = "KDE Daemon";
        "kglobalshortcutsrc"."khotkeys"."_k_friendly_name".value = "Custom Shortcuts Service";
        "kglobalshortcutsrc"."kmix"."_k_friendly_name".value = "Audio Volume";
        "kglobalshortcutsrc"."ksmserver"."_k_friendly_name".value = "Session Management";
        "kglobalshortcutsrc"."kwin"."_k_friendly_name".value = "KWin";
        "kglobalshortcutsrc"."mediacontrol"."_k_friendly_name".value = "Media Controller";
        "kglobalshortcutsrc"."org.kde.dolphin.desktop"."_k_friendly_name".value = "Dolphin";
        "kglobalshortcutsrc"."org.kde.konsole.desktop"."_k_friendly_name".value = "Konsole";
        "kglobalshortcutsrc"."org.kde.krunner.desktop"."_k_friendly_name".value = "KRunner";
        "kglobalshortcutsrc"."org.kde.plasma.emojier.desktop"."_k_friendly_name".value = "Emoji Selector";
        "kglobalshortcutsrc"."org.kde.spectacle.desktop"."_k_friendly_name".value = "Spectacle";
        "kglobalshortcutsrc"."org_kde_powerdevil"."_k_friendly_name".value = "Power Management";
        "kglobalshortcutsrc"."plasmashell"."_k_friendly_name".value = "Activity switching";
        "kglobalshortcutsrc"."systemsettings.desktop"."_k_friendly_name".value = "System Settings";
        "khotkeysrc"."Data"."DataCount".value = 3;
        "khotkeysrc"."Data_1"."Comment".value = "KMenuEdit Global Shortcuts";
        "khotkeysrc"."Data_1"."DataCount".value = 1;
        "khotkeysrc"."Data_1"."Enabled".value = true;
        "khotkeysrc"."Data_1"."Name".value = "KMenuEdit";
        "khotkeysrc"."Data_1"."SystemGroup".value = 1;
        "khotkeysrc"."Data_1"."Type".value = "ACTION_DATA_GROUP";
        "khotkeysrc"."Data_1Conditions"."Comment".value = "";
        "khotkeysrc"."Data_1Conditions"."ConditionsCount".value = 0;
        "khotkeysrc"."Data_1_1"."Comment".value = "Comment";
        "khotkeysrc"."Data_1_1"."Enabled".value = true;
        "khotkeysrc"."Data_1_1"."Name".value = "Search";
        "khotkeysrc"."Data_1_1"."Type".value = "SIMPLE_ACTION_DATA";
        "khotkeysrc"."Data_1_1Actions"."ActionsCount".value = 1;
        "khotkeysrc"."Data_1_1Actions0"."CommandURL".value = "http://google.com";
        "khotkeysrc"."Data_1_1Actions0"."Type".value = "COMMAND_URL";
        "khotkeysrc"."Data_1_1Conditions"."Comment".value = "";
        "khotkeysrc"."Data_1_1Conditions"."ConditionsCount".value = 0;
        "khotkeysrc"."Data_1_1Triggers"."Comment".value = "Simple_action";
        "khotkeysrc"."Data_1_1Triggers"."TriggersCount".value = 1;
        "khotkeysrc"."Data_1_1Triggers0"."Key".value = "";
        "khotkeysrc"."Data_1_1Triggers0"."Type".value = "SHORTCUT";
        "khotkeysrc"."Data_1_1Triggers0"."Uuid".value = "{d03619b6-9b3c-48cc-9d9c-a2aadb485550}";
        "khotkeysrc"."Data_2"."Comment".value =
          "This group contains various examples demonstrating most of the features of KHotkeys. (Note that this group and all its actions are disabled by default.)";
        "khotkeysrc"."Data_2"."DataCount".value = 8;
        "khotkeysrc"."Data_2"."Enabled".value = false;
        "khotkeysrc"."Data_2"."ImportId".value = "kde32b1";
        "khotkeysrc"."Data_2"."Name".value = "Examples";
        "khotkeysrc"."Data_2"."SystemGroup".value = 0;
        "khotkeysrc"."Data_2"."Type".value = "ACTION_DATA_GROUP";
        "khotkeysrc"."Data_2Conditions"."Comment".value = "";
        "khotkeysrc"."Data_2Conditions"."ConditionsCount".value = 0;
        "khotkeysrc"."Data_2_1"."Comment".value =
          "After pressing Ctrl+Alt+I, the KSIRC window will be activated, if it exists. Simple.";
        "khotkeysrc"."Data_2_1"."Enabled".value = false;
        "khotkeysrc"."Data_2_1"."Name".value = "Activate KSIRC Window";
        "khotkeysrc"."Data_2_1"."Type".value = "SIMPLE_ACTION_DATA";
        "khotkeysrc"."Data_2_1Actions"."ActionsCount".value = 1;
        "khotkeysrc"."Data_2_1Actions0"."Type".value = "ACTIVATE_WINDOW";
        "khotkeysrc"."Data_2_1Actions0Window"."Comment".value = "KSIRC window";
        "khotkeysrc"."Data_2_1Actions0Window"."WindowsCount".value = 1;
        "khotkeysrc"."Data_2_1Actions0Window0"."Class".value = "ksirc";
        "khotkeysrc"."Data_2_1Actions0Window0"."ClassType".value = 1;
        "khotkeysrc"."Data_2_1Actions0Window0"."Comment".value = "KSIRC";
        "khotkeysrc"."Data_2_1Actions0Window0"."Role".value = "";
        "khotkeysrc"."Data_2_1Actions0Window0"."RoleType".value = 0;
        "khotkeysrc"."Data_2_1Actions0Window0"."Title".value = "";
        "khotkeysrc"."Data_2_1Actions0Window0"."TitleType".value = 0;
        "khotkeysrc"."Data_2_1Actions0Window0"."Type".value = "SIMPLE";
        "khotkeysrc"."Data_2_1Actions0Window0"."WindowTypes".value = 33;
        "khotkeysrc"."Data_2_1Conditions"."Comment".value = "";
        "khotkeysrc"."Data_2_1Conditions"."ConditionsCount".value = 0;
        "khotkeysrc"."Data_2_1Triggers"."Comment".value = "Simple_action";
        "khotkeysrc"."Data_2_1Triggers"."TriggersCount".value = 1;
        "khotkeysrc"."Data_2_1Triggers0"."Key".value = "Ctrl+Alt+I";
        "khotkeysrc"."Data_2_1Triggers0"."Type".value = "SHORTCUT";
        "khotkeysrc"."Data_2_1Triggers0"."Uuid".value = "{6e7556b0-59f2-4637-93d8-eab1bf2ab928}";
        "khotkeysrc"."Data_2_2"."Comment".value = ''
          After pressing Alt+Ctrl+H the input of 'Hello' will be simulated, as if you typed it.  This is especially useful if you have call to frequently type a word (for instance, 'unsigned').  Every keypress in the input is separated by a colon ':'. Note that the keypresses literally mean keypresses, so you have to write what you would press on the keyboard. In the table below, the left column shows the input and the right column shows what to type.

          "enter" (i.e. new line)                Enter or Return
          a (i.e. small a)                          A
          A (i.e. capital a)                       Shift+A
          : (colon)                                  Shift+;
          ' '  (space)                              Space'';
        "khotkeysrc"."Data_2_2"."Enabled".value = false;
        "khotkeysrc"."Data_2_2"."Name".value = "Type 'Hello'";
        "khotkeysrc"."Data_2_2"."Type".value = "SIMPLE_ACTION_DATA";
        "khotkeysrc"."Data_2_2Actions"."ActionsCount".value = 1;
        "khotkeysrc"."Data_2_2Actions0"."DestinationWindow".value = 2;
        "khotkeysrc"."Data_2_2Actions0"."Input".value = ''
          Shift+H:E:L:L:O
        '';
        "khotkeysrc"."Data_2_2Actions0"."Type".value = "KEYBOARD_INPUT";
        "khotkeysrc"."Data_2_2Conditions"."Comment".value = "";
        "khotkeysrc"."Data_2_2Conditions"."ConditionsCount".value = 0;
        "khotkeysrc"."Data_2_2Triggers"."Comment".value = "Simple_action";
        "khotkeysrc"."Data_2_2Triggers"."TriggersCount".value = 1;
        "khotkeysrc"."Data_2_2Triggers0"."Key".value = "Ctrl+Alt+H";
        "khotkeysrc"."Data_2_2Triggers0"."Type".value = "SHORTCUT";
        "khotkeysrc"."Data_2_2Triggers0"."Uuid".value = "{ebad9126-7d7a-4698-9bad-5c330ec992a5}";
        "khotkeysrc"."Data_2_3"."Comment".value = "This action runs Konsole, after pressing Ctrl+Alt+T.";
        "khotkeysrc"."Data_2_3"."Enabled".value = false;
        "khotkeysrc"."Data_2_3"."Name".value = "Run Konsole";
        "khotkeysrc"."Data_2_3"."Type".value = "SIMPLE_ACTION_DATA";
        "khotkeysrc"."Data_2_3Actions"."ActionsCount".value = 1;
        "khotkeysrc"."Data_2_3Actions0"."CommandURL".value = "konsole";
        "khotkeysrc"."Data_2_3Actions0"."Type".value = "COMMAND_URL";
        "khotkeysrc"."Data_2_3Conditions"."Comment".value = "";
        "khotkeysrc"."Data_2_3Conditions"."ConditionsCount".value = 0;
        "khotkeysrc"."Data_2_3Triggers"."Comment".value = "Simple_action";
        "khotkeysrc"."Data_2_3Triggers"."TriggersCount".value = 1;
        "khotkeysrc"."Data_2_3Triggers0"."Key".value = "Ctrl+Alt+T";
        "khotkeysrc"."Data_2_3Triggers0"."Type".value = "SHORTCUT";
        "khotkeysrc"."Data_2_3Triggers0"."Uuid".value = "{8e4549d7-7c38-45f1-8fcf-723ac7c025d7}";
        "khotkeysrc"."Data_2_4"."Comment".value =
          ''
            Read the comment on the "Type 'Hello'" action first.

            Qt Designer uses Ctrl+F4 for closing windows.  In KDE, however, Ctrl+F4 is the shortcut for going to virtual desktop 4, so this shortcut does not work in Qt Designer.  Further, Qt Designer does not use KDE's standard Ctrl+W for closing the window.

            This problem can be solved by remapping Ctrl+W to Ctrl+F4 when the active window is Qt Designer. When Qt Designer is active, every time Ctrl+W is pressed, Ctrl+F4 will be sent to Qt Designer instead. In other applications, the effect of Ctrl+W is unchanged.

            We now need to specify three things: A new shortcut trigger on 'Ctrl+W', a new keyboard input action sending Ctrl+F4, and a new condition that the active window is Qt Designer.
            Qt Designer seems to always have title 'Qt Designer by Trolltech', so the condition will check for the active window having that title.'';
        "khotkeysrc"."Data_2_4"."Enabled".value = false;
        "khotkeysrc"."Data_2_4"."Name".value = "Remap Ctrl+W to Ctrl+F4 in Qt Designer";
        "khotkeysrc"."Data_2_4"."Type".value = "GENERIC_ACTION_DATA";
        "khotkeysrc"."Data_2_4Actions"."ActionsCount".value = 1;
        "khotkeysrc"."Data_2_4Actions0"."DestinationWindow".value = 2;
        "khotkeysrc"."Data_2_4Actions0"."Input".value = "Ctrl+F4";
        "khotkeysrc"."Data_2_4Actions0"."Type".value = "KEYBOARD_INPUT";
        "khotkeysrc"."Data_2_4Conditions"."Comment".value = "";
        "khotkeysrc"."Data_2_4Conditions"."ConditionsCount".value = 1;
        "khotkeysrc"."Data_2_4Conditions0"."Type".value = "ACTIVE_WINDOW";
        "khotkeysrc"."Data_2_4Conditions0Window"."Comment".value = "Qt Designer";
        "khotkeysrc"."Data_2_4Conditions0Window"."WindowsCount".value = 1;
        "khotkeysrc"."Data_2_4Conditions0Window0"."Class".value = "";
        "khotkeysrc"."Data_2_4Conditions0Window0"."ClassType".value = 0;
        "khotkeysrc"."Data_2_4Conditions0Window0"."Comment".value = "";
        "khotkeysrc"."Data_2_4Conditions0Window0"."Role".value = "";
        "khotkeysrc"."Data_2_4Conditions0Window0"."RoleType".value = 0;
        "khotkeysrc"."Data_2_4Conditions0Window0"."Title".value = "Qt Designer by Trolltech";
        "khotkeysrc"."Data_2_4Conditions0Window0"."TitleType".value = 2;
        "khotkeysrc"."Data_2_4Conditions0Window0"."Type".value = "SIMPLE";
        "khotkeysrc"."Data_2_4Conditions0Window0"."WindowTypes".value = 33;
        "khotkeysrc"."Data_2_4Triggers"."Comment".value = "";
        "khotkeysrc"."Data_2_4Triggers"."TriggersCount".value = 1;
        "khotkeysrc"."Data_2_4Triggers0"."Key".value = "Ctrl+W";
        "khotkeysrc"."Data_2_4Triggers0"."Type".value = "SHORTCUT";
        "khotkeysrc"."Data_2_4Triggers0"."Uuid".value = "{35cace53-6662-451e-a219-84e4ea686bb0}";
        "khotkeysrc"."Data_2_5"."Comment".value =
          "By pressing Alt+Ctrl+W a D-Bus call will be performed that will show the minicli. You can use any kind of D-Bus call, just like using the command line 'qdbus' tool.";
        "khotkeysrc"."Data_2_5"."Enabled".value = false;
        "khotkeysrc"."Data_2_5"."Name".value = "Perform D-Bus call 'qdbus org.kde.krunner /App display'";
        "khotkeysrc"."Data_2_5"."Type".value = "SIMPLE_ACTION_DATA";
        "khotkeysrc"."Data_2_5Actions"."ActionsCount".value = 1;
        "khotkeysrc"."Data_2_5Actions0"."Arguments".value = "";
        "khotkeysrc"."Data_2_5Actions0"."Call".value = "popupExecuteCommand";
        "khotkeysrc"."Data_2_5Actions0"."RemoteApp".value = "org.kde.krunner";
        "khotkeysrc"."Data_2_5Actions0"."RemoteObj".value = "/App";
        "khotkeysrc"."Data_2_5Actions0"."Type".value = "DBUS";
        "khotkeysrc"."Data_2_5Conditions"."Comment".value = "";
        "khotkeysrc"."Data_2_5Conditions"."ConditionsCount".value = 0;
        "khotkeysrc"."Data_2_5Triggers"."Comment".value = "Simple_action";
        "khotkeysrc"."Data_2_5Triggers"."TriggersCount".value = 1;
        "khotkeysrc"."Data_2_5Triggers0"."Key".value = "Ctrl+Alt+W";
        "khotkeysrc"."Data_2_5Triggers0"."Type".value = "SHORTCUT";
        "khotkeysrc"."Data_2_5Triggers0"."Uuid".value = "{fba8d93a-3510-40e8-866b-0c299fc281d6}";
        "khotkeysrc"."Data_2_6"."Comment".value = ''
          Read the comment on the "Type 'Hello'" action first.

          Just like the "Type 'Hello'" action, this one simulates keyboard input, specifically, after pressing Ctrl+Alt+B, it sends B to XMMS (B in XMMS jumps to the next song). The 'Send to specific window' checkbox is checked and a window with its class containing 'XMMS_Player' is specified; this will make the input always be sent to this window. This way, you can control XMMS even if, for instance, it is on a different virtual desktop.

          (Run 'xprop' and click on the XMMS window and search for WM_CLASS to see 'XMMS_Player').'';
        "khotkeysrc"."Data_2_6"."Enabled".value = false;
        "khotkeysrc"."Data_2_6"."Name".value = "Next in XMMS";
        "khotkeysrc"."Data_2_6"."Type".value = "SIMPLE_ACTION_DATA";
        "khotkeysrc"."Data_2_6Actions"."ActionsCount".value = 1;
        "khotkeysrc"."Data_2_6Actions0"."DestinationWindow".value = 1;
        "khotkeysrc"."Data_2_6Actions0"."Input".value = "B";
        "khotkeysrc"."Data_2_6Actions0"."Type".value = "KEYBOARD_INPUT";
        "khotkeysrc"."Data_2_6Actions0DestinationWindow"."Comment".value = "XMMS window";
        "khotkeysrc"."Data_2_6Actions0DestinationWindow"."WindowsCount".value = 1;
        "khotkeysrc"."Data_2_6Actions0DestinationWindow0"."Class".value = "XMMS_Player";
        "khotkeysrc"."Data_2_6Actions0DestinationWindow0"."ClassType".value = 1;
        "khotkeysrc"."Data_2_6Actions0DestinationWindow0"."Comment".value = "XMMS Player window";
        "khotkeysrc"."Data_2_6Actions0DestinationWindow0"."Role".value = "";
        "khotkeysrc"."Data_2_6Actions0DestinationWindow0"."RoleType".value = 0;
        "khotkeysrc"."Data_2_6Actions0DestinationWindow0"."Title".value = "";
        "khotkeysrc"."Data_2_6Actions0DestinationWindow0"."TitleType".value = 0;
        "khotkeysrc"."Data_2_6Actions0DestinationWindow0"."Type".value = "SIMPLE";
        "khotkeysrc"."Data_2_6Actions0DestinationWindow0"."WindowTypes".value = 33;
        "khotkeysrc"."Data_2_6Conditions"."Comment".value = "";
        "khotkeysrc"."Data_2_6Conditions"."ConditionsCount".value = 0;
        "khotkeysrc"."Data_2_6Triggers"."Comment".value = "Simple_action";
        "khotkeysrc"."Data_2_6Triggers"."TriggersCount".value = 1;
        "khotkeysrc"."Data_2_6Triggers0"."Key".value = "Ctrl+Alt+B";
        "khotkeysrc"."Data_2_6Triggers0"."Type".value = "SHORTCUT";
        "khotkeysrc"."Data_2_6Triggers0"."Uuid".value = "{04312a12-280c-4670-8dfa-c507a26ef1b0}";
        "khotkeysrc"."Data_2_7"."Comment".value =
          ''
            Konqueror in KDE3.1 has tabs, and now you can also have gestures.

            Just press the middle mouse button and start drawing one of the gestures, and after you are finished, release the mouse button. If you only need to paste the selection, it still works, just click the middle mouse button. (You can change the mouse button to use in the global settings).

            Right now, there are the following gestures available:
            move right and back left - Forward (Alt+Right)
            move left and back right - Back (Alt+Left)
            move up and back down  - Up (Alt+Up)
            circle counterclockwise - Reload (F5)

            The gesture shapes can be entered by performing them in the configuration dialog. You can also look at your numeric pad to help you: gestures are recognized like a 3x3 grid of fields, numbered 1 to 9.

            Note that you must perform exactly the gesture to trigger the action. Because of this, it is possible to enter more gestures for the action. You should try to avoid complicated gestures where you change the direction of mouse movement more than once.  For instance, 45654 or 74123 are simple to perform, but 1236987 may be already quite difficult.

            The conditions for all gestures are defined in this group. All these gestures are active only if the active window is Konqueror (class contains 'konqueror').'';
        "khotkeysrc"."Data_2_7"."DataCount".value = 4;
        "khotkeysrc"."Data_2_7"."Enabled".value = false;
        "khotkeysrc"."Data_2_7"."Name".value = "Konqi Gestures";
        "khotkeysrc"."Data_2_7"."SystemGroup".value = 0;
        "khotkeysrc"."Data_2_7"."Type".value = "ACTION_DATA_GROUP";
        "khotkeysrc"."Data_2_7Conditions"."Comment".value = "Konqueror window";
        "khotkeysrc"."Data_2_7Conditions"."ConditionsCount".value = 1;
        "khotkeysrc"."Data_2_7Conditions0"."Type".value = "ACTIVE_WINDOW";
        "khotkeysrc"."Data_2_7Conditions0Window"."Comment".value = "Konqueror";
        "khotkeysrc"."Data_2_7Conditions0Window"."WindowsCount".value = 1;
        "khotkeysrc"."Data_2_7Conditions0Window0"."Class".value = "konqueror";
        "khotkeysrc"."Data_2_7Conditions0Window0"."ClassType".value = 1;
        "khotkeysrc"."Data_2_7Conditions0Window0"."Comment".value = "Konqueror";
        "khotkeysrc"."Data_2_7Conditions0Window0"."Role".value = "";
        "khotkeysrc"."Data_2_7Conditions0Window0"."RoleType".value = 0;
        "khotkeysrc"."Data_2_7Conditions0Window0"."Title".value = "";
        "khotkeysrc"."Data_2_7Conditions0Window0"."TitleType".value = 0;
        "khotkeysrc"."Data_2_7Conditions0Window0"."Type".value = "SIMPLE";
        "khotkeysrc"."Data_2_7Conditions0Window0"."WindowTypes".value = 33;
        "khotkeysrc"."Data_2_7_1"."Comment".value = "";
        "khotkeysrc"."Data_2_7_1"."Enabled".value = false;
        "khotkeysrc"."Data_2_7_1"."Name".value = "Back";
        "khotkeysrc"."Data_2_7_1"."Type".value = "SIMPLE_ACTION_DATA";
        "khotkeysrc"."Data_2_7_1Actions"."ActionsCount".value = 1;
        "khotkeysrc"."Data_2_7_1Actions0"."DestinationWindow".value = 2;
        "khotkeysrc"."Data_2_7_1Actions0"."Input".value = "Alt+Left";
        "khotkeysrc"."Data_2_7_1Actions0"."Type".value = "KEYBOARD_INPUT";
        "khotkeysrc"."Data_2_7_1Conditions"."Comment".value = "";
        "khotkeysrc"."Data_2_7_1Conditions"."ConditionsCount".value = 0;
        "khotkeysrc"."Data_2_7_1Triggers"."Comment".value = "Gesture_triggers";
        "khotkeysrc"."Data_2_7_1Triggers"."TriggersCount".value = 3;
        "khotkeysrc"."Data_2_7_1Triggers0"."GesturePointData".value =
          "0,0.0625,1,1,0.5,0.0625,0.0625,1,0.875,0.5,0.125,0.0625,1,0.75,0.5,0.1875,0.0625,1,0.625,0.5,0.25,0.0625,1,0.5,0.5,0.3125,0.0625,1,0.375,0.5,0.375,0.0625,1,0.25,0.5,0.4375,0.0625,1,0.125,0.5,0.5,0.0625,0,0,0.5,0.5625,0.0625,0,0.125,0.5,0.625,0.0625,0,0.25,0.5,0.6875,0.0625,0,0.375,0.5,0.75,0.0625,0,0.5,0.5,0.8125,0.0625,0,0.625,0.5,0.875,0.0625,0,0.75,0.5,0.9375,0.0625,0,0.875,0.5,1,0,0,1,0.5";
        "khotkeysrc"."Data_2_7_1Triggers0"."Type".value = "GESTURE";
        "khotkeysrc"."Data_2_7_1Triggers1"."GesturePointData".value =
          "0,0.0833333,1,0.5,0.5,0.0833333,0.0833333,1,0.375,0.5,0.166667,0.0833333,1,0.25,0.5,0.25,0.0833333,1,0.125,0.5,0.333333,0.0833333,0,0,0.5,0.416667,0.0833333,0,0.125,0.5,0.5,0.0833333,0,0.25,0.5,0.583333,0.0833333,0,0.375,0.5,0.666667,0.0833333,0,0.5,0.5,0.75,0.0833333,0,0.625,0.5,0.833333,0.0833333,0,0.75,0.5,0.916667,0.0833333,0,0.875,0.5,1,0,0,1,0.5";
        "khotkeysrc"."Data_2_7_1Triggers1"."Type".value = "GESTURE";
        "khotkeysrc"."Data_2_7_1Triggers2"."GesturePointData".value =
          "0,0.0833333,1,1,0.5,0.0833333,0.0833333,1,0.875,0.5,0.166667,0.0833333,1,0.75,0.5,0.25,0.0833333,1,0.625,0.5,0.333333,0.0833333,1,0.5,0.5,0.416667,0.0833333,1,0.375,0.5,0.5,0.0833333,1,0.25,0.5,0.583333,0.0833333,1,0.125,0.5,0.666667,0.0833333,0,0,0.5,0.75,0.0833333,0,0.125,0.5,0.833333,0.0833333,0,0.25,0.5,0.916667,0.0833333,0,0.375,0.5,1,0,0,0.5,0.5";
        "khotkeysrc"."Data_2_7_1Triggers2"."Type".value = "GESTURE";
        "khotkeysrc"."Data_2_7_2"."Comment".value = "";
        "khotkeysrc"."Data_2_7_2"."Enabled".value = false;
        "khotkeysrc"."Data_2_7_2"."Name".value = "Forward";
        "khotkeysrc"."Data_2_7_2"."Type".value = "SIMPLE_ACTION_DATA";
        "khotkeysrc"."Data_2_7_2Actions"."ActionsCount".value = 1;
        "khotkeysrc"."Data_2_7_2Actions0"."DestinationWindow".value = 2;
        "khotkeysrc"."Data_2_7_2Actions0"."Input".value = "Alt+Right";
        "khotkeysrc"."Data_2_7_2Actions0"."Type".value = "KEYBOARD_INPUT";
        "khotkeysrc"."Data_2_7_2Conditions"."Comment".value = "";
        "khotkeysrc"."Data_2_7_2Conditions"."ConditionsCount".value = 0;
        "khotkeysrc"."Data_2_7_2Triggers"."Comment".value = "Gesture_triggers";
        "khotkeysrc"."Data_2_7_2Triggers"."TriggersCount".value = 3;
        "khotkeysrc"."Data_2_7_2Triggers0"."GesturePointData".value =
          "0,0.0625,0,0,0.5,0.0625,0.0625,0,0.125,0.5,0.125,0.0625,0,0.25,0.5,0.1875,0.0625,0,0.375,0.5,0.25,0.0625,0,0.5,0.5,0.3125,0.0625,0,0.625,0.5,0.375,0.0625,0,0.75,0.5,0.4375,0.0625,0,0.875,0.5,0.5,0.0625,1,1,0.5,0.5625,0.0625,1,0.875,0.5,0.625,0.0625,1,0.75,0.5,0.6875,0.0625,1,0.625,0.5,0.75,0.0625,1,0.5,0.5,0.8125,0.0625,1,0.375,0.5,0.875,0.0625,1,0.25,0.5,0.9375,0.0625,1,0.125,0.5,1,0,0,0,0.5";
        "khotkeysrc"."Data_2_7_2Triggers0"."Type".value = "GESTURE";
        "khotkeysrc"."Data_2_7_2Triggers1"."GesturePointData".value =
          "0,0.0833333,0,0.5,0.5,0.0833333,0.0833333,0,0.625,0.5,0.166667,0.0833333,0,0.75,0.5,0.25,0.0833333,0,0.875,0.5,0.333333,0.0833333,1,1,0.5,0.416667,0.0833333,1,0.875,0.5,0.5,0.0833333,1,0.75,0.5,0.583333,0.0833333,1,0.625,0.5,0.666667,0.0833333,1,0.5,0.5,0.75,0.0833333,1,0.375,0.5,0.833333,0.0833333,1,0.25,0.5,0.916667,0.0833333,1,0.125,0.5,1,0,0,0,0.5";
        "khotkeysrc"."Data_2_7_2Triggers1"."Type".value = "GESTURE";
        "khotkeysrc"."Data_2_7_2Triggers2"."GesturePointData".value =
          "0,0.0833333,0,0,0.5,0.0833333,0.0833333,0,0.125,0.5,0.166667,0.0833333,0,0.25,0.5,0.25,0.0833333,0,0.375,0.5,0.333333,0.0833333,0,0.5,0.5,0.416667,0.0833333,0,0.625,0.5,0.5,0.0833333,0,0.75,0.5,0.583333,0.0833333,0,0.875,0.5,0.666667,0.0833333,1,1,0.5,0.75,0.0833333,1,0.875,0.5,0.833333,0.0833333,1,0.75,0.5,0.916667,0.0833333,1,0.625,0.5,1,0,0,0.5,0.5";
        "khotkeysrc"."Data_2_7_2Triggers2"."Type".value = "GESTURE";
        "khotkeysrc"."Data_2_7_3"."Comment".value = "";
        "khotkeysrc"."Data_2_7_3"."Enabled".value = false;
        "khotkeysrc"."Data_2_7_3"."Name".value = "Up";
        "khotkeysrc"."Data_2_7_3"."Type".value = "SIMPLE_ACTION_DATA";
        "khotkeysrc"."Data_2_7_3Actions"."ActionsCount".value = 1;
        "khotkeysrc"."Data_2_7_3Actions0"."DestinationWindow".value = 2;
        "khotkeysrc"."Data_2_7_3Actions0"."Input".value = "Alt+Up";
        "khotkeysrc"."Data_2_7_3Actions0"."Type".value = "KEYBOARD_INPUT";
        "khotkeysrc"."Data_2_7_3Conditions"."Comment".value = "";
        "khotkeysrc"."Data_2_7_3Conditions"."ConditionsCount".value = 0;
        "khotkeysrc"."Data_2_7_3Triggers"."Comment".value = "Gesture_triggers";
        "khotkeysrc"."Data_2_7_3Triggers"."TriggersCount".value = 3;
        "khotkeysrc"."Data_2_7_3Triggers0"."GesturePointData".value =
          "0,0.0625,-0.5,0.5,1,0.0625,0.0625,-0.5,0.5,0.875,0.125,0.0625,-0.5,0.5,0.75,0.1875,0.0625,-0.5,0.5,0.625,0.25,0.0625,-0.5,0.5,0.5,0.3125,0.0625,-0.5,0.5,0.375,0.375,0.0625,-0.5,0.5,0.25,0.4375,0.0625,-0.5,0.5,0.125,0.5,0.0625,0.5,0.5,0,0.5625,0.0625,0.5,0.5,0.125,0.625,0.0625,0.5,0.5,0.25,0.6875,0.0625,0.5,0.5,0.375,0.75,0.0625,0.5,0.5,0.5,0.8125,0.0625,0.5,0.5,0.625,0.875,0.0625,0.5,0.5,0.75,0.9375,0.0625,0.5,0.5,0.875,1,0,0,0.5,1";
        "khotkeysrc"."Data_2_7_3Triggers0"."Type".value = "GESTURE";
        "khotkeysrc"."Data_2_7_3Triggers1"."GesturePointData".value =
          "0,0.0833333,-0.5,0.5,1,0.0833333,0.0833333,-0.5,0.5,0.875,0.166667,0.0833333,-0.5,0.5,0.75,0.25,0.0833333,-0.5,0.5,0.625,0.333333,0.0833333,-0.5,0.5,0.5,0.416667,0.0833333,-0.5,0.5,0.375,0.5,0.0833333,-0.5,0.5,0.25,0.583333,0.0833333,-0.5,0.5,0.125,0.666667,0.0833333,0.5,0.5,0,0.75,0.0833333,0.5,0.5,0.125,0.833333,0.0833333,0.5,0.5,0.25,0.916667,0.0833333,0.5,0.5,0.375,1,0,0,0.5,0.5";
        "khotkeysrc"."Data_2_7_3Triggers1"."Type".value = "GESTURE";
        "khotkeysrc"."Data_2_7_3Triggers2"."GesturePointData".value =
          "0,0.0833333,-0.5,0.5,0.5,0.0833333,0.0833333,-0.5,0.5,0.375,0.166667,0.0833333,-0.5,0.5,0.25,0.25,0.0833333,-0.5,0.5,0.125,0.333333,0.0833333,0.5,0.5,0,0.416667,0.0833333,0.5,0.5,0.125,0.5,0.0833333,0.5,0.5,0.25,0.583333,0.0833333,0.5,0.5,0.375,0.666667,0.0833333,0.5,0.5,0.5,0.75,0.0833333,0.5,0.5,0.625,0.833333,0.0833333,0.5,0.5,0.75,0.916667,0.0833333,0.5,0.5,0.875,1,0,0,0.5,1";
        "khotkeysrc"."Data_2_7_3Triggers2"."Type".value = "GESTURE";
        "khotkeysrc"."Data_2_7_4"."Comment".value = "";
        "khotkeysrc"."Data_2_7_4"."Enabled".value = false;
        "khotkeysrc"."Data_2_7_4"."Name".value = "Reload";
        "khotkeysrc"."Data_2_7_4"."Type".value = "SIMPLE_ACTION_DATA";
        "khotkeysrc"."Data_2_7_4Actions"."ActionsCount".value = 1;
        "khotkeysrc"."Data_2_7_4Actions0"."DestinationWindow".value = 2;
        "khotkeysrc"."Data_2_7_4Actions0"."Input".value = "F5";
        "khotkeysrc"."Data_2_7_4Actions0"."Type".value = "KEYBOARD_INPUT";
        "khotkeysrc"."Data_2_7_4Conditions"."Comment".value = "";
        "khotkeysrc"."Data_2_7_4Conditions"."ConditionsCount".value = 0;
        "khotkeysrc"."Data_2_7_4Triggers"."Comment".value = "Gesture_triggers";
        "khotkeysrc"."Data_2_7_4Triggers"."TriggersCount".value = 3;
        "khotkeysrc"."Data_2_7_4Triggers0"."GesturePointData".value =
          "0,0.03125,0,0,1,0.03125,0.03125,0,0.125,1,0.0625,0.03125,0,0.25,1,0.09375,0.03125,0,0.375,1,0.125,0.03125,0,0.5,1,0.15625,0.03125,0,0.625,1,0.1875,0.03125,0,0.75,1,0.21875,0.03125,0,0.875,1,0.25,0.03125,-0.5,1,1,0.28125,0.03125,-0.5,1,0.875,0.3125,0.03125,-0.5,1,0.75,0.34375,0.03125,-0.5,1,0.625,0.375,0.03125,-0.5,1,0.5,0.40625,0.03125,-0.5,1,0.375,0.4375,0.03125,-0.5,1,0.25,0.46875,0.03125,-0.5,1,0.125,0.5,0.03125,1,1,0,0.53125,0.03125,1,0.875,0,0.5625,0.03125,1,0.75,0,0.59375,0.03125,1,0.625,0,0.625,0.03125,1,0.5,0,0.65625,0.03125,1,0.375,0,0.6875,0.03125,1,0.25,0,0.71875,0.03125,1,0.125,0,0.75,0.03125,0.5,0,0,0.78125,0.03125,0.5,0,0.125,0.8125,0.03125,0.5,0,0.25,0.84375,0.03125,0.5,0,0.375,0.875,0.03125,0.5,0,0.5,0.90625,0.03125,0.5,0,0.625,0.9375,0.03125,0.5,0,0.75,0.96875,0.03125,0.5,0,0.875,1,0,0,0,1";
        "khotkeysrc"."Data_2_7_4Triggers0"."Type".value = "GESTURE";
        "khotkeysrc"."Data_2_7_4Triggers1"."GesturePointData".value =
          "0,0.0277778,0,0,1,0.0277778,0.0277778,0,0.125,1,0.0555556,0.0277778,0,0.25,1,0.0833333,0.0277778,0,0.375,1,0.111111,0.0277778,0,0.5,1,0.138889,0.0277778,0,0.625,1,0.166667,0.0277778,0,0.75,1,0.194444,0.0277778,0,0.875,1,0.222222,0.0277778,-0.5,1,1,0.25,0.0277778,-0.5,1,0.875,0.277778,0.0277778,-0.5,1,0.75,0.305556,0.0277778,-0.5,1,0.625,0.333333,0.0277778,-0.5,1,0.5,0.361111,0.0277778,-0.5,1,0.375,0.388889,0.0277778,-0.5,1,0.25,0.416667,0.0277778,-0.5,1,0.125,0.444444,0.0277778,1,1,0,0.472222,0.0277778,1,0.875,0,0.5,0.0277778,1,0.75,0,0.527778,0.0277778,1,0.625,0,0.555556,0.0277778,1,0.5,0,0.583333,0.0277778,1,0.375,0,0.611111,0.0277778,1,0.25,0,0.638889,0.0277778,1,0.125,0,0.666667,0.0277778,0.5,0,0,0.694444,0.0277778,0.5,0,0.125,0.722222,0.0277778,0.5,0,0.25,0.75,0.0277778,0.5,0,0.375,0.777778,0.0277778,0.5,0,0.5,0.805556,0.0277778,0.5,0,0.625,0.833333,0.0277778,0.5,0,0.75,0.861111,0.0277778,0.5,0,0.875,0.888889,0.0277778,0,0,1,0.916667,0.0277778,0,0.125,1,0.944444,0.0277778,0,0.25,1,0.972222,0.0277778,0,0.375,1,1,0,0,0.5,1";
        "khotkeysrc"."Data_2_7_4Triggers1"."Type".value = "GESTURE";
        "khotkeysrc"."Data_2_7_4Triggers2"."GesturePointData".value =
          "0,0.0277778,0.5,0,0.5,0.0277778,0.0277778,0.5,0,0.625,0.0555556,0.0277778,0.5,0,0.75,0.0833333,0.0277778,0.5,0,0.875,0.111111,0.0277778,0,0,1,0.138889,0.0277778,0,0.125,1,0.166667,0.0277778,0,0.25,1,0.194444,0.0277778,0,0.375,1,0.222222,0.0277778,0,0.5,1,0.25,0.0277778,0,0.625,1,0.277778,0.0277778,0,0.75,1,0.305556,0.0277778,0,0.875,1,0.333333,0.0277778,-0.5,1,1,0.361111,0.0277778,-0.5,1,0.875,0.388889,0.0277778,-0.5,1,0.75,0.416667,0.0277778,-0.5,1,0.625,0.444444,0.0277778,-0.5,1,0.5,0.472222,0.0277778,-0.5,1,0.375,0.5,0.0277778,-0.5,1,0.25,0.527778,0.0277778,-0.5,1,0.125,0.555556,0.0277778,1,1,0,0.583333,0.0277778,1,0.875,0,0.611111,0.0277778,1,0.75,0,0.638889,0.0277778,1,0.625,0,0.666667,0.0277778,1,0.5,0,0.694444,0.0277778,1,0.375,0,0.722222,0.0277778,1,0.25,0,0.75,0.0277778,1,0.125,0,0.777778,0.0277778,0.5,0,0,0.805556,0.0277778,0.5,0,0.125,0.833333,0.0277778,0.5,0,0.25,0.861111,0.0277778,0.5,0,0.375,0.888889,0.0277778,0.5,0,0.5,0.916667,0.0277778,0.5,0,0.625,0.944444,0.0277778,0.5,0,0.75,0.972222,0.0277778,0.5,0,0.875,1,0,0,0,1";
        "khotkeysrc"."Data_2_7_4Triggers2"."Type".value = "GESTURE";
        "khotkeysrc"."Data_2_8"."Comment".value =
          "After pressing Win+E (Tux+E) a WWW browser will be launched, and it will open http://www.kde.org . You may run all kind of commands you can run in minicli (Alt+F2).";
        "khotkeysrc"."Data_2_8"."Enabled".value = false;
        "khotkeysrc"."Data_2_8"."Name".value = "Go to KDE Website";
        "khotkeysrc"."Data_2_8"."Type".value = "SIMPLE_ACTION_DATA";
        "khotkeysrc"."Data_2_8Actions"."ActionsCount".value = 1;
        "khotkeysrc"."Data_2_8Actions0"."CommandURL".value = "http://www.kde.org";
        "khotkeysrc"."Data_2_8Actions0"."Type".value = "COMMAND_URL";
        "khotkeysrc"."Data_2_8Conditions"."Comment".value = "";
        "khotkeysrc"."Data_2_8Conditions"."ConditionsCount".value = 0;
        "khotkeysrc"."Data_2_8Triggers"."Comment".value = "Simple_action";
        "khotkeysrc"."Data_2_8Triggers"."TriggersCount".value = 1;
        "khotkeysrc"."Data_2_8Triggers0"."Key".value = "Meta+E";
        "khotkeysrc"."Data_2_8Triggers0"."Type".value = "SHORTCUT";
        "khotkeysrc"."Data_2_8Triggers0"."Uuid".value = "{2f085245-1b22-41e1-a8ec-efeb536790f3}";
        "khotkeysrc"."Data_3"."Comment".value = "Basic Konqueror gestures.";
        "khotkeysrc"."Data_3"."DataCount".value = 14;
        "khotkeysrc"."Data_3"."Enabled".value = true;
        "khotkeysrc"."Data_3"."ImportId".value = "konqueror_gestures_kde321";
        "khotkeysrc"."Data_3"."Name".value = "Konqueror Gestures";
        "khotkeysrc"."Data_3"."SystemGroup".value = 0;
        "khotkeysrc"."Data_3"."Type".value = "ACTION_DATA_GROUP";
        "khotkeysrc"."Data_3Conditions"."Comment".value = "Konqueror window";
        "khotkeysrc"."Data_3Conditions"."ConditionsCount".value = 1;
        "khotkeysrc"."Data_3Conditions0"."Type".value = "ACTIVE_WINDOW";
        "khotkeysrc"."Data_3Conditions0Window"."Comment".value = "Konqueror";
        "khotkeysrc"."Data_3Conditions0Window"."WindowsCount".value = 1;
        "khotkeysrc"."Data_3Conditions0Window0"."Class".value = "^konquerors";
        "khotkeysrc"."Data_3Conditions0Window0"."ClassType".value = 3;
        "khotkeysrc"."Data_3Conditions0Window0"."Comment".value = "Konqueror";
        "khotkeysrc"."Data_3Conditions0Window0"."Role".value = "konqueror-mainwindow#1";
        "khotkeysrc"."Data_3Conditions0Window0"."RoleType".value = 0;
        "khotkeysrc"."Data_3Conditions0Window0"."Title".value = "file:/ - Konqueror";
        "khotkeysrc"."Data_3Conditions0Window0"."TitleType".value = 0;
        "khotkeysrc"."Data_3Conditions0Window0"."Type".value = "SIMPLE";
        "khotkeysrc"."Data_3Conditions0Window0"."WindowTypes".value = 1;
        "khotkeysrc"."Data_3_1"."Comment".value = "Press, move left, release.";
        "khotkeysrc"."Data_3_1"."Enabled".value = true;
        "khotkeysrc"."Data_3_1"."Name".value = "Back";
        "khotkeysrc"."Data_3_1"."Type".value = "SIMPLE_ACTION_DATA";
        "khotkeysrc"."Data_3_10"."Comment".value = ''
          Opera-style: Press, move up, release.
          NOTE: Conflicts with 'New Tab', and as such is disabled by default.'';
        "khotkeysrc"."Data_3_10"."Enabled".value = false;
        "khotkeysrc"."Data_3_10"."Name".value = "Stop Loading";
        "khotkeysrc"."Data_3_10"."Type".value = "SIMPLE_ACTION_DATA";
        "khotkeysrc"."Data_3_10Actions"."ActionsCount".value = 1;
        "khotkeysrc"."Data_3_10Actions0"."DestinationWindow".value = 2;
        "khotkeysrc"."Data_3_10Actions0"."Input".value = ''
          Escape
        '';
        "khotkeysrc"."Data_3_10Actions0"."Type".value = "KEYBOARD_INPUT";
        "khotkeysrc"."Data_3_10Conditions"."Comment".value = "";
        "khotkeysrc"."Data_3_10Conditions"."ConditionsCount".value = 0;
        "khotkeysrc"."Data_3_10Triggers"."Comment".value = "Gesture_triggers";
        "khotkeysrc"."Data_3_10Triggers"."TriggersCount".value = 1;
        "khotkeysrc"."Data_3_10Triggers0"."GesturePointData".value =
          "0,0.125,-0.5,0.5,1,0.125,0.125,-0.5,0.5,0.875,0.25,0.125,-0.5,0.5,0.75,0.375,0.125,-0.5,0.5,0.625,0.5,0.125,-0.5,0.5,0.5,0.625,0.125,-0.5,0.5,0.375,0.75,0.125,-0.5,0.5,0.25,0.875,0.125,-0.5,0.5,0.125,1,0,0,0.5,0";
        "khotkeysrc"."Data_3_10Triggers0"."Type".value = "GESTURE";
        "khotkeysrc"."Data_3_11"."Comment".value = ''
          Going up in URL/directory structure.
          Mozilla-style: Press, move up, move left, move up, release.'';
        "khotkeysrc"."Data_3_11"."Enabled".value = true;
        "khotkeysrc"."Data_3_11"."Name".value = "Up";
        "khotkeysrc"."Data_3_11"."Type".value = "SIMPLE_ACTION_DATA";
        "khotkeysrc"."Data_3_11Actions"."ActionsCount".value = 1;
        "khotkeysrc"."Data_3_11Actions0"."DestinationWindow".value = 2;
        "khotkeysrc"."Data_3_11Actions0"."Input".value = "Alt+Up";
        "khotkeysrc"."Data_3_11Actions0"."Type".value = "KEYBOARD_INPUT";
        "khotkeysrc"."Data_3_11Conditions"."Comment".value = "";
        "khotkeysrc"."Data_3_11Conditions"."ConditionsCount".value = 0;
        "khotkeysrc"."Data_3_11Triggers"."Comment".value = "Gesture_triggers";
        "khotkeysrc"."Data_3_11Triggers"."TriggersCount".value = 1;
        "khotkeysrc"."Data_3_11Triggers0"."GesturePointData".value =
          "0,0.0625,-0.5,1,1,0.0625,0.0625,-0.5,1,0.875,0.125,0.0625,-0.5,1,0.75,0.1875,0.0625,-0.5,1,0.625,0.25,0.0625,1,1,0.5,0.3125,0.0625,1,0.875,0.5,0.375,0.0625,1,0.75,0.5,0.4375,0.0625,1,0.625,0.5,0.5,0.0625,1,0.5,0.5,0.5625,0.0625,1,0.375,0.5,0.625,0.0625,1,0.25,0.5,0.6875,0.0625,1,0.125,0.5,0.75,0.0625,-0.5,0,0.5,0.8125,0.0625,-0.5,0,0.375,0.875,0.0625,-0.5,0,0.25,0.9375,0.0625,-0.5,0,0.125,1,0,0,0,0";
        "khotkeysrc"."Data_3_11Triggers0"."Type".value = "GESTURE";
        "khotkeysrc"."Data_3_12"."Comment".value = ''
          Going up in URL/directory structure.
          Opera-style: Press, move up, move left, move up, release.
          NOTE: Conflicts with  "Activate Previous Tab", and as such is disabled by default.'';
        "khotkeysrc"."Data_3_12"."Enabled".value = false;
        "khotkeysrc"."Data_3_12"."Name".value = "Up #2";
        "khotkeysrc"."Data_3_12"."Type".value = "SIMPLE_ACTION_DATA";
        "khotkeysrc"."Data_3_12Actions"."ActionsCount".value = 1;
        "khotkeysrc"."Data_3_12Actions0"."DestinationWindow".value = 2;
        "khotkeysrc"."Data_3_12Actions0"."Input".value = ''
          Alt+Up
        '';
        "khotkeysrc"."Data_3_12Actions0"."Type".value = "KEYBOARD_INPUT";
        "khotkeysrc"."Data_3_12Conditions"."Comment".value = "";
        "khotkeysrc"."Data_3_12Conditions"."ConditionsCount".value = 0;
        "khotkeysrc"."Data_3_12Triggers"."Comment".value = "Gesture_triggers";
        "khotkeysrc"."Data_3_12Triggers"."TriggersCount".value = 1;
        "khotkeysrc"."Data_3_12Triggers0"."GesturePointData".value =
          "0,0.0625,-0.5,1,1,0.0625,0.0625,-0.5,1,0.875,0.125,0.0625,-0.5,1,0.75,0.1875,0.0625,-0.5,1,0.625,0.25,0.0625,-0.5,1,0.5,0.3125,0.0625,-0.5,1,0.375,0.375,0.0625,-0.5,1,0.25,0.4375,0.0625,-0.5,1,0.125,0.5,0.0625,1,1,0,0.5625,0.0625,1,0.875,0,0.625,0.0625,1,0.75,0,0.6875,0.0625,1,0.625,0,0.75,0.0625,1,0.5,0,0.8125,0.0625,1,0.375,0,0.875,0.0625,1,0.25,0,0.9375,0.0625,1,0.125,0,1,0,0,0,0";
        "khotkeysrc"."Data_3_12Triggers0"."Type".value = "GESTURE";
        "khotkeysrc"."Data_3_13"."Comment".value = "Press, move up, move right, release.";
        "khotkeysrc"."Data_3_13"."Enabled".value = true;
        "khotkeysrc"."Data_3_13"."Name".value = "Activate Next Tab";
        "khotkeysrc"."Data_3_13"."Type".value = "SIMPLE_ACTION_DATA";
        "khotkeysrc"."Data_3_13Actions"."ActionsCount".value = 1;
        "khotkeysrc"."Data_3_13Actions0"."DestinationWindow".value = 2;
        "khotkeysrc"."Data_3_13Actions0"."Input".value = ''
          Ctrl+.
        '';
        "khotkeysrc"."Data_3_13Actions0"."Type".value = "KEYBOARD_INPUT";
        "khotkeysrc"."Data_3_13Conditions"."Comment".value = "";
        "khotkeysrc"."Data_3_13Conditions"."ConditionsCount".value = 0;
        "khotkeysrc"."Data_3_13Triggers"."Comment".value = "Gesture_triggers";
        "khotkeysrc"."Data_3_13Triggers"."TriggersCount".value = 1;
        "khotkeysrc"."Data_3_13Triggers0"."GesturePointData".value =
          "0,0.0625,-0.5,0,1,0.0625,0.0625,-0.5,0,0.875,0.125,0.0625,-0.5,0,0.75,0.1875,0.0625,-0.5,0,0.625,0.25,0.0625,-0.5,0,0.5,0.3125,0.0625,-0.5,0,0.375,0.375,0.0625,-0.5,0,0.25,0.4375,0.0625,-0.5,0,0.125,0.5,0.0625,0,0,0,0.5625,0.0625,0,0.125,0,0.625,0.0625,0,0.25,0,0.6875,0.0625,0,0.375,0,0.75,0.0625,0,0.5,0,0.8125,0.0625,0,0.625,0,0.875,0.0625,0,0.75,0,0.9375,0.0625,0,0.875,0,1,0,0,1,0";
        "khotkeysrc"."Data_3_13Triggers0"."Type".value = "GESTURE";
        "khotkeysrc"."Data_3_14"."Comment".value = "Press, move up, move left, release.";
        "khotkeysrc"."Data_3_14"."Enabled".value = true;
        "khotkeysrc"."Data_3_14"."Name".value = "Activate Previous Tab";
        "khotkeysrc"."Data_3_14"."Type".value = "SIMPLE_ACTION_DATA";
        "khotkeysrc"."Data_3_14Actions"."ActionsCount".value = 1;
        "khotkeysrc"."Data_3_14Actions0"."DestinationWindow".value = 2;
        "khotkeysrc"."Data_3_14Actions0"."Input".value = "Ctrl+,";
        "khotkeysrc"."Data_3_14Actions0"."Type".value = "KEYBOARD_INPUT";
        "khotkeysrc"."Data_3_14Conditions"."Comment".value = "";
        "khotkeysrc"."Data_3_14Conditions"."ConditionsCount".value = 0;
        "khotkeysrc"."Data_3_14Triggers"."Comment".value = "Gesture_triggers";
        "khotkeysrc"."Data_3_14Triggers"."TriggersCount".value = 1;
        "khotkeysrc"."Data_3_14Triggers0"."GesturePointData".value =
          "0,0.0625,-0.5,1,1,0.0625,0.0625,-0.5,1,0.875,0.125,0.0625,-0.5,1,0.75,0.1875,0.0625,-0.5,1,0.625,0.25,0.0625,-0.5,1,0.5,0.3125,0.0625,-0.5,1,0.375,0.375,0.0625,-0.5,1,0.25,0.4375,0.0625,-0.5,1,0.125,0.5,0.0625,1,1,0,0.5625,0.0625,1,0.875,0,0.625,0.0625,1,0.75,0,0.6875,0.0625,1,0.625,0,0.75,0.0625,1,0.5,0,0.8125,0.0625,1,0.375,0,0.875,0.0625,1,0.25,0,0.9375,0.0625,1,0.125,0,1,0,0,0,0";
        "khotkeysrc"."Data_3_14Triggers0"."Type".value = "GESTURE";
        "khotkeysrc"."Data_3_1Actions"."ActionsCount".value = 1;
        "khotkeysrc"."Data_3_1Actions0"."DestinationWindow".value = 2;
        "khotkeysrc"."Data_3_1Actions0"."Input".value = "Alt+Left";
        "khotkeysrc"."Data_3_1Actions0"."Type".value = "KEYBOARD_INPUT";
        "khotkeysrc"."Data_3_1Conditions"."Comment".value = "";
        "khotkeysrc"."Data_3_1Conditions"."ConditionsCount".value = 0;
        "khotkeysrc"."Data_3_1Triggers"."Comment".value = "Gesture_triggers";
        "khotkeysrc"."Data_3_1Triggers"."TriggersCount".value = 1;
        "khotkeysrc"."Data_3_1Triggers0"."GesturePointData".value =
          "0,0.125,1,1,0.5,0.125,0.125,1,0.875,0.5,0.25,0.125,1,0.75,0.5,0.375,0.125,1,0.625,0.5,0.5,0.125,1,0.5,0.5,0.625,0.125,1,0.375,0.5,0.75,0.125,1,0.25,0.5,0.875,0.125,1,0.125,0.5,1,0,0,0,0.5";
        "khotkeysrc"."Data_3_1Triggers0"."Type".value = "GESTURE";
        "khotkeysrc"."Data_3_2"."Comment".value = "Press, move down, move up, move down, release.";
        "khotkeysrc"."Data_3_2"."Enabled".value = true;
        "khotkeysrc"."Data_3_2"."Name".value = "Duplicate Tab";
        "khotkeysrc"."Data_3_2"."Type".value = "SIMPLE_ACTION_DATA";
        "khotkeysrc"."Data_3_2Actions"."ActionsCount".value = 1;
        "khotkeysrc"."Data_3_2Actions0"."DestinationWindow".value = 2;
        "khotkeysrc"."Data_3_2Actions0"."Input".value = ''
          Ctrl+Shift+D
        '';
        "khotkeysrc"."Data_3_2Actions0"."Type".value = "KEYBOARD_INPUT";
        "khotkeysrc"."Data_3_2Conditions"."Comment".value = "";
        "khotkeysrc"."Data_3_2Conditions"."ConditionsCount".value = 0;
        "khotkeysrc"."Data_3_2Triggers"."Comment".value = "Gesture_triggers";
        "khotkeysrc"."Data_3_2Triggers"."TriggersCount".value = 1;
        "khotkeysrc"."Data_3_2Triggers0"."GesturePointData".value =
          "0,0.0416667,0.5,0.5,0,0.0416667,0.0416667,0.5,0.5,0.125,0.0833333,0.0416667,0.5,0.5,0.25,0.125,0.0416667,0.5,0.5,0.375,0.166667,0.0416667,0.5,0.5,0.5,0.208333,0.0416667,0.5,0.5,0.625,0.25,0.0416667,0.5,0.5,0.75,0.291667,0.0416667,0.5,0.5,0.875,0.333333,0.0416667,-0.5,0.5,1,0.375,0.0416667,-0.5,0.5,0.875,0.416667,0.0416667,-0.5,0.5,0.75,0.458333,0.0416667,-0.5,0.5,0.625,0.5,0.0416667,-0.5,0.5,0.5,0.541667,0.0416667,-0.5,0.5,0.375,0.583333,0.0416667,-0.5,0.5,0.25,0.625,0.0416667,-0.5,0.5,0.125,0.666667,0.0416667,0.5,0.5,0,0.708333,0.0416667,0.5,0.5,0.125,0.75,0.0416667,0.5,0.5,0.25,0.791667,0.0416667,0.5,0.5,0.375,0.833333,0.0416667,0.5,0.5,0.5,0.875,0.0416667,0.5,0.5,0.625,0.916667,0.0416667,0.5,0.5,0.75,0.958333,0.0416667,0.5,0.5,0.875,1,0,0,0.5,1";
        "khotkeysrc"."Data_3_2Triggers0"."Type".value = "GESTURE";
        "khotkeysrc"."Data_3_3"."Comment".value = "Press, move down, move up, release.";
        "khotkeysrc"."Data_3_3"."Enabled".value = true;
        "khotkeysrc"."Data_3_3"."Name".value = "Duplicate Window";
        "khotkeysrc"."Data_3_3"."Type".value = "SIMPLE_ACTION_DATA";
        "khotkeysrc"."Data_3_3Actions"."ActionsCount".value = 1;
        "khotkeysrc"."Data_3_3Actions0"."DestinationWindow".value = 2;
        "khotkeysrc"."Data_3_3Actions0"."Input".value = ''
          Ctrl+D
        '';
        "khotkeysrc"."Data_3_3Actions0"."Type".value = "KEYBOARD_INPUT";
        "khotkeysrc"."Data_3_3Conditions"."Comment".value = "";
        "khotkeysrc"."Data_3_3Conditions"."ConditionsCount".value = 0;
        "khotkeysrc"."Data_3_3Triggers"."Comment".value = "Gesture_triggers";
        "khotkeysrc"."Data_3_3Triggers"."TriggersCount".value = 1;
        "khotkeysrc"."Data_3_3Triggers0"."GesturePointData".value =
          "0,0.0625,0.5,0.5,0,0.0625,0.0625,0.5,0.5,0.125,0.125,0.0625,0.5,0.5,0.25,0.1875,0.0625,0.5,0.5,0.375,0.25,0.0625,0.5,0.5,0.5,0.3125,0.0625,0.5,0.5,0.625,0.375,0.0625,0.5,0.5,0.75,0.4375,0.0625,0.5,0.5,0.875,0.5,0.0625,-0.5,0.5,1,0.5625,0.0625,-0.5,0.5,0.875,0.625,0.0625,-0.5,0.5,0.75,0.6875,0.0625,-0.5,0.5,0.625,0.75,0.0625,-0.5,0.5,0.5,0.8125,0.0625,-0.5,0.5,0.375,0.875,0.0625,-0.5,0.5,0.25,0.9375,0.0625,-0.5,0.5,0.125,1,0,0,0.5,0";
        "khotkeysrc"."Data_3_3Triggers0"."Type".value = "GESTURE";
        "khotkeysrc"."Data_3_4"."Comment".value = "Press, move right, release.";
        "khotkeysrc"."Data_3_4"."Enabled".value = true;
        "khotkeysrc"."Data_3_4"."Name".value = "Forward";
        "khotkeysrc"."Data_3_4"."Type".value = "SIMPLE_ACTION_DATA";
        "khotkeysrc"."Data_3_4Actions"."ActionsCount".value = 1;
        "khotkeysrc"."Data_3_4Actions0"."DestinationWindow".value = 2;
        "khotkeysrc"."Data_3_4Actions0"."Input".value = "Alt+Right";
        "khotkeysrc"."Data_3_4Actions0"."Type".value = "KEYBOARD_INPUT";
        "khotkeysrc"."Data_3_4Conditions"."Comment".value = "";
        "khotkeysrc"."Data_3_4Conditions"."ConditionsCount".value = 0;
        "khotkeysrc"."Data_3_4Triggers"."Comment".value = "Gesture_triggers";
        "khotkeysrc"."Data_3_4Triggers"."TriggersCount".value = 1;
        "khotkeysrc"."Data_3_4Triggers0"."GesturePointData".value =
          "0,0.125,0,0,0.5,0.125,0.125,0,0.125,0.5,0.25,0.125,0,0.25,0.5,0.375,0.125,0,0.375,0.5,0.5,0.125,0,0.5,0.5,0.625,0.125,0,0.625,0.5,0.75,0.125,0,0.75,0.5,0.875,0.125,0,0.875,0.5,1,0,0,1,0.5";
        "khotkeysrc"."Data_3_4Triggers0"."Type".value = "GESTURE";
        "khotkeysrc"."Data_3_5"."Comment".value = ''
          Press, move down, move half up, move right, move down, release.
          (Drawing a lowercase 'h'.)'';
        "khotkeysrc"."Data_3_5"."Enabled".value = true;
        "khotkeysrc"."Data_3_5"."Name".value = "Home";
        "khotkeysrc"."Data_3_5"."Type".value = "SIMPLE_ACTION_DATA";
        "khotkeysrc"."Data_3_5Actions"."ActionsCount".value = 1;
        "khotkeysrc"."Data_3_5Actions0"."DestinationWindow".value = 2;
        "khotkeysrc"."Data_3_5Actions0"."Input".value = ''
          Alt+Home
        '';
        "khotkeysrc"."Data_3_5Actions0"."Type".value = "KEYBOARD_INPUT";
        "khotkeysrc"."Data_3_5Conditions"."Comment".value = "";
        "khotkeysrc"."Data_3_5Conditions"."ConditionsCount".value = 0;
        "khotkeysrc"."Data_3_5Triggers"."Comment".value = "Gesture_triggers";
        "khotkeysrc"."Data_3_5Triggers"."TriggersCount".value = 2;
        "khotkeysrc"."Data_3_5Triggers0"."GesturePointData".value =
          "0,0.0461748,0.5,0,0,0.0461748,0.0461748,0.5,0,0.125,0.0923495,0.0461748,0.5,0,0.25,0.138524,0.0461748,0.5,0,0.375,0.184699,0.0461748,0.5,0,0.5,0.230874,0.0461748,0.5,0,0.625,0.277049,0.0461748,0.5,0,0.75,0.323223,0.0461748,0.5,0,0.875,0.369398,0.065301,-0.25,0,1,0.434699,0.065301,-0.25,0.125,0.875,0.5,0.065301,-0.25,0.25,0.75,0.565301,0.065301,-0.25,0.375,0.625,0.630602,0.0461748,0,0.5,0.5,0.676777,0.0461748,0,0.625,0.5,0.722951,0.0461748,0,0.75,0.5,0.769126,0.0461748,0,0.875,0.5,0.815301,0.0461748,0.5,1,0.5,0.861476,0.0461748,0.5,1,0.625,0.90765,0.0461748,0.5,1,0.75,0.953825,0.0461748,0.5,1,0.875,1,0,0,1,1";
        "khotkeysrc"."Data_3_5Triggers0"."Type".value = "GESTURE";
        "khotkeysrc"."Data_3_5Triggers1"."GesturePointData".value =
          "0,0.0416667,0.5,0,0,0.0416667,0.0416667,0.5,0,0.125,0.0833333,0.0416667,0.5,0,0.25,0.125,0.0416667,0.5,0,0.375,0.166667,0.0416667,0.5,0,0.5,0.208333,0.0416667,0.5,0,0.625,0.25,0.0416667,0.5,0,0.75,0.291667,0.0416667,0.5,0,0.875,0.333333,0.0416667,-0.5,0,1,0.375,0.0416667,-0.5,0,0.875,0.416667,0.0416667,-0.5,0,0.75,0.458333,0.0416667,-0.5,0,0.625,0.5,0.0416667,0,0,0.5,0.541667,0.0416667,0,0.125,0.5,0.583333,0.0416667,0,0.25,0.5,0.625,0.0416667,0,0.375,0.5,0.666667,0.0416667,0,0.5,0.5,0.708333,0.0416667,0,0.625,0.5,0.75,0.0416667,0,0.75,0.5,0.791667,0.0416667,0,0.875,0.5,0.833333,0.0416667,0.5,1,0.5,0.875,0.0416667,0.5,1,0.625,0.916667,0.0416667,0.5,1,0.75,0.958333,0.0416667,0.5,1,0.875,1,0,0,1,1";
        "khotkeysrc"."Data_3_5Triggers1"."Type".value = "GESTURE";
        "khotkeysrc"."Data_3_6"."Comment".value = ''
          Press, move right, move down, move right, release.
          Mozilla-style: Press, move down, move right, release.'';
        "khotkeysrc"."Data_3_6"."Enabled".value = true;
        "khotkeysrc"."Data_3_6"."Name".value = "Close Tab";
        "khotkeysrc"."Data_3_6"."Type".value = "SIMPLE_ACTION_DATA";
        "khotkeysrc"."Data_3_6Actions"."ActionsCount".value = 1;
        "khotkeysrc"."Data_3_6Actions0"."DestinationWindow".value = 2;
        "khotkeysrc"."Data_3_6Actions0"."Input".value = ''
          Ctrl+W
        '';
        "khotkeysrc"."Data_3_6Actions0"."Type".value = "KEYBOARD_INPUT";
        "khotkeysrc"."Data_3_6Conditions"."Comment".value = "";
        "khotkeysrc"."Data_3_6Conditions"."ConditionsCount".value = 0;
        "khotkeysrc"."Data_3_6Triggers"."Comment".value = "Gesture_triggers";
        "khotkeysrc"."Data_3_6Triggers"."TriggersCount".value = 2;
        "khotkeysrc"."Data_3_6Triggers0"."GesturePointData".value =
          "0,0.0625,0,0,0,0.0625,0.0625,0,0.125,0,0.125,0.0625,0,0.25,0,0.1875,0.0625,0,0.375,0,0.25,0.0625,0.5,0.5,0,0.3125,0.0625,0.5,0.5,0.125,0.375,0.0625,0.5,0.5,0.25,0.4375,0.0625,0.5,0.5,0.375,0.5,0.0625,0.5,0.5,0.5,0.5625,0.0625,0.5,0.5,0.625,0.625,0.0625,0.5,0.5,0.75,0.6875,0.0625,0.5,0.5,0.875,0.75,0.0625,0,0.5,1,0.8125,0.0625,0,0.625,1,0.875,0.0625,0,0.75,1,0.9375,0.0625,0,0.875,1,1,0,0,1,1";
        "khotkeysrc"."Data_3_6Triggers0"."Type".value = "GESTURE";
        "khotkeysrc"."Data_3_6Triggers1"."GesturePointData".value =
          "0,0.0625,0.5,0,0,0.0625,0.0625,0.5,0,0.125,0.125,0.0625,0.5,0,0.25,0.1875,0.0625,0.5,0,0.375,0.25,0.0625,0.5,0,0.5,0.3125,0.0625,0.5,0,0.625,0.375,0.0625,0.5,0,0.75,0.4375,0.0625,0.5,0,0.875,0.5,0.0625,0,0,1,0.5625,0.0625,0,0.125,1,0.625,0.0625,0,0.25,1,0.6875,0.0625,0,0.375,1,0.75,0.0625,0,0.5,1,0.8125,0.0625,0,0.625,1,0.875,0.0625,0,0.75,1,0.9375,0.0625,0,0.875,1,1,0,0,1,1";
        "khotkeysrc"."Data_3_6Triggers1"."Type".value = "GESTURE";
        "khotkeysrc"."Data_3_7"."Comment".value = ''
          Press, move up, release.
          Conflicts with Opera-style 'Up #2', which is disabled by default.'';
        "khotkeysrc"."Data_3_7"."Enabled".value = true;
        "khotkeysrc"."Data_3_7"."Name".value = "New Tab";
        "khotkeysrc"."Data_3_7"."Type".value = "SIMPLE_ACTION_DATA";
        "khotkeysrc"."Data_3_7Actions"."ActionsCount".value = 1;
        "khotkeysrc"."Data_3_7Actions0"."DestinationWindow".value = 2;
        "khotkeysrc"."Data_3_7Actions0"."Input".value = "Ctrl+Shift+N";
        "khotkeysrc"."Data_3_7Actions0"."Type".value = "KEYBOARD_INPUT";
        "khotkeysrc"."Data_3_7Conditions"."Comment".value = "";
        "khotkeysrc"."Data_3_7Conditions"."ConditionsCount".value = 0;
        "khotkeysrc"."Data_3_7Triggers"."Comment".value = "Gesture_triggers";
        "khotkeysrc"."Data_3_7Triggers"."TriggersCount".value = 1;
        "khotkeysrc"."Data_3_7Triggers0"."GesturePointData".value =
          "0,0.125,-0.5,0.5,1,0.125,0.125,-0.5,0.5,0.875,0.25,0.125,-0.5,0.5,0.75,0.375,0.125,-0.5,0.5,0.625,0.5,0.125,-0.5,0.5,0.5,0.625,0.125,-0.5,0.5,0.375,0.75,0.125,-0.5,0.5,0.25,0.875,0.125,-0.5,0.5,0.125,1,0,0,0.5,0";
        "khotkeysrc"."Data_3_7Triggers0"."Type".value = "GESTURE";
        "khotkeysrc"."Data_3_8"."Comment".value = "Press, move down, release.";
        "khotkeysrc"."Data_3_8"."Enabled".value = true;
        "khotkeysrc"."Data_3_8"."Name".value = "New Window";
        "khotkeysrc"."Data_3_8"."Type".value = "SIMPLE_ACTION_DATA";
        "khotkeysrc"."Data_3_8Actions"."ActionsCount".value = 1;
        "khotkeysrc"."Data_3_8Actions0"."DestinationWindow".value = 2;
        "khotkeysrc"."Data_3_8Actions0"."Input".value = ''
          Ctrl+N
        '';
        "khotkeysrc"."Data_3_8Actions0"."Type".value = "KEYBOARD_INPUT";
        "khotkeysrc"."Data_3_8Conditions"."Comment".value = "";
        "khotkeysrc"."Data_3_8Conditions"."ConditionsCount".value = 0;
        "khotkeysrc"."Data_3_8Triggers"."Comment".value = "Gesture_triggers";
        "khotkeysrc"."Data_3_8Triggers"."TriggersCount".value = 1;
        "khotkeysrc"."Data_3_8Triggers0"."GesturePointData".value =
          "0,0.125,0.5,0.5,0,0.125,0.125,0.5,0.5,0.125,0.25,0.125,0.5,0.5,0.25,0.375,0.125,0.5,0.5,0.375,0.5,0.125,0.5,0.5,0.5,0.625,0.125,0.5,0.5,0.625,0.75,0.125,0.5,0.5,0.75,0.875,0.125,0.5,0.5,0.875,1,0,0,0.5,1";
        "khotkeysrc"."Data_3_8Triggers0"."Type".value = "GESTURE";
        "khotkeysrc"."Data_3_9"."Comment".value = "Press, move up, move down, release.";
        "khotkeysrc"."Data_3_9"."Enabled".value = true;
        "khotkeysrc"."Data_3_9"."Name".value = "Reload";
        "khotkeysrc"."Data_3_9"."Type".value = "SIMPLE_ACTION_DATA";
        "khotkeysrc"."Data_3_9Actions"."ActionsCount".value = 1;
        "khotkeysrc"."Data_3_9Actions0"."DestinationWindow".value = 2;
        "khotkeysrc"."Data_3_9Actions0"."Input".value = "F5";
        "khotkeysrc"."Data_3_9Actions0"."Type".value = "KEYBOARD_INPUT";
        "khotkeysrc"."Data_3_9Conditions"."Comment".value = "";
        "khotkeysrc"."Data_3_9Conditions"."ConditionsCount".value = 0;
        "khotkeysrc"."Data_3_9Triggers"."Comment".value = "Gesture_triggers";
        "khotkeysrc"."Data_3_9Triggers"."TriggersCount".value = 1;
        "khotkeysrc"."Data_3_9Triggers0"."GesturePointData".value =
          "0,0.0625,-0.5,0.5,1,0.0625,0.0625,-0.5,0.5,0.875,0.125,0.0625,-0.5,0.5,0.75,0.1875,0.0625,-0.5,0.5,0.625,0.25,0.0625,-0.5,0.5,0.5,0.3125,0.0625,-0.5,0.5,0.375,0.375,0.0625,-0.5,0.5,0.25,0.4375,0.0625,-0.5,0.5,0.125,0.5,0.0625,0.5,0.5,0,0.5625,0.0625,0.5,0.5,0.125,0.625,0.0625,0.5,0.5,0.25,0.6875,0.0625,0.5,0.5,0.375,0.75,0.0625,0.5,0.5,0.5,0.8125,0.0625,0.5,0.5,0.625,0.875,0.0625,0.5,0.5,0.75,0.9375,0.0625,0.5,0.5,0.875,1,0,0,0.5,1";
        "khotkeysrc"."Data_3_9Triggers0"."Type".value = "GESTURE";
        "khotkeysrc"."General"."AllowKDEAppsToRememberWindowPositions[$d]".value = "";
        "khotkeysrc"."General"."BrowserApplication[$d]".value = "";
        "khotkeysrc"."General"."ColorSchemeHash[$d]".value = "";
        "khotkeysrc"."General"."ColorScheme[$d]".value = "";
        "khotkeysrc"."General"."UseSystemBell[$d]".value = "";
        "khotkeysrc"."Gestures"."Disabled".value = true;
        "khotkeysrc"."Gestures"."MouseButton".value = 2;
        "khotkeysrc"."Gestures"."Timeout".value = 300;
        "khotkeysrc"."GesturesExclude"."Comment".value = "";
        "khotkeysrc"."GesturesExclude"."WindowsCount".value = 0;
        "khotkeysrc"."Icons"."Theme[$d]".value = "";
        "khotkeysrc"."KDE"."LookAndFeelPackage[$d]".value = "";
        "khotkeysrc"."KDE"."SingleClick[$d]".value = "";
        "khotkeysrc"."KDE"."widgetStyle[$d]".value = "";
        "khotkeysrc"."KFileDialog Settings"."Allow Expansion[$d]".value = "";
        "khotkeysrc"."KFileDialog Settings"."Automatically select filename extension[$d]".value = "";
        "khotkeysrc"."KFileDialog Settings"."Breadcrumb Navigation[$d]".value = "";
        "khotkeysrc"."KFileDialog Settings"."Decoration position[$d]".value = "";
        "khotkeysrc"."KFileDialog Settings"."LocationCombo Completionmode[$d]".value = "";
        "khotkeysrc"."KFileDialog Settings"."PathCombo Completionmode[$d]".value = "";
        "khotkeysrc"."KFileDialog Settings"."Show Bookmarks[$d]".value = "";
        "khotkeysrc"."KFileDialog Settings"."Show Full Path[$d]".value = "";
        "khotkeysrc"."KFileDialog Settings"."Show Inline Previews[$d]".value = "";
        "khotkeysrc"."KFileDialog Settings"."Show Speedbar[$d]".value = "";
        "khotkeysrc"."KFileDialog Settings"."Show hidden files[$d]".value = "";
        "khotkeysrc"."KFileDialog Settings"."Sort by[$d]".value = "";
        "khotkeysrc"."KFileDialog Settings"."Sort directories first[$d]".value = "";
        "khotkeysrc"."KFileDialog Settings"."Sort hidden files last[$d]".value = "";
        "khotkeysrc"."KFileDialog Settings"."Sort reversed[$d]".value = "";
        "khotkeysrc"."KFileDialog Settings"."Speedbar Width[$d]".value = "";
        "khotkeysrc"."KFileDialog Settings"."View Style[$d]".value = "";
        "khotkeysrc"."KScreen"."ScreenScaleFactors[$d]".value = "";
        "khotkeysrc"."Main"."AlreadyImported".value = "defaults,kde32b1,konqueror_gestures_kde321";
        "khotkeysrc"."Main"."Disabled".value = false;
        "khotkeysrc"."Voice"."Shortcut".value = "";
        "khotkeysrc"."WM"."activeBackground[$d]".value = "";
        "khotkeysrc"."WM"."activeBlend[$d]".value = "";
        "khotkeysrc"."WM"."activeForeground[$d]".value = "";
        "khotkeysrc"."WM"."inactiveBackground[$d]".value = "";
        "khotkeysrc"."WM"."inactiveBlend[$d]".value = "";
        "khotkeysrc"."WM"."inactiveForeground[$d]".value = "";
        "kwalletrc"."Wallet"."First Use".value = false;
        "kwinrc"."Xwayland"."Scale".value = 1.25;
        "kwinrc"."Plugins"."contrastEnabled".value = false;
        "kxkbrc"."Layout"."Options".value = "caps:swapescape";
        "kxkbrc"."Layout"."ResetOldOptions".value = true;
        "plasma-localerc"."Formats"."LANG".value = "en_US.UTF-8";
        "plasmanotifyrc"."DoNotDisturb"."NotificationSoundsMuted".value = true;
        "plasmanotifyrc"."DoNotDisturb"."Until".value = "2025,4,16,23,38,52.564";
        "plasmanotifyrc"."Notifications"."PopupPosition".value = "TopRight";
        "kscreenlockerrc"."Greeter"."WallpaperPlugin".value = "org.kde.image";
        # This can cause screen locking due to an insane bug, see:
        # https://forum.manjaro.org/t/plasmashell-freeze-after-getting-out-of-hibernation-howto-troubleshoot/153078/14
        "kscreenlockerrc"."Greeter/Wallpaper/org.kde.image/General"."Image".value =
          "${../assets/animals.png}";
        "kscreenlockerrc"."Greeter/Wallpaper/org.kde.image/General"."PreviewImage".value =
          "${../assets/animals.png}";
      };
      panels = [
        {
          location = "left";
          floating = true;
          height = 64;
          widgets = [
            "org.kde.plasma.kickoff"
            "org.kde.plasma.pager"
            {
              name = "org.kde.plasma.icontasks";
              config = {
                General = {
                  showOnlyCurrentDesktop = "false";
                  launchers = [
                    "applications:systemsettings.desktop"
                    "applications:org.kde.dolphin.desktop"
                    "applications:brave-browser.desktop"
                    "applications:com.mitchellh.ghostty.desktop"
                    "applications:discord.desktop"
                    "applications:spotify.desktop"
                    "applications:gimp.desktop"
                  ];
                };
              };
            }
            {
              systemTray = {
                icons.scaleToFit = true;
                items = {
                  shown = [
                    "org.kde.plasma.networkmanagement"
                    "org.kde.plasma.volume"
                    "org.kde.plasma.battery"
                  ];
                  hidden = [
                    "org.kde.plasma.clipboard"
                    "org.kde.plasma.notifications"
                  ];
                  configs.battery.showPercentage = true;
                };
              };
            }
            "org.kde.plasma.digitalclock"
          ];
        }
      ];
    };
}
