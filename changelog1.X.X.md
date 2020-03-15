## 1.0.2
- Remove `Capture` function
### Why?
> You must call GdiplusStartup before you create any GDI+ objects, and you must delete all of your GDI+ objects (or have them go out of scope) 
before you call GdiplusShutdown. - MS Docs  

Origin [here](https://docs.microsoft.com/en-us/windows/win32/api/gdiplusinit/nf-gdiplusinit-gdiplusstartup#remarks)  
That is, objects created after the Gdip_Shutdown function is called are not available.  
So there is a memory leak.  

## 1.0.1
- Add IsWindowMinimize function
- In __CaptureforSave__ function, change Gdip_BitmapFromHWND to Gdip_BitmapFromScreen
- In __Capture__ function, change Gdip_BitmapFromHWND to Gdip_BitmapFromScreen
### Why?
> PrintWindow is slow, and you can avoid that overhead on most windows. just use Gdip_BitmapFromScreen() with "hwnd:" string parameter instead of Gdip_BitmapFromHwnd(), and that will still work for inactive windows as long as the DWM is running. - guest3456(Forum)