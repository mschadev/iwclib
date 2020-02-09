#include ..\inactive.ahk
#include ..\lib\gdip.ahk
MsgBox,% Capture("작업 관리자",50,50,100,200)
MsgBox,% CaptureforSave("작업 관리자","test2.bmp")
return