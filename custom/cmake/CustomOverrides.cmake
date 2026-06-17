# ============================================================================
# Custom Build Configuration Overrides
# Template for customizing QGroundControl branding and feature set
# ============================================================================

# ----------------------------------------------------------------------------
# Application Branding
# ----------------------------------------------------------------------------
# QGC_APP_NAME es el nombre del target CMake y del ejecutable — debe ser ASCII sin espacios
set(QGC_APP_NAME "LowenheiserGCS" CACHE STRING "App Name" FORCE)
set(QGC_APP_DESCRIPTION "Löweheiser Ground Control Station" CACHE STRING "Application description" FORCE)
set(QGC_ORG_NAME "Löweheiser" CACHE STRING "Organization name" FORCE)
set(QGC_ORG_DOMAIN "lowenheiser.com" CACHE STRING "Organization domain" FORCE)
set(QGC_PACKAGE_NAME "com.lowenheiser.gcs" CACHE STRING "Package identifier" FORCE)

# Ampliar rango Qt aceptado para Qt 6.11.x (build-config.json dice 6.10.3 pero 6.11.1 es compatible)
set(QGC_QT_MAXIMUM_VERSION "6.11.99" CACHE STRING "Maximum supported Qt version" FORCE)

# ----------------------------------------------------------------------------
# Custom Icons and Graphics
# ----------------------------------------------------------------------------

# macOS Icon
if(EXISTS "${CMAKE_SOURCE_DIR}/${QGC_CUSTOM_DIR}/res/icons/custom_qgroundcontrol.icns")
    set(QGC_MACOS_ICON_PATH "${CMAKE_SOURCE_DIR}/${QGC_CUSTOM_DIR}/res/icons/custom_qgroundcontrol.icns" CACHE FILEPATH "MacOS Icon Path" FORCE)
endif()

# Linux AppImage Icon
if(EXISTS "${CMAKE_SOURCE_DIR}/${QGC_CUSTOM_DIR}/res/icons/custom_qgroundcontrol.svg")
    set(QGC_APPIMAGE_ICON_SCALABLE_PATH "${CMAKE_SOURCE_DIR}/${QGC_CUSTOM_DIR}/res/icons/custom_qgroundcontrol.svg" CACHE FILEPATH "AppImage Icon SVG Path" FORCE)
endif()

# Windows Installer Header
if(EXISTS "${CMAKE_SOURCE_DIR}/${QGC_CUSTOM_DIR}/deploy/windows/installheader.bmp")
    set(QGC_WINDOWS_INSTALL_HEADER_PATH "${CMAKE_SOURCE_DIR}/${QGC_CUSTOM_DIR}/deploy/windows/installheader.bmp" CACHE FILEPATH "Windows Install Header Path" FORCE)
endif()

# Windows Application Icon
if(EXISTS "${CMAKE_SOURCE_DIR}/${QGC_CUSTOM_DIR}/deploy/windows/WindowsQGC.ico")
    set(QGC_WINDOWS_ICON_PATH "${CMAKE_SOURCE_DIR}/${QGC_CUSTOM_DIR}/deploy/windows/WindowsQGC.ico" CACHE FILEPATH "Windows Icon Path" FORCE)
endif()

# ----------------------------------------------------------------------------
# Feature Set Customization
# ----------------------------------------------------------------------------

# Löweheiser GCS: ArduPilot/APM habilitado (Pixhawk Cube 4 + ArduPilot)
# PX4 plugin factory deshabilitada — no se usa en este ecosistema
set(QGC_DISABLE_PX4_PLUGIN_FACTORY ON CACHE BOOL "Disable PX4 Plugin Factory" FORCE)

# GStreamer deshabilitado en Fase 0 — no necesario para telemetría de generador
set(QGC_ENABLE_GST_VIDEOSTREAMING OFF CACHE BOOL "Disable GStreamer video backend" FORCE)
set(QGC_ENABLE_QT_VIDEOSTREAMING OFF CACHE BOOL "Disable Qt video backend" FORCE)
set(QGC_ENABLE_UVC OFF CACHE BOOL "Disable UVC" FORCE)
