# Löweheiser GCS

Estación de control en tierra (Ground Control Station) basada en QGroundControl, personalizada para los sistemas generadores híbridos Löweheiser.

## Instalación (Windows)

1. Ve a la página de [Releases](https://github.com/dmopsdron-beep/lowenheiser/releases/latest)
2. Descarga el archivo `LowenheiserGCS-installer-AMD64.exe`
3. Ejecuta el instalador y sigue los pasos en pantalla
4. Conecta tu Pixhawk/Cube por USB y abre la aplicación

## Requisitos

- Windows 10 o superior (64 bits)
- Cable USB para conexión con el autopiloto (Pixhawk Cube 4 o compatible)
- ArduPilot 4.2.3 o superior con telemetría de generador (`GENERATOR_STATUS`) y EFI (`EFI_STATUS`) habilitada

## Panel de telemetría del generador

La aplicación añade un panel lateral con los datos en tiempo real del generador:

| Campo | Descripción |
|---|---|
| RPM | Régimen del motor (lectura EFI) |
| VOLTAJE | Voltaje del bus (12S) |
| CORRIENTE | Corriente de batería: positivo = cargando, negativo = descargando |
| POTENCIA | Potencia generada |
| CHT | Temperatura de culata |
| T° ADMS | Temperatura de admisión/ambiente |
| TPS | Posición de la mariposa (throttle) |
| RUNTIME | Tiempo de funcionamiento del motor |
| BATERÍA | Estado de carga estimado (%) |
| BALANCE | Potencia generada (W) |
| AUTONOMÍA | Minutos estimados de autonomía a la descarga actual |

## Soporte

Para incidencias o consultas sobre el panel de telemetría, abre un [issue en GitHub](https://github.com/dmopsdron-beep/lowenheiser/issues).
