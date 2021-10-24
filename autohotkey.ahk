; # => Win
; ! => Alt
; ^ => Ctrl
; + => Shift
SetTitleMatchMode, 2
SetNumLockState, AlwaysOn
SetCapsLockState, AlwaysOff
;Capslock::LCtrl
RAlt::Capslock
;ESC::`
;; Begin swap win and Alt
;LAlt::LWin
;LWin::LAlt
;; End of swap win and alt

; macOS key bindings
#w::Send ^w ; win+w, close c-w
#a::Send ^a ; win+a
#c::Send ^c ; win+c, copy
#z::Send ^z ; win+z, undo
#y::Send ^y ; win+y, redo
#v::Send ^v ; win+v
#t::Send ^t ; win+t
#s::Send ^s ; win+s
#o::Send ^o ; win+
#f::Send ^f ; win+f
#q::Send !{F4} ; win+q

!f::Send ^f ; alt+f => ctrl+f
!q::!F4     ; alt+q 退出
!n::Send ^n ; alt+n 新建
!t::Send ^t ; alt+t new tab
!c::Send ^c ; alt+c copy
!v::Send ^v ; alt+v paste
!s::Send ^s ; alt+s save
!e::Send #e ; alt+e to win+e
!w::Send ^w ; alt+w to ctrl+w 关闭网页窗口


#e::
if WinExist("ahk_class CabinetWClass")
    WinActivate
else
    Run "C:\Windows\explorer.exe"
return

+^1::
if WinExist("ahk_exe firefox.exe")
; if WinExist("ahk_exe chrome.exe")
; if WinExist("ahk_exe msedge.exe")
    WinActivate
else
    Run "C:\Program Files\Mozilla Firefox\firefox.exe"
    ; Run "C:\Program Files (x86)\Google\Chrome\Application\chrome.exe"
    ; Run "C:\Program Files (x86)\Microsoft\Edge\Application\msedge.exe"
return

+^2::
if WinExist("ahk_exe sublime_text.exe")
    WinActivate
else
    Run "C:\Program Files\Sublime Text 3\sublime_text"
return

+^3::
if WinExist("ahk_exe WindowsTerminal.exe")
    WinActivate
return

+^`::
if WinExist("ahk_exe WindowsTerminal.exe")
    WinActivate
return

+^d::
if WinExist("ahk_exe Discord.exe")
    WinActivate
else
    Run "C:\Users\dcai\AppData\Local\Discord\Update.exe" --processStart Discord.exe
return


+^s::
if WinExist("ahk_exe Slack.exe")
    WinActivate
return

+^e::
if WinExist("ahk_exe msedge.exe")
    WinActivate
else
    Run "C:\Program Files (x86)\Microsoft\Edge\Application\msedge.exe"
return

+^v::
if WinExist("ahk_exe Code.exe")
    WinActivate
return

+^f::
if WinExist("ahk_exe firefox.exe")
	WinActivate
else
    Run "C:\Program Files\Mozilla Firefox\firefox.exe"
return

+^w::
if WinExist("ahk_exe WeChat.exe")
    WinActivate
else
    Run "C:\Program Files (x86)\Tencent\WeChat\WeChat.exe"
return

+^Enter::
if WinExist("ahk_exe Postman.exe")
    WinActivate
else
    Run "C:\Users\dcai\AppData\Local\Postman\Postman.exe"
return

^!r::
    Reload  ; Assign Ctrl-Alt-R as a hotkey to restart the script.
return

^#v::SendRaw %clipboard%

^#Enter::
    WinMaximize, A  ; Assign a hotkey to maximize the active window.
return

; https://superuser.com/questions/285356/possible-to-snap-top-bottom-instead-of-just-left-right-in-windows-7
; credit: http://www.pixelchef.net/how-snap-windows-horizontally-windows-7
; Move window up (Windows + Shift + UP ... NOTE must maximize window first)
+#Up::
    WinGetPos,X,Y,W,H,A,,,
    WinMaximize
    WinGetPos,TX,TY,TW,TH,ahk_class Shell_TrayWnd,,,

    ; if this is greater than 1, we're on the secondary (right) monitor. This
    ;   means the center of the active window is a positive X coordinate
    if ( X + W/2 > 0 ) {
        SysGet, MonitorWorkArea, MonitorWorkArea, 1
        WinMove,A,,X,0 , , (MonitorWorkAreaBottom/2)
    } else {
        SysGet, MonitorWorkArea, MonitorWorkArea, 2
        WinMove,A,,X,0 , , (MonitorWorkAreaBottom/2)
    }
return

; Move window down (Windows + Shift + DOWN ... NOTE must maximize window first)
+#Down::
    WinGetPos,X,Y,W,H,A,,,
    WinMaximize
    WinGetPos,TX,TY,TW,TH,ahk_class Shell_TrayWnd,,,

    ; if this is greater than 1, we're on the secondary (right) monitor. This
    ;   means the center of the active window is a positive X coordinate
    if ( X + W/2 > 0 ) {
        SysGet, MonitorWorkArea, MonitorWorkArea, 1
        WinMove,A,,X,MonitorWorkAreaBottom/2 , , (MonitorWorkAreaBottom/2)
    } else {
        SysGet, MonitorWorkArea, MonitorWorkArea, 2
        WinMove,A,,X,MonitorWorkAreaBottom/2 , , (MonitorWorkAreaBottom/2)
    }
return


; Timer
; #p::
; SetTimer, PressTheKey, 10000
; Return

; ^#p::
; SetTimer, PressTheKey, Off
; Return

PressTheKey:
    Send, {Space}
Return
; Timer END

^#+o::
    o := HidListObj( )
    KeyboardId := o.Keyboard.1.KBSubType
    MsgBox, autohotkey version: %A_AhkVersion%
    MsgBox, % "keyboard id: " . KeyboardId
Return

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
HidListObj()
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
{
    F := { Mouse:[], Keyboard:[], HID:[]}
    B := {0:"Mouse", 1:"Keyboard", 2:"HID" }
    DllCall( "GetRawInputDeviceList", "Ptr", 0, "UInt*", iCount, "UInt", A_PtrSize * 2)
    VarSetCapacity( uHIDList, iCount * ( A_PtrSize * 2))
    DllCall( "GetRawInputDeviceList", "Ptr", &uHIDList, "UInt*", iCount, "UInt", A_PtrSize * 2)

    Loop % iCount
    {
        TypeName := b[Type:=NumGet( &uHIDList, (( A_Index - 1) * ( A_PtrSize * 2)) + A_PtrSize, "UInt")]
        F[TypeName].Insert( J := [] )
        J.Queue := A_Index
        J.Handle := h := NumGet( &uHIDList, ( A_Index - 1) * ( A_PtrSize * 2))
        DllCall( "GetRawInputDeviceInfo", "Ptr", h, "UInt", 0x20000007, "Ptr", 0, "UInt*", iLength)
        VarSetCapacity( Name, ( iLength + 1) * 2)
        DllCall( "GetRawInputDeviceInfo", "Ptr", h, "UInt", 0x20000007, "Str", Name, "UInt*", iLength)
        J.Name := Name
        DllCall( "GetRawInputDeviceInfo", "Ptr", h, "UInt", 0x2000000b, "Ptr", 0, "UInt*", iLength)
        VarSetCapacity( uInfo, iLength)
        NumPut( iLength, uInfo, 0, "UInt")
        DllCall( "GetRawInputDeviceInfo", "Ptr", h, "UInt", 0x2000000b, "Ptr", &uInfo, "UInt*", iLength)

        If ( Type = 0 )
        {
            J.ID                    := NumGet( uInfo, 8,"UInt")
            J.Buttons           := NumGet( uInfo, 12,"UInt")
            J.SampleRate        := NumGet( uInfo, 16,"UInt")
            J.HWheel            := NumGet( uInfo, 20,"UInt")
        }
        Else If ( Type = 1 )
        {
            J.KBType                := NumGet( uInfo,   8,"UInt")
            J.KBSubType         := NumGet( uInfo, 12,"UInt")
            J.KeyboardMode  := NumGet( uInfo, 16,"UInt")
            J.FunctionKeys      := NumGet( uInfo, 20,"UInt")
            J.Indicators            := NumGet( uInfo, 24,"UInt")
            J.KeysTotal             := NumGet( uInfo, 28,"UInt")
        }
        Else If ( Type =  2 )
        {
            J.VendorID          := NumGet( uInfo, 8,"UInt")
            J.ProductID             := NumGet( uInfo, 12,"UInt")
            J.VersionNumber     := NumGet( uInfo, 16,"UInt")
            J.UsagePage         := NumGet( uInfo, 20 ,"UShort")
            J.Usage             := NumGet( uInfo, 22, "UShort")
            F[TypeName, J.Usage "_" J.UsagePage] := J
        }
    }
    Return F
}
