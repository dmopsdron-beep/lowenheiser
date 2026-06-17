#include "CustomFirmwarePlugin.h"
#include "CustomAutoPilotPlugin.h"
#include "Vehicle.h"

#include <mavlink.h>

CustomFirmwarePlugin::CustomFirmwarePlugin()
{
}

AutoPilotPlugin *CustomFirmwarePlugin::autopilotPlugin(Vehicle *vehicle) const
{
    return new CustomAutoPilotPlugin(vehicle, vehicle);
}

void CustomFirmwarePlugin::initializeVehicle(Vehicle *vehicle)
{
    // Llama primero al base APM para que haga su inicialización normal
    APMFirmwarePlugin::initializeVehicle(vehicle);

    if (vehicle->isOfflineEditingVehicle()) {
        return;
    }

    // Solicitar GENERATOR_STATUS cada 500 ms en el canal TELEM1
    // ArduPilot no emite estos mensajes por defecto — hay que pedirlos explícitamente
    // con MAV_CMD_SET_MESSAGE_INTERVAL (cmd 511, param1=msg_id, param2=intervalo_us)
    vehicle->sendMavCommand(
        MAV_COMP_ID_AUTOPILOT1,
        MAV_CMD_SET_MESSAGE_INTERVAL,
        false,                          // showError: silencioso, firmware viejo puede no soportarlo
        MAVLINK_MSG_ID_GENERATOR_STATUS,
        500000                          // 500 ms en microsegundos
    );

    // Solicitar EFI_STATUS cada 500 ms
    vehicle->sendMavCommand(
        MAV_COMP_ID_AUTOPILOT1,
        MAV_CMD_SET_MESSAGE_INTERVAL,
        false,
        MAVLINK_MSG_ID_EFI_STATUS,
        500000
    );
}
