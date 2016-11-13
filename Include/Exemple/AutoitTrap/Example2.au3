#Region ;**** Directives created by AutoIt3Wrapper_GUI ****
#AutoIt3Wrapper_UseUpx=n
#AutoIt3Wrapper_Run_AU3Check=n
#AutoIt3Wrapper_Run_Before=ShowOriginalLine.exe %in%
#AutoIt3Wrapper_Run_After=ShowOriginalLine.exe %in%
#EndRegion ;**** Directives created by AutoIt3Wrapper_GUI ****

#include "_AutoItErrorTrap.au3"

If Not @Compiled Then
	MsgBox(4096, "Note:", "You need to compile first!")
	Exit
EndIf

; Default messages...
_AutoItErrorTrap()

_Example()

Func _Example()
	Local $iOption = MsgBox(262180, "Error detection test!", "Hi!" & @CRLF & @CRLF & "Let's try to catch the AutoIt error window?" & _
			@CRLF & @CRLF & "Answer [Yes] to generate an syntaxe error, [No] to exit...")
	Select
		Case $iOption = 6 ;Yes
			; Sybtaxe error |LoL|!
			MsgBox(4096, "Erro!",)

		Case $iOption = 7 ;No
			Exit
	EndSelect
EndFunc   ;==>_Example
