#Requires AutoHotkey v2.0
#SingleInstance Force
SetWinDelay(-1)
CoordMode "Mouse", "Screen"

UserProfile := EnvGet("USERPROFILE")

; ==============================================================================
; 1. CORE FUNCTIONS (Toggle & Config)
; ==============================================================================

ApplyKomorebiConfig() {
    try {
        ; --- BEHAVIOR ---
        ; Disabling focus-follows-mouse to prevent menus from closing when hovering out
        Run("komorebic.exe focus-follows-mouse disable", , "Hide")
        Run("komorebic.exe mouse-follows-focus enable", , "Hide")

        ; --- IGNORE RULES ---
        Run("komorebic.exe manage-rule class '#32768' ignore", , "Hide") ; Standard Windows Menus
        Run("komorebic.exe manage-rule class 'Windows.UI.Core.CoreWindow' ignore", , "Hide") ; UWP Popups
        Run("komorebic.exe manage-rule class 'Chrome_RenderWidgetHostHWND' ignore", , "Hide") ; Chrome/Electron Popups
        Run("komorebic.exe manage-rule exe 'ScreenClippingHost.exe' ignore", , "Hide")
        Run("komorebic.exe float-rule exe 'SnippingTool.exe'", , "Hide")
        Run("komorebic.exe manage-rule class 'Shell_TrayWnd' ignore", , "Hide")

        ; --- VISUALS ---
        Run("komorebic.exe border enable", , "Hide")
        Run("komorebic.exe border-width 5", , "Hide") 
        Run("komorebic.exe border-style rounded", , "Hide") 
        Run("komorebic.exe container-padding 10", , "Hide")
        Run("komorebic.exe workspace-padding 10", , "Hide")

        ; --- COLORS ---
        Run("komorebic.exe border-colour 235 160 172 --window-kind single", , "Hide")
        Run("komorebic.exe border-colour 235 160 172 --window-kind stack", , "Hide")
        Run("komorebic.exe border-colour 235 160 172 --window-kind floating", , "Hide")
        Run("komorebic.exe border-colour 242 205 205 --window-kind monocle", , "Hide")
        Run("komorebic.exe border-colour 24 24 37 --window-kind unfocused", , "Hide")
    }
}

Komorebic(cmd) {
    ; Helper to run komorebic commands silently
    try {
        Run("komorebic.exe " . cmd, , "Hide")
    }
}

ManageKomorebiState(action) {
    if (action = "stop") {
        if ProcessExist("komorebi.exe") {
            RunWait("komorebic.exe stop", , "Hide")
            if ProcessExist("komorebi.exe")
                ProcessClose("komorebi.exe")
        }
    } 
    else if (action = "start") {
        if !ProcessExist("komorebi.exe") {
            Run("komorebic.exe start", , "Hide")
            ProcessWait("komorebi.exe", 5) 
            Sleep(500) 
            ApplyKomorebiConfig()
        }
    }
}

; ==============================================================================
; 2. GLOBAL SYSTEM HOTKEYS (Always Active)
; ==============================================================================

; Auto-Apply Config on Script Reload (if Komorebi is already running)
if ProcessExist("komorebi.exe")
    ApplyKomorebiConfig()

; Toggle Komorebi (Win + P)
#p:: {
    if ProcessExist("komorebi.exe") {
        ManageKomorebiState("stop")
        ToolTip("Komorebi OFF - Native Mode")
    } else {
        ManageKomorebiState("start")
        ToolTip("Komorebi ON - Tiling Mode")
    }
    SetTimer () => ToolTip(), -1500
}

; Close Window (Win + Q)
#q::WinClose("A")

; App Launchers (Win + E, B, N, C, T)
#e::Run("powershell.exe -NoExit -Command yazi", UserProfile)
#+e::Run("explorer.exe", UserProfile)
#b::Run("vivaldi.exe")
#n::Run(UserProfile . "\AppData\Local\Programs\Obsidian\Obsidian.exe")
#c::Run("powershell.exe", UserProfile)
#+t:: {
    btopPath := UserProfile . "\AppData\Local\Microsoft\WinGet\Packages\aristocratos.btop4win_Microsoft.WinGet.Source_8wekyb3d8bbwe\btop4win\btop4win.exe"
    if FileExist(btopPath)
        Run('powershell.exe -Command "' . btopPath . '"', UserProfile)
    else
        Run('powershell.exe -Command "btop4win"', UserProfile)
}

; ==============================================================================
; 3. DUAL-MODE HOTKEYS (Behavior changes based on state)
; ==============================================================================

; Win + F (Toggle Monocle vs Maximize)
#f:: {
    if ProcessExist("komorebi.exe") {
        ; ON: Toggle Tiling Monocle
        Komorebic("toggle-monocle")
    } else {
        ; OFF: Native Windows Maximize
        if (WinGetMinMax("A") = 1)
            WinRestore("A")
        else
            WinMaximize("A")
    }
}

; Win + G (Minimize Active Window)
#w:: {
    if ProcessExist("komorebi.exe") {
        ; ON: Tell Komorebi to minimize (removes from tile grid)
        Komorebic("minimize")
    } else {
        ; OFF: Standard Windows Minimize
        WinMinimize("A")
    }
}

; Win + Left Click (Swap Tile vs Move Window)
#LButton:: {
    MouseGetPos(&startX, &startY, &targetWin)

    ; Safety: Ignore Desktop/Taskbar
    try {
        class := WinGetClass(targetWin)
        if (class == "Shell_TrayWnd" || class == "WorkerW")
            return
    }

    ; --- STATE: KOMOREBI ON (Swap Tiles) ---
    if ProcessExist("komorebi.exe") {
        Threshold := 80 
        Cooldown := 250
        while GetKeyState("LButton", "P") {
            MouseGetPos(&curX, &curY)
            diffX := curX - startX
            diffY := curY - startY

            if (Abs(diffX) > Threshold) {
                (diffX > 0) ? Komorebic("move right") : Komorebic("move left")
                Sleep(Cooldown) 
                MouseGetPos(&startX, &startY) 
            }
            if (Abs(diffY) > Threshold) {
                (diffY > 0) ? Komorebic("move down") : Komorebic("move up")
                Sleep(Cooldown)
                MouseGetPos(&startX, &startY)
            }
            Sleep(10)
        }
        return
    }

    ; --- STATE: KOMOREBI OFF (Standard Move) ---
    ; Calculate offset so window sticks to mouse properly
    WinGetPos(&winX, &winY,,, targetWin)
    offsetX := startX - winX
    offsetY := startY - winY

    ; If maximized, restore it first so we can move it
    if (WinGetMinMax(targetWin) = 1)
        WinRestore(targetWin)

    while GetKeyState("LButton", "P") {
        MouseGetPos(&curX, &curY)
        WinMove(curX - offsetX, curY - offsetY,,, targetWin)
        Sleep(10)
    }
}

; Win + Right Click (Native Resize ONLY when OFF)
#RButton:: {
    ; If Komorebi is ON, we disable scaling completely (Return immediately)
    if ProcessExist("komorebi.exe")
        return 

    MouseGetPos(&startX, &startY, &targetWin)

    ; Safety Check
    try {
        class := WinGetClass(targetWin)
        if (class == "Shell_TrayWnd" || class == "WorkerW")
            return
        WinGetPos(&winX, &winY, &winW, &winH, targetWin)
    } catch {
        return
    }

    ; --- STATE: KOMOREBI OFF (HYPRLAND NATIVE RESIZE) ---
    ; Determine Quadrants
    CenterX := winX + (winW / 2)
    CenterY := winY + (winH / 2)
    ResizeLeft := (startX < CenterX)
    ResizeTop := (startY < CenterY)

    OrigX := winX, OrigY := winY, OrigW := winW, OrigH := winH

    while GetKeyState("RButton", "P") {
        MouseGetPos(&curX, &curY)
        dx := curX - startX
        dy := curY - startY

        NewX := OrigX, NewY := OrigY, NewW := OrigW, NewH := OrigH

        ; Horizontal Logic
        if (ResizeLeft) {
            NewX := OrigX + dx
            NewW := OrigW - dx
        } else {
            NewW := OrigW + dx
        }

        ; Vertical Logic
        if (ResizeTop) {
            NewY := OrigY + dy
            NewH := OrigH - dy
        } else {
            NewH := OrigH + dy
        }

        ; Apply if size is safe (>50px)
        if (NewW > 50 && NewH > 50)
            WinMove(NewX, NewY, NewW, NewH, targetWin)

        Sleep(10)
    }
}

; ==============================================================================
; 4. KOMOREBI SPECIFIC HOTKEYS (Passthrough)
; ==============================================================================

#u::Komorebic("focus up") 
#h::Komorebic("focus down") 
#j::Komorebic("focus left") 
#k::Komorebic("focus right") 

#+u::Komorebic("move up") 
#+h::Komorebic("move down") 
#+j::Komorebic("move left") 
#+k::Komorebic("move right") 

#+r::Komorebic("retile")

; Vim Arrows
!+h::Send "{Left}"
!+j::Send "{Down}"
!+k::Send "{Up}"
!+l::Send "{Right}"

; Workspaces
#1::Komorebic("focus-workspace 0")
#2::Komorebic("focus-workspace 1")
#3::Komorebic("focus-workspace 2")
#4::Komorebic("focus-workspace 3")
#5::Komorebic("focus-workspace 4")
#6::Komorebic("focus-workspace 5")
#7::Komorebic("focus-workspace 6")
#8::Komorebic("focus-workspace 7")
#9::Komorebic("focus-workspace 8")

#+1::Komorebic("move-to-workspace 0")
#+2::Komorebic("move-to-workspace 1")
#+3::Komorebic("move-to-workspace 2")
#+4::Komorebic("move-to-workspace 3")
#+5::Komorebic("move-to-workspace 4")
#+6::Komorebic("move-to-workspace 5")
#+7::Komorebic("move-to-workspace 6")
#+8::Komorebic("move-to-workspace 7")
#+9::Komorebic("move-to-workspace 8")

; Screenshot Tool
~#+s:: {
    if ProcessExist("komorebi.exe") {
        Komorebic("toggle-tiling")
        if KeyWait("LButton", "D T8") {
            KeyWait("LButton")
        }
        Sleep(500)
        Komorebic("toggle-tiling")
    }
}

; System Overrides
~LWin::Send("{Blind}{vkE8}")
#Tab::Send "!{Tab}"
#Esc::Suspend(-1)