; #INDEX# =======================================================================================================================
; Title .........: ShowOriginalLine
; Module ........: Main
; Author ........: FireFox and João Carlos (JScript)
; Support .......:
; Version .......: 0.12.2112.2600
; AutoIt Version.: 3.3.8.1++
; Language ......: ->
; Description ...: Show non compiled line number!
; Free Software .: Redistribute and change under these terms:
;               This program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License
;       as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
;
;               This program is distributed in the hope that it will be useful, but WITHOUT ANY WARRANTY; without even the implied warranty
;       of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the GNU General Public License for more details.
;
;               You should have received a copy of the GNU General Public License along with this program.
;               If not, see <http://www.gnu.org/licenses/>.
; ===============================================================================================================================

#region AutoIt3Wrapper directives section
;** AUT2EXE settings
#AutoIt3Wrapper_Icon=.\Resources\Icon\Icon1.ico							;Filename of the Ico file to use
#AutoIt3Wrapper_OutFile=ShowOriginalLine.exe							;Target exe/a3x filename.
#AutoIt3Wrapper_Compression=0											;Compression parameter 0-4  0=Low 2=normal 4=High. Default=2
#AutoIt3Wrapper_UseUpx=n												;(Y/N) Compress output program.  Default=Y
#AutoIt3Wrapper_UseX64=n
; ================================================================================================================================================
;** Target program Resource info
#AutoIt3Wrapper_Res_Comment=This program is distributed in the hope that it will be useful, but WITHOUT ANY WARRANTY ;Comment field
#AutoIt3Wrapper_Res_Description=Show original line number in AutoItErrorTrap.	;Description field
#AutoIt3Wrapper_Res_LegalCopyright=(C) FireFox and João Carlos (JScript)		;Copyright field
#AutoIt3Wrapper_Res_Fileversion=0.11.1512.2600							;File Version
;#AutoIt3Wrapper_Res_Language=1046										;Resource Language code . default 2057=English (United Kingdom)
#AutoIt3Wrapper_Res_ProductVersion=0.11.1512.2600						;Product Version. Default is the AutoIt3 version used.
#AutoIt3Wrapper_Res_Field=Compiler version|%AutoItVer% - x86
;#AutoIt3Wrapper_Res_Field=CompanyName|
#AutoIt3Wrapper_Res_Field=InternalName|ShowOriginalLine.exe
#AutoIt3Wrapper_Res_Field=LegalTrademarks|Some items owned by Microsoft Corp., The others belong to their respective owners. - All rights reserved.
#AutoIt3Wrapper_Res_Field=ProductName|AutoIt v3 Error Trap!
#AutoIt3Wrapper_Res_Field=OriginalFilename|ShowOriginalLine.exe
#AutoIt3Wrapper_Res_Field=DateBuild|%longdate%
; ================================================================================================================================================
; AU3Check settings
;#AutoIt3Wrapper_Run_AU3Check=							;(Y/N) Run au3check before compilation. Default=Y
#AutoIt3Wrapper_Au3Check_Parameters=-d -w 1 -w 2 -w 3 -w- 4 -w 5 -w 6 -w- 7
;#AutoIt3Wrapper_AU3Check_Stop_OnWarning=				;(Y/N) N=Continue on Warnings.(Default) Y=Always stop on Warnings
; Obfuscator =====================================================================================================================================
#AutoIt3Wrapper_Run_Obfuscator=y                 		;(Y/N) Run Obfuscator before compilation. default=N
#Obfuscator_Parameters=/striponly
; ================================================================================================================================================
; RUN BEFORE AND AFTER definitions
#AutoIt3Wrapper_Run_After="%scitedir%\AutoIt3Wrapper\ResHacker.exe" -delete %out%, %out%, MENU,,
#AutoIt3Wrapper_Run_After="%scitedir%\AutoIt3Wrapper\ResHacker.exe" -delete %out%, %out%, DIALOG,,
#AutoIt3Wrapper_Run_After="%scitedir%\AutoIt3Wrapper\ResHacker.exe" -delete %out%, %out%, ICONGROUP,162,
#AutoIt3Wrapper_Run_After="%scitedir%\AutoIt3Wrapper\ResHacker.exe" -delete %out%, %out%, ICONGROUP,164,
#AutoIt3Wrapper_Run_After="%scitedir%\AutoIt3Wrapper\ResHacker.exe" -delete %out%, %out%, ICONGROUP,169,
#AutoIt3Wrapper_Run_After="%autoitdir%\Aut2Exe\upx.exe" .\ShowOriginalLine.exe
; ================================================================================================================================================
#endregion AutoIt3Wrapper directives section
Opt("ExpandVarStrings", 1) ;0=don't expand, 1=do expand

#include <File.au3>
#include <String.au3>

#Tidy_Off
; #VARIABLES# ===================================================================================================================
Local $sScriptPath
Local $aLines
Local $iLine = 1
Local $sLineStripWS
Local $sInclude = ""
Local $sComment = 0
Global $sOutPut = ""
; Cmd line
Global $iSkipAllVars = 0, $iSkipGlobalVars = 0, $iSkipLocalVars = 0, $iOnlyFuncNames = 0, $iShowLinePreview = 1, $iPrevLenght = 60
;----> Word list to skip line, fell free to add more!
Global $asWordList = "#|;|Case Else|Else|End|Continue|Exit|Do|Next|WEnd|Exit|Break|Opt|AutoIt|BlockInput|OnAutoItExit|Sleep|Send|Set"
$asWordList = StringSplit($asWordList, "|")
;<----
; ================================================================================================================================
#Tidy_On

Select
	Case Not $CmdLine[0]
		$sScriptPath = FileOpenDialog("Select an au3 file...", @ScriptDir, "AutoIt3 v3 Script (*.au3)", 3)
		If @error Then Exit 0

	Case Else
		$sScriptPath = $CmdLineRaw
		If Not FileExists($sScriptPath) Then Exit -1
EndSelect

If Not _FileReadToArray($sScriptPath, $aLines) Then
	If Not $CmdLine[0] Then Exit -2
	MsgBox(4096, "ShowOriginalLine", "Error reading file to Array!" & @CRLF & "Error number: " & @error)
	Exit
EndIf

; Search for local includes and #ShowOriginalLine_Param!
Local $asSplit, $aiSplit
While $iLine <= $aLines[0]
	$sLineStripWS = StringStripWS($aLines[$iLine], 8)

	If StringInStr($sLineStripWS, "#ShowLine_Off", 0, 1, 1, 13) Then
		While $iLine <= $aLines[0]
			If StringInStr($sLineStripWS, "#ShowLine_On", 0, 1, 1, 12) Then
				ExitLoop
			EndIf
			$iLine += 1
			$sLineStripWS = StringStripWS($aLines[$iLine], 3)
		WEnd
		$iLine += 1
		ContinueLoop
	EndIf

	If StringInStr($sLineStripWS, "#ShowOriginalLine_Param", 0, 1, 1, 23) Then
		$asSplit = StringSplit(StringLower($sLineStripWS), "/")
		For $i = 2 To $asSplit[0]
			Switch $asSplit[$i]
				Case "sv", "skipallvars"
					$iSkipAllVars = 1
				Case "sg", "skipglobalvars"
					$iSkipGlobalVars = 1
				Case "sl", "skiplocalvars"
					$iSkipLocalVars = 1
				Case "ofn", "onlyfuncnames"
					$iOnlyFuncNames = 1
				Case "slp", "skiplinepreview"
					$iShowLinePreview = 0
				Case Else
					$aiSplit = StringSplit($asSplit[$i], "=")
					If Not @error Then
						For $j = 1 To $aiSplit[0]
							Switch $aiSplit[$j]
								Case "lpl", "linepreviewlenght"
									$iPrevLenght = Number($aiSplit[$j + 1])
							EndSwitch
						Next
					EndIf
			EndSwitch
		Next
		ExitLoop
	EndIf

	If StringInStr($sLineStripWS, '#include"', 0, 1, 1, 9) Then
		$sInclude = _StringBetween($sLineStripWS, '"', '"')
		If Not @error Then
			$sInclude = $sInclude[0]
			If Not StringInStr($sInclude, "_AutoItErrorTrap.au3") Then
				If StringInStr($sInclude, ".\") Then
					$sInclude = StringReplace($sInclude, ".\", @ScriptDir & "\")
				EndIf
				If FileExists($sInclude) Then
					$sOutPut = "$__iLineNumber=0" & @CRLF
					_AddLineIndex($sInclude)
				EndIf
			EndIf
		EndIf
	EndIf
	$iLine += 1
WEnd

$sOutPut = "Global $__iLineNumber=0" & @CRLF
_AddLineIndex($sScriptPath, $aLines)

; #FUNCTION# ====================================================================================================================
; Name ..........: _AddLineIndex
; Description ...:
; Syntax ........: _AddLineIndex()
; Parameters ....:
; Return values .: None
; Author ........: JScript
; Modified ......:
; Remarks .......:  Detecting AutoIt statement continuation by @Varian
;					Link: http://www.autoitscript.com/forum/topic/145482-question-about-regex/#entry1028087
; Related .......:
; Link ..........:
; Example .......: No
; ===============================================================================================================================
Func _AddLineIndex($sScriptPath, $aLines = 0)
	Local $iLine = 1, $iPrevious = 0, $sCurrentLine, $sLineStripWS, $sIndent = "", $sSelect = 0, $sSwitch = 0
	Local $fMainFile = True, $hFileOpen, $hFileWrite, $iError = 0, $sModule = "•", $sPrgName, $sSpace

	If Not IsArray($aLines) Then
		If Not _FileReadToArray($sScriptPath, $aLines) Then
			$iError = @error
			If Not $CmdLine[0] Then Return SetError(-2, 0, 0)
			MsgBox(4096, "ShowOriginalLine", "Error reading file to Array!" & @CRLF & "Error number: " & $iError & @CRLF & "File: " & $sScriptPath)
			Return SetError(-2, 0, 0)
		EndIf
		$sPrgName = _PathSplitRegEx($sScriptPath)
		If @error Then
			$sModule = "•$sScriptPath$"
		Else
			$sPrgName = $sPrgName[3] & $sPrgName[4]
			$sModule = "•$sPrgName$"
		EndIf
		ConsoleWrite($sModule & @CRLF)
		$fMainFile = False
	EndIf

	Select
		Case StringInStr($aLines[1], "$__iLineNumber")
			$iLine = 2
			$sOutPut = ""
			While $iLine <= $aLines[0]
				$sCurrentLine = $aLines[$iLine]
				$sLineStripWS = StringStripWS($aLines[$iLine], 3)

				If Not $sLineStripWS Then
					$sOutPut &= $sCurrentLine & @CRLF
					$iLine += 1
					ContinueLoop
				EndIf

				If StringMid($sLineStripWS, 1, 14) = "$__iLineNumber" Then
					$iLine += 1
					ContinueLoop
				EndIf

				$sOutPut &= $sCurrentLine & @CRLF
				$iLine += 1
			WEnd

		Case Else
			; backup!!!
			FileCopy($sScriptPath, $sScriptPath & ".Backup.au3")

			If $iOnlyFuncNames Then
				$sOutPut &= "$__iLineNumber=0" & " & '$sModule$'" & @CRLF
			EndIf

			$iLine = 1
			While $iLine <= $aLines[0]
				$sCurrentLine = $aLines[$iLine]
				$sLineStripWS = StringStripWS($sCurrentLine, 3)

				If $aLines[$iLine] = "" Then
					$sOutPut &= $sCurrentLine & @CRLF
					$iLine += 1
					ContinueLoop
				EndIf

				If _SkipLineByWord($sLineStripWS) Then
					$sOutPut &= $sCurrentLine & @CRLF
					$iLine += 1
					ContinueLoop
				EndIf

				$sIndent = ""
				$sSpace = StringLeft($sCurrentLine, StringLen($sIndent) + 1)
				While StringIsSpace($sSpace)
					$sIndent = $sSpace
					$sSpace = StringLeft($sCurrentLine, StringLen($sIndent) + 1)
				WEnd

				If $iOnlyFuncNames Then
					$sOutPut &= $sCurrentLine & @CRLF
					If StringInStr($sLineStripWS, "Func", 0, 1, 1, 4) Then
						$sOutPut &= $sIndent & "$__iLineNumber=" & $iLine
						If $iShowLinePreview Then
							$sOutPut &= " & ' - " & _StringTruncate(StringReplace($sLineStripWS, "'", '"'), $iPrevLenght) & "$sModule$'" & @CRLF
						Else
							$sOutPut &= " & '$sModule$'" & @CRLF
						EndIf
					EndIf
					$iLine += 1
					ContinueLoop
				EndIf

				; Skip comment group by: #comments-start or #cs
				If StringRegExp($sLineStripWS, "\A(?i)#cs\b") Or StringRegExp($sLineStripWS, "\A(?i)#comments-start\b") Then
					$iLine += 1
					While $iLine <= $aLines[0]
						$sCurrentLine = $aLines[$iLine]
						$sLineStripWS = StringStripWS($sCurrentLine, 3)
						If StringRegExp($sLineStripWS, "\A(?i)#ce\b") Or StringRegExp($sLineStripWS, "\A(?i)#comments-end\b") Then
							$sOutPut &= $sCurrentLine & @CRLF
							ExitLoop
						EndIf
						$sOutPut &= $sCurrentLine & @CRLF
						$iLine += 1
					WEnd
					ContinueLoop
				EndIf

				If StringInStr($sLineStripWS, "#ShowLine_Off", 0, 1, 1, 13) Then
					$iLine += 1
					While $iLine <= $aLines[0]
						$sCurrentLine = $aLines[$iLine]
						$sLineStripWS = StringStripWS($sCurrentLine, 3)
						If StringInStr($sLineStripWS, "#ShowLine_On", 0, 1, 1, 12) Then
							$sOutPut &= $sCurrentLine & @CRLF
							ExitLoop
						EndIf
						$sOutPut &= $sCurrentLine & @CRLF
						$iLine += 1
					WEnd
					ContinueLoop
				EndIf

				; #ShowOriginalLine_Param
				Select
					Case $iSkipAllVars
						If StringInStr($sLineStripWS, "Global", 0, 1, 1, 6) Or StringInStr($sLineStripWS, "Local", 0, 1, 1, 5) Then
							$sOutPut &= $sCurrentLine & @CRLF
							$iLine += 1
							ContinueLoop
						EndIf
					Case $iSkipGlobalVars
						If StringInStr($sLineStripWS, "Global", 0, 1, 1, 6) Then
							$sOutPut &= $sCurrentLine & @CRLF
							$iLine += 1
							ContinueLoop
						EndIf
					Case $iSkipLocalVars
						If StringInStr($sLineStripWS, "Local", 0, 1, 1, 5) Then
							$sOutPut &= $sCurrentLine & @CRLF
							$iLine += 1
							ContinueLoop
						EndIf
				EndSelect

				;Select|Switch
				$sSelect = StringInStr($sLineStripWS, "Select", 0, 1, 1, 6)
				$sSwitch = StringInStr($sLineStripWS, "Switch", 0, 1, 1, 6)
				If $sSelect Or $sSwitch Then
					If $sSwitch Then
						$sOutPut &= $sIndent & "$__iLineNumber=" & $iLine
						If $iShowLinePreview Then
							$sOutPut &= " & ' - " & _StringTruncate(StringReplace($sLineStripWS, "'", '"'), $iPrevLenght) & "$sModule$'" & @CRLF
						Else
							$sOutPut &= " & '$sModule$'" & @CRLF
						EndIf
					EndIf

					$iPrevious = $iLine ; save
					$iLine += 1
					While $iLine <= $aLines[0]
						$sLineStripWS = StringStripWS($aLines[$iLine], 3)
						If Not StringInStr($sLineStripWS, "Case", 0, 1, 1, 4) Then
							$iLine += 1
							ContinueLoop
						EndIf
						ExitLoop
					WEnd

					$sOutPut &= $sIndent & "$__iLineNumber=" & $iLine
					If $iShowLinePreview Then
						$sOutPut &= " & ' - " & _StringTruncate(StringReplace($sLineStripWS, "'", '"'), $iPrevLenght) & "$sModule$'" & @CRLF
					Else
						$sOutPut &= " & '$sModule$'" & @CRLF
					EndIf

					$sOutPut &= $sCurrentLine & @CRLF

					$iLine = $iPrevious ; restore
					$iLine += 1
					ContinueLoop
				EndIf

				If $iPrevious Then
					$iPrevious = 0
				Else
					$sOutPut &= $sIndent & "$__iLineNumber=" & $iLine
					If $iShowLinePreview Then
						$sOutPut &= " & ' - " & _StringTruncate(StringReplace($sLineStripWS, "'", '"'), $iPrevLenght) & "$sModule$'" & @CRLF
					Else
						$sOutPut &= " & '$sModule$'" & @CRLF
					EndIf
				EndIf
				$sOutPut &= $sCurrentLine & @CRLF

				;----> Detecting AutoIt statement continuation
				; by @Varian at http://www.autoitscript.com/forum/topic/145482-question-about-regex/#entry1028087
				If StringRegExp($sCurrentLine, "(?m)(^.*_)(?:\s*$|\s*;.*\s*$)", 0) Then
					$iLine += 1
					While $iLine <= $aLines[0]
						$sCurrentLine = $aLines[$iLine]
						If Not StringRegExp($sCurrentLine, "(?m)(^.*_)(?:\s*$|\s*;.*\s*$)", 0) Then
							$sOutPut &= $sCurrentLine & @CRLF
							ExitLoop
						EndIf
						$sOutPut &= $sCurrentLine & @CRLF
						$iLine += 1
					WEnd
				EndIf
				;<----

				$iLine += 1
			WEnd
	EndSelect

	$hFileOpen = FileOpen($sScriptPath, 2)
	If $hFileOpen = -1 Then
		MsgBox(4096, "ShowOriginalLine", "Error: Unable to open file!" & @CRLF & "File: " & $sScriptPath)
		Return SetError(-3, 0, 0)
	EndIf
	$hFileWrite = FileWrite($hFileOpen, $sOutPut)
	FileClose($hFileOpen)

	If $hFileWrite Then
		If Not $CmdLine[0] And $fMainFile Then MsgBox(4096, "ShowOriginalLine", "Info: The file was successfully modified!" & @CRLF & @CRLF & _
				"It was made a backup using the name: " & @CRLF & $sScriptPath & ".Backup.au3")
	Else
		If Not $CmdLine[0] Then MsgBox(4096, "ShowOriginalLine", "Error: The file not opened in writemode or file is read only!" & @CRLF & "File: " & $sScriptPath)
		Return SetError(-3, 0, 0)
	EndIf
	Return SetError(0, 0, 1)
EndFunc   ;==>_AddLineIndex

; #FUNCTION# ====================================================================================================================
; Name ..........: _SkipLineByWord
; Description ...:
; Syntax ........: _SkipLineByWord($sLine)
; Parameters ....: $sLine               - A string value.
; Return values .: None
; Author ........: JScript
; Modified ......:
; Remarks .......:
; Related .......:
; Link ..........:
; Example .......: No
; ===============================================================================================================================
Func _SkipLineByWord($sLine)
	Local $ilen

	For $i = 1 To $asWordList[0]
		$ilen = StringLen($asWordList[$i])
		If StringInStr($sLine, $asWordList[$i], 0, 1, 1, $ilen) Then
			Return 1
		EndIf
	Next
	Return 0
EndFunc   ;==>_SkipLineByWord

; #FUNCTION# ====================================================================================================================
; Name ..........: _StringTruncate
; Description ...:
; Syntax ........: _StringTruncate($sString, $iValue)
; Parameters ....: $sString             - A string value.
;                  $iValue              - An integer value.
; Return values .: None
; Author ........: JScript
; Modified ......:
; Remarks .......:
; Related .......:
; Link ..........:
; Example .......: No
; ===============================================================================================================================
Func _StringTruncate($sString, $iValue)
	Local $sRet

	$sRet = StringLeft($sString, $iValue)
	If StringLen($sString) > $iValue Then $sRet &= " ..."
	Return $sRet
EndFunc   ;==>_StringTruncate

; #FUNCTION# ====================================================================================================================
; Name...........: _PathSplitRegEx
; Description ...: Splits a path into the drive, directory, file name and file extension parts. An empty string is set if a part is missing.
; Syntax.........: _PathSplitRegEx($sPath)
; Parameters ....: $sPath - The path to be split (Can contain a UNC server or drive letter)
; Return values .: Success - Returns an array with 5 elements where 0 = original path, 1 = drive, 2 = directory, 3 = filename, 4 = extension
; Author ........: Gibbo
; Modified.......:
; Remarks .......: This function does not take a command line string. It works on paths, not paths with arguments.
;                This differs from _PathSplit in that the drive letter or servershare retains the "" not the path
;                RegEx Built using examples from "Regular Expressions Cookbook (O’Reilly Media, 2009)"
; Related .......: _PathSplit, _PathFull, _PathMake
; Link ..........:
; Example .......: Yes
; ===============================================================================================================================
Func _PathSplitRegEx($sPath)
	If $sPath = "" Then Return SetError(1, 0, "")
	Local Const $rPathSplit = '^(?i)([a-z]:|\\\\[a-z0-9_.$]+\\[a-z0-9_.]+\$?)?(\\(?:[^\\/:*?"<>|\r\n]+\\)*)?([^\\/:*?"<>|\r\n.]*)((?:\.[^.\\/:*?"<>|\r\n]+)?)$'
	Local $aResult = StringRegExp($sPath, $rPathSplit, 2)

	Switch @error
		Case 0
			Return $aResult
		Case 1
			Return SetError(2, 0, "")
		Case 2
			;This should never happen!
	EndSwitch
EndFunc   ;==>_PathSplitRegEx