import QtQuick
import QtQuick.Controls
import QtQuick.Layouts

import QGroundControl
import QGroundControl.Controls
import QGroundControl.FactControls
import QGroundControl.ScreenTools

SetupPage {
    id:             lowenheiserPage
    pageComponent:  pageComponent

    Component {
        id: pageComponent

        Column {
            id:         mainColumn
            width:      availableWidth
            spacing:    ScreenTools.defaultFontPixelHeight

            FactPanelController { id: controller }

            // Grupos de parámetros. Cada fila se muestra solo si el parámetro
            // existe en el firmware conectado (reportMissing = false).
            property var _groups: [
                {
                    title: qsTr("Generador"),
                    params: [ "GEN_TYPE", "GEN_IDLE_TH", "GEN_RUN_TEMP",
                              "GEN_MAINT_TIME", "GEN_MAX_RPM", "GEN_MIN_RPM" ]
                },
                {
                    title: qsTr("Motor 2T (ICE)"),
                    params: [ "ICE_ENABLE", "ICE_START_CHAN", "ICE_STARTER_TIME",
                              "ICE_START_DELAY", "ICE_RPM_THRESH", "ICE_IDLE_RPM",
                              "ICE_IDLE_DB", "ICE_IDLE_SLEW", "ICE_RPM_CHAN",
                              "ICE_PWM_IGN_ON", "ICE_PWM_IGN_OFF",
                              "ICE_PWM_STRT_ON", "ICE_PWM_STRT_OFF" ]
                },
                {
                    title: qsTr("Inyección (EFI)"),
                    params: [ "EFI_TYPE", "EFI_COEF1", "EFI_COEF2", "EFI_FUEL_DENS" ]
                },
                {
                    title: qsTr("Sensor RPM"),
                    params: [ "RPM1_TYPE", "RPM1_SCALING", "RPM1_PIN",
                              "RPM2_TYPE", "RPM2_SCALING" ]
                }
            ]

            Repeater {
                model: mainColumn._groups

                QGCGroupBox {
                    required property var modelData
                    width:   mainColumn.width
                    title:   modelData.title
                    // Ocultar el grupo entero si ninguno de sus parámetros existe
                    visible: {
                        for (var i = 0; i < modelData.params.length; i++) {
                            if (controller.parameterExists(-1, modelData.params[i])) return true
                        }
                        return false
                    }

                    GridLayout {
                        columns:        2
                        columnSpacing:  ScreenTools.defaultFontPixelWidth * 2
                        rowSpacing:     ScreenTools.defaultFontPixelHeight * 0.5

                        Repeater {
                            model: modelData.params

                            // Cada elemento crea una etiqueta + campo si el parámetro existe
                            Item {
                                required property string modelData
                                property var _fact: controller.getParameterFact(-1, modelData, false)
                                visible:                _fact !== null
                                Layout.columnSpan:      2
                                Layout.fillWidth:       true
                                implicitHeight:         visible ? rowLayout.implicitHeight : 0

                                RowLayout {
                                    id:         rowLayout
                                    width:      parent.width
                                    spacing:    ScreenTools.defaultFontPixelWidth * 2

                                    QGCLabel {
                                        text:                   modelData
                                        Layout.preferredWidth:  ScreenTools.defaultFontPixelWidth * 22
                                    }
                                    FactTextField {
                                        fact:                   parent.parent._fact
                                        visible:                parent.parent._fact !== null
                                        Layout.preferredWidth:  ScreenTools.defaultFontPixelWidth * 18
                                    }
                                }
                            }
                        }
                    }
                }
            }

            QGCLabel {
                width:          mainColumn.width
                wrapMode:       Text.WordWrap
                font.pointSize: ScreenTools.smallFontPointSize
                color:          qgcPal.colorGrey
                text:           qsTr("Solo se muestran los parámetros presentes en el firmware conectado. " +
                                     "Los cambios se escriben directamente en la controladora ArduPilot.")
            }
        }
    }
}
