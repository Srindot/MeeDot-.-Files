#Requires AutoHotkey v2.0
#SingleInstance Force
SetWinDelay(-1) 
UserProfile := EnvGet("USERPROFILE")

ApplyKomorebiConfig() {
    try {
        Run("komorebic.exe focus-follows-mouse enable", , "Hide")
        Run("komorebic.exe mouse-follows-focus enable", , "Hide")
        Run("komorebic.exe manage-rule exe 'ScreenClippingHost.exe' ignore", , "Hide")
        Run("komorebic.exe float-rule exe 'SnippingTool.exe'", , "Hide")
        Run("komorebic.exe manage-rule class 'Shell_TrayWnd' ignore", , "Hide")
        Run("komorebic.exe border enable", , "Hide")
        Run("komorebic.exe border-width 5", , "Hide") 
        Run("komorebic.exe border-style rounded", , "Hide") 
        Run("komorebic.exe container-padding 10", , "Hide")
        Run("komorebic.exe workspace-padding 10", , "Hide")
        Run("komorebic.exe border-colour 235 160 172 --window-kind single", , "Hide")
        Run("komorebic.exe border-colour 235 160 172 --window-kind stack", , "Hide")
        Run("komorebic.exe border-colour 235 160 172 --window-kind floating", , "Hide")
        Run("komorebic.exe border-colour 242 205 205 --window-kind monocle", , "Hide")
        Run("komorebic.exe border-colour 24 24 37 --window-kind unfocused", , "Hide")
    }
}

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

ToolTip("AHK Ready - Press Win+P to start Komorebi")
SetTimer () => ToolTip(), -3000

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

!+h::Send "{Left}"
!+j::Send "{Down}"
!+k::Send "{Up}"
!+l::Send "{Right}"

~#+s:: {
    Komorebic("toggle-tiling")
    if KeyWait("LButton", "D T8") {
        KeyWait("LButton")
    }
    Sleep(500)
    Komorebic("toggle-tiling")
}

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

#f:: {
    if ProcessExist("komorebi.exe") {
        Komorebic("toggle-monocle")
    } else {
        WinGetPos(&X, &Y, &W, &H, "A")
        if (WinGetMinMax("A") = 1)
            WinRestore("A")
        else
            WinMaximize("A")
    }
}

#+r::Komorebic("retile")
#q::WinClose("A")

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

#u::Komorebic("focus up")    
#h::Komorebic("focus down")  
#j::Komorebic("focus left")  
#k::Komorebic("focus right") 

#+u::Komorebic("move up")    
#+h::Komorebic("move down")  
#+j::Komorebic("move left")  
#+k::Komorebic("move right") 

#LButton:: {
    if ProcessExist("komorebi.exe") {
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
    } else {
        CoordMode "Mouse", "Screen"
        MouseGetPos(&startX, &startY, &targetWin)
        if (WinGetClass(targetWin) == "Shell_TrayWnd" || WinGetClass(targetWin) == "WorkerW")
            return
        WinGetPos(&winX, &winY, ,, targetWin)
        while GetKeyState("LButton", "P") {
            MouseGetPos(&mouseX, &mouseY)
            WinMove(winX + (mouseX - startX), winY + (mouseY - startY),,, targetWin)
        }
    }
}

#RButton:: {
    if !ProcessExist("komorebi.exe") {
        CoordMode "Mouse", "Screen"
        MouseGetPos(&startX, &startY, &targetWin)
        if (WinGetClass(targetWin) == "Shell_TrayWnd" || WinGetClass(targetWin) == "WorkerW")
            return
        WinGetPos(&winX, &winY, &winW, &winH, targetWin)
        while GetKeyState("RButton", "P") {
            MouseGetPos(&mouseX, &mouseY)
            WinMove(,, winW + (mouseX - startX), winH + (mouseY - startY), targetWin)
        }
    }
}

~LWin::Send("{Blind}{vkE8}")
#Tab::Send "!{Tab}"
#Esc::Suspend(-1)