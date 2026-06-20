# Changelog

All notable changes to Löweheiser GCS are documented in this file.

## [0.1.0] - 2026-06-20

### Added
- Initial public release of the Löweheiser GCS Windows installer
- Custom generator telemetry panel: RPM, voltage, current, power, cylinder head temperature, intake temperature, throttle position, runtime
- Battery state-of-charge estimation based on bus voltage (12S pack)
- Estimated autonomy (remaining runtime) based on real-time battery discharge current
- Alarm logic for low-RPM / no-generation-while-consuming conditions
- Custom Löweheiser branding (icon, color scheme)
- Raspberry Pi telemetry poller integration

### Known limitations
- Windows installer is not yet digitally signed (SmartScreen warning expected — see README)
- Battery capacity is currently fixed at 6000 mAh in the panel logic; not yet read from a vehicle parameter
