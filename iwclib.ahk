;!!!!!!!!!!README!!!!!!!!!!
;작업 관리자 is Task manager
;
;Version: 1.0.1
;
;!!!!!!!!!!README!!!!!!!!!!



;======================================
;Check the window for minimize
;
;Title: Window program title
;
;return value:
;	1: Window is minimized
;	0: Window is not minimized
;ex)IsWindowMinimize("작업관리자")
;======================================
IsWindowMinimize(Title){
	WinGet,Result,MinMax,%Title%
	if(Result = -1)
	{
		return true
	}
	else
	{
		return false
	}
}

;======================================
;Inactive window program capture for save
;
;Title: Window program title
;FilePath: Image save path
;X: Image X
;Y: Image Y
;W: Image width
;H: Image height
;Flag: PrintScreen WINAPI Flag
;
;return value:
;	0: Capture Failure
;	-1: Requires administrator privileges
;	-2: Window program does not exist
;	other(Bitmap Pointer): Success
;
;ex)CaptureforSave("작업관리자","background.png")
;======================================
CaptureforSave(Title,FilePath,X=0,Y=0,W=0,H=0,Flag=0)
{
	if not A_IsAdmin
	{
		return -1
	}
	WinGet, hWnd,ID,%Title%
	if(hWnd == 0)
	{
		return -2
	}	
	_Token := Gdip_Startup()
	_hBitmap := Gdip_BitmapFromScreen("hwnd:" hWnd)
	if(!_hBitmap)
	{
		Gdip_ShutDown(_Token)
		return false
	}
	WinGetPos,_X,_Y,_Width,_Height,ahk_id %hWnd%
	if(w!=0 && h!=0 && x >=0 && y >= 0 && w+x <= _Width && y+h <= _Height)
	{
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
;Inactive mouse click(left)
;
;Title: Window program title
;X: Point X
;Y: Point Y
;
;return value:
;	void
;
;ex)SimpleClick("작업 관리자",100,100)
;======================================
SimpleClick(Title,X,Y)
{
ControlClick,x%X% y%Y%,%Title%,,,,NA
return
}

;======================================
;Send inactive string
;
;Title: Window program title
;Str: String
;Delay: Input delay
;
;return value:
;	1: Success
;	0: String length is 0
;	-1: Window program does not exist
;
;ex)SendStr("작업 관리자","hello world")
;======================================
SendStr(Title,Str,Delay=0)
{
	IfWinNotExist,%Title%
	{
		return -1
	}
	if(strlen(Str) < 0)
	{
		return false
	}
        Loop,Parse,Str,
        {
			char := A_LoopField
			if(char = " ")
			{
				char := "Space"
			}
            ControlSend,,{%char%},%Title%
			sleep,%Delay%
        }
		return true
}

;======================================
;Inactive Image Search
;
;Title: Window title
;image: Search image path
;RefX: Variable to store X coordinates
;RefY: Variable to store Y coordinates
;X1: Rect left
;Y1: Rect top
;X2: Rect right
;Y2: Rect bottom
;Loc: Image error range
;SearchDirection: Haystack search direction
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
;
;return value:
;	-1: Requires administrator privileges
;	-2: Window program does not exist
;	-3: Capture failure
;	-4: Image load failure
;	0: Image not found
;	value > 0: Number of images found
;
;ex)InactiveImageSearch("작업 관리자","test.png",X,Y)
;======================================
InactiveImageSearch(Title,Image,byref RefX,byref RefY,X1=0,Y1=0,X2=0,Y2=0,Loc=10,SearchDirection="T|L",Instances=1)
{
	if not A_IsAdmin
	{
		return -1
	}
	WinGet, hWnd,ID,%Title%
	if(hWnd == 0)
	{
		return -2
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
	_hBitmap := Capture(Title)
	if(_hBitmap = 0)
	{
		Gdip_Shutdown(_Token)
		return -3
	}
	_Image := Gdip_CreateBitmapFromFile(Image)
	if(_Image = 0)
	{
		if(_hBitmap != 0)
		{
			Gdip_DisposeImage(_hBitmap)
		}
		Gdip_Shutdown(_Token)
		return -4
	}
	_Count := Gdip_ImageSearch(_hBitmap,_Image,PointArray,X1,Y1,X2,Y2,Loc,"",SearchDirection,Instances)	
	if(_Count > 0)
	{
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
	else
	{
		RefX := 0
		RefY := 0
	}
	Gdip_DisposeImage(_hBitmap)
	Gdip_DisposeImage(_Image)
	Gdip_Shutdown(_Token)
	return _Count
}

;======================================
;ImageSearch from image

;BackgroundImage: Background image path
;TargetImage: Target image path
;RefX: Variable to store X coordinates
;RefY: Variable to store Y coordinates
;X1: Rect left
;Y1: Rect top
;X2: Rect right
;Y2: Rect bottom
;Loc: Image error range
;SearchDirection: Haystack search direction
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
;
;return value:
;	-1: Requires administrator privileges
;	-2: Background image load failure
;	-3: Target image load failure
;	0: Target image not found
;	value > 0: Number of images found
;
;ex)ImageSearchFromFile("Background.png","target.png",X,Y)
;======================================
ImageSearchFromFile(BackgroundImage,TargetImage,byref RefX,byref RefY,X1=0,Y1=0,X2=0,Y2=0,Loc=10,SearchDirection="T|L",Instances=1)
{
	if not A_IsAdmin
	{
		return -1
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
	if(_BackgroundBitmap = 0 || _TargetBitmap = 0)
	{
		Gdip_Shutdown(_Token)
		Gdip_DisposeImage(_BackgroundBitmap)
		Gdip_DisposeImage(_TargetBitmap)
		return (_BackgroundBitmap = 0 ? -2 : -3)
	}
	_Success := Gdip_ImageSearch(_BackgroundBitmap,_TargetBitmap,PointArray,X1,Y1,X2,Y2,Loc,"",SearchDirection,Instances)
	if(_Success > 0)
	{
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
	else
	{
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
;
;Title: Window program title
;ARGB: Pixel color to find
;Delay: Input delay
;X: Variable to store X coordinates
;Y: Variable to store Y coordinates
;X1: Rect left
;Y1: Rect top
;X2: Rect right
;Y2: Rect bottom
;
;return value:
;	-1: Requires administrator privileges
;	-2: Window program does not exist
;	-3: Capture failure
;	0: Pixel not found(failure)
;	1: Success
;
;ex)InactivePixelSearch("작업 관리자",0xff03ceb4,X,Y)
;======================================
InactivePixelSearch(Title, ARGB, ByRef X, ByRef Y,X1=0,Y1=0,X2=0,Y2=0)
{
	if not A_IsAdmin
	{
		return -1
	}
	WinGet, hWnd,ID,%Title%
	if(hWnd == 0)
	{
		return -2
	}
	_Token := Gdip_Startup()
	_hBitmap := Capture(Title)
	if(_hBitmap = 0)
	{
		Gdip_Shutdown(_Token)
		return -3
	}
	static _PixelSearch
	if !_PixelSearch
	{
		if(A_PtrSize = 4)
		{
			MCode_PixelSearch := "8B44241099535583E2035603C233F6C1F80239742418577E388B7C24148B6C24248B5424188D1C85000000008D64240033C085"
			. "D27E108BCF3929743183C00183C1043BC27CF283C60103FB3B74241C7CDF8B4424288B4C242C5F5EC700FFFFFFFF5DC701FFFFFFFF83C8FF5BC38B4C2"
			. "4288B54242C5F890189325E5D33C05BC3" ;Laszlo style
			VarSetCapacity(_PixelSearch, StrLen(MCode_PixelSearch)//2)
			Loop % StrLen(MCode_PixelSearch)//2      ;%
				NumPut("0x" SubStr(MCode_PixelSearch, (2*A_Index)-1, 2), _PixelSearch, A_Index-1, "char")
		}
		else
		{
			MCode_PixelSearch := "2,x64:VUiJ5UiD7EBIiU0QiVUYRIlFIESJTShIi0UQSIlF8ItFMMHoGIlF7ItFMMHoECX/AAAAiUXoi0UwwegIJf8AAACJReSLRTAl/wAAAIlF4MdF/AAAAADpyAAAAMdF+AAAAADprAAAAItF+MHgAkhj0ItF/A+vRSiNSAOFwA9IwcH4AkiYSAHQSI0UhQAAAABIi0XwSAHQSIlF2EiLRdiLAMHoGIlF1EiLRdiLAMHoECX/AAAAiUXQSItF2IsAwegIJf8AAACJRcxIi0XYiwAl/wAAAIlFyItF7DtF1HUxi0XoO0XQdSmLReQ7Rcx1IYtF4DtFyHUZSItFOItV+IkQSItFQItV/IkQuAEAAADrJYNF+AGLRfg7RRgPjEj///+DRfwBi0X8O0UgD4ws////uAAAAABIg8RAXcOQkJCQkJA=" ;Bentschi style
			;This function is "C_function\PixelSearch.c"
			_PixelSearch := __BentschiMCode__(MCode_PixelSearch)
		}
		
	}
	Gdip_GetImageDimensions(_hBitmap, Width, Height)
	if !(Width && Height)
		return -1
	Width := (X2 != 0) ? X2-X1 : Width
	Height := (Y2 != 0) ? Y2-Y1 : Height
	if (E1 := Gdip_LockBits(_hBitmap, X1, Y1, Width, Height, Stride1, Scan01, BitmapData1))
		return -2
	
	x := y := 0
	if(A_PtrSize = 4)
	{
		E := DllCall(&_PixelSearch, "uint", Scan01, "int", Width, "int", Height, "int", Stride1, "uint",ARGB, "int*", x, "int*", y)
	}
	else
	{
		E := DllCall(_PixelSearch,"uint",Scan01,"int",Width,"int",Height,"int",Stride1,"uint",ARGB,"int*",x,"int*",y,"cdecl int")
	}
	
	;MsgBox,%hWnd% %_hBitmap% %y% %y% %E% %Width% %Height% %X1% %Y1% %X2% %Y2% ;DEBUG
	Gdip_UnlockBits(_hBitmap, BitmapData1)
	Gdip_DisposeImage(_hBitmap)
	Gdip_Shutdown(_Token)
	return (E = 1 || E != "") ? 1 : 0
}

;======================================
;Multiple Inactive Pixel Search
;
;Title: Window program title
;ARGB: Pixel color to find
;Delay: Input delay
;X: Variable to store X coordinates
;Y: Variable to store Y coordinates
;X1: Rect left
;Y1: Rect top
;X2: Rect right
;Y2: Rect bottom
;Instances := Maximum number of instances to find when searching (0 = find all)
;
;return value:
;	-1: Requires administrator privileges
;	-2: Window program does not exist
;	-3: Capture failure
;	0: Pixel not found(failure)
;	value > 0: Number of pixel found
;
;ex)MultipleInactivePixelSearch("작업 관리자",0xff03ceb4,X,Y,0,0,0,0,3)
;======================================
MultipleInactivePixelSearch(Title, ARGB, ByRef X, ByRef Y,X1=0,Y1=0,X2=0,Y2=0,Instances=0)
{
		if not A_IsAdmin
	{
		return -1
	}
	WinGet, hWnd,ID,%Title%
	if(hWnd == 0)
	{
		return -2
	}
	_Token := Gdip_Startup()
	_hBitmap := Capture(Title)
	
	if(_hBitmap = 0)
	{
		Gdip_Shutdown(_Token)
		return -3
	}
	static _MultiplePixelSearch
	if !_MultiplePixelSearch
	{
		if(A_PtrSize = 4)
		{
			MCode_MultiplePixelSearch := "2,x86:VYnlg+wwi0UIiUX0i0UgwegYiUXwi0UgwegQJf8AAACJReyLRSDB6Agl/wAAAIlF6ItFICX/AAAAiUXki0UMiUX8i0UQiUX46bcAAACLRfyNFIUAAAAAi0X4D69FHAHQjVADhcAPSMLB+AKNFIUAAAAAi0X0AdCJReCLReCLAMHoGIlF3ItF4IsAwegQJf8AAACJRdiLReCLAMHoCCX/AAAAiUXUi0XgiwAl/wAAAIlF0ItF8DtF3HUvi0XsO0XYdSeLReg7RdR1H4tF5DtF0HUXi0Uki1X8iRCLRSiLVfiJELgBAAAA6yiDRfwBi0X8O0UUD4xU////x0X8AAAAAINF+AGLRfg7RRh84bgAAAAAycOQ" ;Bentschi style
			;This function is "C_function\MultiplePixelSearch.c"
		}
		else
		{
			MCode_MultiplePixelSearch := "2,x64:VUiJ5UiD7EBIiU0QiVUYRIlFIESJTShIi0UQSIlF8ItFQMHoGIlF7ItFQMHoECX/AAAAiUXoi0VAwegIJf8AAACJReSLRUAl/wAAAIlF4ItFGIlF/ItFIIlF+OnDAAAAi0X8jRSFAAAAAItF+A+vRTgB0I1QA4XAD0jCwfgCSJhIjRSFAAAAAEiLRfBIAdBIiUXYSItF2IsAwegYiUXUSItF2IsAwegQJf8AAACJRdBIi0XYiwDB6Agl/wAAAIlFzEiLRdiLACX/AAAAiUXIi0XsO0XUdTGLReg7RdB1KYtF5DtFzHUhi0XgO0XIdRlIi0VIi1X8iRBIi0VQi1X4iRC4AQAAAOsog0X8AYtF/DtFKA+MSP///8dF/AAAAACDRfgBi0X4O0UwfOG4AAAAAEiDxEBdw5CQkJCQkJCQkJA="
		}
		_MultiplePixelSearch := __BentschiMCode__(MCode_MultiplePixelSearch)
	}
	Gdip_GetImageDimensions(_hBitmap, Width, Height)
	if !(Width && Height)
		return -1
	clone := Gdip_CloneBitmapArea(_hBitmap,0,0,Width,Height)
	Width := (X2 != 0) ? X2-X1 : Width
	Height := (Y2 != 0) ? Y2-Y1 : Height
	if (E1 := Gdip_LockBits(_hBitmap, X1, Y1, Width, Height, Stride1, Scan01, BitmapData1))
		return -2
	
	_ResultX := _ResultY := 0
	_X := _Y := 0
	_ArrayX := Object()
	_ArrayY := Object()
	_Count := 0
	while((E := DllCall(_MultiplePixelSearch,"uint",Scan01,"int",_X,"int",_Y,"int",Width,"int",Height,"int",Stride1,"uint",ARGB,"int*",_ResultX,"int*",_ResultY,"cdecl uint")) = 1)
	{
		;MsgBox,In while %_ResultX% %_ResultY%
		_X := _ResultX+1
		_Y := _ResultY 
		_ArrayX.Insert(_X-1)
		_ArrayY.Insert(_Y)
		_Count++
		if(_Count=Instances)
		{
			break
		}
	}
	X := _ArrayX
	Y := _ArrayY
	Gdip_UnlockBits(_hBitmap, BitmapData1)
	Gdip_DisposeImage(_hBitmap)
	Gdip_Shutdown(_Token)
	return _Count
}

;======================================
;Hide window program
;
;Title: Window program title
;
;return value:
;	1:Success
;	0:Failure
;
;ex)HideWindow("작업 관리자")
;======================================
HideWindow(Title)
{
	WinGet, _hWnd,ID,%Title%
	WinGetPos,,,_Width,_Height,ahk_id %_hWnd%
	;_X := _Width * -1
	_X := -20000
	_Y := 0
	;MsgBox,%_hWnd% %_X% %_Width% ;DEBUG
	return DllCall("SetWindowPos", "UInt", _hWnd, "UInt", 0, "Int",_X, "Int",_Y, "Int",_Width, "Int",_Height, "UInt", 0x400)
}

;======================================
;Show hidden window program
;
;Title : Window program title
;
;ex)HideWindow("작업 관리자")
;======================================
ShowWindow(Title)
{
	WinMove, %Title%,,0,0
}

;======================================
;Function to create lparam required for 'postmessage'
;
;vk : VK Code (https://docs.microsoft.com/en-us/windows/desktop/inputdev/virtual-key-codes)
;
;return value:
;	integer: LParam
;
;ex)MakeKeyUpLParam(65)
;======================================
MakeKeyUpLParam(vk=0)
{
	_scan := DllCall("MapVirtualKey","Uint",vk,"Uint",0,"Uint")
	_LParam := (0x00000001 | (_scan << 16))
	return _LParam
}

;======================================
;Function to create lparam required for 'postmessage'
;
;vk : VK Code (https://docs.microsoft.com/en-us/windows/desktop/inputdev/virtual-key-codes)
;
;return value:
;	integer: LParam
;
;ex)MakeKeyUpLParam(65)
;======================================
MakeKeyDownLParam(vk=0)
{
	_scan := DllCall("MapVirtualKey","Uint",vk,"Uint",0,"Uint")
	_LParam := (0x00000001 | (_scan << 16))
	_LParam |= 0xC0000000
	return _LParam
}

;======================================
;Bentschi MCode Function
;
;mcode: Mcode(https://autohotkey.com/board/topic/89283-mcode-function-onlinegenerator-x86-and-x64/)
;
;return value:
;	integer: function pointer
;
;ex)MCode("2,x86:aipYww==,x64:uCoAAADD")
;======================================
__BentschiMCode__(mcode)
{
  static e := {1:4, 2:1}, c := (A_PtrSize=8) ? "x64" : "x86"
  if (!regexmatch(mcode, "^([0-9]+),(" c ":|.*?," c ":)([^,]+)", m))
    return
  if (!DllCall("crypt32\CryptStringToBinary", "str", m3, "uint", 0, "uint", e[m1], "ptr", 0, "uint*", s, "ptr", 0, "ptr", 0))
    return
  p := DllCall("GlobalAlloc", "uint", 0, "ptr", s, "ptr")
  if (c="x64")
    DllCall("VirtualProtect", "ptr", p, "ptr", s, "uint", 0x40, "uint*", op)
  if (DllCall("crypt32\CryptStringToBinary", "str", m3, "uint", 0, "uint", e[m1], "ptr", p, "uint*", s, "ptr", 0, "ptr", 0))
    return p
  DllCall("GlobalFree", "ptr", p)
}
