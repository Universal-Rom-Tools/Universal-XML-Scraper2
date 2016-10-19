#Region ;**** Directives created by AutoIt3Wrapper_GUI ****
#AutoIt3Wrapper_Icon=Ressources\Universal_Xml_Scraper.ico
#AutoIt3Wrapper_Outfile=..\BIN\Universal_XML_Scraper.exe
#AutoIt3Wrapper_Outfile_x64=..\BIN\Universal_XML_Scraper64.exe
#AutoIt3Wrapper_Compile_Both=y
#AutoIt3Wrapper_UseX64=y
#AutoIt3Wrapper_Res_Description=Scraper XML Universel
#AutoIt3Wrapper_Res_Fileversion=2.0.0.0
#AutoIt3Wrapper_Res_Fileversion_AutoIncrement=p
#AutoIt3Wrapper_Res_LegalCopyright=LEGRAS David
#AutoIt3Wrapper_Res_Language=1036
#AutoIt3Wrapper_AU3Check_Stop_OnWarning=y
#AutoIt3Wrapper_Run_Tidy=y
#AutoIt3Wrapper_UseUpx=n
#Tidy_Parameters=/reel
#EndRegion ;**** Directives created by AutoIt3Wrapper_GUI ****

;*************************************************************************
;**																		**
;**						Universal XML Scraper V2						**
;**						LEGRAS David									**
;**																		**
;*************************************************************************

;Autoit Librairy definitions
;---------------------------

#include <Date.au3>
#include <array.au3>
#include <File.au3>
#include <String.au3>
#include <GuiStatusBar.au3>
#include <Crypt.au3>
#include <GDIPlus.au3>
#include <ButtonConstants.au3>
#include <ComboConstants.au3>
#include <InetConstants.au3>
#include <EditConstants.au3>
#include <GUIConstantsEx.au3>
#include <WindowsConstants.au3>
#include <StaticConstants.au3>

TraySetState(2)

;Global Values
;---------------------------

If Not _FileCreate(@ScriptDir & "\test") Then ; Testing UXS Directory
	Global $iScriptPath = @AppDataDir & "\UXMLS" ; If not, use Path to current user's Roaming Application Data
	DirCreate($iScriptPath) ;
Else
	Global $iScriptPath = @ScriptDir
	FileDelete($iScriptPath & "\test")
EndIf

Global $iINIPath = $iScriptPath & "\UXS-config.ini"
Global $iLOGPath = IniRead($iINIPath, "GENERAL", "Path_LOG", $iScriptPath & "\log.txt")
Global $iVerboseLVL = IniRead($iINIPath, "GENERAL", "$Verbose", 0)
Global $MS_AutoConfigItem[1]

;Personnal Librairy definitions
;---------------------------

#include "./Include/_MultiLang.au3"
#include "./Include/_ExtMsgBox.au3"
#include "./Include/_Trim.au3"
#include "./Include/_Hash.au3"
#include "./Include/_zip.au3"
#include "./Include/_XML.au3"
#include "./Include/_MyFunction.au3"

;Checking Version
;----------------
_LOG_Ceation() ; Starting Log

If @Compiled Then
	Local $iScriptVer = FileGetVersion(@ScriptFullPath)
	Local $iINIVer = IniRead($iINIPath, "GENERAL", "$verINI", '0.0.0.0')
	Local $iSoftname = "UniversalXMLScraperV" & $iScriptVer
	If $iINIVer <> $iScriptVer Then
		FileDelete($iScriptPath & "\UXS-config.ini")
		FileDelete($iScriptPath & "\LanguageFiles")
		FileDelete($iScriptPath & "\Ressources")
		FileDelete($iScriptPath & "\Mix")
		FileDelete($iScriptPath & "\ProfilsFiles")
		_LOG("Update file needed from version " & $iINIVer & " to " & $iScriptVer, 1)
	Else
		_LOG("No updated files needed (Version : " & $iScriptVer & ")", 1)
	EndIf
Else
	Local $iScriptVer = 'In Progress'
	Local $iINIVer = IniRead($iINIPath, "GENERAL", "$verINI", '0.0.0.0')
	Local $iSoftname = "UniversalXMLScraper(TestDev)"
	_LOG("Dev version", 1)
EndIf

#Region FileInstall
_LOG("Starting files installation", 0)
DirCreate($iScriptPath & "\LanguageFiles")
DirCreate($iScriptPath & "\Ressources")
DirCreate($iScriptPath & "\Mix")
DirCreate($iScriptPath & "\Mix\TEMP")
DirCreate($iScriptPath & "\ProfilsFiles")
FileInstall(".\UXS-config.ini", $iScriptPath & "\UXS-config.ini")
FileInstall(".\LanguageFiles\UXS-ENGLISH.XML", $iScriptPath & "\LanguageFiles\UXS-ENGLISH.XML")
FileInstall(".\LanguageFiles\UXS-FRENCH.XML", $iScriptPath & "\LanguageFiles\UXS-FRENCH.XML")
FileInstall(".\LanguageFiles\UXS-PORTUGUESE.XML", $iScriptPath & "\LanguageFiles\UXS-PORTUGUESE.XML")
FileInstall(".\LanguageFiles\UXS-GERMAN.XML", $iScriptPath & "\LanguageFiles\UXS-GERMAN.XML")
FileInstall(".\LanguageFiles\UXS-SPANISH.XML", $iScriptPath & "\LanguageFiles\UXS-SPANISH.XML")
FileInstall(".\Ressources\empty.jpg", $iScriptPath & "\Ressources\empty.jpg")
FileInstall(".\Ressources\emptySYS.jpg", $iScriptPath & "\Ressources\emptySYS.jpg")
FileInstall(".\Ressources\Fleche.jpg", $iScriptPath & "\Ressources\Fleche.jpg")
FileInstall(".\Ressources\Fleche_DISABLE.bmp", $iScriptPath & "\Ressources\Fleche_DISABLE.bmp")
FileInstall(".\Ressources\Fleche_ENABLE.bmp", $iScriptPath & "\Ressources\Fleche_ENABLE.bmp")
FileInstall(".\Ressources\Fleche_IP1.bmp", $iScriptPath & "\Ressources\Fleche_IP1.bmp")
FileInstall(".\Ressources\Fleche_IP2.bmp", $iScriptPath & "\Ressources\Fleche_IP2.bmp")
FileInstall(".\Ressources\plink.exe", $iScriptPath & "\Ressources\plink.exe")
FileInstall(".\Ressources\optipng.exe", $iScriptPath & "\Ressources\optipng.exe")
FileInstall(".\Ressources\LICENSE optipng.txt", $iScriptPath & "\Ressources\LICENSE optipng.txt")
FileInstall(".\Ressources\LICENSE plink.txt", $iScriptPath & "\Ressources\LICENSE plink.txt")
FileInstall(".\Ressources\systemlist.txt", $iScriptPath & "\Ressources\systemlist.txt")
FileInstall(".\Ressources\regionlist.txt", $iScriptPath & "\Ressources\regionlist.txt")
FileInstall(".\Ressources\UXS.jpg", $iScriptPath & "\Ressources\UXS.jpg")
FileInstall(".\Ressources\jingle_uxs.MP3", $iScriptPath & "\Ressources\jingle_uxs.MP3")
FileInstall(".\Mix\Arcade (moon) By Supernature2k.zip", $iScriptPath & "\Mix\")
FileInstall(".\Mix\Arcade (moon).zip", $iScriptPath & "\Mix\")
FileInstall(".\Mix\Background (Modified DarKade-Theme by Nachtgarm).zip", $iScriptPath & "\Mix\")
FileInstall(".\Mix\Oldtv (Multi Sys).zip", $iScriptPath & "\Mix\")
FileInstall(".\Mix\Standard (3img).zip", $iScriptPath & "\Mix\")
FileInstall(".\Mix\Standard (4img)  By Supernature2k.zip", $iScriptPath & "\Mix\")
FileInstall(".\ProfilsFiles\Screenscraper(MIX)-RecalboxV4.xml", $iScriptPath & "\ProfilsFiles\", 0)
FileInstall(".\ProfilsFiles\Screenscraper-RecalboxV0.xml", $iScriptPath & "\ProfilsFiles\", 0)
FileInstall(".\ProfilsFiles\Screenscraper-RecalboxV4.xml", $iScriptPath & "\ProfilsFiles\", 0)
FileInstall(".\ProfilsFiles\Ressources\Attract-Mode.jpg", $iScriptPath & "\ProfilsFiles\Ressources\", 0)
FileInstall(".\ProfilsFiles\Ressources\empty.jpg", $iScriptPath & "\ProfilsFiles\Ressources\", 0)
FileInstall(".\ProfilsFiles\Ressources\Emulationstation.jpg", $iScriptPath & "\ProfilsFiles\Ressources\", 0)
FileInstall(".\ProfilsFiles\Ressources\Hyperspin.jpg", $iScriptPath & "\ProfilsFiles\Ressources\", 0)
FileInstall(".\ProfilsFiles\Ressources\Recalbox.jpg", $iScriptPath & "\ProfilsFiles\Ressources\", 0)
FileInstall(".\ProfilsFiles\Ressources\RecalboxV3.jpg", $iScriptPath & "\ProfilsFiles\Ressources\", 0)
FileInstall(".\ProfilsFiles\Ressources\RecalboxV4.jpg", $iScriptPath & "\ProfilsFiles\Ressources\", 0)
FileInstall(".\ProfilsFiles\Ressources\Ref.xlsx", $iScriptPath & "\ProfilsFiles\Ressources\", 0)
FileInstall(".\ProfilsFiles\Ressources\Screenscraper (MIX).jpg", $iScriptPath & "\ProfilsFiles\Ressources\", 0)
FileInstall(".\ProfilsFiles\Ressources\Screenscraper.jpg", $iScriptPath & "\ProfilsFiles\Ressources\", 0)
_LOG("Ending files installation", 1)

#EndRegion FileInstall

;Splash Screen
$F_Splashcreen = GUICreate("", 799, 449, -1, -1, $WS_POPUPWINDOW, $WS_EX_TOOLWINDOW)
GUICtrlCreatePic($iScriptPath & "\Ressources\UXS.jpg", -1, -1, 800, 450)
SoundPlay($iScriptPath & "\Ressources\jingle_uxs.MP3")
GUISetState()

;Const def
;---------
Global $iDevId = BinaryToString(_Crypt_DecryptData("0x1552EDED2FA9B5", "1gdf1g1gf", $CALG_RC4))
Global $iDevPassword = BinaryToString(_Crypt_DecryptData("0x1552EDED2FA9B547FBD0D9A623D954AE7BEDC681", "1gdf1g1gf", $CALG_RC4))
Global $iTEMPPath = $iScriptPath & "\TEMP"
Global $iRessourcesPath = $iScriptPath & "\Ressources"
Global $iLangPath = $iScriptPath & "\LanguageFiles" ; Where we are storing the language files.
Global $iProfilsPath = $iScriptPath & "\ProfilsFiles" ; Where we are storing the profils files.

_LOG("Verbose LVL : " & $iVerboseLVL, 1)
_LOG("Path to ini : " & $iINIPath, 1)
_LOG("Path to log : " & $iLOGPath, 1)
_LOG("Path to language : " & $iLangPath, 1)

;Variable def
;------------
Global $vUserLang = IniRead($iINIPath, "LAST_USE", "$vUserLang", -1)
Global $MP_, $aPlink_Command, $vScrapeCancelled
Local $vProfilsPath = IniRead($iINIPath, "LAST_USE", "$vProfilsPath", -1)
Local $vXpath2RomPath, $vFullTimer, $vRomTimer, $aPlink_Command, $vSelectedProfil = -1
Local $L_SCRAPE_Parts[2] = [275, -1]
Local $oXMLProfil, $oXMLSystem
Local $aConfig, $aRomList, $aXMLRomList
Local $nMsg

;---------;
;Principal;
;---------;

; Loading language
Local $aLangList = _MultiLang_LoadLangDef($iLangPath, $vUserLang)
If Not IsArray($aLangList) Or $aLangList < 0 Then
	_LOG("Impossible to load language", 2)
	Exit
EndIf
;~ _ArrayDisplay($aLangList, "$aLangList") ;Debug

; Update Checking
_LOG("Update Checking", 1)
Local $iChangelogPath = $iScriptPath & "\changelog.txt"
FileDelete($iChangelogPath)
Local $Result = _DownloadWRetry("https://raw.githubusercontent.com/Universal-Rom-Tools/Universal-XML-Scraper/master/changelog.txt", $iChangelogPath)
Switch $Result
	Case -1
		_LOG("Error downloading Changelog", 2)
	Case -2
		_LOG("Time Out downloading Changelog", 2)
	Case Else
		Local $iChangelogVer = FileReadLine($iChangelogPath)
		_LOG("Local : " & $iScriptVer & " - Github : " & $iChangelogVer)
		If $iChangelogVer <> $iScriptVer And @Compiled = 1 Then
			_LOG("Asking to Update")
			If MsgBox($MB_YESNO, _MultiLang_GetText("mess_update_Title") & " ( Local : " & $iScriptVer & " - Github : " & $iChangelogVer & " )", _MultiLang_GetText("mess_update_Question")) = $IDYES Then
				_LOG("Open GitHub Release Webpage and quit")
				ShellExecute("https://github.com/Universal-Rom-Tools/Universal-XML-Scraper/releases")
				Exit
			Else
				_LOG("NOT UPDATED")
			EndIf
		EndIf
EndSwitch

;Profil Selection
$vProfilsPath = _ProfilSelection($iProfilsPath, $vProfilsPath)
IniWrite($iINIPath, "LAST_USE", "$vProfilsPath", $vProfilsPath)

;Opening XML Profil file
$oXMLProfil = _XML_Open($vProfilsPath)
If $oXMLProfil = -1 Then Exit

;Catching SystemList.xml
$oXMLSystem = _XMLSystem_Create()
If $oXMLSystem = -1 Then Exit

;Suppress Splascreen
GUIDelete($F_Splashcreen)

; Main GUI
#Region ### START Koda GUI section ### Form=
Local $F_UniversalScraper = GUICreate(_MultiLang_GetText("main_gui"), 350, 181, 215, 143)
GUISetBkColor(0x34495c, $F_UniversalScraper)
Local $MF = GUICtrlCreateMenu(_MultiLang_GetText("mnu_file"))
Local $MF_Separation = GUICtrlCreateMenuItem("", $MF)
Local $MF_Exit = GUICtrlCreateMenuItem(_MultiLang_GetText("mnu_file_exit"), $MF)

Local $MC = GUICtrlCreateMenu(_MultiLang_GetText("mnu_cfg"))
Local $MC_Config_LU = GUICtrlCreateMenuItem(_MultiLang_GetText("mnu_cfg_config_LU"), $MC)
Local $MC_config_autoconf = GUICtrlCreateMenuItem(_MultiLang_GetText("mnu_cfg_config_autoconf"), $MC)
Local $MC_Separation = GUICtrlCreateMenuItem("", $MC)
Local $MC_Profil = GUICtrlCreateMenuItem(_MultiLang_GetText("mnu_cfg_profil"), $MC)
Local $MC_Miximage = GUICtrlCreateMenuItem(_MultiLang_GetText("mnu_cfg_miximage"), $MC)
Local $MC_Langue = GUICtrlCreateMenuItem(_MultiLang_GetText("mnu_cfg_langue"), $MC)

Local $MS = GUICtrlCreateMenu(_MultiLang_GetText("mnu_scrape"))
Local $MS_AutoConfig = GUICtrlCreateMenu(_MultiLang_GetText("mnu_scrape_autoconf"), $MS, 1)
Local $MS_Scrape = GUICtrlCreateMenuItem(_MultiLang_GetText("mnu_scrape_solo"), $MS)
Local $MS_Separation = GUICtrlCreateMenuItem("", $MS)
Local $MS_FullScrape = GUICtrlCreateMenuItem(_MultiLang_GetText("mnu_scrape_fullscrape"), $MS)

Local $MP = GUICtrlCreateMenu(_MultiLang_GetText("mnu_ssh"))
GUICtrlSetState($MP, $GUI_DISABLE)
Local $MH = GUICtrlCreateMenu(_MultiLang_GetText("mnu_help"))
Local $MH_Help = GUICtrlCreateMenuItem(_MultiLang_GetText("mnu_help_about"), $MH)
Local $P_SOURCE = GUICtrlCreatePic("", 0, 0, 150, 100)
Local $P_CIBLE = GUICtrlCreatePic("", 200, 0, 150, 100)
Local $PB_SCRAPE = GUICtrlCreateProgress(0, 110, 350, 25)
Local $B_SCRAPE = GUICtrlCreateButton(_MultiLang_GetText("scrap_button"), 150, 2, 50, 60, BitOR($BS_BITMAP, $BS_FLAT))
GUICtrlSetImage($B_SCRAPE, $iScriptPath & "\Ressources\Fleche_DISABLE.bmp", -1, 0)
Local $L_SCRAPE = _GUICtrlStatusBar_Create($F_UniversalScraper)
_GUICtrlStatusBar_SetParts($L_SCRAPE, $L_SCRAPE_Parts)

GUISetState(@SW_SHOW)
#EndRegion ### END Koda GUI section ###
_LOG("GUI Constructed", 1)
$aDIRList = _Check_autoconf($oXMLProfil)
_GUI_Refresh($oXMLProfil)

While 1
	$nMsg = GUIGetMsg()
	Switch $nMsg
		Case $GUI_EVENT_CLOSE, $MF_Exit ; Exit
			DirRemove($iTEMPPath, 1)
			_LOG("Universal XML Scraper Closed")
			Exit
		Case $MC_Profil ;Profil Selection
			$vProfilsPath = _ProfilSelection($iProfilsPath)
			IniWrite($iINIPath, "LAST_USE", "$vProfilsPath", $vProfilsPath)
			;Opening XML Profil file
			$oXMLProfil = _XML_Open($vProfilsPath)
			If $oXMLProfil = -1 Then Exit
			$aDIRList = _Check_autoconf($oXMLProfil)
			_GUI_Refresh($oXMLProfil)
			$nMsg = ""
		Case $MC_Langue
			$aLangList = _MultiLang_LoadLangDef($iLangPath, -1)
			If Not IsArray($aLangList) Or $aLangList < 0 Then
				_LOG("Impossible to load language", 2)
				Exit
			EndIf
			_LoadConfig($oXMLProfil)
			_GUI_Refresh($oXMLProfil)
		Case $MC_Config_LU
			_GUI_Config_LU()
			_GUI_Refresh($oXMLProfil)
		Case $MC_config_autoconf
			$GUI_Config_autoconf = _GUI_Config_autoconf($oXMLProfil)
			If $GUI_Config_autoconf = 1 Then
				FileDelete($vProfilsPath)
				_XML_SaveToFile($oXMLProfil, $vProfilsPath)
			EndIf
			$aDIRList = _Check_autoconf($oXMLProfil)
			_GUI_Refresh($oXMLProfil)
		Case $MH_Help
			$sMsg = "UNIVERSAL XML SCRAPER - " & $iScriptVer & @CRLF
			$sMsg &= _MultiLang_GetText("win_About_By") & @CRLF & @CRLF
			$sMsg &= _MultiLang_GetText("win_About_Thanks") & @CRLF
			$sMsg &= "http://www.screenzone.fr/" & @CRLF
			$sMsg &= "http://www.screenscraper.fr/" & @CRLF
			$sMsg &= "http://www.recalbox.com/" & @CRLF
			$sMsg &= "http://www.emulationstation.org/" & @CRLF
			_ExtMsgBoxSet(1, 2, 0x34495c, 0xFFFF00, 10, "Arial")
			_ExtMsgBox($EMB_ICONINFO, "OK", _MultiLang_GetText("win_About_Title"), $sMsg, 15)
		Case $B_SCRAPE
			DirRemove($iTEMPPath, 1)
			DirCreate($iTEMPPath)
			$nMsg = ""
			$vScrapeCancelled = 0
			$aConfig = _LoadConfig($oXMLProfil)
			If $aConfig <> 0 Then
				$vFullTimer = TimerInit()
				_GUI_Refresh($oXMLProfil, 1)

				$vEmpty_Rom = IniRead($iINIPath, "LAST_USE", "$vEmpty_Rom", 0)

				If $aConfig[5] = 0 Or ($aConfig[5] > 0 And FileGetSize($aConfig[0]) = 0) Then
					_LOG("vScrape_Mode = " & $aConfig[5] & " And " & $aConfig[0] & " = " & FileGetSize($aConfig[0]) & " ---> _XML_Make", 1)
					$oXMLTarget = _XML_Make($aConfig[0], _XML_Read("Profil/Root/Target_Value", 0, "", $oXMLProfil))
				EndIf
				$aConfig[8] = _XML_Open($aConfig[0])

				$vSystemID = _SelectSystem($oXMLSystem)
				$aRomList = _RomList_Create($aConfig)
				If IsArray($aRomList) And _Check_Cancel() Then
					$vXpath2RomPath = _XML_Read("Profil/Element[@Type='RomPath']/Target_Value", 0, "", $oXMLProfil)
					If FileGetSize($aConfig[0]) <> 0 And _Check_Cancel() Then $aXMLRomList = _XML_ListValue($vXpath2RomPath, $aConfig[0])
					For $vBoucle = 1 To UBound($aRomList) - 1
						$vLogMess = "NOT FOUND"
						$vRomTimer = TimerInit()
						$aRomList = _Check_Rom2Scrape($aRomList, $vBoucle, $aXMLRomList, $aConfig[2], $aConfig[5])
						If $aRomList[$vBoucle][3] = 1 And _Check_Cancel() Then
							$aRomList = _CalcHash($aRomList, $vBoucle)
							$aRomList = _DownloadROMXML($aRomList, $vBoucle, $vSystemID)
							If ($aRomList[$vBoucle][9] = 1 Or $vEmpty_Rom = 1) And _Check_Cancel() Then $aRomList = _Game_Make($aRomList, $vBoucle, $aConfig, $oXMLProfil)
						EndIf
						If $aRomList[$vBoucle][9] = 1 Then $vLogMess = "FOUND"
						_LOG($aRomList[$vBoucle][2] & " scraped in " & Round((TimerDiff($vRomTimer) / 1000), 2) & "s - " & $vLogMess)
						$aRomList[$vBoucle][10] = Round((TimerDiff($vRomTimer) / 1000), 2)
						If Not _Check_Cancel() Then $vBoucle = UBound($aRomList) - 1
					Next

					_LOG("-- Full Scrape in " & Round((TimerDiff($vFullTimer) / 1000), 2) & "s")

					Local $oXMLAfterTidy = _XML_CreateDOMDocument(Default)
					Local $vXMLAfterTidy = _XML_TIDY($aConfig[8])
					_XML_LoadXML($oXMLAfterTidy, $vXMLAfterTidy)
					FileDelete($aConfig[0])
					_XML_SaveToFile($oXMLAfterTidy, $aConfig[0])
					_ArrayDisplay($aRomList, '$aRomList') ; Debug
				EndIf
			EndIf
			DirRemove($iTEMPPath, 1)
			_GUI_Refresh($oXMLProfil)
	EndSwitch
	;SSH Menu
	If IsArray($MP_) Then
		For $vBoucle = 1 To UBound($MP_) - 1
			If $nMsg = $MP_[$vBoucle] Then _Plink($oXMLProfil, $aPlink_Command[$vBoucle][0])
			$nMsg = ""
		Next
	EndIf

	;Auto Conf Sub Menu
	If $aDIRList <> -1 Then
		For $vBoucle = 1 To UBound($MS_AutoConfigItem) - 1
			If $nMsg = $MS_AutoConfigItem[$vBoucle] Then
				ConsoleWrite($aDIRList[$vBoucle][0] & @CRLF)
				For $vBoucle2 = 1 To UBound($MS_AutoConfigItem) - 1
					GUICtrlSetState($MS_AutoConfigItem[$vBoucle2], $GUI_UNCHECKED)
				Next
				GUICtrlSetState($MS_AutoConfigItem[$vBoucle], $GUI_CHECKED)
				IniWrite($iINIPath, "LAST_USE", "$vSource_RomPath", $aDIRList[$vBoucle][1])
				IniWrite($iINIPath, "LAST_USE", "$vTarget_RomPath", $aDIRList[$vBoucle][2])
				IniWrite($iINIPath, "LAST_USE", "$vTarget_XMLName", $aDIRList[$vBoucle][3])
				IniWrite($iINIPath, "LAST_USE", "$vSource_ImagePath", $aDIRList[$vBoucle][4])
				IniWrite($iINIPath, "LAST_USE", "$vTarget_ImagePath", $aDIRList[$vBoucle][5])
				$nMsg = ""
				_GUI_Refresh($oXMLProfil)
			EndIf
		Next
	EndIf

WEnd

;---------;
;Fonctions;
;---------;

#Region Function
Func _LoadConfig($oXMLProfil)
	Local $aMatchingCountry
	Dim $aConfig[12]
	$aConfig[0] = IniRead($iINIPath, "LAST_USE", "$vTarget_XMLName", " ")
	$aConfig[1] = IniRead($iINIPath, "LAST_USE", "$vSource_RomPath", "")
	$aConfig[2] = IniRead($iINIPath, "LAST_USE", "$vTarget_RomPath", "./")
	$aConfig[3] = IniRead($iINIPath, "LAST_USE", "$vSource_ImagePath", "")
	$aConfig[4] = IniRead($iINIPath, "LAST_USE", "$vTarget_ImagePath", "./downloaded_images/")
	$aConfig[5] = IniRead($iINIPath, "LAST_USE", "$vScrape_Mode", 0)
	$aConfig[6] = IniRead($iINIPath, "LAST_USE", "$MissingRom_Mode", 0)
	$aConfig[7] = IniRead($iINIPath, "LAST_USE", "$CountryPic_Mode", 0)
	If IniRead($iINIPath, "LAST_USE", "$vLangPref", 0) = 0 Then IniWrite($iINIPath, "LAST_USE", "$vLangPref", _MultiLang_GetText("langpref"))
	If IniRead($iINIPath, "LAST_USE", "$vCountryPref", 0) = 0 Then IniWrite($iINIPath, "LAST_USE", "$vCountryPref", _MultiLang_GetText("countrypref"))
	$aConfig[9] = StringSplit(IniRead($iINIPath, "LAST_USE", "$vLangPref", ""), "|")
	$aConfig[10] = StringSplit(IniRead($iINIPath, "LAST_USE", "$vCountryPref", ""), "|")
;~ 	_ArrayDisplay($aConfig[9], '$vLangPref') ;Debug
	_FileReadToArray($iRessourcesPath & "\regionlist.txt", $aMatchingCountry, $FRTA_NOCOUNT, "|")
	$aConfig[11] = $aMatchingCountry

	If Not FileExists($aConfig[1]) Then
		_ExtMsgBox($EMB_ICONEXCLAM, "OK", _MultiLang_GetText("err_title"), _MultiLang_GetText("err_PathRom"), 15)
		_LOG("Error Access to : " & $aConfig[1], 2)
		Return 0
	EndIf

	_LOG("$vTarget_XMLName = " & $aConfig[0], 1)
	_LOG("$vSource_RomPath = " & $aConfig[1], 1)
	_LOG("$vTarget_RomPath = " & $aConfig[2], 1)
	_LOG("$vSource_ImagePath = " & $aConfig[3], 1)
	_LOG("$vTarget_ImagePath = " & $aConfig[4], 1)
	_LOG("$vScrape_Mode = " & $aConfig[5], 1)
	_LOG("$MissingRom_Mode = " & $aConfig[6], 1)
	_LOG("$CountryPic_Mode = " & $aConfig[7], 1)

	If Not FileExists($aConfig[3]) Then DirCreate($aConfig[3] & "\")
;~ 	If Not FileExists($aConfig[0]) Then _FileCreate($aConfig[0])

	Return $aConfig
EndFunc   ;==>_LoadConfig

Func _ProfilSelection($iProfilsPath, $vProfilsPath = -1) ;Profil Selection
	; Loading profils list
	$aProfilList = _FileListToArrayRec($iProfilsPath, "*.xml", $FLTAR_FILES, $FLTAR_NORECUR, $FLTAR_SORT, $FLTAR_FULLPATH)
;~ 	_ArrayDisplay($aProfilList, "$aProfilList") ;Debug
	If Not IsArray($aProfilList) Then
		_LOG("No Profils found", 2)
		Exit
	EndIf
	_ArrayColInsert($aProfilList, 0)
	_ArrayColInsert($aProfilList, 0)
	_ArrayDelete($aProfilList, 0)

	For $vBoucle = 0 To UBound($aProfilList) - 1
		$aProfilList[$vBoucle][0] = _XML_Read("Profil/Name", 1, $aProfilList[$vBoucle][2])
		If StringInStr($aProfilList[$vBoucle][0], $vProfilsPath) Then $vProfilsPath = $aProfilList[$vBoucle][2]
	Next
;~ _ArrayDisplay($aProfilList, "$aProfilList") ;Debug

	If $vProfilsPath = -1 Then $vProfilsPath = _SelectGUI($aProfilList, $aProfilList[0][2], "Profil")
	_LOG("Profil selected : " & $vProfilsPath)
	Return $vProfilsPath
EndFunc   ;==>_ProfilSelection

Func _Plink($oXMLProfil, $vPlinkCommand) ;Send a Command via Plink
	Local $vPlink_Ip = _XML_Read("Profil/Plink/Ip", 0, "", $oXMLProfil)
	Local $vPlink_Root = _XML_Read("Profil/Plink/Root", 0, "", $oXMLProfil)
	Local $vPlink_Pswd = _XML_Read("Profil/Plink/Pswd", 0, "", $oXMLProfil)
	Local $aPlink_Command = _XML_Read("Profil/Plink/Command/" & $vPlinkCommand, 0, "", $oXMLProfil)

	If MsgBox($MB_OKCANCEL, $vPlinkCommand, _MultiLang_GetText("mess_ssh_" & $vPlinkCommand)) = $IDOK Then
		_LOG("SSH : " & $aPlink_Command)
		$sRun = $iScriptPath & "\Ressources\plink.exe " & $vPlink_Ip & " -l " & $vPlink_Root & " -pw " & $vPlink_Pswd & " " & $aPlink_Command
		$iPid = Run($sRun, '', @SW_HIDE, $STDERR_CHILD + $STDOUT_CHILD)
		While ProcessExists($iPid)
			$_StderrRead = StderrRead($iPid)
			If Not @error And $_StderrRead <> '' Then
				If StringInStr($_StderrRead, 'Unable to open connection') Then
					MsgBox($MB_ICONERROR, _MultiLang_GetText("err_title"), _MultiLang_GetText("err_PlinkGlobal") & @CRLF & _MultiLang_GetText("err_PlinkConnection"))
					_LOG("Unable to open connection with Plink (" & $vPlink_Root & ":" & $vPlink_Pswd & "@" & $vPlink_Ip & ")", 2)
					Return -1
				EndIf
			EndIf
		WEnd
	Else
		_LOG("SSH canceled : " & $aPlink_Command, 1)
	EndIf
	Return
EndFunc   ;==>_Plink

Func _GUI_Config_LU()
	Local $vImage_Extension, $vAutoconf, $vEmptyRom
	#Region ### START Koda GUI section ### Form=
	$F_CONFIG = GUICreate(_MultiLang_GetText("win_config_LU_Title"), 477, 209, -1, -1, -1, BitOR($WS_EX_TOPMOST, $WS_EX_WINDOWEDGE))
	$G_Scrape = GUICtrlCreateGroup(_MultiLang_GetText("win_config_LU_GroupScrap"), 8, 0, 225, 201)
	$L_Source_RomPath = GUICtrlCreateLabel(_MultiLang_GetText("win_config_LU_GroupScrap_Source_RomPath"), 16, 16)
	GUICtrlSetTip(-1, _MultiLang_GetText("tips_config_GroupScrap_PathRom"))
	$I_Source_RomPath = GUICtrlCreateInput(IniRead($iINIPath, "LAST_USE", "$vSource_RomPath", ""), 16, 35, 177, 21)
	$B_Source_RomPath = GUICtrlCreateButton("...", 198, 35, 27, 21)
	$L_Target_XMLName = GUICtrlCreateLabel(_MultiLang_GetText("win_config_LU_GroupScrap_Target_XMLName"), 16, 63)
	GUICtrlSetTip(-1, _MultiLang_GetText("tips_config_GroupScrap_PathXML"))
	$I_Target_XMLName = GUICtrlCreateInput(IniRead($iINIPath, "LAST_USE", "$vTarget_XMLName", ""), 16, 83, 177, 21)
	$B_Target_XMLName = GUICtrlCreateButton("...", 198, 83, 27, 21)
	$L_Target_RomPath = GUICtrlCreateLabel(_MultiLang_GetText("win_config_LU_GroupScrap_Target_RomPath"), 16, 108)
	GUICtrlSetTip(-1, _MultiLang_GetText("tips_config_GroupScrap_PathRomSub"))
	$I_Target_RomPath = GUICtrlCreateInput(IniRead($iINIPath, "LAST_USE", "$vTarget_RomPath", ""), 16, 128, 177, 21)
	GUICtrlCreateGroup("", -99, -99, 1, 1)
	$G_Image = GUICtrlCreateGroup(_MultiLang_GetText("win_config_LU_GroupImage"), 240, 0, 225, 113)
	$L_Source_ImagePath = GUICtrlCreateLabel(_MultiLang_GetText("win_config_LU_GroupImage_Source_ImagePath"), 248, 15)
	GUICtrlSetTip(-1, _MultiLang_GetText("tips_config_GroupImage_PathImage"))
	$I_Source_ImagePath = GUICtrlCreateInput(IniRead($iINIPath, "LAST_USE", "$vSource_ImagePath", ""), 248, 34, 177, 21)
	$B_Source_ImagePath = GUICtrlCreateButton("...", 430, 34, 27, 21)
	$L_Target_ImagePath = GUICtrlCreateLabel(_MultiLang_GetText("win_config_LU_GroupImage_Target_ImagePath"), 248, 60)
	GUICtrlSetTip(-1, _MultiLang_GetText("tips_config_GroupImage_PathImageSub"))
	$I_Target_ImagePath = GUICtrlCreateInput(IniRead($iINIPath, "LAST_USE", "$vTarget_ImagePath", ""), 248, 80, 177, 21)
	GUICtrlCreateGroup("", -99, -99, 1, 1)
	$B_CONFENREG = GUICtrlCreateButton(_MultiLang_GetText("win_config_Enreg"), 240, 128, 105, 73)
	$B_CONFANNUL = GUICtrlCreateButton(_MultiLang_GetText("win_config_Cancel"), 358, 128, 105, 73)
	GUISetState(@SW_SHOW)
	GUISetState(@SW_DISABLE, $F_UniversalScraper)
	#EndRegion ### END Koda GUI section ###

	While 1
		$nMsg = GUIGetMsg()
		Switch $nMsg
			Case $GUI_EVENT_CLOSE, $B_CONFANNUL
				GUIDelete($F_CONFIG)
				GUISetState(@SW_ENABLE, $F_UniversalScraper)
				WinActivate($F_UniversalScraper)
				_LOG("Path Configuration Canceled", 0)
				Return
			Case $B_Target_XMLName
				$vTarget_XMLName = FileSaveDialog(_MultiLang_GetText("win_config_GroupScrap_PathXML"), GUICtrlRead($I_Source_RomPath), "xml (*.xml)", 18, "gamelist.xml", $F_CONFIG)
				If @error Then $vTarget_XMLName = GUICtrlRead($I_Target_XMLName)
				GUICtrlSetData($I_Target_XMLName, $vTarget_XMLName)
			Case $B_Source_RomPath
				$vSource_RomPath = FileSelectFolder(_MultiLang_GetText("win_config_LU_GroupScrap_Source_RomPath"), GUICtrlRead($I_Source_RomPath), $FSF_CREATEBUTTON, GUICtrlRead($I_Source_RomPath), $F_CONFIG)
				GUICtrlSetData($I_Source_RomPath, $vSource_RomPath)
			Case $B_Source_ImagePath
				$vSource_ImagePath = FileSelectFolder(_MultiLang_GetText("win_config_LU_GroupScrap_Source_RomPath"), GUICtrlRead($I_Source_RomPath), $FSF_CREATEBUTTON, GUICtrlRead($I_Source_ImagePath), $F_CONFIG)
				GUICtrlSetData($I_Source_ImagePath, $vSource_ImagePath)
			Case $B_CONFENREG
				$vSource_RomPath = GUICtrlRead($I_Source_RomPath) ;$vSource_RomPath
				If (StringRight($vSource_RomPath, 1) = '\') Then StringTrimRight($vSource_RomPath, 1)
				IniWrite($iINIPath, "LAST_USE", "$vSource_RomPath", $vSource_RomPath)
				$vTarget_XMLName = GUICtrlRead($I_Target_XMLName) ;$vTarget_XMLName
				IniWrite($iINIPath, "LAST_USE", "$vTarget_XMLName", $vTarget_XMLName)
				$vTarget_RomPath = GUICtrlRead($I_Target_RomPath) ;$vTarget_RomPath
				IniWrite($iINIPath, "LAST_USE", "$vTarget_RomPath", $vTarget_RomPath)
				$vSource_ImagePath = GUICtrlRead($I_Source_ImagePath) ;$vSource_ImagePath
				IniWrite($iINIPath, "LAST_USE", "$vSource_ImagePath", $vSource_ImagePath)
				$vTarget_ImagePath = GUICtrlRead($I_Target_ImagePath) ;$vTarget_ImagePath
				IniWrite($iINIPath, "LAST_USE", "$vTarget_ImagePath", $vTarget_ImagePath)
				_LOG("Path Configuration Saved", 0)
				_LOG("------------------------", 1)
				_LOG("$vTarget_XMLName = " & $vTarget_XMLName, 1)
				_LOG("$vSource_RomPath = " & $vSource_RomPath, 1)
				_LOG("$vTarget_RomPath = " & $vTarget_RomPath, 1)
				_LOG("$vSource_ImagePath = " & $vSource_ImagePath, 1)
				_LOG("$vTarget_ImagePath = " & $vTarget_ImagePath, 1)
				GUIDelete($F_CONFIG)
				GUISetState(@SW_ENABLE, $F_UniversalScraper)
				WinActivate($F_UniversalScraper)
				Return
		EndSwitch
	WEnd
EndFunc   ;==>_GUI_Config_LU

Func _GUI_Config_autoconf($oXMLProfil)
	Local $vImage_Extension, $vAutoconf, $vEmptyRom
	#Region ### START Koda GUI section ### Form=
	$F_CONFIG = GUICreate(_MultiLang_GetText("win_config_autoconf_Title"), 477, 209, -1, -1, -1, BitOR($WS_EX_TOPMOST, $WS_EX_WINDOWEDGE))
	$CB_Autoconf = GUICtrlCreateCheckbox(_MultiLang_GetText("win_config_autoconf_Use"), 8, 8, 225, 33, BitOR($GUI_SS_DEFAULT_CHECKBOX, $BS_CENTER, $BS_VCENTER))
	$G_Scrape = GUICtrlCreateGroup(_MultiLang_GetText("win_config_autoconf_GroupScrap"), 8, 40, 225, 161)
	$L_Source_RootPath = GUICtrlCreateLabel(_MultiLang_GetText("win_config_autoconf_GroupScrap_Source_RootPath"), 16, 56)
	GUICtrlSetTip(-1, _MultiLang_GetText("tips_config_GroupScrap_PathXML"))
	$I_Source_RootPath = GUICtrlCreateInput(_XML_Read("Profil/AutoConf/Source_RootPath", 0, "", $oXMLProfil), 16, 75, 177, 21)
	$B_Source_RootPath = GUICtrlCreateButton("...", 198, 75, 27, 21)
	$L_Target_XMLName = GUICtrlCreateLabel(_MultiLang_GetText("win_config_autoconf_GroupScrap_Target_XMLName"), 16, 103)
	GUICtrlSetTip(-1, _MultiLang_GetText("tips_config_GroupScrap_PathXML"))
	$I_Target_XMLName = GUICtrlCreateInput(_XML_Read("Profil/AutoConf/Target_XMLName", 0, "", $oXMLProfil), 16, 123, 177, 21)
	$L_Target_RomPath = GUICtrlCreateLabel(_MultiLang_GetText("win_config_autoconf_GroupScrap_Target_RomPath"), 16, 153)
	GUICtrlSetTip(-1, _MultiLang_GetText("tips_config_GroupScrap_PathRomSub"))
	$I_Target_RomPath = GUICtrlCreateInput(_XML_Read("Profil/AutoConf/Target_RomPath", 0, "", $oXMLProfil), 16, 173, 177, 21)
	GUICtrlCreateGroup("", -99, -99, 1, 1)
	$G_Image = GUICtrlCreateGroup(_MultiLang_GetText("win_config_autoconf_GroupImage"), 240, 0, 225, 113)
	$L_Source_ImagePath = GUICtrlCreateLabel(_MultiLang_GetText("win_config_autoconf_GroupImage_Source_ImagePath"), 248, 15)
	GUICtrlSetTip(-1, _MultiLang_GetText("tips_config_GroupImage_PathImage"))
	$I_Source_ImagePath = GUICtrlCreateInput(_XML_Read("Profil/AutoConf/Source_ImagePath", 0, "", $oXMLProfil), 248, 34, 177, 21)
	$L_Target_ImagePath = GUICtrlCreateLabel(_MultiLang_GetText("win_config_autoconf_GroupImage_Target_ImagePath"), 248, 60)
	GUICtrlSetTip(-1, _MultiLang_GetText("tips_config_GroupImage_PathImageSub"))
	$I_Target_ImagePath = GUICtrlCreateInput(_XML_Read("Profil/AutoConf/Target_ImagePath", 0, "", $oXMLProfil), 248, 80, 177, 21)
	GUICtrlCreateGroup("", -99, -99, 1, 1)
	$B_CONFENREG = GUICtrlCreateButton(_MultiLang_GetText("win_config_Enreg"), 240, 128, 105, 73)
	$B_CONFANNUL = GUICtrlCreateButton(_MultiLang_GetText("win_config_Cancel"), 358, 128, 105, 73)
	GUISetState(@SW_SHOW)
	GUISetState(@SW_DISABLE, $F_UniversalScraper)
	#EndRegion ### END Koda GUI section ###

	GUICtrlSetState($CB_Autoconf, $GUI_UNCHECKED)
	If IniRead($iINIPath, "LAST_USE", "$vAutoconf_Use", 0) = 1 Then GUICtrlSetState($CB_Autoconf, $GUI_CHECKED)

	While 1
		$nMsg = GUIGetMsg()
		Switch $nMsg
			Case $GUI_EVENT_CLOSE, $B_CONFANNUL
				GUIDelete($F_CONFIG)
				GUISetState(@SW_ENABLE, $F_UniversalScraper)
				WinActivate($F_UniversalScraper)
				_LOG("Path Configuration Canceled", 0)
				Return
			Case $B_Source_RootPath
				$vSource_RootPath = FileSelectFolder(_MultiLang_GetText("win_config_LU_GroupScrap_Source_RootPath"), GUICtrlRead($I_Source_RootPath), $FSF_CREATEBUTTON, GUICtrlRead($I_Source_RootPath), $F_CONFIG)
				GUICtrlSetData($I_Source_RootPath, $vSource_RootPath)
			Case $B_CONFENREG
				$vSource_RootPath = GUICtrlRead($I_Source_RootPath) ;$vSource_RootPath
				If (StringRight($vSource_RootPath, 1) = '\') Then StringTrimRight($vSource_RootPath, 1)
				_XML_Replace("Profil/AutoConf/Source_RootPath", $vSource_RootPath, 0, "", $oXMLProfil)
				$vTarget_XMLName = GUICtrlRead($I_Target_XMLName) ;$vTarget_XMLName
				_XML_Replace("Profil/AutoConf/Target_XMLName", $vTarget_XMLName, 0, "", $oXMLProfil)
				$vTarget_RomPath = GUICtrlRead($I_Target_RomPath) ;$vTarget_RomPath
				_XML_Replace("Profil/AutoConf/Target_RomPath", $vTarget_RomPath, 0, "", $oXMLProfil)
				$vSource_ImagePath = GUICtrlRead($I_Source_ImagePath) ;$vSource_ImagePath
				_XML_Replace("Profil/AutoConf/Source_ImagePath", $vSource_ImagePath, 0, "", $oXMLProfil)
				$vTarget_ImagePath = GUICtrlRead($I_Target_ImagePath) ;$vTarget_ImagePath
				_XML_Replace("Profil/AutoConf/Target_ImagePath", $vTarget_ImagePath, 0, "", $oXMLProfil)
				If _IsChecked($CB_Autoconf) Then
					$vAutoconf_Use = 1
				Else
					$vAutoconf_Use = 0
				EndIf
				IniWrite($iINIPath, "LAST_USE", "$vAutoconf_Use", $vAutoconf_Use)
				_LOG("AutoConf Path Configuration Saved", 0)
				_LOG("------------------------", 1)
				_LOG("$vSource_RootPath = " & $vSource_RootPath, 1)
				_LOG("$vTarget_XMLName = " & $vTarget_XMLName, 1)
				_LOG("$vTarget_RomPath = " & $vTarget_RomPath, 1)
				_LOG("$vSource_ImagePath = " & $vSource_ImagePath, 1)
				_LOG("$vTarget_ImagePath = " & $vTarget_ImagePath, 1)
				GUIDelete($F_CONFIG)
				GUISetState(@SW_ENABLE, $F_UniversalScraper)
				WinActivate($F_UniversalScraper)
				Return 1
		EndSwitch
	WEnd
EndFunc   ;==>_GUI_Config_autoconf

Func _GUI_Refresh($oXMLProfil = -1, $ScrapIP = 0, $vScrapeOK = 0) ;Refresh GUI
	If $oXMLProfil <> -1 Then
		If $ScrapIP = 0 Then
			; GUI Picture
			Local $vSourcePicturePath = _XML_Read("Profil/General/Source_Image", 0, "", $oXMLProfil)
			If $vSourcePicturePath < 0 Then
				$vSourcePicturePath = $iScriptPath & "\ProfilsFiles\Ressources\empty.jpg"
			Else
				$vSourcePicturePath = $iScriptPath & "\ProfilsFiles\Ressources\" & $vSourcePicturePath
			EndIf

			Local $vTargetPicturePath = _XML_Read("Profil/General/Target_Image", 0, "", $oXMLProfil)
			If $vTargetPicturePath < 0 Then
				$vTargetPicturePath = $iScriptPath & "\ProfilsFiles\Ressources\empty.jpg"
			Else
				$vTargetPicturePath = $iScriptPath & "\ProfilsFiles\Ressources\" & $vTargetPicturePath
			EndIf
			_GDIPlus_Startup()
			$hGraphic = _GDIPlus_GraphicsCreateFromHWND($F_UniversalScraper)
			$hImage = _GDIPlus_ImageLoadFromFile($iScriptPath & "\Ressources\empty.jpg")
			$hImage = _GDIPlus_ImageResize($hImage, 100, 40)
			$ImageWidth = _GDIPlus_ImageGetWidth($hImage)
			$ImageHeight = _GDIPlus_ImageGetHeight($hImage)
			_WinAPI_RedrawWindow($F_UniversalScraper, 0, 0, $RDW_UPDATENOW)
			_GDIPlus_GraphicsDrawImage($hGraphic, $hImage, 175 - ($ImageWidth / 2), 82 - ($ImageHeight / 2))
			_WinAPI_RedrawWindow($F_UniversalScraper, 0, 0, $RDW_VALIDATE)
			_GDIPlus_ImageDispose($hImage)
			_GDIPlus_GraphicsDispose($hGraphic)
			_GDIPlus_Shutdown()
			GUICtrlSetImage($P_SOURCE, $vSourcePicturePath)
			GUICtrlSetImage($P_CIBLE, $vTargetPicturePath)

			;Overall Menu
			Local $vSystem = StringSplit(IniRead($iINIPath, "LAST_USE", "$vSource_RomPath", ""), "\")
			$vSystem = $vSystem[UBound($vSystem) - 1]

			GUICtrlSetState($MF, $GUI_ENABLE)
			GUICtrlSetData($MF, _MultiLang_GetText("mnu_file"))
			GUICtrlSetData($MF_Exit, _MultiLang_GetText("mnu_file_exit"))

			GUICtrlSetState($MC, $GUI_ENABLE)
			GUICtrlSetData($MC, _MultiLang_GetText("mnu_cfg"))
			GUICtrlSetData($MC_Config_LU, _MultiLang_GetText("mnu_cfg_config_LU"))
			GUICtrlSetData($MC_config_autoconf, _MultiLang_GetText("mnu_cfg_config_autoconf"))
			GUICtrlSetData($MC_Profil, _MultiLang_GetText("mnu_cfg_profil"))
			GUICtrlSetData($MC_Miximage, _MultiLang_GetText("mnu_cfg_miximage"))
			GUICtrlSetData($MC_Langue, _MultiLang_GetText("mnu_cfg_langue"))

			GUICtrlSetState($MS, $GUI_ENABLE)
			GUICtrlSetData($MS, _MultiLang_GetText("mnu_scrape"))
			GUICtrlSetData($MS_AutoConfig, _MultiLang_GetText("mnu_scrape_autoconf"))
			GUICtrlSetData($MS_Scrape, _MultiLang_GetText("mnu_scrape_solo") & " - " & $vSystem)
			GUICtrlSetData($MS_FullScrape, _MultiLang_GetText("mnu_scrape_fullscrape"))

			;SSH Menu
			If _XML_NodeExists($oXMLProfil, "Profil/Plink/Ip") = $XML_RET_FAILURE Then
				_LOG("SSH Disable", 1)
				GUICtrlSetState($MP, $GUI_DISABLE)
				If IsArray($MP_) Then
					For $vBoucle = 1 To UBound($MP_) - 1
						GUICtrlDelete($MP_[$vBoucle])
					Next
				EndIf

			Else
				_LOG("SSH Enable", 1)
				GUICtrlSetState($MP, $GUI_ENABLE)
				GUICtrlSetData($MP, _MultiLang_GetText("mnu_ssh"))
				If IsArray($MP_) Then
					For $vBoucle = 1 To UBound($MP_) - 1
						GUICtrlDelete($MP_[$vBoucle])
					Next
				EndIf
				$aPlink_Command = _XML_ListNode("Profil/Plink/Command", "", $oXMLProfil)
				If IsArray($aPlink_Command) Then
					Dim $MP_[UBound($aPlink_Command)]
					For $vBoucle = 1 To UBound($aPlink_Command) - 1
						$MP_[$vBoucle] = GUICtrlCreateMenuItem(_MultiLang_GetText("mnu_ssh_" & $aPlink_Command[$vBoucle][0]), $MP)
					Next
				EndIf
			EndIf

			GUICtrlSetState($MH, $GUI_ENABLE)
			GUICtrlSetData($MH, _MultiLang_GetText("mnu_help"))
			GUICtrlSetData($MH_Help, _MultiLang_GetText("mnu_help_about"))

			GUICtrlSetData($B_SCRAPE, _MultiLang_GetText("scrap_button"))
			GUICtrlSetState($PB_SCRAPE, $GUI_HIDE)
			_GUICtrlStatusBar_SetText($L_SCRAPE, "")

			_LOG("GUI Refresh", 1)

		Else
			_LOG("GUI Desactivated (Scrape in progress)", 1)
			GUICtrlSetState($MF, $GUI_DISABLE)
			GUICtrlSetState($MC, $GUI_DISABLE)
			GUICtrlSetState($MS, $GUI_DISABLE)
			GUICtrlSetState($MP, $GUI_DISABLE)
			GUICtrlSetState($MH, $GUI_DISABLE)

;~ 		Local $SCRAP_ENABLE
;~ 		Local $vErrorMess = ""
;~ 		$user_lang = IniRead($PathConfigINI, "LAST_USE", "$user_lang", -1)

;~ 		If $No_Profil < 1 Then
;~ 			$vErrorMess &= _MultiLang_GetText("err_No_Profil") & @CRLF
;~ 			_CREATION_LOGMESS(2, _MultiLang_GetText("err_No_Profil") & " : " & $No_Profil)
;~ 			$vScrapeOK = $vScrapeOK + 1
;~ 		EndIf
;~ 		If $vScrapeOK = 0 Then
;~ 			GUICtrlSetImage($B_SCRAPE, $SOURCE_DIRECTORY & "\Ressources\Fleche_ENABLE.bmp", -1, 0)
;~ 			_CREATION_LOGMESS(2, "SCRAPE Enable")
;~ 			$SCRAP_ENABLE = 1
;~ 		Else
;~ 			GUICtrlSetImage($B_SCRAPE, $SOURCE_DIRECTORY & "\Ressources\Fleche_DISABLE.bmp", -1, 0)
;~ 			_CREATION_LOGMESS(2, "SCRAPE Disable")
;~ 			$SCRAP_ENABLE = 0
;~ 		EndIf

;~ 		$aDIRList = _Check_autoconf($vSource_RootPath, $PATHAUTOCONF_Target_RomPath, $vTarget_XMLName, $vSource_ImagePath, $vTarget_ImagePath)
;~ 	Else
;~ 		If $MCnu_SSH = 2 Then GUICtrlSetState($MP, $GUI_DISABLE)
;~ 		_CREATION_LOGMESS(2, "Menu SSH Disable")
;~ 		GUICtrlSetState($MF, $GUI_DISABLE)
;~ 		GUICtrlSetState($MC, $GUI_DISABLE)
;~ 		GUICtrlSetState($MH, $GUI_DISABLE)
;~ 		GUICtrlSetImage($B_SCRAPE, $SOURCE_DIRECTORY & "\Ressources\Fleche_IP1.bmp", -1, 0)
;~ 		$SCRAP_ENABLE = 1
;~ 		GUICtrlSetState($PB_SCRAPE, $GUI_SHOW)
		EndIf
	EndIf
	Return
EndFunc   ;==>_GUI_Refresh

Func _Check_autoconf($oXMLProfil)
	$vAutoconf_Use = IniRead($iINIPath, "LAST_USE", "$vAutoconf_Use", "-1")
	If $vAutoconf_Use = "-1" Then
		If MsgBox(BitOR($MB_ICONQUESTION, $MB_YESNO), _MultiLang_GetText("mess_autoconf_ask_Title"), _MultiLang_GetText("mess_autoconf_ask_Question")) = $IDYES Then
			$vAutoconf_Use = 1
		Else
			$vAutoconf_Use = 0
		EndIf
	EndIf
	IniWrite($iINIPath, "LAST_USE", "$vAutoconf_Use", $vAutoconf_Use)

	Local $vSource_RootPath = _XML_Read("Profil/AutoConf/Source_RootPath", 0, "", $oXMLProfil)
	Local $vTarget_XMLName = _XML_Read("Profil/AutoConf/Target_XMLName", 0, "", $oXMLProfil)
	Local $vTarget_RomPath = _XML_Read("Profil/AutoConf/Target_RomPath", 0, "", $oXMLProfil)
	Local $vSource_ImagePath = _XML_Read("Profil/AutoConf/Source_ImagePath", 0, "", $oXMLProfil)
	Local $vTarget_ImagePath = _XML_Read("Profil/AutoConf/Target_ImagePath", 0, "", $oXMLProfil)

	If $vSource_RootPath = "" Or $vAutoconf_Use = 0 Then
		GUICtrlSetState($MS_AutoConfig, $GUI_DISABLE)
		GUICtrlSetState($MS_FullScrape, $GUI_DISABLE)
		Return -1
	EndIf

	GUISetState(@SW_DISABLE, $F_UniversalScraper)
	SplashTextOn(_MultiLang_GetText("mnu_edit_autoconf"), _MultiLang_GetText("mess_autoconf"), 400, 50)
	If StringRight($vSource_RootPath, 1) = '\' Then $vSource_RootPath = StringTrimRight($vSource_RootPath, 1)
	$aDIRList = _FileListToArrayRec($vSource_RootPath, "*", $FLTAR_FOLDERS, $FLTAR_NORECUR, $FLTAR_SORT, $FLTAR_RELPATH)
	If IsArray($aDIRList) Then
;~ 		_ArrayDisplay($aDIRList, '$aDIRList') ; Debug
		If IsArray($MS_AutoConfigItem) Then
			For $B_ArrayDelete = 1 To UBound($MS_AutoConfigItem) - 1
				GUICtrlSetState($MS_AutoConfigItem[$B_ArrayDelete], $GUI_UNCHECKED)
				GUICtrlDelete($MS_AutoConfigItem[$B_ArrayDelete])
			Next
		EndIf

		GUICtrlSetState($MS_AutoConfig, $GUI_ENABLE)
		GUICtrlSetState($MS_FullScrape, $GUI_ENABLE)
		Dim $MS_AutoConfigItem[UBound($aDIRList)]
		For $vBoucle = 1 To 5
			_ArrayColInsert($aDIRList, $vBoucle)
		Next
		For $vBoucle = 1 To UBound($aDIRList) - 1
			$aDIRList[$vBoucle][1] = $vSource_RootPath & "\" & $aDIRList[$vBoucle][0]
			$aDIRList[$vBoucle][2] = $vTarget_RomPath
			$aDIRList[$vBoucle][3] = $aDIRList[$vBoucle][1] & "\" & $vTarget_XMLName
			$aDIRList[$vBoucle][4] = $aDIRList[$vBoucle][1] & "\" & $vSource_ImagePath
			$aDIRList[$vBoucle][5] = $vTarget_ImagePath
			DirCreate($aDIRList[$vBoucle][4])
			$MS_AutoConfigItem[$vBoucle] = GUICtrlCreateMenuItem($aDIRList[$vBoucle][0], $MS_AutoConfig)
		Next
;~ 		_ArrayDisplay($aDIRList, '$aDIRList') ; Debug
		GUISetState(@SW_ENABLE, $F_UniversalScraper)
		SplashOff()
		Return $aDIRList
	Else
		GUICtrlSetState($MS_AutoConfig, $GUI_DISABLE)
		GUICtrlSetState($MS_FullScrape, $GUI_DISABLE)
		GUISetState(@SW_ENABLE, $F_UniversalScraper)
		SplashOff()
		MsgBox($MB_ICONERROR, _MultiLang_GetText("err_title"), _MultiLang_GetText("err_autoconfPathRom"))
		IniWrite($iINIPath, "LAST_USE", "$vAutoconf_Use", 0)
		Return -1
	EndIf
EndFunc   ;==>_Check_autoconf

Func _Check_Cancel()
	If GUIGetMsg() = $B_SCRAPE Or $vScrapeCancelled = 1 Then
		_LOG("Scrape Cancelled")
		$vScrapeCancelled = 1
		Return False
	Else
		$vScrapeCancelled = 0
		Return True
	EndIf
EndFunc   ;==>_Check_Cancel

Func _RomList_Create($aConfig, $vFullScrape = 0)
	Local $sDrive = "", $sDir = "", $sFileName = "", $sExtension = "", $aPathSplit
	$vRechFiles = IniRead($iINIPath, "GENERAL", "$vRechFiles ", "*.*z*")
	Local $vPicDir = StringSplit($aConfig[3], "\")
	$vPipeCount = StringSplit($vRechFiles, "|")
	If $vPipeCount[0] = 2 Then $vRechFiles = $vRechFiles & "|"
	If StringRight($vRechFiles, 1) = "|" Then
		$vRechFiles = $vRechFiles & $vPicDir[UBound($vPicDir) - 1]
	Else
		$vRechFiles = $vRechFiles & ";" & $vPicDir[UBound($vPicDir) - 1]
	EndIf
	_LOG("Listing ROM (" & $vRechFiles & ")", 1)
	$aRomList = _FileListToArrayRec($aConfig[1], $vRechFiles, $FLTAR_FILES, $FLTAR_RECUR, $FLTAR_SORT)

	If @error = 1 Then
		_LOG("Invalid Rom Path : " & $aConfig[1], 2)
		If $vFullScrape = 0 Then MsgBox($MB_ICONERROR, _MultiLang_GetText("err_title"), _MultiLang_GetText("err_PathRom"))
		Return -1
	EndIf
	If @error = 4 Then
		_LOG("No rom in " & $aConfig[1], 2)
		If $vFullScrape = 0 Then MsgBox($MB_ICONERROR, _MultiLang_GetText("err_title"), _MultiLang_GetText("err_FillRomList"))
		Return -1
	EndIf

	For $vBoucle = 1 To 10
		_ArrayColInsert($aRomList, $vBoucle)
	Next

	_LOG(UBound($aRomList) - 1 & " Rom(s) found")

	For $vBoucle = 1 To UBound($aRomList) - 1
		$aRomList[$vBoucle][1] = $aConfig[1] & "\" & $aRomList[$vBoucle][0]
		$aPathSplit = _PathSplit($aRomList[$vBoucle][0], $sDrive, $sDir, $sFileName, $sExtension)
		$aRomList[$vBoucle][2] = $aPathSplit[3]
		$aRomList[$vBoucle][9] = -1
	Next

	_ArrayDisplay($aRomList, '$aRomList') ; Debug
;~ 	_ArraySort($aRomList)

	Return $aRomList
EndFunc   ;==>_RomList_Create

Func _Check_Rom2Scrape($aRomList, $vNoRom, $aXMLRomList, $vTarget_RomPath, $vScrape_Mode)
	Switch $vScrape_Mode
		Case 0
			_LOG($aRomList[$vNoRom][2] & " To Scrape ($vScrape_Mode=0)", 1)
			$aRomList[$vNoRom][3] = 1
			Return $aRomList
		Case Else
			If IsArray($aXMLRomList) Then
				If _ArraySearch($aXMLRomList, $vTarget_RomPath & StringReplace($aRomList[$vNoRom][0], "\", "/"), 0, 0, 0, 0, 1, 2) <> -1 Then
					_LOG($aRomList[$vNoRom][2] & " NOT Scraped ($vScrape_Mode=1)", 1)
					$aRomList[$vNoRom][3] = 0
					Return $aRomList
				EndIf
			EndIf
			_LOG($aRomList[$vNoRom][2] & " To Scrape ($vScrape_Mode=1)", 1)
			$aRomList[$vNoRom][3] = 1
			Return $aRomList
	EndSwitch
	Return $aRomList
EndFunc   ;==>_Check_Rom2Scrape

Func _CalcHash($aRomList, $vNoRom)
	If Not _Check_Cancel() Then Return $aRomList
	$TimerHash = TimerInit()
	$aRomList[$vNoRom][4] = FileGetSize($aRomList[$vNoRom][1])
	$aRomList[$vNoRom][5] = StringRight(_CRC32ForFile($aRomList[$vNoRom][1]), 8)
	If Int(($aRomList[$vNoRom][4] / 1048576)) > 50 And IniRead($iINIPath, "GENERAL", "$vQuick", 0) = 1 And _Check_Cancel() Then
		_LOG("QUICK Mode ", 1)
	Else
		$aRomList[$vNoRom][6] = _MD5ForFile($aRomList[$vNoRom][1])
		$aRomList[$vNoRom][7] = _SHA1ForFile($aRomList[$vNoRom][1])
	EndIf
	_LOG("Rom Info (" & $aRomList[$vNoRom][0] & ") Hash in " & Round((TimerDiff($TimerHash) / 1000), 2) & "s")
	_LOG("Size : " & $aRomList[$vNoRom][4], 1)
	_LOG("CRC32 : " & $aRomList[$vNoRom][5], 1)
	_LOG("MD5 : " & $aRomList[$vNoRom][6], 1)
	_LOG("SHA1 : " & $aRomList[$vNoRom][7], 1)
	Return $aRomList
EndFunc   ;==>_CalcHash

Func _XMLSystem_Create()
	Local $oXMLSystem, $vXMLSystemPath = $iScriptPath & "\Ressources\systemlist.xml"
	_LOG("http://www.screenscraper.fr/api/systemesListe.php?devid=" & $iDevId & "&devpassword=" & $iDevPassword & "&softname=" & $iSoftname & "&output=XML", 3)
	$vXMLSystemPath = _DownloadWRetry("http://www.screenscraper.fr/api/systemesListe.php?devid=" & $iDevId & "&devpassword=" & $iDevPassword & "&softname=" & $iSoftname & "&output=XML", $vXMLSystemPath)
	Switch $vXMLSystemPath
		Case -1
			MsgBox($MB_ICONERROR, _MultiLang_GetText("err_title"), _MultiLang_GetText("err_UXSGlobal") & @CRLF & _MultiLang_GetText("err_Connection"))
			Return -1
		Case -2
			MsgBox($MB_ICONERROR, _MultiLang_GetText("err_title"), _MultiLang_GetText("err_UXSGlobal") & @CRLF & _MultiLang_GetText("err_TimeOut"))
			Return -1
		Case Else
			$oXMLSystem = _XML_Open($vXMLSystemPath)
			If $oXMLSystem = -1 Then
				MsgBox($MB_ICONERROR, _MultiLang_GetText("err_title"), _MultiLang_GetText("err_UXSGlobal") & @CRLF & _MultiLang_GetText("err_SystemList"))
				Return -1
			Else
				_LOG("systemlist.xml Opened", 1)
				Return $oXMLSystem
			EndIf
	EndSwitch
EndFunc   ;==>_XMLSystem_Create

Func _DownloadROMXML($aRomList, $vBoucle, $vSystemID)
	If Not _Check_Cancel() Then Return $aRomList
	Local $vXMLRom = $iTEMPPath & "\" & StringRegExpReplace($aRomList[$vBoucle][2], "[\[\]/\|\:\?""\*\\<>]", "") & ".xml"
	_LOG("http://www.screenscraper.fr/api/jeuInfos.php?devid=" & $iDevId & "&devpassword=" & $iDevPassword & "&softname=" & $iSoftname & "&output=xml&crc=" & $aRomList[$vBoucle][5] & "&md5=" & $aRomList[$vBoucle][6] & "&sha1=" & $aRomList[$vBoucle][4] & "&systemeid=" & $vSystemID & "&romtype=rom&romnom=" & $aRomList[$vBoucle][2] & "&romtaille=" & $aRomList[$vBoucle][4], 3)
	$aRomList[$vBoucle][8] = _DownloadWRetry("http://www.screenscraper.fr/api/jeuInfos.php?devid=" & $iDevId & "&devpassword=" & $iDevPassword & "&softname=" & $iSoftname & "&output=xml&crc=" & $aRomList[$vBoucle][5] & "&md5=" & $aRomList[$vBoucle][6] & "&sha1=" & $aRomList[$vBoucle][7] & "&systemeid=" & $vSystemID & "&romtype=rom&romnom=" & $aRomList[$vBoucle][2] & "&romtaille=" & $aRomList[$vBoucle][4], $vXMLRom)
	If (StringInStr(FileReadLine($aRomList[$vBoucle][8]), "Erreur") Or Not FileExists($aRomList[$vBoucle][8])) Then
		_LOG("http://www.screenscraper.fr/api/jeuInfos.php?devid=" & $iDevId & "&devpassword=" & $iDevPassword & "&softname=" & $iSoftname & "&output=xml&crc=&md5=&sha1=&systemeid=" & $vSystemID & "&romtype=rom&romnom=" & $aRomList[$vBoucle][2] & "&romtaille=" & $aRomList[$vBoucle][4], 3)
		$aRomList[$vBoucle][8] = _DownloadWRetry("http://www.screenscraper.fr/api/jeuInfos.php?devid=" & $iDevId & "&devpassword=" & $iDevPassword & "&softname=" & $iSoftname & "&output=xml&crc=&md5=&sha1=&systemeid=" & $vSystemID & "&romtype=rom&romnom=" & $aRomList[$vBoucle][2] & "&romtaille=" & $aRomList[$vBoucle][4], $vXMLRom)
		If (StringInStr(FileReadLine($aRomList[$vBoucle][8]), "Erreur") Or Not FileExists($aRomList[$vBoucle][8])) Then
			FileDelete($aRomList[$vBoucle][8])
			$aRomList[$vBoucle][8] = ""
			$aRomList[$vBoucle][9] = 0
			Return $aRomList
		EndIf
	EndIf
	$aRomList[$vBoucle][9] = 1
	Return $aRomList
EndFunc   ;==>_DownloadROMXML

Func _SelectSystem($oXMLSystem, $vFullScrape = 0)
	Local $vSystem, $vSystemID, $vSystemTEMP
	Local $aSystemListTXT, $aSystemListXML
	Local $vRechSYS = IniRead($iINIPath, "GENERAL", "$vRechSYS", 1)

	$aSystemListXML = _XML_ListValue("Data/systeme/noms/*", "", $oXMLSystem)
;~ 	_ArrayDisplay($aSystemListXML, "$aSystemListXML") ;Debug
	_ArrayColInsert($aSystemListXML, 1)
	_ArrayColInsert($aSystemListXML, 1)
	_ArrayDelete($aSystemListXML, 0)

	For $vBoucle = 0 To UBound($aSystemListXML) - 1
		$aSystemListXML[$vBoucle][1] = _XML_Read('Data/systeme[noms/* = "' & $aSystemListXML[$vBoucle][0] & '"]/id', 0, "", $oXMLSystem)
		$aSystemListXML[$vBoucle][2] = $aSystemListXML[$vBoucle][1]
	Next
	_ArraySort($aSystemListXML)
;~ 	_ArrayDisplay($aSystemListXML, "$aSystemListXML") ;Debug

	If $vRechSYS = 1 Then
		_FileReadToArray($iRessourcesPath & "\systemlist.txt", $aSystemListTXT, $FRTA_NOCOUNT, "|")
;~ 		_ArrayDisplay($aSystemListTXT, "$aSystemListTXT") ;Debug
		$vSystem = StringSplit(IniRead($iINIPath, "LAST_USE", "$vSource_RomPath", ""), "\")
		$vSystem = StringLower($vSystem[UBound($vSystem) - 1])
		$iSystem = _ArraySearch($aSystemListTXT, $vSystem)
		_LOG("Search " & $vSystem & " in $aSystemListTXT = " & $iSystem, 3)
		If $iSystem > 0 Then
			$vSystemTEMP = $aSystemListTXT[$iSystem][1]
			$iSystem = _ArraySearch($aSystemListXML, $vSystemTEMP)
			_LOG("Search " & $vSystemTEMP & " in $aSystemListXML = " & $iSystem, 3)
			If $iSystem > 0 Then
				_LOG("System detected : " & $aSystemListXML[$iSystem][0] & "(" & $aSystemListXML[$iSystem][1] & ")")
				Return $aSystemListXML[$iSystem][1]
			EndIf
		EndIf
		_LOG("No system found for : " & $vSystem)
		If $vFullScrape = 1 Then Return ""
	EndIf

	$vSystemID = _SelectGUI($aSystemListXML, "", "system")
	_LOG("System selected No " & $vSystemID)
	Return $vSystemID

EndFunc   ;==>_SelectSystem

Func _Game_Make($aRomList, $vBoucle, $aConfig, $oXMLProfil)
	Local $vValue
	_XML_WriteValue("//" & _XML_Read("Profil/Game/Target_Value", 0, "", $oXMLProfil), "", "", $aConfig[8])
	$vWhile = 1
	While 1
		Switch _XML_Read("/Profil/Element[" & $vWhile & "]/Target_Type", 0, "", $oXMLProfil)
			Case "XML_Value"
				$vValue = _XML_Read_Source($aRomList, $vBoucle, $aConfig, $oXMLProfil, $vWhile)
				_XML_WriteValue(_XML_Read("/Profil/Element[" & $vWhile & "]/Target_Value", 0, "", $oXMLProfil), $vValue, "", $aConfig[8])
			Case "XML_Attribute"
				$vValue = _XML_Read_Source($aRomList, $vBoucle, $aConfig, $oXMLProfil, $vWhile)
				$vAttributeName = _XML_Read("/Profil/Element[" & $vWhile & "]/Target_Attribute_Name", 0, "", $oXMLProfil)
				_XML_WriteAttributs(_XML_Read("/Profil/Element[" & $vWhile & "]/Target_Value", 0, "", $oXMLProfil), $vAttributeName, $vValue, "", $aConfig[8])
			Case "XML_Path"
				$vValue = _XML_Read_Source($aRomList, $vBoucle, $aConfig, $oXMLProfil, $vWhile)
				If $vValue <> -1 Then _XML_WriteValue(_XML_Read("/Profil/Element[" & $vWhile & "]/Target_Value", 0, "", $oXMLProfil), $vValue, "", $aConfig[8])
			Case "XML_Value_FORMAT"
				$vValue = _XML_Read_Source($aRomList, $vBoucle, $aConfig, $oXMLProfil, $vWhile)
				Switch _XML_Read("/Profil/Element[" & $vWhile & "]/Target_FORMAT", 0, "", $oXMLProfil)
					Case '%20on1%'
						$vValue = StringReplace(Round(($vValue * 100 / 20) / 100, 2), ",", ".")
					Case '%ES_Date%'
						$vValue = StringLeft(StringReplace($vValue, "-", "") & '00000000', 8) & "T000000"
				EndSwitch
				_XML_WriteValue(_XML_Read("/Profil/Element[" & $vWhile & "]/Target_Value", 0, "", $oXMLProfil), $vValue, "", $aConfig[8])
			Case Else
				_LOG("End Of Elements", 3)
				ExitLoop
		EndSwitch
		$vWhile = $vWhile + 1
	WEnd
	Return $aRomList
EndFunc   ;==>_Game_Make

Func _XML_Read_Source($aRomList, $vBoucle, $aConfig, $oXMLProfil, $vWhile)
	Local $vXpath, $vValue
	Switch _XML_Read("/Profil/Element[" & $vWhile & "]/Source_Type", 0, "", $oXMLProfil)
		Case "XML_Value"
			If $aRomList[$vBoucle][9] = 0 Then Return ""
			$vXpath = _XML_Read("/Profil/Element[" & $vWhile & "]/Source_Value", 0, "", $oXMLProfil)

			If StringInStr($vXpath, '%LANG%') Then
				Local $aLangPref = $aConfig[9]
				For $vBoucle2 = 1 To UBound($aLangPref) - 1
					$vXpathTemp = StringReplace($vXpath, '%LANG%', $aLangPref[$vBoucle2])
					$vValue = _XML_Read($vXpathTemp, 0, $aRomList[$vBoucle][8])
					If $vValue <> -1 And $vValue <> "" Then Return $vValue
				Next
			EndIf

			$aXpathCountry = _CountryArray_Make($aConfig, $vXpath, $aRomList[$vBoucle][8], $oXMLProfil)
			For $vBoucle2 = 1 To UBound($aXpathCountry) - 1
				$vValue = _XML_Read($aXpathCountry[$vBoucle2], 0, $aRomList[$vBoucle][8])
				If $vValue <> -1 And $vValue <> "" Then Return $vValue
			Next

			Return ""

		Case "XML_Attribute"
			If $aRomList[$vBoucle][9] = 0 Then Return ""
			Return _XML_Read(_XML_Read("/Profil/Element[" & $vWhile & "]/Source_Value", 1, "", $oXMLProfil), 0, $aRomList[$vBoucle][8])
		Case "XML_Download"
			If $aRomList[$vBoucle][9] = 0 Then Return ""
			$vXpath = _XML_Read("/Profil/Element[" & $vWhile & "]/Source_Value", 0, "", $oXMLProfil)
			$aXpathCountry = _CountryArray_Make($aConfig, $vXpath, $aRomList[$vBoucle][8], $oXMLProfil)
			For $vBoucle2 = 1 To UBound($aXpathCountry) - 1
				$vValue = _Picture_Download($aXpathCountry[$vBoucle2], $aRomList, $vBoucle, $vWhile, $oXMLProfil, $aConfig[4], $aConfig[3])
				Select
					Case $vValue = -2
						Return -1
					Case $vValue <> -1
						Return $vValue
				EndSelect
			Next
			Return ""
		Case "Fixe_Value"
			Return _XML_Read("/Profil/Element[" & $vWhile & "]/Source_Value", 0, "", $oXMLProfil)
		Case "Variable_Value"
			Switch _XML_Read("/Profil/Element[" & $vWhile & "]/Source_Value", 0, "", $oXMLProfil)
				Case '%XML_Rom_Path%'
					Return $aConfig[2] & StringReplace($aRomList[$vBoucle][0], "\", "/")
				Case Else
					_LOG("SOURCE Unknown", 3)
					Return ""
			EndSwitch
		Case "MIX_Template"
			If $aRomList[$vBoucle][9] = 0 Then Return ""
			Local $vDownloadTag, $vDownloadExt, $vTargetPicturePath, $aPathSplit, $sDrive, $sDir, $sFileName, $sExtension
			$vDownloadTag = _XML_Read("/Profil/Element[" & $vWhile & "]/Source_Download_Tag", 0, "", $oXMLProfil)
			$vDownloadExt = _XML_Read("/Profil/Element[" & $vWhile & "]/Source_Download_Ext", 0, "", $oXMLProfil)
			$aPathSplit = _PathSplit(StringReplace($aRomList[$vBoucle][0], "\", "_"), $sDrive, $sDir, $sFileName, $sExtension)
			$vTargetPicturePath = $aConfig[4] & $sFileName & $vDownloadTag & "." & $vDownloadExt
			Switch _XML_Read("/Profil/Element[" & $vWhile & "]/Source_Download_Path", 0, "", $oXMLProfil)
				Case '%Local_Path_File%'
					$vDownloadPath = $aConfig[3] & "\" & $sFileName & $vDownloadTag & "." & $vDownloadExt
				Case Else
					$vDownloadPath = $aConfig[3] & "\" & $sFileName & $vDownloadTag & "." & $vDownloadExt
			EndSwitch
			If FileExists($vDownloadPath) Then Return $vTargetPicturePath

			$vValue = _MIX_Engine($aRomList, $vBoucle, $aConfig, $oXMLProfil)
			If Not FileExists($vValue) Then Return -1
			FileCopy($vValue, $vDownloadPath, $FC_OVERWRITE)

			_LOG("MIX Template finished (" & $vTargetPicturePath & ")", 1)
			Return $vTargetPicturePath
		Case Else
			_LOG("SOURCE Unknown", 3)
			Return ""
	EndSwitch
EndFunc   ;==>_XML_Read_Source

Func _CountryArray_Make($aConfig, $vXpath, $vSource_RomXMLPath, $oXMLProfil)
	Local $vCountryPref, $vXpathCountry, $iCountryPref
	If StringInStr($vXpath, '%COUNTRY%') Then
		Local $aCountryPref = $aConfig[10]
	Else
		Local $aCountryPref[2] = ["", $vXpath]
	EndIf
;~ 	_ArrayDisplay($aCountryPref, "$aCountryPref")

	Local $aMatchingCountry = $aConfig[11]
	Local $aXpathCountry[UBound($aCountryPref)]
	For $vBoucle = 1 To UBound($aCountryPref) - 1
		$vCountryPref = $aCountryPref[$vBoucle]
		If $vCountryPref = '%COUNTRY%' Then
			$vXpathCountry = _XML_Read("/Profil/Country/Source_Value", 0, "", $oXMLProfil)
			$vCountryPref = _XML_Read($vXpathCountry, 0, $vSource_RomXMLPath)
			$iCountryPref = _ArraySearch($aMatchingCountry, $vCountryPref)
			If $iCountryPref > 0 Then
				$vCountryPref = $aMatchingCountry[$iCountryPref][1]
			Else
				$vCountryPref = ""
			EndIf
		EndIf
		$aXpathCountry[$vBoucle] = StringReplace($vXpath, '%COUNTRY%', $vCountryPref)
	Next
	Return $aXpathCountry
EndFunc   ;==>_CountryArray_Make

Func _Picture_Download($vCountryPref, $aRomList, $vBoucle, $vWhile, $oXMLProfil, $vTarget_ImagePath, $vSource_ImagePath)
	Local $vDownloadURL, $vDownloadTag, $vDownloadExt, $vTargetPicturePath, $aPathSplit, $sDrive, $sDir, $sFileName, $sExtension
	$vDownloadURL = _XML_Read($vCountryPref, 0, $aRomList[$vBoucle][8])
	$vDownloadTag = _XML_Read("/Profil/Element[" & $vWhile & "]/Source_Download_Tag", 0, "", $oXMLProfil)
	$vDownloadExt = _XML_Read("/Profil/Element[" & $vWhile & "]/Source_Download_Ext", 0, "", $oXMLProfil)
	$aPathSplit = _PathSplit(StringReplace($aRomList[$vBoucle][0], "\", "_"), $sDrive, $sDir, $sFileName, $sExtension)
	$vTargetPicturePath = $vTarget_ImagePath & $sFileName & $vDownloadTag & "." & $vDownloadExt
	If $vDownloadExt = "%Source%" Then $vDownloadExt = StringRight($vDownloadURL, 3)
	$vDownloadURL = StringTrimRight($vDownloadURL, 3) & $vDownloadExt
	Switch _XML_Read("/Profil/Element[" & $vWhile & "]/Source_Download_Path", 0, "", $oXMLProfil)
		Case '%Local_Path_File%'
			$vDownloadPath = $vSource_ImagePath & "\" & $sFileName & $vDownloadTag & "." & $vDownloadExt
		Case Else
			$vDownloadPath = $vSource_ImagePath & "\" & $sFileName & $vDownloadTag & "." & $vDownloadExt
	EndSwitch

	$vCheckExist = _XML_Read(_XML_Read('/Profil/Game/Target_Value', 0, "", $oXMLProfil) & '[* = "' & $vTargetPicturePath & '"]', 0, "", $aConfig[8])
	If $vCheckExist = -1 Then Return -2

	If FileExists($vDownloadPath) Then Return $vTargetPicturePath

	$vValue = _DownloadWRetry($vDownloadURL, $vDownloadPath)
	If $vValue <> -1 And $vValue <> "" Then
		Return $vTargetPicturePath
	Else
		Return -1
	EndIf
EndFunc   ;==>_Picture_Download

Func _MIX_Engine($aRomList, $vBoucle, $aConfig, $oXMLProfil)
	Local $vMIXTemplatePath = "C:\Developpement\Github\Universal-XML-Scraper2\Mix\Background (Modified DarKade-Theme by Nachtgarm)\"
	Local $oMixConfig = _XML_Open($vMIXTemplatePath & "config.xml")
	Local $vTarget_Width = _XML_Read("/Profil/General/Target_Width", 0, "", $oMixConfig)
	Local $vTarget_Height = _XML_Read("/Profil/General/Target_Height", 0, "", $oMixConfig)
	Local $vPicTarget = -1, $vWhile = 1
	Dim $aMiXPicTemp[1]
	FileDelete($iTEMPPath & "\MIX")
	While 1
		Switch StringLower(_XML_Read("/Profil/Element[" & $vWhile & "]/Source_Type", 0, "", $oMixConfig))
			Case "fixe_value"
				$vPicTarget = $iTEMPPath & "\MIX\" & _XML_Read("/Profil/Element[" & $vWhile & "]/Name", 0, "", $oMixConfig) & ".png"
				FileCopy($vMIXTemplatePath & _XML_Read("/Profil/Element[" & $vWhile & "]/Source_Value", 0, "", $oMixConfig), $vPicTarget, $FC_OVERWRITE + $FC_CREATEPATH)
				$aPicParameters = _MIX_Engine_Dim($vWhile, $oMixConfig)
				_GDIPlus_Imaging($vPicTarget, $aPicParameters, $vTarget_Width, $vTarget_Height)
				_LOG($vPicTarget & " Created", 1)
				_ArrayAdd($aMiXPicTemp, $vPicTarget)
			Case "xml_value"
				$vPicTarget = $iTEMPPath & "\MIX\" & _XML_Read("/Profil/Element[" & $vWhile & "]/Name", 0, "", $oMixConfig) & ".png"
				$vXpath = _XML_Read("/Profil/Element[" & $vWhile & "]/Source_Value", 0, "", $oMixConfig)
				$vOrigin = StringLower(_XML_Read("/Profil/Element[" & $vWhile & "]/source_Origin", 0, "", $oMixConfig))
				If $vOrigin = -1 Then $vOrigin = 'game'
				$aPicParameters = _MIX_Engine_Dim($vWhile, $oMixConfig)
				$aXpathCountry = _CountryArray_Make($aConfig, $vXpath, $aRomList[$vBoucle][8], $oMixConfig)
				For $vBoucle2 = 1 To UBound($aXpathCountry) - 1
					Switch $vOrigin
						Case 'game'
							$vDownloadURL = StringTrimRight(_XML_Read($aXpathCountry[$vBoucle2], 0, $aRomList[$vBoucle][8]), 3) & "png"
							If $vDownloadURL <> "png" And Not FileExists($vPicTarget) Then
								$vValue = _DownloadWRetry($vDownloadURL, $vPicTarget)
								_GDIPlus_Imaging($vPicTarget, $aPicParameters, $vTarget_Width, $vTarget_Height)
								_ArrayAdd($aMiXPicTemp, $vPicTarget)
								_LOG($vPicTarget & " Created", 1)
							EndIf
						Case 'system'
							$vDownloadURL = StringTrimRight(_XML_Read($aXpathCountry[$vBoucle2], 0, "", $oXMLSystem), 3) & "png"
							If $vDownloadURL <> "png" And Not FileExists($vPicTarget) Then
								$vValue = _DownloadWRetry($vDownloadURL, $vPicTarget)
								_GDIPlus_Imaging($vPicTarget, $aPicParameters, $vTarget_Width, $vTarget_Height)
								_ArrayAdd($aMiXPicTemp, $vPicTarget)
								_LOG($vPicTarget & " Created", 1)
							EndIf
					EndSwitch
				Next

			Case 'gdi_function'
				Switch StringLower(_XML_Read("/Profil/Element[" & $vWhile & "]/Source_Function", 0, "", $oMixConfig))
					Case 'transparency'
						$aPicParameters = _MIX_Engine_Dim($vWhile, $oMixConfig)
						$vTransLvl = _XML_Read("/Profil/Element[" & $vWhile & "]/Source_Value", 0, "", $oMixConfig)
						$vPath = $aMiXPicTemp[UBound($aMiXPicTemp) - 1]
						If _GDIPlus_Transparency($vPath, $vTransLvl) = -1 Then _LOG("Transparency Failed", 2)
					Case 'merge'
						If _GDIPlus_Merge($aMiXPicTemp[UBound($aMiXPicTemp) - 2], $aMiXPicTemp[UBound($aMiXPicTemp) - 1]) = -1 Then _LOG("Merging Failed", 2)
						_ArrayDelete($aMiXPicTemp, UBound($aMiXPicTemp) - 1)
					Case 'transparencyzone'
						$aPicParameters = _MIX_Engine_Dim($vWhile, $oMixConfig)
						$vTransLvl = _XML_Read("/Profil/Element[" & $vWhile & "]/Source_Value", 0, "", $oMixConfig)
						$vPath = $aMiXPicTemp[UBound($aMiXPicTemp) - 1]
						If _GDIPlus_TransparencyZone($vPath, $vTarget_Width, $vTarget_Height, $vTransLvl, $aPicParameters[2], $aPicParameters[3], $aPicParameters[0], $aPicParameters[1]) = -1 Then _LOG("Transparency Failed", 2)
					Case Else
						_LOG("Unknown GDI_Function", 2)
				EndSwitch
			Case Else
				_LOG("End Of Elements", 3)
				ExitLoop
		EndSwitch
		$vWhile = $vWhile + 1
	WEnd

	For $vBoucle2 = UBound($aMiXPicTemp) - 1 To 2 Step -1
		If FileExists($aMiXPicTemp[$vBoucle2 - 1]) Then _GDIPlus_Merge($aMiXPicTemp[$vBoucle2 - 1], $aMiXPicTemp[$vBoucle2])
	Next

	$vpngquant = _XML_Read("/Profil/pngquant/use", 0, "", $oMixConfig)
	$vpngquantparameter = _XML_Read("/Profil/pngquant/parameter", 0, "", $oMixConfig)
	If StringLower($vpngquant) = 'yes' Then _PNGQuant($aMiXPicTemp[1], $vpngquantparameter)

	Return $aMiXPicTemp[1]
EndFunc   ;==>_MIX_Engine

Func _MIX_Engine_Dim($vWhile, $oMixConfig)
	Dim $aPicParameters[9]
	$aPicParameters[0] = _XML_Read("/Profil/Element[" & $vWhile & "]/Target_Width", 0, "", $oMixConfig)
	$aPicParameters[1] = _XML_Read("/Profil/Element[" & $vWhile & "]/Target_Height", 0, "", $oMixConfig)
	$aPicParameters[2] = _XML_Read("/Profil/Element[" & $vWhile & "]/Target_TopLeftX", 0, "", $oMixConfig)
	$aPicParameters[3] = _XML_Read("/Profil/Element[" & $vWhile & "]/Target_TopLeftY", 0, "", $oMixConfig)
	$aPicParameters[4] = _XML_Read("/Profil/Element[" & $vWhile & "]/Target_TopRightX", 0, "", $oMixConfig)
	$aPicParameters[5] = _XML_Read("/Profil/Element[" & $vWhile & "]/Target_TopRightY", 0, "", $oMixConfig)
	$aPicParameters[6] = _XML_Read("/Profil/Element[" & $vWhile & "]/Target_BottomLeftX", 0, "", $oMixConfig)
	$aPicParameters[7] = _XML_Read("/Profil/Element[" & $vWhile & "]/Target_BottomLeftY", 0, "", $oMixConfig)
	$aPicParameters[8] = _XML_Read("/Profil/Element[" & $vWhile & "]/Target_Maximize", 0, "", $oMixConfig)
	Return $aPicParameters
EndFunc   ;==>_MIX_Engine_Dim

#EndRegion Function

;~ 	$aPicParameters[0] = Target_Width
;~ 	$aPicParameters[1] = Target_Height
;~ 	$aPicParameters[2] = Target_TopLeftX
;~ 	$aPicParameters[3] = Target_TopLeftY
;~ 	$aPicParameters[4] = Target_TopRightX
;~ 	$aPicParameters[5] = Target_TopRightY
;~ 	$aPicParameters[6] = Target_BottomLeftX
;~ 	$aPicParameters[7] = Target_BottomLeftY
;~ 	$aPicParameters[8] = Target_Maximize

;~ 	$aConfig[0]=$vTarget_XMLName
;~ 	$aConfig[1]=$vSource_RomPath
;~ 	$aConfig[2]=$vTarget_RomPath
;~ 	$aConfig[3]=$vSource_ImagePath
;~ 	$aConfig[4]=$vTarget_ImagePath
;~ 	$aConfig[5]=$vScrape_Mode (0 = NEW, 1 = Update XML & Picture, [2 = Update Picture only To ADD])
;~ 	$aConfig[6]=$MissingRom_Mode (0 = No missing Rom, 1 = Adding missing Rom)
;~ 	$aConfig[7]=$CountryPic_Mode (0 = Language Pic, 1 = Rom Pic, 2 = Language Pic Strict, 3 = Rom Pic Strict)
;~ 	$aConfig[8]=$oTarget_XML
;~ 	$aConfig[9]=$aLangPref
;~ 	$aConfig[10]=$aCountryPref
;~ 	$aConfig[11]=$aMatchingCountry

;~ 	$aRomList[][0]=Relative Path
;~ 	$aRomList[][1]=Full Path
;~ 	$aRomList[][2]=Filename (without extension)
;~ 	$aRomList[][3]=XML to Scrape (0 = No, 1 = Yes)
;~ 	$aRomList[][4]=File Size
;~ 	$aRomList[][5]=File CRC32
;~ 	$aRomList[][6]=File MD5
;~ 	$aRomList[][7]=File SHA1
;~ 	$aRomList[][8]=XML File Scraped
;~ 	$aRomList[][9]=Rom Found
;~ 	$aRomList[][10]=Time By Rom

