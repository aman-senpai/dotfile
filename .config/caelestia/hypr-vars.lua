return {
    -- Default Applications
    terminal                   = "kitty",
    fileExplorer               = "dolphin",
    editor                     = "kate",
    browser                    = "zen-browser",

    -- Trackpad / Touchpad
    touchpadScrollFactor       = 1.0, -- Default was 0.3 (higher = faster, e.g. 1.0, 1.2, 1.5)

    -- App Launcher (opens on Super + Space AND bare Super)
    kbLauncher                 = { "SUPER + Space", "SUPER + SUPER_L" },

    -- Terminal
    kbTerminal                 = { "SUPER + Return", "SUPER + T" },

    -- Apps
    kbFileExplorer             = "SUPER + E",
    kbBrowser                  = { "SUPER + W", "SUPER + B" },
    kbEditor                   = "SUPER + C",

    -- Workspace Navigation (Standard: Super+1..9 to view, Super+Shift+1..9 to move)
    kbGoToWs                   = "SUPER",
    kbMoveWinToWs              = "SUPER + SHIFT",

    -- Window Management
    kbCloseWindow              = { "SUPER + Q", "ALT + F4" },
    kbWindowFullscreen         = "SUPER + F",
    kbToggleWindowFloating     = { "SUPER + ALT + Space", "SUPER + ALT + V" },
    kbPinWindow                = "SUPER + P",

    -- Panels & Caelestia Widgets
    kbShowSidebar              = "SUPER + N",
    kbLock                     = "SUPER + L",
    kbSession                  = "CTRL + ALT + Delete",
    kbShowPanels               = "SUPER + K",

    -- Clipboard & Utilities
    kbClipboard                = "SUPER + V",
    kbClipboardDel             = "SUPER + ALT + V",
    kbEmoji                    = "SUPER + Period",
    kbScreenshot               = "Print",
    kbScreenshotRegion         = "SUPER + SHIFT + S",
    kbScreenshotFreeze         = "SUPER + SHIFT + ALT + S",
    kbColorPicker              = "SUPER + SHIFT + C",
}
