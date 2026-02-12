#Requires AutoHotkey v2.0
#SingleInstance Force
SetWinDelay(-1)
CoordMode "Mouse", "Screen"

; ==============================================================================
; CONFIGURATION
; ==============================================================================
UserProfile := EnvGet("USERPROFILE")
KomorebicPath := "komorebic.exe" ; Ensure this is in your PATH or provide full path

; Visuals
BorderColorFocused   := "235 160 172" ; Catppuccin Rosewater
BorderColorUnfocused := "24 24 37"    ; Catppuccin Base
BorderWidth          := 5
Padding              := 10

; Mouse Interaction Settings
ResizeThreshold      := 20   ; Pixels to move before a tiled resize triggers
MoveThreshold        := 80   ; Pixels to move before a tiled move/swap triggers
ActionCooldown       := 150  ; ms between tiled actions to prevent jitter

; ==============================================================================
; KOMOREBI HELPERS
; ==============================================================================
Komorebic(cmd) {
    try {
        Run(KomorebicPath . " " . cmd, , "Hide")
    } catch as e {
        ; Silent fail if komorebic isn't found/running
    }
}

ApplyKomorebiConfig() {
    Komorebic("focus-follows-mouse enable")
    Komorebic("mouse-follows-focus enable")
    Komorebic("manage-rule exe 'ScreenClippingHost.exe' ignore")
    Komorebic("float-rule exe 'SnippingTool.exe'")
    Komorebic("manage-rule class 'Shell_TrayWnd' ignore")
    Komorebic("manage-rule class 'WorkerW' ignore")
    
    Komorebic("border enable")
    Komorebic("border-width " . BorderWidth)
    Komorebic("border-style rounded")
    Komorebic("container-padding " . Padding)
    Komorebic("workspace-padding " . Padding)
    
    Komorebic("border-colour " . BorderColorFocused . " --window-kind single")
    Komorebic("border-colour " . BorderColorFocused . " --window-kind stack")
    Komorebic("border-colour " . BorderColorFocused . " --window-kind floating")
    Komorebic("border-colour " . BorderColorUnfocused . " --window-kind unfocused")
}

ManageKomorebiState(action) {
    if (action = "stop") {
        if ProcessExist("komorebi.exe") {
            Komorebic("stop")
            if ProcessExist("komorebi.exe")
                ProcessClose("komorebi.exe")
        }
    } else if (action = "start") {
        if !ProcessExist("komorebi.exe") {
            Komorebic("start")
            ProcessWait("komorebi.exe", 5)
            Sleep(500)
            ApplyKomorebiConfig()
        }
    }
}

; ==============================================================================
; HOTKEYS
; ==============================================================================

; --- Management ---
ToolTip("AHK Ready - Press Win+P to start Komorebi")
SetTimer () => ToolTip(), -3000

#p:: {
    if ProcessExist("komorebi.exe") {
        ManageKomorebiState("stop")
        ToolTip("Komorebi Stopped")
    } else {
        ManageKomorebiState("start")
        ToolTip("Komorebi Started")
    }
    SetTimer () => ToolTip(), -1500
}

#q::WinClose("A")
#e::Run("powershell.exe -NoExit -Command yazi", UserProfile)
#+e::Run("explorer.exe", UserProfile)
#b::Run("vivaldi.exe")
#c::Run("powershell.exe", UserProfile)
#n::Run(UserProfile . "\AppData\Local\Programs\Obsidian\Obsidian.exe")

#+t:: {
    btopPath := UserProfile . "\AppData\Local\Microsoft\WinGet\Packages\aristocratos.btop4win_Microsoft.WinGet.Source_8wekyb3d8bbwe\btop4win\btop4win.exe"
    if FileExist(btopPath)
        Run('powershell.exe -Command "' . btopPath . '"', UserProfile)
    else
        Run('powershell.exe -Command "btop4win"', UserProfile)
}

; --- Window Focus (Vim keys) ---
#h::Komorebic("focus left")
#j::Komorebic("focus down")
#k::Komorebic("focus up")
#l::Komorebic("focus right")

; --- Window Move (Vim keys) ---
#+h::Komorebic("move left")
#+j::Komorebic("move down")
#+k::Komorebic("move up")
#+l::Komorebic("move right")

; --- Workspaces ---
#1::Komorebic("focus-workspace 0")
#2::Komorebic("focus-workspace 1")
#3::Komorebic("focus-workspace 2")
#4::Komorebic("focus-workspace 3")
#5::Komorebic("focus-workspace 4")

#+1::Komorebic("move-to-workspace 0")
#+2::Komorebic("move-to-workspace 1")
#+3::Komorebic("move-to-workspace 2")
#+4::Komorebic("move-to-workspace 3")
#+5::Komorebic("move-to-workspace 4")

; --- Tiling Toggles ---

; CORRECTED: Handles Monocle if Komorebi is running, else Standard Maximize
#f:: {
    if ProcessExist("komorebi.exe") {
        Komorebic("toggle-monocle")
    } else {
        if (WinGetMinMax("A") = 1)
            WinRestore("A")
        else
            WinMaximize("A")
    }
}

#+r::Komorebic("retile")

~#+s:: {
    Komorebic("toggle-tiling")
    if KeyWait("LButton", "D T8")
        KeyWait("LButton")
    Sleep(500)
    Komorebic("toggle-tiling")
}

; ==============================================================================
; HYPRLAND MOUSE BEHAVIOR (Move & Resize)
; ==============================================================================

; --- Super + Left Click: MOVE ---
#LButton:: {
    MouseGetPos(&startX, &startY, &targetWin)
    
    ; Safety check: Don't move desktop or taskbar
    try {
        class := WinGetClass(targetWin)
        if (class == "Shell_TrayWnd" || class == "WorkerW" || class == "Progman")
            return
    }

    ; 1. FLOATING / NATIVE MOVE (Standard Windows Logic)
    if !ProcessExist("komorebi.exe") { 
        WinGetPos(&winX, &winY, , , targetWin)
        offsetX := startX - winX
        offsetY := startY - winY
        
        while GetKeyState("LButton", "P") {
            MouseGetPos(&curX, &curY)
            WinMove(curX - offsetX, curY - offsetY, , , targetWin)
            Sleep(10)
        }
        return
    }

    ; 2. TILED MOVE (Komorebi Swap Logic)
    lastMove := A_TickCount
    while GetKeyState("LButton", "P") {
        MouseGetPos(&curX, &curY)
        diffX := curX - startX
        diffY := curY - startY
        
        if (A_TickCount - lastMove > ActionCooldown) {
            if (Abs(diffX) > MoveThreshold) {
                (diffX > 0) ? Komorebic("move right") : Komorebic("move left")
                lastMove := A_TickCount
                MouseGetPos(&startX, &startY) 
            }
            else if (Abs(diffY) > MoveThreshold) {
                (diffY > 0) ? Komorebic("move down") : Komorebic("move up")
                lastMove := A_TickCount
                MouseGetPos(&startX, &startY)
            }
        }
        Sleep(10)
    }
}

; --- Super + Right Click: RESIZE (Hyprland Style) ---
#RButton:: {
    MouseGetPos(&startX, &startY, &targetWin)
    
    try {
        class := WinGetClass(targetWin)
        if (class == "Shell_TrayWnd" || class == "WorkerW")
            return
        WinGetPos(&winX, &winY, &winW, &winH, targetWin)
    } catch {
        return
    }

    ; 1. FLOATING RESIZE (All Directions)
    if !ProcessExist("komorebi.exe") {
        ; Calculate window center to determine quadrants
        CenterX := winX + (winW / 2)
        CenterY := winY + (winH / 2)
        
        ; Determine quadrant: -1 (Left/Top), 1 (Right/Bottom)
        DirX := (startX < CenterX) ? -1 : 1
        DirY := (startY < CenterY) ? -1 : 1
        
        ; Store initial offsets to prevent snapping
        offW := winW
        offH := winH
        offX := winX
        offY := winY
        
        while GetKeyState("RButton", "P") {
            MouseGetPos(&curX, &curY)
            
            deltaX := curX - startX
            deltaY := curY - startY
            
            newX := offX
            newY := offY
            newW := offW
            newH := offH

            if (DirX == -1) { ; Left Side
                newX := offX + deltaX
                newW := offW - deltaX
            } else {          ; Right Side
                newW := offW + deltaX
            }
            
            if (DirY == -1) { ; Top Side
                newY := offY + deltaY
                newH := offH - deltaY
            } else {          ; Bottom Side
                newH := offH + deltaY
            }

            if (newW > 50 && newH > 50)
                WinMove(newX, newY, newW, newH, targetWin)
                
            Sleep(10)
        }
        return
    }

    ; 2. TILED RESIZE (Komorebi Axis)
    lastResize := A_TickCount
    while GetKeyState("RButton", "P") {
        MouseGetPos(&curX, &curY)
        diffX := curX - startX
        diffY := curY - startY
        
        if (A_TickCount - lastResize > 100) { 
            if (Abs(diffX) > ResizeThreshold) {
                action := (diffX > 0) ? "increase" : "decrease"
                Komorebic("resize-axis horizontal " . action)
                startX := curX 
                lastResize := A_TickCount
            }
            if (Abs(diffY) > ResizeThreshold) {
                action := (diffY > 0) ? "increase" : "decrease"
                Komorebic("resize-axis vertical " . action)
                startY := curY
                lastResize := A_TickCount
            }
        }
        Sleep(10)
    }
}

; --- System Overrides ---
~LWin::Send("{Blind}{vkE8}") 
#Tab::Send "!{Tab}"
#Esc::Suspend(-1)