#pragma once

#include "APMFirmwarePlugin.h"

class AutoPilotPlugin;
class Vehicle;

class CustomFirmwarePlugin : public APMFirmwarePlugin
{
    Q_OBJECT

public:
    CustomFirmwarePlugin();

    // FirmwarePlugin overrides
    AutoPilotPlugin *autopilotPlugin(Vehicle *vehicle) const final;
    void initializeVehicle(Vehicle *vehicle) final;
};
