;======================================
;Inactive Windows Program Capture for save
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
;Screen := Screen Rect
;return value :Bitmap pointer(address).If not zero, success.
;ex)Capture("0|0|1920|1080")
;======================================
ScreenCapture(Screen=0){
	_Token := Gdip_Startup()
	_hBitmap := Gdip_BitmapFromScreen(Screen)
	Gdip_ShutDown(_Token)
	return _hBitmap
}
;======================================
;Inactive Windows Screen Capture for save
;FilePath := Image Save Path
;Screen := Screen Rect
;return value :1 if successful, 0 if failed
;ex)Capture("0|0|1920|1080")
;======================================
ScreenCaptureforSave(FilePath,Screen=0){
	_Token := Gdip_Startup()
	_hBitmap := Gdip_BitmapFromScreen(Screen)
	if(_hBitmap = 0){
		return false
	}
	Gdip_SaveBitmapToFile(_hBitmap, FilePath)
	Gdip_DisposeImage(_hBitmap)
	Gdip_ShutDown(_Token)
	
	return true
}

;======================================
;Inactive Windows Program Capture
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
;======================================
;Inactive ready Init Function
;FilePath := Image Save Path
;Screen := Screen Rect
;return value :If inactive ready is return 1,if not inactive ready is return 0
;ex)Capture("0|0|1920|1080")
;======================================
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
;return value :1 if successful, 0 if failed
;ex)SendStr("Windows","hello world")
;======================================
SendStr(Title,Str,Delay=0){
	IfWinNotExist,%Title%
	{
		return false
	}
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
;======================================
;;Inactive Image Search
;Title := Windows title
;image := Search image path
;RefX := Point x var
;RefY := Point y var
;X1 := Rect left
;Y1 := Rect top
;X2 := Rect right
;Y2 := Rect bottom
;Loc := Image error range
;SearchDirection := Haystack search direction
; Vertical preference:
;  T|L = top->left->right->bottom [default]
;  B|L = bottom->left->right->top
;  B|R = bottom->right->left->top
;  T|R = top->right->left->bottom
; Horizontal preference:
;  L|T = left->top->bottom->right
;  L|B = left->bottom->top->right
;  R|B = right->bottom->top->left
;  R|T = right->top->bottom->left
;Instances := Maximum number of instances to find when searching (0 = find all)
;return value: Number of images found
;ex)InactiveImageSearch("작업 관리자","test.png",X[1],Y[1])
;======================================
InactiveImageSearch(Title,Image,byref RefX,byref RefY,X1=0,Y1=0,X2=0,Y2=0,Loc=10,SearchDirection="T|L",Instances=1){
	if(!Init()){
		return false
	}
	
	if(SearchDirection = "B|L")
	{
		_SearchDirection := 2
	}
	else if(SearchDirection = "B|R")
	{
		_SearchDirection := 3
	}
	else if(SearchDirection = "T|R")
	{
		_SearchDirection := 4
	}
	else if(SearchDirection = "L|T")
	{
		_SearchDirection := 5
	}
	else if(SearchDirection = "L|B")
	{
		_SearchDirection := 6
	}
	else if(SearchDirection = "R|B")
	{
		_SearchDirection := 7
	}
	else if(SearchDirection = "R|T")
	{
		_SearchDirection := 8
	}
	else
	{
		_SearchDirection := 1
	}
	;MsgBox,%_SearchDirection%
	_Token := Gdip_Startup()
	_hBitmap := Capture(Title)
	if(_hBitmap = 0){
		Gdip_Shutdown(_Token)
		return false
	}
	_Image := Gdip_CreateBitmapFromFile(Image)
	if(_Image = 0){
		if(_hBitmap != 0){
			Gdip_DisposeImage(_hBitmap)
		}
		Gdip_Shutdown(_Token)
		return false
	}
	_Success := Gdip_ImageSearch(_hBitmap,_Image,PointArray,X1,Y1,X2,Y2,Loc,"",SearchDirection,Instances)
	
	if(_Success > 0){
		_ArrayX := Object()
		_ArrayY := Object()
		;MsgBox,%PointArray%
		loop,parse,PointArray,`n
		{
			StringSplit,Point,A_LoopField,`,
			;MsgBox,%A_Index% %Point1% %Point2%
			_ArrayX.Insert(Point1)
			_ArrayY.Insert(Point2)
			
		}
		RefX := _ArrayX
		RefY := _ArrayY
	}
	else{
		RefX := 0
		RefY := 0
	}
	Gdip_DisposeImage(_hBitmap)
	Gdip_DisposeImage(_Image)
	Gdip_Shutdown(_Token)
	return _Success
}
;======================================
;ImageSearch from image file
;BackgroundImage := Background image path
;TargetImage := Target image path
;RefX := Point x var
;RefY := Point y var
;X1 := Rect left
;Y1 := Rect top
;X2 := Rect right
;Y2 := Rect bottom
;Loc := Image error range
;SearchDirection := Haystack search direction
; Vertical preference:
;  T|L = top->left->right->bottom [default]
;  B|L = bottom->left->right->top
;  B|R = bottom->right->left->top
;  T|R = top->right->left->bottom
; Horizontal preference:
;  L|T = left->top->bottom->right
;  L|B = left->bottom->top->right
;  R|B = right->bottom->top->left
;  R|T = right->top->bottom->left
;Instances := Maximum number of instances to find when searching (0 = find all)
;return value: Number of images found
;ex)ImageSearchFromFile("Background.png","target.png",X[1],Y[1])
;======================================
ImageSearchFromFile(BackgroundImage,TargetImage,byref RefX,byref RefY,X1=0,Y1=0,X2=0,Y2=0,Loc=10,SearchDirection="T|L",Instances=1){
	if(!Init()){
		return false
	}
	
	if(SearchDirection = "B|L")
	{
		_SearchDirection := 2
	}
	else if(SearchDirection = "B|R")
	{
		_SearchDirection := 3
	}
	else if(SearchDirection = "T|R")
	{
		_SearchDirection := 4
	}
	else if(SearchDirection = "L|T")
	{
		_SearchDirection := 5
	}
	else if(SearchDirection = "L|B")
	{
		_SearchDirection := 6
	}
	else if(SearchDirection = "R|B")
	{
		_SearchDirection := 7
	}
	else if(SearchDirection = "R|T")
	{
		_SearchDirection := 8
	}
	else
	{
		_SearchDirection := 1
	}
	_Token := Gdip_Startup()
	_BackgroundBitmap := Gdip_CreateBitmapFromFile(BackgroundImage)
	_TargetBitmap := Gdip_CreateBitmapFromFile(TargetImage)
	if(_BackgroundBitmap = 0 || _TargetBitmap = 0){
		Gdip_Shutdown(_Token)
		Gdip_DisposeImage(_BackgroundBitmap)
		Gdip_DisposeImage(_TargetBitmap)
		return false
	}
	_Success := Gdip_ImageSearch(_BackgroundBitmap,_TargetBitmap,PointArray,X1,Y1,X2,Y2,Loc,"",SearchDirection,Instances)
	if(_Success > 0){
		_ArrayX := Object()
		_ArrayY := Object()
		;MsgBox,%PointArray%
		loop,parse,PointArray,`n
		{
			StringSplit,Point,A_LoopField,`,
			;MsgBox,%A_Index% %Point1% %Point2%
			_ArrayX.Insert(Point1)
			_ArrayY.Insert(Point2)
			
		}
		RefX := _ArrayX
		RefY := _ArrayY
	}
	else{
		RefX := 0
		RefY := 0
	}
	Gdip_DisposeImage(_hBitmap)
	Gdip_DisposeImage(_Image)
	Gdip_Shutdown(_Token)
	return _Success
}
;======================================
;Inactive Pixel Search
;Title : Window title
;ARGB := Pixel Color to Find
;Delay : Input delay
;X := Point x var
;Y := Point y var
;X1 := Rect left
;Y1 := Rect top
;X2 := Rect right
;Y2 := Rect bottom
;return value :1 if successful, 0 if failed
;ex)InactivePixelSearch("작업 관리자",0xff03ceb4,X,Y)
;======================================
InactivePixelSearch(Title, ARGB, ByRef X, ByRef Y,X1=0,Y1=0,X2=0,Y2=0)
{
	if(!Init()){
		return false
	}
	_Token := Gdip_Startup()
	_hBitmap := Capture(Title)
	if(_hBitmap = 0){
		Gdip_Shutdown(_Token)
		return false
	}
	static _PixelSearch
	if !_PixelSearch
	{
		MCode_PixelSearch := "8B44241099535583E2035603C233F6C1F80239742418577E388B7C24148B6C24248B5424188D1C85000000008D64240033C085"
		. "D27E108BCF3929743183C00183C1043BC27CF283C60103FB3B74241C7CDF8B4424288B4C242C5F5EC700FFFFFFFF5DC701FFFFFFFF83C8FF5BC38B4C2"
		. "4288B54242C5F890189325E5D33C05BC3"

		VarSetCapacity(_PixelSearch, StrLen(MCode_PixelSearch)//2)
		Loop % StrLen(MCode_PixelSearch)//2      ;%
			NumPut("0x" SubStr(MCode_PixelSearch, (2*A_Index)-1, 2), _PixelSearch, A_Index-1, "char")
	}
	Gdip_GetImageDimensions(_hBitmap, Width, Height)
	if !(Width && Height)
		return -1
	Width := (X2 != 0) ? X2-X1 : Width
	Height := (Y2 != 0) ? Y2-Y1 : Height
	if (E1 := Gdip_LockBits(_hBitmap, X1, Y1, Width, Height, Stride1, Scan01, BitmapData1))
		return -2
	
	x := y := 0
	E := DllCall(&_PixelSearch, "uint", Scan01, "int", Width, "int", Height, "int", Stride1, "uint",ARGB, "int*", x, "int*", y)
	X += X1 ;비트맵 시작점 X1만큼 추가해줘야 비트맵 크기에서 좌표 값 나옴
	Y += Y1 ;비트맵 시작점 Y1만큼 추가해줘야 비트맵 크기에서 좌표 값 나옴
	;MsgBox,%hWnd% %_hBitmap% %y% %y% %E% %Width% %Height% %X1% %Y1% %X2% %Y2% ;DEBUG
	Gdip_UnlockBits(_hBitmap, BitmapData1)
	Gdip_DisposeImage(_hBitmap)
	Gdip_Shutdown(_Token)
	return (E = 0 || E != "") ? 1 : 0
}
;======================================
;Hide Window
;Title : Window title
;return value :1 if successful, 0 if failed
;ex)HideWindow("작업 관리자")
;======================================
HideWindow(Title){
	WinGet, _hWnd,ID,%Title%
	WinGetPos,,,_Width,_Height,ahk_id %_hWnd%
	_X := _Width * -1
	_Y := 0
	;MsgBox,%_hWnd% %_X% %_Width% ;DEBUG
	return DllCall("SetWindowPos", "UInt", _hWnd, "UInt", 0, "Int",_X, "Int",_Y, "Int",_Width, "Int",_Height, "UInt", 0x400)
}
;======================================
;Show hidden windows
;Title : Window title
;ex)HideWindow("작업 관리자")
;======================================
ShowWindow(Title){
	WinMove, %Title%,,0,0
}
;======================================
;Function to create lparam required for 'postmessage'
;vk : VK Code (https://docs.microsoft.com/en-us/windows/desktop/inputdev/virtual-key-codes)
;ex)MakeKeyUpLParam(65)
;======================================
MakeKeyUpLParam(vk=0){
	_scan := DllCall("MapVirtualKey","Uint",vk,"Uint",0,"Uint")
	_LParam := (0x00000001 | (_scan << 16))
	return _LParam
}
;======================================
;Function to create lparam required for 'postmessage'
;vk : VK Code (https://docs.microsoft.com/en-us/windows/desktop/inputdev/virtual-key-codes)
;ex)MakeKeyUpLParam(65)
;======================================
MakeKeyDownLParam(vk=0){
	_scan := DllCall("MapVirtualKey","Uint",vk,"Uint",0,"Uint")
	_LParam := (0x00000001 | (_scan << 16))
	_LParam |= 0xC0000000
	return _LParam
}
