#include ..\lib\gdip.ahk
#include ..\inactive.ahk
SucCount := InactiveImageSearch("작업 관리자","Target.png",X,Y,0,0,0,0,5,"T|R",0)
if(SucCount > 0){ 
    loop,%SucCount%
    {
        targetX := X[A_index]
        targetY := Y[A_index]
        MsgBox,Idx:%A_Index% X:%targetX% Y:%targetY%
        SimpleClick("작업 관리자",targetX,targetY)
    }
}
else{
    MsgBox,Fail
}

Suc := ImageSearchFromFile("Background.png","Target.png",X,Y,0,0,0,0,5,"T|R",0)
if(SucCount > 0){ 
    loop,%SucCount%
    {
        targetX := X[A_index]
        targetY := Y[A_index]
        MsgBox,Idx:%A_Index% X:%targetX% Y:%targetY%
    }
}
else{
    MsgBox,Fail
}