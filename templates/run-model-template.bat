@echo off
setlocal

REM Copy this file into /launchers and customize MODEL_FILE.
set "ROOT=%~dp0.."
set "LLAMAFILE=%ROOT%\bin\llamafile.exe"
set "MODEL_FILE=replace-with-your-model.gguf"
set "MODEL=%ROOT%\models\%MODEL_FILE%"
set "LOG=%ROOT%\logs\run-model.log"

if not exist "%LLAMAFILE%" (
  echo [ERROR] Missing "%LLAMAFILE%"
  pause
  exit /b 1
)

if not exist "%MODEL%" (
  echo [ERROR] Missing "%MODEL%"
  pause
  exit /b 1
)

echo Starting local LLM server...
"%LLAMAFILE%" --server --model "%MODEL%" 1>>"%LOG%" 2>>&1
