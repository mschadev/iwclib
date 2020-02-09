#include ..\lib\gdip.ahk
#include ..\inactive.ahk
if(InactivePixelSearch("작업 관리자",0xff03ceb4,X,Y,30,50,50,600) == 1)
{
    SimpleClick("작업 관리자",X,Y)
    MsgBox,%X% %Y%
}