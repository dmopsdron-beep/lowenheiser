#pragma once

#include "VehicleComponent.h"

/// Vehicle Setup page for Löweheiser generator / 2T engine parameters.
/// Groups the relevant ArduPilot GEN_*, ICE_*, EFI_* and RPM_* parameters
/// in a single page. Only parameters present in the connected firmware are shown.
class CustomLowenheiserComponent : public VehicleComponent
{
    Q_OBJECT

public:
    explicit CustomLowenheiserComponent(Vehicle *vehicle, AutoPilotPlugin *autopilot, QObject *parent = nullptr);

    QStringList setupCompleteChangedTriggerList() const final { return QStringList(); }

    QString name() const final { return _name; }
    QString description() const final { return tr("Ajustes del generador Löweheiser (motor 2T, alternador y EFI)."); }
    QString iconResource() const final { return QStringLiteral("/res/gear-white.svg"); }
    bool requiresSetup() const final { return false; }
    bool setupComplete() const final { return true; }
    QUrl setupSource() const final { return QUrl::fromUserInput(QStringLiteral("qrc:/qml/QGroundControl/AutoPilotPlugins/Custom/CustomLowenheiserComponent.qml")); }
    QUrl summaryQmlSource() const final { return QUrl(); }

private:
    const QString _name = tr("Löweheiser");
};
