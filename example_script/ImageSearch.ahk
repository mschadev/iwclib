#include ..\lib\gdip.ahk
#include ..\inactive.ahk
Suc := InactiveImageSearch("작업 관리자","target.png",X,Y,0,0,0,0,10,"T|R")
if(Suc){
    MsgBox,X:%X% Y:%Y%
    SimpleClick("작업 관리자",X,Y)
}
else{
    MsgBox,Fail
}

Suc := ImageSearchFromFile("Background.png","target.png",X,Y)
if(Suc){
    MsgBox,X:%X% Y:%Y%
}
else{
    MsgBox,Fail
}