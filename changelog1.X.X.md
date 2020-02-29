## 1.0.1
- Add IsWindowMinimize function
- In __CaptureforSave__ function, change Gdip_BitmapFromHWND to Gdip_BitmapFromScreen
- In __Capture__ function, change Gdip_BitmapFromHWND to Gdip_BitmapFromScreen
### Why?
> PrintWindow is slow, and you can avoid that overhead on most windows. just use Gdip_BitmapFromScreen() with "hwnd:" string parameter instead of Gdip_BitmapFromHwnd(), and that will still work for inactive windows as long as the DWM is running. - guest3456(Forum)