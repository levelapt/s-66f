; 2.9s-66f.au3
#include <MsgBoxConstants.au3>
Opt("SendKeyDelay", 0) ;0 milliseconds
Opt("SendKeyDownDelay", 1) ;1 millisecond
HotKeySet("{ESC}", "Terminate")
$track = ""
$artist =""
$name = ""
$class ="[CLASS:SpotifyMainWindow]"
$audacity = "Audacity"
$state = null ;"boot"
$lasttrack = WinGetTitle($class)
$export = ""
$mp3dir = "C:\Users\bob\Music\h4x\exports\"


While WinExists($class)
	$track = WinGetTitle($class)
	Switch $state
		Case "boot"
			ToolTip($state)
		If WinExists($audacity) == False Then Run("C:/Program Files (x86)/Audacity/audacity.exe")
			Sleep(2500)
			record(True)
		Case "recording"
			ToolTip($state & " | " & $lasttrack,0,0)
			If $track == $lasttrack Then
				Sleep(100)
			Else
				export()
			EndIf
		Case "exporting"
			if WinExists($lasttrack) then
				ToolTip(WinExists($lasttrack)& " | " & $state  & " | " & $lasttrack & " | " & $export,0,0)
			Else
				record(true)
			EndIf
			Sleep(300)
		Case "Spotify"
			ToolTip($state & " next track ",0,0)
			ControlSend($class, "", "", "^{RIGHT}")
		Case $lasttrack
			proc()
		Case Else
			ToolTip("lol")
			Sleep(10)
			ToolTip("\o/")
	EndSwitch
	Sleep(10)
WEnd


Func record($to)
	$track = WinGetTitle($class)
	If $to == True Then
	$lasttrack = $track
	if FileExists($mp3dir & StringRegExpReplace($lasttrack, '[\\/:*?"<>|]', '') &".mp3") Then
	ControlSend($class, "", "", "^{RIGHT}")
	record(true)
	Else

	$state = "recording"
	$trackhdl = ControlGetHandle($audacity, "", "Track Panel")
	ControlClick($audacity, "", $trackhdl,"left",1,12,12) ; Track Panel
	$rechdl = ControlGetHandle($audacity, "", "Record")
	WinActivate($class)
	WinWaitActive($class)
	ControlSend($class, "", "", "^{LEFT}")
	ControlClick($audacity, "", $rechdl) ; Record
	EndIf
	Else
	$stophdl = ControlGetHandle($audacity, "", "Stop")
	ControlClick($audacity, "", $stophdl) ; Stop
	EndIf
	Sleep(2000)
EndFunc




Func proc()
	Sleep(1000)
	record(True)
EndFunc


Func export()
	record(False)
	Sleep(50)
	WinActivate($audacity)
	WinWaitActive($audacity)
	ControlSend($audacity, "", "", "^+e")
	$splt = StringSplit($lasttrack,"-")
	If $splt[0] >= 2 Then
		$artist = $splt[1]
		$name = $splt[2]
		WinWait("Export Audio")
		Sleep(1000)
		ControlSend("Export Audio", "", "[CLASS:Edit; INSTANCE:1]", StringRegExpReplace($lasttrack, '[\\/:*?"<>|]', ''))
		ControlClick("Export Audio", "", "[CLASS:#32770; INSTANCE:1]]")
		ControlSend("Export Audio", "", "[CLASS:#32770; INSTANCE:1]", "{ENTER}")
		Sleep(500)
		If WinActive("Warning") Then ControlClick("Warning", "", "[CLASS:Button; INSTANCE:1]")
		WinWait("Edit Metadata Tags")
		Send("{TAB}")
		Sleep(10)
		Send($artist)
		Sleep(10)
		Send("{TAB}")
		Sleep(10)
		Send("{TAB}")
		Sleep(10)
		Send($name)
		Sleep(10)
		ControlClick("Edit Metadata Tags", "", "[CLASS:Button; INSTANCE:11]")
		$export = $name
		$state = "exporting"
		Sleep(500)
	WinWait($lasttrack)
	EndIf
EndFunc

Func error1()
MsgBox($MB_SYSTEMMODAL, "Error", "Wating")
While WinExists("Export Audio")
WEnd
EndFunc

Func Terminate()
	$stophdl = ControlGetHandle($audacity, "", "Stop")
	ControlClick($audacity, "", $stophdl) ; Stop
    Exit
EndFunc   ;==>Terminate
