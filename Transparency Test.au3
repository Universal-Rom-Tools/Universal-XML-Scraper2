#include <ScreenCapture.au3>

_GDIPlus_Startup()
Global $iWidth = 144, $iHeight = 87
Global $hBitmap_GDIPlus = _GDIPlus_BitmapCreateFromFile("C:\Users\Screech\Desktop\TestWrite1.png")
Global $hBitmap_Result = _GDIPlus_BitmapCreateFromScan0($iWidth, $iHeight)
Global $hBitmap_Result_Ctxt = _GDIPlus_ImageGetGraphicsContext($hBitmap_Result)

Global $aRemapTable[2][2]
$aRemapTable[0][0] = 1
$aRemapTable[1][0] = 0xFFFF00FF ;Farbe, die Transparent gemacht werden soll

Global $hIA = _GDIPlus_ImageAttributesCreate()
_GDIPlus_ImageAttributesSetRemapTable($hIA, 1, True, $aRemapTable)
_GDIPlus_GraphicsDrawImageRectRect($hBitmap_Result_Ctxt, $hBitmap_GDIPlus, 0, 0, $iWidth, $iHeight, 0, 0, $iWidth, $iHeight, $hIA)
_GDIPlus_ImageSaveToFile($hBitmap_Result, @ScriptDir & "\Result.png")

_GDIPlus_GraphicsDispose($hBitmap_Result_Ctxt)
_GDIPlus_BitmapDispose($hBitmap_GDIPlus)
_GDIPlus_BitmapDispose($hBitmap_Result)
_GDIPlus_ImageAttributesDispose($hIA)
_GDIPlus_Shutdown()

ShellExecute(@ScriptDir & "\Result.png")

Func _GDIPlus_ImageAttributesSetRemapTable($hImageAttributes, $iColorAdjustType = 0, $fEnable = False, $aColorMap = 0)
    Local $iI, $iCount, $tColorMap, $aResult
    If IsArray($aColorMap) And UBound($aColorMap) > 1 Then
        $iCount = $aColorMap[0][0]
        $tColorMap = DllStructCreate("uint ColorMap[" & $iCount * 2 & "]")
        For $iI = 1 To $iCount
            $tColorMap.ColorMap((2 * $iI - 1)) = $aColorMap[$iI][0]
            $tColorMap.ColorMap((2 * $iI)) = $aColorMap[$iI][1]
        Next
        $aResult = DllCall($__g_hGDIPDll, "int", "GdipSetImageAttributesRemapTable", "handle", $hImageAttributes, "int", $iColorAdjustType, "int", $fEnable, "int", $iCount, "struct*", $tColorMap)
        If @error Then Return SetError(@error, @extended, False)
        If $aResult[0] Then Return SetError(10, $aResult[0], False)
        Return True
    EndIf
    Return SetError(11, 0, False)
EndFunc   ;==>_GDIPlus_ImageAttributesSetRemapTable