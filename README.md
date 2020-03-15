# iwclib
![](https://img.shields.io/github/repo-size/zxc010613/iwclib)  
Simple Inactive Windows Control Library for AutoHotKey(L)  
Autohotkey Forum Post: [here](https://www.autohotkey.com/boards/viewtopic.php?f=6&t=73094)  

# Support version
- ### Unicode32  
- ### Unicode64  
- ### ANSI32

# Installation

1. Download [here](./releases)
2. Include "iwclib-full.ahk" in the script.

```autohotkey
#include iwclib-full.ahk
```

# Supported functions

Table of supported functions.  
If exist `*` before function name,  __Requires administrator privileges__

### Capture

| Function             | Description                               |
| -------------------- | ----------------------------------------- |
| *CaptureforSave       | Inactive Windows Program Capture for save |

### Control

| Function    | Description                |
| ----------- | -------------------------- |
| SimpleClick | Inactive Mouse Click(left) |
| SendStr     | Inactive Send string       |

### Windows

| Function            | Description                 |
| ------------------- | --------------------------- |
| *InactiveImageSearch | Inactive Image Search       |
| *ImageSearchFromFile | ImageSearch From Image File |
| *InactivePixelSearch | Inactive Pixel Search       |
| *MultipleInactivePixelSearch | Multiple Inactive Pixel Search |
| HideWindow          | Hide Window                 |
| ShowWindow          | Show Window                 |
| IsWindowMinimize    | Check the window for minimize |

### Etc

| Function          | Description                                          |
| ----------------- | ---------------------------------------------------- |
| MakeKeyDownLParam | Function to create lparam required for 'postmessage' |
| MakeKeyUpLParam   | Function to create lparam required for 'postmessage' |

# Development Environment

Windows 10 64bit  
Autohotkey v1.1.30.01  
UniCode 32bit

# License

[MIT](./LICENSE)
