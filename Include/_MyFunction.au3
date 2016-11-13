;~ Function List
; #MISC Function# ===================================================================================================
;~ _CREATION_LOG([$iLOGPath = @ScriptDir & "\Log.txt"]) Create the Log file with starting info
;~ _LOG([$iMessage = ""],[$iLOGType = 0],[$iVerboseLVL = 0],[$iLOGPath = @ScriptDir & "\Log.txt"]) Write log message in file and in console
;~ _Download($iURL, $iPath, $iTimeOut = 20) Download URL to a file with @Error and TimeOut
;~ _DownloadWRetry($iURL, $iPath, $iRetry = 3) Download URL to a file with @Error and TimeOut With Retry
; #XML Function# ===================================================================================================
;~ _XML_Read($iXpath, [$iXMLType=0], [$iXMLPath=""], [$oXMLDoc=""]) Read Data in XML File or XML Object
;~ _XML_Write($iXpath, [$iXMLType=0], [$iXMLPath=""], [$oXMLDoc=""]) Write Data in XML File or XML Object
; #GDI Function# ===================================================================================================
;~ _GDIPlus_GraphicsDrawImageRectRect($hGraphics, $hImage, $iSrcX, $iSrcY, [$iSrcWidth, _
;                                   [$iSrcHeight, [$iDstX, [$iDstY, [$iDstWidth, [$iDstHeight[, [$iUnit = 2]]]]]]])  Draw an Image object with transparency
;~ _GDIPlus_RelativePos($iValue, $iValueMax) Calculate relative position
;~ _GDIPlus_ResizeMax($iPath, $iMAX_Width, $iMAX_Height) Resize a Picture to the Max Size in Width and/or Height
;~ _GDIPlus_Rotation($iPath, $iRotation = 0) Rotate a picture
;~ _GDIPlus_Imaging($iPath, $A_PathImage, $A_MIX_IMAGE_Format, $B_Images, $TYPE = '') Prepare a picture
; #XML DOM Error/Event Handling# ===================================================================================
;~ Internal Function Handling XML Error

#Region MISC Function

; #FUNCTION# ===================================================================================================
; Name...........: _LOG_Ceation
; Description ...: Create the Log file with starting info
; Syntax.........: _LOG_Ceation()
; Parameters ....: $iLOGPath	- Path to log File
; Return values .:
; Author ........: Screech
; Modified.......:
; Remarks .......:
; Related .......:
; Link ..........;
; Example .......; No
Func _LOG_Ceation($iLOGPath = "")
	Local $iVersion
	If $iLOGPath = "" Then $iLOGPath = @ScriptDir & "\Log.txt"
	If @Compiled Then
		$iVersion = FileGetVersion(@ScriptFullPath)
	Else
		$iVersion = 'In Progress'
	EndIf
	FileDelete($iLOGPath)
	If Not _FileCreate($iLOGPath) Then MsgBox(4096, "Error", " Erreur creation du Fichier LOG      error:" & @error)
	_LOG(@ScriptFullPath & " (" & $iVersion & ")", 0, $iLOGPath)
	_LOG(@OSVersion & "(" & @OSArch & ") - " & @OSLang, 0, $iLOGPath)
EndFunc   ;==>_LOG_Ceation

; #FUNCTION# ===================================================================================================
; Name...........: _LOG
; Description ...: Write log message in file and in console
; Syntax.........: _LOG([$iMessage = ""],[$iLOGType = 0],[$iVerboseLVL = 0],[$iLOGPath = @ScriptDir & "\Log.txt"])
; Parameters ....: $iLOGPath		- Path to log File
;                  $iMessage	- Message
;                  $iLOGType	- Log Type (0 = Standard, 1 = Warning, 2 = Critical)
; Return values .:
; Author ........: Screech
; Modified.......:
; Remarks .......:
; Related .......:
; Link ..........;
; Example .......; No
Func _LOG($iMessage = "", $iLOGType = 0, $iLOGPath = @ScriptDir & "\Log.txt")
	Local $tCur, $dtCur, $iTimestamp
;~ 	Local $iVerboseLVL = IniRead($iINIPath, "GENERAL", "$vVerbose", 0)
	$tCur = _Date_Time_GetLocalTime()
	$dtCur = _Date_Time_SystemTimeToArray($tCur)
	$iTimestamp = "[" & StringRight("0" & $dtCur[3], 2) & ":" & StringRight("0" & $dtCur[4], 2) & ":" & StringRight("0" & $dtCur[5], 2) & "] - "
	Switch $iLOGType
		Case 0
			FileWrite($iLOGPath, $iTimestamp & $iMessage & @CRLF)
			ConsoleWrite($iMessage & @CRLF)
		Case 1
			If $iLOGType <= $iVerboseLVL Then FileWrite($iLOGPath, $iTimestamp & "> " & $iMessage & @CRLF)
			ConsoleWrite("+" & $iMessage & @CRLF)
		Case 2
			If $iLOGType <= $iVerboseLVL Then FileWrite($iLOGPath, $iTimestamp & "/!\ " & $iMessage & @CRLF)
			ConsoleWrite("!" & $iMessage & @CRLF)
		Case 3
			If $iLOGType <= $iVerboseLVL Then
				FileWrite($iLOGPath, $iTimestamp & "--------------------------------------------------------------------------------" & @CRLF)
				FileWrite($iLOGPath, $iTimestamp & $iMessage & @CRLF)
				FileWrite($iLOGPath, $iTimestamp & "--------------------------------------------------------------------------------" & @CRLF)
			EndIf
			ConsoleWrite(">----" & $iMessage & @CRLF)
	EndSwitch
EndFunc   ;==>_LOG

; #FUNCTION# ===================================================================================================
; Name...........: _Download
; Description ...: Download URL to a file with @Error and TimeOut
; Syntax.........: _Download($iURL, $iPath)
; Parameters ....: $iURL		- URL to download
;                  $iPath		- Path to download
;                  $iTimeOut	- Time to wait before time out in second
; Return values .: Success      - Return the path of the download
;                  Failure      - -1 : Error
;~ 								- -2 : Time Out
; Author ........: Screech
; Modified.......:
; Remarks .......:
; Related .......:
; Link ..........;
; Example .......; No
Func _Download($iURL, $iPath, $iTimeOut = "")
	Local $inetgettime = 0, $aData, $hDownload
	If $iTimeOut = "" Then $iTimeOut = 20
	$hDownload = InetGet($iURL, $iPath, $INET_FORCERELOAD, $INET_DOWNLOADBACKGROUND)
	Do
		Sleep(250)
		$inetgettime = $inetgettime + 0.25
		If $inetgettime > $iTimeOut Then
			InetClose($hDownload)
			_LOG("Timed out (" & $inetgettime & "s) for downloading file : " & $iPath, 1, $iLOGPath)
			Return -2
		EndIf
	Until InetGetInfo($hDownload, $INET_DOWNLOADCOMPLETE) ; Check if the download is complete.

	$aData = InetGetInfo($hDownload)
	If @error Then
		_LOG("File Downloaded ERROR InetGetInfo : " & $iPath, 2, $iLOGPath)
		InetClose($hDownload)
		FileDelete($iPath)
		Return -1
	EndIf

	InetClose($hDownload)

	If $aData[$INET_DOWNLOADSUCCESS] Then
		_LOG("File Downloaded : " & $iPath, 1, $iLOGPath)
		Return $iPath
	Else
		_LOG("Error Downloading File : " & $iPath, 2, $iLOGPath)
		_LOG("Error Downloading URL : " & $iURL, 2, $iLOGPath)
		_LOG("Bytes read: " & $aData[$INET_DOWNLOADREAD], 2, $iLOGPath)
		_LOG("Size: " & $aData[$INET_DOWNLOADSIZE], 2, $iLOGPath)
		_LOG("Complete: " & $aData[$INET_DOWNLOADCOMPLETE], 2, $iLOGPath)
		_LOG("successful: " & $aData[$INET_DOWNLOADSUCCESS], 2, $iLOGPath)
		_LOG("@error: " & $aData[$INET_DOWNLOADERROR], 2, $iLOGPath)
		_LOG("@extended: " & $aData[$INET_DOWNLOADEXTENDED], 2, $iLOGPath)
		Return -1
	EndIf
EndFunc   ;==>_Download

; #FUNCTION# ===================================================================================================
; Name...........: _DownloadWRetry
; Description ...: Download URL to a file with @Error and TimeOut With Retry
; Syntax.........: _DownloadWRetry($iURL, $iPath, $iRetry = 3)
; Parameters ....: $iURL		- URL to download
;                  $iPath		- Path to download
;~ 				   $iRetry		- Number of retry
; Return values .: Success      - Return the path of the download
;                  Failure      - -1 : Error
;~ 								- -2 : Time Out
; Author ........: Screech
; Modified.......:
; Remarks .......:
; Related .......:
; Link ..........;
; Example .......; No
Func _DownloadWRetry($iURL, $iPath, $iRetry = "", $iTimeOut = "")
	Local $iCount = 0, $iResult = -1, $vTimer = TimerInit()
	If $iRetry = "" Then $iRetry = 3
	If $iTimeOut = "" Then $iTimeOut = 20
	While $iResult < 0 And $iCount < $iRetry
		$iCount = $iCount + 1
		$iResult = _Download($iURL, $iPath, $iTimeOut)
	WEnd
	_LOG("-In " & $iCount & " try and " & Round((TimerDiff($vTimer) / 1000), 2) & "s", 1, $iLOGPath)
	Return $iResult
EndFunc   ;==>_DownloadWRetry

; #FUNCTION# ===================================================================================================
; Name...........: _MultiLang_LoadLangDef
; Description ...: Return a file size and convert to a readable form
; Syntax.........: _MultiLang_LoadLangDef($iLangPath, $vUserLang)
; Parameters ....: $iLangPath	- Path to the language
;                  $vUserLang	- User language code
; Return values .: Success      - Return the language files array
;                  Failure      - -1
; Author ........: Autoit Help
; Modified.......:
; Remarks .......: Brett Francis (BrettF)
; Related .......:
; Link ..........;
; Example .......; No
Func _MultiLang_LoadLangDef($iLangPath, $vUserLang)
	;Create an array of available language files
	; ** n=0 is the default language file
	; [n][0] = Display Name in Local Language (Used for Select Function)
	; [n][1] = Language File (Full path.  In this case we used a $iLangPath
	; [n][2] = [Space delimited] Character codes as used by @OS_LANG (used to select correct lang file)
	Local $aLangFiles[5][3]

	$aLangFiles[0][0] = "English (US)" ;
	$aLangFiles[0][1] = $iLangPath & "\UXS-ENGLISH.XML"
	$aLangFiles[0][2] = "0409 " & _ ;English_United_States
			"0809 " & _ ;English_United_Kingdom
			"0c09 " & _ ;English_Australia
			"1009 " & _ ;English_Canadian
			"1409 " & _ ;English_New_Zealand
			"1809 " & _ ;English_Irish
			"1c09 " & _ ;English_South_Africa
			"2009 " & _ ;English_Jamaica
			"2409 " & _ ;English_Caribbean
			"2809 " & _ ;English_Belize
			"2c09 " & _ ;English_Trinidad
			"3009 " & _ ;English_Zimbabwe
			"3409" ;English_Philippines

	$aLangFiles[1][0] = "Français" ; French
	$aLangFiles[1][1] = $iLangPath & "\UXS-FRENCH.XML"
	$aLangFiles[1][2] = "040c " & _ ;French_Standard
			"080c " & _ ;French_Belgian
			"0c0c " & _ ;French_Canadian
			"100c " & _ ;French_Swiss
			"140c " & _ ;French_Luxembourg
			"180c" ;French_Monaco

	$aLangFiles[2][0] = "Portugues" ; Portuguese
	$aLangFiles[2][1] = $iLangPath & "\UXS-PORTUGUESE.XML"
	$aLangFiles[2][2] = "0816 " & _ ;Portuguese - Portugal
			"0416 " ;Portuguese - Brazil

	$aLangFiles[3][0] = "Deutsch" ; German
	$aLangFiles[3][1] = $iLangPath & "\UXS-GERMAN.XML"
	$aLangFiles[3][2] = "0407 " & _ ;German - Germany
			"0807 " & _ ;German - Switzerland
			"0C07 " & _ ;German - Austria
			"1007 " & _ ;German - Luxembourg
			"1407 " ;German - Liechtenstein

	$aLangFiles[4][0] = "Espanol" ; Spanish
	$aLangFiles[4][1] = $iLangPath & "\UXS-SPANISH.XML"
	$aLangFiles[4][2] = "040A " & _ ;Spanish - Spain
			"080A " & _ ;Spanish - Mexico
			"0C0A " & _ ;Spanish - Spain
			"100A " & _ ;Spanish - Guatemala
			"140A " & _ ;Spanish - Costa Rica
			"180A " & _ ;Spanish - Panama
			"1C0A " & _ ;Spanish - Dominican Republic
			"200A " & _ ;Spanish - Venezuela
			"240A " & _ ;Spanish - Colombia
			"280A " & _ ;Spanish - Peru
			"2C0A " & _ ;Spanish - Argentina
			"300A " & _ ;Spanish - Ecuador
			"340A " & _ ;Spanish - Chile
			"380A " & _ ;Spanish - Uruguay
			"3C0A " & _ ;Spanish - Paraguay
			"400A " & _ ;Spanish - Bolivia
			"440A " & _ ;Spanish - El Salvador
			"480A " & _ ;Spanish - Honduras
			"4C0A " & _ ;Spanish - Nicaragua
			"500A " & _ ;Spanish - Puerto Rico
			"540A " ;Spanish - United State

	;Set the available language files, names, and codes.
	_MultiLang_SetFileInfo($aLangFiles)
	If @error Then
		MsgBox(48, "Error", "Could not set file info.  Error Code " & @error)
		_LOG("Could not set file info.  Error Code " & @error, 2, $iLOGPath)
		Exit
	EndIf

	;Check if the loaded settings file exists.  If not ask user to select language.
	If $vUserLang = -1 Then
		;Create Selection GUI
		_LOG("Loading language :" & StringLower(@OSLang), 1, $iLOGPath)
		_MultiLang_LoadLangFile(StringLower(@OSLang))
		$vUserLang = _SelectGUI($aLangFiles, StringLower(@OSLang), "langue", 1)
		If @error Then
			MsgBox(48, "Error", "Could not create selection GUI.  Error Code " & @error)
			_LOG("Could not create selection GUI.  Error Code " & @error, 2, $iLOGPath)
			Exit
		EndIf
		IniWrite($iINIPath, "LAST_USE", "$vUserLang", $vUserLang)
	EndIf

	_LOG("Language Selected : " & $vUserLang, 0, $iLOGPath)

	;If you supplied an invalid $vUserLang, we will load the default language file
	If _MultiLang_LoadLangFile($vUserLang) = 2 Then MsgBox(64, "Information", "Just letting you know that we loaded the default language file")
	If @error Then
		MsgBox(48, "Error", "Could not load lang file.  Error Code " & @error)
		_LOG("Could not load lang file.  Error Code " & @error, 2, $iLOGPath)
		Exit
	EndIf
	Return $aLangFiles
EndFunc   ;==>_MultiLang_LoadLangDef

; #FUNCTION# ===================================================================================================
; Name...........: _SelectGUI
; Description ...: GUI to select from an array
; Syntax.........: _SelectGUI($aSelectionItem , [$default = -1] , [$vText = "standard"], [$vLanguageSelector = 0])
; Parameters ....: $aSelectionItem	- Array with info (see Remarks)
;                  $vLanguageSelector- If used as language selector
;                  $default			- Default value if nothing selected
; Return values .: Success      - Return the selected item
;                  Failure      - -1
; Author ........: Brett Francis (BrettF)
; Modified.......:
; Remarks .......: $aSelectionItem is a 2D Array
;~ 					[Name viewed][Note Used][Returned value]
; Related .......:
; Link ..........;
; Example .......; No
Func _SelectGUI($aSelectionItem, $default = -1, $vText = "standard", $vLanguageSelector = 0)
;~ 	_CREATION_LOGMESS(2, "Selection de la langue")
;~ 	If $demarrage = 0 Then GUISetState(@SW_DISABLE, $F_UniversalScraper)
	If $aSelectionItem = -1 Or IsArray($aSelectionItem) = 0 Then
		_LOG("Selection Array Invalid", 2, $iLOGPath)
		Return -1
	EndIf
	If $vLanguageSelector = 1 Then
		$_gh_aLangFileArray = $aSelectionItem
		If $default = -1 Then $default = @OSLang
	EndIf


	Local $_Selector_gui_GUI = GUICreate(_MultiLang_GetText("win_sel_" & $vText & "_Title"), 230, 100)
	Local $_Selector_gui_Combo = GUICtrlCreateCombo("(" & _MultiLang_GetText("win_sel_" & $vText & "_Title") & ")", 8, 48, 209, 25, BitOR($GUI_SS_DEFAULT_COMBO, $CBS_SIMPLE)) ;BitOR($CBS_DROPDOWNLIST, $CBS_AUTOHSCROLL))
	Local $_Selector_gui_Button = GUICtrlCreateButton(_MultiLang_GetText("win_sel_" & $vText & "_button"), 144, 72, 75, 25)
	Local $_Selector_gui_Label = GUICtrlCreateLabel(_MultiLang_GetText("win_sel_" & $vText & "_text"), 8, 8, 212, 33)

	;Create List of available Items
	For $i = 0 To UBound($aSelectionItem) - 1
		GUICtrlSetData($_Selector_gui_Combo, $aSelectionItem[$i][0], "(" & _MultiLang_GetText("win_sel_" & $vText & "_Title") & ")")
	Next

	GUISetState(@SW_SHOW)
	While 1
		$nMsg = GUIGetMsg()
		Switch $nMsg
			Case -3, $_Selector_gui_Button
				ExitLoop
		EndSwitch
	WEnd
	Local $_selected = GUICtrlRead($_Selector_gui_Combo)
	GUIDelete($_Selector_gui_GUI)
	For $i = 0 To UBound($aSelectionItem) - 1
		If StringInStr($aSelectionItem[$i][0], $_selected) Then
			If $vLanguageSelector = 1 Then
				_LOG("Value selected : " & StringLeft($aSelectionItem[$i][2], 4), 1, $iLOGPath)
				Return StringLeft($aSelectionItem[$i][2], 4)
			Else
				_LOG("Value selected : " & $aSelectionItem[$i][2], 1, $iLOGPath)
				Return $aSelectionItem[$i][2]
			EndIf
		EndIf
	Next
	_LOG("No Value selected (Default = " & $default & ")", 1, $iLOGPath)
	Return $default
EndFunc   ;==>_SelectGUI

; #FUNCTION# ===================================================================================================
; Name...........: _ByteSuffix($iBytes)
; Description ...: Return a file size and convert to a readable form
; Syntax.........: _ByteSuffix($iBytes)
; Parameters ....: $iBytes		- Size from a FileGetSize() function
; Return values .: Success      - Return a string with Size and suffixe
; Author ........: Autoit Help
; Modified.......:
; Remarks .......:
; Related .......:
; Link ..........;
; Example .......; yes in FileGetSize autoit Help
Func _ByteSuffix($iBytes)
	Local $iIndex = 0, $aArray = [' bytes', ' KB', ' MB', ' GB', ' TB', ' PB', ' EB', ' ZB', ' YB']
	While $iBytes > 1023
		$iIndex += 1
		$iBytes /= 1024
	WEnd
	Return Round($iBytes) & $aArray[$iIndex]
EndFunc   ;==>_ByteSuffix

Func _IsChecked($idControlID)
	Return BitAND(GUICtrlRead($idControlID), $GUI_CHECKED) = $GUI_CHECKED
EndFunc   ;==>_IsChecked

Func _FormatElapsedTime($Input_Seconds)
	If $Input_Seconds < 1 Then Return
	Global $ElapsedMessage = ''
	Global $Input = $Input_Seconds
	Switch $Input_Seconds
		Case 0 To 59
			GetSeconds()
		Case 60 To 3599
			GetMinutes()
			GetSeconds()
		Case 3600 To 86399
			GetHours()
			GetMinutes()
			GetSeconds()
		Case Else
			GetDays()
			GetHours()
			GetMinutes()
			GetSeconds()
	EndSwitch
	Return $ElapsedMessage
EndFunc   ;==>_FormatElapsedTime

Func GetDays()
	$Days = Int($Input / 86400)
	$Input -= ($Days * 86400)
	$ElapsedMessage &= $Days & ' d, '
	Return $ElapsedMessage
EndFunc   ;==>GetDays

Func GetHours()
	$Hours = Int($Input / 3600)
	$Input -= ($Hours * 3600)
	$ElapsedMessage &= $Hours & ' h, '
	Return $ElapsedMessage
EndFunc   ;==>GetHours

Func GetMinutes()
	$Minutes = Int($Input / 60)
	$Input -= ($Minutes * 60)
	$ElapsedMessage &= $Minutes & ' min, '
	Return $ElapsedMessage
EndFunc   ;==>GetMinutes

Func GetSeconds()
	$ElapsedMessage &= Int($Input) & ' sec.'
	Return $ElapsedMessage
EndFunc   ;==>GetSeconds

Func _MakeTEMPFile($iPath, $iPath_Temp)
	;Working on temporary picture
	FileDelete($iPath_Temp)
	If Not FileCopy($iPath, $iPath_Temp, 9) Then
		_LOG("Error copying " & $iPath & " to " & $iPath_Temp, 2, $iLOGPath)
		Return -1
	EndIf
	If Not FileDelete($iPath) Then
		_LOG("Error deleting " & $iPath, 2, $iLOGPath)
		Return -1
	EndIf
	Return $iPath_Temp
EndFunc   ;==>_MakeTEMPFile

Func _Coalesce($vValue1, $vValue2, $vTestValue = "")
	If $vValue1 = $vTestValue Then Return $vValue2
	Return $vValue1
EndFunc   ;==>_Coalesce

#EndRegion MISC Function

#Region GDI Function
; #FUNCTION# ===================================================================================================
; Name...........: _OptiPNG
; Description ...: Optimize PNG
; Syntax.........: _OptiPNG($iPath)
; Parameters ....: $iPath		- Path to the picture
; Return values .: Success      - Return the Path of the Picture
;                  Failure      - -1
; Author ........: wakillon
; Modified.......:
; Remarks .......:
; Related .......:
; Link ..........;
; Example .......; https://www.autoitscript.com/forum/topic/122168-tinypicsharer-v-1034-new-version-08-june-2013/
Func _OptiPNG($iPath, $iParamater = "-clobber")
	Local $sRun, $iPid, $_StderrRead
	Local $sDrive, $sDir, $sFileName, $iExtension, $iPath_Temp
	_PathSplit($iPath, $sDrive, $sDir, $sFileName, $iExtension)
	$iPath_Temp = $sDrive & $sDir & $sFileName & "-OPTI_Temp.PNG"
	If StringLower($iExtension) <> ".png" Then
		_LOG("Not a PNG file : " & $iPath, 2, $iLOGPath)
		Return -1
	EndIf
	$vPathSize = _ByteSuffix(FileGetSize($iPath))
	If _MakeTEMPFile($iPath, $iPath_Temp) = -1 Then Return -1
	$sRun = $iScriptPath & '\Ressources\optipng.exe -o1 "' & $iPath_Temp & '" ' & $iParamater & ' -out "' & $iPath & '"'
	_LOG("OptiPNG command: " & $sRun, 1, $iLOGPath)
	$iPid = Run($sRun, '', @SW_HIDE, $STDERR_CHILD + $STDOUT_CHILD)
	While ProcessExists($iPid)
		$_StderrRead = StderrRead($iPid)
		If Not @error And $_StderrRead <> '' Then
			If StringInStr($_StderrRead, 'error') Then
				_LOG("Error while optimizing " & $iPath, 2, $iLOGPath)
				Return -1
			EndIf
		EndIf
	WEnd
	$vPathSizeOptimized = _ByteSuffix(FileGetSize($iPath))
	_LOG("PNG Optimization (OptiPNG): " & $iPath & "(" & $vPathSize & " -> " & $vPathSizeOptimized & ")", 0, $iLOGPath)
	If Not FileDelete($iPath_Temp) Then
		_LOG("Error deleting " & $iPath_Temp, 2, $iLOGPath)
		Return -1
	EndIf
	Return $iPath
EndFunc   ;==>_OptiPNG

; #FUNCTION# ===================================================================================================
; Name...........: _PNGQuant
; Description ...: Optimize PNG
; Syntax.........: _PNGQuant($iPath,$iParamater = "")
; Parameters ....: $iPath		- Path to the picture
; Return values .: Success      - Return the Path of the Picture
;                  Failure      - -1
; Author ........: wakillon
; Modified.......:
; Remarks .......:
; Related .......:
; Link ..........;
; Example .......; https://www.autoitscript.com/forum/topic/122168-tinypicsharer-v-1034-new-version-08-june-2013/
Func _Compression($iPath, $isoft = 'pngquant.exe', $iParamater = '--force --verbose --ordered --speed=1 --quality=50-90 --ext .png')
	Local $sRun, $iPid, $_StderrRead
	Local $sDrive, $sDir, $sFileName, $iExtension, $iPath_Temp
	_PathSplit($iPath, $sDrive, $sDir, $sFileName, $iExtension)
	If StringLower($iExtension) <> ".png" Then
		_LOG("Not a PNG file : " & $iPath, 2, $iLOGPath)
		Return -1
	EndIf
	$vPathSize = _ByteSuffix(FileGetSize($iPath))
	$sRun = $iScriptPath & '\Ressources\pngquant.exe ' & $iParamater & ' ' & $iPath
	_LOG("PNGQuant command: " & $sRun, 1, $iLOGPath)
	$iPid = Run($sRun, '', @SW_HIDE, $STDERR_CHILD + $STDOUT_CHILD)
	While ProcessExists($iPid)
		$_StderrRead = StderrRead($iPid)
		If Not @error And $_StderrRead <> '' Then
			If StringInStr($_StderrRead, 'error') And Not StringInStr($_StderrRead, 'No errors') Then
				_LOG("Error while optimizing " & $iPath, 2, $iLOGPath)
				Return -1
			EndIf
		EndIf
	WEnd
	$vPathSizeOptimized = _ByteSuffix(FileGetSize($iPath))
	_LOG("PNG Optimization (PNGQuant): " & $iPath & "(" & $vPathSize & " -> " & $vPathSizeOptimized & ")", 0, $iLOGPath)
	Return $iPath
EndFunc   ;==>_Compression

; #FUNCTION# ===================================================================================================
; Name...........: _GDIPlus_RelativePos
; Description ...: Calculate relative position
; Syntax.........: _GDIPlus_RelativePos($iValue, $iValueMax)
; Parameters ....: $iValue		- Value
;                  $iValueMax	- Value Max
; Return values .: Return the relative Value
; Author ........: Screech
; Modified.......:
; Remarks .......:
; Related .......:
; Link ..........;
; Example .......; No
Func _GDIPlus_RelativePos($iValue, $iValueMax)
	If StringLeft($iValue, 1) = '%' Then Return Int($iValueMax * StringTrimLeft($iValue, 1))
	Return $iValue
EndFunc   ;==>_GDIPlus_RelativePos

; #FUNCTION# ===================================================================================================
; Name...........: _GDIPlus_ResizeMax
; Description ...: Resize a Picture to the Max Size in Width and/or Height
; Syntax.........: _GDIPlus_ResizeMax($iPath, $iMAX_Width, $iMAX_Height)
; Parameters ....: $iPath		- Path to the picture
;                  $iMAX_Width	- Max width
;                  $iMAX_Height	- Max height
; Return values .: Success      - Return the Path of the Picture
;                  Failure      - -1
; Author ........: Screech
; Modified.......:
; Remarks .......:
; Related .......:
; Link ..........;
; Example .......; No
Func _GDIPlus_ResizeMax($iPath, $iMAX_Width, $iMAX_Height)
	Local $hImage, $iWidth, $iHeight, $iWidth_New, $iHeight_New, $iRatio, $hImageResized
	Local $sDrive, $sDir, $sFileName, $iExtension, $iPath_Temp, $iResized
	_PathSplit($iPath, $sDrive, $sDir, $sFileName, $iExtension)
	$iPath_Temp = $sDrive & $sDir & $sFileName & "-RESIZE_Temp." & $iExtension
	If _MakeTEMPFile($iPath, $iPath_Temp) = -1 Then Return -1
	_GDIPlus_Startup()
	$hImage = _GDIPlus_ImageLoadFromFile($iPath_Temp)
	$iWidth = _GDIPlus_ImageGetWidth($hImage)
	If $iWidth = 4294967295 Then $iWidth = 0 ;4294967295 en cas d'erreur.
	$iHeight = _GDIPlus_ImageGetHeight($hImage)
	If $iMAX_Width <= 0 Then $iMAX_Width = $iWidth
	If $iMAX_Height <= 0 Then $iMAX_Height = $iHeight
	$iWidth_New = $iWidth
	$iHeight_New = $iHeight
	$iRatio = $iHeight / $iWidth

	If $iWidth_New > $iMAX_Width Then
		$iWidth_New = $iMAX_Width
		$iHeight_New = $iWidth_New * $iRatio
	EndIf
	If $iHeight_New > $iMAX_Height Then
		$iHeight_New = $iMAX_Height
		$iWidth_New = $iHeight_New / $iRatio
	EndIf

;~ 	If $iWidth > $iMAX_Width Then
;~ 		$iRatio = $iWidth / $iMAX_Width
;~ 		$iWidth_New = $iMAX_Width
;~ 		$iHeight_New = $iHeight / $iRatio
;~ 		If $iHeight_New > $iMAX_Height Then
;~ 			$iRatio = $iHeight_New / $iMAX_Height
;~ 			$iHeight_New = $iMAX_Height
;~ 			$iWidth_New = $iWidth_New / $iRatio
;~ 		EndIf
;~ 	EndIf
;~ 	If $iHeight > $iMAX_Height Then
;~ 		$iRatio = $iHeight / $iMAX_Height
;~ 		$iHeight_New = $iMAX_Height
;~ 		$iWidth_New = $iWidth / $iRatio
;~ 		If $iWidth_New > $iMAX_Width Then
;~ 			$iRatio = $iWidth_New / $iMAX_Width
;~ 			$iHeight_New = $iHeight_New / $iRatio
;~ 			$iWidth_New = $iMAX_Width
;~ 		EndIf
;~ 	EndIf
	$iWidth_New = Int($iWidth_New)
	$iHeight_New = Int($iHeight_New)
	If $iWidth <> $iWidth_New Or $iHeight <> $iHeight_New Then
		$iResized = 1
		_LOG("Resize Max : " & $iPath, 0, $iLOGPath) ; Debug
		_LOG("Origine = " & $iWidth & "x" & $iHeight, 1, $iLOGPath) ; Debug
		_LOG("Finale = " & $iWidth_New & "x" & $iHeight_New, 1, $iLOGPath) ; Debug
	Else
		$iResized = 0
		_LOG("No Resizing : " & $iPath, 0, $iLOGPath) ; Debug
	EndIf
	$hImageResized = _GDIPlus_ImageResize($hImage, $iWidth_New, $iHeight_New)
	_GDIPlus_ImageSaveToFile($hImageResized, $iPath)
	_GDIPlus_ImageDispose($hImageResized)
	_GDIPlus_ImageDispose($hImage)
	_GDIPlus_Shutdown()
	If Not FileDelete($iPath_Temp) Then
		_LOG("Error deleting " & $iPath_Temp, 2, $iLOGPath)
		Return -1
	EndIf
	Return $iResized
EndFunc   ;==>_GDIPlus_ResizeMax

; #FUNCTION# ===================================================================================================
; Name...........: _GDIPlus_Rotation
; Description ...: Rotate a picture
; Syntax.........: _GDIPlus_Rotation($iPath, $iRotation = 0)
; Parameters ....: $iPath		- Path to the picture
;                  $iRotation	- Rotation Value
; Return values .: Success      - Return the Path of the Picture
;                  Failure      - -1
; Author ........: Screech
; Modified.......:
; Remarks .......: 	0 - No rotation and no flipping (A 180-degree rotation, a horizontal flip and then a vertical flip)
;~ 					1 - A 90-degree rotation without flipping (A 270-degree rotation, a horizontal flip and then a vertical flip)
;~ 					2 - A 180-degree rotation without flipping (No rotation, a horizontal flip followed by a vertical flip)
;~ 					3 - A 270-degree rotation without flipping (A 90-degree rotation, a horizontal flip and then a vertical flip)
;~ 					4 - No rotation and a horizontal flip (A 180-degree rotation followed by a vertical flip)
;~ 					5 - A 90-degree rotation followed by a horizontal flip (A 270-degree rotation followed by a vertical flip)
;~ 					6 - A 180-degree rotation followed by a horizontal flip (No rotation and a vertical flip)
;~ 					7 - A 270-degree rotation followed by a horizontal flip (A 90-degree rotation followed by a vertical flip)
; Related .......:
; Link ..........;
; Example .......; No
Func _GDIPlus_Rotation($iPath, $iRotation = 0)
	Local $hImage, $iWidth, $iHeight, $iWidth_New, $iHeight_New
	#forceref $hImage, $iWidth, $iHeight, $iWidth_New, $iHeight_New
	Local $sDrive, $sDir, $sFileName, $iExtension, $iPath_Temp
	_PathSplit($iPath, $sDrive, $sDir, $sFileName, $iExtension)
	$iPath_Temp = $sDrive & $sDir & $sFileName & "-ROTATE_Temp." & $iExtension
	If _MakeTEMPFile($iPath, $iPath_Temp) = -1 Then Return -1
	If $iRotation = '' Or $iRotation > 7 Then $iRotation = 0
	_GDIPlus_Startup()
	$hImage = _GDIPlus_ImageLoadFromFile($iPath_Temp)
	$iWidth = _GDIPlus_ImageGetWidth($hImage)
	If $iWidth = 4294967295 Then $iWidth = 0 ;4294967295 en cas d'erreur.
	$iHeight = _GDIPlus_ImageGetHeight($hImage)
	_GDIPlus_ImageRotateFlip($hImage, $iRotation)
	$iWidth_New = _GDIPlus_ImageGetWidth($hImage)
	If $iWidth = 4294967295 Then $iWidth = 0 ;4294967295 en cas d'erreur.
	$iHeight_New = _GDIPlus_ImageGetHeight($hImage)
	_LOG("ROTATION (" & $iRotation & ") : " & $iPath, 0, $iLOGPath) ; Debug
	_GDIPlus_ImageSaveToFile($hImage, $iPath)
	_GDIPlus_ImageDispose($hImage)
	_GDIPlus_Shutdown()
	If Not FileDelete($iPath_Temp) Then
		_LOG("Error deleting " & $iPath_Temp, 2, $iLOGPath)
		Return -1
	EndIf
	Return $iPath
EndFunc   ;==>_GDIPlus_Rotation

; #FUNCTION# ===================================================================================================
; Name...........: _GDIPlus_Transparency
; Description ...: Apply transparency on a picture
; Syntax.........: _GDIPlus_Transparency($iPath, $iTransLvl)
; Parameters ....: $iPath		- Path to the picture
;                  $iTransLvl	- Transparency level
; Return values .: Success      - Return the Path of the Picture
;                  Failure      - -1
; Author ........: Screech
; Modified.......:
;; Related .......:
; Link ..........;
; Example .......; No
Func _GDIPlus_Transparency($iPath, $iTransLvl)
;~ 	MsgBox(0,"DEBUG","_GDIPlus_Transparency");Debug
	Local $hImage, $ImageWidth, $ImageHeight, $hGui, $hGraphicGUI, $hBMPBuff, $hGraphic
	Local $MergedImageBackgroundColor = 0x00000000
	Local $sDrive, $sDir, $sFileName, $iExtension, $iPath_Temp
	_PathSplit($iPath, $sDrive, $sDir, $sFileName, $iExtension)
	$iPath_Temp = $sDrive & $sDir & $sFileName & "-TRANS_Temp.PNG"
	If _MakeTEMPFile($iPath, $iPath_Temp) = -1 Then Return -1
	$iPath = $sDrive & $sDir & $sFileName & ".png"
	_GDIPlus_Startup()
	$hImage = _GDIPlus_ImageLoadFromFile($iPath_Temp)
	$ImageWidth = _GDIPlus_ImageGetWidth($hImage)
	If $ImageWidth = 4294967295 Then $ImageWidth = 0 ;4294967295 en cas d'erreur.
	$ImageHeight = _GDIPlus_ImageGetHeight($hImage)
	$hGui = GUICreate("", $ImageWidth, $ImageHeight)
	$hGraphicGUI = _GDIPlus_GraphicsCreateFromHWND($hGui) ;Draw to this graphics, $hGraphicGUI, to display on GUI
	$hBMPBuff = _GDIPlus_BitmapCreateFromGraphics($ImageWidth, $ImageHeight, $hGraphicGUI) ; $hBMPBuff is a bitmap in memory
	$hGraphic = _GDIPlus_ImageGetGraphicsContext($hBMPBuff) ; Draw to this graphics, $hGraphic, being the graphics of $hBMPBuff
	_GDIPlus_GraphicsClear($hGraphic, $MergedImageBackgroundColor)
	_GDIPlus_GraphicsDrawImageRectRectTrans($hGraphic, $hImage, 0, 0, "", "", "", "", "", "", 2, $iTransLvl)
	_LOG("Transparency (" & $iTransLvl & ") : " & $iPath, 0, $iLOGPath) ; Debug
	_GDIPlus_ImageSaveToFile($hBMPBuff, $iPath)
	_GDIPlus_GraphicsDispose($hGraphic)
	_GDIPlus_BitmapDispose($hBMPBuff)
	_WinAPI_DeleteObject($hBMPBuff)
	_GDIPlus_GraphicsDispose($hGraphicGUI)
	GUIDelete($hGui)
	_GDIPlus_ImageDispose($hImage)
	_GDIPlus_Shutdown()
	If Not FileDelete($iPath_Temp) Then
		_LOG("Error deleting " & $iPath_Temp, 2, $iLOGPath)
		Return -1
	EndIf
	Return $iPath
EndFunc   ;==>_GDIPlus_Transparency

; #FUNCTION# ===================================================================================================
; Name...........: _GDIPlus_TransparencyZone
; Description ...: Apply transparency on a picture
; Syntax.........: _GDIPlus_TransparencyZone($iPath, $vTarget_Width, $vTarget_Height, $iTransLvl = 1, $iX = 0, $iY = 0, $iWidth = "", $iHeight = "")
; Parameters ....: $iPath			- Path to the picture
;                  $vTarget_Width	- Target Width
;                  $vTarget_Height	- Target Height
;                  $iTransLvl		- Value range from 0 (Zero for invisible) to 1.0 (fully opaque)
;                  $iX				- X position of the transparency zone
;                  $iY				- Y position of the transparency zone
;                  $iWidth			- Width of the transparency zone
;                  $iHeight			- Height of the transparency zone
; Return values .: Success      - Return the Path of the Picture
;                  Failure      - -1
; Author ........: Screech
; Modified.......:
; Remarks .......:
; Related .......:
; Link ..........;
; Example .......; No
Func _GDIPlus_TransparencyZone($iPath, $vTarget_Width, $vTarget_Height, $iTransLvl = 1, $iX = 0, $iY = 0, $iWidth = "", $iHeight = "")
	#forceref $iX, $iY, $iWidth, $iHeight
	Local $hImage, $ImageWidth, $ImageHeight, $hGui, $hGraphicGUI, $hBMPBuff, $hGraphic
	Local $MergedImageBackgroundColor = 0x00000000
	Local $sDrive, $sDir, $sFileName, $iExtension, $iPath_Temp
	_PathSplit($iPath, $sDrive, $sDir, $sFileName, $iExtension)
	$iPath_Temp = $sDrive & $sDir & $sFileName & "-TRANSZONE_Temp.PNG"
	$iPath_CutHole_Temp = $sDrive & $sDir & $sFileName & "-CutHole_Temp.PNG"
	$iPath_Crop_Temp = $sDrive & $sDir & $sFileName & "-CutCrop_Temp.PNG"
	If _MakeTEMPFile($iPath, $iPath_Temp) = -1 Then Return -1
	$iPath = $sDrive & $sDir & $sFileName & ".png"
	_GDIPlus_CalcPos($iX, $iY, $iWidth, $iHeight, $vTarget_Width, $vTarget_Height)
	_GDIPlus_Startup()
	$hImage = _GDIPlus_ImageLoadFromFile($iPath_Temp)
	$hNew_CutHole = _GDIPlus_ImageCutRectHole($hImage, $iX, $iY, $iWidth, $iHeight, $vTarget_Width, $vTarget_Height)
	If @error Then
		_LOG("Error _GDIPlus_ImageCutRectHole " & $iPath_Temp, 2, $iLOGPath)
		Return -1
	EndIf
	$hNew_Crop = _GDIPlus_ImageCrop($hImage, $iX, $iY, $iWidth, $iHeight, $vTarget_Width, $vTarget_Height)
	If @error Then
		_LOG("Error _GDIPlus_ImageCrop " & $iPath_Temp, 2, $iLOGPath)
		Return -1
	EndIf
	_GDIPlus_ImageSaveToFile($hNew_CutHole, $iPath_CutHole_Temp)
	_GDIPlus_ImageSaveToFile($hNew_Crop, $iPath_Crop_Temp)
	_GDIPlus_ImageDispose($hImage)
	_GDIPlus_BitmapDispose($hNew_CutHole)
	_GDIPlus_BitmapDispose($hNew_Crop)
	_GDIPlus_Shutdown()
	_GDIPlus_Transparency($iPath_Crop_Temp, $iTransLvl)
	_GDIPlus_Merge($iPath_CutHole_Temp, $iPath_Crop_Temp)
	FileCopy($iPath_CutHole_Temp, $iPath)
	FileDelete($iPath_CutHole_Temp)
	If Not FileDelete($iPath_Temp) Then
		_LOG("Error deleting " & $iPath_Temp, 2, $iLOGPath)
		Return -1
	EndIf
	Return $iPath
EndFunc   ;==>_GDIPlus_TransparencyZone

; #FUNCTION# ===================================================================================================
; Name...........: _GDIPlus_ImageCutRectHole
; Description ...: Cut a rectangle hole on a picture
; Syntax.........: _GDIPlus_ImageCutRectHole($hImage, $iX, $iY, $iWidthCut, $iHeightCut, $vTarget_Width, $vTarget_Height)
; Parameters ....: $hImage			- Handle to the picture
;                  $iX				- X position of the cut
;                  $iY				- Y position of the cut
;                  $iWidthCut		- Width of the cut
;                  $iHeightCut		- Height of the cut
;                  $vTarget_Width	- Target Width
;                  $vTarget_Height	- Target Height
; Return values .: Success      - Return Handle
;                  Failure      - -1
; Author ........: UEZ
; Modified.......:
; Remarks .......:
; Related .......:
; Link ..........; https://www.autoitscript.com/forum/topic/146755-solvedlayer-mask-in-gdi/
; Example .......;
Func _GDIPlus_ImageCutRectHole($hImage, $iX, $iY, $iWidthCut, $iHeightCut, $vTarget_Width, $vTarget_Height)
	Local $hTexture = _GDIPlus_TextureCreate($hImage, 4)
	$hImage = _GDIPlus_BitmapCreateFromScan0($vTarget_Width, $vTarget_Height)
	Local $hGfxCtxt = _GDIPlus_ImageGetGraphicsContext($hImage)
	_GDIPlus_GraphicsSetSmoothingMode($hGfxCtxt, 2)
	_GDIPlus_GraphicsSetPixelOffsetMode($hGfxCtxt, 2)
	_GDIPlus_GraphicsFillRect($hGfxCtxt, 0, 0, $iX, $vTarget_Height, $hTexture)
	_GDIPlus_GraphicsFillRect($hGfxCtxt, $iX + $iWidthCut, 0, $vTarget_Width - ($iX + $iWidthCut), $vTarget_Height, $hTexture)
	_GDIPlus_GraphicsFillRect($hGfxCtxt, $iX, 0, $iWidthCut, $iY, $hTexture)
	_GDIPlus_GraphicsFillRect($hGfxCtxt, $iX, $iY + $iHeightCut, $iWidthCut, $vTarget_Height - ($iY + $iHeightCut), $hTexture)
	_GDIPlus_BrushDispose($hTexture)
	_GDIPlus_GraphicsDispose($hGfxCtxt)
	Return $hImage
EndFunc   ;==>_GDIPlus_ImageCutRectHole

; #FUNCTION# ===================================================================================================
; Name...........: _GDIPlus_ImageCrop
; Description ...: Crop a picture
; Syntax.........: _GDIPlus_ImageCrop($hImage, $iX, $iY, $iWidthCut, $iHeightCut, $vTarget_Width, $vTarget_Height)
; Parameters ....: $hImage			- Handle to the picture
;                  $iX				- X position of the crop
;                  $iY				- Y position of the crop
;                  $iWidthCut		- Width of the crop
;                  $iHeightCut		- Height of the crop
;                  $vTarget_Width	- Target Width
;                  $vTarget_Height	- Target Height
; Return values .: Success      - Return Handle
;                  Failure      - -1
; Author ........: UEZ
; Modified.......:
; Remarks .......:
; Related .......:
; Link ..........; https://www.autoitscript.com/forum/topic/146755-solvedlayer-mask-in-gdi/
; Example .......;
Func _GDIPlus_ImageCrop($hImage, $iX, $iY, $iWidthCut, $iHeightCut, $vTarget_Width, $vTarget_Height)
	Local $hTexture = _GDIPlus_TextureCreate($hImage, 4)
	$hImage = _GDIPlus_BitmapCreateFromScan0($vTarget_Width, $vTarget_Height)
	Local $hGfxCtxt = _GDIPlus_ImageGetGraphicsContext($hImage)
	_GDIPlus_GraphicsSetSmoothingMode($hGfxCtxt, 2)
	_GDIPlus_GraphicsSetPixelOffsetMode($hGfxCtxt, 2)
	_GDIPlus_GraphicsFillRect($hGfxCtxt, $iX, $iY, $iWidthCut, $iHeightCut, $hTexture)
	_GDIPlus_BrushDispose($hTexture)
	_GDIPlus_GraphicsDispose($hGfxCtxt)
	Return $hImage
EndFunc   ;==>_GDIPlus_ImageCrop

; #FUNCTION# ===================================================================================================
; Name...........: _GDIPlus_CalcPos
; Description ...: Calculate Relative and tagged position and size
; Syntax.........: _GDIPlus_CalcPos(ByRef $iX, ByRef $iY, ByRef $iWidth, ByRef $iHeight, $vTarget_Width, $vTarget_Height)
; Parameters ....: $iX				- X position to calculate
;                  $iY				- Y position to calculate
;                  $iWidth			- Width
;                  $iHeight			- Height
;                  $vTarget_Width	- Target Width
;                  $vTarget_Height	- Target Height
; Return values .: Success      - Return position and size ByRef
; Author ........: Screech
; Modified.......:
; Remarks .......:
; Related .......:
; Link ..........;
; Example .......;
Func _GDIPlus_CalcPos(ByRef $iX, ByRef $iY, ByRef $iWidth, ByRef $iHeight, $vTarget_Width, $vTarget_Height)
	$iWidth = _GDIPlus_RelativePos($iWidth, $vTarget_Width)
	If $iWidth = "" Then $iWidth = $vTarget_Width
	$iHeight = _GDIPlus_RelativePos($iHeight, $vTarget_Height)
	If $iHeight = "" Then $iHeight = $vTarget_Height
	$iX = _GDIPlus_CalcPosX($iX, $iWidth, $vTarget_Width)
	$iY = _GDIPlus_CalcPosY($iY, $iHeight, $vTarget_Height)
EndFunc   ;==>_GDIPlus_CalcPos

; #FUNCTION# ===================================================================================================
; Name...........: _GDIPlus_CalcPosX
; Description ...: Calculate Relative and tagged X position
; Syntax.........: _GDIPlus_CalcPosX($iX, $iWidth, $vTarget_Width)
; Parameters ....: $iX				- X position to calculate
;                  $iWidth			- Width
;                  $vTarget_Width	- Target Width
; Return values .: Success      - Return $iX
; Author ........: Screech
; Modified.......:
; Remarks .......:
; Related .......:
; Link ..........;
; Example .......;
Func _GDIPlus_CalcPosX($iX, $iWidth, $vTarget_Width)
	$iX = _GDIPlus_RelativePos($iX, $vTarget_Width)
	Switch $iX
		Case 'CENTER'
			$iX = ($vTarget_Width / 2) - ($iWidth / 2)
		Case 'LEFT'
			$iX = 0
		Case 'RIGHT'
			$iX = $vTarget_Width - $iWidth
	EndSwitch
	Return Int($iX)
EndFunc   ;==>_GDIPlus_CalcPosX

; #FUNCTION# ===================================================================================================
; Name...........: _GDIPlus_CalcPosY
; Description ...: Calculate Relative and tagged X position
; Syntax.........: _GDIPlus_CalcPosY($iY, $iHeight, $vTarget_Height)
; Parameters ....: $iY				- Y position to calculate
;                  $iHeight			- Height
;                  $vTarget_Height	- Target Height
; Return values .: Success      - Return $iY
; Author ........: Screech
; Modified.......:
; Remarks .......:
; Related .......:
; Link ..........;
; Example .......;
Func _GDIPlus_CalcPosY($iY, $iHeight, $vTarget_Height)
	$iY = _GDIPlus_RelativePos($iY, $vTarget_Height)
	Switch $iY
		Case 'CENTER'
			$iY = ($vTarget_Height / 2) - ($iHeight / 2)
		Case 'UP'
			$iY = 0
		Case 'DOWN'
			$iY = $vTarget_Height - $iHeight
	EndSwitch
	Return Int($iY)
EndFunc   ;==>_GDIPlus_CalcPosY

; #FUNCTION# ===================================================================================================
; Name...........: _GDIPlus_Merge($iPath1, $iPath2)
; Description ...: Merge 2 pictures
; Syntax.........: _GDIPlus_Merge($iPath1, $iPath2)
; Parameters ....: $iPath1		- First image path
;                  $iPath1		- Second image path
; Return values .: Success      - Return the path of the finale picture
;                  Failure      - -1
; Author ........: Screech
; Modified.......:
; Remarks .......: Delete $iPath2 after merging
; Related .......:
; Link ..........;
; Example .......; No
Func _GDIPlus_Merge($iPath1, $iPath2)
;~ 	MsgBox(0,"DEBUG","_GDIPlus_Merge");Debug
	Local $hGui, $hGraphicGUI, $hBMPBuff, $hGraphic, $ImageWidth, $ImageHeight
	Local $MergedImageBackgroundColor = 0x00000000
	Local $sDrive, $sDir, $sFileName, $iExtension, $iPath_Temp
	_PathSplit($iPath1, $sDrive, $sDir, $sFileName, $iExtension)
	$iPath_Temp = $sDrive & $sDir & $sFileName & "-MER_Temp.PNG"

	If _MakeTEMPFile($iPath1, $iPath_Temp) = -1 Then Return -1

	$iPath1 = $sDrive & $sDir & $sFileName & ".png"

	_GDIPlus_Startup()
	$hImage1 = _GDIPlus_ImageLoadFromFile($iPath_Temp)
	$hImage2 = _GDIPlus_ImageLoadFromFile($iPath2)
	$ImageWidth = _GDIPlus_ImageGetWidth($hImage1)
	If $ImageWidth = 4294967295 Then $ImageWidth = 0 ;4294967295 en cas d'erreur.
	$ImageHeight = _GDIPlus_ImageGetHeight($hImage1)
	$hGui = GUICreate("", $ImageWidth, $ImageHeight)
	$hGraphicGUI = _GDIPlus_GraphicsCreateFromHWND($hGui) ;Draw to this graphics, $hGraphicGUI, to display on GUI
	$hBMPBuff = _GDIPlus_BitmapCreateFromGraphics($ImageWidth, $ImageHeight, $hGraphicGUI) ; $hBMPBuff is a bitmap in memory
	$hGraphic = _GDIPlus_ImageGetGraphicsContext($hBMPBuff) ; Draw to this graphics, $hGraphic, being the graphics of $hBMPBuff
	_GDIPlus_GraphicsClear($hGraphic, $MergedImageBackgroundColor) ;Fill the Graphic Background (0x00000000 for transparent background in .png files)
	_GDIPlus_GraphicsDrawImage($hGraphic, $hImage1, 0, 0)
	_GDIPlus_GraphicsDrawImage($hGraphic, $hImage2, 0, 0)

	_LOG("Merging " & $iPath2 & " on " & $iPath_Temp, 0, $iLOGPath) ; Debug
	_GDIPlus_ImageSaveToFile($hBMPBuff, $iPath1)

	_GDIPlus_GraphicsDispose($hGraphic)
	_GDIPlus_BitmapDispose($hBMPBuff)
	_WinAPI_DeleteObject($hBMPBuff)
	_GDIPlus_GraphicsDispose($hGraphicGUI)
	GUIDelete($hGui)
	_GDIPlus_ImageDispose($hImage2)
	_GDIPlus_ImageDispose($hImage1)
	_GDIPlus_Shutdown()
	If Not FileDelete($iPath_Temp) Then
		_LOG("Error deleting " & $iPath_Temp, 2, $iLOGPath)
		Return -1
	EndIf
	If Not FileDelete($iPath2) Then
		_LOG("Error deleting " & $iPath2, 2, $iLOGPath)
		Return -1
	EndIf
	Return $iPath1
EndFunc   ;==>_GDIPlus_Merge

; #FUNCTION# ===================================================================================================
; Name...........: _GDIPlus_GraphicsDrawImageRectRectTrans
; Description ...: Draw an Image object with transparency
; Syntax.........: _GDIPlus_GraphicsDrawImageRectRect($hGraphics, $hImage, $iSrcX, $iSrcY, [$iSrcWidth, _
;                                   [$iSrcHeight, [$iDstX, [$iDstY, [$iDstWidth, [$iDstHeight[, [$iUnit = 2]]]]]]])
; Parameters ....: $hGraphics   - Handle to a Graphics object
;                  $hImage      - Handle to an Image object
;                  $iSrcX       - The X coordinate of the upper left corner of the source image
;                  $iSrcY       - The Y coordinate of the upper left corner of the source image
;                  $iSrcWidth   - Width of the source image
;                  $iSrcHeight  - Height of the source image
;                  $iDstX       - The X coordinate of the upper left corner of the destination image
;                  $iDstY       - The Y coordinate of the upper left corner of the destination image
;                  $iDstWidth   - Width of the destination image
;                  $iDstHeight  - Height of the destination image
;                  $iUnit       - Specifies the unit of measure for the image
;                  $nTrans      - Value range from 0 (Zero for invisible) to 1.0 (fully opaque)
; Return values .: Success      - True
;                  Failure      - False
; Author ........: Siao
; Modified.......: Malkey
; Remarks .......:
; Related .......:
; Link ..........; http://www.autoitscript.com/forum/index.php?s=&showtopic=70573&view=findpost&p=517195
; Example .......; Yes
Func _GDIPlus_GraphicsDrawImageRectRectTrans($hGraphics, $hImage, $iSrcX, $iSrcY, $iSrcWidth = "", $iSrcHeight = "", _
		$iDstX = "", $iDstY = "", $iDstWidth = "", $iDstHeight = "", $iUnit = 2, $nTrans = 1)
	Local $tColorMatrix, $hImgAttrib, $iW = _GDIPlus_ImageGetWidth($hImage), $iH = _GDIPlus_ImageGetHeight($hImage)
	If $iSrcWidth = 0 Or $iSrcWidth = "" Then $iSrcWidth = $iW
	If $iSrcHeight = 0 Or $iSrcHeight = "" Then $iSrcHeight = $iH
	If $iDstX = "" Then $iDstX = $iSrcX
	If $iDstY = "" Then $iDstY = $iSrcY
	If $iDstWidth = "" Then $iDstWidth = $iSrcWidth
	If $iDstHeight = "" Then $iDstHeight = $iSrcHeight
	If $iUnit = "" Then $iUnit = 2
	;;create color matrix data
	$tColorMatrix = DllStructCreate("float[5];float[5];float[5];float[5];float[5]")
	;blending values:
	Local $x = DllStructSetData($tColorMatrix, 1, 1, 1) * DllStructSetData($tColorMatrix, 2, 1, 2) * DllStructSetData($tColorMatrix, 3, 1, 3) * _
			DllStructSetData($tColorMatrix, 4, $nTrans, 4) * DllStructSetData($tColorMatrix, 5, 1, 5)
;~ 	$x = $x
	;;create an image attributes object and update its color matrix
	$hImgAttrib = _GDIPlus_ImageAttributesCreate()
	_GDIPlus_ImageAttributesSetColorMatrix($hImgAttrib, 1, 1, DllStructGetPtr($tColorMatrix))
	_GDIPlus_GraphicsDrawImageRectRect($hGraphics, $hImage, $iSrcX, $iSrcY, $iSrcWidth, $iSrcHeight, $iDstX, $iDstY, $iDstWidth, $iDstHeight, $hImgAttrib, $iUnit)
	;;clean up
	_GDIPlus_ImageAttributesDispose($hImgAttrib)
	Return
EndFunc   ;==>_GDIPlus_GraphicsDrawImageRectRectTrans

; #FUNCTION# ===================================================================================================
; Name...........: _GDIPlus_Imaging
; Description ...: Prepare a picture
; Syntax.........: _GDIPlus_Imaging($iPath, $aPicParameters, $vTarget_Width, $vTarget_Height, $vTarget_Maximize = 'no')
; Parameters ....: $iPath			- Path to the picture
;                  $aPicParameters	- Position Parameter
;                  $vTarget_Width	- Target Width
;                  $vTarget_Height	- Target Height
;                  $vTarget_Maximize- Maximize the picture (yes or no)
; Return values .: Success      - Return the Path of the Picture
;                  Failure      - -1
; Author ........: Screech
; Modified.......:
; Remarks .......: 	$aPicParameters[0] = Target_Width
; 					$aPicParameters[1] = Target_Height
;				 	$aPicParameters[2] = Target_TopLeftX
;				 	$aPicParameters[3] = Target_TopLeftY
;				 	$aPicParameters[4] = Target_TopRightX
;				 	$aPicParameters[5] = Target_TopRightY
;				 	$aPicParameters[6] = Target_BottomLeftX
;				 	$aPicParameters[7] = Target_BottomLeftY
;				 	$aPicParameters[8] = Target_Maximize
; Related .......:
; Link ..........;
; Example .......; No
Func _GDIPlus_Imaging($iPath, $aPicParameters, $vTarget_Width, $vTarget_Height)
	Local $sDrive, $sDir, $sFileName, $iExtension, $iPath_Temp, $iResized = 0
	_PathSplit($iPath, $sDrive, $sDir, $sFileName, $iExtension)
	$aPicParameters[8] = StringUpper($aPicParameters[8])
	$iPath_Temp = $sDrive & $sDir & $sFileName & "-IMAGING_Temp" & $iExtension
	Local $hImage, $hGui, $hGraphicGUI, $hBMPBuff, $hGraphic
	Local $MergedImageBackgroundColor = 0x00000000
	Local $iWidth = _GDIPlus_RelativePos($aPicParameters[0], $vTarget_Width)
	Local $iHeight = _GDIPlus_RelativePos($aPicParameters[1], $vTarget_Height)
	If $aPicParameters[8] = 'YES' Then $iResized = _GDIPlus_ResizeMax($iPath, $iWidth, $iHeight)
	If _MakeTEMPFile($iPath, $iPath_Temp) = -1 Then Return -1
	_GDIPlus_Startup()
	$hImage = _GDIPlus_ImageLoadFromFile($iPath_Temp)
	If $iWidth <= 0 Or ($aPicParameters[8] = 'YES' And $iResized = 1) Then $iWidth = _GDIPlus_ImageGetWidth($hImage)
	If $iHeight <= 0 Or ($aPicParameters[8] = 'YES' And $iResized = 1) Then $iHeight = _GDIPlus_ImageGetHeight($hImage)
	$hGui = GUICreate("", $vTarget_Width, $vTarget_Height)
	$hGraphicGUI = _GDIPlus_GraphicsCreateFromHWND($hGui) ;Draw to this graphics, $hGraphicGUI, to display on GUI
	$hBMPBuff = _GDIPlus_BitmapCreateFromGraphics($vTarget_Width, $vTarget_Height, $hGraphicGUI) ; $hBMPBuff is a bitmap in memory
	$hGraphic = _GDIPlus_ImageGetGraphicsContext($hBMPBuff) ; Draw to this graphics, $hGraphic, being the graphics of $hBMPBuff
	_GDIPlus_GraphicsClear($hGraphic, $MergedImageBackgroundColor) ; Fill the Graphic Background (0x00000000 for transparent background in .png files)
	Local $Image_C1X = _GDIPlus_CalcPosX($aPicParameters[2], $iWidth, $vTarget_Width)
	Local $Image_C1Y = _GDIPlus_CalcPosY($aPicParameters[3], $iHeight, $vTarget_Height)
	Local $Image_C2X = _GDIPlus_RelativePos($aPicParameters[4], $vTarget_Width)
	Local $Image_C2Y = _GDIPlus_RelativePos($aPicParameters[5], $vTarget_Height)
	Local $Image_C3X = _GDIPlus_RelativePos($aPicParameters[6], $vTarget_Width)
	Local $Image_C3Y = _GDIPlus_RelativePos($aPicParameters[7], $vTarget_Height)
	Switch $Image_C2X
		Case 'CENTER'
			$Image_C2X = Int(($vTarget_Width / 2) + ($iWidth / 2))
		Case 'LEFT'
			$Image_C2X = $iWidth
		Case 'RIGHT'
			$Image_C2X = $vTarget_Width
		Case ''
			$Image_C2X = $Image_C1X + $iWidth
	EndSwitch
	Switch $Image_C2Y
		Case 'CENTER'
			$Image_C2Y = Int(($vTarget_Height / 2) - ($iHeight / 2))
		Case 'UP'
			$Image_C2Y = 0
		Case 'DOWN'
			$Image_C2Y = $vTarget_Height - $iHeight
		Case ''
			$Image_C2Y = $Image_C1Y
	EndSwitch
	Switch $Image_C3X
		Case 'CENTER'
			$Image_C3X = Int(($vTarget_Width / 2) - ($iWidth / 2))
		Case 'LEFT'
			$Image_C3X = 0
		Case 'RIGHT'
			$Image_C3X = $vTarget_Width - $iWidth
		Case ''
			$Image_C3X = $Image_C1X
	EndSwitch
	Switch $Image_C3Y
		Case 'CENTER'
			$Image_C3Y = Int(($vTarget_Height / 2) + ($iHeight / 2))
		Case 'UP'
			$Image_C3Y = 0 + $iHeight
		Case 'DOWN'
			$Image_C3Y = $vTarget_Height
		Case ''
			$Image_C3Y = $Image_C1Y + $iHeight
	EndSwitch

	$Image_C1X = $Image_C1X + _GDIPlus_RelativePos($aPicParameters[9], $vTarget_Width)
	$Image_C1Y = $Image_C1Y + _GDIPlus_RelativePos($aPicParameters[10], $vTarget_Width)
	$Image_C2X = $Image_C2X + _GDIPlus_RelativePos($aPicParameters[9], $vTarget_Width)
	$Image_C2Y = $Image_C2Y + _GDIPlus_RelativePos($aPicParameters[10], $vTarget_Width)
	$Image_C3X = $Image_C3X + _GDIPlus_RelativePos($aPicParameters[9], $vTarget_Width)
	$Image_C3Y = $Image_C3Y + _GDIPlus_RelativePos($aPicParameters[10], $vTarget_Width)

	_GDIPlus_DrawImagePoints($hGraphic, $hImage, $Image_C1X, $Image_C1Y, $Image_C2X, $Image_C2Y, $Image_C3X, $Image_C3Y)
	_GDIPlus_ImageSaveToFile($hBMPBuff, $iPath)
	_GDIPlus_GraphicsDispose($hGraphic)
	_GDIPlus_BitmapDispose($hBMPBuff)
	_WinAPI_DeleteObject($hBMPBuff)
	_GDIPlus_GraphicsDispose($hGraphicGUI)
	GUIDelete($hGui)
	_GDIPlus_ImageDispose($hImage)
	_GDIPlus_Shutdown()
	If Not FileDelete($iPath_Temp) Then
		_LOG("Error deleting " & $iPath_Temp, 2, $iLOGPath)
		Return -1
	EndIf
	Return $iPath
EndFunc   ;==>_GDIPlus_Imaging
#EndRegion GDI Function

#Region XML Function

; #FUNCTION# ===================================================================================================
; Name...........: _XML_Open
; Description ...: Open an XML Object
; Syntax.........: _XML_Open($iXMLPath)
; Parameters ....: $iXMLPath	- Path to the XML File
; Return values .: Success      - Object contening the XML File
;                  Failure      - -1
; Author ........: Screech
; Modified.......:
; Remarks .......:
; Related .......:
; Link ..........;
; Example .......; No
Func _XML_Open($iXMLPath)
	Local $oXMLDoc = _XML_CreateDOMDocument()
	_XML_Load($oXMLDoc, $iXMLPath)
	If @error Then
		_LOG('_XML_Load @error:' & @CRLF & XML_My_ErrorParser(@error), 2, $iLOGPath)
		Return -1
	EndIf
	_XML_TIDY($oXMLDoc)
	If @error Then
		_LOG('_XML_TIDY @error:' & @CRLF & XML_My_ErrorParser(@error), 2, $iLOGPath)
		Return -1
	EndIf
	_LOG($iXMLPath & " Open", 3, $iLOGPath)
	Return $oXMLDoc
EndFunc   ;==>_XML_Open

; #FUNCTION# ===================================================================================================
; Name...........: _XML_Read
; Description ...: Read Data in XML File or XML Object
; Syntax.........: _XML_Read($iXpath, [$iXMLType=0], [$iXMLPath=""], [$oXMLDoc=""])
; Parameters ....: $iXpath		- Xpath to the value to read
;                  $iXMLType	- Type of Value (0 = Node Value, 1 = Attribute Value)
;                  $iXMLPath	- Path to the XML File
;                  $oXMLDoc		- Object contening the XML File
; Return values .: Success      - First Value
;                  Failure      - -1
; Author ........: Screech
; Modified.......:
; Remarks .......:
; Related .......:
; Link ..........;
; Example .......; No
Func _XML_Read($iXpath, $iXMLType = 0, $iXMLPath = "", $oXMLDoc = "")
	Local $iXMLValue = -1, $oNode, $iXpathSplit, $iXMLAttributeName
	If $iXMLPath = "" And $oXMLDoc = "" Then Return -1
	If $iXMLPath <> "" Then
		$oXMLDoc = _XML_Open($iXMLPath)
		If $oXMLDoc = -1 Then
			_LOG('_XML_Open ERROR (' & $iXpath & ')', 2, $iLOGPath)
			Return -1
		EndIf
	EndIf

	Switch $iXMLType
		Case 0
			$iXMLValue = _XML_GetValue($oXMLDoc, $iXpath)
			If @error Then
				If @error = 21 Then Return ""
				_LOG('_XML_GetValue ERROR (' & $iXpath & ')', 2, $iLOGPath)
				_LOG('_XML_GetValue @error(' & @error & ') :' & @CRLF & XML_My_ErrorParser(@error), 3, $iLOGPath)
				Return -1
			EndIf
			If IsArray($iXMLValue) And UBound($iXMLValue) - 1 > 0 Then
				Return $iXMLValue[1]
			Else
				_LOG('_XML_GetValue (' & $iXpath & ') is not an Array', 2, $iLOGPath)
				Return -1
			EndIf
		Case 1
			$iXpathSplit = StringSplit($iXpath, "/")
			$iXMLAttributeName = $iXpathSplit[UBound($iXpathSplit) - 1]
			$iXpath = StringTrimRight($iXpath, StringLen($iXMLAttributeName) + 1)
			$oNode = _XML_SelectSingleNode($oXMLDoc, $iXpath)
			If @error Then
				_LOG('_XML_SelectSingleNode ERROR (' & $iXpath & ')', 2, $iLOGPath)
				_LOG('_XML_SelectSingleNode @error:' & @CRLF & XML_My_ErrorParser(@error), 3, $iLOGPath)
				Return -1
			EndIf
			$iXMLValue = _XML_GetNodeAttributeValue($oNode, $iXMLAttributeName)
			If @error Then
				_LOG('_XML_GetNodeAttributeValue ERROR (' & $iXpath & ')', 2, $iLOGPath)
				_LOG('_XML_GetNodeAttributeValue @error:' & @CRLF & XML_My_ErrorParser(@error), 3, $iLOGPath)
				Return -1
			EndIf
			Return $iXMLValue
		Case Else
			Return -2
	EndSwitch

	Return -1
EndFunc   ;==>_XML_Read

; #FUNCTION# ===================================================================================================
; Name...........: _XML_Replace
; Description ...: replace Data in XML File or XML Object
; Syntax.........: _XML_Replace($iXpath, $iValue, [$iXMLType=0], [$iXMLPath=""], [$oXMLDoc=""])
; Parameters ....: $iXpath		- Xpath to the value to replace
;~ 				   $iValue		- Value to replace
;                  $iXMLType	- Type of Value (0 = Node Value, 1 = Attribute Value)
;                  $iXMLPath	- Path to the XML File
;                  $oXMLDoc		- Object contening the XML File
; Return values .: Success      - 1
;                  Failure      - -1
; Author ........: Screech
; Modified.......:
; Remarks .......:
; Related .......:
; Link ..........;
; Example .......; No
Func _XML_Replace($iXpath, $iValue, $iXMLType = 0, $iXMLPath = "", $oXMLDoc = "")
	Local $iXMLValue = -1, $oNode, $iXpathSplit, $iXMLAttributeName
	If $iXMLPath = "" And $oXMLDoc = "" Then
		_LOG('_XML_Replace Error : Need an Handle or Path', 2, $iLOGPath)
		Return -1
	EndIf
	If $iXMLPath <> "" Then
		$oXMLDoc = _XML_Open($iXMLPath)
		If $oXMLDoc = -1 Then Return -1
	EndIf

	Switch $iXMLType
		Case 0
			$iXMLValue = _XML_UpdateField($oXMLDoc, $iXpath, $iValue)
			If @error Then
				_LOG('_XML_UpdateField @error:' & @CRLF & XML_My_ErrorParser(@error), 2, $iLOGPath)
				Return -1
			EndIf
			_XML_TIDY($oXMLDoc)
			_LOG('_XML_UpdateField (' & $iXpath & ') = ' & $iValue, 1, $iLOGPath)
			Return 1
		Case 1
			$iXpathSplit = StringSplit($iXpath, "/")
			$iXMLAttributeName = $iXpathSplit[UBound($iXpathSplit) - 1]
			$iXpath = StringTrimRight($iXpath, StringLen($iXMLAttributeName) + 1)
			_XML_SetAttrib($oXMLDoc, $iXpath, $iXMLAttributeName, $iValue)
			If @error Then
				_LOG('_XML_SelectSingleNode @error:' & @CRLF & XML_My_ErrorParser(@error), 2, $iLOGPath)
				Return -1
			EndIf
			_XML_TIDY($oXMLDoc)
			_LOG('_XML_UpdateField (' & $iXpath & ') = ' & $iValue, 1, $iLOGPath)
			Return 1
		Case Else
			_LOG('_XML_Replace : $iXMLType Unknown', 2, $iLOGPath)
			Return -1
	EndSwitch

	Return -1
EndFunc   ;==>_XML_Replace

; #FUNCTION# ===================================================================================================
; Name...........: _XML_ListValue
; Description ...: List Data in XML File or XML Object
; Syntax.........: _XML_ListValue($iXpath, [$iXMLPath=""], [$oXMLDoc=""])
; Parameters ....: $iXpath		- Xpath to the values to read
;                  $iXMLPath	- Path to the XML File
;                  $oXMLDoc		- Object contening the XML File
; Return values .: Success      - Array with all the data ([0] = Nb of Values)
;                  Failure      - -1
; Author ........: Screech
; Modified.......:
; Remarks .......: No attribute
; Related .......:
; Link ..........;
; Example .......; No
Func _XML_ListValue($iXpath, $iXMLPath = "", $oXMLDoc = "")
	Local $iXMLValue = -1
	If $iXMLPath = "" And $oXMLDoc = "" Then Return -1
	If $iXMLPath <> "" Then
		$oXMLDoc = _XML_Open($iXMLPath)
		If $oXMLDoc = -1 Then Return -1
	EndIf

	$iXMLValue = _XML_GetValue($oXMLDoc, $iXpath)
	If @error Then
		_LOG('_XML_GetValue ERROR (' & $iXpath & ')', 2, $iLOGPath)
		_LOG('_XML_GetValue @error:' & @CRLF & XML_My_ErrorParser(@error), 3, $iLOGPath)
		Return -1
	EndIf
	If IsArray($iXMLValue) Then
		Return $iXMLValue
	Else
		_LOG('_XML_GetValue (' & $iXpath & ') is not an Array', 2, $iLOGPath)
		Return -1
	EndIf

	Return -1
EndFunc   ;==>_XML_ListValue

; #FUNCTION# ===================================================================================================
; Name...........: _XML_ListNode
; Description ...: List Nodes in XML File or XML Object
; Syntax.........: _XML_ListNode($iXpath, [$iXMLPath=""], [$oXMLDoc=""])
; Parameters ....: $iXpath		- Xpath to the Node to read
;                  $iXMLPath	- Path to the XML File
;                  $oXMLDoc		- Object contening the XML File
; Return values .: Success      - Array with all the data ([0][0] = Nb of Values ; [x][0] = Node Name ; [x][1] = Node Value)
;                  Failure      - -1
; Author ........: Screech
; Modified.......:
; Remarks .......: No attribute
; Related .......:
; Link ..........;
; Example .......; No
Func _XML_ListNode($iXpath, $iXMLPath = "", $oXMLDoc = "")
	Local $iXMLValue = -1
	If $iXMLPath = "" And $oXMLDoc = "" Then Return -1
	If $iXMLPath <> "" Then
		$oXMLDoc = _XML_Open($iXMLPath)
		If $oXMLDoc = -1 Then Return -1
	EndIf

	$iXMLValue = _XML_GetChildren($oXMLDoc, $iXpath)
	If @error Then
		_LOG('_XML_GetChildNodes ERROR (' & $iXpath & ')', 2, $iLOGPath)
		_LOG('_XML_GetChildNodes @error:' & @CRLF & XML_My_ErrorParser(@error), 3, $iLOGPath)
		Return -1
	EndIf
	If IsArray($iXMLValue) Then
		Return $iXMLValue
	Else
		_LOG('_XML_GetValue (' & $iXpath & ') is not an Array', 2, $iLOGPath)
		Return -1
	EndIf
	Return -1
EndFunc   ;==>_XML_ListNode

; #FUNCTION# ===================================================================================================
; Name...........: _XML_Make
; Description ...: Create an XML File and Object
; Syntax.........: _XML_Make($iXMLPath,$iRoot,[$iUTF8 = True])
; Parameters ....: $iXMLPath	- Path to the XML File
;                  $iRoot		- Xpath Root
;                  $iUTF8		- UTF8 encoding
; Return values .: Success      - Object contening the XML File
;                  Failure      - -1
; Author ........: Screech
; Modified.......:
; Remarks .......:
; Related .......:
; Link ..........;
; Example .......; No
Func _XML_Make($iXMLPath, $iRoot, $iUTF8 = True)
	FileDelete($iXMLPath)
	Local $oXMLDoc = _XML_CreateFile($iXMLPath, $iRoot, $iUTF8)
	If @error Then
		_LOG('_XML_CreateFile @error:' & @CRLF & XML_My_ErrorParser(@error), 2, $iLOGPath)
		Return -1
	EndIf
	Return $oXMLDoc
EndFunc   ;==>_XML_Make

; #FUNCTION# ===================================================================================================
; Name...........: _XML_WriteValue
; Description ...: Create a node and is value in XML File or XML Object
; Syntax.........: _XML_WriteValue($iXpath, [$iValue=""], [$iXMLPath=""], [$oXMLDoc=""])
; Parameters ....: $iXpath		- Xpath to the value to read
;                  $iValue		- Value to write
;                  $iXMLPath	- Path to the XML File
;                  $oXMLDoc		- Object contening the XML File
; Return values .: Success      - 1
;                  Failure      - -1
; Author ........: Screech
; Modified.......:
; Remarks .......:
; Related .......:
; Link ..........;
; Example .......; No
Func _XML_WriteValue($iXpath, $iValue = "", $iXMLPath = "", $oXMLDoc = "", $ipos = "last()")
	Local $iXMLValue = -1, $oNode, $iXpathSplit, $iXMLAttributeName
	If $iXMLPath = "" And $oXMLDoc = "" Then Return -1
	If $iXMLPath <> "" Then
		$oXMLDoc = _XML_Open($iXMLPath)
		If $oXMLDoc = -1 Then Return -1
	EndIf

	$iXpathSplit = StringSplit($iXpath, "/")
	$iXMLChildName = $iXpathSplit[UBound($iXpathSplit) - 1]
	$iXpath = StringTrimRight($iXpath, StringLen($iXMLChildName) + 1)
	_XML_CreateChildWAttr($oXMLDoc, $iXpath & "[" & $ipos & "]", $iXMLChildName, Default, $iValue)
	If @error Then
		_LOG('_XML_CreateChildWAttr ERROR (' & $iXpath & ')', 2, $iLOGPath)
		_LOG('_XML_CreateChildWAttr @error:' & @CRLF & XML_My_ErrorParser(@error), 3, $iLOGPath)
		Return -1
	EndIf
	Return 1
EndFunc   ;==>_XML_WriteValue

; #FUNCTION# ===================================================================================================
; Name...........: _XML_WriteAttributs
; Description ...: Read Data in XML File or XML Object
; Syntax.........: _XML_WriteAttributs($iXpath, $iAttribute, [$iValue=""], [$iXMLPath=""], [$oXMLDoc=""])
; Parameters ....: $iXpath		- Xpath to the value to read
;                  $iAttribute	- Attribute name
;                  $iValue		- Value to write
;                  $iXMLPath	- Path to the XML File
;                  $oXMLDoc		- Object contening the XML File
; Return values .: Success      - 1
;                  Failure      - -1
; Author ........: Screech
; Modified.......:
; Remarks .......:
; Related .......:
; Link ..........;
; Example .......; No
Func _XML_WriteAttributs($iXpath, $iAttribute, $iValue = "", $iXMLPath = "", $oXMLDoc = "", $ipos = "last()")
	Local $iXMLValue = -1, $oNode, $iXpathSplit, $iXMLAttributeName
	If $iXMLPath = "" And $oXMLDoc = "" Then Return -1
	If $iXMLPath <> "" Then
		$oXMLDoc = _XML_Open($iXMLPath)
		If $oXMLDoc = -1 Then Return -1
	EndIf

	_XML_SetAttrib($oXMLDoc, $iXpath & "[" & $ipos & "]", $iAttribute, $iValue)
	If @error Then
		_LOG('_XML_SetAttrib ERROR (' & $iXpath & ')', 2, $iLOGPath)
		_LOG('_XML_SetAttrib @error:' & @CRLF & XML_My_ErrorParser(@error), 3, $iLOGPath)
		Return -1
	EndIf
	Return 1
EndFunc   ;==>_XML_WriteAttributs

#EndRegion XML Function

#Region XML DOM Error/Event Handling
; This COM Error Hanlder will be used globally (excepting inside UDF Functions)
Global $oErrorHandler = ObjEvent("AutoIt.Error", ErrFunc_CustomUserHandler_MAIN)
#forceref $oErrorHandler

; This is SetUp for the transfer UDF internal COM Error Handler to the user function
_XML_ComErrorHandler_UserFunction(ErrFunc_CustomUserHandler_XML)

Func ErrFunc_CustomUserHandler_MAIN($oError)
	ConsoleWrite(@ScriptName & " (" & $oError.scriptline & ") : MainScript ==> COM Error intercepted !" & @CRLF & _
			@TAB & "err.number is: " & @TAB & @TAB & "0x" & Hex($oError.number) & @CRLF & _
			@TAB & "err.windescription:" & @TAB & $oError.windescription & @CRLF & _
			@TAB & "err.description is: " & @TAB & $oError.description & @CRLF & _
			@TAB & "err.source is: " & @TAB & @TAB & $oError.source & @CRLF & _
			@TAB & "err.helpfile is: " & @TAB & $oError.helpfile & @CRLF & _
			@TAB & "err.helpcontext is: " & @TAB & $oError.helpcontext & @CRLF & _
			@TAB & "err.lastdllerror is: " & @TAB & $oError.lastdllerror & @CRLF & _
			@TAB & "err.scriptline is: " & @TAB & $oError.scriptline & @CRLF & _
			@TAB & "err.retcode is: " & @TAB & "0x" & Hex($oError.retcode) & @CRLF & @CRLF)
EndFunc   ;==>ErrFunc_CustomUserHandler_MAIN

Func ErrFunc_CustomUserHandler_XML($oError)
	; here is declared another path to UDF au3 file
	; thanks to this with using _XML_ComErrorHandler_UserFunction(ErrFunc_CustomUserHandler_XML)
	;  you get errors which after pressing F4 in SciTE4AutoIt you goes directly to the specified UDF Error Line
	ConsoleWrite(@ScriptDir & '\XMLWrapperEx.au3' & " (" & $oError.scriptline & ") : UDF ==> COM Error intercepted ! " & @CRLF & _
			@TAB & "err.number is: " & @TAB & @TAB & "0x" & Hex($oError.number) & @CRLF & _
			@TAB & "err.windescription:" & @TAB & $oError.windescription & @CRLF & _
			@TAB & "err.description is: " & @TAB & $oError.description & @CRLF & _
			@TAB & "err.source is: " & @TAB & @TAB & $oError.source & @CRLF & _
			@TAB & "err.helpfile is: " & @TAB & $oError.helpfile & @CRLF & _
			@TAB & "err.helpcontext is: " & @TAB & $oError.helpcontext & @CRLF & _
			@TAB & "err.lastdllerror is: " & @TAB & $oError.lastdllerror & @CRLF & _
			@TAB & "err.scriptline is: " & @TAB & $oError.scriptline & @CRLF & _
			@TAB & "err.retcode is: " & @TAB & "0x" & Hex($oError.retcode) & @CRLF & @CRLF)
EndFunc   ;==>ErrFunc_CustomUserHandler_XML

Func XML_DOM_EVENT_ondataavailable()
	#CS
		ondataavailable Event
		https://msdn.microsoft.com/en-us/library/ms754530(v=vs.85).aspx
	#CE
	Local $oEventObj = @COM_EventObj
	ConsoleWrite('@COM_EventObj = ' & ObjName($oEventObj, 3) & @CRLF)

	Local $sMessage = 'XML_DOM_EVENT_ fired "ondataavailable"' & @CRLF
	ConsoleWrite($sMessage)
EndFunc   ;==>XML_DOM_EVENT_ondataavailable

Func XML_DOM_EVENT_onreadystatechange()
	#CS
		onreadystatechange Event
		https://msdn.microsoft.com/en-us/library/ms759186(v=vs.85).aspx
	#CE
	Local $oEventObj = @COM_EventObj
	ConsoleWrite('@COM_EventObj = ' & ObjName($oEventObj, 3) & @CRLF)

	Local $sMessage = 'XML_DOM_EVENT_ fired "onreadystatechange" : ReadyState = ' & $oEventObj.ReadyState & @CRLF
	ConsoleWrite($sMessage)

EndFunc   ;==>XML_DOM_EVENT_onreadystatechange

Func XML_DOM_EVENT_ontransformnode($oNodeCode_XSL, $oNodeData_XML, $bBool)
	#forceref $oNodeCode_XSL, $oNodeData_XML, $bBool
	#CS
		ontransformnode Event
		https://msdn.microsoft.com/en-us/library/ms767521(v=vs.85).aspx
	#CE
	Local $oEventObj = @COM_EventObj
	ConsoleWrite('@COM_EventObj = ' & ObjName($oEventObj, 3) & @CRLF)

	Local $sMessage = 'XML_DOM_EVENT_ fired "ontransformnode"' & @CRLF
	ConsoleWrite($sMessage)

EndFunc   ;==>XML_DOM_EVENT_ontransformnode

; #FUNCTION# ====================================================================================================================
; Name ..........: XML_My_ErrorParser
; Description ...: Changing $XML_ERR_ ... to human readable description
; Syntax ........: XML_My_ErrorParser($iXMLWrapper_Error, $iXMLWrapper_Extended)
; Parameters ....: $iXMLWrapper_Error	- an integer value.
;                  $iXMLWrapper_Extended           - an integer value.
; Return values .: description as string
; Author ........: mLipok
; Modified ......:
; Remarks .......: This function is only example of how user can parse @error and @extended to human readable description
; Related .......:
; Link ..........:
; Example .......: No
; ===============================================================================================================================
Func XML_My_ErrorParser($iXMLWrapper_Error, $iXMLWrapper_Extended = 0)
	Local $sErrorInfo = ''
	Switch $iXMLWrapper_Error
		Case $XML_ERR_OK
			$sErrorInfo = '$XML_ERR_OK=' & $XML_ERR_OK & @CRLF & 'All is ok.'
		Case $XML_ERR_GENERAL
			$sErrorInfo = '$XML_ERR_GENERAL=' & $XML_ERR_GENERAL & @CRLF & 'The error which is not specifically defined.'
		Case $XML_ERR_COMERROR
			$sErrorInfo = '$XML_ERR_COMERROR=' & $XML_ERR_COMERROR & @CRLF & 'COM ERROR OCCURED. Check @extended and your own error handler function for details.'
		Case $XML_ERR_ISNOTOBJECT
			$sErrorInfo = '$XML_ERR_ISNOTOBJECT=' & $XML_ERR_ISNOTOBJECT & @CRLF & 'No object passed to function'
		Case $XML_ERR_INVALIDDOMDOC
			$sErrorInfo = '$XML_ERR_INVALIDDOMDOC=' & $XML_ERR_INVALIDDOMDOC & @CRLF & 'Invalid object passed to function'
		Case $XML_ERR_INVALIDATTRIB
			$sErrorInfo = '$XML_ERR_INVALIDATTRIB=' & $XML_ERR_INVALIDATTRIB & @CRLF & 'Invalid object passed to function.'
		Case $XML_ERR_INVALIDNODETYPE
			$sErrorInfo = '$XML_ERR_INVALIDNODETYPE=' & $XML_ERR_INVALIDNODETYPE & @CRLF & 'Invalid object passed to function.'
		Case $XML_ERR_OBJCREATE
			$sErrorInfo = '$XML_ERR_OBJCREATE=' & $XML_ERR_OBJCREATE & @CRLF & 'Object can not be created.'
		Case $XML_ERR_NODECREATE
			$sErrorInfo = '$XML_ERR_NODECREATE=' & $XML_ERR_NODECREATE & @CRLF & 'Can not create Node - check also COM Error Handler'
		Case $XML_ERR_NODEAPPEND
			$sErrorInfo = '$XML_ERR_NODEAPPEND=' & $XML_ERR_NODEAPPEND & @CRLF & 'Can not append Node - check also COM Error Handler'
		Case $XML_ERR_PARSE
			$sErrorInfo = '$XML_ERR_PARSE=' & $XML_ERR_PARSE & @CRLF & 'Error: with Parsing objects, .parseError.errorCode=' & $iXMLWrapper_Extended & ' Use _XML_ErrorParser_GetDescription() for get details.'
		Case $XML_ERR_PARSE_XSL
			$sErrorInfo = '$XML_ERR_PARSE_XSL=' & $XML_ERR_PARSE_XSL & @CRLF & 'Error with Parsing XSL objects .parseError.errorCode=' & $iXMLWrapper_Extended & ' Use _XML_ErrorParser_GetDescription() for get details.'
		Case $XML_ERR_LOAD
			$sErrorInfo = '$XML_ERR_LOAD=' & $XML_ERR_LOAD & @CRLF & 'Error opening specified file.'
		Case $XML_ERR_SAVE
			$sErrorInfo = '$XML_ERR_SAVE=' & $XML_ERR_SAVE & @CRLF & 'Error saving file.'
		Case $XML_ERR_PARAMETER
			$sErrorInfo = '$XML_ERR_PARAMETER=' & $XML_ERR_PARAMETER & @CRLF & 'Wrong parameter passed to function.'
		Case $XML_ERR_ARRAY
			$sErrorInfo = '$XML_ERR_ARRAY=' & $XML_ERR_ARRAY & @CRLF & 'Wrong array parameter passed to function. Check array dimension and conent.'
		Case $XML_ERR_XPATH
			$sErrorInfo = '$XML_ERR_XPATH=' & $XML_ERR_XPATH & @CRLF & 'XPath syntax error - check also COM Error Handler.'
		Case $XML_ERR_NONODESMATCH
			$sErrorInfo = '$XML_ERR_NONODESMATCH=' & $XML_ERR_NONODESMATCH & @CRLF & 'No nodes match the XPath expression'
		Case $XML_ERR_NOCHILDMATCH
			$sErrorInfo = '$XML_ERR_NOCHILDMATCH=' & $XML_ERR_NOCHILDMATCH & @CRLF & 'There is no Child in nodes matched by XPath expression.'
		Case $XML_ERR_NOATTRMATCH
			$sErrorInfo = '$XML_ERR_NOATTRMATCH=' & $XML_ERR_NOATTRMATCH & @CRLF & 'There is no such attribute in selected node.'
		Case $XML_ERR_DOMVERSION
			$sErrorInfo = '$XML_ERR_DOMVERSION=' & $XML_ERR_DOMVERSION & @CRLF & 'DOM Version: ' & 'MSXML Version ' & $iXMLWrapper_Extended & ' or greater required for this function'
		Case $XML_ERR_EMPTYCOLLECTION
			$sErrorInfo = '$XML_ERR_EMPTYCOLLECTION=' & $XML_ERR_EMPTYCOLLECTION & @CRLF & 'Collections of objects was empty'
		Case $XML_ERR_EMPTYOBJECT
			$sErrorInfo = '$XML_ERR_EMPTYOBJECT=' & $XML_ERR_EMPTYOBJECT & @CRLF & 'Object is empty'
		Case Else
			$sErrorInfo = '=' & $iXMLWrapper_Error & @CRLF & 'NO ERROR DESCRIPTION FOR THIS @error'
	EndSwitch

	Local $sExtendedInfo = ''
	Switch $iXMLWrapper_Error
		Case $XML_ERR_COMERROR, $XML_ERR_NODEAPPEND, $XML_ERR_NODECREATE
			$sExtendedInfo = 'COM ERROR NUMBER (@error returned via @extended) =' & $iXMLWrapper_Extended
		Case $XML_ERR_PARAMETER
			$sExtendedInfo = 'This @error was fired by parameter: #' & $iXMLWrapper_Extended
		Case Else
			Switch $iXMLWrapper_Extended
				Case $XML_EXT_DEFAULT
					$sExtendedInfo = '$XML_EXT_DEFAULT=' & $XML_EXT_DEFAULT & @CRLF & 'Default - Do not return any additional information'
				Case $XML_EXT_XMLDOM
					$sExtendedInfo = '$XML_EXT_XMLDOM=' & $XML_EXT_XMLDOM & @CRLF & '"Microsoft.XMLDOM" related Error'
				Case $XML_EXT_DOMDOCUMENT
					$sExtendedInfo = '$XML_EXT_DOMDOCUMENT=' & $XML_EXT_DOMDOCUMENT & @CRLF & '"Msxml2.DOMDocument" related Error'
				Case $XML_EXT_XSLTEMPLATE
					$sExtendedInfo = '$XML_EXT_XSLTEMPLATE=' & $XML_EXT_XSLTEMPLATE & @CRLF & '"Msxml2.XSLTemplate" related Error'
				Case $XML_EXT_SAXXMLREADER
					$sExtendedInfo = '$XML_EXT_SAXXMLREADER=' & $XML_EXT_SAXXMLREADER & @CRLF & '"MSXML2.SAXXMLReader" related Error'
				Case $XML_EXT_MXXMLWRITER
					$sExtendedInfo = '$XML_EXT_MXXMLWRITER=' & $XML_EXT_MXXMLWRITER & @CRLF & '"MSXML2.MXXMLWriter" related Error'
				Case $XML_EXT_FREETHREADEDDOMDOCUMENT
					$sExtendedInfo = '$XML_EXT_FREETHREADEDDOMDOCUMENT=' & $XML_EXT_FREETHREADEDDOMDOCUMENT & @CRLF & '"Msxml2.FreeThreadedDOMDocument" related Error'
				Case $XML_EXT_XMLSCHEMACACHE
					$sExtendedInfo = '$XML_EXT_XMLSCHEMACACHE=' & $XML_EXT_XMLSCHEMACACHE & @CRLF & '"Msxml2.XMLSchemaCache." related Error'
				Case $XML_EXT_STREAM
					$sExtendedInfo = '$XML_EXT_STREAM=' & $XML_EXT_STREAM & @CRLF & '"ADODB.STREAM" related Error'
				Case $XML_EXT_ENCODING
					$sExtendedInfo = '$XML_EXT_ENCODING=' & $XML_EXT_ENCODING & @CRLF & 'Encoding related Error'
				Case Else
					$sExtendedInfo = '$iXMLWrapper_Extended=' & $iXMLWrapper_Extended & @CRLF & 'NO ERROR DESCRIPTION FOR THIS @extened'
			EndSwitch
	EndSwitch
	; return back @error and @extended for further debuging
	Return SetError($iXMLWrapper_Error, $iXMLWrapper_Extended, _
			'@error description:' & @CRLF & _
			$sErrorInfo & @CRLF & _
			@CRLF & _
			'@extended description:' & @CRLF & _
			$sExtendedInfo & @CRLF & _
			'')

EndFunc   ;==>XML_My_ErrorParser
#EndRegion XML DOM Error/Event Handling


#Region SendMail Function

Func _CreateMailslot($sMailSlotName)
	Local $hHandle = _MailSlotCreate($sMailSlotName)
	If @error Then
		_LOG("MailSlot error : Failed to create new account! (" & $sMailSlotName & ")", 2, $iLOGPath)
		Return -1
	EndIf
	Return $hHandle
EndFunc   ;==>_CreateMailslot


Func _SendMail($hHandle, $sDataToSend)
	If $sDataToSend Then
		_MailSlotWrite($hHandle, $sDataToSend, 2)
		Switch @error
			Case 1
				_LOG("MailSlot error : Account that you try to send to likely doesn't exist!", 2, $iLOGPath)
				Return -1
			Case 2
				_LOG("MailSlot error : Message is blocked!", 2, $iLOGPath)
				Return -1
			Case 3
				_LOG("MailSlot error : Message is send but there is an open handle left.", 2, $iLOGPath)
				Return -1
			Case 4
				_LOG("MailSlot error : All is fucked up!", 2, $iLOGPath)
				Return -1
			Case Else
				_LOG("MailSlot : Sucessfully sent =" & $sDataToSend, 3, $iLOGPath)
				Return 1
		EndSwitch
	Else
		_LOG("MailSlot error : Nothing to send.", 2, $iLOGPath)
	EndIf
EndFunc   ;==>_SendMail

Func _ReadMessage($hHandle)
	Local $iSize = _MailSlotCheckForNextMessage($hHandle)
	If $iSize Then
		Return _MailSlotRead($hHandle, $iSize, 2)
	Else
		_LOG("MailSlot error : MailSlot is empty", 2, $iLOGPath)
		Return -1
	EndIf
EndFunc   ;==>_ReadMessage


Func _CheckCount($hHandle)
	Local $iCount = _MailSlotGetMessageCount($hHandle)
	Switch $iCount
		Case 0
			_LOG("MailSlot : No new messages", 3, $iLOGPath)
		Case 1
			_LOG("MailSlot : There is 1 message waiting to be read.", 3, $iLOGPath)
		Case Else
			_LOG("MailSlot : There are " & $iCount & " messages waiting to be read.", 3, $iLOGPath)
	EndSwitch
	Return $iCount
EndFunc   ;==>_CheckCount

Func _CheckAnswer($hHandle, $idata)
	Local $iAnwser = ""
	Local $iSize
	Local $iCounter = 0
	While $iAnwser <> $idata And $iCounter < 500
		$iSize = _MailSlotCheckForNextMessage($hHandle)
		If $iSize Then $idata = _MailSlotRead($hHandle, $iSize, 2)
		$iCounter += 1
	WEnd
	Return 1
EndFunc   ;==>_CheckAnswer


Func _CloseMailAccount(ByRef $hHandle)
	If _MailSlotClose($hHandle) Then
		$hHandle = 0
		_LOG("MailSlot : Account succesfully closed.", 3, $iLOGPath)
		Return 1
	Else
		_LOG("MailSlot error : Account could not be closed!", 2, $iLOGPath)
		Return -1
	EndIf

EndFunc   ;==>_CloseMailAccount


Func _RestoreAccount($hHandle)
	Local $hMailSlotHandle = _MailSlotCreate($hHandle)
	If @error Then
		_LOG("MailSlot error : Account could not be created!", 2, $iLOGPath)
		Return -1
	Else
		_LOG("MailSlot error : New account with the same address successfully created!", 2, $iLOGPath)
		Return $hMailSlotHandle
	EndIf
EndFunc   ;==>_RestoreAccount

#EndRegion SendMail Function


#Region Not Used Function
Func ImageColorToTransparent($hImage2, $iColor = Default)
	Local $hBitmap1, $Reslt, $width, $height, $stride, $format, $Scan0, $v_Buffer, $v_Value, $iIW, $iIH

	$GuiSizeX = _GDIPlus_ImageGetWidth($hImage2)
	$GuiSizeY = _GDIPlus_ImageGetHeight($hImage2)
	$hBitmap1 = _GDIPlus_BitmapCloneArea($hImage2, 0, 0, $GuiSizeX, $GuiSizeY, $GDIP_PXF32ARGB)
	If $iColor = Default Then $iColor = _GDIPlus_BitmapGetPixel($hBitmap1, 1, 1) ; Transparent color
	ProgressOn("", "Processing", "0 percent", "", @DesktopHeight - 80, 1)
	$Reslt = _GDIPlus_BitmapLockBits($hBitmap1, 0, 0, $GuiSizeX, $GuiSizeY, BitOR($GDIP_ILMREAD, $GDIP_ILMWRITE), $GDIP_PXF32ARGB)
	;Get the returned values of _GDIPlus_BitmapLockBits ()
	$width = DllStructGetData($Reslt, "width")
	$height = DllStructGetData($Reslt, "height")
	$stride = DllStructGetData($Reslt, "stride")
	$format = DllStructGetData($Reslt, "format")
	$Scan0 = DllStructGetData($Reslt, "Scan0")
	For $i = 0 To $GuiSizeX - 1
		For $j = 0 To $GuiSizeY - 1
			$v_Buffer = DllStructCreate("dword", $Scan0 + ($j * $stride) + ($i * 4))
			$v_Value = DllStructGetData($v_Buffer, 1)
			If Hex($v_Value, 6) = Hex($iColor, 6) Then
				DllStructSetData($v_Buffer, 1, Hex($iColor, 6)) ; Sets Transparency here. Alpha Channel = 00, not written to.
			EndIf
		Next
		ProgressSet(Int(100 * $i / ($GuiSizeX)), Int(100 * $i / ($GuiSizeX)) & " percent")
	Next
	_GDIPlus_BitmapUnlockBits($hBitmap1, $Reslt)
	ProgressOff()
	Return $hBitmap1
EndFunc   ;==>ImageColorToTransparent

; #FUNCTION# ===================================================================================================
; Name...........: _GDIPlus_CreateMask
; Description ...: Create a Mask
; Syntax.........: _GDIPlus_Fusion($iPath1,$iPath2)
; Parameters ....: $iPath1		- First image path
;                  $iPath1		- Second image path
; Return values .: Success      - Return the path of the finale picture
;                  Failure      - -1
; Author ........: Screech
; Modified.......:
; Related .......:
; Link ..........;
; Example .......; No
Func _GDIPlus_CreateMask($iPath_Temp, $iX, $iY, $iWidth, $iHeight)
	Local $aRemapTable[2][2]
	Local $iPathBlack_Source = $iScriptPath & "\Ressources\Black.png"
	Local $iPathWhite_Source = $iScriptPath & "\Ressources\White.png"
	Local $iPathBlack_TEMP = $iScriptPath & "\TEMP\MIX\Black_TEMP.png"
	Local $iPathWhite_TEMP = $iScriptPath & "\TEMP\MIX\White_TEMP.png"
	Local $iPathMask_TEMP = $iScriptPath & "\TEMP\MIX\Mask_TEMP.png"
	Local $iPathMask = $iScriptPath & "\TEMP\MIX\Mask.png"
	Local $iPathIMask = $iScriptPath & "\TEMP\MIX\IMask.png"

	$aRemapTable[0][0] = 1
	$aRemapTable[1][0] = 0xFFFFFFFF ;Farbe, die Transparent gemacht werden soll

	FileCopy($iPathWhite_Source, $iPathWhite_TEMP, $FC_OVERWRITE + $FC_CREATEPATH)
	FileCopy($iPathBlack_Source, $iPathMask_TEMP, $FC_OVERWRITE + $FC_CREATEPATH)
	FileDelete($iPathMask)
	FileDelete($iPathIMask)

	_GDIPlus_Startup()
	$hImage = _GDIPlus_ImageLoadFromFile($iPath_Temp)
	$ImageWidth = _GDIPlus_ImageGetWidth($hImage)
	If $ImageWidth = 4294967295 Then $ImageWidth = 0 ;4294967295 en cas d'erreur.
	$ImageHeight = _GDIPlus_ImageGetHeight($hImage)
	_GDIPlus_ImageDispose($hImage)
	_GDIPlus_Shutdown()

	Dim $aPicParameters[9]
	$aPicParameters[0] = $iWidth
	$aPicParameters[1] = $iHeight
	$aPicParameters[2] = $iX
	$aPicParameters[3] = $iY
	_GDIPlus_Imaging($iPathWhite_TEMP, $aPicParameters, $ImageWidth, $ImageHeight)
	$aPicParameters[0] = $ImageWidth
	$aPicParameters[1] = $ImageHeight
	$aPicParameters[2] = 0
	$aPicParameters[3] = 0
	$aPicParameters[4] = $ImageWidth
	$aPicParameters[5] = 0
	$aPicParameters[6] = 0
	$aPicParameters[7] = $ImageHeight
	_GDIPlus_Imaging($iPathMask_TEMP, $aPicParameters, $ImageWidth, $ImageHeight)
	_GDIPlus_Merge($iPathMask_TEMP, $iPathWhite_TEMP)

	_GDIPlus_Startup()
	$hImage = _GDIPlus_BitmapCreateFromFile($iPathMask_TEMP)
	$hImage_Result = _GDIPlus_BitmapCreateFromScan0($ImageWidth, $ImageHeight)
	$hImage_Result_Ctxt = _GDIPlus_ImageGetGraphicsContext($hImage_Result)

	$hIA = _GDIPlus_ImageAttributesCreate()
	_GDIPlus_ImageAttributesSetRemapTable($hIA, 1, True, $aRemapTable)
	_GDIPlus_GraphicsDrawImageRectRect($hImage_Result_Ctxt, $hImage, 0, 0, $ImageWidth, $ImageHeight, 0, 0, $ImageWidth, $ImageHeight, $hIA)
	_GDIPlus_ImageSaveToFile($hImage_Result, $iPathMask)

	_GDIPlus_GraphicsDispose($hImage_Result_Ctxt)
	_GDIPlus_BitmapDispose($hImage)
	_GDIPlus_BitmapDispose($hImage_Result)
	_GDIPlus_ImageAttributesDispose($hIA)
	_GDIPlus_Shutdown()

	FileCopy($iPathBlack_Source, $iPathBlack_TEMP, $FC_OVERWRITE + $FC_CREATEPATH)
	FileCopy($iPathWhite_Source, $iPathMask_TEMP, $FC_OVERWRITE + $FC_CREATEPATH)

	Dim $aPicParameters[9]
	$aPicParameters[0] = $iWidth
	$aPicParameters[1] = $iHeight
	$aPicParameters[2] = $iX
	$aPicParameters[3] = $iY
	_GDIPlus_Imaging($iPathBlack_TEMP, $aPicParameters, $ImageWidth, $ImageHeight)
	$aPicParameters[0] = $ImageWidth
	$aPicParameters[1] = $ImageHeight
	$aPicParameters[2] = 0
	$aPicParameters[3] = 0
	$aPicParameters[4] = $ImageWidth
	$aPicParameters[5] = 0
	$aPicParameters[6] = 0
	$aPicParameters[7] = $ImageHeight
	_GDIPlus_Imaging($iPathMask_TEMP, $aPicParameters, $ImageWidth, $ImageHeight)
	_GDIPlus_Merge($iPathMask_TEMP, $iPathBlack_TEMP)

	_GDIPlus_Startup()
	$hImage = _GDIPlus_BitmapCreateFromFile($iPathMask_TEMP)
	$hImage_Result = _GDIPlus_BitmapCreateFromScan0($ImageWidth, $ImageHeight)
	$hImage_Result_Ctxt = _GDIPlus_ImageGetGraphicsContext($hImage_Result)

	$hIA = _GDIPlus_ImageAttributesCreate()
	_GDIPlus_ImageAttributesSetRemapTable($hIA, 1, True, $aRemapTable)
	_GDIPlus_GraphicsDrawImageRectRect($hImage_Result_Ctxt, $hImage, 0, 0, $ImageWidth, $ImageHeight, 0, 0, $ImageWidth, $ImageHeight, $hIA)
	_GDIPlus_ImageSaveToFile($hImage_Result, $iPathIMask)

	_GDIPlus_GraphicsDispose($hImage_Result_Ctxt)
	_GDIPlus_BitmapDispose($hImage)
	_GDIPlus_BitmapDispose($hImage_Result)
	_GDIPlus_ImageAttributesDispose($hIA)
	_GDIPlus_Shutdown()
	FileDelete($iPathBlack_TEMP)
	FileDelete($iPathWhite_TEMP)
	FileDelete($iPathMask_TEMP)
EndFunc   ;==>_GDIPlus_CreateMask

; #FUNCTION# ===================================================================================================
; Name...........: _GDIPlus_ImageAttributesSetRemapTable
; Description ...: Put a Color in transparent
; Syntax.........: _GDIPlus_ImageAttributesSetRemapTable($hImageAttributes, $iColorAdjustType = 0, $fEnable = False, $aColorMap = 0)
; Parameters ....: $hImageAttributes	-
;                  $iColorAdjustType	-
;                  $fEnable				-
;                  $aColorMap			-
; Return values .: Return
; Author ........:
; Modified.......:
; Remarks .......:
; Related .......:
; Link ..........;
; Example .......; https://www.autoitscript.com/forum/topic/165975-bmp-to-png-with-transparent-color/
Func _GDIPlus_ImageAttributesSetRemapTable($hImageAttributes, $iColorAdjustType = 0, $fEnable = False, $aColorMap = 0)
	Local $iI, $iCount, $tColorMap, $aResult
	If IsArray($aColorMap) And UBound($aColorMap) > 1 Then
		$iCount = $aColorMap[0][0]
		$tColorMap = DllStructCreate("uint ColorMap[" & $iCount * 2 & "]")
		For $iI = 1 To $iCount
			$tColorMap.ColorMap((2 * $iI - 1)) = $aColorMap[$iI][0]
			$tColorMap.ColorMap((2 * $iI)) = $aColorMap[$iI][1]
		Next
		$aResult = DllCall($__g_hGDIPDll, "int", "GdipSetImageAttributesRemapTable", "handle", $hImageAttributes, "int", $iColorAdjustType, "int", $fEnable, "int", $iCount, "struct*", $tColorMap)
		If @error Then Return SetError(@error, @extended, False)
		If $aResult[0] Then Return SetError(10, $aResult[0], False)
		Return True
	EndIf
	Return SetError(11, 0, False)
EndFunc   ;==>_GDIPlus_ImageAttributesSetRemapTable
#EndRegion Not Used Function
