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
    <img src="https://img.shields.io/github/downloads/vhanla/winxcorners/1.2.1b/total.svg" alt="total latest downloads">
  </a>
</div>

<div align="center">
  <h4>
    <a href="#">
      WinXcorners
    </a>
    <span> | </span>
    <a href="#">
      Features
    </a>
    <span> | </span>
    <a href="#">
      Downloads
    </a>
    <span> | </span>
    <a href="#">
      Development
    </a>
    <span> | </span>
    <a href="#">
      Contribution
    </a>    
  </h4>
</div>

<div align="center">
  <sub>Translations:</sub>
  <a href="docs/i18n/spanish.md#readme">
    <span>:es:</span>
  </a>  
</div>

## WinXcorners
WinXcorners is a lightweight utility for Windows 10 and Windows 11 that enhances your desktop experience by allowing you to assign custom actions triggered when you hover your mouse cursor over the corners of your main monitor. Whether you're a power user, developer, or just someone who appreciates efficiency, WinXcorners provides a seamless way to streamline your workflow.

## Key Features

1. **Corner Actions**: Choose from a variety of predefined actions for each corner:
- **Show All Windows**: Activate Windows' Task View `Win`+`Tab` to manage your open applications.
- **Show Desktop**: Quickly minimize all windows and reveal the desktop.
- **Start Screen Saver**: Trigger your screen saver for privacy or energy-saving purposes.
- **Turn Off Monitors**: Conveniently turn off your display when not in use.
- **Start Menu**: Invoke the Start Menu on hovering a corner.
- **Action Center**: Invoke the Action Center without hassle.
- **Hide Other Windows**: Just like `Win`+`Home`.

2. **Customization**: Tailor WinXcorners to your preferences:
- Assign different actions to different corners.
- Fine-tune hover sensitivity and delay settings.
- Enable or disable automatic startup with Windows.

3. **System Tray Integration**: WinXcorners runs discreetly in the system tray, ensuring it doesn't clutter your desktop or Taskbar.

4. **Unobstrusive**: Its usage won't interfere with your common tasks, unless you decide to do so.
- It won't trigger actions while dragging content with your mouse.
- It won't trigger while using a Full Screen application, like games or media, for instance.

5. **Visible Countdown Counter**: Helps you, visually, to know if a corner action is about to be triggered (Advanced feature).

## Installation (Portable)
1. Download the latest release from the GitHub repository.
2. Just unzip into a secure folder.
3. Run the single small executable, settings will be written/saved there.

## Usage
1. Launch WinXcorners popup window from the system tray icon.
2. Configure your preferred actions for each corner.
3. Hover your mouse cursor over a corner to trigger the assigned action.

## Advanced Usage
1. Right click the WinXcorners tray icon.
2. Select **Advanced** to open the more advanced options.
3. There you can:
- Set a global delay, so the action will trigger after some few seconds.
- Set specific delay for each corner.
- Enable or Disable the triggering of actions while on Full Screen applications, it can also be done via the right click on the system tray icon for WinXcorners.
4. Add up to 4 custom actions: Just write the commands and its respective arguments to launch, set hidden launch or visible. 

## Notes
- WinXcorners works seamlessly on your primary monitor but secondary monitors haven't been tested throughfully, consider it partially supported.
- If you encounter issues with elevated privileges software, try restarting WinXcorners as an administrator specially if you use those kind of elevated privileged software most of the time, otherwise triggering won't work due to the nature of separate privileges.
- If you encounter other unknown issues, please fill a bug report at the GitHub issues page.

## Requirements

    Windows 10 x86/x64  | Windows 11 


![snp2](https://lh3.googleusercontent.com/-vxIVdOymPXY/Vh-ze0Bn4bI/AAAAAAAALQY/zZ9TGvPVQpE/WinXCorners%25255B5%25255D.jpg?imgmax=800)

And when you are going to play video games, it includes a toggle option that will disable it temporarily.

![snp3](https://lh3.googleusercontent.com/-VrZ2zw8gfmo/Vh-zhP_UljI/AAAAAAAALQg/aqqvlB79QhQ/WinXCorners%25255B7%25255D%25255B1%25255D.jpg?imgmax=800)

The application runs in the System Tray, by right clicking you can enable it to run when Windows starts (logon).

![snp4](https://lh3.googleusercontent.com/-7ja-oixZ058/Vh-zjp8pRpI/AAAAAAAALQo/h4y4EPuoBbY/WinXCorners%25255B9%25255D%25255B1%25255D.jpg?imgmax=800)

Limitations:

    The application won't detect the screen edges if you are using (focused) an elevated privileged application. But you can always restart the application as administrator.
    If you have multiple monitors, it won't work in a secondary monitor.

[UPDATE August 2016]
WinXCorners 1.1.0.3 beta

This is new version which fixes some bugs and adds new features:

Changelog:

- Fixed trigger while holding down any mouse button  (left, middle or right button)

- Changed text rendering method to fix blurry text on some screen resolutions

- Fixed showing countdown while holding down mouse button

- Added a workaround to let show windows, show desktop and show action center be triggered while using a program with administrative rights

New features:

- Delayed hotcornes, you can set a delay time to trigger a hotcorner event

- Added notification center option

- Custom command for a hotcorner

- Visible delay countdown

- Trayicon icon updated, it turns grayish if you disable temporarily the tool

![snp5](https://lh3.googleusercontent.com/-NtNXrUcUUus/V6VlOWJMPeI/AAAAAAAALxM/hmfgAnoSvK8/image%25255B12%25255D.png?imgmax=800)
You can call this advanced options dialog from System Tray icon (right click –> Advanced)

WIP Support for light theme on Windows 10 May 2019 Update
![imagen](https://user-images.githubusercontent.com/1015823/59126095-d2835e80-8929-11e9-9b89-6023164aaa8d.png)

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