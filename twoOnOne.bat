@ECHO OFF
setlocal enabledelayedexpansion
CLS
REM This script takes two one-page PDF files, cuts them to 50% height and 
REM joins them into one page.
REM It uses ImageMagick, so take care it is present and provide its path.
REM The result file will be named like the current date in the format YYYY-MM-DD-##.pdf, 
REM where ## is as low as possible without overwriting anything.
REM Note: Since ImageMagick is used, the resulting PDF will be rasterized.
REM Before using, rename twoOnOne_configuration-TEMPLATE.bat into twoOnOne_configuration.bat
REM and fill its values.
REM Note 2: Uses wmic.

REM Load Configuration
CALL twoOnOne_configuration.bat

REM Check Arguments
CALL :CheckArguments %*
IF "%ERRORLEVEL%"=="1" (
	CALL :PrintUsage
	PAUSE
	GOTO :EOF
)
CALL :ProcessFiles %*
CALL :StoreResult
CALL :StartViewer

REM Run finished
PAUSE
endlocal
GOTO :EOF

REM Check the arguments if they exist and if they are existing files.
REM Call with %*
REM Returns 0 if they exist and point to existing files,
REM 1 otherwise.
:CheckArguments
IF [%1] == [] EXIT /B 1
IF [%2] == [] EXIT /B 1
IF NOT EXIST %1 (
	ECHO %1 does not exist.
	EXIT /B 1
)
IF NOT EXIST %2 (
	ECHO %2 does not exist.
	EXIT /B 1
)
EXIT /B 0

REM Print the usage.
REM Call without any parameters
REM Returns nothing.
:PrintUsage
ECHO Please provide two PDF files to cut and merge!
ECHO You can specify their path names at the CLI or drag/drop them onto a link to this script.
EXIT /B

REM Cuts the files into halfs and stores them combined
REM Call with %*
REM Returns nothing.
:ProcessFiles
%imConvert% -units PixelsPerInch -density %imResolution% %1 -crop 100%%x50%%+0+0 +repage %tempImagePath%image1.pdf
%imConvert% -units PixelsPerInch -density %imResolution% %2 -crop 100%%x50%%+0+0 +repage %tempImagePath%image2.pdf
%imConvert% -units PixelsPerInch -density %imResolution% -append %tempImagePath%image1.pdf %tempImagePath%image2.pdf %tempImagePath%image3.pdf
EXIT /B

REM Determine the file name and copy the generated file into that file
REM Call without any parameters
REM Returns nothing.
:StoreResult
REM The following piece of code comes from http://stackoverflow.com/questions/3472631/how-do-i-get-the-day-month-and-year-from-a-windows-cmd-exe-script
REM By 
for /F "skip=1 delims=" %%F in ('
    wmic PATH Win32_LocalTime GET Day^,Month^,Year /FORMAT:TABLE
') do (
    for /F "tokens=1-3" %%L in ("%%F") do (
        set CurrDay=0%%L
        set CurrMonth=0%%M
        set CurrYear=%%N
    )
)
set CurrDay=%CurrDay:~-2%
set CurrMonth=%CurrMonth:~-2%
REM Foreign code END
SET counter=0
:countUp
SET /A counter=%counter%+1
SET counterString=0%counter%
SET counterString=%counterString:~-2%
SET fileName=%CurrYear%-%CurrMonth%-%CurrDay%-%counterString%
SET outputFilePath=%outputPath%%fileName%.pdf
IF EXIST %outputFilePath% GOTO countUp
ECHO Saving to %outputFilePath%...
COPY %tempImagePath%image3.pdf %outputFilePath%
EXIT /B

REM Start the output file
REM Call without any parameters
REM Returns nothing.
:StartViewer
START %outputFilePath%
EXIT /B