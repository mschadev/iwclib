#include ..\lib\gdip.ahk
#include ..\iwclib.ahk
UpLParam := MakeKeyUpLParam(65) ;A key
DownLParam := MakeKeyDownLParam(65) ;A key
;MsgBox,UpLParam:%UpLParam% DownLParam:%DownLParam%
postmessage, 0x100,65, %UpLParam%,Edit1,제목 없음 - Windows 메모장
postmessage, 0x101, 65, %DownLParam%,Edit1,제목 없음 - Windows 메모장