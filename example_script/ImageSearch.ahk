#include ..\lib\gdip.ahk
#include ..\inactive.ahk
Suc := InactiveImageSearch("작업 관리자","target.png",X,Y)
if(Suc){
    SimpleClick("작업 관리자",X,Y)
}
else{
    MsgBox,Fail
}