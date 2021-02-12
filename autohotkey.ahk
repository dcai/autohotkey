; # => Win
; ! => Alt
; ^ => Ctrl
; + => Shift
SetTitleMatchMode, 2
SetNumLockState, AlwaysOn
SetCapsLockState, AlwaysOff
Capslock::Esc
RAlt::Capslock
;LAlt::LWin
;LWin::LAlt
;ESC::`

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
if WinExist("ahk_exe Discord.exe")
    WinActivate
return

+^s::
if WinExist("ahk_exe Slack.exe")
    WinActivate
return

+^e::
if WinExist("ahk_exe msedge.exe")
    WinActivate
return

+^f::
if WinExist("ahk_exe firefox.exe")
	WinActivate
else
    Run "C:\Program Files\Mozilla Firefox\firefox.exe"
return

^!r::
    Reload  ; Assign Ctrl-Alt-R as a hotkey to restart the script.
return

; macOS key bindings
!f::Send ^f
!q::!F4    ;退出
!r::Send #r
!n::Send ^n ;新建
!t::Send ^t ; new tab
!c::Send ^c ; copy
!v::Send ^v ; paste
!s::Send ^s ; save
!e::Send #e ; win+e
!w::Send ^w ;关闭网页窗口
#w::Send ^w ; win+w to close c-w
#c::Send ^c ; win+c to copy
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
#p::
SetTimer, PressTheKey, 10000
Return

^#p::
SetTimer, PressTheKey, Off     
Return

PressTheKey:
    Send, {Space}
Return
; Timer END



#o::
    o := HidListObj( )
    MsgBox % "" . o .Keyboard.1.KBSubType
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
