#Region ;**** Directives created by AutoIt3Wrapper_GUI ****
#AutoIt3Wrapper_Icon=Ressources\Universal_Xml_Scraper.ico
#AutoIt3Wrapper_Outfile=.\Universal_XML_Scraper.exe
#AutoIt3Wrapper_Outfile_x64=.\Universal_XML_Scraper64.exe
#AutoIt3Wrapper_Compile_Both=y
#AutoIt3Wrapper_UseX64=y
#AutoIt3Wrapper_Res_Description=Scraper XML Universel
#AutoIt3Wrapper_Res_Fileversion=2.0.0.0
#AutoIt3Wrapper_Res_Fileversion_AutoIncrement=p
#AutoIt3Wrapper_Res_LegalCopyright=LEGRAS David
#AutoIt3Wrapper_Res_Language=1036
#AutoIt3Wrapper_AU3Check_Stop_OnWarning=y
#AutoIt3Wrapper_Run_Tidy=y
#Tidy_Parameters=/reel
#AutoIt3Wrapper_Run_Before=ShowOriginalLine.exe %in%
#AutoIt3Wrapper_Run_After=ShowOriginalLine.exe %in%
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
Global $iLOGPath = $iScriptPath & "\LOGs\log.txt"
Global $iVerboseLVL = IniRead($iINIPath, "GENERAL", "$vVerbose", 0)
Global $MS_AutoConfigItem

;Personnal Librairy definitions
;---------------------------

#include "./Include/_MultiLang.au3"
#include "./Include/_ExtMsgBox.au3"
#include "./Include/_Trim.au3"
#include "./Include/_Hash.au3"
#include "./Include/_zip.au3"
#include "./Include/_XML.au3"
#include "./Include/MailSlot.au3"
#include "./Include/_GraphGDIPlus.au3"
#include "./Include/_MyFunction.au3"
#include "./Include/_AutoItErrorTrap.au3"

_AutoItErrorTrap("Main Module", "Hi!" & @CRLF & @CRLF & "An error was detected in the program, you can try again," & _
		" cancel to exit or continue to see more details of the error." & @CRLF & @CRLF & "Sorry for the inconvenience!")

;Checking Version
;----------------
_LOG_Ceation($iLOGPath) ; Starting Log

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
		_LOG("Update file needed from version " & $iINIVer & " to " & $iScriptVer, 1, $iLOGPath)
	Else
		_LOG("No updated files needed (Version : " & $iScriptVer & ")", 1, $iLOGPath)
	EndIf
Else
	Local $iScriptVer = 'In Progress'
	Local $iINIVer = IniRead($iINIPath, "GENERAL", "$verINI", '0.0.0.0')
	Local $iSoftname = "UniversalXMLScraper(TestDev)"
	_LOG("Dev version", 1, $iLOGPath)
EndIf

#Region FileInstall
_LOG("Starting files installation", 0, $iLOGPath)
DirCreate($iScriptPath & "\LanguageFiles")
DirCreate($iScriptPath & "\Ressources")
DirCreate($iScriptPath & "\Mix")
DirCreate($iScriptPath & "\Mix\TEMP")
DirCreate($iScriptPath & "\ProfilsFiles")
DirCreate($iScriptPath & "\ProfilsFiles\Ressources")
FileInstall(".\UXS-config.ini", $iScriptPath & "\UXS-config.ini")
FileInstall(".\LanguageFiles\UXS-ENGLISH.XML", $iScriptPath & "\LanguageFiles\UXS-ENGLISH.XML")
FileInstall(".\LanguageFiles\UXS-FRENCH.XML", $iScriptPath & "\LanguageFiles\UXS-FRENCH.XML")
FileInstall(".\LanguageFiles\UXS-PORTUGUESE.XML", $iScriptPath & "\LanguageFiles\UXS-PORTUGUESE.XML")
FileInstall(".\LanguageFiles\UXS-GERMAN.XML", $iScriptPath & "\LanguageFiles\UXS-GERMAN.XML")
FileInstall(".\LanguageFiles\UXS-SPANISH.XML", $iScriptPath & "\LanguageFiles\UXS-SPANISH.XML")
;~ FileInstall(".\Ressources\empty.jpg", $iScriptPath & "\Ressources\empty.jpg")
;~ FileInstall(".\Ressources\emptySYS.jpg", $iScriptPath & "\Ressources\emptySYS.jpg")
;~ FileInstall(".\Ressources\Fleche.jpg", $iScriptPath & "\Ressources\Fleche.jpg")
;~ FileInstall(".\Ressources\Fleche_DISABLE.bmp", $iScriptPath & "\Ressources\Fleche_DISABLE.bmp")
;~ FileInstall(".\Ressources\Fleche_ENABLE.bmp", $iScriptPath & "\Ressources\Fleche_ENABLE.bmp")
;~ FileInstall(".\Ressources\Fleche_IP1.bmp", $iScriptPath & "\Ressources\Fleche_IP1.bmp")
;~ FileInstall(".\Ressources\Fleche_IP2.bmp", $iScriptPath & "\Ressources\Fleche_IP2.bmp")
FileInstall(".\Ressources\plink.exe", $iScriptPath & "\Ressources\plink.exe")
FileInstall(".\Ressources\optipng.exe", $iScriptPath & "\Ressources\optipng.exe")
FileInstall(".\Ressources\pngquant.exe", $iScriptPath & "\Ressources\pngquant.exe")
FileInstall(".\Ressources\LICENSE optipng.txt", $iScriptPath & "\Ressources\LICENSE optipng.txt")
FileInstall(".\Ressources\LICENSE pngquant.txt", $iScriptPath & "\Ressources\LICENSE pngquant.txt")
FileInstall(".\Ressources\LICENSE plink.txt", $iScriptPath & "\Ressources\LICENSE plink.txt")
FileInstall(".\Ressources\systemlist.txt", $iScriptPath & "\Ressources\systemlist.txt")
FileInstall(".\Ressources\regionlist.txt", $iScriptPath & "\Ressources\regionlist.txt")
FileInstall(".\Ressources\UXS.jpg", $iScriptPath & "\Ressources\UXS.jpg")
FileInstall(".\Ressources\UXS Wizard.jpg", $iScriptPath & "\Ressources\UXS Wizard.jpg")
FileInstall(".\Ressources\jingle_uxs.MP3", $iScriptPath & "\Ressources\jingle_uxs.MP3")
FileInstall(".\Mix\Arcade (moon).zip", $iScriptPath & "\Mix\")
FileInstall(".\Mix\Arcade Zoomed (moon).zip", $iScriptPath & "\Mix\")
FileInstall(".\Mix\Full Back.zip", $iScriptPath & "\Mix\")
FileInstall(".\Mix\Standard (3img).zip", $iScriptPath & "\Mix\")
FileInstall(".\Mix\Standard (4img).zip", $iScriptPath & "\Mix\")
;~ FileInstall(".\Mix\Oldtv (Multi Sys).zip", $iScriptPath & "\Mix\")
;~ FileInstall(".\Mix\Standard (3img).zip", $iScriptPath & "\Mix\")
;~ FileInstall(".\Mix\Standard (4img)  By Supernature2k.zip", $iScriptPath & "\Mix\")
FileInstall(".\ProfilsFiles\Screenscraper(MIX)-RecalboxV4.xml", $iScriptPath & "\ProfilsFiles\", 0)
FileInstall(".\ProfilsFiles\Screenscraper(MIX)-RecalboxV3.xml", $iScriptPath & "\ProfilsFiles\", 0)
FileInstall(".\ProfilsFiles\Screenscraper(MIX)-Retropie.xml", $iScriptPath & "\ProfilsFiles\", 0)
FileInstall(".\ProfilsFiles\Screenscraper-RecalboxV4.xml", $iScriptPath & "\ProfilsFiles\", 0)
FileInstall(".\ProfilsFiles\Screenscraper-RecalboxV3.xml", $iScriptPath & "\ProfilsFiles\", 0)
FileInstall(".\ProfilsFiles\Screenscraper-Retropie.xml", $iScriptPath & "\ProfilsFiles\", 0)
;~ FileInstall(".\ProfilsFiles\Ressources\Attract-Mode.jpg", $iScriptPath & "\ProfilsFiles\Ressources\", 0)
FileInstall(".\ProfilsFiles\Ressources\empty.jpg", $iScriptPath & "\ProfilsFiles\Ressources\", 0)
;~ FileInstall(".\ProfilsFiles\Ressources\Emulationstation.jpg", $iScriptPath & "\ProfilsFiles\Ressources\", 0)
;~ FileInstall(".\ProfilsFiles\Ressources\Hyperspin.jpg", $iScriptPath & "\ProfilsFiles\Ressources\", 0)
FileInstall(".\ProfilsFiles\Ressources\Screenscraper(MIX)-RecalboxV4.jpg", $iScriptPath & "\ProfilsFiles\Ressources\", 0)
FileInstall(".\ProfilsFiles\Ressources\Screenscraper(MIX)-RecalboxV3.jpg", $iScriptPath & "\ProfilsFiles\Ressources\", 0)
FileInstall(".\ProfilsFiles\Ressources\Screenscraper(MIX)-Retropie.jpg", $iScriptPath & "\ProfilsFiles\Ressources\", 0)
FileInstall(".\ProfilsFiles\Ressources\Screenscraper-RecalboxV4.jpg", $iScriptPath & "\ProfilsFiles\Ressources\", 0)
FileInstall(".\ProfilsFiles\Ressources\Screenscraper-RecalboxV3.jpg", $iScriptPath & "\ProfilsFiles\Ressources\", 0)
FileInstall(".\ProfilsFiles\Ressources\Screenscraper-Retropie.jpg", $iScriptPath & "\ProfilsFiles\Ressources\", 0)
FileInstall(".\Scraper.exe", $iScriptPath & "\Scraper.exe", 0)
FileInstall(".\Scraper64.exe", $iScriptPath & "\Scraper64.exe", 0)
_LOG("Ending files installation", 1, $iLOGPath)

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
Global $iMIXPath = $iScriptPath & "\Mix" ; Where we are storing the MIX files.
Global $iPathMixTmp = $iMIXPath & "\TEMP" ; Where we are storing the current MIX files.

If @OSArch = "X64" Then
	_LOG("Scrape in x64", 0, $iLOGPath)
	Local $iScraper = "Scraper64.exe"
Else
	_LOG("Scrape in x86", 0, $iLOGPath)
	Local $iScraper = "Scraper.exe"
EndIf

_LOG("Verbose LVL : " & $iVerboseLVL, 1, $iLOGPath)
_LOG("Path to ini : " & $iINIPath, 1, $iLOGPath)
_LOG("Path to log : " & $iLOGPath, 1, $iLOGPath)
_LOG("Path to language : " & $iLangPath, 1, $iLOGPath)

;Variable def
;------------
Global $vUserLang = IniRead($iINIPath, "LAST_USE", "$vUserLang", -1)
Global $MP_, $aPlink_Command, $vScrapeCancelled
Global $vProfilsPath = IniRead($iINIPath, "LAST_USE", "$vProfilsPath", -1)
Local $vXpath2RomPath, $vFullTimer, $vRomTimer, $aPlink_Command, $vSelectedProfil = -1
Local $L_SCRAPE_Parts[3] = [300, 480, -1]
Local $oXMLProfil, $oXMLSystem
Local $aConfig, $aRomList, $aXMLRomList
Local $nMsg
Local $sMailSlotMother = "\\.\mailslot\Mother"
Local $sMailSlotCancel = "\\.\mailslot\Cancel"
Local $hMailSlotMother = _CreateMailslot($sMailSlotMother)
Local $vNbThread = IniRead($iINIPath, "LAST_USE", "$vNbThread", 1)
Local $vStart = 0

;---------;
;Principal;
;---------;

; Loading language
Local $aLangList = _MultiLang_LoadLangDef($iLangPath, $vUserLang)
If Not IsArray($aLangList) Or $aLangList < 0 Then
	_LOG("Impossible to load language", 2, $iLOGPath)
	Exit
EndIf
;~ _ArrayDisplay($aLangList, "$aLangList") ;Debug

; Update Checking
_LOG("Update Checking", 1, $iLOGPath)
Local $iChangelogPath = $iScriptPath & "\changelog.txt"
FileDelete($iChangelogPath)
Local $Result = _DownloadWRetry("https://raw.githubusercontent.com/Universal-Rom-Tools/Universal-XML-Scraper/master/changelog.txt", $iChangelogPath)
Switch $Result
	Case -1
		_LOG("Error downloading Changelog", 2, $iLOGPath)
	Case -2
		_LOG("Time Out downloading Changelog", 2, $iLOGPath)
	Case Else
		Local $iChangelogVer = FileReadLine($iChangelogPath)
		_LOG("Local : " & $iScriptVer & " - Github : " & $iChangelogVer, 0, $iLOGPath)
		If $iChangelogVer <> $iScriptVer And @Compiled = 1 Then
			_LOG("Asking to Update", 0, $iLOGPath)
			If MsgBox($MB_YESNO, _MultiLang_GetText("mess_update_Title") & " ( Local : " & $iScriptVer & " - Github : " & $iChangelogVer & " )", _MultiLang_GetText("mess_update_Question")) = $IDYES Then
				_LOG("Open GitHub Release Webpage and quit", 0, $iLOGPath)
				ShellExecute("https://github.com/Universal-Rom-Tools/Universal-XML-Scraper/releases")
				Exit
			Else
				_LOG("NOT UPDATED", 0, $iLOGPath)
			EndIf
		EndIf
EndSwitch

;Catching SystemList.xml
$oXMLSystem = _XMLSystem_Create()
If $oXMLSystem = -1 Then Exit

;Delete Splascreen
GUIDelete($F_Splashcreen)

#Region ### START Koda GUI section ### Form=
Local $F_UniversalScraper = GUICreate(_MultiLang_GetText("main_gui"), 601, 370)
GUISetBkColor(0x34495c, $F_UniversalScraper)
Local $MF = GUICtrlCreateMenu(_MultiLang_GetText("mnu_file"))
Local $MF_Separation = GUICtrlCreateMenuItem("", $MF)
Local $MF_Exit = GUICtrlCreateMenuItem(_MultiLang_GetText("mnu_file_exit"), $MF)

Local $MC = GUICtrlCreateMenu(_MultiLang_GetText("mnu_cfg"))
Local $MC_Wizard = GUICtrlCreateMenuItem(_MultiLang_GetText("mnu_cfg_Wizard"), $MC)
Local $MC_Separation = GUICtrlCreateMenuItem("", $MC)
Local $MC_Config_LU = GUICtrlCreateMenuItem(_MultiLang_GetText("mnu_cfg_config_LU"), $MC)
Local $MC_config_autoconf = GUICtrlCreateMenuItem(_MultiLang_GetText("mnu_cfg_config_autoconf"), $MC)
Local $MC_config_Option = GUICtrlCreateMenuItem(_MultiLang_GetText("mnu_cfg_config_Option"), $MC)
Local $MC_config_PIC = GUICtrlCreateMenuItem(_MultiLang_GetText("mnu_cfg_config_PIC"), $MC)
Local $MC_config_MISC = GUICtrlCreateMenuItem(_MultiLang_GetText("mnu_cfg_config_MISC"), $MC)
Local $MC_Separation = GUICtrlCreateMenuItem("", $MC)
Local $MC_Profil = GUICtrlCreateMenuItem(_MultiLang_GetText("mnu_cfg_profil"), $MC)
Local $MC_Miximage = GUICtrlCreateMenuItem(_MultiLang_GetText("mnu_cfg_miximage"), $MC)
Local $MC_Langue = GUICtrlCreateMenuItem(_MultiLang_GetText("mnu_cfg_langue"), $MC)
;~ Local $MC_TEST = GUICtrlCreateMenuItem("TEST", $MC) ; Debug

Local $MS = GUICtrlCreateMenu(_MultiLang_GetText("mnu_scrape"))
Local $MS_AutoConfig = GUICtrlCreateMenu(_MultiLang_GetText("mnu_scrape_autoconf"), $MS, 1)
Local $MS_Scrape = GUICtrlCreateMenuItem(_MultiLang_GetText("mnu_scrape_solo"), $MS)
Local $MS_Separation = GUICtrlCreateMenuItem("", $MS)
Local $MS_FullScrape = GUICtrlCreateMenuItem(_MultiLang_GetText("mnu_scrape_fullscrape"), $MS)

Local $MP = GUICtrlCreateMenu(_MultiLang_GetText("mnu_ssh"))
GUICtrlSetState($MP, $GUI_DISABLE)
Local $MH = GUICtrlCreateMenu(_MultiLang_GetText("mnu_help"))
Local $MH_Help = GUICtrlCreateMenuItem(_MultiLang_GetText("mnu_help_about"), $MH)

Local $P_BACKGROUND = GUICtrlCreatePic($iScriptPath & "\ProfilsFiles\Ressources\empty.jpg", -1, 0, 600, 293)
Local $PB_SCRAPE = GUICtrlCreateProgress(2, 297, 478, 25)
Local $B_SCRAPE = GUICtrlCreateButton(_MultiLang_GetText("scrap_button"), 481, 296, 118, 27)
Local $L_SCRAPE = _GUICtrlStatusBar_Create($F_UniversalScraper)
_GUICtrlStatusBar_SetParts($L_SCRAPE, $L_SCRAPE_Parts)
Dim $F_UniversalScraper_AccelTable[3][2] = [["!+{DOWN}", $MC_Config_LU], ["!+{F21}", $MC_Separation], ["{VERR.MAJ}", $MS_FullScrape]]
GUISetAccelerators($F_UniversalScraper_AccelTable)
GUISetState(@SW_SHOW)
#EndRegion ### END Koda GUI section ###

$vProfilDefault = IniRead($iINIPath, "LAST_USE", "$vProfilsPath", "")
If $vProfilDefault = "" Then
	$vStart = 1
Else
	;Opening XML Profil file
	$oXMLProfil = _XML_Open($vProfilsPath)
	If $oXMLProfil = -1 Then Exit

	;Setting MIX Template
	_LOG("Setting Mix Template", 0, $iLOGPath)
	$vLastMIX = $iMIXPath & "\" & IniRead($iINIPath, "LAST_USE", "$vMixImage", "Standard (3img)") & ".zip"
	DirRemove($iPathMixTmp, 1)
	DirCreate($iPathMixTmp)
	$vResult = _Zip_UnzipAll($vLastMIX, $iPathMixTmp, 0)
	If @error Then
		Switch @error
			Case 1
				_LOG("no Zip file", 2, $iLOGPath)
			Case 2
				_LOG("no Zip dll found : " & @SystemDir & "\zipfldr.dll", 2, $iLOGPath)
			Case 3
				_LOG("Zip dll (zipfldr.dll) isn't registered", 2, $iLOGPath)
			Case Else
				_LOG("Unknown Zip Error (" & @error & ")", 2, $iLOGPath)
		EndSwitch
	EndIf
	$aDIRList = _Check_autoconf($oXMLProfil)
	_LoadConfig($oXMLProfil)
	_GUI_Refresh($oXMLProfil)
EndIf
_LOG("GUI Constructed", 1, $iLOGPath)

While 1
	$nMsg = GUIGetMsg()
	If $vStart = 1 Then
		$nMsg = $MC_Wizard
		$vStart = 0
	EndIf

	Switch $nMsg
		Case $MC_Wizard ;Wizard
			$vBoucle = 1
			$vMaxWizard = 5
			While $vBoucle < $vMaxWizard
				Switch $vBoucle
					Case 1
						$vResult = _WizardProfil()
						Switch $vResult
							Case -2
								$vBoucle = $vMaxWizard
							Case -1
								$vBoucle = $vBoucle - 1
							Case Else
								IniWrite($iINIPath, "LAST_USE", "$vProfilsPath", $vResult)
								_LOG("Wizard - Profil selected : " & $vResult, 0, $iLOGPath)
								$oXMLProfil = _XML_Open($vResult)
								If $oXMLProfil = -1 Then Exit
								;Catching SystemList.xml
								$vBoucle = $vBoucle + 1
						EndSwitch

					Case 2
						$vResult = _WizardAutoconf()
						Switch $vResult
							Case -2
								$vBoucle = $vMaxWizard
							Case -1
								$vBoucle = $vBoucle - 1
							Case Else
								_XML_Replace("Profil/AutoConf/Source_RootPath", $vResult, 0, "", $oXMLProfil)
								FileDelete($vProfilsPath)
								_XML_SaveToFile($oXMLProfil, $vProfilsPath)
								IniWrite($iINIPath, "LAST_USE", "$vAutoconf_Use", 1)
								$aDIRList = _Check_autoconf($oXMLProfil)
								IniWrite($iINIPath, "LAST_USE", "$vSource_RomPath", $aDIRList[1][1])
								IniWrite($iINIPath, "LAST_USE", "$vTarget_RomPath", $aDIRList[1][2])
								IniWrite($iINIPath, "LAST_USE", "$vTarget_XMLName", $aDIRList[1][3])
								IniWrite($iINIPath, "LAST_USE", "$vSource_ImagePath", $aDIRList[1][4])
								IniWrite($iINIPath, "LAST_USE", "$vTarget_ImagePath", $aDIRList[1][5])
								_LoadConfig($oXMLProfil)
								_GUI_Refresh($oXMLProfil)
								If IniRead($iINIPath, "LAST_USE", "$vRechFiles", 0) = 0 Then IniWrite($iINIPath, "LAST_USE", "$vRechFiles", "*.*|*.xml;*.txt;*.dv;*.fs;*.xor;*.drv;*.dat;*.cfg;*.nv;*.sav*|")
								If IniRead($iINIPath, "LAST_USE", "$vAutoconf_Use", 0) <> 0 Then $vBoucle = $vBoucle + 1
						EndSwitch
					Case 3
						If StringLower(_XML_Read('Profil/General/Mix', 0, "", $oXMLProfil)) = "true" Then
							$vResult = _WizardWindow(_MultiLang_GetText("win_Wizard_MIX_Title"), _MultiLang_GetText("win_Wizard_MIX_Desc"), "", "", 0, 1, 1, 0)
							If $vResult > 0 Then _GUI_Config_MIX($iMIXPath, $iPathMixTmp)
						Else
							_WizardWindow(_MultiLang_GetText("win_Wizard_END_Title"), _MultiLang_GetText("win_Wizard_END_Desc"), "", "", 0, 1, 1, 0)
							$vResult = -2
						EndIf
						Switch $vResult
							Case -2
								$vBoucle = $vMaxWizard
							Case -1
								$vBoucle = $vBoucle - 1
							Case Else
								$vBoucle = $vBoucle + 1
						EndSwitch
					Case 4
						$vResult = _WizardWindow(_MultiLang_GetText("win_Wizard_END_Title"), _MultiLang_GetText("win_Wizard_END_Desc"), "", "", 0, 0, 0, 1)
						$vBoucle = $vMaxWizard
				EndSwitch
			WEnd
		Case $GUI_EVENT_CLOSE, $MF_Exit ; Exit
			DirRemove($iTEMPPath, 1)
			_LOG("Universal XML Scraper Closed", 0, $iLOGPath)
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
		Case $MC_Langue ;Langue Selection
			$aLangList = _MultiLang_LoadLangDef($iLangPath, -1)
			If Not IsArray($aLangList) Or $aLangList < 0 Then
				_LOG("Impossible to load language", 2, $iLOGPath)
				Exit
			EndIf
			_LoadConfig($oXMLProfil)
			_GUI_Refresh($oXMLProfil)
		Case $MC_Config_LU ;Manual Path Configuration
			_GUI_Config_LU()
			_GUI_Refresh($oXMLProfil)
		Case $MC_config_Option ;Option Configuration
			$GUI_Config_Options = _GUI_Config_Options($oXMLProfil)
			If $GUI_Config_Options = 1 Then
				FileDelete($vProfilsPath)
				_XML_SaveToFile($oXMLProfil, $vProfilsPath)
			EndIf
			$aDIRList = _Check_autoconf($oXMLProfil)
			_GUI_Refresh($oXMLProfil)
		Case $MC_config_PIC ;Picture Configuration
			_GUI_Config_Image($oXMLProfil, $iPathMixTmp)
			_GUI_Refresh($oXMLProfil)
		Case $MC_config_MISC ;General Configuration
			_GUI_Config_MISC()
			_GUI_Refresh($oXMLProfil)
		Case $MC_Miximage ;Mix Image Selection
			_GUI_Config_MIX($iMIXPath, $iPathMixTmp)
		Case $MC_config_autoconf ;Autoconf Configuration
			$GUI_Config_autoconf = _GUI_Config_autoconf($oXMLProfil)
			If $GUI_Config_autoconf = 1 Then
				FileDelete($vProfilsPath)
				_XML_SaveToFile($oXMLProfil, $vProfilsPath)
			EndIf
			$aDIRList = _Check_autoconf($oXMLProfil)
			_GUI_Refresh($oXMLProfil)
		Case $MH_Help ;Help
			$sMsg = "UNIVERSAL XML SCRAPER - " & $iScriptVer & @CRLF
			$sMsg &= _MultiLang_GetText("win_About_By") & @CRLF & @CRLF
			$sMsg &= _MultiLang_GetText("win_About_Thanks") & @CRLF
			$sMsg &= "http://www.screenzone.fr/" & @CRLF
			$sMsg &= "http://www.screenscraper.fr/" & @CRLF
			$sMsg &= "http://www.recalbox.com/" & @CRLF
			$sMsg &= "http://www.emulationstation.org/" & @CRLF
			_ExtMsgBoxSet(1, 2, 0x34495c, 0xFFFF00, 10, "Arial")
			_ExtMsgBox($EMB_ICONINFO, "OK", _MultiLang_GetText("win_About_Title"), $sMsg, 15)
		Case $B_SCRAPE, $MS_Scrape ;Solo Scrape or Cancel
			$vFullTimer = TimerInit()
			$vNbThread = IniRead($iINIPath, "LAST_USE", "$vNbThread", 1)
			$aRomList = _SCRAPE($oXMLProfil, $vNbThread)
			$vNbThread = IniRead($iINIPath, "LAST_USE", "$vNbThread", 1)
			_LOG("-- Full Scrape in " & Round((TimerDiff($vFullTimer) / 1000), 2) & "s", 0, $iLOGPath)
			_Results($aRomList, $vNbThread, $vFullTimer)
			$vScrapeCancelled = 0
			_GUI_Refresh($oXMLProfil)
		Case $MS_FullScrape ;FullScrape
			Dim $aRomList_FULL[1][12]
			$vFullTimer = TimerInit()
			$vNbThread = IniRead($iINIPath, "LAST_USE", "$vNbThread", 1)
			For $vBoucle = 1 To UBound($MS_AutoConfigItem) - 1
				IniWrite($iINIPath, "LAST_USE", "$vSource_RomPath", $aDIRList[$vBoucle][1])
				IniWrite($iINIPath, "LAST_USE", "$vTarget_RomPath", $aDIRList[$vBoucle][2])
				IniWrite($iINIPath, "LAST_USE", "$vTarget_XMLName", $aDIRList[$vBoucle][3])
				IniWrite($iINIPath, "LAST_USE", "$vSource_ImagePath", $aDIRList[$vBoucle][4])
				IniWrite($iINIPath, "LAST_USE", "$vTarget_ImagePath", $aDIRList[$vBoucle][5])
				$aRomList = _SCRAPE($oXMLProfil, $vNbThread, 1)
				If IsArray($aRomList) Then
					For $i = 1 To UBound($aRomList, 1) - 1
						ReDim $aRomList_FULL[UBound($aRomList_FULL, 1) + 1][UBound($aRomList, 2)]
						For $j = 0 To UBound($aRomList, 2) - 1
							$aRomList_FULL[UBound($aRomList_FULL, 1) - 1][$j] = $aRomList[$i][$j]
						Next
					Next
				EndIf
				If Not _Check_Cancel() Then $vBoucle = UBound($MS_AutoConfigItem) - 1
			Next
			$vNbThread = IniRead($iINIPath, "LAST_USE", "$vNbThread", 1)
			_LOG("-- Full Scrape in " & Round((TimerDiff($vFullTimer) / 1000), 2) & "s", 0, $iLOGPath)
			_Results($aRomList_FULL, $vNbThread, $vFullTimer)
			$vScrapeCancelled = 0
			_GUI_Refresh($oXMLProfil)
	EndSwitch
	;SSH Menu
	If IsArray($MP_) Then
		For $vBoucle = 1 To UBound($MP_) - 1
			If $nMsg = $MP_[$vBoucle] Then _Plink($oXMLProfil, $aPlink_Command[$vBoucle][0])
		Next
	EndIf

	;Auto Conf Sub Menu
	If $aDIRList <> -1 Then
		For $vBoucle = 1 To UBound($MS_AutoConfigItem) - 1
			If $nMsg = $MS_AutoConfigItem[$vBoucle] Then
				_LOG("Autoconfig Selected :" & $aDIRList[$vBoucle][0],0, $iLOGPath)
				For $vBoucle2 = 1 To UBound($MS_AutoConfigItem) - 1
					GUICtrlSetState($MS_AutoConfigItem[$vBoucle2], $GUI_UNCHECKED)
				Next
				GUICtrlSetState($MS_AutoConfigItem[$vBoucle], $GUI_CHECKED)
				IniWrite($iINIPath, "LAST_USE", "$vSource_RomPath", $aDIRList[$vBoucle][1])
				IniWrite($iINIPath, "LAST_USE", "$vTarget_RomPath", $aDIRList[$vBoucle][2])
				IniWrite($iINIPath, "LAST_USE", "$vTarget_XMLName", $aDIRList[$vBoucle][3])
				IniWrite($iINIPath, "LAST_USE", "$vSource_ImagePath", $aDIRList[$vBoucle][4])
				IniWrite($iINIPath, "LAST_USE", "$vTarget_ImagePath", $aDIRList[$vBoucle][5])
				$nMsg = 0
				_GUI_Refresh($oXMLProfil)
			EndIf
		Next
	EndIf

WEnd

;---------;
;Fonctions;
;---------;

Func _LoadConfig($oXMLProfil)
	Local $aMatchingCountry
	Dim $aConfig[15]
	$aConfig[0] = IniRead($iINIPath, "LAST_USE", "$vTarget_XMLName", " ")
	$aConfig[1] = IniRead($iINIPath, "LAST_USE", "$vSource_RomPath", "")
	$aConfig[2] = IniRead($iINIPath, "LAST_USE", "$vTarget_RomPath", "./")
	$aConfig[3] = IniRead($iINIPath, "LAST_USE", "$vSource_ImagePath", "")
	$aConfig[4] = IniRead($iINIPath, "LAST_USE", "$vTarget_ImagePath", "./downloaded_images/")
	$aConfig[5] = IniRead($iINIPath, "LAST_USE", "$vScrape_Mode", 0)
	$aConfig[6] = IniRead($iINIPath, "LAST_USE", "$vMissingRom_Mode", 0)
	$aConfig[7] = IniRead($iINIPath, "LAST_USE", "$vCountryPic_Mode", 0)
	If IniRead($iINIPath, "LAST_USE", "$vLangPref", 0) = 0 Then IniWrite($iINIPath, "LAST_USE", "$vLangPref", _MultiLang_GetText("langpref"))
	If IniRead($iINIPath, "LAST_USE", "$vCountryPref", 0) = 0 Then IniWrite($iINIPath, "LAST_USE", "$vCountryPref", _MultiLang_GetText("countrypref"))
	$aConfig[9] = IniRead($iINIPath, "LAST_USE", "$vLangPref", "")
	$aConfig[10] = IniRead($iINIPath, "LAST_USE", "$vCountryPref", "")
	$aConfig[11] = $iRessourcesPath & "\regionlist.txt"
	$aConfig[12] = 0
	$aConfig[13] = IniRead($iINIPath, "LAST_USE", "$vSSLogin", "")
	$aConfig[14] = BinaryToString(_Crypt_DecryptData(IniRead($iINIPath, "LAST_USE", "$vSSPassword", ""), "1gdf1g1gf", $CALG_RC4))

	If Not FileExists($aConfig[1]) Then
		_ExtMsgBox($EMB_ICONEXCLAM, "OK", _MultiLang_GetText("err_title"), _MultiLang_GetText("err_PathRom"), 15)
		_LOG("Error Access to : " & $aConfig[1], 2, $iLOGPath)
		Return 0
	EndIf

	_LOG("$vTarget_XMLName = " & $aConfig[0], 1, $iLOGPath)
	_LOG("$vSource_RomPath = " & $aConfig[1], 1, $iLOGPath)
	_LOG("$vTarget_RomPath = " & $aConfig[2], 1, $iLOGPath)
	_LOG("$vSource_ImagePath = " & $aConfig[3], 1, $iLOGPath)
	_LOG("$vTarget_ImagePath = " & $aConfig[4], 1, $iLOGPath)
	_LOG("$vScrape_Mode = " & $aConfig[5], 1, $iLOGPath)
	_LOG("$vMissingRom_Mode = " & $aConfig[6], 1, $iLOGPath)
	_LOG("$vCountryPic_Mode = " & $aConfig[7], 1, $iLOGPath)
	_LOG("$vLangPref = " & $aConfig[9], 1, $iLOGPath)
	_LOG("$vCountryPref = " & $aConfig[10], 1, $iLOGPath)
	_LOG("$aMatchingCountry = " & $aConfig[11], 1, $iLOGPath)

	If Not FileExists($aConfig[3]) Then DirCreate($aConfig[3] & "\")
;~ 	If Not FileExists($aConfig[0]) Then _FileCreate($aConfig[0])

	Return $aConfig
EndFunc   ;==>_LoadConfig

Func _ProfilSelection($iProfilsPath, $vProfilsPath = -1) ;Profil Selection
	; Loading profils list
	$aProfilList = _FileListToArrayRec($iProfilsPath, "*.xml", $FLTAR_FILES, $FLTAR_NORECUR, $FLTAR_SORT, $FLTAR_FULLPATH)
;~ 	_ArrayDisplay($aProfilList, "$aProfilList") ;Debug
	If Not IsArray($aProfilList) Then
		_LOG("No Profils found", 2, $iLOGPath)
		Exit
	EndIf
	_ArrayColInsert($aProfilList, 0)
	_ArrayColInsert($aProfilList, 0)
	_ArrayDelete($aProfilList, 0)

	For $vBoucle = 0 To UBound($aProfilList) - 1
		$aProfilList[$vBoucle][0] = _XML_Read("Profil/Name", 1, $aProfilList[$vBoucle][2])
		If StringInStr($aProfilList[$vBoucle][0], $vProfilsPath) Then $vProfilsPath = $aProfilList[$vBoucle][2]
	Next
;~ 	_ArrayDisplay($aProfilList, "$aProfilList") ;Debug

	If $vProfilsPath = -1 Then $vProfilsPath = _SelectGUI($aProfilList, $aProfilList[0][2], "Profil")
	_LOG("Profil selected : " & $vProfilsPath, 0, $iLOGPath)
	Return $vProfilsPath
EndFunc   ;==>_ProfilSelection

Func _Plink($oXMLProfil, $vPlinkCommand) ;Send a Command via Plink
	Local $vPlink_Ip = _XML_Read("Profil/Plink/Ip", 0, "", $oXMLProfil)
	Local $vPlink_Root = _XML_Read("Profil/Plink/Root", 0, "", $oXMLProfil)
	Local $vPlink_Pswd = _XML_Read("Profil/Plink/Pswd", 0, "", $oXMLProfil)
	Local $aPlink_Command = _XML_Read("Profil/Plink/Command/" & $vPlinkCommand, 0, "", $oXMLProfil)

	If MsgBox($MB_OKCANCEL, $vPlinkCommand, _MultiLang_GetText("mess_ssh_" & $vPlinkCommand)) = $IDOK Then
		_LOG("SSH : " & $aPlink_Command, 0, $iLOGPath)
		$sRun = $iScriptPath & "\Ressources\plink.exe " & $vPlink_Ip & " -l " & $vPlink_Root & " -pw " & $vPlink_Pswd & " " & $aPlink_Command
		$iPid = Run($sRun, '', @SW_HIDE, $STDERR_CHILD + $STDOUT_CHILD)
		While ProcessExists($iPid)
			$_StderrRead = StderrRead($iPid)
			If Not @error And $_StderrRead <> '' Then
				If StringInStr($_StderrRead, 'Unable to open connection') Then
					MsgBox($MB_ICONERROR, _MultiLang_GetText("err_title"), _MultiLang_GetText("err_PlinkGlobal") & @CRLF & _MultiLang_GetText("err_PlinkConnection"))
					_LOG("Unable to open connection with Plink (" & $vPlink_Root & ":" & $vPlink_Pswd & "@" & $vPlink_Ip & ")", 2, $iLOGPath)
					Return -1
				EndIf
			EndIf
		WEnd
	Else
		_LOG("SSH canceled : " & $aPlink_Command, 1, $iLOGPath)
	EndIf
	Return
EndFunc   ;==>_Plink

Func _GUI_Config_Options($oXMLProfil)
	Local $aValue_Option = ""
	Local $vDefaultOptionValue = 0
	#Region ### START Koda GUI section ### Form=
	$F_CONFIG = GUICreate(_MultiLang_GetText("win_config_Option_Title"), 243, 263, -1, -1, -1, BitOR($WS_EX_TOPMOST, $WS_EX_WINDOWEDGE))
	$G_Option = GUICtrlCreateGroup(_MultiLang_GetText("win_config_Option_GroupOption"), 8, 8, 225, 65)
	$L_Option = GUICtrlCreateLabel(_MultiLang_GetText("win_config_Option_GroupOption_Choice"), 16, 23)
	$C_Option = GUICtrlCreateCombo("", 16, 40, 209, 25, BitOR($GUI_SS_DEFAULT_COMBO, $CBS_SIMPLE))
	GUICtrlCreateGroup("", -99, -99, 1, 1)
	$G_OptionParam = GUICtrlCreateGroup(_MultiLang_GetText("win_config_Option_GroupOption"), 8, 80, 225, 129)
	$C_OptionParam = GUICtrlCreateCombo("", 16, 104, 209, 25, BitOR($GUI_SS_DEFAULT_COMBO, $CBS_SIMPLE))
	$E_OptionParamDesc = GUICtrlCreateEdit("", 16, 128, 209, 73, BitOR($ES_AUTOVSCROLL, $ES_AUTOHSCROLL, $ES_READONLY, $ES_WANTRETURN))
	GUICtrlSetData(-1, "")
	GUICtrlCreateGroup("", -99, -99, 1, 1)
	$B_CONFENREG = GUICtrlCreateButton(_MultiLang_GetText("win_config_Enreg"), 8, 216, 105, 41)
	$B_CONFANNUL = GUICtrlCreateButton(_MultiLang_GetText("win_config_Cancel"), 126, 216, 105, 41)
	GUISetState(@SW_SHOW)
	GUISetState(@SW_DISABLE, $F_UniversalScraper)
	#EndRegion ### END Koda GUI section ###

	$aOption = _XML_ListValue('Profil/Options/Option/Name', "", $oXMLProfil)
	$vOption = ""
	For $vBoucle = 1 To UBound($aOption) - 1
		$vOption = $vOption & $aOption[$vBoucle] & "|"
	Next
	GUICtrlSetData($C_Option, $vOption, "Select an option")

	While 1
		$nMsg = GUIGetMsg()
		Switch $nMsg
			Case $GUI_EVENT_CLOSE, $B_CONFANNUL
				GUIDelete($F_CONFIG)
				GUISetState(@SW_ENABLE, $F_UniversalScraper)
				WinActivate($F_UniversalScraper)
				_LOG("Option Configuration Canceled", 0, $iLOGPath)
				Return -1
			Case $C_Option
				$vValue_Option = ""
				GUICtrlSetData($C_OptionParam, $vValue_Option)
				$aValue_Option = _XML_ListValue('Profil/Options/Option[Name="' & GUICtrlRead($C_Option) & '"]/Source_Value_Option', "", $oXMLProfil)
				_ArrayColInsert($aValue_Option, 1)
				For $vBoucle = 1 To UBound($aValue_Option) - 1
					$aValue_Option[$vBoucle][1] = _XML_Read('Profil/Options/Option[Name="' & GUICtrlRead($C_Option) & '"]/Source_Value_Option[' & $vBoucle & ']/Name', 1, "", $oXMLProfil)
					$vValue_Option = $vValue_Option & $aValue_Option[$vBoucle][1] & "|"
				Next

				$vNode = _XML_Read('Profil/Options/Option[Name="' & GUICtrlRead($C_Option) & '"]/NodeName', 0, "", $oXMLProfil)
				$vDefaultOptionValue = _XML_Read('Profil/Element[@Type="' & GUICtrlRead($C_Option) & '"]/' & $vNode, 0, "", $oXMLProfil)
				$vDefaultOptionName = _ArraySearch($aValue_Option, $vDefaultOptionValue)
				If $vDefaultOptionName > 0 Then
					$vDefaultOptionName = $aValue_Option[$vDefaultOptionName][1]
				Else
					$vDefaultOptionName = $aValue_Option[1][1]
				EndIf
				GUICtrlSetData($C_OptionParam, $vValue_Option, $vDefaultOptionName)
				GUICtrlSetData($E_OptionParamDesc, _XML_Read('Profil/Options/Option[Name="' & GUICtrlRead($C_Option) & '"]/Source_Value_Option[@Name="' & GUICtrlRead($C_OptionParam) & '"]/Desc', 1, "", $oXMLProfil))
			Case $C_OptionParam
				GUICtrlSetData($E_OptionParamDesc, _XML_Read('Profil/Options/Option[Name="' & GUICtrlRead($C_Option) & '"]/Source_Value_Option[@Name="' & GUICtrlRead($C_OptionParam) & '"]/Desc', 1, "", $oXMLProfil))
			Case $B_CONFENREG
				$vDefaultOptionName = GUICtrlRead($C_OptionParam)
				If IsArray($aValue_Option) Then
					$vDefaultOptionValue = _ArraySearch($aValue_Option, $vDefaultOptionName)
					If $vDefaultOptionValue > 0 Then
						$vNode = _XML_Read('Profil/Options/Option[Name="' & GUICtrlRead($C_Option) & '"]/NodeName', 0, "", $oXMLProfil)
						$vDefaultOptionValue = $aValue_Option[$vDefaultOptionValue][0]
;~ 						MsgBox(0, "$vDefaultOptionValue - Node", 'Profil/Element[@Type="' & GUICtrlRead($C_Option) & '"]/' & $vNode & " -> " & $vDefaultOptionValue)
						_XML_Replace('Profil/Element[@Type="' & GUICtrlRead($C_Option) & '"]/' & $vNode, $vDefaultOptionValue, 0, "", $oXMLProfil)
						_LOG("Option Configuration Saved", 0, $iLOGPath)
						_LOG("------------------------", 1, $iLOGPath)
						_LOG(GUICtrlRead($C_Option) & " = " & $vDefaultOptionValue, 1, $iLOGPath)

						GUIDelete($F_CONFIG)
						GUISetState(@SW_ENABLE, $F_UniversalScraper)
						WinActivate($F_UniversalScraper)
						Return 1
					EndIf
				EndIf
				GUIDelete($F_CONFIG)
				GUISetState(@SW_ENABLE, $F_UniversalScraper)
				WinActivate($F_UniversalScraper)
				_LOG("Option Configuration Error : No choice made", 0, $iLOGPath)
				Return -1

		EndSwitch
	WEnd
EndFunc   ;==>_GUI_Config_Options

Func _GUI_Config_Image($oXMLProfil, $iPathMixTmp)
	#Region ### START Koda GUI section ### Form=
	$F_CONFIG = GUICreate(_MultiLang_GetText("win_config_PIC_Title"), 474, 122, -1, -1, -1, BitOR($WS_EX_TOPMOST, $WS_EX_WINDOWEDGE))
	$G_Picture = GUICtrlCreateGroup(_MultiLang_GetText("win_config_PIC_GroupPICParam"), 8, 0, 225, 113)
	$L_PicSize = GUICtrlCreateLabel(_MultiLang_GetText("win_config_PIC_GroupPICParam_PicSize"), 16, 16)
	$I_Width = GUICtrlCreateInput("", 16, 36, 89, 21)
	$I_Height = GUICtrlCreateInput("", 136, 36, 89, 21)
	$L_X = GUICtrlCreateLabel("X", 116, 40, 11, 17)
	$L_PicExt = GUICtrlCreateLabel(_MultiLang_GetText("win_config_PIC_GroupPICParam_PicExt"), 16, 76)
	$C_PicExt = GUICtrlCreateCombo("", 136, 72, 89, 25, BitOR($GUI_SS_DEFAULT_COMBO, $CBS_SIMPLE))
	GUICtrlSetData($C_PicExt, "defaut|jpg|png", StringLower(_Coalesce(IniRead($iINIPath, "LAST_USE", "$vTarget_Image_Ext", ""), _XML_Read('Profil/General/Image_Extension', 0, "", $oXMLProfil))))
	GUICtrlCreateGroup("", -99, -99, 1, 1)
	$B_CONFENREG = GUICtrlCreateButton(_MultiLang_GetText("win_config_Enreg"), 240, 72, 105, 41)
	$B_CONFANNUL = GUICtrlCreateButton(_MultiLang_GetText("win_config_Cancel"), 358, 72, 105, 41)
	GUISetState(@SW_SHOW)
	GUISetState(@SW_DISABLE, $F_UniversalScraper)
	#EndRegion ### END Koda GUI section ###

	If StringLower(_XML_Read('Profil/General/Mix', 0, "", $oXMLProfil)) = "true" Then
		GUICtrlSetData($I_Width, _Coalesce(IniRead($iINIPath, "LAST_USE", "$vTarget_Image_Width", ""), _XML_Read("Profil/General/Target_Width", 0, $iPathMixTmp & "\config.xml")))
		GUICtrlSetData($I_Height, _Coalesce(IniRead($iINIPath, "LAST_USE", "$vTarget_Image_Height", ""), _XML_Read("Profil/General/Target_Height", 0, $iPathMixTmp & "\config.xml")))
	Else
		GUICtrlSetData($I_Width, _Coalesce(IniRead($iINIPath, "LAST_USE", "$vTarget_Image_Width", ""), _XML_Read("Profil/General/Target_Image_Width", 0, "", $oXMLProfil)))
		GUICtrlSetData($I_Height, _Coalesce(IniRead($iINIPath, "LAST_USE", "$vTarget_Image_Height", ""), _XML_Read("Profil/General/Target_Image_Height", 0, "", $oXMLProfil)))
	EndIf

	While 1
		$nMsg = GUIGetMsg()
		Switch $nMsg
			Case $GUI_EVENT_CLOSE, $B_CONFANNUL
				GUIDelete($F_CONFIG)
				GUISetState(@SW_ENABLE, $F_UniversalScraper)
				WinActivate($F_UniversalScraper)
				_LOG("Image Configuration Canceled", 0, $iLOGPath)
				Return
			Case $B_CONFENREG
				IniWrite($iINIPath, "LAST_USE", "$vTarget_Image_Width", GUICtrlRead($I_Width))
				IniWrite($iINIPath, "LAST_USE", "$vTarget_Image_Height", GUICtrlRead($I_Height))
				$vPicExt = GUICtrlRead($C_PicExt)
				If $vPicExt = "defaut" Then $vPicExt = ""
				IniWrite($iINIPath, "LAST_USE", "$vTarget_Image_Ext", $vPicExt)
				_LOG("Image Configuration Saved", 0, $iLOGPath)
				_LOG("------------------------", 1, $iLOGPath)
				_LOG("$vTarget_Image_Width = " & GUICtrlRead($I_Width), 1, $iLOGPath)
				_LOG("$vTarget_Image_Height = " & GUICtrlRead($I_Height), 1, $iLOGPath)
				_LOG("$vTarget_Image_Ext = " & $vPicExt, 1, $iLOGPath)
				GUIDelete($F_CONFIG)
				GUISetState(@SW_ENABLE, $F_UniversalScraper)
				WinActivate($F_UniversalScraper)
				Return
		EndSwitch
	WEnd
EndFunc   ;==>_GUI_Config_Image

Func _GUI_Config_MIX($iMIXPath, $iPathMixTmp)
	Local $vMIXListC = ""
	$aMIXList = _FileListToArrayRec($iMIXPath, "*.zip", $FLTAR_FILES, $FLTAR_NORECUR, $FLTAR_SORT, $FLTAR_NOPATH)
	For $vBoucle = 1 To UBound($aMIXList) - 1
		$vMIXListC = $vMIXListC & "|" & StringTrimRight($aMIXList[$vBoucle], 4)
	Next

	$vMIXLast = _XML_Read("/Profil/Name", 1, $iPathMixTmp & "\config.xml")

	#Region ### START Koda GUI section ### Form=
	$F_MIXIMAGE = GUICreate(_MultiLang_GetText("win_config_mix_Title"), 825, 272, -1, -1, -1, BitOR($WS_EX_TOPMOST, $WS_EX_WINDOWEDGE))
	$C_MIXIMAGE = GUICtrlCreateCombo("", 8, 242, 401, 25, BitOR($CBS_DROPDOWNLIST, $CBS_AUTOHSCROLL))
	GUICtrlSetData($C_MIXIMAGE, $vMIXListC, $vMIXLast)
	$B_OK = GUICtrlCreateButton(_MultiLang_GetText("win_config_mix_Enreg"), 416, 240, 200, 25)
	$B_CANCEL = GUICtrlCreateButton(_MultiLang_GetText("win_config_mix_Cancel"), 616, 240, 200, 25)
	$P_Empty = GUICtrlCreatePic("", 8, 8, 400, 200)
	$P_Full = GUICtrlCreatePic("", 417, 8, 400, 200)
	$L_Empy = GUICtrlCreateLabel(_MultiLang_GetText("win_config_mix_empty"), 144, 216, 116, 17, $SS_CENTER)
	$L_Exemple = GUICtrlCreateLabel(_MultiLang_GetText("win_config_mix_exemple"), 592, 216, 44, 17)
	GUISetState(@SW_SHOW)
	GUISetState(@SW_DISABLE, $F_UniversalScraper)
	#EndRegion ### END Koda GUI section ###

	$vMIXExempleEmptyPath = $iPathMixTmp & "\" & _XML_Read("/Profil/General/Empty_Exemple", 0, $iPathMixTmp & "\config.xml")
	$vMIXExempleFullPath = $iPathMixTmp & "\" & _XML_Read("/Profil/General/Full_Exemple", 0, $iPathMixTmp & "\config.xml")
	GUICtrlSetImage($P_Empty, $vMIXExempleEmptyPath)
	GUICtrlSetImage($P_Full, $vMIXExempleFullPath)

	While 1
		Local $nMsg = GUIGetMsg()
		Switch $nMsg
			Case $GUI_EVENT_CLOSE, $B_CANCEL
				DirRemove($iPathMixTmp, 1)
				DirCreate($iPathMixTmp)
				_Zip_UnzipAll($iMIXPath & "\" & $vMIXLast & ".zip", $iPathMixTmp, 1)
				IniWrite($iINIPath, "LAST_USE", "$vMixImage", $vMIXLast)
				GUIDelete($F_MIXIMAGE)
				GUISetState(@SW_ENABLE, $F_UniversalScraper)
				WinActivate($F_UniversalScraper)
				_LOG("MIX Configuration Canceled", 0, $iLOGPath)
				Return
			Case $B_OK
				IniWrite($iINIPath, "LAST_USE", "$vTarget_Image_Width", "")
				IniWrite($iINIPath, "LAST_USE", "$vTarget_Image_Height", "")
				IniWrite($iINIPath, "LAST_USE", "$vMixImage", GUICtrlRead($C_MIXIMAGE))
				_LOG("MIX Configuration Saved : " & GUICtrlRead($C_MIXIMAGE), 0, $iLOGPath)
				GUIDelete($F_MIXIMAGE)
				GUISetState(@SW_ENABLE, $F_UniversalScraper)
				WinActivate($F_UniversalScraper)
				Return
			Case $C_MIXIMAGE
				If GUICtrlRead($C_MIXIMAGE) <> _XML_Read("/Profil/Name", 1, $iPathMixTmp & "\config.xml") Then
					DirRemove($iPathMixTmp, 1)
					DirCreate($iPathMixTmp)
					_Zip_UnzipAll($iMIXPath & "\" & GUICtrlRead($C_MIXIMAGE) & ".zip", $iPathMixTmp, 1)
					$vMIXExempleEmptyPath = $iPathMixTmp & "\" & _XML_Read("/Profil/General/Empty_Exemple", 0, $iPathMixTmp & "\config.xml")
					$vMIXExempleFullPath = $iPathMixTmp & "\" & _XML_Read("/Profil/General/Full_Exemple", 0, $iPathMixTmp & "\config.xml")
					GUICtrlSetImage($P_Empty, $vMIXExempleEmptyPath)
					GUICtrlSetImage($P_Full, $vMIXExempleFullPath)
				EndIf
		EndSwitch
	WEnd

EndFunc   ;==>_GUI_Config_MIX

Func _GUI_Config_MISC()
	Local $aRechFiles = StringSplit(IniRead($iINIPath, "LAST_USE", "$vRechFiles", "*.*|*.xml;*.txt;*.dv;*.fs;*.xor;*.drv;*.dat;*.cfg;*.nv;*.sav*|"), '|', $STR_ENTIRESPLIT + $STR_NOCOUNT)
	Local $aScrapeMode = StringSplit(_MultiLang_GetText("win_config_MISC_GroupMISC_ScrapeModeChoice"), '|', $STR_ENTIRESPLIT + $STR_NOCOUNT)
	Local $aCountryPic_Mode = StringSplit(_MultiLang_GetText("win_config_MISC_GroupMISC_CountryPicModeChoice"), '|', $STR_ENTIRESPLIT + $STR_NOCOUNT)
	Local $aVerbose = StringSplit(_MultiLang_GetText("win_config_MISC_GroupMISC_VerboseChoice"), '|', $STR_ENTIRESPLIT + $STR_NOCOUNT)
	Local $vNbThreadDefault = 0

	#Region ### START Koda GUI section ### Form=
	$F_CONFIG = GUICreate(_MultiLang_GetText("win_config_MISC_Title"), 475, 372, -1, -1, -1, BitOR($WS_EX_TOPMOST, $WS_EX_WINDOWEDGE))
	$G_Misc = GUICtrlCreateGroup(_MultiLang_GetText("win_config_MISC_GroupMISC"), 8, 0, 225, 321)
	$L_CountryPref = GUICtrlCreateLabel(_MultiLang_GetText("win_config_MISC_GroupMISC_CountryPref"), 16, 15)
	$I_CountryPref = GUICtrlCreateInput(IniRead($iINIPath, "LAST_USE", "$vCountryPref", ""), 16, 34, 209, 21)
	$L_LangPref = GUICtrlCreateLabel(_MultiLang_GetText("win_config_MISC_GroupMISC_LangPref"), 16, 60)
	$I_LangPref = GUICtrlCreateInput(IniRead($iINIPath, "LAST_USE", "$vLangPref", ""), 16, 80, 209, 21)
	$L_ScrapeMode = GUICtrlCreateLabel(_MultiLang_GetText("win_config_MISC_GroupMISC_ScrapeMode"), 16, 108)
	$C_ScrapeMode = GUICtrlCreateCombo("", 16, 128, 209, 25, BitOR($GUI_SS_DEFAULT_COMBO, $CBS_SIMPLE))
	GUICtrlSetData($C_ScrapeMode, _MultiLang_GetText("win_config_MISC_GroupMISC_ScrapeModeChoice"), $aScrapeMode[IniRead($iINIPath, "LAST_USE", "$vScrape_Mode", 0)])
	$L_CountryPic_Mode = GUICtrlCreateLabel(_MultiLang_GetText("win_config_MISC_GroupMISC_CountryPicMode"), 16, 156)
	$C_CountryPic_Mode = GUICtrlCreateCombo("", 16, 176, 209, 25, BitOR($GUI_SS_DEFAULT_COMBO, $CBS_SIMPLE))
	GUICtrlSetData($C_CountryPic_Mode, _MultiLang_GetText("win_config_MISC_GroupMISC_CountryPicModeChoice"), $aCountryPic_Mode[IniRead($iINIPath, "LAST_USE", "$vCountryPic_Mode", 0)])
	$L_Verbose = GUICtrlCreateLabel(_MultiLang_GetText("win_config_MISC_GroupMISC_Verbose"), 16, 204)
	$C_Verbose = GUICtrlCreateCombo("", 16, 224, 209, 25, BitOR($GUI_SS_DEFAULT_COMBO, $CBS_SIMPLE))
	GUICtrlSetData($C_Verbose, _MultiLang_GetText("win_config_MISC_GroupMISC_VerboseChoice"), $aVerbose[IniRead($iINIPath, "GENERAL", "$vVerbose", 0)])
	$CB_MissingRom_Mode = GUICtrlCreateCheckbox(_MultiLang_GetText("win_config_MISC_GroupMISC_MissingMode"), 16, 254)
	$CB_RechSys = GUICtrlCreateCheckbox(_MultiLang_GetText("win_config_MISC_GroupMISC_RechSys"), 16, 278)
	GUICtrlCreateGroup("", -99, -99, 1, 1)
	$G_ScreenScraper = GUICtrlCreateGroup(_MultiLang_GetText("win_config_MISC_GroupScreenScraper"), 240, 0, 225, 153)
	$L_SSLogin = GUICtrlCreateLabel(_MultiLang_GetText("win_config_MISC_GroupScreenScraper_Login"), 248, 15)
	$I_SSLogin = GUICtrlCreateInput(IniRead($iINIPath, "LAST_USE", "$vSSLogin", ""), 248, 34, 113, 21)
	$L_SSPassword = GUICtrlCreateLabel(_MultiLang_GetText("win_config_MISC_GroupScreenScraper_Password"), 248, 61)
	$I_SSPassword = GUICtrlCreateInput(BinaryToString(_Crypt_DecryptData(IniRead($iINIPath, "LAST_USE", "$vSSPassword", ""), "1gdf1g1gf", $CALG_RC4)), 248, 80, 113, 21, BitOR($GUI_SS_DEFAULT_INPUT, $ES_PASSWORD))
	$L_Thread = GUICtrlCreateLabel(_MultiLang_GetText("win_config_MISC_GroupScreenScraper_NbThread"), 376, 15)
	$C_Thread = GUICtrlCreateCombo("1", 376, 34, 81, 21, BitOR($GUI_SS_DEFAULT_COMBO, $CBS_SIMPLE))
	GUICtrlSetData($C_Thread, "", "")
	$B_SSCheck = GUICtrlCreateButton(_MultiLang_GetText("win_config_MISC_GroupScreenScraper_Check"), 368, 80, 91, 21)
	$B_SSRegister = GUICtrlCreateButton(_MultiLang_GetText("win_config_MISC_GroupScreenScraper_SSRegister"), 248, 112, 211, 25)
	GUICtrlCreateGroup("", -99, -99, 1, 1)
	$G_RechFiles = GUICtrlCreateGroup(_MultiLang_GetText("win_config_MISC_GroupRechFiles"), 240, 160, 225, 161)
	$L_Include = GUICtrlCreateLabel(_MultiLang_GetText("win_config_MISC_GroupRechFiles_Include"), 248, 175, 71, 17)
	$I_Include = GUICtrlCreateInput($aRechFiles[0], 248, 194, 209, 21)
	$L_Exclude = GUICtrlCreateLabel(_MultiLang_GetText("win_config_MISC_GroupRechFiles_Exclude"), 248, 220, 74, 17)
	$I_Exclude = GUICtrlCreateInput($aRechFiles[1], 248, 240, 209, 21)
	$L_ExcludeFolder = GUICtrlCreateLabel(_MultiLang_GetText("win_config_MISC_GroupRechFiles_ExcludeFolder"), 248, 268, 92, 17)
	$I_ExcludeFolder = GUICtrlCreateInput($aRechFiles[2], 248, 288, 209, 21)
	GUICtrlCreateGroup("", -99, -99, 1, 1)
	$B_CONFENREG = GUICtrlCreateButton(_MultiLang_GetText("win_config_Enreg"), 64, 328, 105, 33)
	$B_CONFANNUL = GUICtrlCreateButton(_MultiLang_GetText("win_config_Cancel"), 294, 328, 105, 33)
	GUISetState(@SW_SHOW)
	GUISetState(@SW_DISABLE, $F_UniversalScraper)
	#EndRegion ### END Koda GUI section ###

	GUICtrlSetState($CB_MissingRom_Mode, $GUI_UNCHECKED)
	If IniRead($iINIPath, "LAST_USE", "$vMissingRom_Mode", 0) = 1 Then GUICtrlSetState($CB_MissingRom_Mode, $GUI_CHECKED)
	GUICtrlSetState($CB_RechSys, $GUI_UNCHECKED)
	If IniRead($iINIPath, "LAST_USE", "$vRechSYS", 1) = 1 Then GUICtrlSetState($CB_RechSys, $GUI_CHECKED)

	$vNbThread = IniRead($iINIPath, "LAST_USE", "$vNbThread", 1)
	$vTEMPPathSSCheck = $iScriptPath & "\Ressources\SSCheck.xml"
	$vSSLogin = GUICtrlRead($I_SSLogin) ;$vSSLogin
	$vSSPassword = GUICtrlRead($I_SSPassword) ;$vSSPassword
	_LOG("SS Check ssid=" & $vSSLogin, 1, $iLOGPath)
	$vTEMPPathSSCheck = _DownloadWRetry("http://www.screenscraper.fr/api/ssuserInfos.php?devid=xxx&devpassword=yyy&softname=zzz&output=XML&ssid=" & $vSSLogin & "&sspassword=" & $vSSPassword, $vTEMPPathSSCheck)
	$vSSLevel = Number(_XML_Read("/Data/ssuser/niveau", 0, $vTEMPPathSSCheck))
	If $vSSLevel < 1 Then $vSSLevel = 0
	Switch $vSSLevel
		Case 0
			$vNbThreadMax = 1
		Case 1 To 9
			$vNbThreadMax = 2
		Case 10 To 39
			$vNbThreadMax = 5
		Case 40 To 10000
			$vNbThreadMax = 10
		Case Else
			$vNbThreadMax = 1
	EndSwitch
	$vNbThreadC = ""
	For $vBoucle = 1 To $vNbThreadMax
		$vNbThreadC = $vNbThreadC & $vBoucle & "|"
	Next

	If $vNbThread > $vNbThreadMax Then $vNbThread = $vNbThreadMax
	GUICtrlSetData($C_Thread, $vNbThreadC, $vNbThread)

	While 1
		$nMsg = GUIGetMsg()
		Switch $nMsg
			Case $GUI_EVENT_CLOSE, $B_CONFANNUL
				GUIDelete($F_CONFIG)
				GUISetState(@SW_ENABLE, $F_UniversalScraper)
				WinActivate($F_UniversalScraper)
				_LOG("MISC Configuration Canceled", 0, $iLOGPath)
				Return
			Case $B_CONFENREG
				IniWrite($iINIPath, "LAST_USE", "$vNbThread", GUICtrlRead($C_Thread))
				IniWrite($iINIPath, "LAST_USE", "$vScrape_Mode", StringLeft(GUICtrlRead($C_ScrapeMode), 1))
				IniWrite($iINIPath, "LAST_USE", "$vCountryPic_Mode", StringLeft(GUICtrlRead($C_CountryPic_Mode), 1))
				IniWrite($iINIPath, "GENERAL", "$vVerbose", StringLeft(GUICtrlRead($C_Verbose), 1))
				$iVerboseLVL = StringLeft(GUICtrlRead($C_Verbose), 1)
				IniWrite($iINIPath, "LAST_USE", "$vMissingRom_Mode", 0)
				If _IsChecked($CB_MissingRom_Mode) Then IniWrite($iINIPath, "LAST_USE", "$vMissingRom_Mode", 1)
				IniWrite($iINIPath, "LAST_USE", "$vRechSYS", 0)
				If _IsChecked($CB_RechSys) Then IniWrite($iINIPath, "LAST_USE", "$vRechSYS", 1)
				IniWrite($iINIPath, "LAST_USE", "$vRechFiles", GUICtrlRead($I_Include) & "|" & GUICtrlRead($I_Exclude) & "|" & GUICtrlRead($I_ExcludeFolder))
				$vCountryPref = GUICtrlRead($I_CountryPref) ;$vCountryPref
				IniWrite($iINIPath, "LAST_USE", "$vCountryPref", $vCountryPref)
				$vLangPref = GUICtrlRead($I_LangPref) ;$vLangPref
				IniWrite($iINIPath, "LAST_USE", "$vLangPref", $vLangPref)
				$vSSLogin = GUICtrlRead($I_SSLogin) ;$vSSLogin
				IniWrite($iINIPath, "LAST_USE", "$vSSLogin", $vSSLogin)
				$vSSPassword = _Crypt_EncryptData(GUICtrlRead($I_SSPassword), "1gdf1g1gf", $CALG_RC4) ;$vSSPassword
				IniWrite($iINIPath, "LAST_USE", "$vSSPassword", $vSSPassword)
				GUIDelete($F_CONFIG)
				GUISetState(@SW_ENABLE, $F_UniversalScraper)
				WinActivate($F_UniversalScraper)
				Return GUICtrlRead($C_Thread)
			Case $B_SSRegister
				_LOG("Launch Internet Browser to Register", 0, $iLOGPath)
				ShellExecute("http://www.screenscraper.fr/membreinscription.php")
			Case $B_SSCheck
				GUICtrlSetData($C_Thread, "", "")
				$vTEMPPathSSCheck = $iScriptPath & "\Ressources\SSCheck.xml"
				$vSSLogin = GUICtrlRead($I_SSLogin) ;$vSSLogin
				$vSSPassword = GUICtrlRead($I_SSPassword) ;$vSSPassword
				_LOG("SS Check ssid=" & $vSSLogin, 3, $iLOGPath)
				$vTEMPPathSSCheck = _DownloadWRetry("http://www.screenscraper.fr/api/ssuserInfos.php?devid=xxx&devpassword=yyy&softname=zzz&output=XML&ssid=" & $vSSLogin & "&sspassword=" & $vSSPassword, $vTEMPPathSSCheck)
				$vSSLevel = Number(_XML_Read("/Data/ssuser/niveau", 0, $vTEMPPathSSCheck))
				If $vSSLevel < 1 Then $vSSLevel = 0
				Switch $vSSLevel
					Case 0
						$vNbThreadMax = 1
						$vNbThreadDefault = 0
						_LOG("Not Registered", 0, $iLOGPath)
						MsgBox($MB_ICONERROR, _MultiLang_GetText("err_title"), _MultiLang_GetText("err_NotRegistered"), 10, $F_CONFIG)
					Case 1 To 9
						$vNbThreadMax = 2
						$vNbThreadDefault = 0
						_LOG("Registered Lvl : " & $vSSLevel & " - Nb Thread Available : " & $vNbThreadMax, 0, $iLOGPath)
						MsgBox($MB_ICONINFORMATION, _MultiLang_GetText("mess_ssregister_title"), _MultiLang_GetText("mess_ssregister_OK") & " " & $vNbThreadMax & " Threads", 10, $F_CONFIG)
					Case 10 To 39
						$vNbThreadMax = 5
						$vNbThreadDefault = 0
						_LOG("Registered Lvl : " & $vSSLevel & " - Nb Thread Available : " & $vNbThreadMax, 0, $iLOGPath)
						MsgBox($MB_ICONINFORMATION, _MultiLang_GetText("mess_ssregister_title"), _MultiLang_GetText("mess_ssregister_OK") & " " & $vNbThreadMax & " Threads", 10, $F_CONFIG)
					Case 40 To 499
						$vNbThreadMax = 10
						$vNbThreadDefault = 5
						_LOG("Registered Lvl : " & $vSSLevel & " - Nb Thread Available : " & $vNbThreadMax, 0, $iLOGPath)
						MsgBox($MB_ICONINFORMATION, _MultiLang_GetText("mess_ssregister_title"), _MultiLang_GetText("mess_ssregister_OK") & " " & $vNbThreadMax & " Threads", 10, $F_CONFIG)
					Case Else
						$vNbThreadMax = 99
						$vNbThreadDefault = 10
						_LOG("God Mode", 0, $iLOGPath)
						MsgBox($MB_ICONWARNING, _MultiLang_GetText("mess_ssregister_title"), _MultiLang_GetText("mess_ssregister_GodMode"), 10, $F_CONFIG)
				EndSwitch
				$vNbThreadC = ""
				For $vBoucle = 1 To $vNbThreadMax
					$vNbThreadC = $vNbThreadC & $vBoucle & "|"
				Next
				If $vNbThreadDefault = 0 Then $vNbThreadDefault = $vNbThreadMax
				GUICtrlSetData($C_Thread, $vNbThreadC, $vNbThreadDefault)
		EndSwitch
	WEnd
EndFunc   ;==>_GUI_Config_MISC

Func _GUI_Config_LU()
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
				_LOG("Path Configuration Canceled", 0, $iLOGPath)
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
				_LOG("Path Configuration Saved", 0, $iLOGPath)
				_LOG("------------------------", 1, $iLOGPath)
				_LOG("$vTarget_XMLName = " & $vTarget_XMLName, 1, $iLOGPath)
				_LOG("$vSource_RomPath = " & $vSource_RomPath, 1, $iLOGPath)
				_LOG("$vTarget_RomPath = " & $vTarget_RomPath, 1, $iLOGPath)
				_LOG("$vSource_ImagePath = " & $vSource_ImagePath, 1, $iLOGPath)
				_LOG("$vTarget_ImagePath = " & $vTarget_ImagePath, 1, $iLOGPath)
				GUIDelete($F_CONFIG)
				GUISetState(@SW_ENABLE, $F_UniversalScraper)
				WinActivate($F_UniversalScraper)
				Return
		EndSwitch
	WEnd
EndFunc   ;==>_GUI_Config_LU

Func _GUI_Config_autoconf($oXMLProfil)
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
				_LOG("Path Configuration Canceled", 0, $iLOGPath)
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
				_LOG("AutoConf Path Configuration Saved", 0, $iLOGPath)
				_LOG("------------------------", 1, $iLOGPath)
				_LOG("$vSource_RootPath = " & $vSource_RootPath, 1, $iLOGPath)
				_LOG("$vTarget_XMLName = " & $vTarget_XMLName, 1, $iLOGPath)
				_LOG("$vTarget_RomPath = " & $vTarget_RomPath, 1, $iLOGPath)
				_LOG("$vSource_ImagePath = " & $vSource_ImagePath, 1, $iLOGPath)
				_LOG("$vTarget_ImagePath = " & $vTarget_ImagePath, 1, $iLOGPath)
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

			GUICtrlSetImage($P_BACKGROUND, $vSourcePicturePath)

			;Overall Menu
			Local $vSystem = StringSplit(IniRead($iINIPath, "LAST_USE", "$vSource_RomPath", ""), "\")
			$vSystem = $vSystem[UBound($vSystem) - 1]

			GUICtrlSetState($MC_Miximage, $GUI_DISABLE)
			If StringLower(_XML_Read('Profil/General/Mix', 0, "", $oXMLProfil)) = "true" Then GUICtrlSetState($MC_Miximage, $GUI_ENABLE)

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
				_LOG("SSH Disable", 1, $iLOGPath)
				GUICtrlSetState($MP, $GUI_DISABLE)
				If IsArray($MP_) Then
					For $vBoucle = 1 To UBound($MP_) - 1
						GUICtrlDelete($MP_[$vBoucle])
					Next
				EndIf

			Else
				_LOG("SSH Enable", 1, $iLOGPath)
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
			_GUICtrlStatusBar_SetText($L_SCRAPE, "")

			_LOG("GUI Refresh", 1, $iLOGPath)

		Else
			_LOG("GUI Desactivated (Scrape in progress)", 1, $iLOGPath)
			GUICtrlSetState($MF, $GUI_DISABLE)
			GUICtrlSetState($MC, $GUI_DISABLE)
			GUICtrlSetState($MS, $GUI_DISABLE)
			GUICtrlSetState($MP, $GUI_DISABLE)
			GUICtrlSetState($MH, $GUI_DISABLE)
			GUICtrlSetData($B_SCRAPE, _MultiLang_GetText("scrap_cancel_button"))
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

	If IsHWnd($F_UniversalScraper) Then GUISetState(@SW_DISABLE, $F_UniversalScraper)
	SplashTextOn(_MultiLang_GetText("mnu_edit_autoconf"), _MultiLang_GetText("mess_autoconf"), 400, 50)
	If StringRight($vSource_RootPath, 1) = '\' Then $vSource_RootPath = StringTrimRight($vSource_RootPath, 1)
	$aDIRList = _FileListToArrayRec($vSource_RootPath, "*", $FLTAR_FOLDERS, $FLTAR_NORECUR, $FLTAR_SORT, $FLTAR_RELPATH)
	If IsArray($aDIRList) Then
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
		_LOG("Scrape Cancelled", 0, $iLOGPath)
		$vScrapeCancelled = 1
		Return False
	Else
		$vScrapeCancelled = 0
		Return True
	EndIf
EndFunc   ;==>_Check_Cancel

Func _RomList_Create($aConfig, $vFullScrape = 0)
	Local $sDrive = "", $sDir = "", $sFileName = "", $sExtension = "", $aPathSplit
	$vRechFiles = IniRead($iINIPath, "LAST_USE", "$vRechFiles ", "*.*z*")
	Local $vPicDir = StringSplit($aConfig[3], "\")
	$vPipeCount = StringSplit($vRechFiles, "|")
	If $vPipeCount[0] = 2 Then $vRechFiles = $vRechFiles & "|"
	If StringRight($vRechFiles, 1) = "|" Then
		$vRechFiles = $vRechFiles & $vPicDir[UBound($vPicDir) - 1]
	Else
		$vRechFiles = $vRechFiles & ";" & $vPicDir[UBound($vPicDir) - 1]
	EndIf
	_LOG("Listing ROM (" & $vRechFiles & ")", 1, $iLOGPath)
	$aRomList = _FileListToArrayRec($aConfig[1], $vRechFiles, $FLTAR_FILES, $FLTAR_RECUR, $FLTAR_SORT)

	If @error = 1 Then
		_LOG("Invalid Rom Path : " & $aConfig[1], 2, $iLOGPath)
		If $vFullScrape = 0 Then MsgBox($MB_ICONERROR, _MultiLang_GetText("err_title"), _MultiLang_GetText("err_PathRom"))
		Return -1
	EndIf
	If @error = 4 Then
		_LOG("No rom in " & $aConfig[1], 2, $iLOGPath)
		If $vFullScrape = 0 Then MsgBox($MB_ICONERROR, _MultiLang_GetText("err_title"), _MultiLang_GetText("err_FillRomList"))
		Return -1
	EndIf

	For $vBoucle = 1 To 12
		_ArrayColInsert($aRomList, $vBoucle)
	Next

	_LOG(UBound($aRomList) - 1 & " Rom(s) found", 0, $iLOGPath)

	For $vBoucle = 1 To UBound($aRomList) - 1
		$aRomList[$vBoucle][1] = $aConfig[1] & "\" & $aRomList[$vBoucle][0]
		$aPathSplit = _PathSplit($aRomList[$vBoucle][0], $sDrive, $sDir, $sFileName, $sExtension)
		$aRomList[$vBoucle][2] = $aPathSplit[3]
		$aRomList[$vBoucle][9] = -1
	Next
	Return $aRomList
EndFunc   ;==>_RomList_Create

Func _Check_Rom2Scrape($aRomList, $vNoRom, $aXMLRomList, $vTarget_RomPath, $vScrape_Mode, $aExtToHide = "", $aValueToHide = "")
	Local $sDrive = "", $sDir = "", $sFileName = "", $sExtension = "", $aPathSplit

	If IsArray($aExtToHide) Then
		$aPathSplit = _PathSplit($aRomList[$vNoRom][0], $sDrive, $sDir, $sFileName, $sExtension)
		$aFindDuplicate = _ArrayFindAll($aRomList, $sFileName, 0, 0, 0, 0, 2)
		For $vBoucle = 1 To UBound($aExtToHide) - 1
			If StringLeft($aExtToHide[$vBoucle], 1) <> "." Then $aExtToHide[$vBoucle] = "." & $aExtToHide[$vBoucle]
			If UBound($aFindDuplicate) > 1 And $sExtension = $aExtToHide[$vBoucle] Then
				$aRomList[$vNoRom][3] = 2
				_LOG($aRomList[$vNoRom][2] & " To Hide", 1, $iLOGPath)
				Return $aRomList
			EndIf
		Next
	EndIf

	If IsArray($aValueToHide) Then
		For $vBoucle = 1 To UBound($aValueToHide) - 1
			If StringInStr($aRomList[$vNoRom][0], $aValueToHide[$vBoucle]) Then
				$aRomList[$vNoRom][3] = 3
				_LOG($aRomList[$vNoRom][2] & " To Hide", 1, $iLOGPath)
				Return $aRomList
			EndIf
		Next
	EndIf

	Switch $vScrape_Mode
		Case 0
			_LOG($aRomList[$vNoRom][2] & " To Scrape ($vScrape_Mode=0)", 1, $iLOGPath)
			If $aRomList[$vNoRom][3] < 2 Then $aRomList[$vNoRom][3] = 1
			Return $aRomList
		Case Else
			If IsArray($aXMLRomList) Then
				If _ArraySearch($aXMLRomList, $vTarget_RomPath & StringReplace($aRomList[$vNoRom][0], "\", "/"), 0, 0, 0, 0, 1, 2) <> -1 Then
					_LOG($aRomList[$vNoRom][2] & " NOT Scraped ($vScrape_Mode=1)", 1, $iLOGPath)
					If $aRomList[$vNoRom][3] < 2 Then $aRomList[$vNoRom][3] = 0
					Return $aRomList
				EndIf
			EndIf
			_LOG($aRomList[$vNoRom][2] & " To Scrape ($vScrape_Mode=1)", 1, $iLOGPath)
			If $aRomList[$vNoRom][3] < 2 Then $aRomList[$vNoRom][3] = 1
			Return $aRomList
	EndSwitch
	Return $aRomList
EndFunc   ;==>_Check_Rom2Scrape

Func _CalcHash($aRomList, $vNoRom)
	If Not _Check_Cancel() Then Return $aRomList
	$TimerHash = TimerInit()
	$aRomList[$vNoRom][4] = FileGetSize($aRomList[$vNoRom][1])
	$aRomList[$vNoRom][5] = StringRight(_CRC32ForFile($aRomList[$vNoRom][1]), 8)
	$aRomList[$vNoRom][6] = _MD5ForFile($aRomList[$vNoRom][1])
	If Int(($aRomList[$vNoRom][4] / 1048576)) > 50 Or IniRead($iINIPath, "GENERAL", "$vQuick", 0) = 1 And _Check_Cancel() Then
		_LOG("QUICK Mode ", 1, $iLOGPath)
	Else
		$aRomList[$vNoRom][7] = _SHA1ForFile($aRomList[$vNoRom][1])
	EndIf
	_LOG("Rom Info (" & $aRomList[$vNoRom][0] & ") Hash in " & Round((TimerDiff($TimerHash) / 1000), 2) & "s", 0, $iLOGPath)
	_LOG("Size : " & $aRomList[$vNoRom][4], 1, $iLOGPath)
	_LOG("CRC32 : " & $aRomList[$vNoRom][5], 1, $iLOGPath)
	_LOG("MD5 : " & $aRomList[$vNoRom][6], 1, $iLOGPath)
	_LOG("SHA1 : " & $aRomList[$vNoRom][7], 1, $iLOGPath)
	Return $aRomList
EndFunc   ;==>_CalcHash

Func _XMLSystem_Create($vSSLogin = "", $vSSPassword = "")
	Local $oXMLSystem, $vXMLSystemPath = $iScriptPath & "\Ressources\systemlist.xml"
	$vXMLSystemPath = _DownloadWRetry("http://www.screenscraper.fr/api/systemesListe.php?devid=" & $iDevId & "&devpassword=" & $iDevPassword & "&softname=" & $iSoftname & "&output=XML&ssid=" & $vSSLogin & "&sspassword=" & $vSSPassword, $vXMLSystemPath)
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
				_LOG("systemlist.xml Opened", 1, $iLOGPath)
				Return $oXMLSystem
			EndIf
	EndSwitch
EndFunc   ;==>_XMLSystem_Create

Func _DownloadROMXML($aRomList, $vBoucle, $vSystemID, $vSSLogin = "", $vSSPassword = "")
	If Not _Check_Cancel() Then Return $aRomList
	Local $vXMLRom = $iTEMPPath & "\" & StringRegExpReplace($aRomList[$vBoucle][2], "[\[\]/\|\:\?""\*\\<>]", "") & ".xml"
	$aRomList[$vBoucle][8] = _DownloadWRetry("http://www.screenscraper.fr/api/jeuInfos.php?devid=" & $iDevId & "&devpassword=" & $iDevPassword & "&softname=" & $iSoftname & "&output=xml&ssid=" & $vSSLogin & "&sspassword=" & $vSSPassword & "&crc=" & $aRomList[$vBoucle][5] & "&md5=" & $aRomList[$vBoucle][6] & "&sha1=" & $aRomList[$vBoucle][7] & "&systemeid=" & $vSystemID & "&romtype=rom&romnom=" & $aRomList[$vBoucle][2] & "&romtaille=" & $aRomList[$vBoucle][4], $vXMLRom)
	If (StringInStr(FileReadLine($aRomList[$vBoucle][8]), "Erreur") Or Not FileExists($aRomList[$vBoucle][8])) Then
		$aRomList[$vBoucle][8] = _DownloadWRetry("http://www.screenscraper.fr/api/jeuInfos.php?devid=" & $iDevId & "&devpassword=" & $iDevPassword & "&softname=" & $iSoftname & "&output=xml&ssid=" & $vSSLogin & "&sspassword=" & $vSSPassword & "&crc=&md5=&sha1=&systemeid=" & $vSystemID & "&romtype=rom&romnom=" & $aRomList[$vBoucle][2] & "&romtaille=" & $aRomList[$vBoucle][4], $vXMLRom)
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
	Local $vRechSYS = IniRead($iINIPath, "LAST_USE", "$vRechSYS", 1)

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
		If $iSystem > 0 Then
			$vSystemTEMP = $aSystemListTXT[$iSystem][1]
			$iSystem = _ArraySearch($aSystemListXML, $vSystemTEMP)
			If $iSystem > 0 Then
				_LOG("System detected : " & $aSystemListXML[$iSystem][0] & "(" & $aSystemListXML[$iSystem][1] & ")", 0, $iLOGPath)
				Return $aSystemListXML[$iSystem][1]
			EndIf
		EndIf
		_LOG("No system found for : " & $vSystem, 0, $iLOGPath)
		If $vFullScrape = 1 Then Return ""
	EndIf

	$vSystemID = _SelectGUI($aSystemListXML, "", "system")
	_LOG("System selected No " & $vSystemID, 0, $iLOGPath)
	Return $vSystemID

EndFunc   ;==>_SelectSystem

Func _Results($aRomList, $vNbThread, $vFullTimer, $vFullScrape = 0)
	Local $vTimeTotal, $vTimeMoy = 0, $vNbRom = 0, $vNbRomScraped = 0, $vNbRomOK = 0
	Local $vTitle
	For $vBoucle = 1 To UBound($aRomList) - 1
		$vTimeMoy += $aRomList[$vBoucle][10]
		If $aRomList[$vBoucle][12] = 1 Then $vNbRomOK += 1
		If $aRomList[$vBoucle][11] = 1 Then $vNbRomScraped += 1
	Next
	If $vNbRomScraped > 0 Then
		$vTimeMoy = Round($vTimeMoy / $vNbRomScraped, 2) & " sec."
	Else
		$vTimeMoy = 'N/A'
	EndIf
	$vTimeMax = _ArrayMax($aRomList, 1, 0, Default, 10)
	$vTimeTotal = _FormatElapsedTime(Round((TimerDiff($vFullTimer) / 1000), 2))
	If $vNbRomScraped > 0 Then
		$vNbRomOKRatio = Round($vNbRomOK / $vNbRomScraped * 100) & "%"
	Else
		$vNbRomOKRatio = 'N/A'
	EndIf
	$vNbRom = UBound($aRomList) - 1

	_LOG("Results", 0, $iLOGPath)
	_LOG("Roms : = " & $vNbRom, 0, $iLOGPath)
	_LOG("Roms Found = " & $vNbRomOK & "/" & $vNbRomScraped, 0, $iLOGPath)
	_LOG("Average Time by Rom = " & $vTimeMoy, 0, $iLOGPath)
	_LOG("Max Time = " & $vTimeMax, 0, $iLOGPath)
	_LOG("Total Time = " & $vTimeTotal, 0, $iLOGPath)
	_LOG("Nb Thread = " & $vNbThread, 0, $iLOGPath)

	If $vFullScrape = 1 Then
		$vTitle = "FullScrape"
	Else
		$vTitle = StringSplit(IniRead($iINIPath, "LAST_USE", "$vSource_RomPath", ""), "\")
		$vTitle = $vTitle[UBound($vTitle) - 1]
	EndIf

	If $vScrapeCancelled = 1 Then $vTitle = $vTitle & " (Annulé)"

	#Region ### START Koda GUI section ### Form=
	$F_Results = GUICreate(_MultiLang_GetText("win_Results_Title"), 538, 403, -1, -1, BitOR($WS_EX_TOPMOST, $WS_EX_WINDOWEDGE))
	$L_Results = GUICtrlCreateLabel($vTitle, 8, 8, 247, 29)
	GUICtrlSetFont(-1, 15, 800, 0, "MS Sans Serif")
	$L_NbRom = GUICtrlCreateLabel(_MultiLang_GetText("win_Results_FilesFound"), 8, 56)
	$L_NbRomOK = GUICtrlCreateLabel(_MultiLang_GetText("win_Results_RomsFound"), 8, 80)
	$L_NbRomOKRatio = GUICtrlCreateLabel(_MultiLang_GetText("win_Results_PercentFound"), 8, 104)
	$L_TimeMoy = GUICtrlCreateLabel(_MultiLang_GetText("win_Results_MoyTime"), 305, 56)
	$L_TimeTotal = GUICtrlCreateLabel(_MultiLang_GetText("win_Results_FullTime"), 305, 80)
	$L_NbThread = GUICtrlCreateLabel(_MultiLang_GetText("win_Results_NbThread"), 305, 104)
	$L_NbRomValue = GUICtrlCreateLabel($vNbRom, 176, 56)
	$L_NbRomOKValue = GUICtrlCreateLabel($vNbRomOK & "/" & $vNbRomScraped, 176, 80)
	$L_NbRomOKRatioValue = GUICtrlCreateLabel($vNbRomOKRatio, 176, 104)
	$L_TimeMoyValue = GUICtrlCreateLabel($vTimeMoy, 448, 56)
	$L_TimeTotalValue = GUICtrlCreateLabel($vTimeTotal, 448, 80)
	$L_NbThreadValue = GUICtrlCreateLabel($vNbThread, 448, 104)
	$B_OK = GUICtrlCreateButton("OK", 104, 128, 147, 25)
;~ 	$B_Missing = GUICtrlCreateButton("Generer le fichier Missing", 288, 128, 147, 25)
	$G_Time = _GraphGDIPlus_Create($F_Results, 25, 160, 500, 190, 0xFF000000, 0xFF34495c)
	$L_Xmin = GUICtrlCreateLabel("1", 26, 355, 10, 17)
	$L_Xmax = GUICtrlCreateLabel($vNbRom, 325, 355, 200, 17, $SS_RIGHT)
	$L_Ymin = GUICtrlCreateLabel("0s", 0, 340, 24, 17, $SS_RIGHT)
	$L_Ymax = GUICtrlCreateLabel(Round($vTimeMax, 1) & "s", 0, 160, 24, 17, $SS_RIGHT)
;~ 	$G_Time = _GraphGDIPlus_Create($F_Results, 50, 160, 200, 150, 0xFF000000, 0xFF34495c)
	GUISetState(@SW_SHOW)
	GUISetState(@SW_DISABLE, $F_UniversalScraper)
	#EndRegion ### END Koda GUI section ###

	$vXTicks = 50
	If $vNbRom <= 50 Then $vXTicks = $vNbRom
	_GraphGDIPlus_Set_RangeX($G_Time, 1, Round($vNbRom), Round($vXTicks), 0)
	_GraphGDIPlus_Set_RangeY($G_Time, 0, Round($vTimeMax * 10) + 2, ((Round($vTimeMax)) * 10) + 2, 0)
	_GraphGDIPlus_Set_GridX($G_Time, 1, 0xFF6993BE)
	_GraphGDIPlus_Set_GridY($G_Time, 1, 0xFF6993BE)
	_GraphGDIPlus_Plot_Start($G_Time, 0, 0)
	_GraphGDIPlus_Set_PenColor($G_Time, 0xFFff0000)
	_GraphGDIPlus_Set_PenSize($G_Time, 2)

	For $vBoucle = 1 To $vNbRom
		_GraphGDIPlus_Plot_Line($G_Time, $vBoucle, $aRomList[$vBoucle][10] * 10)
	Next
	_GraphGDIPlus_Refresh($G_Time)

	While 1
		$nMsg = GUIGetMsg()
		Switch $nMsg
			Case $GUI_EVENT_CLOSE, $B_OK
				_GraphGDIPlus_Delete($F_Results, $G_Time)
				GUIDelete($F_Results)
				GUISetState(@SW_ENABLE, $F_UniversalScraper)
				WinActivate($F_UniversalScraper)
				Return

		EndSwitch
	WEnd

EndFunc   ;==>_Results

Func _SCRAPE($oXMLProfil, $vNbThread = 1, $vFullScrape = 0)
	While ProcessExists($iScraper)
		ProcessClose($iScraper)
	WEnd

	DirRemove($iTEMPPath, 1)
	DirCreate($iTEMPPath)
	DirCreate($iTEMPPath & "\scraped")
;~ 	$nMsg = ""

	If $aConfig <> 0 Then
		_GUI_Refresh($oXMLProfil, 1)
		Local $vScrapeCancelled = 0
		Local $aConfig = _LoadConfig($oXMLProfil)
		Local $aExtToHide = StringSplit(_XML_Read('/Profil/Element[Source_Value="%AutoHide%"]/AutoHideEXT', 0, "", $oXMLProfil), "|")
		Local $aValueToHide = StringSplit(_XML_Read('/Profil/Element[Source_Value="%AutoHide%"]/AutoHideValue', 0, "", $oXMLProfil), "|")
		Local $vSendTimerLeft = 0, $vCreateTimerLeft = 0, $vSendTimerMoy = 0, $vCreateTimerMoy = 0, $vSendTimerTotal = 0, $vCreateTimerTotal = 0
		Local $vEmpty_Rom = IniRead($iINIPath, "LAST_USE", "$vEmpty_Rom", 0)
		Local $vThreadUsed = 1
		$aConfig[8] = "0000"

		$vTEMPPathSSCheck = _DownloadWRetry("http://www.screenscraper.fr/api/ssuserInfos.php?devid=xxx&devpassword=yyy&softname=zzz&output=XML&ssid=" & $aConfig[13] & "&sspassword=" & $aConfig[14], $iScriptPath & "\Ressources\SSCheck.xml")
		$vSSLevel = Number(_XML_Read("/Data/ssuser/niveau", 0, $vTEMPPathSSCheck))
		If $vSSLevel < 1 Then $vSSLevel = 0
		Switch $vSSLevel
			Case 0
				$vNbThreadMax = 1
			Case 1 To 9
				$vNbThreadMax = 2
			Case 10 To 39
				$vNbThreadMax = 5
			Case 40 To 10000
				$vNbThreadMax = 10
			Case Else
				$vNbThreadMax = 1
		EndSwitch

		If $vNbThread > $vNbThreadMax Then
			_LOG("Are you a cheater ? BAD NbThread in INI : " & $vNbThread & "(MAX = " & $vNbThreadMax & ")", 0, $iLOGPath)
			$vNbThread = $vNbThreadMax
			IniWrite($iINIPath, "LAST_USE", "$vNbThread", $vNbThread)
		EndIf

		$aConfig[12] = _SelectSystem($oXMLSystem)
		$aRomList = _RomList_Create($aConfig, $vFullScrape)
		If IsArray($aRomList) And _Check_Cancel() Then

			If $aConfig[5] = 0 Or ($aConfig[5] > 0 And FileGetSize($aConfig[0]) < 100) Then
				_LOG("vScrape_Mode = " & $aConfig[5] & " And " & $aConfig[0] & " = " & FileGetSize($aConfig[0]) & " ---> _XML_Make", 1, $iLOGPath)
				$oXMLTarget = _XML_Make($aConfig[0], _XML_Read("Profil/Root/Target_Value", 0, "", $oXMLProfil))
			EndIf

			$vXpath2RomPath = "/" & _XML_Read("Profil/Root/Target_Value", 0, "", $oXMLProfil) & "/" & _XML_Read("Profil/Element[@Type='RomPath']/Target_Value", 0, "", $oXMLProfil)
			If FileGetSize($aConfig[0]) > 100 And _Check_Cancel() Then $aXMLRomList = _XML_ListValue($vXpath2RomPath, $aConfig[0])
;~ 			_ArrayDisplay($aXMLRomList, "$aXMLRomList")

			For $vBoucle = 1 To $vNbThread
				ShellExecute($iScriptPath & "\" & $iScraper, $vBoucle)
;~ 				Sleep(100)
			Next

			For $vBoucle = 1 To UBound($aRomList) - 1
				$vSendTimer = TimerInit()
				Local $PercentProgression = Round(($vBoucle * 100) / UBound($aRomList) - 1)
				GUICtrlSetData($PB_SCRAPE, $PercentProgression)
				_GUICtrlStatusBar_SetText($L_SCRAPE, $aRomList[$vBoucle][2])
				_GUICtrlStatusBar_SetText($L_SCRAPE, "Sending  : " & _FormatElapsedTime($vSendTimerLeft), 1)
				_GUICtrlStatusBar_SetText($L_SCRAPE, @TAB & @TAB & $vBoucle & "/" & UBound($aRomList) - 1, 2)
				$aRomList = _Check_Rom2Scrape($aRomList, $vBoucle, $aXMLRomList, $aConfig[2], $aConfig[5], $aExtToHide, $aValueToHide)
				If $aRomList[$vBoucle][3] >= 1 And _Check_Cancel() Then
					If $aRomList[$vBoucle][3] < 2 Then
						$aRomList = _CalcHash($aRomList, $vBoucle)
					EndIf
					$aRomList = _DownloadROMXML($aRomList, $vBoucle, $aConfig[12], $aConfig[13], $aConfig[14])

					If ($aRomList[$vBoucle][9] = 1 Or $vEmpty_Rom = 1 Or $aRomList[$vBoucle][3] > 1) And _Check_Cancel() Then
						_XML_Make($iTEMPPath & "\scraped\" & $vBoucle & ".xml", _XML_Read("Profil/Game/Target_Value", 0, "", $oXMLProfil))
						$sMailSlotName = "\\.\mailslot\Son" & $vThreadUsed
						$vMessage = _ArrayToString($aRomList, '{Break}', $vBoucle, $vBoucle, '{Break}')
						$vResultSM = _SendMail($sMailSlotName, $vMessage)
						$vResultSM = _SendMail($sMailSlotName, $vBoucle)
						$vMessage = _ArrayToString($aConfig, '{Break}')
						$vResultSM = _SendMail($sMailSlotName, $vMessage)
						$vResultSM = _SendMail($sMailSlotName, $vProfilsPath)
						If $vResultSM = 1 Then
							$aRomList[$vBoucle][11] = 1
							$vThreadUsed += 1
							If $vThreadUsed > $vNbThread Then $vThreadUsed = 1
						Else
							_LOG("Error Thread No " & $vThreadUsed & " Doesn't exist anymore Try to Relaunch", 2, $iLOGPath)
							ShellExecute($iScriptPath & "\" & $iScraper, $vThreadUsed)
						EndIf
					EndIf
				EndIf
				If Not _Check_Cancel() Then
					For $vBoucle2 = 1 To $vNbThread
						_SendMail($sMailSlotCancel & $vBoucle2, "CANCELED")
					Next
					$vBoucle = UBound($aRomList) - 1
				EndIf

				$vSendTimerTotal = $vSendTimerTotal + Round((TimerDiff($vSendTimer) / 1000), 2)
				$vSendTimerMoy = Round($vSendTimerTotal / $vBoucle, 2)
				$vSendTimerLeft = $vSendTimerMoy * (UBound($aRomList) - 1 - $vBoucle)
			Next

			If Not _Check_Cancel() Then
				$vTotalRomToScrap = _MailSlotGetMessageCount($hMailSlotMother)
			Else
				$vTotalRomToScrap = 0
				For $vBoucle = 1 To UBound($aRomList) - 1
					If $aRomList[$vBoucle][11] = 1 Then $vTotalRomToScrap += 1
				Next
			EndIf

			Dim $aXMLTarget
			_FileReadToArray($aConfig[0], $aXMLTarget)
			_ArrayDelete($aXMLTarget, 0)
			FileDelete($aConfig[0])
			$vBoucle = UBound($aXMLTarget) - 1
			While $vBoucle <> 0
				If $aXMLTarget[$vBoucle] = "" Then
					_ArrayDelete($aXMLTarget, $vBoucle)
				Else
					$vLastLine = $aXMLTarget[$vBoucle]
					_ArrayDelete($aXMLTarget, $vBoucle)
					ExitLoop
				EndIf
				$vBoucle -= 1
			WEnd
			If $vLastLine = '<' & _XML_Read("Profil/Root/Target_Value", 0, "", $oXMLProfil) & '/>' Then
				_ArrayAdd($aXMLTarget, '<' & _XML_Read("Profil/Root/Target_Value", 0, "", $oXMLProfil) & '>')
				$vLastLine = '</' & _XML_Read("Profil/Root/Target_Value", 0, "", $oXMLProfil) & '>'
			EndIf

			$iNumberOfMessagesOverall = 0
			While $iNumberOfMessagesOverall < $vTotalRomToScrap
				$vCreateTimer = TimerInit()
				If _MailSlotGetMessageCount($hMailSlotMother) >= 1 Then
					$iNumberOfMessagesOverall += 1
					Local $PercentProgression = Round(($iNumberOfMessagesOverall * 100) / $vTotalRomToScrap)
					GUICtrlSetData($PB_SCRAPE, $PercentProgression)
					$vMessageFromChild = _ReadMessage($hMailSlotMother)
					$aMessageFromChild = StringSplit($vMessageFromChild, '|', $STR_ENTIRESPLIT + $STR_NOCOUNT)
					ReDim $aMessageFromChild[2]
					_LOG("Receveid Message Rom no " & $aMessageFromChild[0] & " in " & $aMessageFromChild[1] & "s", 1, $iLOGPath)
					Dim $aXMLSource
					_GUICtrlStatusBar_SetText($L_SCRAPE, $aRomList[$aMessageFromChild[0]][2])
					_GUICtrlStatusBar_SetText($L_SCRAPE, "Creating  : " & _FormatElapsedTime($vCreateTimerLeft), 1)
					_GUICtrlStatusBar_SetText($L_SCRAPE, @TAB & @TAB & $iNumberOfMessagesOverall & "/" & ($vTotalRomToScrap) - 1, 2)
					_FileReadToArray($iTEMPPath & "\scraped\" & $aMessageFromChild[0] & ".xml", $aXMLSource)
					For $vBoucle = 1 To UBound($aXMLSource) - 1
						_ArrayAdd($aXMLTarget, $aXMLSource[$vBoucle])
					Next
					$aRomList[$aMessageFromChild[0]][10] = $aMessageFromChild[1]
					$aRomList[$aMessageFromChild[0]][12] = 1

				EndIf
				If GUIGetMsg() = $B_SCRAPE Then
					_LOG("Scrape Cancelled", 0, $iLOGPath)
					$vScrapeCancelled = 1
					For $vBoucle2 = 1 To $vNbThread
						_SendMail($sMailSlotCancel & $vBoucle2, "CANCELED")
					Next
					$vTotalRomToScrap = $iNumberOfMessagesOverall
				EndIf
				$vCreateTimerTotal = $vCreateTimerTotal + Round(($aRomList[$iNumberOfMessagesOverall][10] / 1000), 2)
				$vCreateTimerMoy = $vCreateTimerTotal / $iNumberOfMessagesOverall
				$vCreateTimerLeft = $vCreateTimerMoy * ($vTotalRomToScrap - $iNumberOfMessagesOverall)
			WEnd
			_ArrayAdd($aXMLTarget, $vLastLine)
			_FileWriteFromArray($aConfig[0], $aXMLTarget)

			Local $oXMLAfterTidy = _XML_CreateDOMDocument(Default)
			$oToTidy = _XML_Open($aConfig[0])
			Local $vXMLAfterTidy = _XML_TIDY($oToTidy, -1)
			_XML_LoadXML($oXMLAfterTidy, $vXMLAfterTidy)
			FileDelete($aConfig[0])
			_XML_SaveToFile($oXMLAfterTidy, $aConfig[0])

			GUICtrlSetData($PB_SCRAPE, 0)
			_GUICtrlStatusBar_SetText($L_SCRAPE, "", 0)
			_GUICtrlStatusBar_SetText($L_SCRAPE, "", 1)
			_GUICtrlStatusBar_SetText($L_SCRAPE, "", 2)
			_CreateMissing($aRomList, $aConfig)
		EndIf
	EndIf
	While ProcessExists($iScraper)
		ProcessClose($iScraper)
	WEnd
	For $vBoucle = 1 To $vNbThread
		DirRemove($iTEMPPath & $vBoucle, 1)
	Next
	Return $aRomList
EndFunc   ;==>_SCRAPE

Func _CreateMissing($aRomList, $aConfig)
	$vSysName = _XML_Read('/Data/systeme[id=' & $aConfig[12] & ']/noms/nom_eu', 0, $iScriptPath & "\Ressources\systemlist.xml")
;~ 	_ArrayDisplay($aConfig, "$aConfig")
	If Not _FileCreate($aConfig[1] & '\' & $vSysName & "_missing.txt") Then MsgBox(4096, "Error", " Erreur creation du Fichier missing      error:" & @error)
	For $vBoucle = 1 To UBound($aRomList) - 1
		If $aRomList[$vBoucle][9] = 0 Then
			$tCur = _Date_Time_GetLocalTime()
			$vMissing_Line1 = StringLeft($aRomList[$vBoucle][0] & "                                                                     ", 68)
			$vMissing_Line2 = $aRomList[$vBoucle][5]
			$vMissing_Line3 = StringRight("                  " & StringRegExpReplace($aRomList[$vBoucle][4], '\G(\d+?)(?=(\d{3})+(\D|$))', '$1 '), 17) & "    "
			$hFile = _WinAPI_CreateFile($aRomList[$vBoucle][1], 2)
			$aTime = _Date_Time_GetFileTime($hFile)
			_WinAPI_CloseHandle($hFile)
			$vTime = _Date_Time_FileTimeToStr($aTime[2])
			$vTime = StringMid($vTime, 12, 5) & ".00 " & StringMid($vTime, 7, 4) & "-" & StringLeft($vTime, 2) & "-" & StringMid($vTime, 4, 2)
			$vMissing_Line4 = "    " & $aRomList[$vBoucle][6]
			FileWrite($aConfig[1] & '\' & $vSysName & "_missing.txt", $vMissing_Line1 & $vMissing_Line2 & $vMissing_Line3 & $vTime & $vMissing_Line4 & @CRLF)
		EndIf
	Next
EndFunc   ;==>_CreateMissing

Func _WizardWindow($vTitle, $vDescription, $vInputValue, $vInputDefault = "", $vInputType = 0, $vNext = 1, $vBack = 1, $vCancel = 1)
	Local $vReturnValue
	$vDescription = StringReplace($vDescription, "|!|", @CRLF)
	#Region ### START Koda GUI section ### Form=
	$F_WIZARD = GUICreate($vTitle, 426, 314)
	$P_UXS = GUICtrlCreatePic($iScriptPath & "\Ressources\UXS Wizard.jpg", 8, 6, 200, 300)
	$G_DESC = GUICtrlCreateGroup("", 216, 0, 200, 244)
	$L_DESC = GUICtrlCreateLabel($vDescription, 224, 8, 185, 233)
	GUICtrlCreateGroup("", -99, -99, 1, 1)
	$I_INPUT = GUICtrlCreateInput("", 216, 248, 161, 21)
	$B_BROWSE = GUICtrlCreateButton("...", 384, 248, 27, 21)
	$B_BACK = GUICtrlCreateButton(_MultiLang_GetText("win_Wizard_Back"), 296, 280, 59, 25)
	$B_CANCEL = GUICtrlCreateButton(_MultiLang_GetText("win_Wizard_End"), 216, 280, 75, 25)
	$B_NEXT = GUICtrlCreateButton(_MultiLang_GetText("win_Wizard_Next"), 360, 280, 59, 25)
	$C_COMBO = GUICtrlCreateCombo("", 216, 248, 201, 25, BitOR($GUI_SS_DEFAULT_COMBO, $CBS_SIMPLE))
	GUISetState(@SW_SHOW)
	GUISetState(@SW_DISABLE, $F_UniversalScraper)
	#EndRegion ### END Koda GUI section ###

	Switch $vInputType
		Case 1 ; Combo
			GUICtrlSetState($I_INPUT, $GUI_HIDE)
			GUICtrlSetState($B_BROWSE, $GUI_HIDE)
			GUICtrlSetData($C_COMBO, $vInputValue, $vInputDefault)
		Case 2 ; Input + Browse Button
			GUICtrlSetData($I_INPUT, $vInputDefault)
			GUICtrlSetState($C_COMBO, $GUI_HIDE)
		Case 3 ; Input
			GUICtrlSetData($I_INPUT, $vInputDefault)
			GUICtrlSetState($C_COMBO, $GUI_HIDE)
			GUICtrlSetState($B_BROWSE, $GUI_HIDE)
		Case Else ;Nothing
			GUICtrlSetState($I_INPUT, $GUI_HIDE)
			GUICtrlSetState($B_BROWSE, $GUI_HIDE)
			GUICtrlSetState($C_COMBO, $GUI_HIDE)
	EndSwitch

	If $vNext = 0 Then GUICtrlSetState($B_NEXT, $GUI_HIDE)
	If $vBack = 0 Then GUICtrlSetState($B_BACK, $GUI_HIDE)
	If $vCancel = 0 Then GUICtrlSetState($B_CANCEL, $GUI_HIDE)

	While 1
		$nMsg = GUIGetMsg()
		Switch $nMsg
			Case $B_BROWSE
				$vBrowse = FileSelectFolder("", GUICtrlRead($I_INPUT), $FSF_CREATEBUTTON, GUICtrlRead($I_INPUT), $F_WIZARD)
				GUICtrlSetData($I_INPUT, $vBrowse)
			Case $B_NEXT
				Switch $vInputType
					Case 1
						$vReturnValue = GUICtrlRead($C_COMBO)
					Case 2
						$vReturnValue = GUICtrlRead($I_INPUT)
					Case 3
						$vReturnValue = GUICtrlRead($I_INPUT)
					Case Else
						$vReturnValue = 1
				EndSwitch
				GUIDelete($F_WIZARD)
				GUISetState(@SW_ENABLE, $F_UniversalScraper)
				WinActivate($F_UniversalScraper)
				Return $vReturnValue
			Case $B_BACK
				GUIDelete($F_WIZARD)
				GUISetState(@SW_ENABLE, $F_UniversalScraper)
				WinActivate($F_UniversalScraper)
				Return -1
			Case $B_CANCEL
				GUIDelete($F_WIZARD)
				GUISetState(@SW_ENABLE, $F_UniversalScraper)
				WinActivate($F_UniversalScraper)
				Return -2
		EndSwitch
	WEnd

EndFunc   ;==>_WizardWindow

Func _WizardProfil()
	; Loading profils list
	Local $vProfilDefault, $vProfilList = ""
	Local $aProfilList = _FileListToArrayRec($iProfilsPath, "*.xml", $FLTAR_FILES, $FLTAR_NORECUR, $FLTAR_SORT, $FLTAR_FULLPATH)
	If Not IsArray($aProfilList) Then
		_LOG("No Profils found", 2, $iLOGPath)
		Exit
	EndIf
	_ArrayColInsert($aProfilList, 0)
	_ArrayColInsert($aProfilList, 0)
	_ArrayDelete($aProfilList, 0)
	For $vBoucle = 0 To UBound($aProfilList) - 1
		$aProfilList[$vBoucle][0] = _XML_Read("Profil/Name", 1, $aProfilList[$vBoucle][2])
		If StringInStr($aProfilList[$vBoucle][0], $vProfilsPath) Then $vProfilsPath = $aProfilList[$vBoucle][2]
		$vProfilList = $vProfilList & $aProfilList[$vBoucle][0] & "|"
	Next

	$vProfilDefault = IniRead($iINIPath, "LAST_USE", "$vProfilsPath", "")
	If $vProfilDefault = "" Then
		$vProfilDefault = $aProfilList[0][0]
	Else
		For $vBoucle = 0 To UBound($aProfilList) - 1
			If StringInStr($aProfilList[$vBoucle][2], $vProfilDefault) Then $vProfilDefault = $aProfilList[$vBoucle][0]
		Next
	EndIf

	$vResultWZ = _WizardWindow(_MultiLang_GetText("win_Wizard_Profil_Title"), _MultiLang_GetText("win_Wizard_Profil_Desc"), $vProfilList, $vProfilDefault, 1, 1, 0, 0)
	If $vResultWZ < 0 Then Return $vResultWZ
	For $i = 0 To UBound($aProfilList) - 1
		If StringInStr($aProfilList[$i][0], $vResultWZ) Then $vProfilsPath = $aProfilList[$i][2]
	Next
	Return $vProfilsPath
EndFunc   ;==>_WizardProfil

Func _WizardAutoconf()
	; Autoconf
	$vResultWZ = _WizardWindow(_MultiLang_GetText("win_Wizard_Autoconf_Title"), _MultiLang_GetText("win_Wizard_Autoconf_Desc"), "", _XML_Read("Profil/AutoConf/Source_RootPath", 0, "", $oXMLProfil), 2, 1, 1, 0)
	If $vResultWZ < 0 Then Return $vResultWZ
	_LOG("Wizard - Autoconf Path : " & $vResultWZ, 0, $iLOGPath)
	If (StringRight($vResultWZ, 1) = '\') Then StringTrimRight($vResultWZ, 1)
	Return $vResultWZ
EndFunc   ;==>_WizardAutoconf

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
;~ 	$aConfig[6]=$vMissingRom_Mode (0 = No missing Rom, 1 = Adding missing Rom)
;~ 	$aConfig[7]=$vCountryPic_Mode (0 = Language Pic, 1 = Rom Pic, 2 = Language Pic Strict, 3 = Rom Pic Strict)
;~ 	$aConfig[8]=$oTarget_XML
;~ 	$aConfig[9]=$aLangPref
;~ 	$aConfig[10]=$aCountryPref
;~ 	$aConfig[11]=$aMatchingCountry
;~ 	$aConfig[12]=$vSystemId
;~ 	$aConfig[13]=$vSSLogin
;~ 	$aConfig[14]=$vSSPassword

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
;~ 	$aRomList[][11]=Send to the scraper
;~ 	$aRomList[][12]=Return from the scraper

