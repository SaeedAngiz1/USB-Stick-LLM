# USB LLM Portable Kit

Run local LLMs from a USB flash drive on Windows with no installation, no internet, and no admin rights.

This project packages the workflow shown in the video into a reusable, GitHub-friendly starter kit with scripts, templates, and documentation.

## Features

- Portable offline AI setup for `llamafile` + GGUF models
- PowerShell scripts to validate system and USB readiness
- Launcher generator that creates per-model `.bat` files
- Optional GPU offload (`-ngl 999`) launcher mode
- Troubleshooting guide for common startup and performance issues

## Project Structure

- `scripts/check-prereqs.ps1` - checks Windows version, RAM, USB filesystem, and free space
- `scripts/setup-usb.ps1` - guided setup helper for preparing the USB folder layout
- `scripts/create-model-launcher.ps1` - creates model-specific `.bat` launchers
- `templates/run-model-template.bat` - base launcher template
- `docs/TROUBLESHOOTING.md` - fixes for common errors and slow performance
- `examples/models.example.json` - sample model inventory format

## Requirements

- Windows 10/11
- USB 3.0 flash drive (recommended 64GB+)
- `llamafile.exe` downloaded from Mozilla Ocho releases
- At least one `.gguf` model file

## Quick Start

1. Clone or download this repository to your computer.
2. Copy this folder to your USB drive.
3. Put `llamafile.exe` inside `\bin` on the USB.
4. Put your `.gguf` model files inside `\models`.
5. Run:

```powershell
powershell -ExecutionPolicy Bypass -File .\scripts\check-prereqs.ps1 -UsbRoot "E:\USB-LLM"
powershell -ExecutionPolicy Bypass -File .\scripts\setup-usb.ps1 -UsbRoot "E:\USB-LLM"
```

6. Generate a launcher:

```powershell
powershell -ExecutionPolicy Bypass -File .\scripts\create-model-launcher.ps1 `
  -UsbRoot "E:\USB-LLM" `
  -ModelFileName "Qwen3-8B-Q4_K_M.gguf" `
  -LauncherName "run-qwen3-8b" `
  -UseGpuOffload
```

7. Double-click the generated launcher in `\launchers`.
8. Chat in your browser once the local server starts.

## Suggested USB Layout

```text
USB-LLM/
  bin/
    llamafile.exe
  models/
    Qwen3-8B-Q4_K_M.gguf
  launchers/
    run-qwen3-8b.bat
  logs/
  scripts/
  templates/
  docs/
```

## Notes on Model Size

- Dense models: usually keep at or below ~14B for wider compatibility
- MoE models: larger parameter counts can still be viable depending on active experts and quantization
- Lower-bit quantized GGUF variants (for example Q4) usually load faster and use less memory

## Security and Privacy

- This stack runs locally and offline by default
- No prompts or outputs are sent to cloud services unless you explicitly add online integrations

## Publish to GitHub

```bash
git init
git add .
git commit -m "Initialize USB LLM portable kit"
git branch -M main
git remote add origin <your-repo-url>
git push -u origin main
```

## Credits

Workflow inspiration from the YouTube tutorial by BlueSpork:
https://www.youtube.com/watch?v=sYIajNkYZus
