# Ahk-inactive-library

This is a simple library for using inactive functions.
# Installation

  1. Download "lib\gdip.ahk" and "Inactive.ahk."
  2. Include "gdip.ahk" and "Inactive.ahk" in the script.
```autoit
#include gdip.ahk
#include inactive.ahk
```

# Supported functions
Table of supported functions.

### Capture
| Function | Description |
| ------ | ------ |
| CaptureforSave | Inactive Windows Program Capture for save |
| ScreenCapture | Inactive Windows Screen Capture |
| ScreenCaptureforSave  | Inactive Windows Screen Capture for save |
| Capture | Inactive Windows Program Capture |

### Control
| Function | Description |
| ------ | ------ |
| SimpleClick | Inactive Mouse Click(left) |
| SendStr | Inactive Send string |

### Windows
| Function | Description |
| ------ | ------ |
| InactiveImageSearch | Inactive Image Search |
| ImageSearchFromFile | ImageSearch From Image File |
| InactivePixelSearch | Inactive Pixel Search |
| HideWindow | Hide Window |
| ShowWindow | Show Window |

### Etc
| Function | Description |
| ------ | ------ |
| Init | Inactive ready Init Function |
| MakeKeyDownLParam | Function to create lparam required for 'postmessage' |
| MakeKeyUpLParam | Function to create lparam required for 'postmessage' |


## development environment
Windows 10 64bit,Autohotkey v1.1.30.01 (UniCode 32-bit)

License
----
MIT License

Copyright (c) 2019 Plorence

Permission is hereby granted, free of charge, to any person obtaining a copy
of this software and associated documentation files (the "Software"), to deal
in the Software without restriction, including without limitation the rights
to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the Software is
furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all
copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
SOFTWARE.

