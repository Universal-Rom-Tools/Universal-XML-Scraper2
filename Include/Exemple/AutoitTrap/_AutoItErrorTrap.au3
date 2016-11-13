#AutoIt3Wrapper_Au3Check_Parameters=-d -w 1 -w 2 -w 3 -w- 4 -w 5 -w 6 -w- 7
#include-once
; #INDEX# =======================================================================================================================
; Title .........: _AutoItErrorTrap
; Version .......: 0.11.1712.2600
; AutoIt Version.: 3.3.8.1
; Language.......: English
; Description ...: Detection and treatment of errors in the AutoIt scripts (AutoIt error trap)!
; Author ........: JScript (João Carlos)
; Remarks .......: "UseCallBack" option is based on work concept of G.Sandler (CreatoR), thanks.
; ===============================================================================================================================

#include <Math.au3>
#include <WinAPI.au3>
#include <String.au3>
#include <GuiEdit.au3>
#include <WinAPIEx.au3>
#include <GuiButton.au3>
#include <Constants.au3>
#include <SendMessage.au3>
#include <GuiImageList.au3>
#include <APIConstants.au3>
#include <ScreenCapture.au3>
#include <StaticConstants.au3>
#include <WindowsConstants.au3>

; #CURRENT# =====================================================================================================================
; _AutoItErrorTrap
; ===============================================================================================================================

; #INTERNAL_USE_ONLY# ===========================================================================================================
; __AET_SENDDATA
; __AET_RECVDATA
; __AET_RegWinClass
; __CBTProc_ErrorTrap
; __AET_MainWindow
; __AET_SendBugDlg
; __AET_ScreenDlg
; __AET_AboutDlg
; __AET_ButtonSetIcon
; __AET_ShutDown
; ===============================================================================================================================

#Tidy_Off
; #VARIABLES# ===================================================================================================================
; Call Back variables
Global $hAET_CBTPROC_CALLBKERROR
Global $hAET_CBTPROC_HOOKERROR
Global $hAET_ERROR_HWND
; Used in StdOut option...
Global $hAET_RECDATA_HWND
Global $tAET_COPYDATA
Global $pAET_COPYDATA
Global $tAET_ENTERDATA
Global $pAET_ENTERDATA
Global $iAET_LASTLINE
Global $hAET_USER32
; New error dialog
Global $hAET_WINDOW_PROC
Global $hAET_NEWDLG_HWND
; Send dialog
Global $hAET_SNDDLG_HWND
; Las screen dialog
Global $hAET_SCRDLG_HWND
; About dialog
Global $hAET_ABTDLG_HWND
; Thread and LastWin
Global $iAET_THREADID
Global $hAET_LASTWIN_HWND
; Buttons and text variables
Global $hAET_GETERROR
Global $sAET_BTN_TRYAGAIN
Global $sAET_BTN_CONTINUE
Global $sAET_BTN_CANCEL
Global $hAET_BTN_MORE
Global $hAET_BTN_SAVE
Global $hAET_BTN_LASTSCR
Global $hAET_BTN_SENDDLG
Global $hAET_SND_EDIT1
Global $hAET_SND_EDIT2
Global $hAET_BTN_SENDOK
Global $hAET_BTN_CHECKBOX
Global $sAET_BTN_OK_SNDDLG
Global $sAET_BTN_OK_SCRDLG
Global $sAET_BTN_OK_ABOUT
Global $hAET_SCR_HBITMAP
Global $hAET_LBL_INFO
Global $hAET_LBL_ERROR

#region Translations =========================================================================================================
Global $sAET_ERROR_TITLE 	= @ScriptName
Global $sAET_ERROR_TEXT 	= "A crash has been detected by AutoitErrorTrap!" & @CRLF & @CRLF & _
							"To help the development process, this program will try and gather" & _
							" the information about the crash and the state os your machine at the time of crash. " & _
							"This data can then be submited to product support."
Global $sAET_OK_BTN 		= "OK"
Global $sAET_TRYAGAIN_BTN 	= "Try Again"
Global $sAET_CONTINUE_BTN 	= "Continue"
Global $sAET_CANCEL_BTN		= "Cancel"
Global $sAET_SEND_BTN 		= "Submit"
Global $sAET_LASTSCRN_BTN 	= "Last Screen"
Global $sAET_SAVE_BTN		= "Save..."
Global $sAET_ENVIROMMENT 	= "Environment( AutoIt:" & @AutoItVersion & " - Language:" & @OSLang & " - Keyboard:" & @KBLayout & _
							" - OS:" & @OSVersion & " /  CPU:" & @CPUArch & " - OS:" & @OSArch & " )" & @CRLF & @CRLF
Global $sAET_ABOUT_TITLE	= "About"
Global $sAET_TRYCONTINUE	= "Due to system of errors, it is still not possible to continue (so far) safely!" & @CRLF & @CRLF & "Sorry for the inconvenience..."
#endregion Translations =========================================================================================================

Global $hAET_PARENT			= 0
Global $hAET_INSTANCE 		= _WinAPI_GetModuleHandle(0)
Global $vAET_USERICON 		= 0

; Flag to expand/retract window.
Global $hAET_WINGROW 		= 0

; New Error Dialog dimensions...
Global $iAET_DLG_WIDTH 		= 628
Global $iAET_DLG_HEIGHT 	= 155
Global $iAET_DLG_HGROW		= 322

; Redraws the entire window if a movement or size adjustment changes the height of the client area.
Global Const $CS_VREDRAW 	= 0x0001
Global Const $CS_HREDRAW 	= 0x0002
; Controls background color
Global $_WM_CTLCOLOR_BACKGROUND = _WinAPI_GetStockObject($WHITE_BRUSH)
; AutoIt Error Trap Class!
Global Const $sAET_CLASSNAME = 'AutoIt_ErrorTrapWindow'
;================================================================================================================================
#Tidy_On

; #EXIT_REGISTER# ===============================================================================================================
OnAutoItExitRegister("__AET_ShutDown")
; ===============================================================================================================================

;----> For debug purposes --------------------
;__AET_MainWindow()
;<--------------------------------------------

; #FUNCTION# ====================================================================================================================
; Name ..........: _AutoItErrorTrap
; Description ...: Detection and treatment of errors in the AutoIt scripts.
; Syntax ........: _AutoItErrorTrap( [sTitle [, sText [, fUseCallBack ]]])
; Parameters ....: $sTitle              - [optional] The title of the trap window. Default is "".
;                  $sText               - [optional] The text of the trap window. Default is "".
;                  $fUseCallBack        - [optional] A binary value. Default is True.
; Return values .: None
; Author ........: JScript
; Modified ......:
; Remarks .......: If the UseCallBack option is True:
;						The error detection is made in the same exe, but will fail on error "Recursion level has been exceeded..."!
;				   If False: Will use "StdOut" to read the error, but will not be compatible with CUI application!
; Related .......:
; Link ..........:
; Example .......: No
; ===============================================================================================================================
Func _AutoItErrorTrap($sTitle = "", $sText = "", $fUseCallBack = True)
	Local $iPID, $sCommandLine

	;----> Define win title and text labels.
	If $sTitle Then $sAET_ERROR_TITLE = $sTitle
	$sAET_ERROR_TITLE &= " - AutoItErrorTrap"

	If $sText Then $sAET_ERROR_TEXT = $sText
	;<----

	If $fUseCallBack Then
		;----> Trap the error window using callback!!!
		$iAET_THREADID = _WinAPI_GetCurrentThreadId()

		$hAET_CBTPROC_CALLBKERROR = DllCallbackRegister("__CBTProc_ErrorTrap", "int", "int;int;int")
		If Not $hAET_CBTPROC_CALLBKERROR Then
			Return 0
		EndIf
		$hAET_CBTPROC_HOOKERROR = _WinAPI_SetWindowsHookEx($WH_CBT, DllCallbackGetPtr($hAET_CBTPROC_CALLBKERROR), 0, $iAET_THREADID)
		If Not $hAET_CBTPROC_HOOKERROR Then
			DllCallbackFree($hAET_CBTPROC_CALLBKERROR)
			Return 0
		EndIf
		;<----
	Else
		;----> Get command line...
		If StringInStr($CmdLineRaw, "/AutoItErrorTrap") Then
			$CmdLineRaw = StringReplace($CmdLineRaw, "/AutoItErrorTrap", "")

			; Send original line number using WM_COPYDATA in stdout mode.
			If IsDeclared("__iLineNumber") Then
				$tAET_COPYDATA = DllStructCreate('ulong_ptr;dword;ptr')
				$pAET_COPYDATA = DllStructGetPtr($tAET_COPYDATA)
				$tAET_ENTERDATA = DllStructCreate('wchar[1024]')
				$pAET_ENTERDATA = DllStructGetPtr($tAET_ENTERDATA)
				DllStructSetData($tAET_COPYDATA, 2, 1024)
				DllStructSetData($tAET_COPYDATA, 3, $pAET_ENTERDATA)
				$hAET_USER32 = DllOpen("User32.dll")
				$hAET_RECDATA_HWND = WinGetHandle('[CLASS:AutoIt_ErrorTrapWindow;TITLE:WM_COPYDATA]')
				AdlibRegister("__AET_SENDDATA", 50)
			EndIf
			Return 1
		Else
			Opt("TrayIconHide", 1)
		EndIf
		;<----
		If IsDeclared("__iLineNumber") Then __AET_RECVDATA()
		;----> Trap the error window using stdout, based on idea by G.Sandler (CreatoR) in OnAutoItErrorRegister
		;	Link: http://www.autoitscript.com/forum/topic/126714-onautoiterrorregister-handle-autoit-critical-errors/
		;--
		$sCommandLine = @AutoItExe & ' /ErrorStdOut /AutoIt3ExecuteScript "' & @ScriptFullPath & '" ' & $CmdLineRaw & ' /AutoItErrorTrap'
		$iPID = Run($sCommandLine, @ScriptDir, 0, $STDERR_MERGED)
		ProcessWait($iPID)
		While 1
			$hAET_GETERROR &= StdoutRead($iPID)
			If @error Then
				ExitLoop
			EndIf
			Sleep(10)
		WEnd
		Select
			Case Not $hAET_GETERROR
				Exit
			Case $iAET_LASTLINE
				$hAET_GETERROR = StringRegExpReplace($hAET_GETERROR, "\d+[0-9]", $iAET_LASTLINE & @CRLF)
				$hAET_GETERROR = StringReplace($hAET_GETERROR, "•", @CRLF & "Module: Main/", 1)
		EndSelect
		$hAET_GETERROR = StringReplace($hAET_GETERROR, @LF, @CRLF)

		__AET_MainWindow()
		;<----
	EndIf
	;<----
	Return 1
EndFunc   ;==>_AutoItErrorTrap

; #INTERNAL_USE_ONLY# ===========================================================================================================
; Name ..........: __CBTProc_ErrorTrap
; Description ...: Trap the error window!!!
; Syntax ........: __CBTProc_ErrorTrap($nCode, $wParam, $lParam)
; Parameters ....: $nCode               - A floating point number value.
;                  $wParam              - An unknown value.
;                  $lParam              - An unknown value.
; Return values .: None
; Author ........: JScript
; Modified ......:
; Remarks .......: In this way is super fast!!!
; Related .......:
; Link ..........:
; Example .......: No
; ===============================================================================================================================
Func __CBTProc_ErrorTrap($nCode, $wParam, $lParam)
	If $nCode < 0 Then
		Return _WinAPI_CallNextHookEx($hAET_CBTPROC_HOOKERROR, $nCode, $wParam, $lParam)
	EndIf

	Switch $nCode
		;Case 3 ; HCBT_CREATEWND
		;
		Case 5 ; HCBT_ACTIVATE
			If Not _WinAPI_FindWindow("#32770", "AutoIt Error") Then
				Return _WinAPI_CallNextHookEx($hAET_CBTPROC_HOOKERROR, $nCode, $wParam, $lParam)
			EndIf

			$hAET_ERROR_HWND = HWnd($wParam)
			$hAET_GETERROR = ControlGetText($hAET_ERROR_HWND, "", "Static2")
			If IsDeclared("__iLineNumber") Then
				$hAET_GETERROR = StringRegExpReplace($hAET_GETERROR, "\d+[0-9]", Eval("__iLineNumber") & @CRLF)
				$hAET_GETERROR = StringReplace($hAET_GETERROR, "•", @CRLF & "Module: Main/", 1)
			EndIf
			$hAET_GETERROR = StringReplace($hAET_GETERROR, @LF, @CRLF)

			_WinAPI_UnhookWindowsHookEx($hAET_CBTPROC_HOOKERROR)
			_WinAPI_DestroyWindow($hAET_ERROR_HWND)

			;----> Capture last window
			Local $aEnumWin = _WinAPI_EnumWindows()
			For $i = 1 To $aEnumWin[0][0]
				If WinGetProcess($aEnumWin[$i][0]) = @AutoItPID And $aEnumWin[$i][1] = "AutoIt v3 GUI" Then
					$hAET_SCR_HBITMAP = _ScreenCapture_CaptureWnd("", $aEnumWin[$i][0])
					$hAET_LASTWIN_HWND = $aEnumWin[$i][0]
					ExitLoop
				EndIf
			Next
			;<----
			_WinAPI_ShowWindow($hAET_LASTWIN_HWND, @SW_HIDE) ; More fast than WinSetState()!!!

			__AET_MainWindow()
	EndSwitch

	Return _WinAPI_CallNextHookEx($hAET_CBTPROC_HOOKERROR, $nCode, $wParam, $lParam)
EndFunc   ;==>__CBTProc_ErrorTrap

; #INTERNAL_USE_ONLY# ===========================================================================================================
; Name ..........: __AET_SENDDATA
; Description ...: Send original line number in stdout mode.
; Syntax ........: __AET_SENDDATA()
; Parameters ....:
; Return values .: None
; Author ........: JScript
; Modified ......:
; Remarks .......:
; Related .......:
; Link ..........:
; Example .......: No
; ===============================================================================================================================
Func __AET_SENDDATA()
	DllStructSetData($tAET_ENTERDATA, 1, Eval("__iLineNumber"))
	DllCall($hAET_USER32, 'lresult', 'SendMessage', 'hwnd', $hAET_RECDATA_HWND, 'uint', $WM_COPYDATA, 'ptr', 0, 'ptr', $pAET_COPYDATA)
EndFunc   ;==>__AET_SENDDATA

; #INTERNAL_USE_ONLY# ===========================================================================================================
; Name ..........: __AET_RECVDATA
; Description ...: Receive original line number in stdout mode.
; Syntax ........: __AET_RECVDATA()
; Parameters ....:
; Return values .: None
; Author ........: JScript
; Modified ......:
; Remarks .......:
; Related .......:
; Link ..........:
; Example .......: No
; ===============================================================================================================================
Func __AET_RECVDATA()
	__AET_RegWinClass()
	$hAET_RECDATA_HWND = _WinAPI_CreateWindowEx(0, $sAET_CLASSNAME, "WM_COPYDATA", 0, 0, 0, 0, 0, 0)
EndFunc   ;==>__AET_RECVDATA

; #INTERNAL_USE_ONLY# ===========================================================================================================
; Name ..........: __AET_RegWinClass
; Description ...: Registers a AutoItErrorTrap window class.
; Syntax ........: __AET_RegWinClass()
; Parameters ....:
; Return values .: None
; Author ........: JScript
; Modified ......:
; Remarks .......:
; Related .......:
; Link ..........:
; Example .......: No
; ===============================================================================================================================
Func __AET_RegWinClass()
	Local $tWCEX, $tClass, $hIcon

	If $hAET_WINDOW_PROC Then Return 0
	;---> Passes message information to the specified window procedure.
	$hAET_WINDOW_PROC = DllCallbackRegister('__AET_CallWindowProc', 'lresult', 'hwnd;uint;wparam;lparam')

	;-- Pointer to Class Name.
	$tClass = DllStructCreate('wchar[' & StringLen($sAET_CLASSNAME) + 1 & ']')
	DllStructSetData($tClass, 1, $sAET_CLASSNAME)
	;-- Define app icon.
	$hIcon = _WinAPI_LoadShell32Icon(77)
	;-- Fill WNDCLASSEX structure.
	$tWCEX = DllStructCreate($tagWNDCLASSEX)
	DllStructSetData($tWCEX, 'Size', DllStructGetSize($tWCEX))
	DllStructSetData($tWCEX, 'Style', 0);BitOR($CS_VREDRAW, $CS_HREDRAW))
	DllStructSetData($tWCEX, 'hWndProc', DllCallbackGetPtr($hAET_WINDOW_PROC))
	DllStructSetData($tWCEX, 'ClsExtra', 0)
	DllStructSetData($tWCEX, 'WndExtra', 0)
	DllStructSetData($tWCEX, 'hInstance', $hAET_INSTANCE)
	DllStructSetData($tWCEX, 'hIcon', $hIcon)
	DllStructSetData($tWCEX, 'hCursor', _WinAPI_LoadCursor(0, $IDC_ARROW))
	DllStructSetData($tWCEX, 'hBackground', _WinAPI_GetSysColorBrush($COLOR_WINDOW))
	DllStructSetData($tWCEX, 'MenuName', 0)
	DllStructSetData($tWCEX, 'ClassName', DllStructGetPtr($tClass))
	DllStructSetData($tWCEX, 'hIconSm', 0)
	Return _WinAPI_RegisterClassEx($tWCEX)
	;<----
EndFunc   ;==>__AET_RegWinClass

#region #MAIN_WINDOW# ========================================================================================================
; #INTERNAL_USE_ONLY# ===========================================================================================================
; Name ..........: __AET_MainWindow
; Description ...:
; Syntax ........: __AET_MainWindow()
; Parameters ....: Returned by _AutoItErrorTrap function.
; Return values .: None
; Author ........: JScript
; Modified ......:
; Remarks .......:
; Related .......:
; Link ..........:
; Example .......: No
; ===============================================================================================================================
Func __AET_MainWindow()
	Local $aiMem = ProcessGetStats(), $aiIOs = ProcessGetStats(-1, 1), $sMoreInfo, $hLeftIcon, $hFont
	Local Const $STM_SETIMAGE = 0x0172

	If Not $hAET_WINDOW_PROC Then __AET_RegWinClass()

	;----> Create AutoIt Error Trap main window.
	$hAET_NEWDLG_HWND = _WinAPI_CreateWindowEx(BitOR($WS_EX_TOPMOST, $WS_EX_CONTEXTHELP), $sAET_CLASSNAME, $sAET_ERROR_TITLE, BitOR($WS_CAPTION, $WS_POPUPWINDOW, $WS_DLGFRAME), _
			(@DesktopWidth / 2) - ($iAET_DLG_WIDTH / 2), (@DesktopHeight / 2) - ($iAET_DLG_HEIGHT / 2), $iAET_DLG_WIDTH, $iAET_DLG_HEIGHT, 0)

	;-- Frame border...
	;__AET_WinCtrlStatic($hAET_NEWDLG_HWND, "", 0, 0, 622, 128, BitOR($WS_DISABLED, $SS_GRAYFRAME), $WS_EX_DLGMODALFRAME)

	;-- Left Icon
	$hLeftIcon = __AET_WinCtrlStatic($hAET_NEWDLG_HWND, "", 16, 10, 32, 32, BitOR($WS_DISABLED, $SS_Icon))
	_WinAPI_DestroyIcon(_SendMessage($hLeftIcon, $STM_SETIMAGE, 1, _WinAPI_LoadIcon(0, $IDI_INFORMATION)))

	;-- Info text
	$hAET_LBL_INFO = __AET_WinCtrlStatic($hAET_NEWDLG_HWND, $sAET_ERROR_TEXT, 60, 10, 435, 106)
	$hFont = _WinAPI_CreateFont(14, 0, 0, 0, $FW_MEDIUM, False, False, False, $DEFAULT_CHARSET, $OUT_DEFAULT_PRECIS, $CLIP_DEFAULT_PRECIS, $DEFAULT_QUALITY, 0, 'Tahoma')
	_WinAPI_SetFont($hAET_LBL_INFO, $hFont)

	;-- Add new buttons...
	$sAET_BTN_TRYAGAIN = _GUICtrlButton_Create($hAET_NEWDLG_HWND, $sAET_TRYAGAIN_BTN, 504, 10, 108, 26) ; Try Again
	$sAET_BTN_CONTINUE = _GUICtrlButton_Create($hAET_NEWDLG_HWND, $sAET_CONTINUE_BTN, 504, 50, 108, 26) ; Continue
	$sAET_BTN_CANCEL = _GUICtrlButton_Create($hAET_NEWDLG_HWND, $sAET_CANCEL_BTN, 504, 90, 108, 26) ; Cancel
	$hAET_BTN_MORE = _GUICtrlButton_Create($hAET_NEWDLG_HWND, "", 12, 94, 26, 26) ; More...

	;-- Line separator...
	__AET_WinCtrlStatic($hAET_NEWDLG_HWND, "", 0, 128, $iAET_DLG_WIDTH, 2, BitOR($WS_DISABLED, $SS_GRAYFRAME, $SS_SUNKEN))

	;-- GroupBox
	__AET_WinCtrlGroupBox($hAET_NEWDLG_HWND, "Exception Reason", 10, 136, 602, 130)

	;-- Error Info
	$hAET_GETERROR &= @CRLF & @CRLF & $sAET_ENVIROMMENT
	$hAET_LBL_ERROR = _GUICtrlEdit_Create($hAET_NEWDLG_HWND, $hAET_GETERROR, 18, 152, 590, 110, BitOR($ES_MULTILINE, $ES_AUTOVSCROLL, $ES_READONLY, $WS_VSCROLL), $WS_EX_TRANSPARENT)

	;-- GroupBox - Memory Information
	__AET_WinCtrlGroupBox($hAET_NEWDLG_HWND, "Memory Information", 10, 272, 192, 130)
	;-- Memory Info
	$sMoreInfo = "Working Set Size" & @TAB & Int($aiMem[0] / 1024) & @CRLF
	$sMoreInfo &= "Peak Working Set" & @TAB & Int($aiMem[1] / 1024) & @CRLF & @CRLF
	$aiMem = MemGetStats()
	$sMoreInfo &= "Total Physical" & @TAB & Int($aiMem[1] / 1024) & @CRLF
	$sMoreInfo &= "Available Physical" & @TAB & Int($aiMem[2] / 1024) & @CRLF
	$sMoreInfo &= "Total PageFile" & @TAB & Int($aiMem[3] / 1024) & @CRLF
	$sMoreInfo &= "Available PageFile" & @TAB & Int($aiMem[4] / 1024) & @CRLF
	$sMoreInfo &= "Total Virtual" & @TAB & Int($aiMem[5] / 1024) & @CRLF
	$sMoreInfo &= "Available Virtual" & @TAB & Int($aiMem[6] / 1024)
	$hAET_GETERROR &= @CRLF & @CRLF & "* Memory information *" & @CRLF & @CRLF & $sMoreInfo & @CRLF
	_GUICtrlEdit_Create($hAET_NEWDLG_HWND, $sMoreInfo, 18, 288, 181, 110, BitOR($ES_MULTILINE, $ES_AUTOVSCROLL, $ES_READONLY, $WS_VSCROLL), $WS_EX_TRANSPARENT)

	;-- GroupBox - IO Operations
	__AET_WinCtrlGroupBox($hAET_NEWDLG_HWND, "IO Operations", 215, 272, 192, 130)
	;-- IO Operations
	$sMoreInfo = @CRLF & "Read Operations" & @TAB & $aiIOs[0] & @CRLF
	$sMoreInfo &= "Write Operations" & @TAB & $aiIOs[1] & @CRLF
	$sMoreInfo &= "Others Operations" & @TAB & $aiIOs[2] & @CRLF
	$sMoreInfo &= "Read Bytes" & @TAB & $aiIOs[3] & @CRLF
	$sMoreInfo &= "Write Bytes" & @TAB & $aiIOs[4] & @CRLF
	$sMoreInfo &= "Other Bytes R\W" & @TAB & $aiIOs[5]
	$hAET_GETERROR &= @CRLF & "* IO information *" & @CRLF & $sMoreInfo & @CRLF
	_GUICtrlEdit_Create($hAET_NEWDLG_HWND, $sMoreInfo, 223, 288, 181, 110, BitOR($ES_MULTILINE, $ES_AUTOVSCROLL, $ES_READONLY, $WS_VSCROLL), $WS_EX_TRANSPARENT)

	;-- GroupBox - OS Information
	__AET_WinCtrlGroupBox($hAET_NEWDLG_HWND, "OS Information", 420, 272, 192, 130)
	;-- OS Information
	$sMoreInfo = @CRLF & "Architecture" & @TAB & @OSArch & @CRLF
	$sMoreInfo &= "Version number" & @TAB & @OSVersion & @CRLF
	$sMoreInfo &= "ServicePack" & @TAB & @OSServicePack & @CRLF
	$sMoreInfo &= "Build number" & @TAB & @OSBuild & @CRLF
	$sMoreInfo &= "Language" & @TAB & @OSLang & @CRLF
	$sMoreInfo &= "Keyboard Layout" & @TAB & @KBLayout
	$hAET_GETERROR &= @CRLF & "* OS information *" & @CRLF & $sMoreInfo & @CRLF
	_GUICtrlEdit_Create($hAET_NEWDLG_HWND, $sMoreInfo, 428, 288, 181, 110, BitOR($ES_MULTILINE, $ES_AUTOVSCROLL, $ES_READONLY, $WS_VSCROLL), $WS_EX_TRANSPARENT)

;~ 	$hAET_BTN_SENDDLG = _GUICtrlButton_Create($hAET_NEWDLG_HWND, $sAET_SEND_BTN, 10, 412, 108, 26, $BS_VCENTER)
	$hAET_BTN_LASTSCR = _GUICtrlButton_Create($hAET_NEWDLG_HWND, $sAET_LASTSCRN_BTN, 386, 412, 108, 26)
	If Not $hAET_SCR_HBITMAP Then
		_GUICtrlButton_Enable($hAET_BTN_LASTSCR, False)
	EndIf
	$hAET_BTN_SAVE = _GUICtrlButton_Create($hAET_NEWDLG_HWND, $sAET_SAVE_BTN, 504, 412, 108, 26)

	;-- Set buttons icons.
	If @OSVersion = "WIN_XP" Then
		__AET_ButtonSetIcon($sAET_BTN_TRYAGAIN, 24)
		__AET_ButtonSetIcon($hAET_BTN_SAVE, 6)
	Else
		__AET_ButtonSetIcon($sAET_BTN_TRYAGAIN, 238)
		__AET_ButtonSetIcon($hAET_BTN_SAVE, 258)
	EndIf
	__AET_ButtonSetIcon($sAET_BTN_CONTINUE, 109)
	__AET_ButtonSetIcon($sAET_BTN_CANCEL, 131)
	__AET_ButtonSetIcon($hAET_BTN_SENDDLG, 156)
	__AET_ButtonSetIcon($hAET_BTN_LASTSCR, 139)
	__AET_ButtonSetIcon($hAET_BTN_MORE, 1, 24, 24, 4, "Cliconfg.rll")

	;-- Activates the window and displays it in its current size and position
	_WinAPI_ShowWindow($hAET_NEWDLG_HWND, @SW_SHOW)

	;WinWaitClose($hAET_NEWDLG_HWND)
	While 1
		Sleep(1000)
	WEnd
EndFunc   ;==>__AET_MainWindow
#endregion #MAIN_WINDOW# ========================================================================================================

; #INTERNAL_USE_ONLY# ===========================================================================================================
; Name ..........: __AET_CallWindowProc
; Description ...:
; Syntax ........: __AET_CallWindowProc($hWnd, $iMsg, $wParam, $lParam)
; Parameters ....: $hWnd                - A handle value.
;                  $iMsg                - An integer value.
;                  $wParam              - An unknown value.
;                  $lParam              - An unknown value.
; Return values .: None
; Author ........: JScript
; Modified ......:
; Remarks .......:
; Related .......:
; Link ..........:
; Example .......: No
; ===============================================================================================================================
Func __AET_CallWindowProc($hWnd, $iMsg, $wParam, $lParam)
	Local $nNotifyCode, $hCtrlWnd, $hDC

	;--> Commom to all windows.
	Switch $iMsg
		Case $WM_COPYDATA
			If $hWnd = $hAET_RECDATA_HWND Then
				$tAET_COPYDATA = DllStructCreate('ulong_ptr;dword;ptr', $lParam)
				$tAET_ENTERDATA = DllStructCreate('wchar[1024]', DllStructGetData($tAET_COPYDATA, 3))

				$iAET_LASTLINE = DllStructGetData($tAET_ENTERDATA, 1)
				Return 1
			EndIf

		Case $WM_COMMAND
			$nNotifyCode = _WinAPI_HiWord($wParam)
			If $nNotifyCode Then Return 0
			$hCtrlWnd = $lParam

			Switch $hCtrlWnd
				Case $sAET_BTN_OK_ABOUT
					_SendMessage($hWnd, $WM_CLOSE)
			EndSwitch

		Case $WM_SYSCOMMAND
			; In WM_SYSCOMMAND messages, the four low-order (? _ [] X) bits of the wParam parameter are used internally by the system.
			; To obtain the correct result when testing the value of wParam, an application must combine the value 0xFFF0 with the
			; wParam value by using the bitwise AND operator.
			Switch BitAND($wParam, 0xFFF0)
				Case 0xF180 ; SC_CONTEXTHELP
					__AET_AboutDlg($hWnd)
					Return 0
			EndSwitch

		Case $WM_CLOSE
			If $hWnd = $hAET_NEWDLG_HWND Then
				;$iAET_DLG_HEIGHT = _WinAPI_GetWindowHeight($hWnd)
				;While $iAET_DLG_HEIGHT > 25
				;	WinSetTrans($hWnd, "", $iAET_DLG_HEIGHT)
				;	WinMove($hWnd, "", Default, (@DesktopHeight / 2) - ($iAET_DLG_HEIGHT / 2), $iAET_DLG_WIDTH, $iAET_DLG_HEIGHT)
				;	$iAET_DLG_HEIGHT -= 20
				;	Sleep(10)
				;WEnd
			EndIf
			_WinAPI_DestroyWindow($hWnd)

		Case $WM_DESTROY
			If $hWnd = $hAET_NEWDLG_HWND Then
				Exit
			EndIf

		Case $WM_KEYDOWN
			; Check if the window receive [ESC] key to exit!
			If _WinAPI_LoWord($wParam) = 27 Then
				_SendMessage($hWnd, $WM_CLOSE)
			EndIf

			;Case $WM_NOTIFY

		Case $WM_CTLCOLORSTATIC, $WM_CTLCOLOREDIT
			$hDC = $wParam
			$hCtrlWnd = $lParam
			Switch $hCtrlWnd
				Case $hAET_LBL_INFO, $hAET_LBL_ERROR
					_WinAPI_SetTextColor($hDC, 0x0000FF)

				Case Else
					;_WinAPI_SetBkMode($hDC, $TRANSPARENT)

			EndSwitch
			Return $_WM_CTLCOLOR_BACKGROUND
	EndSwitch

	;-- Read individual messages for each window.
	Switch $hWnd
		Case $hAET_SNDDLG_HWND

			Switch $iMsg
				Case $WM_COMMAND
					Switch $hCtrlWnd
						Case $hAET_BTN_SENDOK
							MsgBox(262208, "Info", "Still currently being created!", 0, $hWnd)

						Case $sAET_BTN_OK_SNDDLG
							_SendMessage($hWnd, $WM_CLOSE)

					EndSwitch
			EndSwitch

		Case $hAET_SCRDLG_HWND

			Switch $iMsg
				Case $WM_COMMAND
					Switch $hCtrlWnd
						Case $sAET_BTN_OK_SCRDLG
							_SendMessage($hWnd, $WM_CLOSE)

						Case $hAET_BTN_CHECKBOX
							MsgBox(262208, "Info", "Still currently being created!", 0, $hWnd)

					EndSwitch
			EndSwitch

		Case $hAET_NEWDLG_HWND

			Switch $iMsg
				Case $WM_COMMAND
					Switch $hCtrlWnd
						Case $sAET_BTN_TRYAGAIN
							ShellExecute(@AutoItExe, $CmdLineRaw, "")
							_SendMessage($hWnd, $WM_CLOSE)

						Case $sAET_BTN_CONTINUE
							_WinAPI_ShowWindow($hAET_NEWDLG_HWND, @SW_HIDE)
							_WinAPI_ShowWindow($hAET_LASTWIN_HWND, @SW_SHOW) ; Call("_Main")
							MsgBox(262208, $sAET_ABOUT_TITLE, $sAET_TRYCONTINUE, 0, $hAET_LASTWIN_HWND)
							;ShellExecute(@AutoItExe, $CmdLineRaw, "")
							_SendMessage($hWnd, $WM_CLOSE)

						Case $sAET_BTN_CANCEL
							_SendMessage($hWnd, $WM_CLOSE)

						Case $hAET_BTN_MORE
							Local $iNewHeight = $iAET_DLG_HEIGHT + $iAET_DLG_HGROW

							Switch $hAET_WINGROW
								Case 0
									$hAET_WINGROW = 1
									__AET_ButtonSetIcon($hAET_BTN_MORE, 3, 24, 24, 4, "Cliconfg.rll")
								Case 1
									$hAET_WINGROW = 0
									$iNewHeight = $iAET_DLG_HEIGHT
									__AET_ButtonSetIcon($hAET_BTN_MORE, 1, 24, 24, 4, "Cliconfg.rll")
							EndSwitch
							; Left = Default or (@DesktopWidth / 2) - ($iAET_DLG_WIDTH / 2)
							WinMove($hWnd, "", Default, (@DesktopHeight / 2) - (($iNewHeight) / 2), Default, $iNewHeight)

						Case $hAET_BTN_SAVE
							Local $sFileName = FileSaveDialog("Choose a name.", @ScriptDir, "Text (*.txt;*.log)", 2, @ScriptName & ".log", $hWnd)
							If Not @error Then
								Local $hFileOpen = FileOpen($sFileName, 2)
								If $hFileOpen Then
									FileWrite($hFileOpen, $hAET_GETERROR & @CRLF & "Last System Error Message: " & _WinAPI_GetLastErrorMessage())
									FileClose($hFileOpen)
									_ScreenCapture_SaveImage(@ScriptDir & "\LastScreen.jpg", $hAET_SCR_HBITMAP)
									MsgBox(262208, "Info", 'The log file "' & @ScriptName & '".log was written with success!', 0, $hWnd)
								EndIf
							EndIf

						Case $hAET_BTN_LASTSCR
							__AET_ScreenDlg($hWnd)

						Case $hAET_BTN_SENDDLG
							__AET_SendBugDlg($hWnd)

					EndSwitch
					Return 0
			EndSwitch
	EndSwitch

	Return _WinAPI_DefWindowProcW($hWnd, $iMsg, $wParam, $lParam)
EndFunc   ;==>__AET_CallWindowProc

#region #SND_DIALOG# =========================================================================================================
; #INTERNAL_USE_ONLY# ===========================================================================================================
; Name ..........: __AET_SendBugDlg
; Description ...:
; Syntax ........: __AET_SendBugDlg()
; Parameters ....:
; Return values .: None
; Author ........: JScript
; Modified ......:
; Remarks .......:
; Related .......:
; Link ..........:
; Example .......: No
; ===============================================================================================================================
Func __AET_SendBugDlg($hWnd)
	Local $ICON_SMALL = 0

	_WinAPI_EnableWindow($hWnd, False)
	;----> Create window
	$hAET_SNDDLG_HWND = _WinAPI_CreateWindowEx(BitOR($WS_EX_TOPMOST, $WS_EX_CONTEXTHELP), $sAET_CLASSNAME, $sAET_SEND_BTN, _
			BitOR($WS_CAPTION, $WS_POPUPWINDOW, $WS_DLGFRAME), (@DesktopWidth / 2) - (500 / 2), (@DesktopHeight / 2) - (400 / 2), 500, 400, $hWnd)

	;-- GroupBoxs
	__AET_WinCtrlGroupBox($hAET_SNDDLG_HWND, "Title: ", 4, 4, 486, 36)
	__AET_WinCtrlGroupBox($hAET_SNDDLG_HWND, "Description: ", 4, 46, 486, 264)

	;-- Edit Title
	$hAET_SND_EDIT1 = _GUICtrlEdit_Create($hAET_SNDDLG_HWND, $sAET_ERROR_TITLE, 10, 18, 474, 18, $ES_LEFT, $WS_EX_TRANSPARENT)
	_GUICtrlEdit_SetLimitText($hAET_SND_EDIT1, 80)

	;-- Edit Body (description)
	$hAET_SND_EDIT2 = _GUICtrlEdit_Create($hAET_SNDDLG_HWND, $hAET_GETERROR & @CRLF & "Last System Error Message: " & _WinAPI_GetLastErrorMessage(), 10, 64, 476, 242, _
			BitOR($ES_MULTILINE, $ES_AUTOVSCROLL, $WS_VSCROLL, $ES_WANTRETURN), $WS_EX_TRANSPARENT)

	;-- Line separator...
	__AET_WinCtrlStatic($hAET_SNDDLG_HWND, "", 0, 322, 500, 2, BitOR($WS_DISABLED, $SS_GRAYFRAME, $SS_SUNKEN))

	$hAET_BTN_SENDOK = _GUICtrlButton_Create($hAET_SNDDLG_HWND, $sAET_SEND_BTN, 209, 334, 108, 26)
	$sAET_BTN_OK_SNDDLG = _GUICtrlButton_Create($hAET_SNDDLG_HWND, $sAET_OK_BTN, 327, 334, 108, 26)

	;-- Set buttons icons.
	__AET_ButtonSetIcon($hAET_BTN_SENDOK, 156) ; Send
	__AET_ButtonSetIcon($sAET_BTN_OK_SNDDLG, 144) ; OK
	;<----

	_WinAPI_ShowWindow($hAET_SNDDLG_HWND, @SW_SHOW)

	;-- Set title bar icon
	_WinAPI_DestroyIcon(_SendMessage($hAET_SNDDLG_HWND, $WM_SETICON, $ICON_SMALL, _WinAPI_LoadShell32Icon(156)))
	;<----

	WinWaitClose($hAET_SNDDLG_HWND)
	_WinAPI_EnableWindow($hWnd, True)
	_WinAPI_SetActiveWindow($hWnd)
EndFunc   ;==>__AET_SendBugDlg
#endregion #SND_DIALOG# =========================================================================================================

#region #SCREEN_DIALOG# ======================================================================================================
; #INTERNAL_USE_ONLY# ===========================================================================================================
; Name ..........: __AET_ScreenDlg
; Description ...:
; Syntax ........: __AET_ScreenDlg()
; Parameters ....:
; Return values .: None
; Author ........: JScript
; Modified ......:
; Remarks .......:
; Related .......:
; Link ..........:
; Example .......: No
; ===============================================================================================================================
Func __AET_ScreenDlg($hWnd)
	Local Const $STM_SETIMAGE = 0x0172, $ICON_SMALL = 0, $SS_REALSIZECONTROL = 0x40
	Local $hCtrlWnd, $iWidth = 720, $iHeight = 480, $iCtrlWidth = 714, $iCtrlHeight = 400, $iScale

	_WinAPI_EnableWindow($hWnd, False)
	;----> Create window
	$hAET_SCRDLG_HWND = _WinAPI_CreateWindowEx(BitOR($WS_EX_TOPMOST, $WS_EX_CONTEXTHELP), $sAET_CLASSNAME, $sAET_LASTSCRN_BTN, BitOR($WS_CAPTION, $WS_POPUPWINDOW, $WS_DLGFRAME), _
			(@DesktopWidth / 2) - ($iWidth / 2), (@DesktopHeight / 2) - ($iHeight / 2), $iWidth, $iHeight, $hWnd) ; Wide...

	;-- Sets the $SS_BITMAP and $SS_REALSIZECONTROL...
	$hCtrlWnd = __AET_WinCtrlStatic($hAET_SCRDLG_HWND, "", 0, 0, 0, 0, BitOR($WS_DISABLED, $SS_REALSIZECONTROL, $SS_SUNKEN, $SS_BITMAP))

	;-- Send image to control.
	_SendMessage($hCtrlWnd, $STM_SETIMAGE, 0, $hAET_SCR_HBITMAP)

	;-- Initialize GDI+ library only if not alread started!
	_GDIPlus_Startup()

	;-- Get image file dimensions.
	Local $hBitmap = _GDIPlus_BitmapCreateFromHBITMAP($hAET_SCR_HBITMAP)
	Local $iOWidth = _GDIPlus_ImageGetWidth($hBitmap)
	Local $iOHeight = _GDIPlus_ImageGetHeight($hBitmap)
	_GDIPlus_BitmapDispose($hBitmap)

	$iScale = _Min($iCtrlWidth / $iOWidth, $iCtrlHeight / $iOHeight)
	Select
		Case $iOWidth > $iCtrlWidth
			$iCtrlWidth = Round($iOWidth * $iScale)
		Case Else
			$iCtrlWidth = $iOWidth
	EndSelect
	Select
		Case $iOHeight > $iCtrlHeight
			$iCtrlHeight = Round($iOHeight * $iScale)
		Case Else
			$iCtrlHeight = $iOHeight
	EndSelect
	_WinAPI_MoveWindow($hCtrlWnd, ($iWidth / 2) - ($iCtrlWidth / 2), (($iHeight - 80) / 2) - ($iCtrlHeight / 2), $iCtrlWidth, $iCtrlHeight)

	;-- Clean up resources used by Microsoft Windows GDI+.
	_GDIPlus_Shutdown()

	;-- Line separator...
	__AET_WinCtrlStatic($hAET_SCRDLG_HWND, "", 0, 402, 720, 2, BitOR($WS_DISABLED, $SS_GRAYFRAME, $SS_SUNKEN))

	$sAET_BTN_OK_SCRDLG = _GUICtrlButton_Create($hAET_SCRDLG_HWND, $sAET_OK_BTN, 596, 415, 108, 26)

	;-- Set buttons icons.
	__AET_ButtonSetIcon($sAET_BTN_OK_SCRDLG, 144) ; OK
	;<----

	_WinAPI_ShowWindow($hAET_SCRDLG_HWND, @SW_SHOW)

	;-- Set title bar icon
	_WinAPI_DestroyIcon(_SendMessage($hAET_SCRDLG_HWND, $WM_SETICON, $ICON_SMALL, _WinAPI_LoadShell32Icon(139)))
	;<----

	WinWaitClose($hAET_SCRDLG_HWND)
	_WinAPI_EnableWindow($hWnd, True)
	_WinAPI_SetActiveWindow($hWnd)
EndFunc   ;==>__AET_ScreenDlg
#endregion #SCREEN_DIALOG# ======================================================================================================

#region #ABOUT_DIALOG# =======================================================================================================
; #INTERNAL_USE_ONLY# ===========================================================================================================
; Name ..........: __AET_AboutDlg
; Description ...:
; Syntax ........: __AET_AboutDlg()
; Parameters ....:
; Return values .: None
; Author ........: JScript
; Modified ......:
; Remarks .......:
; Related .......:
; Link ..........:
; Example .......: No
; ===============================================================================================================================
Func __AET_AboutDlg($hWnd)
	Local $sText, $hStatic, $hFont, $hLeftIcon
	Local Const $ICON_SMALL = 0;, $STM_SETIMAGE = 0x0172

	_WinAPI_EnableWindow($hWnd, False)
	;----> Create window
	$hAET_ABTDLG_HWND = _WinAPI_CreateWindowEx($WS_EX_TOPMOST, $sAET_CLASSNAME, $sAET_ABOUT_TITLE, _
			BitOR($WS_CAPTION, $WS_POPUPWINDOW, $WS_DLGFRAME), (@DesktopWidth / 2) - (477 / 2), (@DesktopHeight / 2) - (369 / 2), 477, 369, $hWnd)

	$sText = 'Case $HCBT_ACTIVATE' & @CRLF & _
			'	If Not WinExists("[CLASS:#32770;TITLE:AutoIt Error]") Or $hAET_ERROR_HWND Then' & @CRLF & _
			'		Return _WinAPI_CallNextHookEx($hAET_CBTPROC_HOOKERROR, $nCode, $wParam, $lParam)' & @CRLF & _
			'	EndIf' & @CRLF & @CRLF & _
			'	;----> Capture last window' & @CRLF & _
			'	Local $aEnumWin = _WinAPI_EnumWindows()' & @CRLF & _
			'	For $i = 1 To $aEnumWin[0][0]' & @CRLF & _
			'		If WinGetProcess($aEnumWin[$i][0]) = @AutoItPID And $aEnumWin[$i][1] = "AutoIt v3 GUI" Then' & @CRLF & _
			'			$hAET_SCR_HBITMAP = _ScreenCapture_CaptureWnd("", $aEnumWin[$i][0])' & @CRLF & _
			'			$hAET_LASTWIN_HWND = $aEnumWin[$i][0]' & @CRLF & _
			'			ExitLoop' & @CRLF & _
			'		EndIf' & @CRLF & _
			'	Next' & @CRLF & _
			'	;<----' & @CRLF & _
			'	_WinAPI_ShowWindow($hAET_LASTWIN_HWND, @SW_HIDE) ; More fast than WinSetState()!!!' & @CRLF & _
			'	$hAET_ERROR_HWND = WinGetHandle("[CLASS:#32770;TITLE:AutoIt Error]")' & @CRLF & _
			'	$hAET_GETERROR = StringReplace(ControlGetText($hAET_ERROR_HWND, "", "Static2"), @LF, @CRLF)' & @CRLF & _
			'	$hAET_GETERROR = StringRegExpReplace($hAET_GETERROR, "\d+[0-9]", Eval("__iLineNumber") & @CRLF)' & @CRLF & _
			'	__AET_NewDialog()' & @CRLF & _
			'Case $HCBT_DESTROYWND' & @CRLF & _
			'	If $wParam = $hAET_ERROR_HWND Then' & @CRLF & _
			'		_WinAPI_UnhookWindowsHookEx($hAET_CBTPROC_HOOKERROR)'
	__AET_WinCtrlStatic($hAET_ABTDLG_HWND, $sText, 0, 0, 471, 289, BitOR($WS_DISABLED, $SS_LEFTNOWORDWRAP))

	;-- Left Icon
	;$hLeftIcon = __AET_WinCtrlStatic($hAET_ABTDLG_HWND, "", 16, 10, 32, 32, BitOR($WS_DISABLED, $SS_Icon))
	;_WinAPI_DestroyIcon(_SendMessage($hLeftIcon, $STM_SETIMAGE, 1, _WinAPI_LoadIcon(0, $IDI_APPLICATION)))

	$hLeftIcon = _GUIImageList_Create(32, 32, 5, 4)
	Local $hBitmap = _WinAPI_LoadImage(0, _IconAni(), $IMAGE_BITMAP, 0, 0, BitOR($LR_LOADFROMFILE, $LR_CREATEDIBSECTION, $LR_LOADTRANSPARENT))
	_GUIImageList_Add($hLeftIcon, $hBitmap)

	;-- Draw frame...
	__AET_WinCtrlStatic($hAET_ABTDLG_HWND, "", 61, 22, 377, 249, BitOR($WS_DISABLED, $SS_GRAYFRAME, $SS_SUNKEN), $WS_EX_DLGMODALFRAME)

	$sText = "Detection and treatment of errors in the AutoIt scripts!" & @CRLF & @CRLF & "" & _
			"(Free Software) Redistribute and change under these terms:" & @CRLF & @CRLF & _
			"This program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License" & @CRLF & _
			"as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version." & @CRLF & @CRLF & _
			"This program is distributed in the hope that it will be useful, but WITHOUT ANY WARRANTY; without even the implied warranty" & @CRLF & _
			"of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the GNU General Public License for more details." & @CRLF & @CRLF & _
			"You should have received a copy of the GNU General Public License along with this program. If not, see <http://www.gnu.org/licenses/>."
	$hStatic = __AET_WinCtrlStatic($hAET_ABTDLG_HWND, $sText, 65, 26, 369, 242, $SS_CENTER)
	$hFont = _WinAPI_CreateFont(14, 0, 0, 0, $FW_MEDIUM, False, False, False, $DEFAULT_CHARSET, _
			$OUT_DEFAULT_PRECIS, $CLIP_DEFAULT_PRECIS, $DEFAULT_QUALITY, 0, 'Tahoma')
	_WinAPI_SetFont($hStatic, $hFont)

	__AET_WinCtrlStatic($hAET_ABTDLG_HWND, "; JScript - Brazil!", 356, 271, 80, 16, BitOR($WS_DISABLED, $SS_LEFTNOWORDWRAP))

	;-- Line separator...
	__AET_WinCtrlStatic($hAET_ABTDLG_HWND, "", 0, 292, 477, 2, BitOR($WS_DISABLED, $SS_GRAYFRAME, $SS_SUNKEN))

	;-- Set buttons icons.
	$sAET_BTN_OK_ABOUT = _GUICtrlButton_Create($hAET_ABTDLG_HWND, $sAET_OK_BTN, 375, 304, 88, 26) ; Ok
	__AET_ButtonSetIcon($sAET_BTN_OK_ABOUT, 144) ; OK
	;<----

	_WinAPI_ShowWindow($hAET_ABTDLG_HWND, @SW_SHOW)

	;-- Set title bar icon
	_WinAPI_DestroyIcon(_SendMessage($hAET_ABTDLG_HWND, $WM_SETICON, $ICON_SMALL, _WinAPI_LoadShell32Icon(154)))
	;<----

	;----> Simple left icon animation ;-)
	Local $iIndex = 0, $hDll = DllOpen("comctl32.dll"), $hDC = _WinAPI_GetDC($hAET_ABTDLG_HWND)
	While WinExists($hAET_ABTDLG_HWND)
		DllCall($hDll, "bool", "ImageList_Draw", "handle", $hLeftIcon, "int", $iIndex, "handle", $hDC, "int", 16, "int", 10, "uint", 0)
		$iIndex += 1
		If $iIndex > 4 Then
			$iIndex = 0
		EndIf
		Sleep(100)
	WEnd
	DllClose($hDll)
	_WinAPI_ReleaseDC($hAET_ABTDLG_HWND, $hDC)
	;<----
	_WinAPI_DeleteObject($hFont)
	_WinAPI_EnableWindow($hWnd, True)
	_WinAPI_SetActiveWindow($hWnd)
EndFunc   ;==>__AET_AboutDlg

; #INTERNAL_USE_ONLY# ===========================================================================================================
; Name ..........: __AET_WinCtrlGroupBox
; Description ...:
; Syntax ........: __AET_WinCtrlGroupBox($hWnd, $sText, $iLeft, $iTop, $iWidth, $iHeight[, $iStyle = -1[, $iExStyle = -1]])
; Parameters ....: $hWnd                - A handle value.
;                  $sText               - A string value.
;                  $iLeft               - An integer value.
;                  $iTop                - An integer value.
;                  $iWidth              - An integer value.
;                  $iHeight             - An integer value.
;                  $iStyle              - [optional] An integer value. Default is -1.
;                  $iExStyle            - [optional] An integer value. Default is -1.
; Return values .: None
; Author ........: JScript
; Modified ......:
; Remarks .......:
; Related .......:
; Link ..........:
; Example .......: No
; ===============================================================================================================================
Func __AET_WinCtrlGroupBox($hWnd, $sText, $iLeft, $iTop, $iWidth, $iHeight, $iStyle = -1, $iExStyle = -1)
	Local $iForcedStyle = BitOR($WS_GROUP, $BS_GROUPBOX, $WS_VISIBLE, $WS_CHILD)
	Local Static $iCtrlID = 0

	; Determines the last child-window identifier; it must be unique for all child windows with the same parent window.
	__AET_GetLastCtrlID($hWnd, $iCtrlID)

	If $iStyle = -1 Then
		$iStyle = $iForcedStyle
	Else
		$iStyle = BitOR($iStyle, $iForcedStyle)
	EndIf
	If $iExStyle = -1 Then $iExStyle = 0
	;$iExStyle = BitOR($iExStyle, $WS_EX_NOACTIVATE)
	Local $hGroup = _WinAPI_CreateWindowEx($iExStyle, "BUTTON", $sText, $iStyle, $iLeft, $iTop, $iWidth, $iHeight, $hWnd, $iCtrlID)
	_SendMessage($hGroup, $WM_SETFONT, _WinAPI_GetStockObject($DEFAULT_GUI_FONT), True)
	Return $hGroup
EndFunc   ;==>__AET_WinCtrlGroupBox

; #INTERNAL_USE_ONLY# ===========================================================================================================
; Name ..........: __AET_WinCtrlStatic
; Description ...:
; Syntax ........: __AET_WinCtrlStatic($hWnd, $sText, $iLeft, $iTop, $iWidth, $iHeight[, $iStyle = -1[, $iExStyle = -1]])
; Parameters ....: $hWnd                - A handle value.
;                  $sText               - A string value.
;                  $iLeft               - An integer value.
;                  $iTop                - An integer value.
;                  $iWidth              - An integer value.
;                  $iHeight             - An integer value.
;                  $iStyle              - [optional] An integer value. Default is -1.
;                  $iExStyle            - [optional] An integer value. Default is -1.
; Return values .: None
; Author ........: JScript
; Modified ......:
; Remarks .......:
; Related .......:
; Link ..........:
; Example .......: No
; ===============================================================================================================================
Func __AET_WinCtrlStatic($hWnd, $sText, $iLeft, $iTop, $iWidth, $iHeight, $iStyle = -1, $iExStyle = -1)
	Local $iForcedStyle = BitOR($WS_TABSTOP, $WS_VISIBLE, $WS_CHILD, $SS_NOTIFY)
	Local Static $iCtrlID = 0

	; Determines the last child-window identifier; it must be unique for all child windows with the same parent window.
	__AET_GetLastCtrlID($hWnd, $iCtrlID)

	If $iStyle = -1 Then
		$iStyle = $iForcedStyle
	Else
		$iStyle = BitOR($iStyle, $iForcedStyle)
	EndIf
	If $iExStyle = -1 Then $iExStyle = 0
	;$iExStyle = BitOR($iExStyle, $WS_EX_NOACTIVATE)
	Local $hStatic = _WinAPI_CreateWindowEx($iExStyle, "Static", $sText, $iStyle, $iLeft, $iTop, $iWidth, $iHeight, $hWnd, $iCtrlID)
	_SendMessage($hStatic, $WM_SETFONT, _WinAPI_GetStockObject($DEFAULT_GUI_FONT), True)
	Return $hStatic
EndFunc   ;==>__AET_WinCtrlStatic

; #INTERNAL_USE_ONLY# ===========================================================================================================
; Name ..........: __AET_GetLastCtrlID
; Description ...: Determines the last child-window identifier, it must be unique for all child windows with the same parent window.
; Syntax ........: __AET_GetLastCtrlID($hWnd, Byref $iCtrlID)
; Parameters ....: $hWnd                - A handle value.
;                  $iCtrlID             - [in/out] An integer value.
; Return values .: None
; Author ........: JScript
; Modified ......:
; Remarks .......:
; Related .......:
; Link ..........:
; Example .......: No
; ===============================================================================================================================
Func __AET_GetLastCtrlID($hWnd, ByRef $iCtrlID)
	Local $avEnumChild = _WinAPI_EnumChildWindows($hWnd, False)
	If @error Then
		$iCtrlID = 1
	Else
		$iCtrlID = _WinAPI_GetDlgCtrlID($avEnumChild[$avEnumChild[0][0]][0]) + 1
	EndIf
EndFunc   ;==>__AET_GetLastCtrlID

; #INTERNAL_USE_ONLY# ===========================================================================================================
; Name ..........: __AET_ButtonSetIcon
; Description ...:
; Syntax ........: __AET_ButtonSetIcon($hWnd, $iIndex)
; Parameters ....: $hWnd                - A handle value.
;                  $iIndex              - An integer value.
; Return values .: None
; Author ........: JScript
; Modified ......:
; Remarks .......:
; Related .......:
; Link ..........:
; Example .......: No
; ===============================================================================================================================
Func __AET_ButtonSetIcon($hWnd, $iIndex, $iWidth = 16, $iHeight = 16, $iAlign = 0, $sDll = "Shell32.dll")
	Local $hImageList

	$hImageList = _GUIImageList_Create($iWidth, $iHeight, 5, 3)
	_GUIImageList_AddIcon($hImageList, @SystemDir & "\" & $sDll, $iIndex, True)
	_GUICtrlButton_SetImageList($hWnd, $hImageList, $iAlign)
EndFunc   ;==>__AET_ButtonSetIcon

; #INTERNAL_USE_ONLY# ===========================================================================================================
; Name ..........: __AET_ShutDown
; Description ...: Function to be called when AutoIt exits.
; Syntax ........: __AET_ShutDown()
; Parameters ....:
; Return values .: None
; Author ........: JScript
; Modified ......:
; Remarks .......: Frees handle created with DllCallbackRegister.
; Related .......:
; Link ..........:
; Example .......: No
; ===============================================================================================================================
Func __AET_ShutDown()
	If $hAET_USER32 Then DllClose($hAET_USER32)
	If $hAET_WINDOW_PROC Then
		_WinAPI_UnregisterClass($sAET_CLASSNAME, $hAET_INSTANCE)
		DllCallbackFree($hAET_WINDOW_PROC)
	EndIf
	If $hAET_CBTPROC_HOOKERROR Then
		DllCallbackFree($hAET_CBTPROC_CALLBKERROR)
	EndIf
	;----> Clean up resources used by Microsoft Windows GDI+.
	If $hAET_SCR_HBITMAP Then
		_WinAPI_DeleteObject($hAET_SCR_HBITMAP)
		_GDIPlus_Shutdown()
	EndIf
	;<----
EndFunc   ;==>__AET_ShutDown

; #INTERNAL_USE_ONLY# ===========================================================================================================
; Name ..........: _IconAni
; Description ...: Simple icon animation using bitmap strip!
; Author ........: JScript
; ===============================================================================================================================
Func _IconAni()
	Local $hFileHwnd, $bData, $sFileName = @TempDir & "\Icon.bmp"

	; Original: D:\Dropbox\AutoIt v3 - Projects\AutoItErrorTrap\Include\Icon.bmp
	$bData = "uragQk02UAACADYAMKooADCgABggABgBAihHAAAEfAkA////Hgz+AP7+APz8/AD4APj4APT09ADxAPHxAe3t7QHrgOvrAurq6gIBDhDu7u4BARf19fUAAPn5+QD9/f3HIlslAwl/8PDwHn+BFz/FPaF/gQfVP5V/gT3p6R7p3j/NP/9f5wD7+/sGAMEUwRfo6OgC4ADg4ATa2toF1gDW1gfU1NQH0wjT0wjBAdfX1wYA3NzcBeLi4gNjwUTBKPf39/6hwTH2QPb2AO/v78If4Rzh4cYfwR7JH9vb2//KH8EN/UHFP9kfwQDBA+0PH+Ef/w//H+kf5S/V1dXx4g/S0tL/D/8M/z/gP/jn5+fqP+0v8T//D3deA+Fd4Q7k5OQD2dkA2QbPz88JxcUAxQ27u7sSs7MAsxesrKwbr69Arxm1tbUVYQLBAMHBD8jIyAzRgNHRCN3d3QXhFfFhYvr6+uIJ/w7vD+EuMOXl5QNhHukPsbHAsRirq"
	$bData &= "6sc9Q9hIT/hD+Eg4XH/D/cf9Q+qqkCqHK2trRphIbp4uroT8Q//H/8f6Q/EAMTEDrm5uROu+K6uGuEPYTDhD/8f/w/H/z/jD2EdsLCw4i/hAP/5L+Ef/w9rAGGWYV7hbWFqEMrKygvhLIWFhQA6XFxcaUJCQgCNTEFMpjFUUwC1MTg4qUFBQQKP4QKCgoI9pKTApCC4uLgUcQpxCPDf398E8VmxMD8IPwCH+QdxNHEMzc3NCnEOMIeHhzhxBvEGNUwATKsuS0q4MTcCN/oHoqKiIra2ALYVw8PDDtDQ4NAJ3t7e/wc/AP8HIfgPy8vLC/EehIQAhDtfX19lQ0MAQ4w1UE+rLlAAT7o/PkWxPT0EPZX1B6OjoyG3GLe3FPEH9Q/s7Oz/skD/Bz8A9QdxbvkH8S71DwBFQESWUkBPswBLOUi7QTdAsfBAQECQcQn9B/8P/wcHPwD/D/0fQD9AklQAQVGwUj9PtjP4MzOk8SD/D/MP/wf/Bj"
	$bData &= "m/D/QAMS9xVXEXaGcAaF1iRl64lFQAiuzNb7/86YcA4P9/0PL/MfYA7v8s4dn/Ks8AyPwglI/6G1oAWOcxODepbm7AblOgoKAjcTKxC/+xM7EMcWQ/CP8H8QcxPzFmAXEXcHBwUU1cZgCwJ5uW7CrKwwD8K93W/yvb0wD/KtnR/yrVzgD/Ks3G/CKfmQD6Hmhl5y08PACzZmZmXZ2dneImcTDJycnyB7E4/wcPPwD5B/EPcRdqampYADRgXrUjko3uACa6s/wr3NX/ADzl5P+mvPP/APmK7P/hedH/AJ9YlPpgOlrnADUxNK5oaGhacJ+fnyT/D/8H/wf98ADz8/MyR/EH8V3xBwA1W1qwbnqb6gDaec787oDd/wDrftv/43rT/wDcdsz/yGy7/ACdV5L6ZDxg5wA5NDiraWlpWTCcnJwmcVLxD9jYPtj2D/+Q/wf5D/UfY0cAX7iSU4nsx2wgufzietLwB9r/AO+I5P+Owuv/ADrk4vw"
	$bData &= "jop36gBxgXucwNzfyBz/xF/8P/w89V3EvsQ/MzATMCvE+Z0pjs8wAcL7274De//AAgd//3ozg/1YA5vH/Mffv/y8A7uf/Lunh/y0E5NzwINT/KtfQAP8nv7n8GmRhYPA2Pj6h8TDxI8b4xsYN8YExEH8wvw/xBwDOzs4Ji4uLNQBuUWqpwG229ABe5vj/Mvnx/wAv8en/Luzk/ygu6OEwAODyB07YAOH/jr7n/8GqAO7/4ozj/3xFAHPyOjU5qX5+/H5C+QcxEP8H/w+xFzFXAfFGN3Busym+uAD2Lebf/y3l3gD/Leff/1fU4wD/6Zbv//2J7QD/9oTk/++B3gD/6X3Z/954zwD/ym69/Gw9ZADyNzY3oYGBgT4+9QcxIP8H/w/xD+PjDOMDcRvxBzliYasAK8fA9k7h6v8A9pb5//6L7v8A+obo//WE4/8Y8YLgMhkxAOuD3wD/15Tk/6id1gD8SXSF8jI6OuCpf39/QfErMYPxmh//"
	$bData &= "F/8P9R/xD/FOaU1mALPUdcb29oXlBfQG3nIAx5vj/0cA6e3/MPPr/y6A6uL/LOLb/3E5ACe+uPwbbmvy8DM6Oqb9H/8POwCxAQMxAjEzcW9wVLBoAKbf+4nq/PmGAufwDuT/9IPi/wCbu+z/M/31/8Ax+PD/MfXwB/AgIC/w6P8wMAAv7Qrl8BngsggltrD8ACE+PM1tbW1U/zGKMQhxMLFY8YD/B/MHMRIBMYRyb3FTm12RANr0heP8oLrvAP81//v/M/z0AzAocAf07P8w8uoBsgdD6uz/4pTpAfAJfLsA4//yguH/7X8A3P/me9X/xGoAt/w4KDXSbW0AbVSsrKwbxsYAxg3Z2dkG6+sA6wL6+voA//8C/w4M+Pj4AOjoAOgCzMzMCnZ2AHlSL6Sg3zP3AO/8MPTs/zDwAOj/L+3l/y/rAOP/rLTv//6NAPL//ort//yIAOr/+Ybn//aFEOX/84MDf+V71AD/umSs/D0uOwDLc3NzT"
	$bData &= "q6uriIaCX/5+fkOe/7+AP4A9/f3AOfnBOcCAStqdnZbKwCemuEw6eH8MwDl4f/Xo/f//wCQ+P//jfP//hCL7//9AHf9iOsBAH/r/+yT7f9WQNnl/y7q4oJRLgGAUSe/ufwdPDsA1GdnZ1uqqqoAHMXFxQ3Y2NgHlj+BAYU/ysrKC3QAd3dNe4uv3f1Akff8/ozxgnX7AYA5+Ibm//WF5AD/ZN7x/zH37wD/MPHp/y/u5gGCOS3m3v8r3tcA/yrX0P8ip6EA/B84OM9sbGwQVq2trZ5/+/v7AADu7u4B1NTUAAdzgIBRyX7KSOr/kIB5jvSCd/kAh+f/7oDd/2QA3/X/Nv/9/zQA/vn/M/z1/zFA9u7/MfXtgkUzAPz0/2nY7v+3AKHg/6Sz5/+VAKrZ/EZCVd9qAGpqWLCwsBjJAMnJC97e3gTwwPDwAfz8/MofwYQA7e3tAdLS0ggAf3d+Usxzv+qI+ofowpRO7vrAHCD+/zX++sAd9v"
	$bData &= "8EMfPAg+/o/zvkcOP/25/AgcAnwQr2QITk//GC4MKA4gB60v/CabX8SgAvRt9ra2tXsQixsRjBVd/f3wSA8fHxAf39/dY/AHx7fEeSlMPlDcM5+MM5wDgv7OX/ADff3f/1mfz/gP+S+///j/bAg2HDof6K7v/CacAD8wCM6//fjuP/2oB2y/xBLD3YwWAH3T/BH8E/0NDQCWsAeHdaL8nC7C8DwbzAHD3f4P//l6D+//+V/cAd+cAdAvTCnfqH6f/njzDm/1bkw4HBny3lAN3/LODZ/yvcANX/KMzF/xlHwEbjZWVlXsHAxR8HwT/VH8FfcH5+Uy1gt7HpuLnAGsEckSD5//6O88La84Og4v/CnePAYvzARoD3/zL78/8ywaEM8+vjQOBBL+/n/wAt5N3/KtDJ/AAdSknbb29vUgfhL/UfYW/09PQA4QDh4QSNkJA0TWCqs9v9meEdYACTCvvgKvBiXtuC1v+gQvn9/zqABjjgQYA2/vv"
	$bData &= "/M/rx4g8AX93t/8Wn7P8I9ITj4j/qftr/APCB3//mfNX/ADkpN9R9fX1DMLi4uBThK2Fs9vYG9u4PYUOJh4k6tUBrruH+i+7iiu9Agd7/bdfyag4x4+CRYS2otfDgE2BB4IIP4SPhUOUy4RDofdf/AM5uv/85KjfPAIKCgj26uroTcNHR0QjhD2F98R+PAI2PNbRsrNuaRMX14A3//zfkXjEB4Csu59//fMLj2P//mwAD4SOWYABgMwNhUGEA7ZXx/6O5APD/Rdvg/y7hANr/Q+Hl/2/NAOb8JT9B1H9/wH9Bubm5E+Uf8Q8A4ODgBIeKijlgM8fC5TJgeWI57ADk/zza2///nmcgBeEO4VCR+GJBYRxX0Oj1/zPhQPngkeA/EeG0LuvkYpEq2dIA/ybEvv8cPz5g2H5+fkL9D+EfjACPjzUzvLbfN2rrYC+hYCuZIATgQP4Ukfdgn+diO2nZ8kz/OeAiYSM2/+BQ/aD2/zL68uKPM2AB"
	$bData &= "AD/3+v95yOf/AHPJ5f88zs/88B89PNDhD/U/ZV/hE0BAmpezWeTgOp0H5x1hO+GK04HS/z4VQAI9YAA74jL4/zKBYCRR4uz/95HjPxVhtPXgkO9gpeh92BD/5HrTYuE5NTgAqZ2dnSbDw8NgDtzc3AVpYGGf7ADs7AG0tLQWqchwp71iOo/1YglhCKBx1O//P+QOOOFPkPLq/y1gfPKd4CNn4THhQGFlkvpjkuC2/gNhNOAR74De/7NhAKf8Pjo+oZ+fAJ8kxMTEDt3dHt3iD2Wg5R/hI5tpl0Sz+2BYcdr1YBz/AeNe/v7/MvTt/wAt4tr/h73i/+z/oIAC4SOYYYNgDeCewMSr8P887zBS8R9w6eH/LPAnsWhxACcAwLr8MTo5qZwMnJz/D/gHs7OzFxA/oJ+7cVc1//sM/zSwRfF+OtPT/xT/pJAConMH/pH25P/38H66ovBYsAnxAgo28Eg1MWn79P8yRPjwMgAw8OmyUCPAraf8N"
	$bData &= "Tc38g/5B0P9D/EXPZiUuLEDO6Dj4v/yo/AVn3QgUJT7//gwcOXwRFc06Pa2ETexCjFi/fUA/2Xf8f/Io+vA/+qI4v/r8EexGwDwh+T/w4rT/Hg6Njr/H/QPsSixL3AAg4NWNPHr+HFU0+uzDqEwAJzwDpMI+f/ysI3VeMv/oEz0+v9AYAE8cA+CMzE36eL/16RweqcxI/F6sR+N8XYo7PAyAN94z/9sPWXyAGZmZl22trYVcTFI6enpdoDxBzEhg+B1g2L0kgAGMSXwDiD7iev/5zBMestY6v9EgAJxBznwJzDx8IZRy9c3QbVacSgwAArz8HHusCnroPr/CMWi6jIQb0Bo8DBubm5TMSb/B/YAAXFhhXeFX/SM7AD4+Yjp/4/C7IvyBnEvPLA2NPjysBzQ2P96vbBIpUABMSgQlvr//TAu1Jzq8P86+vawH7BoMRHwWQFxmC3l3v8s39gA/yra0v8cdXEA8mhoaFq3t7cH/wfwB7FfjH"
	$bData &= "uMYEAw8/b6OXEO8T379QT/LzGd1M//6K01sJ+ncwf+8HexkHfO/u4yIPECsVrxYfEg8ig0KQAx9u//LOLb/wAbbWnyaWlpWQP/B/cHa4yMYDT1FO/6cVQu8FOtue2I//+mdC+Z/f9xEdGxHFnn9HQR/zNI8G8Aisrx//mO8P8Y/YnsclLxSul+2QXwb9awcNn/eENvB/8f8AcxMPLy8gG/gL+/ED+vrb/xM0A35OD/3rCwJKkTAAZxN5r9sC/o/9pAdcr/ZtrtsiA8pP79MoeXu7AqmHRhKzYAc4r+sKP7sJHrfwLac3AxN7OioqIAIsjIyAzi4uIwA/X19fIH8Yi7u8C7Ep+MvMtyRXElDTAl/DB4MQy1js//qEn9/nIHPXAHL/BleHu+3LMJ8TnxBnCC8gCY+f+Fy/H/Nhro8WffsEdwkNvT/4BU0+D/vJPWMjgQpKSkIP8H8QG9gL29EbV3tcZxVwL5sA7Wh9j/S/ko/P9F4AVBsR3"
	$bData &= "8+AT/LrCVWsDO//8KqwABo3NI6Ivk/+hS7PlyaDYwS3IA8Ho4M/rzMpGxcHFQJ77AuPwuNTSu/w/3F4CscqvCUPT9MmYNsR058COxNirWz/8UjrnwDq7zGP2R9AD/5HzU/0j2+we2aLFwMQA8/P7/cgDY9f+Nw+//jADC7f+IwOn/WwDZ6P8t2tP8MBg5OKv/D/cHPqysVMI18BUz8E8usDN2DMXeMwdxIKD+//sEjO7yJ1vm8/9DAzRIsSdn0ur/95Xd8DGQsGfwE/Ex/XAfMVoBcTLnfNf/1nPHcP86Mjn+HzFQsW+KAJKSODf08/gzgXB8L+jh/3LIsAeKsEAGrbMW/ZL0sldggrrd/0h1IDAK7u6hcLjxInEjmvNSMiHyABXzKP3waemwWGA5WQLncZjBwcEP29sM2wV1sPEHiZKSOTB21vH4MiV0Jf6UIPn/8YPgsgt8whjh/0qxIDAPMO3mWP+AunBIsTmfs4m44LLx/0HxNJDw"
	$bData &= "eTHZGfLY3dYyADEDLWVpH/YHMWDxB7Fn8QeSjpIgOPST9PhxV/yKouxyO3zM6jIHRjAAAj5wBzHu5/89xzDJ//2vcA2wB/uN8PD/hcczSPVotQDxSxGxqjT89vK4KtnRAP8cYl/pgICABkD/D/QHjO34b+Eo+f9CNC89MVD58wT/LTB8NMLB/+4GtDBmsC/9lff/zwyG1PJZM2H+/zj7Ar0A+f+B0vT/3pkA7P/2heX/8oIA4f/sf9v/5XsA1f/kfNX/k78A6v8gYV/lg4MAgzzBwcEP29sA2wXx8fEB/PwA/ADs7OwBipIAkjg69PT4Of8A/v82/fj/MOwA5P8x0s7/0rYA8f//sf///6eA///+lvj/5gCWIHPK5f9FACQ6/gD7/0rf5v/2mqD9//+X/gcDmAADAJX7//6O9P/7AInr//CB3//hAHnR/2A5WueCCIKCPQl/+vr6AADi4uIDYZ2deQI5AFM2/vr/MfAA6P8u19H/z7kVA"
	$bData &= "HuzABSsAAOg/v8A9Yjn/8F9xf8ATff7/0H+/v9YWNzqABcAG6EAA5wA///7m/7/4aYA+/+3uPT/nr8A7v+pue//6acA+v/+mfz/+IcA6P+gWJT6XFwAXGm7u7sS19eg1wbu7u6GP2CAP0BG8fP/+6uAXasFgCemgAGe/v/9jgDy/+p+2f/Cd4DB/1rs9f9IAAuAOfv4/3jG4oKJYP+a/P+qgFOBWzUQ/vn/NYCdNf33AP80/PX/MfTsAP8u6eL/LN/YAP8r3db/I6GcAZI/4eHhBJ1+nRh5/52AJ4Bh/pD1AP/xguD/zn3MwP9m4PD/TAALgrcBgDsr2tP/s7HlAP//qf//+o7xQP9Q7/n/PoANPXWAATzAADvEAsEEwQM6AcFU/fr/Lurj/wAglZD6Xl5eZwHRP5+Bn3b+kfdA/6a57f9HwFZHBcANRMER/v3/M/IA7P8q1tD/ebcCz8KC/qL+/+aGKN//QcAHP8CLTu4A9v/Op/P//4"
	$bData &= "4A8//+jPD//YsI7v/8wH31hOP/gOt+2v/ketPCMwila6jCP7q6uhOA1tbWB+3t7cp/C8ErwS06wBwy8+z/ACzc1f9Iw8n/DN22wBbBoKP+//ZAien/pKDXwkM7QP37/6y48sJ+/y6fwWvEAcGDosNS/5Ug/P/9jfHCIZhTQo3OH/n5+QDBQlAIubmpw1D+/zT5APP/LuXd/yzMAMf/obng//20A8ARwKD+nv3/94sg7P+nquHCRn7WAPX//6T///2dAP7/pMD3/0LqAOz/L+/n/y7rAOP/Lebf/yziAtvCfUzP2P+0qgDp/+N80/xCQgBCjbW1tRXU1EDUB+vr6wLFH08BwB8z+PL/tcLyaP/+scAbsAAYwHj/AJ/+//uQ8v/nAH3X/7V/wf9bEOby/0PAZ1Xl7wHCn96m+f9B+v0twH3+akDhATbgczL3Bu/iEWERKs7H/EEIQUGP7Q/T09MIwLaDtq7/o2EsYAAB4GX5ier/5HvUAP/"
	$bData &= "HdsL/fMLgDP9NYA5iUPz5/0gA3OH/9qv9/+RQofX/P+ACP+ACSgD0/f+VxPP/rwCx7f/Ineb/zwCU4f/BmuD/gEDL7v9D+fzgEPEA/ynIwvxEREQCiu0P1dXVB69+gK+p/5T7//NgRmiTvefiDUvkXmJQ8QDr/yvQyv+YtwDe//6p/v/5lArz4iBEYAvUqfr/eP+W/OAW4Y9gkWA+/0aT4H7gUfiG5+Kg5gB81v/ietL/PYA9PZWzs7MXYR4I6urq5i9Ztbmp2kBgDUNgAOEAOmBmYaAAKtfQ/zPAvv9Azrbt//+vY1/0AIvq/17q+P884Pv5/+2kYA3hTeCQAPSi/f/Qr/j/ANCx9//PtPb/COWq+eOTmv7/+gHgYdRzxfxAQEACkO0fzMzMCka9FL3E4WlCYTj+/P8CM+Ff3tf/KM3GAP9ZvMj/17PwDP/+YZPgD/yX+P8Afdr5/6LO/P9y52ACZ+Rgj2CO4bY1APz2/zP58f8xEPPr"
	$bData &= "/y/gFyzh2gFihjfb2v/QmugA/zMzM6SxsbFWGOkf4Q9F4A83YB4vAOfg/5rE6P/+LrZgDWGvYaGh4KCV+AT/9WBv5Ibd/5IAwu3/P/v7//bAqf3/ZOj9YnZhJi/hF2UY4SjhQjhhefnyEP8t599giM//MYA3N6mvr68Z6Q8AxsbGDcONzM8N4qmqYABgav6Z+/8g+Ijp/+lgr9VzAMb/m53P/2LbKOz/RGA+PWAKl88A9/+5wPv/R/oA/v+Xyvr/9pIp4GaM7+CO7GA+5v8A84Ph/+2A3P8A53zX/9qA1P+Ai7zm/y7o4O4PyPj4+OIPzIjgD2BICPuK7GJFkbvk/3ZPYA1hr0ZhGWAB4b4zAPHs/3PT6//2AKX8/2fn+/+2/r/gTeG24Y3hF+HG4BfiARHgPv6P9WJQ7oDdAWDx1P9DOEGxrACsrBvS0tII6QTp6eIfzs7OCZzAiLW9R/3+4svhDSPhKGFQMvLq4scpxwDC/4a21//Vr"
	$bData &= "gPgHOAxuLr4/3XkAv3iUc60/P9r3ADy/zLv6P8v6wjk/y6wFi3j2/8AL97Y/3rI5P8A4Kz4//6R9v8A6X3Y/z02PKwQrq6uGvkXw8PD4A5G2trasTZ1XzEWGjUwOzDwBHIozsf/AETIzf9ozOH/AIzL8f+vwfr/4KrI/f9DoDdxR7kzBbFHN7BHNPv0/y8E7uYwKNn/LODYAP9N5e3/RklTDrXxD/kv8QdC2dnaBDj/cD717f8t4ADZ/3XI3P/et3fwVXFf8X+lMzbycXAatwS5+PAH/P+C2PwA/6m/9//MpO4A/8+b5//Gm+MA/6K06P980vDQ/073/DIoObAbsXgAK9vU/y5LSrhwq6urHPEP9QfxiGRwx9fb/PE19QYxHJwA/f/9kvX/9oga6HAo2PIb8S/DqvAA/5nK+f+T1P1k/9+wSP+YMCCwHv9pcGD/mbAAkvAWMGf5UTCH7X/cclTn8ANbcuCwWFBO9gf1F/EH2IiR2N2xa/"
	$bData &= "6V+nAvAugyA8GCyf+LteDc/17m83IZcTWxNgBR7/r/f9n6/wKLsA/Xsf3/rsQA+f+mxfT/mMcA7/+5u/L/869XMEmwSvJjnPGE9vAw4gOwMLBoOUm7qqqqA/oH8RfajNnansi29/IuMQBJdCDxfTkwX0HxVzHu5/8xMCZNEOnv/54wN4vZ/Jj/aeezHrFDN/3wjxD79f8yMBwv7eUQ/y3l3rIjKtnSEP+St+ZwMOj/Tzw8TPIP9R/xf/Evop/YzctJ8C+xB0p0XzGeAXEoOPz4/zT28AT/NXBENv32/04A7/X/yaXt/4UAyu7/7pj0/84Qpe//qvBZfNTysP9Q+PyyErEoOvADDjMwA/JvMCUu6uL/cDZSUavxT/mH8U9IqNXV0LEOOrFX9DAoAfByKdDJ/z7GyAD/ab7T/3+42AD/gLrc/1/R4gD/Oe3q/4PK7aT/grBt1qswXpewrgSS97Ki+Ifn/+8Egd2yNteF1/9zRNbxMig0+/Y"
	$bData &= "yeDWcTEv/B/FX8Aeoz7AE2rXAArQwAPF/qHREMRwNMC/+MLUxcsSt9P8AZNnt/5m+7P8AZeLz/5XN8//Axr32//W1sCdxH96lcChxMvCcMSjr8G8xrADVn+7/OVJUsw/xPzF3cb/xB8fHxwww2pba2PJL8ET+lAr4cgzoMAzgedD/ANl1yv/QdMX/gMmG0f/tgt4yUgCbve3/qrXt/2BQ8Pj/NjFncIYwBbA+LXCTMt7Z/3FwzuL/zXC4MgXwC/uEiu5yVVFATrHxBwH5D8nJyQvbktuC1jFckMrw/1YwHG5OYAPxf7VQPbAZsZlBAfB+jcny/9Kh7QT/nDAIvrHz/3tA2ff/Tfn9slNBHzIcsEswCTE/MSgr3NQE/zAwCdec7f9MGD9JpvF/9Qf7+/sCALHIwIjArKrDfvlyBzEAcSjxBHVssQc6ATAAc9Xy/++M6BD/2pvssFnr/73guPX//pNwFrBq8WaAzY7a/23g9LILRbEDOPAk"
	$bData &= "MfXucMDhPP8rsDDxl/G34FYF8Azw8PIHsQBUv7+uBzEvMTfxfzT38P8wBfAqL3CkLuTd/y4E49zwAOP/M/buAP9N6/H/8Y7rAP+LyPD/M/DpgP+Uy+//9rKwH4qocSL68rf0hOIyH4DiftX/fM7u8IE++bKA8Qfxr/kH8Q9SwADArD749v+U0ODv/9y89zcoMUSxUAGwtdyj9v9wyuYBMkB01PD/8IznEP9Y6/ewH/D/LwFwzj7a2v+9v/AdswOtMADwUDGY9YTkBTAo2jJIRkFGlrkMubn6B7EYxY/FuKsyAzEApnADm3C7kPDYAIzu//mK6//3ETBR+4vt8HTz/8QCrLNuxqvx/+iRsOn/buGwt7A+O3BIA7UI8T4w2tX/u7sX8AjxhDBQ6DC0RkJFApP9D9jY2Aa+iyC+sf+b/TKH2ocA2v+Qwen/Y+cC9bBX9P9b5/T/AGfZ7/+OuOT/IN+M4P/7MAKcwADw/0Ln6P/3mAL2sh/mh"
	$bData &= "t7/lb5Y6v9NMEzxRz5y9PlA/zDx6f8ssHgtIfAbZdTp//G/vLwEvBL17/39/QDnAOfnArqRuon9QJf6/76w7/At7lz/X3DdcVAxgVtwCHgAze3/uZ3f//IjcB3xB7uu8DBR7/9AOeTh/+WzQHiej7sA/P/8jO//7oAA3f/jfdX/mroA5/9K/P7/Pv8A/v81/Pf/LusA4/8oxb/8XFwAXGnFxcUN4eEA4QT09PQA/f0A/QDn5+cCZbuAu4lI////SgAGAkcABkL+/v88/oD7/zr9+f84AAYAN/33/zb89P8ANvv0/8Sp7v8A+Yfo/7Gx7f8ANvr1/y/p4f8AX9Tg//S5/P8A/6v+//+Z/P8A/o3x//SE4v8A6H3Y/+R71P+Aadfw/yrMxQZ/CODg4AZ/6enpAiBltbWBPgBzNfcA8v8x5N7/YNIA3/+IxeP/h78A4P9hxtj/Us4A2v8v39n/MO4A5v8y8ur/pr0A9P/5iOj/vqYY6P9BAD"
	$bData &= "cDh+L/LADc1f+Lyub//Cq3gEOpAGSXgIuK7QD/84Pi/9BxwQD8WVlZbcTExAYOiT+Bf7qQuon/qqyAF7SAAa+AAaiAAVqhgAGdgWeAAZWAbZIA+P/jnPT/O+wC6oJDrLz0//yLAO3/64Ld/3/TAvGCnTz+/f80+QDy/y/t5f8s4QDa/zDb1v+7tgDx//6R9//Ga0C4/F9fX2WRv7oGk4A/gDf+lvv/+0GAKfGD4P/lgJvfAHjP/+N70//qBH7Zggn8iev//QCK7P9d5PP/MCDs5f+kw4AtmPoFgIXpwlqorOP/UwT5/MQi/v8z+vMBwn4t5N3/LNLLAc5//v7+APPz8wABr5+vQ/6n/gD8/pf6//eH5wD/7IPe/9mJ2wD/2n/T/+Z81rD/8YLfwlvBHvrAAQibwPLAgvb/LucA4P92zuT//7GdAByawC7AB8Gg5nzAYRDF6/9DgAU4/vwE/y/ASyOPiuyHAIeHOM/PzwnoQOjoAvj4+MY"
	$bData &= "figCvr0NI/v78TVfAC8EAwaJEwABAwAA9BcAAOsCxOP34/6VQt+v//sBH+cAozQia5f/BjDP17v8ALODY/3rL4v8M/7YAC8h974He/wLpwEWht+z/JpjAk+yFhYU6wR/BXEHJH4awsEhBxEw3QcA1M/Ps/zDAky5E49zCtzLw6cAZ7QHCADLx6f/co/gBwn7sgNz/b9/1B8LLwX3BQyvd1v98IMvj//+uABSg/gD//o70//WE4wD/oFqU7IODgw48yR9ACMIfpKSxQXTTuwBKs0AEwTDBU6qFwACkwACe///9wKBAuK7x/zznwL/0AcAm7OT/lMXv/wXBa/TAFtyB1f9cLPD54iZlUC7gFizfANj/M9vX/+6YAPX/mliQ6oaGrIY58S/iP63gD6YACHKcYBaS9+JQYT7hAP4SjuBMjvJgL+7/3QCc7f81/fb/MADt5v9I29///Qat4AXgEPaG5f/nAWBFvpvd/079/hT/QkAJN2CIMPPr"
	$bData &= "AP8u6uL/JZSQBuztD+Ef+fn5AL4Avr4R6KLo4/+OoiAC4YfgD/2N7+JaBPuKYD6P8///kSj1//5gnPhgP2DlBeGS+uIgLdvV//ggs/3//6fgEJP4AWKT7H/b/9aL2zD/S/n9YBDgT+/nIP82YF6wAAAY2gDa2gXv7+8B/AT8/OIP+vr6AMIAwsIPfsvm3VBQ+/7/T4ACTGhQP4FgAFzm9//HoeBfBeAf/2Cb94bm/8oImOL/YUY4/Pj/Ci/gGy1gj82/9P8FYjif4z72heX/8ACB3//Ro+//NABmZbitra0a2cDZ2Qbu7u7mD+IfgMDAEU3l5d9hrypDYF09YDg54a769KHgC/f/Of5gAf7gUgD27v9n1+z//5SW/WKs7eBPobPgMF3gBjvgHGFDYX0tYFDTKLn2/+E5/uCW8oIA4f9gRl21r68crxntH+EPYaJK291A2KXT+//9YaeyASADrf//96j9/4C7s/H/VdTiYJ5g5/80+PBiY"
	$bData &= "GGtqBy88eIc4WDhk6Oy5YPiJmF+N/76/zHgtAViEeVgiZ/y/2VK7GGx9Q/iP6fgP+Fe4a9yp2Nn/5rgOuGv4B3/AJH2//eQ7/9gBOPz4Av5/zHw6IHiW+Oz+f//o+EtCvLgHOBgUNf/lr3Y6f9GYSJgKTFgJmGgGDZhX/IPYbDm5uZgAr+dv33iD+HApaljOP+b4A6YYL+XYAHEk/liLrG17+ORYRyBYRDg2f/QuvXjBgab4BBgBPKD4f/rAH7a/5a86/81AeAEKbiy9HBwcABRzc3NCuXl5XAD9vb2Yg9hAGFw6wDr6wK0lbRq2gCt/f905vz/cADj+P981/T/egDX9f+rs+v/7jyG4mNPYCDhHOFPuaYO5+JP4j5gbC3i2/80W9TwOLOwCnFDk/oB8mL2hOT/1nrMAPZmaWhdysrKAAvk5OQD9fX1h3IH9Q8xeHG3t3TxG93xV0swAPETMTw+dBQxF8BJ7fH/65twJfAQRTFB8fAWr6"
	$bData &= "rl8idAMTACNvz2sm+xCHvNBOb/8Tz+kPf/zwBywPZpaWlZzDzMzPIP+QdxAPEHbr4Ivnk+cC9F9PX/AEHp6P9A5ub/4Dvo5f8wsBsxV7GHBjdwRzEwL+rj/85cr/cwIvAFsEHysHHhQILY/13w+vKLOjFwBDL38HJHsT+FmgDE9mpqaljLy1zLC/0H+h/xf7X4V6OL81cxKP3wH3HW73IQzjewaDEJcQ7Pt/AQ8SoUlvqwceoyOdCR3Y1yCDzxJ3AIKby2/wcD9Ac1MLu6uxTmqfzm3fIHMUTxY3IwsXUwAACV+//pmvP/Q6z19/AYcXX6ch8u8DUYpsPv8wIxK5D2/4j5hudwR97/uvCRADX69fw7a2qpgLKyshfc3Ny6LwH5B8C/wBLooegA2/6d/P/9kvQQ//uM7jBY8P/9R3Ff8VcwWf+U+rIA+vEwVpjB8PInMQ5xQXFyMTGP7rT7cwswk/6LAvDxgvxpTGWzroCurhrb29sFsU8"
	$bData &= "I+/v7/ge3v78X4FLo6N9OAAExADGMBkU0gDEGP/r7/8g6qjBHlPAF8ThwCfWFYOT/0JXishazhvsE/zEwUC7n3/8yAOLc/+2h+//6gIvu/GVLYauxXwP/D/cHvL+/ElDgqODWRPRXO7AEOTAWC3FYMQA6cDY4/vj/gDP37/9H5emwoY+0IXARMWkxZ4vK7zN4wTAEM/v1/zAwIrCEAPxFbXKzrKysdhv/D/wfoPAf8U98qPcAnv7/f87w/zR58Jw5/3AI8SexH3AO0Da1cBlxApqzR7Gu7IFw3P9e6zBycAzwWvzwN25ssbFn/w83SHEJALWitU/4svj2X/IHMWAxTbFEsA71sFBk9OP2MBH88iexEbJgsDicmsjwJ/BisiqS+XJHEvgwSp7AcKqcmNoAi4uLNdXV1QcHcT51f/0H8PDwAa+Aoa9A+a/59vZfT3APMrgxALBV/5awWI+i9HKoauH59ic1sRZzMKbxEO6yMAJxjHEiiwDv"
	$bData &= "/7Bnpt2EhMCEO9TU1Ad5h/0HAXERh7GxSEr4+A72sSc2ULCdYuj7//zMq3A+8IWyJ/FocDBxqNjVl+X2J7ERMrEwcIkAN+fk//Ka+v+IqGWg8g/W1tb/D8H8D4uzs0ZL8AfxBB+xB/EvcQV1DjE/NPryWP+Wx/BmsSeccQ76bP/78BYxZ5ZwQHVHM4WwUjGwKiyfm+FxlzDT09MI/w/7H6SnALZOrcf59tu7AP7/+7D+/8y6APn/j870/1HsezB3coj8sG8xlfAnsR/rnfA3tjARMbexb4/1cB8i5/KGkMPwsm8umH6U8g/xF/8PNwAxKXHZuWCXuXT4qoAG8VerAbAvqf7/ocj4/3hK9PmwwDHtM8GxCDOBsBYw7+j/w7wwMKmwAv+fcW/7cKLwMgAAiJW/6nJ1dU/wzs7OCX9XOwBxYHHRwLqdunL+s8AFtYg3MTDxJLEFmLAfsNzNqtb0cknxcTwwADbwOPGOMXEf2rP6cytwMMRvw"
	$bData &= "LjqdHN0UHF/fXcB/w/8AN7e3gSgAKW+cqrF+PaLANj+/4Pa/P/R/Kn0cK3wDbGQMUcxAHEIEJD1//1wH7ax7gEwHzq3AP//Qf///zn/AP3/M/ry/zDzAOv/VuTw/69rAKzlfHt8R8/PAM8J5eXlA/X1wPUA/v7+AACoDgwA/Pz8AN7e3gQAcL29fE/+/vyqTgAoTAAGRwAGQgAGAj0Evlnr9//upFD9//+iACCdAAaVAPv//ovu//iGgOb/l8Xx/0MCJwD+/zL89P8vywDF7Gt0dFjMzADMCuTk5AP09AL0Gn/i4uIDda8Ir2VBAH9P9vz/ADr8+P87/fr/Wj4ATz8AJAEDPQALNwD++v8z9+//RQDp6//3qv7//wqnABibgAOQ9//8AInr//qH6P9gAOX5/zPNyOlvwHJyUs7Ozp5/gQEA+/v7ANfX1wYAfq61bFzt+fYAeuP+/1rw/P9oPf78gK/+goOBAT4FhIU0gHE68e7/+QqogD"
	$bData &= "2ohEGT/P//AI/2/75yueN8gHV8VsnJyQuFfRj9/f2WPYk/tJu0gGz5tPn2/7SAChqvgAGpgAGBt5r+/wDdpvz/T/X+/xZEAAeB+TuAATb++QT/MsBDMvHq/9kArPr//5b9/8AAc7nffXZ8VMoEysrqH93d3QWwoJawXfmmwB+lQAVqpMA0o8AApMACwQOhBcAAmcADkvj//oyA8P9v4vr/RsRmgjjASDT99/8zwEUAYrHE43p1eVEYzc3Nxn7hH9TU1MIHwqD4+PZKxJ/BlIHBXF3r/f/uosEjCwADwQCewZ/8//6NCPL//cB9lMj0/wo8gAQ1wGsyxcDlAGt4d1rHx8cMYcEf8/PzAd0fwaDZANnZBnS7u3FO0Pn59kgABUXIAMXBAjjAFzT89f+nxhb4w2bBRpvAAJL5/wD/jfH/75bz/wA7rq/ddX18TgPpf8Ug4+PjA42vgK9AT+jo20nEQC/BWMEgwULD4v7AOfn/GGnj9sNC4TK"
	$bData &= "X/v8A9I/y+qlwpr0AiIaIO9HR0Qgw5+fnAn8PazDh4QDhBLaktk7mphDm3f+q4xv+oP/E/+zgP1Xy/mIQ4U8KQOZP++IhjM/2/wD1kvT4m2uZswCPjY8109PTCHDo6OgC4W7/D+sftYCltUTgpeDW4l86rWAArORg4RzgYP+VAP3/5p73/0P+C+Ny4RA3YT/28/o/AKCeu4eKijnQeNDQCeEf/w/rH+GgiACxsUhO5+jfSgHAaWrp//+B3P8f4J7kYOGN5U9gbf+Q9gD/55ry/0f3/QD/OPT0+ECbmOCziYyMN+UP/y/vLwCNrq5BUOjo3Q9hYGEAYVHnsP7/Qfk4+v/34RFhEWAz/5kBYACU/f/0ju/6AJl6qL2GiYk6D+Ev/w9vAGEF8PDwAQC9wMASdLS0auBN5ubdR2CyYVBpEEBr5fv/56ngH58A///0lvT4vHoAvMuDdYNitLQAtBbf398E7e1g7QH39/d/D3BA7gDu7gG7ursU"
	$bData &= "vACXv32PxOjjY/js/vxhjOFOZU9hguE+AeGORu3y+KF9rgC/g3mDVrm5uT4TYShhCOEPeb75H7++AL8SvZy9euWksOXf/q+AfuRP/uBPYtrgHmDq/eKeYY45APX1+D6trcJrAIyMYLOzsxfgDODg/x/8H7+6vxcAt5O3dOaa5t/U/qfgD6tkYKbkT+AuAP+Y/v/4mPz/AGbT6fRBt7fCAGyGhl64uLgUH/EP/wc/AD8A8w/v7+8AAbe/vxdxt7dgdE/m5t/xH/FmPIEgJ2jn/v/bsLQw1XFpnPAflfAfe/8f/wcLPwA/AP8yG/n5+QAA6+vrAsLCwg8Aiq+vQ2W7u4kAU7+/rkjV1dAAccLa2rZ+tr0AuYS5qZ1/nXkAko2SObu7uxIh8Wvs7OwBMS/6+h76vx8/AD8A+Afm5uYgAr6+vhHxB2S6CLqJVPQHRNnZ2gBGvb3EULm5qQBhnZ15ipKSOPC/v78QdRfxB7E8vwUfPwA/APcH8"
	$bData &= "TtxBbKfsgBKuZC5jMWLxQC4mq7a2ELZ2QDbRb6+wlKzswCjY56edoeXl+A9vb29EXEX9Q/xBw//Dz8APwD3B+np6QIAwcHBD7CgsEIAtZK1gcaRxrUA2pXa2NiR2N0AzIrMz7aCtq4Al4GdeY2VlTXwwMDAEHUf/w8/AD8AF/8H9QfxF2PwH4GmwACszozOy9mR2QDaxIfEybiEuPirnX7/H/UfvwU/AD8AD3sIcQTxg7EY2traBeHxrMTExA5xpfGacasBMQfx8fEB9vb2f38nPwA/AD8AtjhxEP0Hw4DDww7Ly8sL+Qf48vLy8gd/Hz8APwA/AIH/B+cC1tbWBzGV/zE5cQj/B/8PPwA/AD8A+wcf8RyxIPEG8QcxIcbGxv4NMW4xN/8P/wc/AD8A/wfh+w/b29sFcR/xF7Gd//EQ9Qf/H/8EPwA/AD8Acyj/sQixDfEFMQk1APEAMWN/Vv8/AD8APwA/AP8H/wf/Bz8A/z8APwA/AP"
	$bData &= "8H/wf/Bz8APwCPPwA/ALsg+Qf4+Pj2B/9xAf8HPwA/AD8APwD/D/sPELAA+gD8/PwA/f0g/QD///8mMA=="

	$hFileHwnd = FileOpen($sFileName, 10)
	If @error Then Return SetError(1, 0, 0)
	FileWrite($hFileHwnd, __IconAni(__IconAniB64($bData)))
	FileClose($hFileHwnd)
	If FileExists($sFileName) Then Return $sFileName

	Return SetError(1, 0, 0)
EndFunc   ;==>_IconAni

Func __IconAniB64($sInput)
	Local $struct = DllStructCreate("int")
	Local $a_Call = DllCall("Crypt32.dll", "int", "CryptStringToBinary", _
			"str", $sInput, _
			"int", 0, _
			"int", 1, _
			"ptr", 0, _
			"ptr", DllStructGetPtr($struct, 1), _
			"ptr", 0, _
			"ptr", 0)
	If @error Or Not $a_Call[0] Then
		Return SetError(1, 0, "") ; error calculating the length of the buffer needed
	EndIf
	Local $a = DllStructCreate("byte[" & DllStructGetData($struct, 1) & "]")
	$a_Call = DllCall("Crypt32.dll", "int", "CryptStringToBinary", _
			"str", $sInput, _
			"int", 0, _
			"int", 1, _
			"ptr", DllStructGetPtr($a), _
			"ptr", DllStructGetPtr($struct, 1), _
			"ptr", 0, _
			"ptr", 0)
	If @error Or Not $a_Call[0] Then
		Return SetError(2, 0, ""); error decoding
	EndIf
	Return DllStructGetData($a, 1)
EndFunc   ;==>__IconAniB64

Func __IconAni($bBinary)
	$bBinary = Binary($bBinary)
	Local $tInput = DllStructCreate("byte[" & BinaryLen($bBinary) & "]")
	DllStructSetData($tInput, 1, $bBinary)
	Local $tBuffer = DllStructCreate("byte[" & 16 * DllStructGetSize($tInput) & "]") ; initially oversizing buffer
	Local $a_Call = DllCall("ntdll.dll", "int", "RtlDecompressBuffer", _
			"ushort", 2, _
			"ptr", DllStructGetPtr($tBuffer), _
			"dword", DllStructGetSize($tBuffer), _
			"ptr", DllStructGetPtr($tInput), _
			"dword", DllStructGetSize($tInput), _
			"dword*", 0)

	If @error Or $a_Call[0] Then
		Return SetError(1, 0, "") ; error decompressing
	EndIf

	Local $tOutput = DllStructCreate("byte[" & $a_Call[6] & "]", DllStructGetPtr($tBuffer))

	Return SetError(0, 0, DllStructGetData($tOutput, 1))
EndFunc   ;==>__IconAni