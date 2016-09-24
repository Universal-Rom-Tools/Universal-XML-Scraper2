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

If Not _FileCreate(@ScriptDir & "\test") Then ; Testing UXS Directory
	Global $iScriptPath = @AppDataDir & "\UXMLS" ; If not, use Path to current user's Roaming Application Data
	DirCreate($iScriptPath) ;
Else
	Global $iScriptPath = @ScriptDir
	FileDelete($iScriptPath & "\test")
EndIf

FileInstall(".\Ressources\UXS.jpg", $iScriptPath & "\Ressources\UXS.jpg")
FileInstall(".\Ressources\jingle_uxs.MP3", $iScriptPath & "\Ressources\jingle_uxs.MP3")

;Splash Screen
$F_Splashcreen = GUICreate("", 799, 449, -1, -1, $WS_POPUPWINDOW, $WS_EX_TOOLWINDOW)
GUICtrlCreatePic($iScriptPath & "\Ressources\UXS.jpg", -1, -1, 800, 450)
SoundPlay($iScriptPath & "\Ressources\jingle_uxs.MP3")
GUISetState()

Sleep(6000)

;Suppress Splascreen
GUIDelete($F_Splashcreen)