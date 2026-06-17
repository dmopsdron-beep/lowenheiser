#include "CustomAutoPilotPlugin.h"
#include "CustomLowenheiserComponent.h"
#include "QGCCorePlugin.h"
#include "Vehicle.h"

CustomAutoPilotPlugin::CustomAutoPilotPlugin(Vehicle *vehicle, QObject *parent)
    : APMAutoPilotPlugin(vehicle, parent)
{
    (void) connect(QGCCorePlugin::instance(), &QGCCorePlugin::showAdvancedUIChanged, this, &CustomAutoPilotPlugin::_advancedChanged);
}

void CustomAutoPilotPlugin::_advancedChanged(bool)
{
    _components.clear();
    emit vehicleComponentsChanged();
}

const QVariantList &CustomAutoPilotPlugin::vehicleComponents()
{
    if (!_components.isEmpty() || _incorrectParameterVersion) {
        return _components;
    }

    // Delega al plugin APM base para obtener los componentes estándar ArduPilot
    // (parámetros, radio, modos de vuelo, power, safety, etc.)
    _components = APMAutoPilotPlugin::vehicleComponents();

    // Añade la página propia Löweheiser (generador / 2T / EFI) si los parámetros
    // ya están disponibles. Sin parametersReady el base devuelve lista vacía.
    if (!_components.isEmpty()) {
        CustomLowenheiserComponent *lowenheiser = new CustomLowenheiserComponent(_vehicle, this);
        lowenheiser->setupTriggerSignals();
        _components.append(QVariant::fromValue(qobject_cast<VehicleComponent*>(lowenheiser)));
    }

    return _components;
}
