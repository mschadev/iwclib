﻿#include ..\lib\gdip.ahk
#include ..\inactive.ahk
UpLParam := MakeKeyUpLParam(65)
DownLParam := MakeKeyDownLParam(65)
;MsgBox,UpLParam:%UpLParam% DownLParam:%DownLParam%
postmessage, 0x100,65, %UpLParam%,Edit1,제목 없음 - 메모장
postmessage, 0x101, 65, %DownLParam%,Edit1,제목 없음 - 메모장