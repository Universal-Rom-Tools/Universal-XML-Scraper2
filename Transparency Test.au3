#include <GDIPlus.au3>
#include <array.au3>

_GDIPlus_Startup()
FileDelete(@ScriptDir & "\2.png")
Local $hImage = _GDIPlus_ImageLoadFromFile(@ScriptDir & "\1.png")
$hNewBitmap = _GDIPlus_ImageShapeRect($hImage)
_GDIPlus_ImageSaveToFile($hNewBitmap, @ScriptDir & "\2.png")
_GDIPlus_ImageDispose($hImage)
_GDIPlus_BitmapDispose($hNewBitmap)
_GDIPlus_Shutdown()
ShellExecute(@ScriptDir & "\2.png")
Exit

Func _GDIPlus_ImageShapeRectOLD($hImage,$iTiling = 4) ;coded by UEZ 2012-12-17
;~     Local $iWidth = $iRadius * 2, $iHeight = $iWidth
	Local $iWidth = _GDIPlus_ImageGetWidth($hImage)
	If $iWidth = 4294967295 Then $iWidth = 0 ;4294967295 en cas d'erreur.
	Local $iHeight = _GDIPlus_ImageGetHeight($hImage)
	Local $aResult = DllCall($__g_hGDIPDll, "uint", "GdipCreateTexture", "ptr", $hImage, "int", $iTiling, "int*", 0)
	If @error Then Return SetError(1, 0, 0)
	Local $hTexture = $aResult[3]
	$aResult = DllCall($__g_hGDIPDll, "uint", "GdipCreateBitmapFromScan0", "int", $iWidth, "int", $iHeight, "int", 0, "int", 0x0026200A, "ptr", 0, "int*", 0)
	If @error Then Return SetError(2, 0, 0)
	$hImage = $aResult[6]
	_ArrayDisplay($aResult, "$aResult")
	Local $hGfxCtxt = _GDIPlus_ImageGetGraphicsContext($hImage)
	_GDIPlus_GraphicsSetSmoothingMode($hGfxCtxt, 2)
	DllCall($__g_hGDIPDll, "uint", "GdipSetPixelOffsetMode", "handle", $hGfxCtxt, "int", 2)
;~     _GDIPlus_GraphicsFillEllipse($hGfxCtxt, 0, 0, $iWidth, $iHeight, $hTexture)
	_GDIPlus_GraphicsFillRect($hGfxCtxt, 20, 20, 40, 40, $hTexture)
	_GDIPlus_GraphicsFillRect($hGfxCtxt, 40, 40, 100, 100, $hTexture)
	_GDIPlus_GraphicsFillRect($hGfxCtxt, 0, 110, 0, 100, $hTexture)
	_GDIPlus_GraphicsFillRect($hGfxCtxt, 50, 0, 100, 10, $hTexture)
	_GDIPlus_BrushDispose($hTexture)
	_GDIPlus_GraphicsDispose($hGfxCtxt)
	Return $hImage
EndFunc   ;==>_GDIPlus_ImageShapeRectOLD

Func _GDIPlus_ImageShapeRect($hImage, $iTiling = 4) ;coded by UEZ 2012-12-17
	Local $iX = 780.8
	Local $iY = 225.28
	Local $iWidthCut = 459.52
	Local $iHeightCut = 696.32
	Local $vTarget_Width = 1280
	Local $vTarget_Height = 1024

	Local $hTexture = _GDIPlus_TextureCreate($hImage, 4)
	$hImage = _GDIPlus_BitmapCreateFromScan0($vTarget_Width, $vTarget_Height)
	Local $hGfxCtxt = _GDIPlus_ImageGetGraphicsContext($hImage)
	_GDIPlus_GraphicsSetSmoothingMode($hGfxCtxt, 2)
	_GDIPlus_GraphicsSetPixelOffsetMode($hGfxCtxt, 2)
	_GDIPlus_GraphicsFillRect($hGfxCtxt, 0, 0, $iX, $vTarget_Height, $hTexture)
	_GDIPlus_GraphicsFillRect($hGfxCtxt, $iX + $iWidthCut, 0, $vTarget_Width - ($iX + $iWidthCut), $vTarget_Height, $hTexture)
	_GDIPlus_GraphicsFillRect($hGfxCtxt, $iX, 0, $iWidthCut, $iY, $hTexture)
	_GDIPlus_GraphicsFillRect($hGfxCtxt, $iX, $iY + $iHeightCut, $iWidthCut, $vTarget_Height - ($iY + $iHeightCut), $hTexture)
	_GDIPlus_BrushDispose($hTexture)
	_GDIPlus_GraphicsDispose($hGfxCtxt)
	Return $hImage
EndFunc   ;==>_GDIPlus_ImageShapeRect
