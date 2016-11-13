Global $__iLineNumber=0
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
$__iLineNumber=68 & ' - Local $sScriptPath•'
Local $sScriptPath
$__iLineNumber=69 & ' - Local $aLines•'
Local $aLines
$__iLineNumber=70 & ' - Local $iLine = 1•'
Local $iLine = 1
$__iLineNumber=71 & ' - Local $sLineStripWS•'
Local $sLineStripWS
$__iLineNumber=72 & ' - Local $sInclude = ""•'
Local $sInclude = ""
$__iLineNumber=73 & ' - Local $sComment = 0•'
Local $sComment = 0
$__iLineNumber=74 & ' - Global $sOutPut = ""•'
Global $sOutPut = ""
; Cmd line
$__iLineNumber=76 & ' - Global $iSkipAllVars = 0, $iSkipGlobalVars = 0, $iSkipLocalV ...•'
Global $iSkipAllVars = 0, $iSkipGlobalVars = 0, $iSkipLocalVars = 0, $iOnlyFuncNames = 0, $iShowLinePreview = 1, $iPrevLenght = 60
;----> Word list to skip line, fell free to add more!
$__iLineNumber=78 & ' - Global $asWordList = "#|;|Case Else|Else|End|Continue|Exit|D ...•'
Global $asWordList = "#|;|Case Else|Else|End|Continue|Exit|Do|Next|WEnd|Exit|Break|Opt|AutoIt|BlockInput|OnAutoItExit|Sleep|Send|Set"
$__iLineNumber=79 & ' - $asWordList = StringSplit($asWordList, "|")•'
$asWordList = StringSplit($asWordList, "|")
;<----
; ================================================================================================================================
#Tidy_On

$__iLineNumber=85 & ' - Case Not $CmdLine[0]•'
Select
	Case Not $CmdLine[0]
		$__iLineNumber=86 & ' - $sScriptPath = FileOpenDialog("Select an au3 file...", @Scri ...•'
		$sScriptPath = FileOpenDialog("Select an au3 file...", @ScriptDir, "AutoIt3 v3 Script (*.au3)", 3)
		$__iLineNumber=87 & ' - If @error Then Exit 0•'
		If @error Then Exit 0

	Case Else
		$__iLineNumber=90 & ' - $sScriptPath = $CmdLineRaw•'
		$sScriptPath = $CmdLineRaw
		$__iLineNumber=91 & ' - If Not FileExists($sScriptPath) Then Exit -1•'
		If Not FileExists($sScriptPath) Then Exit -1
EndSelect

$__iLineNumber=94 & ' - If Not _FileReadToArray($sScriptPath, $aLines) Then•'
If Not _FileReadToArray($sScriptPath, $aLines) Then
	$__iLineNumber=95 & ' - If Not $CmdLine[0] Then Exit -2•'
	If Not $CmdLine[0] Then Exit -2
	$__iLineNumber=96 & ' - MsgBox(4096, "ShowOriginalLine", "Error reading file to Arra ...•'
	MsgBox(4096, "ShowOriginalLine", "Error reading file to Array!" & @CRLF & "Error number: " & @error)
	Exit
EndIf

; Search for local includes and #ShowOriginalLine_Param!
$__iLineNumber=101 & ' - Local $asSplit, $aiSplit•'
Local $asSplit, $aiSplit
$__iLineNumber=102 & ' - While $iLine <= $aLines[0]•'
While $iLine <= $aLines[0]
	$__iLineNumber=103 & ' - $sLineStripWS = StringStripWS($aLines[$iLine], 8)•'
	$sLineStripWS = StringStripWS($aLines[$iLine], 8)

	$__iLineNumber=105 & ' - If StringInStr($sLineStripWS, "#ShowLine_Off", 0, 1, 1, 13)  ...•'
	If StringInStr($sLineStripWS, "#ShowLine_Off", 0, 1, 1, 13) Then
		$__iLineNumber=106 & ' - While $iLine <= $aLines[0]•'
		While $iLine <= $aLines[0]
			$__iLineNumber=107 & ' - If StringInStr($sLineStripWS, "#ShowLine_On", 0, 1, 1, 12) T ...•'
			If StringInStr($sLineStripWS, "#ShowLine_On", 0, 1, 1, 12) Then
				ExitLoop
			EndIf
			$__iLineNumber=110 & ' - $iLine += 1•'
			$iLine += 1
			$__iLineNumber=111 & ' - $sLineStripWS = StringStripWS($aLines[$iLine], 3)•'
			$sLineStripWS = StringStripWS($aLines[$iLine], 3)
		WEnd
		$__iLineNumber=113 & ' - $iLine += 1•'
		$iLine += 1
		ContinueLoop
	EndIf

	$__iLineNumber=117 & ' - If StringInStr($sLineStripWS, "#ShowOriginalLine_Param", 0,  ...•'
	If StringInStr($sLineStripWS, "#ShowOriginalLine_Param", 0, 1, 1, 23) Then
		$__iLineNumber=118 & ' - $asSplit = StringSplit(StringLower($sLineStripWS), "/")•'
		$asSplit = StringSplit(StringLower($sLineStripWS), "/")
		$__iLineNumber=119 & ' - For $i = 2 To $asSplit[0]•'
		For $i = 2 To $asSplit[0]
			$__iLineNumber=120 & ' - Switch $asSplit[$i]•'
			$__iLineNumber=121 & ' - Case "sv", "skipallvars"•'
			Switch $asSplit[$i]
				Case "sv", "skipallvars"
					$__iLineNumber=122 & ' - $iSkipAllVars = 1•'
					$iSkipAllVars = 1
				$__iLineNumber=123 & ' - Case "sg", "skipglobalvars"•'
				Case "sg", "skipglobalvars"
					$__iLineNumber=124 & ' - $iSkipGlobalVars = 1•'
					$iSkipGlobalVars = 1
				$__iLineNumber=125 & ' - Case "sl", "skiplocalvars"•'
				Case "sl", "skiplocalvars"
					$__iLineNumber=126 & ' - $iSkipLocalVars = 1•'
					$iSkipLocalVars = 1
				$__iLineNumber=127 & ' - Case "ofn", "onlyfuncnames"•'
				Case "ofn", "onlyfuncnames"
					$__iLineNumber=128 & ' - $iOnlyFuncNames = 1•'
					$iOnlyFuncNames = 1
				$__iLineNumber=129 & ' - Case "slp", "skiplinepreview"•'
				Case "slp", "skiplinepreview"
					$__iLineNumber=130 & ' - $iShowLinePreview = 0•'
					$iShowLinePreview = 0
				Case Else
					$__iLineNumber=132 & ' - $aiSplit = StringSplit($asSplit[$i], "=")•'
					$aiSplit = StringSplit($asSplit[$i], "=")
					$__iLineNumber=133 & ' - If Not @error Then•'
					If Not @error Then
						$__iLineNumber=134 & ' - For $j = 1 To $aiSplit[0]•'
						For $j = 1 To $aiSplit[0]
							$__iLineNumber=135 & ' - Switch $aiSplit[$j]•'
							$__iLineNumber=136 & ' - Case "lpl", "linepreviewlenght"•'
							Switch $aiSplit[$j]
								Case "lpl", "linepreviewlenght"
									$__iLineNumber=137 & ' - $iPrevLenght = Number($aiSplit[$j + 1])•'
									$iPrevLenght = Number($aiSplit[$j + 1])
							EndSwitch
						Next
					EndIf
			EndSwitch
		Next
		ExitLoop
	EndIf

	$__iLineNumber=146 & ' - If StringInStr($sLineStripWS, "#include"", 0, 1, 1, 9) Then•'
	If StringInStr($sLineStripWS, '#include"', 0, 1, 1, 9) Then
		$__iLineNumber=147 & ' - $sInclude = _StringBetween($sLineStripWS, """, """)•'
		$sInclude = _StringBetween($sLineStripWS, '"', '"')
		$__iLineNumber=148 & ' - If Not @error Then•'
		If Not @error Then
			$__iLineNumber=149 & ' - $sInclude = $sInclude[0]•'
			$sInclude = $sInclude[0]
			$__iLineNumber=150 & ' - If Not StringInStr($sInclude, "_AutoItErrorTrap.au3") Then•'
			If Not StringInStr($sInclude, "_AutoItErrorTrap.au3") Then
				$__iLineNumber=151 & ' - If StringInStr($sInclude, ".\") Then•'
				If StringInStr($sInclude, ".\") Then
					$__iLineNumber=152 & ' - $sInclude = StringReplace($sInclude, ".\", @ScriptDir & "\")•'
					$sInclude = StringReplace($sInclude, ".\", @ScriptDir & "\")
				EndIf
				$__iLineNumber=154 & ' - If FileExists($sInclude) Then•'
				If FileExists($sInclude) Then
					$__iLineNumber=155 & ' - $sOutPut = "$__iLineNumber=0" & @CRLF•'
					$sOutPut = "$__iLineNumber=0" & @CRLF
					$__iLineNumber=156 & ' - _AddLineIndex($sInclude)•'
					_AddLineIndex($sInclude)
				EndIf
			EndIf
		EndIf
	EndIf
	$__iLineNumber=161 & ' - $iLine += 1•'
	$iLine += 1
WEnd

$__iLineNumber=164 & ' - $sOutPut = "Global $__iLineNumber=0" & @CRLF•'
$sOutPut = "Global $__iLineNumber=0" & @CRLF
$__iLineNumber=165 & ' - _AddLineIndex($sScriptPath, $aLines)•'
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
$__iLineNumber=181 & ' - Func _AddLineIndex($sScriptPath, $aLines = 0)•'
Func _AddLineIndex($sScriptPath, $aLines = 0)
	$__iLineNumber=182 & ' - Local $iLine = 1, $iPrevious = 0, $sCurrentLine, $sLineStrip ...•'
	Local $iLine = 1, $iPrevious = 0, $sCurrentLine, $sLineStripWS, $sIndent = "", $sSelect = 0, $sSwitch = 0
	$__iLineNumber=183 & ' - Local $fMainFile = True, $hFileOpen, $hFileWrite, $iError =  ...•'
	Local $fMainFile = True, $hFileOpen, $hFileWrite, $iError = 0, $sModule = "•", $sPrgName, $sSpace

	$__iLineNumber=185 & ' - If Not IsArray($aLines) Then•'
	If Not IsArray($aLines) Then
		$__iLineNumber=186 & ' - If Not _FileReadToArray($sScriptPath, $aLines) Then•'
		If Not _FileReadToArray($sScriptPath, $aLines) Then
			$__iLineNumber=187 & ' - $iError = @error•'
			$iError = @error
			$__iLineNumber=188 & ' - If Not $CmdLine[0] Then Return SetError(-2, 0, 0)•'
			If Not $CmdLine[0] Then Return SetError(-2, 0, 0)
			$__iLineNumber=189 & ' - MsgBox(4096, "ShowOriginalLine", "Error reading file to Arra ...•'
			MsgBox(4096, "ShowOriginalLine", "Error reading file to Array!" & @CRLF & "Error number: " & $iError & @CRLF & "File: " & $sScriptPath)
			$__iLineNumber=190 & ' - Return SetError(-2, 0, 0)•'
			Return SetError(-2, 0, 0)
		EndIf
		$__iLineNumber=192 & ' - $sPrgName = _PathSplitRegEx($sScriptPath)•'
		$sPrgName = _PathSplitRegEx($sScriptPath)
		$__iLineNumber=193 & ' - If @error Then•'
		If @error Then
			$__iLineNumber=194 & ' - $sModule = "•$sScriptPath$"•'
			$sModule = "•C:\Developpement\Github\Universal-XML-Scraper2\Include\AutoitTrap\ShowOriginalLine.au3"
		Else
			$__iLineNumber=196 & ' - $sPrgName = $sPrgName[3] & $sPrgName[4]•'
			$sPrgName = $sPrgName[3] & $sPrgName[4]
			$__iLineNumber=197 & ' - $sModule = "•$sPrgName$"•'
			$sModule = "•"
		EndIf
		$__iLineNumber=199 & ' - ConsoleWrite($sModule & @CRLF)•'
		ConsoleWrite($sModule & @CRLF)
		$__iLineNumber=200 & ' - $fMainFile = False•'
		$fMainFile = False
	EndIf

	$__iLineNumber=204 & ' - Case StringInStr($aLines[1], "$__iLineNumber")•'
	Select
		Case StringInStr($aLines[1], "$__iLineNumber")
			$__iLineNumber=205 & ' - $iLine = 2•'
			$iLine = 2
			$__iLineNumber=206 & ' - $sOutPut = ""•'
			$sOutPut = ""
			$__iLineNumber=207 & ' - While $iLine <= $aLines[0]•'
			While $iLine <= $aLines[0]
				$__iLineNumber=208 & ' - $sCurrentLine = $aLines[$iLine]•'
				$sCurrentLine = $aLines[$iLine]
				$__iLineNumber=209 & ' - $sLineStripWS = StringStripWS($aLines[$iLine], 3)•'
				$sLineStripWS = StringStripWS($aLines[$iLine], 3)

				$__iLineNumber=211 & ' - If Not $sLineStripWS Then•'
				If Not $sLineStripWS Then
					$__iLineNumber=212 & ' - $sOutPut &= $sCurrentLine & @CRLF•'
					$sOutPut &= $sCurrentLine & @CRLF
					$__iLineNumber=213 & ' - $iLine += 1•'
					$iLine += 1
					ContinueLoop
				EndIf

				$__iLineNumber=217 & ' - If StringMid($sLineStripWS, 1, 14) = "$__iLineNumber" Then•'
				If StringMid($sLineStripWS, 1, 14) = "$__iLineNumber" Then
					$__iLineNumber=218 & ' - $iLine += 1•'
					$iLine += 1
					ContinueLoop
				EndIf

				$__iLineNumber=222 & ' - $sOutPut &= $sCurrentLine & @CRLF•'
				$sOutPut &= $sCurrentLine & @CRLF
				$__iLineNumber=223 & ' - $iLine += 1•'
				$iLine += 1
			WEnd

		Case Else
			; backup!!!
			$__iLineNumber=228 & ' - FileCopy($sScriptPath, $sScriptPath & ".Backup.au3")•'
			FileCopy($sScriptPath, $sScriptPath & ".Backup.au3")

			$__iLineNumber=230 & ' - If $iOnlyFuncNames Then•'
			If $iOnlyFuncNames Then
				$__iLineNumber=231 & ' - $sOutPut &= "$__iLineNumber=0" & " & "•"" & @CRLF•'
				$sOutPut &= "$__iLineNumber=0" & " & '•'" & @CRLF
			EndIf

			$__iLineNumber=234 & ' - $iLine = 1•'
			$iLine = 1
			$__iLineNumber=235 & ' - While $iLine <= $aLines[0]•'
			While $iLine <= $aLines[0]
				$__iLineNumber=236 & ' - $sCurrentLine = $aLines[$iLine]•'
				$sCurrentLine = $aLines[$iLine]
				$__iLineNumber=237 & ' - $sLineStripWS = StringStripWS($sCurrentLine, 3)•'
				$sLineStripWS = StringStripWS($sCurrentLine, 3)

				$__iLineNumber=239 & ' - If $aLines[$iLine] = "" Then•'
				If $aLines[$iLine] = "" Then
					$__iLineNumber=240 & ' - $sOutPut &= $sCurrentLine & @CRLF•'
					$sOutPut &= $sCurrentLine & @CRLF
					$__iLineNumber=241 & ' - $iLine += 1•'
					$iLine += 1
					ContinueLoop
				EndIf

				$__iLineNumber=245 & ' - If _SkipLineByWord($sLineStripWS) Then•'
				If _SkipLineByWord($sLineStripWS) Then
					$__iLineNumber=246 & ' - $sOutPut &= $sCurrentLine & @CRLF•'
					$sOutPut &= $sCurrentLine & @CRLF
					$__iLineNumber=247 & ' - $iLine += 1•'
					$iLine += 1
					ContinueLoop
				EndIf

				$__iLineNumber=251 & ' - $sIndent = ""•'
				$sIndent = ""
				$__iLineNumber=252 & ' - $sSpace = StringLeft($sCurrentLine, StringLen($sIndent) + 1)•'
				$sSpace = StringLeft($sCurrentLine, StringLen($sIndent) + 1)
				$__iLineNumber=253 & ' - While StringIsSpace($sSpace)•'
				While StringIsSpace($sSpace)
					$__iLineNumber=254 & ' - $sIndent = $sSpace•'
					$sIndent = $sSpace
					$__iLineNumber=255 & ' - $sSpace = StringLeft($sCurrentLine, StringLen($sIndent) + 1)•'
					$sSpace = StringLeft($sCurrentLine, StringLen($sIndent) + 1)
				WEnd

				$__iLineNumber=258 & ' - If $iOnlyFuncNames Then•'
				If $iOnlyFuncNames Then
					$__iLineNumber=259 & ' - $sOutPut &= $sCurrentLine & @CRLF•'
					$sOutPut &= $sCurrentLine & @CRLF
					$__iLineNumber=260 & ' - If StringInStr($sLineStripWS, "Func", 0, 1, 1, 4) Then•'
					If StringInStr($sLineStripWS, "Func", 0, 1, 1, 4) Then
						$__iLineNumber=261 & ' - $sOutPut &= $sIndent & "$__iLineNumber=" & $iLine•'
						$sOutPut &= $sIndent & "$__iLineNumber=" & $iLine
						$__iLineNumber=262 & ' - If $iShowLinePreview Then•'
						If $iShowLinePreview Then
							$__iLineNumber=263 & ' - $sOutPut &= " & " - " & _StringTruncate(StringReplace($sLine ...•'
							$sOutPut &= " & ' - " & _StringTruncate(StringReplace($sLineStripWS, "'", '"'), $iPrevLenght) & "$sModule$'" & @CRLF
						Else
							$__iLineNumber=265 & ' - $sOutPut &= " & "$sModule$"" & @CRLF•'
							$sOutPut &= " & '•'" & @CRLF
						EndIf
					EndIf
					$__iLineNumber=268 & ' - $iLine += 1•'
					$iLine += 1
					ContinueLoop
				EndIf

				; Skip comment group by: #comments-start or #cs
				$__iLineNumber=273 & ' - If StringRegExp($sLineStripWS, "\A(?i)#cs\b") Or StringRegEx ...•'
				If StringRegExp($sLineStripWS, "\A(?i)#cs\b") Or StringRegExp($sLineStripWS, "\A(?i)#comments-start\b") Then
					$__iLineNumber=274 & ' - $iLine += 1•'
					$iLine += 1
					$__iLineNumber=275 & ' - While $iLine <= $aLines[0]•'
					While $iLine <= $aLines[0]
						$__iLineNumber=276 & ' - $sCurrentLine = $aLines[$iLine]•'
						$sCurrentLine = $aLines[$iLine]
						$__iLineNumber=277 & ' - $sLineStripWS = StringStripWS($sCurrentLine, 3)•'
						$sLineStripWS = StringStripWS($sCurrentLine, 3)
						$__iLineNumber=278 & ' - If StringRegExp($sLineStripWS, "\A(?i)#ce\b") Or StringRegEx ...•'
						If StringRegExp($sLineStripWS, "\A(?i)#ce\b") Or StringRegExp($sLineStripWS, "\A(?i)#comments-end\b") Then
							$__iLineNumber=279 & ' - $sOutPut &= $sCurrentLine & @CRLF•'
							$sOutPut &= $sCurrentLine & @CRLF
							ExitLoop
						EndIf
						$__iLineNumber=282 & ' - $sOutPut &= $sCurrentLine & @CRLF•'
						$sOutPut &= $sCurrentLine & @CRLF
						$__iLineNumber=283 & ' - $iLine += 1•'
						$iLine += 1
					WEnd
					ContinueLoop
				EndIf

				$__iLineNumber=288 & ' - If StringInStr($sLineStripWS, "#ShowLine_Off", 0, 1, 1, 13)  ...•'
				If StringInStr($sLineStripWS, "#ShowLine_Off", 0, 1, 1, 13) Then
					$__iLineNumber=289 & ' - $iLine += 1•'
					$iLine += 1
					$__iLineNumber=290 & ' - While $iLine <= $aLines[0]•'
					While $iLine <= $aLines[0]
						$__iLineNumber=291 & ' - $sCurrentLine = $aLines[$iLine]•'
						$sCurrentLine = $aLines[$iLine]
						$__iLineNumber=292 & ' - $sLineStripWS = StringStripWS($sCurrentLine, 3)•'
						$sLineStripWS = StringStripWS($sCurrentLine, 3)
						$__iLineNumber=293 & ' - If StringInStr($sLineStripWS, "#ShowLine_On", 0, 1, 1, 12) T ...•'
						If StringInStr($sLineStripWS, "#ShowLine_On", 0, 1, 1, 12) Then
							$__iLineNumber=294 & ' - $sOutPut &= $sCurrentLine & @CRLF•'
							$sOutPut &= $sCurrentLine & @CRLF
							ExitLoop
						EndIf
						$__iLineNumber=297 & ' - $sOutPut &= $sCurrentLine & @CRLF•'
						$sOutPut &= $sCurrentLine & @CRLF
						$__iLineNumber=298 & ' - $iLine += 1•'
						$iLine += 1
					WEnd
					ContinueLoop
				EndIf

				; #ShowOriginalLine_Param
				$__iLineNumber=305 & ' - Case $iSkipAllVars•'
				Select
					Case $iSkipAllVars
						$__iLineNumber=306 & ' - If StringInStr($sLineStripWS, "Global", 0, 1, 1, 6) Or Strin ...•'
						If StringInStr($sLineStripWS, "Global", 0, 1, 1, 6) Or StringInStr($sLineStripWS, "Local", 0, 1, 1, 5) Then
							$__iLineNumber=307 & ' - $sOutPut &= $sCurrentLine & @CRLF•'
							$sOutPut &= $sCurrentLine & @CRLF
							$__iLineNumber=308 & ' - $iLine += 1•'
							$iLine += 1
							ContinueLoop
						EndIf
					$__iLineNumber=311 & ' - Case $iSkipGlobalVars•'
					Case $iSkipGlobalVars
						$__iLineNumber=312 & ' - If StringInStr($sLineStripWS, "Global", 0, 1, 1, 6) Then•'
						If StringInStr($sLineStripWS, "Global", 0, 1, 1, 6) Then
							$__iLineNumber=313 & ' - $sOutPut &= $sCurrentLine & @CRLF•'
							$sOutPut &= $sCurrentLine & @CRLF
							$__iLineNumber=314 & ' - $iLine += 1•'
							$iLine += 1
							ContinueLoop
						EndIf
					$__iLineNumber=317 & ' - Case $iSkipLocalVars•'
					Case $iSkipLocalVars
						$__iLineNumber=318 & ' - If StringInStr($sLineStripWS, "Local", 0, 1, 1, 5) Then•'
						If StringInStr($sLineStripWS, "Local", 0, 1, 1, 5) Then
							$__iLineNumber=319 & ' - $sOutPut &= $sCurrentLine & @CRLF•'
							$sOutPut &= $sCurrentLine & @CRLF
							$__iLineNumber=320 & ' - $iLine += 1•'
							$iLine += 1
							ContinueLoop
						EndIf
				EndSelect

				;Select|Switch
				$__iLineNumber=326 & ' - $sSelect = StringInStr($sLineStripWS, "Select", 0, 1, 1, 6)•'
				$sSelect = StringInStr($sLineStripWS, "Select", 0, 1, 1, 6)
				$__iLineNumber=327 & ' - $sSwitch = StringInStr($sLineStripWS, "Switch", 0, 1, 1, 6)•'
				$sSwitch = StringInStr($sLineStripWS, "Switch", 0, 1, 1, 6)
				$__iLineNumber=328 & ' - If $sSelect Or $sSwitch Then•'
				If $sSelect Or $sSwitch Then
					$__iLineNumber=329 & ' - If $sSwitch Then•'
					If $sSwitch Then
						$__iLineNumber=330 & ' - $sOutPut &= $sIndent & "$__iLineNumber=" & $iLine•'
						$sOutPut &= $sIndent & "$__iLineNumber=" & $iLine
						$__iLineNumber=331 & ' - If $iShowLinePreview Then•'
						If $iShowLinePreview Then
							$__iLineNumber=332 & ' - $sOutPut &= " & " - " & _StringTruncate(StringReplace($sLine ...•'
							$sOutPut &= " & ' - " & _StringTruncate(StringReplace($sLineStripWS, "'", '"'), $iPrevLenght) & "$sModule$'" & @CRLF
						Else
							$__iLineNumber=334 & ' - $sOutPut &= " & "•"" & @CRLF•'
							$sOutPut &= " & '$sModule$'" & @CRLF
						EndIf
					EndIf

					$__iLineNumber=338 & ' - $iPrevious = $iLine ; save•'
					$iPrevious = $iLine ; save
					$__iLineNumber=339 & ' - $iLine += 1•'
					$iLine += 1
					$__iLineNumber=340 & ' - While $iLine <= $aLines[0]•'
					While $iLine <= $aLines[0]
						$__iLineNumber=341 & ' - $sLineStripWS = StringStripWS($aLines[$iLine], 3)•'
						$sLineStripWS = StringStripWS($aLines[$iLine], 3)
						$__iLineNumber=342 & ' - If Not StringInStr($sLineStripWS, "Case", 0, 1, 1, 4) Then•'
						If Not StringInStr($sLineStripWS, "Case", 0, 1, 1, 4) Then
							$__iLineNumber=343 & ' - $iLine += 1•'
							$iLine += 1
							ContinueLoop
						EndIf
						ExitLoop
					WEnd

					$__iLineNumber=349 & ' - $sOutPut &= $sIndent & "$__iLineNumber=" & $iLine•'
					$sOutPut &= $sIndent & "$__iLineNumber=" & $iLine
					$__iLineNumber=350 & ' - If $iShowLinePreview Then•'
					If $iShowLinePreview Then
						$__iLineNumber=351 & ' - $sOutPut &= " & " - " & _StringTruncate(StringReplace($sLine ...•'
						$sOutPut &= " & ' - " & _StringTruncate(StringReplace($sLineStripWS, "'", '"'), $iPrevLenght) & "•'" & @CRLF
					Else
						$__iLineNumber=353 & ' - $sOutPut &= " & "$sModule$"" & @CRLF•'
						$sOutPut &= " & '$sModule$'" & @CRLF
					EndIf

					$__iLineNumber=356 & ' - $sOutPut &= $sCurrentLine & @CRLF•'
					$sOutPut &= $sCurrentLine & @CRLF

					$__iLineNumber=358 & ' - $iLine = $iPrevious ; restore•'
					$iLine = $iPrevious ; restore
					$__iLineNumber=359 & ' - $iLine += 1•'
					$iLine += 1
					ContinueLoop
				EndIf

				$__iLineNumber=363 & ' - If $iPrevious Then•'
				If $iPrevious Then
					$__iLineNumber=364 & ' - $iPrevious = 0•'
					$iPrevious = 0
				Else
					$__iLineNumber=366 & ' - $sOutPut &= $sIndent & "$__iLineNumber=" & $iLine•'
					$sOutPut &= $sIndent & "$__iLineNumber=" & $iLine
					$__iLineNumber=367 & ' - If $iShowLinePreview Then•'
					If $iShowLinePreview Then
						$__iLineNumber=368 & ' - $sOutPut &= " & " - " & _StringTruncate(StringReplace($sLine ...•'
						$sOutPut &= " & ' - " & _StringTruncate(StringReplace($sLineStripWS, "'", '"'), $iPrevLenght) & "•'" & @CRLF
					Else
						$__iLineNumber=370 & ' - $sOutPut &= " & "$sModule$"" & @CRLF•'
						$sOutPut &= " & '$sModule$'" & @CRLF
					EndIf
				EndIf
				$__iLineNumber=373 & ' - $sOutPut &= $sCurrentLine & @CRLF•'
				$sOutPut &= $sCurrentLine & @CRLF

				;----> Detecting AutoIt statement continuation
				; by @Varian at http://www.autoitscript.com/forum/topic/145482-question-about-regex/#entry1028087
				$__iLineNumber=377 & ' - If StringRegExp($sCurrentLine, "(?m)(^.*_)(?:\s*$|\s*;.*\s*$ ...•'
				If StringRegExp($sCurrentLine, "(?m)(^.*_)(?:\s*$|\s*;.*\s*$)", 0) Then
					$__iLineNumber=378 & ' - $iLine += 1•'
					$iLine += 1
					$__iLineNumber=379 & ' - While $iLine <= $aLines[0]•'
					While $iLine <= $aLines[0]
						$__iLineNumber=380 & ' - $sCurrentLine = $aLines[$iLine]•'
						$sCurrentLine = $aLines[$iLine]
						$__iLineNumber=381 & ' - If Not StringRegExp($sCurrentLine, "(?m)(^.*_)(?:\s*$|\s*;.* ...•'
						If Not StringRegExp($sCurrentLine, "(?m)(^.*_)(?:\s*$|\s*;.*\s*$)", 0) Then
							$__iLineNumber=382 & ' - $sOutPut &= $sCurrentLine & @CRLF•'
							$sOutPut &= $sCurrentLine & @CRLF
							ExitLoop
						EndIf
						$__iLineNumber=385 & ' - $sOutPut &= $sCurrentLine & @CRLF•'
						$sOutPut &= $sCurrentLine & @CRLF
						$__iLineNumber=386 & ' - $iLine += 1•'
						$iLine += 1
					WEnd
				EndIf
				;<----

				$__iLineNumber=391 & ' - $iLine += 1•'
				$iLine += 1
			WEnd
	EndSelect

	$__iLineNumber=395 & ' - $hFileOpen = FileOpen($sScriptPath, 2)•'
	$hFileOpen = FileOpen($sScriptPath, 2)
	$__iLineNumber=396 & ' - If $hFileOpen = -1 Then•'
	If $hFileOpen = -1 Then
		$__iLineNumber=397 & ' - MsgBox(4096, "ShowOriginalLine", "Error: Unable to open file ...•'
		MsgBox(4096, "ShowOriginalLine", "Error: Unable to open file!" & @CRLF & "File: " & $sScriptPath)
		$__iLineNumber=398 & ' - Return SetError(-3, 0, 0)•'
		Return SetError(-3, 0, 0)
	EndIf
	$__iLineNumber=400 & ' - $hFileWrite = FileWrite($hFileOpen, $sOutPut)•'
	$hFileWrite = FileWrite($hFileOpen, $sOutPut)
	$__iLineNumber=401 & ' - FileClose($hFileOpen)•'
	FileClose($hFileOpen)

	$__iLineNumber=403 & ' - If $hFileWrite Then•'
	If $hFileWrite Then
		$__iLineNumber=404 & ' - If Not $CmdLine[0] And $fMainFile Then MsgBox(4096, "ShowOri ...•'
		If Not $CmdLine[0] And $fMainFile Then MsgBox(4096, "ShowOriginalLine", "Info: The file was successfully modified!" & @CRLF & @CRLF & _
				"It was made a backup using the name: " & @CRLF & $sScriptPath & ".Backup.au3")
	Else
		$__iLineNumber=407 & ' - If Not $CmdLine[0] Then MsgBox(4096, "ShowOriginalLine", "Er ...•'
		If Not $CmdLine[0] Then MsgBox(4096, "ShowOriginalLine", "Error: The file not opened in writemode or file is read only!" & @CRLF & "File: " & $sScriptPath)
		$__iLineNumber=408 & ' - Return SetError(-3, 0, 0)•'
		Return SetError(-3, 0, 0)
	EndIf
	$__iLineNumber=410 & ' - Return SetError(0, 0, 1)•'
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
$__iLineNumber=426 & ' - Func _SkipLineByWord($sLine)•'
Func _SkipLineByWord($sLine)
	$__iLineNumber=427 & ' - Local $ilen•'
	Local $ilen

	$__iLineNumber=429 & ' - For $i = 1 To $asWordList[0]•'
	For $i = 1 To $asWordList[0]
		$__iLineNumber=430 & ' - $ilen = StringLen($asWordList[$i])•'
		$ilen = StringLen($asWordList[$i])
		$__iLineNumber=431 & ' - If StringInStr($sLine, $asWordList[$i], 0, 1, 1, $ilen) Then•'
		If StringInStr($sLine, $asWordList[$i], 0, 1, 1, $ilen) Then
			$__iLineNumber=432 & ' - Return 1•'
			Return 1
		EndIf
	Next
	$__iLineNumber=435 & ' - Return 0•'
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
$__iLineNumber=452 & ' - Func _StringTruncate($sString, $iValue)•'
Func _StringTruncate($sString, $iValue)
	$__iLineNumber=453 & ' - Local $sRet•'
	Local $sRet

	$__iLineNumber=455 & ' - $sRet = StringLeft($sString, $iValue)•'
	$sRet = StringLeft($sString, $iValue)
	$__iLineNumber=456 & ' - If StringLen($sString) > $iValue Then $sRet &= " ..."•'
	If StringLen($sString) > $iValue Then $sRet &= " ..."
	$__iLineNumber=457 & ' - Return $sRet•'
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
$__iLineNumber=475 & ' - Func _PathSplitRegEx($sPath)•'
Func _PathSplitRegEx($sPath)
	$__iLineNumber=476 & ' - If $sPath = "" Then Return SetError(1, 0, "")•'
	If $sPath = "" Then Return SetError(1, 0, "")
	$__iLineNumber=477 & ' - Local Const $rPathSplit = "^(?i)([a-z]:|\\\\[a-z0-9_.$]+\\[a ...•'
	Local Const $rPathSplit = '^(?i)([a-z]:|\\\\[a-z0-9_.$]+\\[a-z0-9_.]+\$?)?(\\(?:[^\\/:*?"<>|\r\n]+\\)*)?([^\\/:*?"<>|\r\n.]*)((?:\.[^.\\/:*?"<>|\r\n]+)?)$'
	$__iLineNumber=478 & ' - Local $aResult = StringRegExp($sPath, $rPathSplit, 2)•'
	Local $aResult = StringRegExp($sPath, $rPathSplit, 2)

	$__iLineNumber=480 & ' - Switch @error•'
	$__iLineNumber=481 & ' - Case 0•'
	Switch @error
		Case 0
			$__iLineNumber=482 & ' - Return $aResult•'
			Return $aResult
		$__iLineNumber=483 & ' - Case 1•'
		Case 1
			$__iLineNumber=484 & ' - Return SetError(2, 0, "")•'
			Return SetError(2, 0, "")
		$__iLineNumber=485 & ' - Case 2•'
		Case 2
			;This should never happen!
	EndSwitch
EndFunc   ;==>_PathSplitRegEx
