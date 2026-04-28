@echo off
setlocal EnableDelayedExpansion

set "FFMPEG=ffmpeg"

echo.
echo ============================================
echo   Ultimate Video Retime / Re-Encode Tool
echo ============================================
echo.
echo Supported input types: .mp4 .avi .mov .m4v
echo Output type: .mp4
echo.
echo Retiming mode uses an AVIFRate-style approach:
echo it re-interprets the clip as a new input FPS instead of using setpts.
echo.

set /p RETIME="Do the clips need retiming? (Y/N): "

set "USE_RETIME=0"
if /I "%RETIME%"=="Y" set "USE_RETIME=1"

if "%USE_RETIME%"=="1" (
    echo.
    echo Example: 60 fps clip recorded at 0.1 timescale that should really play as 600 fps.
    set /p ASSUMEFPS="Enter retimed / interpreted input FPS: "
)

echo.
echo Starting processing...
echo.

for %%F in (*.mp4 *.MP4 *.avi *.AVI *.mov *.MOV *.m4v *.M4V) do (
    if exist "%%F" call :process_file "%%F"
)

echo.
echo ============================================
echo All supported files processed.
echo ============================================
pause
exit /b


:process_file
set "INPUT=%~1"
set "BASENAME=%~n1"

echo %BASENAME% | findstr /I /R "_encoded$" >nul
if not errorlevel 1 (
    echo Skipping already encoded file: %~1
    exit /b
)

set "OUTPUT=%BASENAME%_encoded.mp4"

echo --------------------------------------------
echo Processing: %~1
echo Output: !OUTPUT!
echo --------------------------------------------

if "%USE_RETIME%"=="1" (
    %FFMPEG% -y -fflags +genpts -r %ASSUMEFPS% -i %1 -an -c:v libx264 -preset fast -profile:v high -level:v 5.1 -pix_fmt yuv420p -b:v 300M -maxrate 300M -bufsize 600M -g 1 -bf 0 -x264-params "keyint=1:min-keyint=1:scenecut=0:bframes=0:ref=1:fullrange=on" -color_range pc -colorspace bt709 -color_trc bt709 -color_primaries bt709 -movflags +faststart -fps_mode passthrough "!OUTPUT!"
) else (
    %FFMPEG% -y -i %1 -an -c:v libx264 -preset fast -profile:v high -level:v 5.1 -pix_fmt yuv420p -b:v 300M -maxrate 300M -bufsize 600M -g 1 -bf 0 -x264-params "keyint=1:min-keyint=1:scenecut=0:bframes=0:ref=1:fullrange=on" -color_range pc -colorspace bt709 -color_trc bt709 -color_primaries bt709 -movflags +faststart "!OUTPUT!"
)

if errorlevel 1 (
    echo FAILED: %~1
) else (
    echo DONE: !OUTPUT!
)

echo.
exit /b