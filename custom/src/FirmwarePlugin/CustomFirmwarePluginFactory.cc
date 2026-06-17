#include "CustomFirmwarePluginFactory.h"
#include "CustomFirmwarePlugin.h"

CustomFirmwarePluginFactory CustomFirmwarePluginFactoryImp;

CustomFirmwarePluginFactory::CustomFirmwarePluginFactory()
    : _pluginInstance(nullptr)
{
}

QList<QGCMAVLink::FirmwareClass_t> CustomFirmwarePluginFactory::supportedFirmwareClasses() const
{
    return { QGCMAVLink::FirmwareClassArduPilot };
}

QList<QGCMAVLink::VehicleClass_t> CustomFirmwarePluginFactory::supportedVehicleClasses() const
{
    // Aceptar cualquier tipo — el generador puede estar en rover, copter, etc.
    return {
        QGCMAVLink::VehicleClassMultiRotor,
        QGCMAVLink::VehicleClassFixedWing,
        QGCMAVLink::VehicleClassRoverBoat,
        QGCMAVLink::VehicleClassGeneric,
    };
}

FirmwarePlugin *CustomFirmwarePluginFactory::firmwarePluginForAutopilot(MAV_AUTOPILOT autopilotType, MAV_TYPE /*vehicleType*/)
{
    if (autopilotType == MAV_AUTOPILOT_ARDUPILOTMEGA) {
        if (!_pluginInstance) {
            _pluginInstance = new CustomFirmwarePlugin;
        }
        return _pluginInstance;
    }

    return nullptr;
}
