#include ..\lib\gdip.ahk
#include ..\inactive.ahk
Suc := InactiveImageSearch(X,Y,"작업 관리자","target.png")
if(Suc){
    SimpleClick("작업 관리자",X,Y)
}
else{
    MsgBox,Fail
}