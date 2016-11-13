#AutoIt3Wrapper_Au3Check_Parameters=-d -w 1 -w 2 -w 3 -w 4 -w 5 -w 6

#include "MailSlot.au3"

Global Const $sMailSlotName = "\\.\mailslot\RandomNameForThisTest"


Global $hGUI = GUICreate("MailSlot Demo Sender", 450, 400, @DesktopWidth / 4 - 225, -1, -1, 8) ; $WS_EX_TOPMOST

GUICtrlCreateLabel("Message text:", 10, 22, 100, 25)
GUICtrlSetColor(-1, 0x0000CC)
GUICtrlSetFont(-1, 11)

Global $hEdit = GUICtrlCreateEdit("", 15, 50, 300, 340)

Global $hButtonSend = GUICtrlCreateButton("&Send Mail", 330, 100, 100, 25)

Global $hButtonCloseApp = GUICtrlCreateButton("&Exit", 330, 350, 100, 25)

GUISetState()


While 1

	Switch GUIGetMsg()
		Case - 3, $hButtonCloseApp
			Exit
		Case $hButtonSend
			_SendMail($sMailSlotName)
	EndSwitch

WEnd


; Wrapper function:

Func _SendMail($sMailSlotName)

	Local $sDataToSend = GUICtrlRead($hEdit)

	If $sDataToSend Then
		_MailSlotWrite($sMailSlotName, $sDataToSend);, 1)
		Switch @error
			Case 1
				MsgBox(48, "MailSlot demo error", "Account that you try to send to likely doesn't exist!", 0, $hGUI)
			Case 2
				MsgBox(48, "MailSlot demo error", "Message is blocked!", 0, $hGUI)
			Case 3
				MsgBox(48, "MailSlot demo error", "Message is send but there is an open handle left." & @CRLF & "That could lead to possible errors in future", 0, $hGUI)
			Case 4
				MsgBox(48, "MailSlot demo error", "All is fucked up!" & @CRLF & "Try debugging MailSlot.au3 functions. Thanks.", 0, $hGUI)
			Case Else
				MsgBox(64, "MailSlot demo", "Sucessfully sent!", 0, $hGUI)
		EndSwitch
		GUICtrlSetData($hEdit, "")
	Else
		MsgBox(64, "MailSlot demo", "Nothing to send.", 0, $hGUI)
	EndIf

EndFunc   ;==>_SendMail




