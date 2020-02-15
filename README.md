# Ahk-inactive-library

This is a simple library for using inactive functions.

# Support version
- ### Unicode32  
- ### Unicode64  
- ### ANSI32
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

| Function             | Description                               |
| -------------------- | ----------------------------------------- |
| CaptureforSave       | Inactive Windows Program Capture for save |
| Capture              | Inactive Windows Program Capture          |

### Control

| Function    | Description                |
| ----------- | -------------------------- |
| SimpleClick | Inactive Mouse Click(left) |
| SendStr     | Inactive Send string       |

### Windows

| Function            | Description                 |
| ------------------- | --------------------------- |
| InactiveImageSearch | Inactive Image Search       |
| ImageSearchFromFile | ImageSearch From Image File |
| InactivePixelSearch | Inactive Pixel Search       |
| MultipleInactivePixelSearch | Multiple Inactive Pixel Search |
| HideWindow          | Hide Window                 |
| ShowWindow          | Show Window                 |

### Etc

| Function          | Description                                          |
| ----------------- | ---------------------------------------------------- |
| MakeKeyDownLParam | Function to create lparam required for 'postmessage' |
| MakeKeyUpLParam   | Function to create lparam required for 'postmessage' |

## development environment

Windows 10 64bit,Autohotkey v1.1.30.01 (UniCode 32-bit)

# License

[MIT](./LICENSE)
