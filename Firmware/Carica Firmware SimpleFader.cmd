@echo off
setlocal enabledelayedexpansion

echo Ricerca porte COM disponibili...
echo -------------------------------
echo.

set counter=0

for /f "skip=1 tokens=1,* delims= " %%A in ('wmic path Win32_SerialPort get DeviceID^,Name 2^>nul') do (
    if not "%%A"=="" (
        set /a counter+=1
        set "port[!counter!]=%%A"
        echo [ !counter! ] - %%A - %%B
    )
)

if %counter% equ 0 (
    echo Nessuna porta COM trovata!
    pause
    exit /b
)

echo.
:select
set /p "scelta=Seleziona il numero della porta (1-%counter%): "
if %scelta% gtr %counter% (
    echo Scelta non valida!
    pause
    exit /b
)
if %scelta% lss 1 (
    echo Scelta non valida!
    pause
    exit /b
)

set "selected_port=!port[%scelta%]!"

echo.
echo Eseguo il comando con porta %selected_port%
.\ArduinoSketchUploader.exe --file=.\SimpleFader-1.0.hex --port=%selected_port% --model=Micro

endlocal
