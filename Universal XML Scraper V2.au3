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

;FileInstall
;-----------
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
FileInstall(".\Ressources\thegamedb.jpg", $iScriptPath & "\Ressources\thegamedb.jpg")
FileInstall(".\Ressources\Screenscraper.jpg", $iScriptPath & "\Ressources\Screenscraper.jpg")
FileInstall(".\Ressources\Screenscraper (MIX).jpg", $iScriptPath & "\Ressources\Screenscraper (MIX).jpg")
FileInstall(".\Ressources\RecalboxV3.jpg", $iScriptPath & "\Ressources\RecalboxV3.jpg")
FileInstall(".\Ressources\RecalboxV4.jpg", $iScriptPath & "\Ressources\RecalboxV4.jpg")
FileInstall(".\Ressources\Recalbox.jpg", $iScriptPath & "\Ressources\Recalbox.jpg")
FileInstall(".\Ressources\Hyperspin.jpg", $iScriptPath & "\Ressources\Hyperspin.jpg")
FileInstall(".\Ressources\Emulationstation.jpg", $iScriptPath & "\Ressources\Emulationstation.jpg")
FileInstall(".\Ressources\Attract-Mode.jpg", $iScriptPath & "\Ressources\Attract-Mode.jpg")
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
FileInstall(".\Mix\Arcade (moon) By Supernature2k.zip", $iScriptPath & "\Mix\")
FileInstall(".\Mix\Arcade (moon).zip", $iScriptPath & "\Mix\")
FileInstall(".\Mix\Background (Modified DarKade-Theme by Nachtgarm).zip", $iScriptPath & "\Mix\")
FileInstall(".\Mix\Oldtv (Multi Sys).zip", $iScriptPath & "\Mix\")
FileInstall(".\Mix\Standard (3img).zip", $iScriptPath & "\Mix\")
FileInstall(".\Mix\Standard (4img)  By Supernature2k.zip", $iScriptPath & "\Mix\")
FileInstall(".\ProfilsFiles\Screenscraper-RecalboxV4.xml", $iScriptPath & "\ProfilsFiles\")
_LOG("Ending files installation", 1)

;Const def
;---------
Global $iDevId = BinaryToString(_Crypt_DecryptData("0x1552EDED2FA9B5", "1gdf1g1gf", $CALG_RC4))
Global $iDevPassword = BinaryToString(_Crypt_DecryptData("0x1552EDED2FA9B547FBD0D9A623D954AE7BEDC681", "1gdf1g1gf", $CALG_RC4))
Global $iLangPath = $iScriptPath & "\LanguageFiles" ; Where we are storing the language files.
Global $iProfilsPath = $iScriptPath & "\ProfilsFiles" ; Where we are storing the profils files.
Global $vProfilsPath = IniRead($iINIPath, "LAST_USE", "$vProfilsPath", -1)

_LOG("Verbose LVL : " & $iVerboseLVL, 1)
_LOG("Path to ini : " & $iINIPath, 1)
_LOG("Path to log : " & $iLOGPath, 1)
_LOG("Path to language : " & $iLangPath, 1)

;Variable def
;------------
Global $vUserLang = IniRead($iINIPath, "LAST_USE", "$vUserLang", -1)
Local $vSelectedProfil = -1
Local $L_SCRAPE_Parts[2] = [275, -1]
Local $oXMLProfil

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
$oXMLProfil = _XML_CreateDOMDocument()
_XML_Load($oXMLProfil, $vProfilsPath)
If @error Then
	_LOG('_XML_Load @error:' & @CRLF & XML_My_ErrorParser(@error), 2)
	Exit
EndIf
_XML_TIDY($oXMLProfil)
If @error Then
	_LOG('_XML_TIDY @error:' & @CRLF & XML_My_ErrorParser(@error), 2)
	Exit
EndIf

; Main GUI
#Region ### START Koda GUI section ### Form=
Local $F_UniversalScraper = GUICreate(_MultiLang_GetText("main_gui"), 350, 181, 215, 143)
GUISetBkColor(0x34495c, $F_UniversalScraper)
Local $MF = GUICtrlCreateMenu(_MultiLang_GetText("mnu_file"))
Local $MF_Profil = GUICtrlCreateMenuItem(_MultiLang_GetText("mnu_file_profil"), $MF)
Local $MF_Separation = GUICtrlCreateMenuItem("", $MF)
Local $MF_Exit = GUICtrlCreateMenuItem(_MultiLang_GetText("mnu_file_exit"), $MF)
Local $ME = GUICtrlCreateMenu(_MultiLang_GetText("mnu_edit"))
Local $ME_Config_LU = GUICtrlCreateMenuItem(_MultiLang_GetText("mnu_edit_config_LU"), $ME)
Local $ME_config_autoconf = GUICtrlCreateMenuItem(_MultiLang_GetText("mnu_edit_config_autoconf"), $ME)
Local $ME_Separation = GUICtrlCreateMenuItem("", $ME)
Local $ME_AutoConfig = GUICtrlCreateMenu(_MultiLang_GetText("mnu_edit_autoconf"), $ME, 1)
Local $ME_FullScrape = GUICtrlCreateMenuItem(_MultiLang_GetText("mnu_edit_fullscrape"), $ME)
Local $ME_Miximage = GUICtrlCreateMenuItem(_MultiLang_GetText("mnu_edit_miximage"), $ME)
Local $ME_Langue = GUICtrlCreateMenuItem(_MultiLang_GetText("mnu_edit_langue"), $ME)
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

Local $vPlink_Command = _XML_ListNode("Profil/Plink/Command", "", $oXMLProfil)
If IsArray($vPlink_Command) Then
	Local $MP_[UBound($vPlink_Command)]
	For $vBoucle = 1 To UBound($vPlink_Command) - 1
		$MP_[$vBoucle] = GUICtrlCreateMenuItem(_MultiLang_GetText("mnu_ssh_" & $vPlink_Command[$vBoucle][0]), $MP)
	Next
EndIf

GUISetState(@SW_SHOW)
#EndRegion ### END Koda GUI section ###
_LOG("GUI Constructed", 1)
_Refresh_GUI($oXMLProfil)

While 1
	Local $nMsg = GUIGetMsg()
	Switch $nMsg
		Case $GUI_EVENT_CLOSE, $MF_Exit ; Exit
			_LOG("Universal XML Scraper Closed")
			Exit
		Case $MF_Profil ;Profil Selection
			$vProfilsPath = _ProfilSelection($iProfilsPath)
			IniWrite($iINIPath, "LAST_USE", "$vProfilsPath", $vProfilsPath)
			;Opening XML Profil file
			$oXMLProfil = _XML_CreateDOMDocument()
			_XML_Load($oXMLProfil, $vProfilsPath)
			If @error Then
				_LOG('_XML_Load @error:' & @CRLF & XML_My_ErrorParser(@error), 2)
				Exit
			EndIf
			_XML_TIDY($oXMLProfil)
			If @error Then
				_LOG('_XML_TIDY @error:' & @CRLF & XML_My_ErrorParser(@error), 2)
				Exit
			EndIf
			_Refresh_GUI($oXMLProfil)
		Case $ME_Langue
			$aLangList = _MultiLang_LoadLangDef($iLangPath, -1)
			If Not IsArray($aLangList) Or $aLangList < 0 Then
				_LOG("Impossible to load language", 2)
				Exit
			EndIf
			_Refresh_GUI($oXMLProfil)
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
		Case $ME_Config_LU
			_GUI_Config_LU()
		Case $ME_config_autoconf
			_GUI_Config_autoconf($oXMLProfil)
		Case $B_SCRAPE
			$aConfig = _LoadConfig($oXMLProfil)
;~ 			If _SCRAPING_VERIF() = 0 Then
;~ 				If _GUI_REFRESH($INI_P_SOURCE, $INI_P_CIBLE, 1) = 1 Then
;~ 					$FullTimer = TimerInit()
;~ 					$V_Header = IniRead($PathConfigINI, $A_Profil[$No_Profil], "$HEADER_1", "0")
;~ 					$A_System = _SYSTEM_CREATEARRAY_SCREENSCRAPER()
;~ 					$No_system = _SYSTEM_SelectGUI($A_System)
;~ 					$A_ROMList = _SCRAPING($No_Profil, $A_Profil, $vSource_RomPath, $No_system, $vUpperCase, $V_Header)
;~ 					If IsArray($A_ROMList) Then
;~ 						_FUSIONXML($V_Header, $A_ROMList)
;~ 						_SCRAPING_BILAN(TimerDiff($FullTimer), $A_ROMList)
;~ 					EndIf
;~ 					FileDelete($PathDIRTmp)
;~ 					FileDelete($PathTmp_GAME)
;~ 					FileDelete($PathTmp_SYS)
;~ 				EndIf
;~ 			EndIf
;~ 			_GUI_REFRESH($INI_P_SOURCE, $INI_P_CIBLE, 0)
	EndSwitch
	;SSH Menu
	If IsArray($vPlink_Command) Then
		For $vBoucle = 1 To UBound($vPlink_Command) - 1
			If $nMsg = $MP_[$vBoucle] Then _Plink($oXMLProfil, $vPlink_Command[$vBoucle][0])
		Next
	EndIf
WEnd

;---------;
;Fonctions;
;---------;

#Region Function
Func _LoadConfig($oXMLProfil)
	Local $aConfig[6]
	$aConfig[0] = IniRead($iINIPath, "LAST_USE", "Target_RootPath", "")
	$aConfig[1] = IniRead($iINIPath, "LAST_USE", "Target_XMLName", "")
	$aConfig[2] = IniRead($iINIPath, "LAST_USE", "Source_RomPath", "")
	$aConfig[3] = IniRead($iINIPath, "LAST_USE", "Target_RomPath", "")
	$aConfig[4] = IniRead($iINIPath, "LAST_USE", "Source_ImagePath", "")
	$aConfig[5] = IniRead($iINIPath, "LAST_USE", "Target_ImagePath", "")

EndFunc   ;==>_LoadConfig

Func _ProfilSelection($iProfilsPath, $vProfilsPath = -1) ;Profil Selection
	; Loading profils list
	$aProfilList = _FileListToArrayRec($iProfilsPath, "*.xml", $FLTAR_FILES, $FLTAR_NORECUR, $FLTAR_SORT, $FLTAR_FULLPATH)
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

Func _Refresh_GUI($oXMLProfil = -1, $ScrapIP = 0, $vScrapeOK = 0) ;Refresh GUI
	Local $vPlink_Command
	If $oXMLProfil <> -1 Then
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

		If _XML_NodeExists($oXMLProfil, "Profil/Plink/Ip") = $XML_RET_FAILURE Then
			_LOG("SSH Disable", 1)
			GUICtrlSetState($MP, $GUI_DISABLE)
		Else
			_LOG("SSH Enable", 1)
			GUICtrlSetState($MP, $GUI_ENABLE)
		EndIf

		GUICtrlSetState($MF, $GUI_ENABLE)
		GUICtrlSetData($MF, _MultiLang_GetText("mnu_file"))
		GUICtrlSetData($MF_Profil, _MultiLang_GetText("mnu_file_profil"))
		GUICtrlSetData($MF_Exit, _MultiLang_GetText("mnu_file_exit"))

		GUICtrlSetState($ME, $GUI_ENABLE)
		GUICtrlSetData($ME, _MultiLang_GetText("mnu_edit"))
		GUICtrlSetData($ME_AutoConfig, _MultiLang_GetText("mnu_edit_autoconf"))
		GUICtrlSetData($ME_FullScrape, _MultiLang_GetText("mnu_edit_fullscrape"))
		GUICtrlSetData($ME_Miximage, _MultiLang_GetText("mnu_edit_miximage"))
		GUICtrlSetData($ME_Langue, _MultiLang_GetText("mnu_edit_langue"))
		GUICtrlSetData($ME_Config_LU, _MultiLang_GetText("mnu_edit_config_LU"))
		GUICtrlSetData($ME_config_autoconf, _MultiLang_GetText("mnu_edit_config_autoconf"))

		GUICtrlSetData($MP, _MultiLang_GetText("mnu_ssh"))

		$vPlink_Command = _XML_ListNode("Profil/Plink/Command", "", $oXMLProfil)
		If IsArray($vPlink_Command) Then
			For $vBoucle = 1 To UBound($vPlink_Command) - 1
				GUICtrlSetData($MP_[$vBoucle], _MultiLang_GetText("mnu_ssh_" & $vPlink_Command[$vBoucle][0]))
			Next
		EndIf

		GUICtrlSetState($MH, $GUI_ENABLE)
		GUICtrlSetData($MH, _MultiLang_GetText("mnu_help"))
		GUICtrlSetData($MH_Help, _MultiLang_GetText("mnu_help_about"))

		GUICtrlSetData($B_SCRAPE, _MultiLang_GetText("scrap_button"))
		GUICtrlSetState($PB_SCRAPE, $GUI_HIDE)
		_GUICtrlStatusBar_SetText($L_SCRAPE, "")

		_LOG("GUI Refresh", 1)
	EndIf

	Local $SCRAP_ENABLE
	Local $vErrorMess = ""
	If $ScrapIP = 0 Then

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

;~ 		$A_DIRList = _AUTOCONF($PATHAUTOCONF_PathRom, $PATHAUTOCONF_Target_RomPath, $PATHAUTOCONF_PathNew, $PATHAUTOCONF_PathImage, $PATHAUTOCONF_PathImageSub)
;~ 	Else
;~ 		If $Menu_SSH = 2 Then GUICtrlSetState($MP, $GUI_DISABLE)
;~ 		_CREATION_LOGMESS(2, "Menu SSH Disable")
;~ 		GUICtrlSetState($MF, $GUI_DISABLE)
;~ 		GUICtrlSetState($ME, $GUI_DISABLE)
;~ 		GUICtrlSetState($MH, $GUI_DISABLE)
;~ 		GUICtrlSetImage($B_SCRAPE, $SOURCE_DIRECTORY & "\Ressources\Fleche_IP1.bmp", -1, 0)
;~ 		$SCRAP_ENABLE = 1
;~ 		GUICtrlSetState($PB_SCRAPE, $GUI_SHOW)
	EndIf
	Return $SCRAP_ENABLE
EndFunc   ;==>_Refresh_GUI

Func _Plink($oXMLProfil, $vPlinkCommand) ;Send a Command via Plink
	Local $vPlink_Ip = _XML_Read("Profil/Plink/Ip", 0, "", $oXMLProfil)
	Local $vPlink_Root = _XML_Read("Profil/Plink/Root", 0, "", $oXMLProfil)
	Local $vPlink_Pswd = _XML_Read("Profil/Plink/Pswd", 0, "", $oXMLProfil)
	Local $vPlink_Command = _XML_Read("Profil/Plink/Command/" & $vPlinkCommand, 0, "", $oXMLProfil)

	If MsgBox($MB_OKCANCEL, $vPlinkCommand, _MultiLang_GetText("mess_ssh_" & $vPlinkCommand)) = $IDOK Then
		$sRun = $iScriptPath & "\Ressources\plink.exe " & $vPlink_Ip & " -l " & $vPlink_Root & " -pw " & $vPlink_Pswd & " " & $vPlink_Command
		$iPid = Run($sRun, '', @SW_HIDE, $STDERR_CHILD + $STDOUT_CHILD)
		While ProcessExists($iPid)
			$_StderrRead = StderrRead($iPid)
			If Not @error And $_StderrRead <> '' Then
				If StringInStr($_StderrRead, 'Unable to open connection') Then
					_LOG("Unable to open connection with Plink (" & $vPlink_Root & ":" & $vPlink_Pswd & "@" & $vPlink_Ip & ")", 2)
					Return -1
				EndIf
			EndIf
		WEnd
		_LOG("SSH : " & $vPlink_Command)
	Else
		_LOG("SSH canceled : " & $vPlink_Command, 1)
	EndIf
EndFunc   ;==>_Plink

;~ Func _SCRAPING_VERIF()
;~ 	Local $vErrorMess = "", $vScrapeOK = 0
;~ 	If (StringRight($vSource_RomPath, 1) = '\') Then $vSource_RomPath = StringTrimRight($vSource_RomPath, 1)
;~ 	If FileExists($vSource_RomPath) Then
;~ 		If (StringRight($vSource_RomPath, 1) <> '\') Then $vSource_RomPath &= '\'
;~ 		_CREATION_LOGMESS(2, "Chemin des Roms : " & $vSource_RomPath)
;~ 	Else
;~ 		$vErrorMess = _MultiLang_GetText("err_PathRom") & @CRLF
;~ 		_CREATION_LOGMESS(2, _MultiLang_GetText("err_PathRom") & " : " & $vSource_RomPath)
;~ 		$vScrapeOK = $vScrapeOK + 1
;~ 	EndIf
;~ 	If Not FileExists($vTarget_XMLName) Then
;~ 		If Not _FileCreate($vTarget_XMLName) Then
;~ 			$vErrorMess &= _MultiLang_GetText("err_PathNew") & @CRLF
;~ 			_CREATION_LOGMESS(2, _MultiLang_GetText("err_PathNew") & " : " & $vTarget_XMLName)
;~ 			$vScrapeOK = $vScrapeOK + 1
;~ 		EndIf
;~ 	EndIf
;~ 	If Not FileExists($vSource_ImagePath) Then
;~ 		If Not DirCreate($vSource_ImagePath) Then
;~ 			$vErrorMess &= _MultiLang_GetText("err_PathImage") & @CRLF
;~ 			_CREATION_LOGMESS(2, _MultiLang_GetText("err_PathImage") & " : " & $vSource_ImagePath)
;~ 			$vScrapeOK = $vScrapeOK + 1
;~ 		EndIf
;~ 	EndIf
;~ 	If StringLower(StringRight($vTarget_XMLName, 4)) <> ".xml" Then
;~ 		$vErrorMess &= _MultiLang_GetText("err_PathNew_ext") & @CRLF
;~ 		_CREATION_LOGMESS(2, _MultiLang_GetText("err_PathNew_ext") & " : " & StringLower(StringRight($vTarget_XMLName, 4)))
;~ 		$vScrapeOK = $vScrapeOK + 1
;~ 	EndIf
;~ 	If $vScrapeOK > 0 Then _ExtMsgBox($EMB_ICONEXCLAM, "OK", _MultiLang_GetText("err_title"), $vErrorMess, 15)
;~ 	Return $vScrapeOK
;~ EndFunc   ;==>_SCRAPING_VERIF

Func _GUI_Config_LU()
	Local $vImage_Extension, $vAutoconf, $vScrapeMode, $vEmptyRom
	#Region ### START Koda GUI section ### Form=
	$F_CONFIG = GUICreate(_MultiLang_GetText("win_config_LU_Title"), 477, 209, -1, -1, -1, BitOR($WS_EX_TOPMOST, $WS_EX_WINDOWEDGE))
	$G_Scrape = GUICtrlCreateGroup(_MultiLang_GetText("win_config_LU_GroupScrap"), 8, 0, 225, 201)
	$L_Source_RootPath = GUICtrlCreateLabel(_MultiLang_GetText("win_config_LU_GroupScrap_Source_RootPath"), 16, 16)
	GUICtrlSetTip(-1, _MultiLang_GetText("tips_config_GroupScrap_PathXML"))
	$I_Source_RootPath = GUICtrlCreateInput(IniRead($iINIPath, "LAST_USE", "$Source_RootPath", ""), 16, 35, 177, 21)
	$B_Source_RootPath = GUICtrlCreateButton("...", 198, 35, 27, 21)
	$L_Target_XMLName = GUICtrlCreateLabel(_MultiLang_GetText("win_config_LU_GroupScrap_Target_XMLName"), 16, 63)
	GUICtrlSetTip(-1, _MultiLang_GetText("tips_config_GroupScrap_PathXML"))
	$I_Target_XMLName = GUICtrlCreateInput(IniRead($iINIPath, "LAST_USE", "$Target_XMLName", ""), 16, 83, 177, 21)
	$B_Target_XMLName = GUICtrlCreateButton("...", 198, 83, 27, 21)
	$L_Source_RomPath = GUICtrlCreateLabel(_MultiLang_GetText("win_config_LU_GroupScrap_Source_RomPath"), 16, 108)
	GUICtrlSetTip(-1, _MultiLang_GetText("tips_config_GroupScrap_PathRom"))
	$I_Source_RomPath = GUICtrlCreateInput(IniRead($iINIPath, "LAST_USE", "$Source_RomPath", ""), 16, 128, 177, 21)
	$B_Source_RomPath = GUICtrlCreateButton("...", 198, 128, 27, 21)
	$L_Target_RomPath = GUICtrlCreateLabel(_MultiLang_GetText("win_config_LU_GroupScrap_Target_RomPath"), 16, 153)
	GUICtrlSetTip(-1, _MultiLang_GetText("tips_config_GroupScrap_PathRomSub"))
	$I_Target_RomPath = GUICtrlCreateInput(IniRead($iINIPath, "LAST_USE", "$Target_RomPath", ""), 16, 173, 177, 21)
;~ 	$B_Target_RomPath = GUICtrlCreateButton("...", 198, 173, 27, 21)
	GUICtrlCreateGroup("", -99, -99, 1, 1)
	$G_Image = GUICtrlCreateGroup(_MultiLang_GetText("win_config_LU_GroupImage"), 240, 0, 225, 113)
	$L_Source_ImagePath = GUICtrlCreateLabel(_MultiLang_GetText("win_config_LU_GroupImage_Source_ImagePath"), 248, 15)
	GUICtrlSetTip(-1, _MultiLang_GetText("tips_config_GroupImage_PathImage"))
	$I_Source_ImagePath = GUICtrlCreateInput(IniRead($iINIPath, "LAST_USE", "$Source_ImagePath", ""), 248, 34, 177, 21)
	$B_Source_ImagePath = GUICtrlCreateButton("...", 430, 34, 27, 21)
	$L_Target_ImagePath = GUICtrlCreateLabel(_MultiLang_GetText("win_config_LU_GroupImage_Target_ImagePath"), 248, 60)
	GUICtrlSetTip(-1, _MultiLang_GetText("tips_config_GroupImage_PathImageSub"))
	$I_Target_ImagePath = GUICtrlCreateInput(IniRead($iINIPath, "LAST_USE", "$Target_ImagePath", ""), 248, 80, 177, 21)
;~ 	$B_Target_ImagePath = GUICtrlCreateButton("...", 430, 80, 27, 21)
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
			Case $B_Source_RootPath
				$Source_RootPath = FileSelectFolder(_MultiLang_GetText("win_config_LU_GroupScrap_Source_RootPath"), GUICtrlRead($I_Source_RootPath), $FSF_CREATEBUTTON, GUICtrlRead($I_Source_RootPath), $F_CONFIG)
				GUICtrlSetData($I_Source_RootPath, $Source_RootPath)
			Case $B_Target_XMLName
				$Target_XMLName = FileSaveDialog(_MultiLang_GetText("win_config_GroupScrap_PathXML"), GUICtrlRead($I_Source_RootPath) & "\" & GUICtrlRead($I_Source_RomPath), "xml (*.xml)", 18, "gamelist.xml", $F_CONFIG)
				If @error Then $Target_XMLName = GUICtrlRead($I_Target_XMLName)
				GUICtrlSetData($I_Target_XMLName, $Target_XMLName)
			Case $B_Source_RomPath
				$Source_RomPath = FileSelectFolder(_MultiLang_GetText("win_config_LU_GroupScrap_Source_RomPath"), GUICtrlRead($I_Source_RootPath), $FSF_CREATEBUTTON, GUICtrlRead($I_Source_RootPath), $F_CONFIG)
				$Source_RomPath = StringSplit($Source_RomPath, "\")
				GUICtrlSetData($I_Source_RomPath, $Source_RomPath[UBound($Source_RomPath) - 1])
			Case $B_Source_ImagePath
				$Source_ImagePath = FileSelectFolder(_MultiLang_GetText("win_config_LU_GroupScrap_Source_RomPath"), GUICtrlRead($I_Source_RootPath) & "\" & GUICtrlRead($I_Source_RomPath) & "\" & GUICtrlRead($I_Source_ImagePath), $FSF_CREATEBUTTON, GUICtrlRead($I_Source_RootPath) & "\" & GUICtrlRead($I_Source_RomPath) & "\" & GUICtrlRead($I_Source_ImagePath), $F_CONFIG)
				$Source_ImagePath = StringSplit($Source_ImagePath, "\")
				GUICtrlSetData($I_Source_ImagePath, $Source_ImagePath[UBound($Source_ImagePath) - 1])
			Case $B_CONFENREG
				$Source_RootPath = GUICtrlRead($I_Source_RootPath) ;$Source_RootPath
				If (StringRight($Source_RootPath, 1) = '\') Then StringTrimRight($Source_RootPath, 1)
				IniWrite($iINIPath, "LAST_USE", "$Source_RootPath", $Source_RootPath)
				$Target_XMLName = GUICtrlRead($I_Target_XMLName) ;$Target_XMLName
				IniWrite($iINIPath, "LAST_USE", "$Target_XMLName", $Target_XMLName)
				$Source_RomPath = GUICtrlRead($I_Source_RomPath) ;$Source_RomPath
				IniWrite($iINIPath, "LAST_USE", "$Source_RomPath", $Source_RomPath)
				$Target_RomPath = GUICtrlRead($I_Target_RomPath) ;$Target_RomPath
				IniWrite($iINIPath, "LAST_USE", "$Target_RomPath", $Target_RomPath)
				$Source_ImagePath = GUICtrlRead($I_Source_ImagePath) ;$Source_ImagePath
				IniWrite($iINIPath, "LAST_USE", "$Source_ImagePath", $Source_ImagePath)
				$Target_ImagePath = GUICtrlRead($I_Target_ImagePath) ;$Target_ImagePath
				IniWrite($iINIPath, "LAST_USE", "$Target_ImagePath", $Target_ImagePath)
				_LOG("Path Configuration Saved", 0)
				_LOG("------------------------", 1)
				_LOG("$Source_RootPath = " & $Source_RootPath, 1)
				_LOG("$Target_XMLName = " & $Target_XMLName, 1)
				_LOG("$Source_RomPath = " & $Source_RomPath, 1)
				_LOG("$Target_RomPath = " & $Target_RomPath, 1)
				_LOG("$Source_ImagePath = " & $Source_ImagePath, 1)
				_LOG("$Target_ImagePath = " & $Target_ImagePath, 1)
				GUIDelete($F_CONFIG)
				GUISetState(@SW_ENABLE, $F_UniversalScraper)
				WinActivate($F_UniversalScraper)
				Return
		EndSwitch
	WEnd
EndFunc   ;==>_GUI_Config_LU

Func _GUI_Config_autoconf($oXMLProfil)
	Local $vImage_Extension, $vAutoconf, $vScrapeMode, $vEmptyRom
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
;~ 	$B_Target_XMLName = GUICtrlCreateButton("...", 198, 123, 27, 21)
	$L_Target_RomPath = GUICtrlCreateLabel(_MultiLang_GetText("win_config_autoconf_GroupScrap_Target_RomPath"), 16, 153)
	GUICtrlSetTip(-1, _MultiLang_GetText("tips_config_GroupScrap_PathRomSub"))
	$I_Target_RomPath = GUICtrlCreateInput(_XML_Read("Profil/AutoConf/Target_RomPath", 0, "", $oXMLProfil), 16, 173, 177, 21)
;~ 	$B_Target_RomPath = GUICtrlCreateButton("...", 198, 173, 27, 21)
	GUICtrlCreateGroup("", -99, -99, 1, 1)
	$G_Image = GUICtrlCreateGroup(_MultiLang_GetText("win_config_autoconf_GroupImage"), 240, 0, 225, 113)
	$L_Source_ImagePath = GUICtrlCreateLabel(_MultiLang_GetText("win_config_autoconf_GroupImage_Source_ImagePath"), 248, 15)
	GUICtrlSetTip(-1, _MultiLang_GetText("tips_config_GroupImage_PathImage"))
	$I_Source_ImagePath = GUICtrlCreateInput(_XML_Read("Profil/AutoConf/Source_ImagePath", 0, "", $oXMLProfil), 248, 34, 177, 21)
;~ 	$B_Source_ImagePath = GUICtrlCreateButton("...", 430, 34, 27, 21)
	$L_Target_ImagePath = GUICtrlCreateLabel(_MultiLang_GetText("win_config_autoconf_GroupImage_Target_ImagePath"), 248, 60)
	GUICtrlSetTip(-1, _MultiLang_GetText("tips_config_GroupImage_PathImageSub"))
	$I_Target_ImagePath = GUICtrlCreateInput(_XML_Read("Profil/AutoConf/Target_ImagePath", 0, "", $oXMLProfil), 248, 80, 177, 21)
;~ 	$B_Target_ImagePath = GUICtrlCreateButton("...", 430, 80, 27, 21)
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
			Case $B_Source_RootPath
				$Source_RootPath = FileSelectFolder(_MultiLang_GetText("win_config_LU_GroupScrap_Source_RootPath"), GUICtrlRead($I_Source_RootPath), $FSF_CREATEBUTTON, GUICtrlRead($I_Source_RootPath), $F_CONFIG)
				GUICtrlSetData($I_Source_RootPath, $Source_RootPath)
			Case $B_CONFENREG
				$Source_RootPath = GUICtrlRead($I_Source_RootPath) ;$Source_RootPath
				If (StringRight($Source_RootPath, 1) = '\') Then StringTrimRight($Source_RootPath, 1)
				_XML_Replace("Profil/AutoConf/Source_RootPath", $Source_RootPath, 0, "", $oXMLProfil)
;~ 				IniWrite($iINIPath, "LAST_USE", "$Source_RootPath", $Source_RootPath)
;~ 				$Target_XMLName = GUICtrlRead($I_Target_XMLName) ;$Target_XMLName
;~ 				IniWrite($iINIPath, "LAST_USE", "$Target_XMLName", $Target_XMLName)
;~ 				$Target_RomPath = GUICtrlRead($I_Target_RomPath) ;$Target_RomPath
;~ 				IniWrite($iINIPath, "LAST_USE", "$Target_RomPath", $Target_RomPath)
;~ 				$Source_ImagePath = GUICtrlRead($I_Source_ImagePath) ;$Source_ImagePath
;~ 				IniWrite($iINIPath, "LAST_USE", "$Source_ImagePath", $Source_ImagePath)
;~ 				$Target_ImagePath = GUICtrlRead($I_Target_ImagePath) ;$Target_ImagePath
;~ 				IniWrite($iINIPath, "LAST_USE", "$Target_ImagePath", $Target_ImagePath)
				_LOG("AutoConf Path Configuration Saved", 0)
;~ 				_LOG("------------------------", 1)
;~ 				_LOG("$Source_RootPath = " & $Source_RootPath, 1)
;~ 				_LOG("$Target_XMLName = " & $Target_XMLName, 1)
;~ 				_LOG("$Target_RomPath = " & $Target_RomPath, 1)
;~ 				_LOG("$Source_ImagePath = " & $Source_ImagePath, 1)
;~ 				_LOG("$Target_ImagePath = " & $Target_ImagePath, 1)
				_XML_Misc_Viewer($oXMLProfil)
				GUIDelete($F_CONFIG)
				GUISetState(@SW_ENABLE, $F_UniversalScraper)
				WinActivate($F_UniversalScraper)
				Return
		EndSwitch
	WEnd
EndFunc   ;==>_GUI_Config_autoconf

#EndRegion Function
