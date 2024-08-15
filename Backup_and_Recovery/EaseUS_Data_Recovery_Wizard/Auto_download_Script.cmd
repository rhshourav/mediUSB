@echo off
setlocal enabledelayedexpansion

:: Base URL and file prefix
set base_url=https://raw.githubusercontent.com/rhshourav/mediUSB/main/Backup_and_Recovery/EaseUS_Data_Recovery_Wizard/EaseUS_Data_Recovery_Wizard.part
set file_prefix=EaseUS_Data_Recovery_Wizard.part

:: Number of parts
set /a start=1
set /a end=9

:: Loop to download each part
for /l %%i in (%start%, 1, %end%) do (
    :: Format part number with leading zeros (if needed)
    set part_number=%%i
    if %%i lss 10 (set part_number=0%%i)
    if %%i geq 10 if %%i lss 18 (set part_number=%%i)

    :: Determine file extension based on part number
    if %%i==1 (
        set file_extension=.exe
    ) else (
        set file_extension=.rar
    )

    :: Form the full URL and output file name
    set full_url=%base_url%!part_number!!file_extension!
    set output_file=%file_prefix%!part_number!!file_extension!

    :: Download the file
    echo Downloading !full_url! to !output_file!
    curl !full_url! --output !output_file!

    :: Check if the download was successful
    if errorlevel 1 (
        echo Failed to download !full_url!
        exit /b 1
    )
)

echo All parts downloaded successfully!
endlocal
pause
