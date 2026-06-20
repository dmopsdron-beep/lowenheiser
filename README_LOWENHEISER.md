# Löweheiser GCS

A Ground Control Station based on QGroundControl, customized for Löweheiser hybrid generator systems.

## Installation (Windows)

1. Go to the [Releases page](https://github.com/dmopsdron-beep/lowenheiser/releases/latest)
2. Download `LowenheiserGCS-installer-AMD64.exe`
3. Run the installer and follow the on-screen steps
4. Connect your Pixhawk/Cube via USB and open the application

### About the Windows security warning

The first time you run the installer, Windows may show a blue **"Windows protected your PC"** screen (SmartScreen). This happens because the installer is not yet digitally signed with a paid certificate — it does **not** mean the file is unsafe.

To proceed:
1. Click **"More info"**
2. Click **"Run anyway"**

This is expected and normal for new, independently published software. We're working on adding a code signing certificate to remove this warning in a future release.

## Requirements

- Windows 10 or later (64-bit)
- USB cable to connect to the autopilot (Pixhawk Cube 4 or compatible)
- ArduPilot 4.2.3 or later, with generator telemetry (`GENERATOR_STATUS`) and EFI (`EFI_STATUS`) enabled

## Generator Telemetry Panel

The application adds a side panel showing live generator data:

| Field | Description |
|---|---|
| RPM | Engine speed (from EFI) |
| VOLTAGE | Bus voltage (12S) |
| CURRENT | Battery current: positive = charging, negative = discharging |
| POWER | Power generated |
| CHT | Cylinder head temperature |
| INTAKE TEMP | Intake / ambient temperature |
| TPS | Throttle position |
| RUNTIME | Engine running time |
| BATTERY | Estimated state of charge (%) |
| BALANCE | Power generated (W) |
| AUTONOMY | Estimated remaining runtime (minutes) at the current discharge rate |

## Support

For issues or questions about the telemetry panel, please open an [issue on GitHub](https://github.com/dmopsdron-beep/lowenheiser/issues).

## License

This project is free to download and use. See [LICENSE-GPL](LICENSE-GPL) for details. It is a fork of [QGroundControl](https://github.com/mavlink/qgroundcontrol), licensed under GPLv3.

## Terms of Use & Safety Notice

Please read [TERMS.md](TERMS.md) before using this software — it includes an important safety notice about relying on this tool to monitor generator/engine status.
