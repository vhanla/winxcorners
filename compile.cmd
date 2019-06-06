@echo off

SET MSBUILD="C:\Program Files (x86)\Microsoft Visual Studio\2019\Community\MSBuild\Current\Bin\MSBuild.exe"
SET RSVARS="C:\Program Files (x86)\Embarcadero\Studio\20.0\bin\rsvars.bat"

SET PROJECT=WinXCorners.dproj

call %RSVARS%
%MSBUILD% %PROJECT% "/t:Clean,Make" "/p:config=Debug" "/verbosity:minimal"

if %ERRORLEVEL% NEQ 0 GOTO END

echo.
:END
