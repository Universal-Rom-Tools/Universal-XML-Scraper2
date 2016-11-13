#Region ;**** Directives created by AutoIt3Wrapper_GUI ****
#AutoIt3Wrapper_UseUpx=n
#AutoIt3Wrapper_Run_AU3Check=n
#AutoIt3Wrapper_Run_Before=ShowOriginalLine.exe %in%
#AutoIt3Wrapper_Run_After=ShowOriginalLine.exe %in%
#EndRegion ;**** Directives created by AutoIt3Wrapper_GUI ****

 ; Skip Global and Local variables.
#ShowOriginalLine_Param=/SV

#include "_AutoItErrorTrap.au3"

; Default messages.
_AutoItErrorTrap("", "", False) ; Will use "StdOut" to read the error, but will not be compatible with CUI application!

Global $iToolTip = 0

_Recursion()

Func _Recursion()
	$iToolTip +=1
	ToolTip("Recursion number: " & $iToolTip, Default, Default, "Recursion")
	;Sleep(10)
	Return _Recursion()
EndFunc
