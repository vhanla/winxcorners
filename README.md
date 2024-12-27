<p align="center"><img src="https://github.com/vhanla/winxcorners/blob/master/.github/cover.jpg?raw=true"/ width="100%">

# WinXcorners

<div align="center">
  <!-- license -->
  <a href="LICENSE">
    <img src="https://img.shields.io/github/license/vhanla/winxcorners.svg" alt="license">
  </a>
  <!-- downloads total-->
  <a href="https://github.com/vhanla/winxcorners/releases">
    <img src="https://img.shields.io/github/downloads/vhanla/winxcorners/total.svg" alt="total downloads">
  </a>
    <!-- downloads latest release -->
  <a href="https://github.com/vhanla/winxcorners/releases/latest">
    <img src="https://img.shields.io/github/downloads/vhanla/winxcorners/1.3.1/total.svg" alt="total latest downloads">
  </a>
  <!-- downloads latest release -->
  <a href="https://github.com/vhanla/winxcorners/releases/1.3.0">
    <img src="https://img.shields.io/github/downloads/vhanla/winxcorners/1.3.0/total.svg" alt="total latest downloads">
  </a>
  <!-- downloads latest most downloaded release -->
  <a href="https://github.com/vhanla/winxcorners/releases/1.2.1b">
    <img src="https://img.shields.io/github/downloads/vhanla/winxcorners/1.2.1b/total.svg" alt="total latest downloads">
  </a>
</div>

<div align="center">
  <h4>
    <a href="#winxcorners">
      WinXcorners
    </a>
    <span> | </span>
    <a href="#features">
      Features
    </a>
    <span> | </span>
    <a href="#howto">
      How To
    </a>
    <span> | </span>
    <a href="#download">
      Download
    </a>
    <span> | </span>
    <a href="#development">
      Development
    </a>
    <span> | </span>
    <a href="#contribution">
      Contribution
    </a>    
  </h4>
</div>

<!--div align="center">
  <sub>Translations:</sub>
  <a href="docs/i18n/spanish.md#readme">
    <span>:es:</span>
  </a>  
</div-->

## <a name="winxcorners"></a> WinXcorners
WinXcorners is a lightweight utility for Windows 10 and Windows 11 that enhances your desktop experience by allowing you to assign custom actions triggered when you hover your mouse cursor over the corners of your main monitor. Whether you're a power user, developer, or just someone who appreciates efficiency, WinXcorners provides a seamless way to streamline your workflow.

## <a name="features"></a> Key Features <a href="#winxcorners">⬆️</a>

1. **Corner Actions**: Choose from a variety of predefined actions for each corner:
    - [x] **Show All Windows**: Activate Windows' Task View `Win`+`Tab` to manage your open applications.
    - [x] **Show Desktop**: Quickly minimize all windows and reveal the desktop.
    - [x] **Start Screen Saver**: Trigger your screen saver for privacy or energy-saving purposes.
    - [x] **Turn Off Monitors**: Conveniently turn off your display when not in use.
    - [x] **Start Menu**: Invoke the Start Menu on hovering a corner.
    - [x] **Action Center**: Invoke the Action Center without hassle.
    - [x] **Hide Other Windows**: Just like `Win`+`Home`.
    - [x] **Custom**: Invoke other executables with command line params 
    - [x] 🆕 **Custom**: Execute custom hotkeys (sequence of key hold/release) *___v1.3.1___ (</a> How to <a href="#howtohotkey">⬇️</a>)

2. **Customization**: Tailor WinXcorners to your preferences:
    - Assign different actions to different corners.
    - Fine-tune hover sensitivity and delay settings.
    - Enable or disable automatic startup with Windows.

3. **System Tray Integration**: WinXcorners runs discreetly in the system tray, ensuring it doesn't clutter your desktop or Taskbar.

4. **Unobstrusive**: Its usage won't interfere with your common tasks, unless you decide to do so.
    - It won't trigger actions while dragging content with your mouse.
    - It won't trigger while using a **Full Screen application**, like games or media, for instance.
    - You can disable it temporarily right from the popup window with the switch toggle.

5. **Visible Countdown Counter**: Helps you, visually, to know if a corner action is about to be triggered (Advanced feature).

6. **Windows 10/11 Theme aware**: Partially supports Windows 10 and 11 dark and light theme, so it will look like part of your OS.
<h4 align="center">:crescent_moon:themes:high_brightness:</h4>


| Dark Theme Windows 11                                     | Light Theme Windows 11                                            |
|:-------------------------------------------------:|:-----------------------------------------------:|
| ![snap02](https://github.com/vhanla/winxcorners/blob/master/.github/snap02.jpg?raw=true)  | ![snap02b](https://github.com/vhanla/winxcorners/blob/master/.github/snap02b.jpg?raw=true)         |
| Dark Theme Windows 10                                     | Light Theme Windows 10 May 2019 Update onwards                                       |
| ![snp4](https://lh3.googleusercontent.com/-7ja-oixZ058/Vh-zjp8pRpI/AAAAAAAALQo/h4y4EPuoBbY/WinXCorners%25255B9%25255D%25255B1%25255D.jpg?imgmax=800)| ![imagen](https://user-images.githubusercontent.com/1015823/59126095-d2835e80-8929-11e9-9b89-6023164aaa8d.png)|

## Demo Video
<details>
<summary>
    <strong>🎞</strong> 
</summary>
<p>This demonstration would change on following versions.</p>
</details>
<p align="center"><video src="https://private-user-images.githubusercontent.com/1015823/339573857-e76a408c-db68-4b01-b5e7-6c991b23306c.mp4?jwt=eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJnaXRodWIuY29tIiwiYXVkIjoicmF3LmdpdGh1YnVzZXJjb250ZW50LmNvbSIsImtleSI6ImtleTUiLCJleHAiOjE3MTgzMTk0NzMsIm5iZiI6MTcxODMxOTE3MywicGF0aCI6Ii8xMDE1ODIzLzMzOTU3Mzg1Ny1lNzZhNDA4Yy1kYjY4LTRiMDEtYjVlNy02Yzk5MWIyMzMwNmMubXA0P1gtQW16LUFsZ29yaXRobT1BV1M0LUhNQUMtU0hBMjU2JlgtQW16LUNyZWRlbnRpYWw9QUtJQVZDT0RZTFNBNTNQUUs0WkElMkYyMDI0MDYxMyUyRnVzLWVhc3QtMSUyRnMzJTJGYXdzNF9yZXF1ZXN0JlgtQW16LURhdGU9MjAyNDA2MTNUMjI1MjUzWiZYLUFtei1FeHBpcmVzPTMwMCZYLUFtei1TaWduYXR1cmU9YjQ2ZWY2MTE0Yzk0YTkyMmI5ZGYzZTYwZjczMDEzOTVmOWJkZjE3MzEyNTBmZTA2MzViZTY5ODAzMzlmZWU5NSZYLUFtei1TaWduZWRIZWFkZXJzPWhvc3QmYWN0b3JfaWQ9MCZrZXlfaWQ9MCZyZXBvX2lkPTAifQ.a3lscQfOnOHr9iDYV4l8vKi8mBqrICrVh2B-d2u0yaM"/></p>

## <a name="download"></a> Installation (Portable) <a href="#winxcorners">⬆️</a>
1. Download the latest release from the GitHub repository.
2. Just unzip into a secure folder.
3. Run the single small executable, settings will be written/saved there.
4. 💡 It will run minimized and hidden in the **System Tray**

## Requirements

    — OS: Windows 10 x86/x64  | Windows 11 
    — HDD: 1.4 MB 
    — RAM: 9 MB



## Download and Installation *(?)*

![platform](https://img.shields.io/static/v1.svg?label=Platform&message=Win-32&style=for-the-badge)

| v1.3.1 (2024) | v1.3.0 (2024) | v1.2.1b (2019) |
|:---------------:|:---------------:|:-----------------:|
| ![](https://raw.githubusercontent.com/wiki/ryanoasis/nerd-fonts/screenshots/v1.0.x/windows-pass-sm.png)| ![](https://raw.githubusercontent.com/wiki/ryanoasis/nerd-fonts/screenshots/v1.0.x/windows-pass-sm.png)| ![](https://raw.githubusercontent.com/wiki/ryanoasis/nerd-fonts/screenshots/v1.0.x/windows-pass-sm.png)| 
| [![latest versionbeta](https://img.shields.io/github/downloads/vhanla/winxcorners/latest/winxcorners1.3.1.zip.svg)](https://github.com/vhanla/winxcorners/releases/download/1.3.1/winxcorners1.3.1.zip) | [![latest version](https://img.shields.io/github/downloads/vhanla/winxcorners/1.3.0/winxcorners130.zip.svg)](https://github.com/vhanla/winxcorners/releases/download/1.3.0/winxcorners130.zip) | [![latest version](https://img.shields.io/github/downloads/vhanla/winxcorners/1.2.1b/WinXCornersRegistryFix.zip.svg)](https://github.com/vhanla/winxcorners/releases/download/1.2.1b/WinXCornersRegistryFix.zip) |



## <a name="howto"></a> How To Use  <a href="#winxcorners">⬆️</a>
1. Launch WinXcorners popup window from the system tray icon.
2. Configure your preferred actions for each corner.
3. Hover your mouse cursor over a corner to trigger the assigned action.

## Advanced Usage
1. Right click the WinXcorners tray icon.
2. Select **Advanced** to open the more advanced options.

|  | |
|:-------------------------------------------------:|:-------------------------------------------------:|
|![snap02](https://github.com/vhanla/winxcorners/blob/master/.github/snap03.jpg?raw=true)|![snp5](https://lh3.googleusercontent.com/-NtNXrUcUUus/V6VlOWJMPeI/AAAAAAAALxM/hmfgAnoSvK8/image%25255B12%25255D.png?imgmax=800)|
|Advanced options v 1.3.0 | Advanced options v 1.2.1b *old snapshot* | 

3. There you can:
    - Set a global delay, so the action will trigger after some few seconds.
    - Set specific delay for each corner.
    - Enable or Disable the triggering of actions while on Full Screen applications, it can also be done via the right click on the system tray icon for WinXcorners.
4. Add up to 4 custom actions: Just write the commands and its respective arguments to launch, set hidden launch or visible. 

## <a name="howtohotkey"></a> Custom Hotkeys  <a href="#winxcorners">⬆️</a>
*___v1.3.1___

The hotkeys will be as follows:
`_control` or `control` or `control_` where `_` means hold or release (prefixed, appended) and without it, a full key press. This will be useful if you have a sequence of hotkeys to do, like `_control+k+control_+_control+_b` for VSCode for instance, that will do a `ctrl+k` then `ctrl+b` to toggle the sidebar.

There is more, it will check for windows on foreground/currently focused, or globally, whether by only its classname or with titlebar text too. The conditional pseudo script will be as follows:
```
! = follows sequence of hotkeys as mentioned above
# = follows [classname,title] there title is optional to match with current focused window
@ = follows [classname,title] there title is optional to match with any opened window
```

### Rule:

`#[classname,title]:(sequence of hotkeys)?(optional sequence of hotkeys in case condition is not met)`

For instance the following will check if current window is VSCode's and will invoke `ctrl+k` `ctrl+b` sequence of hotkeys, other wise if not on VSCode, just invoke the Start Menu.

`#[Chrome_WidgetWin_1]:(_control+k+control_+_control+_b)?(win)`

E.g. `#[conditional match]:(hotkey if match)?(hotkey if not)`

Another example for Windows 10: 

This will check if Alt+Tab's window is visible, if so, it will hide it, otherwise it will invoke it, as a faster alternative to Task View.
`#[MultitaskingViewFrame]:(escape)?(_control+_alt+tab)`

![snap03](https://github.com/vhanla/winxcorners/blob/master/.github/snap03b.jpg?raw=true)

## Notes
- WinXcorners works seamlessly on your primary monitor but secondary monitors haven't been tested throughfully, consider it partially supported.
- If you encounter issues with elevated privileges software, try restarting WinXcorners as an administrator specially if you use those kind of elevated privileged software most of the time, otherwise triggering won't work due to the nature of separate privileges.
- If you encounter other unknown issues, please fill a bug report at the GitHub issues page.

**Limitations**:

    Sometimes the application won't detect the screen edges if you are using (focused) an elevated privileged application. But you can always restart the application as administrator.

## <a name="development"></a> Development <a href="#winxcorners">⬆️</a>

Build with Delphi 2006 onwards, third party units are in thirdparty and all rights belong to each of them, they're open source too.

## <a name="contribution"></a> Contribution <a href="#winxcorners">⬆️</a>

You're welcome to PR your improvements.

MIT License

Copyright (c) 2015 Victor Alberto Gil (vhanla)

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
