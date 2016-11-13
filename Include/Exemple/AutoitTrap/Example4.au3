#Region ;**** Directives created by AutoIt3Wrapper_GUI ****
#AutoIt3Wrapper_UseUpx=n
#AutoIt3Wrapper_Run_AU3Check=n
#AutoIt3Wrapper_Run_Before=ShowOriginalLine.exe %in%
#AutoIt3Wrapper_Run_After=ShowOriginalLine.exe %in%
#EndRegion ;**** Directives created by AutoIt3Wrapper_GUI ****

 ; Skip Global and Local variables.
#ShowOriginalLine_Param=/SV

#include <GUIConstantsEx.au3>
#include <StaticConstants.au3>

#include "_AutoItErrorTrap.au3"

#ShowLine_Off
If Not @Compiled Then
	MsgBox(4096, "Note:", "You need to compile first!")
	Exit
EndIf

; Default messages.
_AutoItErrorTrap()

_Example()
#ShowLine_On

Func _Example()
	Local $hForm, $iOption, $sDefaultStatus = "Ready", $iFileMenu, $iFileItem
	Local $iHelpMenu, $iInfoItem, $iExitItem, $iRecentFilesMenu, $iViewMenu
	Local $iViewStatusItem, $iStatusLabel, $sFileName
	Local $asArray[4] = ["JScript", "Jonatas", "AutoIt", "Brasil"]

	#ShowLine_Off
	$hForm = GUICreate("My GUI menu", 480, 360)

	$iFileMenu = GUICtrlCreateMenu("&File")
	$iFileItem = GUICtrlCreateMenuItem("Open", $iFileMenu)
	GUICtrlSetState(-1, $GUI_DEFBUTTON)
	$iHelpMenu = GUICtrlCreateMenu("?")
	GUICtrlCreateMenuItem("Save", $iFileMenu)
	GUICtrlSetState(-1, $GUI_DISABLE)
	$iInfoItem = GUICtrlCreateMenuItem("Info", $iHelpMenu)
	$iExitItem = GUICtrlCreateMenuItem("Exit", $iFileMenu)
	$iRecentFilesMenu = GUICtrlCreateMenu("Recent Files", $iFileMenu, 1)

	GUICtrlCreateMenuItem("", $iFileMenu, 2) ; create a separator line

	$iViewMenu = GUICtrlCreateMenu("View", -1, 1) ; is created before "?" menu
	$iViewStatusItem = GUICtrlCreateMenuItem("Statusbar", $iViewMenu)
	GUICtrlSetState(-1, $GUI_CHECKED)

	$iStatusLabel = GUICtrlCreateLabel($sDefaultStatus, 0, 325, 480, 16, BitOR($SS_SIMPLE, $SS_SUNKEN))

	GUISetState()

	$iOption = MsgBox(262180, "Error detection test!", "Hi!" & @CRLF & @CRLF & "Let's try to catch the AutoIt error window?" & _
			@CRLF & @CRLF & "Answer [Yes] to generate an array error, [No] to exit...")
	#ShowLine_On

	Select
		Case $iOption = 6 ;Yes
			; Error in array value!
			For $i = 1 To 5
				GUICtrlSetData($iStatusLabel, $asArray[$i])
			Next
		Case $iOption = 7 ;No
			;
	EndSelect

	#ShowLine_Off
	While 1
		Switch GUIGetMsg()
			Case $GUI_EVENT_CLOSE, $iExitItem
				Exit
			Case $iInfoItem
				MsgBox(4096, "Info", "Only a test...", 0, $hForm)
			Case $iFileItem
				$sFileName = FileOpenDialog("Choose file...", @TempDir, "All (*.*)")
				If @error <> 1 Then GUICtrlCreateMenuItem($sFileName, $iRecentFilesMenu)
			Case $iViewStatusItem
				If BitAND(GUICtrlRead($iViewStatusItem), $GUI_CHECKED) = $GUI_CHECKED Then
					GUICtrlSetState($iViewStatusItem, $GUI_UNCHECKED)
					GUICtrlSetState($iStatusLabel, $GUI_HIDE)
				Else
					GUICtrlSetState($iViewStatusItem, $GUI_CHECKED)
					GUICtrlSetState($iStatusLabel, $GUI_SHOW)
				EndIf
		EndSwitch
	WEnd
	#ShowLine_On
EndFunc   ;==>_Example
