#AutoIt3Wrapper_Au3Check_Parameters=-d -w 1 -w 2 -w 3 -w 4 -w 5 -w 6

#include "MailSlot.au3"

Global Const $sMailSlotName = "\\.\mailslot\RandomNameForThisTest"

Global $hMailSlot = _MailSlotCreate($sMailSlotName)
If @error Then
	MsgBox(48 + 262144, "MailSlot", "Failed to create new account!" & @CRLF & "Probably one using that 'address' already exists.")
	Exit
EndIf

Global $iNumberOfMessagesOverall

Global $hGUI = GUICreate("MailSlot Demo Receiver", 450, 400, 3 * @DesktopWidth / 4 - 225, -1, -1, 8) ; $WS_EX_TOPMOST

GUICtrlCreateLabel("Message text:", 10, 22, 100, 25)
GUICtrlSetColor(-1, 0x0000CC)
GUICtrlSetFont(-1, 11)

Global $hEdit = GUICtrlCreateEdit("", 15, 50, 300, 340)

Global $hButtonRead = GUICtrlCreateButton("Read &Mail", 330, 50, 100, 25)

Global $hButtonCheckCount = GUICtrlCreateButton("&Check Mail Count", 330, 100, 100, 25)

Global $hButtonCloseAccount = GUICtrlCreateButton("Close Mail &Account", 330, 150, 100, 25)

Global $hButtonRestoreAccount = GUICtrlCreateButton("&Restore Account", 330, 200, 100, 25)

Global $hButtonCloseApp = GUICtrlCreateButton("&Exit", 330, 350, 100, 25)

GUISetState()


While 1

	Switch GUIGetMsg()
		Case - 3, $hButtonCloseApp
			Exit
		Case $hButtonRead
			If $hMailSlot Then
				_ReadMessage($hMailSlot)
			Else
				MsgBox(48, "MailSlot demo", "No account is available!", 0, $hGUI)
			EndIf
		Case $hButtonCheckCount
			If $hMailSlot Then
				_CheckCount($hMailSlot)
			Else
				MsgBox(48, "MailSlot demo", "No account is available!", 0, $hGUI)
			EndIf
		Case $hButtonCloseAccount
			If $hMailSlot Then
				_CloseMailAccount($hMailSlot)
			Else
				MsgBox(64, "MailSlot demo", "No account is available!", 0, $hGUI)
			EndIf
		Case $hButtonRestoreAccount
			If $hMailSlot Then
				MsgBox(64, "MailSlot demo", "This account already exists!", 0, $hGUI)
			Else
				_RestoreAccount($sMailSlotName)
			EndIf
	EndSwitch

WEnd


; Wrapper functions:

Func _ReadMessage($hHandle)

	Local $iSize = _MailSlotCheckForNextMessage($hHandle)

	If $iSize Then
		Local $sData = _MailSlotRead($hMailSlot, $iSize, 1)
		$iNumberOfMessagesOverall += 1
		GUICtrlSetData($hEdit, "Message No" & $iNumberOfMessagesOverall & " , Size = " & $iSize & " :" & @CRLF & @CRLF & $sData)
	Else
		MsgBox(64, "Nothing read", "MailSlot is empty", 0, $hGUI)
	EndIf

EndFunc   ;==>_ReadMessage


Func _CheckCount($hHandle)

	Local $iCount = _MailSlotGetMessageCount($hHandle)
	Switch $iCount
		Case 0
			MsgBox(64, "Messages", "No new messages", 0, $hGUI)
		Case 1
			MsgBox(64, "Messages", "There is 1 message waiting to be read.", 0, $hGUI)
		Case Else
			MsgBox(64, "Messages", "There are " & $iCount & " messages waiting to be read.", 0, $hGUI)
	EndSwitch

EndFunc   ;==>_CheckCount


Func _CloseMailAccount(ByRef $hHandle)

	If _MailSlotClose($hHandle) Then
		$hHandle = 0
		MsgBox(64, "MailSlot demo", "Account succesfully closed.", 0, $hGUI)
	Else
		MsgBox(48, "MailSlot demo error", "Account could not be closed!", 0, $hGUI)
	EndIf

EndFunc   ;==>_CloseMailAccount


Func _RestoreAccount($sMailSlotName)

	Local $hMailSlotHandle = _MailSlotCreate($sMailSlotName)

	If @error Then
		MsgBox(48, "MailSlot demo error", "Account could not be created!", 0, $hGUI)
	Else
		MsgBox(64, "MailSlot demo", "New account with the same address successfully created!", 2, $hGUI)
		$hMailSlot = $hMailSlotHandle ; global var
	EndIf

EndFunc   ;==>_RestoreAccount
