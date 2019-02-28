#include ..\inactive.ahk
#include ..\lib\gdip.ahk
MsgBox,% Capture("작업 관리자",50,50,100,200)
MsgBox,% CaptureforSave("작업 관리자","test2.bmp")
_hBitmap := ScreenCapture()
ScreenCaptureforSave("background.bmp","0|0|1920|1080")
Gdip_DisposeImage(_hBitmap)
return