@echo off
setlocal enabledelayedexpansion
cd /d "%~dp0"

if "%~1"=="" (
    echo Drag and drop a video file onto this script.
    pause
    exit /b
)

set "INPUT=%~1"

echo =============================================================
echo    MPEG2 VIDEO ENCODER ( Optimized for PowerPC G4 Systems)
echo =============================================================

echo Select Resolution:
echo --- 16:9 Aspect ---           --- 4:3 Aspect ---
echo 1). 1920x1080 (1080p)         7). 1440x1080
echo 2). 1600x900                  8). 1024x768 (XGA)
echo 3). 1366x768                  9). 800x600  (SVGA)
echo 4). 1280x720  (720p)          10). 640x480  (VGA)
echo 5). 1024x576                  11). 320x240  (QVGA)
echo 6). 854x480   (480p)          
echo.
echo 0). SOURCE RESOLUTION
echo.
set /p choice="Choice: "

:: Resolution Mapping
if "%choice%"=="1"  set "RW=1920" & set "RH=1080"
if "%choice%"=="2"  set "RW=1600" & set "RH=900"
if "%choice%"=="3"  set "RW=1366" & set "RH=768"
if "%choice%"=="4"  set "RW=1280" & set "RH=720"
if "%choice%"=="5"  set "RW=1024" & set "RH=576"
if "%choice%"=="6"  set "RW=854"  & set "RH=480"
if "%choice%"=="7"  set "RW=1440" & set "RH=1080"
if "%choice%"=="8"  set "RW=1024" & set "RH=768"
if "%choice%"=="9"  set "RW=800"  & set "RH=600"
if "%choice%"=="10" set "RW=640"  & set "RH=480"
if "%choice%"=="11" set "RW=320"  & set "RH=240"

:: Handle Source Resolution Option
if "%choice%"=="0" (
    for /f "tokens=1,2 delims=x" %%a in ('ffprobe -v error -select_streams v:0 -show_entries stream^=width^,height -of csv^=s^=x:p^=0 "%INPUT%"') do (
        set "RW=%%a"
        set "RH=%%b"
    )
    echo Detected Source: !RW!x!RH!
)

echo.
echo FRAMERATE:
echo 1). Source
echo 2). 23.97
echo 3). 25
echo 4). 29.97
echo 5). 30
echo 6). 60
set /p fps="Choice: "

set "FPS_CMD="
if "%fps%"=="1" (
    for /f "delims=" %%a in ('ffprobe -v error -select_streams v:0 -show_entries stream^=r_frame_rate -of default^=noprint_wrappers^=1:nokey^=1 "%INPUT%"') do set "FPS_RAW=%%a"
    for /f "delims=/ tokens=1,2" %%a in ("!FPS_RAW!") do (
        if "%%b" == "" (set /a "FPS_VAL=%%a") else (set /a "FPS_VAL=%%a/%%b")
    )
)
if "%fps%"=="2" set "FPS_CMD=-r 23.97 -fps_mode cfr" & set "FPS_VAL=24"
if "%fps%"=="3" set "FPS_CMD=-r 25 -fps_mode cfr"    & set "FPS_VAL=25"
if "%fps%"=="4" set "FPS_CMD=-r 29.97 -fps_mode cfr" & set "FPS_VAL=30"
if "%fps%"=="5" set "FPS_CMD=-r 30 -fps_mode cfr"    & set "FPS_VAL=30"
if "%fps%"=="6" set "FPS_CMD=-r 60 -fps_mode cfr"    & set "FPS_VAL=60"

echo.
echo QUALITY PRESET:
echo 1). Standard (0.3 BPP)
echo 2). Enhanced (0.4 BPP - High Detail)
set /p qual="Choice: "
set "BPP_VAL=30"
if "%qual%"=="2" set "BPP_VAL=40"

:: --- THE ALGORITHM ---
set /a "BITRATE_K=(%RW% * %RH% * %FPS_VAL% * %BPP_VAL%) / 100000"

:: Safety Cap at 25Mbps
if %BITRATE_K% GTR 25000 set "BITRATE_K=25000"

set /a "MAXRATE_K=(%BITRATE_K% * 12) / 10"
set /a "BUF_K=%BITRATE_K% * 2"

set "BITRATE=%BITRATE_K%k"
set "MAXRATE=%MAXRATE_K%k"
set "BUFSIZE=%BUF_K%k"

echo.
echo Target: %RW%x%RH% (%RH%p) @ %FPS_VAL%fps
echo Mode: %BITRATE% (BPP: 0.!BPP_VAL!)
echo.

set "OUTPUT=%~dpn1_G4_%RH%p.mov"
set "VF_FILTERS=hqdn3d=1.5:1.5:4:4,deblock=filter=strong:block=8,scale=%RW%:%RH%:flags=lanczos:force_original_aspect_ratio=decrease,pad=%RW%:%RH%:(ow-iw)/2:(oh-ih)/2,unsharp=5:5:0.8:5:5:0.0"

set "FF_GLOBAL=-hide_banner -loglevel repeat+level+info -err_detect ignore_err"

echo =============================================================
echo Running Pass 1...
ffmpeg %FF_GLOBAL% -y -i "%INPUT%" ^
-map 0:v:0 -c:v mpeg2video -pix_fmt yuv420p -g 12 -bf 2 -b:v %BITRATE% -maxrate %MAXRATE% -bufsize %BUFSIZE% -dc 10 ^
-vf "%VF_FILTERS%" %FPS_CMD% ^
-pass 1 -an -vtag m2v1 -f null NUL

echo.
echo Running Pass 2...
ffmpeg %FF_GLOBAL% -y -i "%INPUT%" ^
-map 0:v:0 -map 0:a:0 -c:v mpeg2video -pix_fmt yuv420p -g 12 -bf 2 -b:v %BITRATE% -maxrate %MAXRATE% -bufsize %BUFSIZE% -dc 10 ^
-vf "%VF_FILTERS%" %FPS_CMD% ^
-pass 2 -c:a pcm_s16le -ar 48000 -ac 2 ^
-f mov -vtag m2v1 -movflags +faststart ^
"%OUTPUT%"

if exist ffmpeg2pass-0.log del ffmpeg2pass-0.log
if exist ffmpeg2pass-0.log.mbtree del ffmpeg2pass-0.log.mbtree

echo.
echo Done. File: %OUTPUT%
pause