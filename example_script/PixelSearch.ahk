#include ..\lib\gdip.ahk
#include ..\inactive.ahk
_Count := MultipleInactivePixelSearch("작업 관리자",0xff0078d7,X,Y,0,0,50,600)
MsgBox,Count:%_Count%
loop,%_Count%
{
    x1 := X[A_Index] + 0
    y2 := Y[A_Index] + 0
    SimpleClick("작업 관리자",x1,y1)
    ;MsgBox,%x1% %y2%
}
if(InactivePixelSearch("작업 관리자",0xff0078d7,X,Y,30,50,50,600) == 1)
{
    x1 := X + 30
    y1 := Y + 50
    SimpleClick("작업 관리자",x1,y1)
    ;MsgBox,%x1% %y1%
}