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

set /p RETIME="Do the clips need retiming? (Y/N): "

set "USE_RETIME=0"
if /I "%RETIME%"=="Y" set "USE_RETIME=1"

if "%USE_RETIME%"=="1" (
    echo.
    echo Example: 60 fps recorded at 0.1 timescale, restored to 600 fps = multiplier 10
    set /p MULT="Enter retime multiplier: "
)

echo.
set /p OUTFPS="Enter output FPS: "

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
    %FFMPEG% -y -i %1 -an -vf "setpts=(1/%MULT%)*PTS" -c:v libx264 -preset fast -profile:v high -level:v 5.1 -pix_fmt yuv420p -r %OUTFPS% -fps_mode cfr -b:v 300M -maxrate 300M -bufsize 600M -x264-params "keyint=12:min-keyint=12:scenecut=0:bframes=0:ref=1:fullrange=on" -color_range pc -colorspace bt709 -color_trc bt709 -color_primaries bt709 "!OUTPUT!"
) else (
    %FFMPEG% -y -i %1 -an -c:v libx264 -preset fast -profile:v high -level:v 5.1 -pix_fmt yuv420p -r %OUTFPS% -fps_mode cfr -b:v 300M -maxrate 300M -bufsize 600M -x264-params "keyint=12:min-keyint=12:scenecut=0:bframes=0:ref=1:fullrange=on" -color_range pc -colorspace bt709 -color_trc bt709 -color_primaries bt709 "!OUTPUT!"
)

if errorlevel 1 (
    echo FAILED: %~1
) else (
    echo DONE: !OUTPUT!
)

echo.
exit /b