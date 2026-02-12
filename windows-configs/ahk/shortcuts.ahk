#Requires AutoHotkey v2.0
#SingleInstance Force
SetWinDelay(-1)
CoordMode "Mouse", "Screen"

; ==============================================================================
; CONFIGURATION
; ==============================================================================
UserProfile := EnvGet("USERPROFILE")
GlazeWMPath := "glazewm.exe" ; Ensure this is in your PATH or provide full path

; Mouse Interaction Settings
ResizeThreshold := 20 ; Pixels before a tiled resize triggers
MoveThreshold := 80 ; Pixels before a tiled move/swap triggers
ActionCooldown := 150 ; ms between tiled actions to avoid spam

; ==============================================================================
; GLAZEWM HELPERS
; ==============================================================================
GlazeWM(cmd) {
    try {
        Run(GlazeWMPath . " command " . cmd, , "Hide")
    } catch as e {
        ; Silent fail if glazewm isn't found
    }
}

ManageGlazeState(action) {
    if (action = "stop") {
        if ProcessExist("glazewm.exe") {
            GlazeWM("wm-exit")
            Sleep(500)
            if ProcessExist("glazewm.exe")
                ProcessClose("glazewm.exe")
        }
    } else if (action = "start") {
        if !ProcessExist("glazewm.exe") {
            try {
                Run(GlazeWMPath, , "Hide")
                ToolTip("GlazeWM Starting...")
                ProcessWait("glazewm.exe", 5)
                Sleep(1000)
                ToolTip()
            } catch as e {
                MsgBox("Failed to start GlazeWM: " . e.Message)
            }
        }
    }
}

; ==============================================================================
; HOTKEYS
; ==============================================================================

; --- Management ---
ToolTip("AHK Ready - Press Win+P to start GlazeWM")
SetTimer () => ToolTip(), -3000

#p:: {
    if ProcessExist("glazewm.exe") {
        ManageGlazeState("stop")
        ToolTip("GlazeWM Stopped")
    } else {
        ManageGlazeState("start")
        ToolTip("GlazeWM Started")
    }
    SetTimer () => ToolTip(), -1500
}

#q::WinClose("A")
#e::SmartSpawn("powershell.exe -NoExit -Command yazi") ; Retains 'yazi' functionality via SmartSpawn
#+e::SmartSpawn("explorer.exe")
#b::SmartSpawn("vivaldi.exe")
#c::SmartSpawn("powershell.exe")
#Enter::SmartSpawn("wt.exe") ; Added explicit bind for Windows Terminal as requested
#n::SmartSpawn(UserProfile . "\AppData\Local\Programs\Obsidian\Obsidian.exe")

#+t:: {
    btopPath := UserProfile . "\AppData\Local\Microsoft\WinGet\Packages\aristocratos.btop4win_Microsoft.WinGet.Source_8wekyb3d8bbwe\btop4win\btop4win.exe"
    if FileExist(btopPath)
        SmartSpawn('powershell.exe -Command "' . btopPath . '"')
    else
        SmartSpawn('powershell.exe -Command "btop4win"')
}

; --- Window Focus (Vim keys) ---
#h::GlazeWM("focus --direction left")
#j::GlazeWM("focus --direction down")
#k::GlazeWM("focus --direction up")
#l::GlazeWM("focus --direction right")

; --- Window Move (Vim keys) ---
#+h::GlazeWM("move --direction left")
#+j::GlazeWM("move --direction down")
#+k::GlazeWM("move --direction up")
#+l::GlazeWM("move --direction right")

; --- Workspaces ---
; Note: GlazeWM workspaces are named strings. Assuming names "1" through "9" as per config.
#1::GlazeWM("focus --workspace 1")
#2::GlazeWM("focus --workspace 2")
#3::GlazeWM("focus --workspace 3")
#4::GlazeWM("focus --workspace 4")
#5::GlazeWM("focus --workspace 5")

#+1::GlazeWM("move --workspace 1")
#+2::GlazeWM("move --workspace 2")
#+3::GlazeWM("move --workspace 3")
#+4::GlazeWM("move --workspace 4")
#+5::GlazeWM("move --workspace 5")

; --- Tiling Toggles ---

#f:: {
    if ProcessExist("glazewm.exe") {
        ; Use toggle-maximized (Keep Bar) instead of toggle-fullscreen (Hide Bar)
        GlazeWM("toggle-maximized") 
    } else {
        if (WinGetMinMax("A") = 1)
            WinRestore("A")
        else
            WinMaximize("A")
    }
}

#+r::GlazeWM("wm-redraw")

~#+s:: {
    GlazeWM("toggle-tiling")
    if KeyWait("LButton", "D T8")
        KeyWait("LButton")
    Sleep(500)
    GlazeWM("toggle-tiling")
}

; ==============================================================================
; MOUSE BEHAVIOR (Move & Resize)
; ==============================================================================

; --- Super + Left Click: MOVE ---
#LButton:: {
    MouseGetPos(&startX, &startY, &targetWin)

    ; Safety check
    try {
        class := WinGetClass(targetWin)
        if (class == "Shell_TrayWnd" || class == "WorkerW" || class == "Progman")
            return
    }

    ; 1. FLOATING / NATIVE MOVE
    if !ProcessExist("glazewm.exe") { 
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

    ; 2. TILED MOVE (GlazeWM Swap Logic)
    lastMove := A_TickCount
    while GetKeyState("LButton", "P") {
        MouseGetPos(&curX, &curY)
        diffX := curX - startX
        diffY := curY - startY

        if (A_TickCount - lastMove > ActionCooldown) {
            if (Abs(diffX) > MoveThreshold) {
                (diffX > 0) ? GlazeWM("move --direction right") : GlazeWM("move --direction left")
                lastMove := A_TickCount
                MouseGetPos(&startX, &startY) 
            }
            else if (Abs(diffY) > MoveThreshold) {
                (diffY > 0) ? GlazeWM("move --direction down") : GlazeWM("move --direction up")
                lastMove := A_TickCount
                MouseGetPos(&startX, &startY)
            }
        }
        Sleep(10)
    }
}

; --- Super + Right Click: RESIZE ---
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

    ; 1. FLOATING RESIZE
    if !ProcessExist("glazewm.exe") {
        CenterX := winX + (winW / 2)
        CenterY := winY + (winH / 2)
        DirX := (startX < CenterX) ? -1 : 1
        DirY := (startY < CenterY) ? -1 : 1
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
            } else { ; Right Side
                newW := offW + deltaX
            }

            if (DirY == -1) { ; Top Side
                newY := offY + deltaY
                newH := offH - deltaY
            } else { ; Bottom Side
                newH := offH + deltaY
            }

            if (newW > 50 && newH > 50)
                WinMove(newX, newY, newW, newH, targetWin)

            Sleep(10)
        }
        return
    }

    ; 2. TILED RESIZE (GlazeWM Axis)
    ; Increased resize percentage to 5% and slightly larger cooldown to reduce process spam
    lastResize := A_TickCount
    while GetKeyState("RButton", "P") {
        MouseGetPos(&curX, &curY)
        diffX := curX - startX
        diffY := curY - startY

        ; Slightly increased cooldown (100 -> 125ms) to reduce process spam
        if (A_TickCount - lastResize > 125) { 
            if (Abs(diffX) > ResizeThreshold) {
                ; Example: If diffX > 0 (moved right), increase width
                ; Increased step size to 5% to make resizing more responsive with fewer calls
                action := (diffX > 0) ? "+5%" : "-5%"
                    GlazeWM("resize --width " . action)
                    startX := curX 
                    lastResize := A_TickCount
                }
                if (Abs(diffY) > ResizeThreshold) {
                action := (diffY > 0) ? "+5%" : "-5%"
                    GlazeWM("resize --height " . action)
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

    ; ==============================================================================
    ; SMART SPAWN LOGIC (Mouse-Based Split Direction)
    ; ==============================================================================
    ; Checks mouse position relative to the active window's quadrants (X logic).
    ; Left/Right -> Horizontal Split. Top/Bottom -> Vertical Split.

    SmartSpawn(appCommand) {
        if !ProcessExist("glazewm.exe") {
            Run(appCommand)
            return
        }

        ; 1. Get the window under the mouse (Hyprland "Focus Follows Mouse" style)
        MouseGetPos(&mouseX, &mouseY, &targetWin)

        ; If we are hovering over the desktop/taskbar, just spawn normally
        try {
            class := WinGetClass(targetWin)
            if (class == "Shell_TrayWnd" || class == "WorkerW" || class == "Progman") {
                Run(appCommand)
                return
            }
        } catch {
            Run(appCommand)
            return
        }

        ; 2. Calculate Mouse Position relative to that Window
        try {
            WinGetPos(&winX, &winY, &winW, &winH, targetWin)
        } catch {
            Run(appCommand)
            return
        }

        relX := mouseX - winX
        relY := mouseY - winY

        ; 3. Determine Quadrant (The "X" Logic)
        ; We normalize coordinates to 0.0-1.0 to handle rectangular windows correctly
        normX := relX / winW
        normY := relY / winH

        ; Check if we are in the "Horizontal" triangles (Left/Right) or "Vertical" (Top/Bottom)
        ; Logic: If the point is closer to the horizontal centerline than vertical centerline
        if (Abs(normX - 0.5) > Abs(normY - 0.5)) {
            ; Mouse is clearly Left or Right -> Horizontal Split (Side-by-Side)
            ; Correct CLI: glazewm command set-tiling-direction horizontal
            Run(GlazeWMPath . " command set-tiling-direction horizontal",, "Hide")
        } else {
            ; Mouse is clearly Top or Bottom -> Vertical Split (Stacked)
            ; Correct CLI: glazewm command set-tiling-direction vertical
            Run(GlazeWMPath . " command set-tiling-direction vertical",, "Hide")
        }

        ; 4. Spawn the App
        ; Small sleep to ensure GlazeWM registered the direction change
        Sleep(50) 
        Run(appCommand)
    }
