#Region ;**** Directives created by AutoIt3Wrapper_GUI ****
#AutoIt3Wrapper_UseUpx=n
;#AutoIt3Wrapper_Run_AU3Check=n
#AutoIt3Wrapper_Run_Before=ShowOriginalLine.exe %in%
#AutoIt3Wrapper_Run_After=ShowOriginalLine.exe %in%
#EndRegion ;**** Directives created by AutoIt3Wrapper_GUI ****

#include "./_AutoItErrorTrap.au3"

If Not @Compiled Then
;	MsgBox(4096, "Note:", "You need to compile first!")
;	Exit
EndIf

; Custom title and text...
_AutoItErrorTrap("AutoItErrorTrap", "Hi!" & @CRLF & @CRLF & "An error was detected in the program, you can try again," & _
		" cancel to exit or continue to see more details of the error." & @CRLF & @CRLF & "Sorry for the inconvenience!")

_Example()

Func _Example()
	Local $asArray[4] = ["JScript", "Jonatas", "AutoIt", "Brasil"]

	Local $iOption = MsgBox(262180, "Error detection test!", "Hi!" & @CRLF & @CRLF & "Let's try to catch the AutoIt error window?" & _
			@CRLF & @CRLF & "Answer [Yes] to generate an array error, [No] to exit...")
	Select
		Case $iOption = 6 ;Yes
			; Error in array value!
			MsgBox(4096, "Erro!", $asArray[5])

		Case $iOption = 7 ;No
			Exit
		Case Else
			Exit
	EndSelect
EndFunc   ;==>_Example
