#include "CustomLowenheiserComponent.h"

CustomLowenheiserComponent::CustomLowenheiserComponent(Vehicle *vehicle, AutoPilotPlugin *autopilot, QObject *parent)
    : VehicleComponent(vehicle, autopilot, AutoPilotPlugin::UnknownVehicleComponent, parent)
{

}
