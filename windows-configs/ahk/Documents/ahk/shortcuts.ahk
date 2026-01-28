#Requires AutoHotkey v2.0
#SingleInstance Force
SetWinDelay(-1) 
UserProfile := EnvGet("USERPROFILE")

; ---------------------------------------------------------
; 1. CONFIGURATION FUNCTION (Fast Apply)
; ---------------------------------------------------------
ApplyKomorebiConfig() {
    try {
        ; --- BEHAVIOR ---
        Run("komorebic.exe focus-follows-mouse enable", , "Hide")
        Run("komorebic.exe mouse-follows-focus enable", , "Hide")

        ; --- IGNORE RULES ---
        Run("komorebic.exe manage-rule exe 'ScreenClippingHost.exe' ignore", , "Hide")
        Run("komorebic.exe float-rule exe 'SnippingTool.exe'", , "Hide")
        Run("komorebic.exe manage-rule class 'Shell_TrayWnd' ignore", , "Hide")

        ; --- VISUALS ---
        Run("komorebic.exe border enable", , "Hide")
        Run("komorebic.exe border-width 5", , "Hide") 
        Run("komorebic.exe border-style rounded", , "Hide") 
        
        ; Gapping
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

; ---------------------------------------------------------
; 2. SMART PROCESS MANAGER
; ---------------------------------------------------------
Komorebic(cmd) {
    Run("komorebic.exe " . cmd, , "Hide")
}

ManageKomorebiState(action) {
    if (action = "stop") {
        if ProcessExist("komorebi.exe") {
            RunWait("komorebic.exe stop", , "Hide")
            if ProcessExist("komorebi.exe") {
                ProcessClose("komorebi.exe")
            }
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

; ---------------------------------------------------------
; 3. INITIAL STARTUP (REMOVED)
; ---------------------------------------------------------
; I have removed the auto-start commands. 
; The script will now wait for you to press Win+P.
ToolTip("AHK Ready - Press Win+P to start Komorebi")
SetTimer () => ToolTip(), -3000

; ---------------------------------------------------------
; 4. WIN+P: TOGGLE KOMOREBI ON/OFF
; ---------------------------------------------------------
#p:: {
    if ProcessExist("komorebi.exe") {
        ManageKomorebiState("stop")
        ToolTip("Komorebi Stopped")
        SetTimer () => ToolTip(), -1500
    } else {
        ManageKomorebiState("start")
        ToolTip("Komorebi Started")
        SetTimer () => ToolTip(), -1500
    }
}

; ---------------------------------------------------------
; VIM ARROWS
; ---------------------------------------------------------
!+h::Send "{Left}"
!+j::Send "{Down}"
!+k::Send "{Up}"
!+l::Send "{Right}"

; ---------------------------------------------------------
; SCREENSHOT INTERCEPTOR
; ---------------------------------------------------------
~#+s:: {
    Komorebic("toggle-tiling")
    if KeyWait("LButton", "D T8") {
        KeyWait("LButton")
    }
    Sleep(500)
    Komorebic("toggle-tiling")
}

; ---------------------------------------------------------
; WORKSPACES & NAVIGATION
; ---------------------------------------------------------
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

#f::Komorebic("toggle-monocle")
#+r::Komorebic("retile")
#q::WinClose("A")

; ---------------------------------------------------------
; APP LAUNCHERS
; ---------------------------------------------------------
#e::Run("powershell.exe -NoExit -Command yazi", UserProfile)
#+e::Run("explorer.exe", UserProfile)
#b:: Run("vivaldi.exe")
#n:: Run(UserProfile . "\AppData\Local\Programs\Obsidian\Obsidian.exe")
#c:: Run("powershell.exe", UserProfile)

#+t:: {
    btopPath := UserProfile . "\AppData\Local\Microsoft\WinGet\Packages\aristocratos.btop4win_Microsoft.WinGet.Source_8wekyb3d8bbwe\btop4win\btop4win.exe"
    if FileExist(btopPath) {
        Run('powershell.exe -Command "' . btopPath . '"', UserProfile)
    } else {
        Run('powershell.exe -Command "btop4win"', UserProfile)
    }
}

; ---------------------------------------------------------
; WINDOW MOVING
; ---------------------------------------------------------
#u::Komorebic("focus up")    
#h::Komorebic("focus down")  
#j::Komorebic("focus left")  
#k::Komorebic("focus right") 

#+u::Komorebic("move up")    
#+h::Komorebic("move down")  
#+j::Komorebic("move left")  
#+k::Komorebic("move right") 

; ---------------------------------------------------------
; SMOOTH MOUSE
; ---------------------------------------------------------
#LButton:: {
    MouseGetPos(&startX, &startY)
    Threshold := 80 
    Cooldown  := 250
    
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
}

~LWin::Send("{Blind}{vkE8}")
#Tab::Send "!{Tab}"
#Esc::Suspend(-1)