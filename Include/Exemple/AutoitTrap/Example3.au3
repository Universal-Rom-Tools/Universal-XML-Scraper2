#AutoIt3Wrapper_Change2CUI=y
#Region ;**** Directives created by AutoIt3Wrapper_GUI ****
#AutoIt3Wrapper_UseUpx=n
#AutoIt3Wrapper_Run_AU3Check=n
#AutoIt3Wrapper_Run_Before=ShowOriginalLine.exe %in%
#AutoIt3Wrapper_Run_After=ShowOriginalLine.exe %in%
#EndRegion ;**** Directives created by AutoIt3Wrapper_GUI ****

#include <_AutoItErrorTrap.au3>

If Not @Compiled Then
	MsgBox(4096, "Note:", "You need to compile first!")
	Exit
EndIf

; Default messages...
_AutoItErrorTrap()

ConsoleWrite("Hello CMD world!" & @CRLF)
ConsoleWrite("Wait..." & @CRLF)
Sleep(1000)
ConsoleWrite("Variable error:" & $sVar & @CRLF)
