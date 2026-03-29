# Troubleshooting

## `llamafile.exe` does not open

- Confirm the file exists at `bin/llamafile.exe`
- Try launching from PowerShell to see direct output
- Ensure your antivirus did not quarantine the executable

## Model fails to load

- Confirm model path and filename exactly match your `.gguf`
- Use smaller or more heavily quantized models if RAM is limited
- Close memory-heavy apps before launching

## Very slow generation speed

- Use a smaller model or lower-bit quantized variant
- Try USB 3.0/3.2 ports instead of USB 2.0
- Use launcher with GPU offload (`-ngl 999`) if supported

## Browser does not open automatically

- Manually open `http://127.0.0.1:8080` (common default)
- Check logs in `logs/*.log` for port or startup errors

## USB works on one PC but not another

- Verify target PC has enough RAM for the selected model
- Confirm USB is formatted in exFAT
- Some locked-down enterprise systems may block unknown executables
