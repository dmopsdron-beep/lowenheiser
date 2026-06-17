#pragma once

#include "APMAutoPilotPlugin.h"

class Vehicle;

class CustomAutoPilotPlugin : public APMAutoPilotPlugin
{
    Q_OBJECT

public:
    explicit CustomAutoPilotPlugin(Vehicle *vehicle, QObject *parent = nullptr);

    const QVariantList &vehicleComponents() final;

private slots:
    void _advancedChanged(bool advanced);

private:
    QVariantList _components;
};
