#Requires AutoHotkey v2.0
#SingleInstance Force
SetWinDelay(-1)
CoordMode "Mouse", "Screen"

UserProfile := EnvGet("USERPROFILE")

; ==============================================================================
; 1. CORE FUNCTIONS (Toggle & Config)
; ==============================================================================

Komorebic(cmd) {
    ; Helper to run komorebic commands silently
    try {
        RunWait("komorebic.exe " . cmd, , "Hide")
    }
}

ManageKomorebiState(action) {
    if (action = "stop") {
        if ProcessExist("komorebi.exe") {
            RunWait("komorebic.exe stop", , "Hide")
            if ProcessExist("komorebi.exe")
                ProcessClose("komorebi.exe")
            
            ; Stop masir when native mode is active
            if ProcessExist("masir.exe")
                ProcessClose("masir.exe")
        }
    } 
    else if (action = "start") {
        if !ProcessExist("komorebi.exe") {
            ; Start komorebi with the masir hook enabled
            Run("komorebic.exe start --masir", , "Hide")
            ProcessWait("komorebi.exe", 5) 
            Sleep(500) 
        }
    }
}

; ==============================================================================
; 2. GLOBAL SYSTEM HOTKEYS (Always Active)
; ==============================================================================

; Toggle Komorebi (Win + O)
#o:: {
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

; Alt + Backspace to Delete button 
!BackSpace::Send "{Delete}"

; Ctrl + Alt + Backspace to Delete Entire Next Word  
+!BackSpace::Send "^{Delete}"

; App Launchers (Win + E, B, N, C, T)
#e::Run('wt.exe -p "Arch" wsl.exe bash -ic "yazi"', UserProfile)
#+e::Run("explorer.exe", UserProfile)
#b::Run("vivaldi.exe")
#n::Run(UserProfile . "\AppData\Local\Programs\Obsidian\Obsidian.exe")
; #c::Run("powershell.exe", UserProfile)
#c::Run("wt.exe ", UserProfile)
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
    WinGetPos(&winX, &winY,,, targetWin)
    offsetX := startX - winX
    offsetY := startY - winY

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
    if ProcessExist("komorebi.exe")
        return 

    MouseGetPos(&startX, &startY, &targetWin)

    try {
        class := WinGetClass(targetWin)
        if (class == "Shell_TrayWnd" || class == "WorkerW")
            return
        WinGetPos(&winX, &winY, &winW, &winH, targetWin)
    } catch {
        return
    }

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

        if (ResizeLeft) {
            NewX := OrigX + dx
            NewW := OrigW - dx
        } else {
            NewW := OrigW + dx
        }

        if (ResizeTop) {
            NewY := OrigY + dy
            NewH := OrigH - dy
        } else {
            NewH := OrigH + dy
        }

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

; ==============================================================================
; 5. VIM ARROWS & WORD JUMPING
; ==============================================================================

; Normal Arrows (Alt + Shift + H/J/K/L)
!+h::Send "{Left}"
!+j::Send "{Down}"
!+k::Send "{Up}"
!+l::Send "{Right}"

; Old script (Failed, Syntax Error: can't use & and operators(^,% and, +) in the same line)
; ; Jump Words (Alt + Shift + C + H/L) 
; !+c&h::Send "^{Left}"
; !+c&l::Send "^{Right}"
;
; ; Select Jumped Words (Alt + Shift + X + H/L)
; !+x&h::Send "^{Left}"
; !+x&l::Send "^{Right}"
;
; ; Select characters (Alt + Shift + V + H/L)
; !+v&h::Send "^{Left}"
; !+v&l::Send "^{Right}"

; Enter condition if Alt + Shift is held down 

#HotIf GetKeyState("Alt", "P") && GetKeyState("Shift", "P")

; C + H/L = To Jump Words 
c & h::Send "^{Left}"
c & l:: Send "^{Right}"

; X + H/L = To Select Jumped Words
x & h::Send "^+{Left}"
x & l:: Send "^+{Right}"

; Z + H/L = To Select Characters
z & h::Send "+{Left}"
z & l:: Send "+{Right}"

#HotIf

; ==============================================================================
; 6. WORKSPACES & MISC
; ==============================================================================

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
    ; Pass the native Windows shortcut through.
    ; Komorebi's JSON will automatically float the clipping overlay.
}

; System Overrides
~LWin::Send("{Blind}{vkE8}")
#Tab::Send "!{Tab}"
#Esc::Suspend(-1)

; ==============================================================================
; 7. FLOW LAUNCHER
; ==============================================================================

; Press Win + S to launch Flow Launcher instantly
#s:: {
    Send "{Blind}{LWin up}{RWin up}" ; Instantly releases the Win key logically
    Send "!+-"                       ; Sends the new safe combo (Alt + Shift + Minus)
}

; ==============================================================================

