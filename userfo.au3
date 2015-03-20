#Region ;**** Directives created by AutoIt3Wrapper_GUI ****
#AutoIt3Wrapper_Icon=user.ico
#AutoIt3Wrapper_Outfile_x64=AIP files\USRinFO.exe
#AutoIt3Wrapper_UseX64=y
#AutoIt3Wrapper_Res_Description=Display user info
#AutoIt3Wrapper_Res_Fileversion=1.0.0.23
#AutoIt3Wrapper_Res_LegalCopyright=Richard Easton
#AutoIt3Wrapper_Res_requestedExecutionLevel=None
#EndRegion ;**** Directives created by AutoIt3Wrapper_GUI ****
#cs ----------------------------------------------------------------------------

	AutoIt Version: 3.3.8.1
	Author:         Richard Easton

	Script Function:
	USER inFO.

#ce ----------------------------------------------------------------------------

; Script Start - Add your code below here



#include <ButtonConstants.au3>
#include <GUIConstantsEx.au3>
#include <StaticConstants.au3>
#include <WindowsConstants.au3>
#include <AD.au3>
#include <GuiButton.au3>
#include <Array.au3>
dim $studsearch, $studcheck, $sims, $stud, $auser, $DA, $h, $w, $usr, $hd, $hp, $hs, $cn, $os, $ld, $ls, $regvar, $USRinFO, $dirsize, $ivalue, $gmail, $gcal, $prog, $gdrv, $gsch, $mininmize, $dirsize, $homedir, $i, $p, $nMsg, $usrlbl, $sUser, $chngpwd, $groupsplit, $drvsize, $simspath


SplashImageOn("", "Splash.jpg", 250, 355, -1 , -1, 1)
sleep(1000)
_AD_Open()
$stud = 0
$groupsplit = stringsplit(_AD_GetUserPrimaryGroup(), ",")
$aUser = _AD_RecursiveGetMemberOf(@UserName, 10, 1)
if _ArraySearch($aUser, "Students", 0, 0,1, 1) = 1 Then
	$stud = 1
EndIf

_AD_Close()

;desktop metrics
$h = @DesktopHeight - 400
$w = @DesktopWidth - 300

;usr details
$usr = @UserName
$hd = @HomeDrive
$hp = @HomePath
$hs = @HomeShare
;local info
$cn = @ComputerName
$os = @OSArch

;network info
$ld = @LogonDomain
$ls = @LogonServer


Opt("TrayMenuMode", 3)
Opt("TrayOnEventMode", 1)
TrayCreateItem("Display", -1, -1, 1)
TrayItemSetOnEvent(-1, "Show")
TrayCreateItem("")
TrayCreateItem("About", -1, -1, 1)
TrayItemSetOnEvent(-1, "about")

;gui
Global $USRinFO = GUICreate("", 260, 350, $w, $h, 0, $WS_EX_TOOLWINDOW)
GUISetBkColor(0xffffff)
SplashImageOn("", "Splash1.jpg", 250, 355, -1 , -1, 1)
sleep(1000)

GUICtrlCreateGroup(" User Details ", 8, 8, 240, 130)

;users logon name
$usrlbl = GUICtrlCreateLabel($usr, 50, 29, 100, 25)
GUICtrlSetFont(-1, 10, 600, -1, "corbel", 5)

SplashImageOn("", "Splash2.jpg", 250, 355, -1 , -1, 1)
Sleep(1000)
if  stringmid($groupsplit[1], 4) = "Domain Admins" Then
	GUICtrlCreateIcon("Admin.ico",-1, 16, 30, 16,16)
	GUICtrlSetFont($usrlbl, 10, 600, -1, "corbel", 5)
elseif stringmid($groupsplit[1], 4) = "Domain Users" Then
	GUICtrlCreateIcon("user.ico",-1, 16, 30, 16,16)
	GUICtrlSetFont(-1, 10, 600, -1, "corbel", 5)
Else
	GUICtrlCreateIcon("Admin.ico",-1, 16, 30, 16,16)
	GUICtrlSetFont(-1, 10, 600, -1, "corbel", 5)
endif
; group
if stringmid($groupsplit[1], 4) > "" Then
	GUICtrlCreateIcon("group.ico",-1, 16, 50, 16,16)
	guictrlcreatelabel(stringmid($groupsplit[1], 4), 50, 50, 180, 25)
	GUICtrlSetFont(-1, 10, 600, -1, "corbel", 5)
Else
	GUICtrlCreateIcon("group.ico",-1, 16, 50, 16,16)
	guictrlcreatelabel("Local Login", 50, 50, 180, 25)
	GUICtrlSetFont(-1, 10, 600, -1, "corbel", 5)
EndIf

;computer name
GUICtrlCreateIcon("pc.ico",-1, 16, 70, 16,16)
GUICtrlCreateLabel($cn,50, 70, 180, 17)
GUICtrlSetFont(-1, 10, 600, -1, "corbel", 5)

;IP Address
guictrlcreateicon("IPAddress.ico", -1, 16, 90, 16, 16)
GUICtrlCreateLabel(@IPAddress1, 50, 90, 180, 25)
GUICtrlSetFont(-1, 10, 600, -1, "corbel", 5)

$dirsize = DirGetSize($hd, 1)
if stringmid($groupsplit[1], 4) > "" Then
	if isarray($dirsize) Then
		If $dirsize[0] > 1000000000 Then
			$p = $dirsize[0] / 1024 / 1024 / 1024
			$i = $p / 2.00 * 100
			guictrlcreateicon("folder.ico", -1, 16, 110, 16, 16)
			$prog = GUICtrlCreateProgress(50, 108, 150, 20)
			guictrlsetdata($prog, $i, "")
			GUICtrlCreateLabel(Round($p, 2) & " GB", 205, 110, 40, 17)
			GUICtrlSetFont(-1, 8, 400, -1, "corbel", 5)
		Else
			$p = ($dirsize[0] / 1024 / 1024)
			guictrlcreateicon("folder.ico", -1, 16, 110, 16, 16)
			$i = $p / 2.00 * 100
			guictrlcreateicon("folder.ico", -1, 16, 110, 16, 16)
			$prog = GUICtrlCreateProgress(50, 108, 150, 20)
			guictrlsetdata($prog, $i, "")
			GUICtrlCreateLabel(Round($p, 2) & " MB", 205, 110, 40, 17)
			GUICtrlSetFont(-1, 8, 400, -1, "corbel", 5)
		EndIf
	EndIf
Else
	if isarray($dirsize) Then
		$drvsize = DriveSpacefree($hd)
		$p = $dirsize[0] / 1024 / 1024 / 1024
		$i = $p / round($drvsize,2) * 100000
		guictrlcreateicon("folder.ico", -1, 16, 110, 16, 16)
		$prog = GUICtrlCreateProgress(50, 108, 150, 20)
		guictrlsetdata($prog, $i, "")
		GUICtrlCreateLabel(Round($p, 2) & " GB", 205, 110, 40, 17)
		GUICtrlSetFont(-1, 8, 400, -1, "corbel", 5)
	EndIf
EndIf

GUICtrlCreateGroup("", -99, -99, 1, 1)

GUICtrlCreateGroup(" Network Details ", 8, 140, 240, 60)
;logon domain
guictrlcreateicon("domain.ico", -1, 16, 162, 16, 16)
GUICtrlCreateLabel($ld, 50, 162, 190, 17)
GUICtrlSetFont(-1, 10, 600, -1, "corbel", 5)
;logon server
guictrlcreateicon("server.ico", -1, 16, 180, 16, 16)
GUICtrlCreateLabel($ls, 50, 180, 190, 17)
GUICtrlSetFont(-1, 10, 600, -1, "corbel", 5)
;endgroup
GUICtrlCreateGroup("", -99, -99, 1, 1)

;Google controls
GUICtrlCreateGroup(" Google Apps ", 8, 200, 240, 65)

$gmail = GUICtrlCreateButton("gmail", 16, 220, 36, 36, $BS_ICON)
GUICtrlSetImage($gmail, @ScriptDir & "\g-mail.ico", 1)
GUICtrlSetTip($gmail, "This will open your Google Mail", "USRinFo", 1, 1)
if $stud = 1 Then
	guictrlsetstate($gmail, $GUI_DISABLE)
EndIf

$gcal = GUICtrlCreateButton("gcal", 53, 220, 36, 36, $BS_ICON)
GUICtrlSetImage($gcal, @ScriptDir & "\gcal.ico", 1)
GUICtrlSetTip($gcal, "This will open your Google Calendar", "USRinFo", 1, 1)
if $stud = 1 Then
	guictrlsetstate($gcal, $GUI_DISABLE)
EndIf

$gdrv = GUICtrlCreateButton("gdrive", 90, 220, 36, 36, $BS_ICON)
GUICtrlSetImage($gdrv, @ScriptDir & "\drive.ico", 1)
GUICtrlSetTip($gdrv, "This will open your Google Drive", "USRinFo", 1, 1)
if $stud = 1 Then
	guictrlsetstate($gdrv, $GUI_DISABLE)
EndIf

$gsch = GUICtrlCreateButton("gsearch", 127, 220, 36, 36, $BS_ICON)
GUICtrlSetImage($gsch, @ScriptDir & "\gsearch.ico", 1)
GUICtrlSetTip($gsch, "This will open a Google search page", "USRinFo", 1, 1)

$chngpwd = guictrlcreatebutton("chngpwd", 164, 220, 36, 36, $BS_ICON)
GUICtrlSetImage($chngpwd, @ScriptDir & "\key.ico", 1)
GUICtrlSetTip($chngpwd, "This will change your network password", "USRinFo", 2, 1)

if stringmid($groupsplit[1], 4) > "" then
	guictrlsetstate($chngpwd, $GUI_ENABLE)
endif


if $stud = 0 then
	If FileExists("C:\Program Files\SIMS\SIMS .net\Pulsar.exe") or FileExists("C:\Program Files (x86)\SIMS\SIMS .net\Pulsar.exe") Then
		$sims = GUICtrlCreateButton("SIMS", 201, 220, 36, 36, $BS_ICON)
		GUICtrlSetImage($sims, @ScriptDir & "\sims.ico", 1)
		GUICtrlSetTip($sims, "This will open SIMS.net", "USRinFo", 1, 1)
	EndIf
EndIf

GUICtrlCreateGroup("", -99, -99, 1, 1)


;button controls
$mininmize = GUICtrlCreateButton("Minimize", 8, 280, 80, 30)
GUICtrlSetTip($mininmize, "This will minimize USRinFO", "USRinFo", 1, 1)
$homedir = GUICtrlCreateButton("Home Dir", 90, 280, 80, 30)
GUICtrlSetTip($homedir, "This will open your home directory", "USRinFo", 1, 1)

SplashImageOn("", "Splash3.jpg", 250, 355, -1 , -1, 1)
sleep(2000)
SplashOff()

GUISetState(@SW_SHOWMINIMIZED)
GUISetState(@SW_HIDE)
$show = 0

While 1
	$nMsg = GUIGetMsg()
	Switch $nMsg
		Case $GUI_EVENT_CLOSE
			Exit
		Case $mininmize
			GUISetState(@SW_HIDE)
			$show = 0
		Case $homedir
			Run("explorer.exe " & $hd, @SystemDir)
		Case $gmail
			If @OSArch = "X64" Then
				Run("C:\Program Files (x86)\Internet Explorer\iexplore.exe https://mail.google.com/mail/?tab=mm&authuser=0", "")
			Else
				Run("C:\Program Files\Internet Explorer\iexplore.exe https://mail.google.com/mail/?tab=mm&authuser=0", "")
			EndIf
		Case $gcal
			If @OSArch = "X64" Then
				Run("C:\Program Files (x86)\Internet Explorer\iexplore.exe https://www.google.com/calendar?tab=mc&authuser=0", "")
			Else
				Run("C:\Program Files\Internet Explorer\iexplore.exe https://www.google.com/calendar?tab=mc&authuser=0", "")
			EndIf
		Case $gdrv
			If @OSArch = "X64" Then
				Run("C:\Program Files (x86)\Internet Explorer\iexplore.exe https://drive.google.com/?tab=mo&authuser=0", "")
			Else
				Run("C:\Program Files\Internet Explorer\iexplore.exe https://drive.google.com/?tab=mo&authuser=0", "")
			EndIf
		Case $gsch
			If @OSArch = "X64" Then
				Run("C:\Program Files (x86)\Internet Explorer\iexplore.exe http://www.google.com/webhp?hl=en&tab=mw&authuser=0", "")
			Else
				Run("C:\Program Files\Internet Explorer\iexplore.exe http://www.google.com/webhp?hl=en&tab=mw&authuser=0", "")
			EndIf
		Case $chngpwd
			$pwd1 = InputBox("Change My Password", "enter new password", "", "*", 100, 150)
			$pwd2 = InputBox("Change My Password", "confirm new password", "", "*", 100, 150)
			_AD_Open()
			if $pwd1 > "" and $pwd2 > "" and $pwd1 = $pwd2 Then
				$sUser = _AD_SamAccountNameToFQDN(@UserName)
				Global $iValue = _AD_SetPassword($sUser, $pwd1)
				If $iValue = 1 Then
					MsgBox(64, "Change My Password", "Password for user '" & @username & "' successfully changed",3)
				ElseIf @error = 1 Then
					MsgBox(64, "Change My Password", "User '" & @username & "' does not exist")
				Elseif @error = "-2147352567" Then
					MsgBox(64, "Change My Password", "Your new password does not meet the required security parameters" & @CR & @CR & "Remember you will need a minimum of 8 characters and one of these characters MUST be a capital letter")
				Else
					MsgBox(64, "Change My Password", "There is a problem, please contact IT Support, error code: " & @error)
				EndIf
			Else
				Msgbox(48, "Change My Password", "You did not enter a password! or " & @CR & @CR & "your passwords do not match please try again! " , 5)
			EndIf
			_AD_Close()
		Case $sims
			if FileExists("C:\Program Files\sims\SIMS .net\Pulsar.exe") Then
				run("C:\Program Files\sims\SIMS .net\Pulsar.exe","")
			Elseif FileExists("C:\Program Files (x86)\sims\SIMS .net\Pulsar.exe") Then
				run("C:\Program Files (x86)\sims\SIMS .net\Pulsar.exe","")
			EndIf
	EndSwitch
WEnd

Func show()
	if $show = 0 then
		GUISetState(@SW_SHOW)
		GUISetState(@SW_RESTORE, $USRinFO)
		$show = 1
	Else
		Guisetstate(@SW_HIDE)
		GuisetState(@SW_MINIMIZE)
		$show = 0
	EndIf

EndFunc   ;==>show

Func about()
	MsgBox(64, "USRinFo", "USRinFo" & @CR & "Version: " & FileGetVersion("USRinFO.exe") & @CR & @CR & "Created By Richard Easton 2015")
EndFunc   ;==>about

