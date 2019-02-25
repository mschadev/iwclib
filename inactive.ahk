;======================================
;Inactive Windows Screen Capture for save
;hWnd := Windows HWND 
;X : Image X
;Y : Image Y
;W : Image Width
;H : Image Height
;Flag : PrintScreen API Flag
;return value :Bitmap pointer(address).If not zero, success.
;ex)Capture(0x50af4)
;======================================
CaptureforSave(Title,FilePath,X=0,Y=0,W=0,H=0,Flag=0){
	if(!Init()){
		return false
	}
	WinGet, hWnd,ID,%Title%
	if(hWnd == 0){
		return false
	}	
	_Token := Gdip_Startup()
	_hBitmap := Gdip_BitmapFromHwnd(hWnd,Flag)
	if(!_hBitmap){
		Gdip_ShutDown(_Token)
		return false
	}
	WinGetPos,_X,_Y,_Width,_Height,ahk_id %hWnd%
	if(w!=0 && h!=0 && x >=0 && y >= 0 && w+x <= _Width && y+h <= _Height){
		_hBitmap_temp := _hBitmap ;주소값 대입 후 메모리 해제용으로 사용
		_hBitmap := Gdip_CropImage(_hBitmap,x,y,w,h)
		Gdip_DisposeImage(_hBitmap_temp)
	}
	Gdip_SaveBitmapToFile(_hBitmap, FilePath)
	Gdip_DisposeImage(_hBitmap)
	Gdip_ShutDown(_Token)
	return true
}
;======================================
;Inactive Windows Screen Capture
;hWnd := Windows HWND 
;X : Image X
;Y : Image Y
;W : Image Width
;H : Image Height
;Flag : PrintScreen API Flag
;return value :Bitmap pointer(address).If not zero, success.
;ex)Capture(0x50af4)
;======================================
Capture(Title,X=0,Y=0,W=0,H=0,Flag=0){
	if(!Init()){
		return false
	}
	WinGet, hWnd,ID,%Title%
	if(hWnd == 0){
		return false
	}	
	IfWinNotExist,ahk_id %hWnd%
	{
		return false
	}
	_Token := Gdip_Startup()
	_hBitmap := Gdip_BitmapFromHwnd(hWnd,Flag)
	if(!_hBitmap){
		Gdip_ShutDown(_Token)
		return false
	}
	WinGetPos,_X,_Y,_Width,_Height,ahk_id %hWnd%
	if(w!=0 && h!=0 && x >=0 && y >= 0 && w+x <= _Width && y+h <= _Height){
		_hBitmap_temp := _hBitmap ;주소값 대입 후 메모리 해제용으로 사용
		_hBitmap := Gdip_CropImage(_hBitmap,x,y,w,h)
		Gdip_DisposeImage(_hBitmap_temp)
	}
	Gdip_ShutDown(_Token)
	return _hBitmap

}
Init(){
	if not A_IsAdmin 
	{ 
		return false
	}
	return true
}
;======================================
;Inactive Mouse Click(left)
;Title : Window title
;X : Point X
;Y : Point Y
;ex)SimpleClick("Windows",100,100)
;======================================
SimpleClick(Title,X,Y)
{
ControlClick,x%X% y%Y%,%Title%,,,,NA
return
}
;======================================
;Inactive Send string
;Title : Window title
;Str : String
;Delay : Input delay
;ex)SendStr("Windows","hello world")
;======================================
SendStr(Title,Str,Delay=0){
	if(strlen(Str) < 0){
		return false
	}
        Loop,Parse,Str,
        {
			char := A_LoopField
			if(char = " "){
				char := "Space"
			}
            ControlSend,,{%char%},%Title%
			sleep,%Delay%
        }
		return true
}

InactiveImageSearch(byref RefX,byref RefY,Title,Image,X1=0,Y1=0,X2=0,Y2=0,Loc=10){
	if(!Init()){
		return false
	}
	WinGet, hWnd,ID,%Title%
	if(hWnd == 0){
		return false
	}	
	_Token := Gdip_Startup()
	_Bitmap := Capture(Title)
	if(_Bitmap = 0){
		return false
	}
	_Image := Gdip_CreateBitmapFromFile(Image)
	if(_Image = 0){
		if(_Bitmap != 0){
			Gdip_DisposeImage(_Bitmap)
		}
		return false
	}
	_Success := Gdip_ImageSearch(_Bitmap,_Image,Point,X1,Y1,X2,Y2,Loc,0x000000,1,1)
	if(_Success = true){
		StringSplit,PointArray,Point,`,
		RefX := PointArray1
		RefY := PointArray2
	}
	else{
		RefX := 0
		RefY := 0
	}
	Gdip_DisposeImage(_Bitmap)
	Gdip_DisposeImage(_Image)
	Gdip_Shutdown(_Token)
	return _Success
}

