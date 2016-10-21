#include "_GraphGDIPlus.au3"

Opt("GUIOnEventMode", 1)

$GUI = GUICreate("",600,600)
GUISetOnEvent(-3,"_Exit")
GUISetState()

;----- Create Graph area -----
$Graph = _GraphGDIPlus_Create($GUI,40,30,530,520,0xFF000000,0xFF88B3DD)

;----- Set X axis range from -5 to 5 -----
_GraphGDIPlus_Set_RangeX($Graph,-5,5,10,1,1)
_GraphGDIPlus_Set_RangeY($Graph,-5,5,10,1,1)

;----- Set Y axis range from -5 to 5 -----
_GraphGDIPlus_Set_GridX($Graph,1,0xFF6993BE)
_GraphGDIPlus_Set_GridY($Graph,1,0xFF6993BE)

;----- Draw the graph -----
_Draw_Graph()

While 1
    Sleep(100)
WEnd



Func _Draw_Graph()
    ;----- Set line color and size -----
    _GraphGDIPlus_Set_PenColor($Graph,0xFF325D87)
    _GraphGDIPlus_Set_PenSize($Graph,2)

    ;----- draw lines -----
    $First = True
    For $i = -5 to 5 Step 0.005
        $y = _GammaFunction($i)
        If $First = True Then _GraphGDIPlus_Plot_Start($Graph,$i,$y)
        $First = False
        _GraphGDIPlus_Plot_Line($Graph,$i,$y)
        _GraphGDIPlus_Refresh($Graph)
    Next
EndFunc



Func _GammaFunction($iZ)
    $nProduct = ((2^$iZ) / (1 + $iZ))
    For $n = 2 to 1000
        $nProduct *= ((1 + (1/$n))^$iZ) / (1 + ($iZ / $n))
    Next
    Return (1/$iZ) * $nProduct
EndFunc



Func _Exit()
    ;----- close down GDI+ and clear graphic -----
    _GraphGDIPlus_Delete($GUI,$Graph)
    Exit
EndFunc