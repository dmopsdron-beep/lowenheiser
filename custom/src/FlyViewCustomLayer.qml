import QtQuick
import QtQuick.Controls
import QtQuick.Layouts

import QGroundControl
import QGroundControl.Controls
import Custom.Widgets
import Custom.RpiPoller

Item {
    property var parentToolInsets
    property var totalToolInsets:   _totalToolInsets
    property var mapControl

    readonly property string noGPS:              qsTr("NO GPS")
    readonly property real   indicatorValueWidth: ScreenTools.defaultFontPixelWidth * 7

    property var    _activeVehicle:         QGroundControl.multiVehicleManager.activeVehicle
    property real   _indicatorDiameter:     ScreenTools.defaultFontPixelWidth * 18
    property real   _indicatorsHeight:      ScreenTools.defaultFontPixelHeight
    property var    _sepColor:              qgcPal.globalTheme === QGCPalette.Light ? Qt.rgba(0,0,0,0.5) : Qt.rgba(1,1,1,0.5)
    property color  _indicatorsColor:       qgcPal.text
    property bool   _isVehicleGps:          _activeVehicle ? _activeVehicle.gps.count.rawValue > 1 && _activeVehicle.gps.hdop.rawValue < 1.4 : false
    property string _altitude:              _activeVehicle ? (isNaN(_activeVehicle.altitudeRelative.value) ? "0.0" : _activeVehicle.altitudeRelative.value.toFixed(1)) + ' ' + _activeVehicle.altitudeRelative.units : "0.0"
    property string _distanceStr:           isNaN(_distance) ? "0" : _distance.toFixed(0) + ' ' + QGroundControl.unitsConversion.appSettingsHorizontalDistanceUnitsString
    property real   _heading:               _activeVehicle   ? _activeVehicle.heading.rawValue : 0
    property real   _distance:              _activeVehicle ? _activeVehicle.distanceToHome.rawValue : 0
    property string _messageTitle:          ""
    property string _messageText:           ""
    property real   _toolsMargin:           ScreenTools.defaultFontPixelWidth * 0.75

    // Generator / EFI values (safe defaults when no vehicle)
    property real _efiRpm:         _activeVehicle ? _activeVehicle.efi.rpm.rawValue                    : 0
    property real _busVoltage:     _activeVehicle ? _activeVehicle.generator.busVoltage.rawValue       : 0
    property real _loadCurrent:    _activeVehicle ? _activeVehicle.generator.loadCurrent.rawValue      : 0
    property real _batteryCurrent: _activeVehicle ? _activeVehicle.generator.batteryCurrent.rawValue   : 0
    property real _power:          _activeVehicle ? _activeVehicle.generator.powerGenerated.rawValue   : 0
    property real _cht:            _activeVehicle ? _activeVehicle.efi.cylinderTemp.rawValue           : 0
    property real _intakeTemp:     _activeVehicle ? _activeVehicle.efi.intakeTemp.rawValue             : 0
    property real _tps:            _activeVehicle ? _activeVehicle.efi.throttlePos.rawValue            : 0
    property real _runtime:        _activeVehicle ? _activeVehicle.generator.runtime.rawValue          : 0

    // Battery / autonomy
    // busVoltage can drop to 0 when generator is idle — hold the last valid reading for SOC
    property real _lastGoodVoltage: 48.0
    property real _effectiveVoltage: (_busVoltage > 42.0) ? _busVoltage : _lastGoodVoltage
    // 12S LiPo: 50.4V = 100%, 42.0V = 0%
    property real _batPercent:    Math.max(0, Math.min(100, (_effectiveVoltage - 42.0) / (50.4 - 42.0) * 100))
    property real _batCapacity:   6000  // mAh
    property real _batRemaining:  Math.max(0, _batCapacity * _batPercent / 100)
    // batteryCurrent (MAVLink bat_current): positive = charging battery, negative = discharging
    // This is the direct battery current, valid even when generator is idle
    property real _dischargeA:    (_batteryCurrent > 0.5) ? _batteryCurrent : 0
    property real _autonMin:      (_dischargeA > 0.5) ? (_batRemaining / (_dischargeA * 1000 / 60)) : 9999
    property real _balance:       Math.abs(_power)  // W produced by generator


    // Paleta Löweheiser (misma que el Tuner / CustomPlugin.cc) — centralizada
    readonly property color _panelBg:       Qt.rgba(0x16/255, 0x1b/255, 0x22/255, 0.90)
    readonly property color _panelHeaderBg: Qt.rgba(0x00/255, 0xa8/255, 0x78/255, 0.16)
    readonly property color _accent:        "#00a878"
    readonly property color _textPrimary:   "#e6edf3"
    readonly property color _textMuted:     "#8b949e"
    readonly property color _warn:          "#f39c12"
    readonly property color _alarm:         "#e74c3c"
    readonly property color _rowAlt:        Qt.rgba(1, 1, 1, 0.03)

    function secondsToHHMMSS(timeS) {
        var sec_num = parseInt(timeS, 10);
        var hours   = Math.floor(sec_num / 3600);
        var minutes = Math.floor((sec_num - (hours * 3600)) / 60);
        var seconds = sec_num - (hours * 3600) - (minutes * 60);
        if (hours   < 10) {hours   = "0"+hours;}
        if (minutes < 10) {minutes = "0"+minutes;}
        if (seconds < 10) {seconds = "0"+seconds;}
        return hours+':'+minutes+':'+seconds;
    }

    // Helper: color by threshold (green / orange / red)
    function valueColor(val, warnThreshold, alarmThreshold) {
        if (val >= alarmThreshold) return _alarm
        if (val >= warnThreshold)  return _warn
        return _accent
    }

    // Hold last busVoltage > 42V so SOC stays valid when generator is at idle
    Connections {
        target: _activeVehicle ? _activeVehicle.generator.busVoltage : null
        function onRawValueChanged() {
            if (_activeVehicle && _activeVehicle.generator.busVoltage.rawValue > 42.0)
                _lastGoodVoltage = _activeVehicle.generator.busVoltage.rawValue
        }
    }

    QGCToolInsets {
        id:                     _totalToolInsets
        leftEdgeTopInset:       parentToolInsets.leftEdgeTopInset
        leftEdgeCenterInset:    generatorPanel.leftEdgeCenterInset
        leftEdgeBottomInset:    parentToolInsets.leftEdgeBottomInset
        rightEdgeTopInset:      parentToolInsets.rightEdgeTopInset
        rightEdgeCenterInset:   parentToolInsets.rightEdgeCenterInset
        rightEdgeBottomInset:   parent.width - compassBackground.x
        topEdgeLeftInset:       parentToolInsets.topEdgeLeftInset
        topEdgeCenterInset:     compassArrowIndicator.y + compassArrowIndicator.height
        topEdgeRightInset:      parentToolInsets.topEdgeRightInset
        bottomEdgeLeftInset:    parentToolInsets.bottomEdgeLeftInset
        bottomEdgeCenterInset:  parentToolInsets.bottomEdgeCenterInset
        bottomEdgeRightInset:   parent.height - attitudeIndicator.y
    }

    //-------------------------------------------------------------------------
    //-- Generator / EFI telemetry panel (left side)
    Rectangle {
        id:                     generatorPanel
        visible:                _activeVehicle !== null && _activeVehicle !== undefined
        anchors.left:           parent.left
        anchors.leftMargin:     _toolsMargin
        anchors.top:            parent.top
        anchors.topMargin:      parentToolInsets.topEdgeLeftInset + _toolsMargin
        width:                  ScreenTools.defaultFontPixelWidth * 28
        height:                 panelColumn.implicitHeight
        color:                  _panelBg
        radius:                 ScreenTools.defaultFontPixelWidth * 0.5
        border.color:           _accent
        border.width:           1
        clip:                   true

        property real leftEdgeCenterInset: visible ? x + width + _toolsMargin : 0

        Column {
            id:                 panelColumn
            width:              parent.width
            spacing:            0

            // --- Cabecera principal con franja de acento ---
            Rectangle {
                width:  parent.width
                height: ScreenTools.defaultFontPixelHeight * 2.0
                color:  _panelHeaderBg

                Text {
                    anchors.centerIn: parent
                    text:           "GENERADOR"
                    color:          _accent
                    font.bold:      true
                    font.pointSize: ScreenTools.defaultFontPointSize * 1.15
                }
                // Indicador de conectividad RPi
                Rectangle {
                    anchors.right:          parent.right
                    anchors.rightMargin:    ScreenTools.defaultFontPixelWidth
                    anchors.verticalCenter: parent.verticalCenter
                    width:  ScreenTools.defaultFontPixelHeight * 0.6
                    height: width
                    radius: width / 2
                    color:  (_activeVehicle && (_busVoltage > 0 || _efiRpm > 0)) ? _accent : _alarm
                    border.width: 1
                    border.color: Qt.rgba(0, 0, 0, 0.4)
                    ToolTip.visible:  rpiDotArea.containsMouse
                    ToolTip.text:     RpiPoller.online ? qsTr("RPi conectada") : qsTr("RPi sin conexión")
                    MouseArea { id: rpiDotArea; anchors.fill: parent; hoverEnabled: true }
                }
                Rectangle {  // línea de acento bajo la cabecera
                    anchors.bottom: parent.bottom
                    width:  parent.width
                    height: 1
                    color:  _accent
                }
            }

            // --- Motor / Generador (panel unificado) ---
            GenRow { rowIndex: 0; label: qsTr("RPM");       value: _efiRpm.toFixed(0);        unit: "rpm"; vcolor: _accent }
            GenRow { rowIndex: 1; label: qsTr("VOLTAJE");   value: _busVoltage.toFixed(1);    unit: "V";   vcolor: (_busVoltage < 45 || _busVoltage >= 49.9) ? _alarm : (_busVoltage < 46 || _busVoltage >= 49.0) ? _warn : _accent }
            GenRow { rowIndex: 2; label: qsTr("CORRIENTE"); value: _batteryCurrent.toFixed(1); unit: "A";   vcolor: (_batteryCurrent > 5) ? _alarm : (_batteryCurrent > 1) ? _warn : _accent }
            GenRow { rowIndex: 3; label: qsTr("POTENCIA");  value: _power.toFixed(0);         unit: "W";   vcolor: _textPrimary }
            GenRow { rowIndex: 4; label: qsTr("CHT");       value: _cht.toFixed(0);           unit: "°C";  vcolor: valueColor(_cht, 180, 220) }
            GenRow { rowIndex: 5; label: qsTr("T° ADMS");   value: _intakeTemp.toFixed(0);    unit: "°C";  vcolor: valueColor(_intakeTemp, 50, 65) }
            GenRow { rowIndex: 6; label: qsTr("TPS");       value: _tps.toFixed(0);           unit: "%";   vcolor: _textPrimary }
            GenRow { rowIndex: 7; label: qsTr("RUNTIME");   value: secondsToHHMMSS(_runtime); unit: "";    vcolor: _textMuted }
            GenRow { rowIndex: 8; label: qsTr("BATERÍA");   value: _batPercent.toFixed(0);    unit: "%";   vcolor: (_batPercent < 15) ? _alarm : (_batPercent < 30) ? _warn : _accent }
            GenRow { rowIndex: 9; label: qsTr("BALANCE");   value: _balance.toFixed(0);       unit: "W";   vcolor: _accent }
            GenRow { rowIndex: 10; label: qsTr("AUTONOMÍA"); value: (_autonMin >= 9999) ? "---" : _autonMin.toFixed(1); unit: "min"; vcolor: (_autonMin < 2) ? _alarm : (_autonMin < 5) ? _warn : _accent }

            // --- Datos de la RPi (solo si online y con datos) ---
            Loader {
                active:     RpiPoller.online && Object.keys(RpiPoller.data).length > 0
                width:      parent.width
                sourceComponent: Component {
                    Column {
                        width:   panelColumn.width
                        spacing: 0

                        SectionHeader { title: "RPi" }

                        Repeater {
                            model: Object.keys(RpiPoller.data)
                            delegate: GenRow {
                                rowIndex: index
                                label:  modelData
                                value:  {
                                    var v = RpiPoller.data[modelData]
                                    return (typeof v === "number") ? v.toFixed(1) : String(v)
                                }
                                unit:   ""
                                vcolor: _textPrimary
                            }
                        }
                    }
                }
            }

            // Espaciador inferior
            Item { width: parent.width; height: ScreenTools.defaultFontPixelHeight * 0.4 }
        }
    }

    // Sub-cabecera de sección (EFI / RPi)
    component SectionHeader: Rectangle {
        property string title: ""
        width:  panelColumn.width
        height: ScreenTools.defaultFontPixelHeight * 1.7
        color:  _panelHeaderBg

        Text {
            anchors.centerIn: parent
            text:           parent.title
            color:          _accent
            font.bold:      true
            font.pointSize: ScreenTools.defaultFontPointSize * 1.05
        }
    }

    // Fila de dato: etiqueta · valor · unidad, con zebra striping
    component GenRow: Rectangle {
        property string label:    ""
        property string value:    "---"
        property string unit:     ""
        property color  vcolor:   _textPrimary
        property int    rowIndex: 0

        width:  panelColumn.width
        height: ScreenTools.defaultFontPixelHeight * 1.7
        color:  (rowIndex % 2 === 1) ? _rowAlt : "transparent"

        Row {
            anchors.fill:           parent
            anchors.leftMargin:     ScreenTools.defaultFontPixelWidth
            anchors.rightMargin:    ScreenTools.defaultFontPixelWidth
            spacing: 0

            Text {
                width:       (parent.width) * 0.50
                height:      parent.height
                verticalAlignment: Text.AlignVCenter
                text:        label
                color:       _textMuted
                font.pointSize: ScreenTools.defaultFontPointSize
                elide:       Text.ElideRight
            }
            Text {
                width:       (parent.width) * 0.34
                height:      parent.height
                verticalAlignment:   Text.AlignVCenter
                horizontalAlignment: Text.AlignRight
                text:        value
                color:       vcolor
                font.pointSize: ScreenTools.defaultFontPointSize
                font.bold:   true
            }
            Text {
                width:       (parent.width) * 0.16
                height:      parent.height
                verticalAlignment: Text.AlignVCenter
                text:        unit ? " " + unit : ""
                color:       _textMuted
                font.pointSize: ScreenTools.defaultFontPointSize * 0.85
            }
        }
    }

    //-------------------------------------------------------------------------
    //-- Heading Indicator
    Rectangle {
        id:                         compassBar
        height:                     ScreenTools.defaultFontPixelHeight * 1.5
        width:                      ScreenTools.defaultFontPixelWidth  * 50
        anchors.bottom:             parent.bottom
        anchors.bottomMargin:       _toolsMargin
        color:                      "#DEDEDE"
        radius:                     2
        clip:                       true
        anchors.horizontalCenter:   parent.horizontalCenter
        Repeater {
            model: 720
            QGCLabel {
                function _normalize(degrees) {
                    var a = degrees % 360
                    if (a < 0) a += 360
                    return a
                }
                property int _startAngle: modelData + 180 + _heading
                property int _angle: _normalize(_startAngle)
                anchors.verticalCenter: parent.verticalCenter
                x:              visible ? ((modelData * (compassBar.width / 360)) - (width * 0.5)) : 0
                visible:        _angle % 45 == 0
                color:          "#75505565"
                font.pointSize: ScreenTools.smallFontPointSize
                text: {
                    switch(_angle) {
                    case 0:     return "N"
                    case 45:    return "NE"
                    case 90:    return "E"
                    case 135:   return "SE"
                    case 180:   return "S"
                    case 225:   return "SW"
                    case 270:   return "W"
                    case 315:   return "NW"
                    }
                    return ""
                }
            }
        }
    }
    Rectangle {
        id:                         headingIndicator
        height:                     ScreenTools.defaultFontPixelHeight
        width:                      ScreenTools.defaultFontPixelWidth * 4
        color:                      qgcPal.windowShadeDark
        anchors.top:                compassBar.top
        anchors.topMargin:          -headingIndicator.height / 2
        anchors.horizontalCenter:   parent.horizontalCenter
        QGCLabel {
            text:                   _heading
            color:                  qgcPal.text
            font.pointSize:         ScreenTools.smallFontPointSize
            anchors.centerIn:       parent
        }
    }
    Image {
        id:                         compassArrowIndicator
        height:                     _indicatorsHeight
        width:                      height
        source:                     "/custom/img/compass_pointer.svg"
        fillMode:                   Image.PreserveAspectFit
        sourceSize.height:          height
        anchors.top:                compassBar.bottom
        anchors.topMargin:          -height / 2
        anchors.horizontalCenter:   parent.horizontalCenter
    }

    Rectangle {
        id:                     compassBackground
        anchors.bottom:         attitudeIndicator.bottom
        anchors.right:          attitudeIndicator.left
        anchors.rightMargin:    -attitudeIndicator.width / 2
        width:                  -anchors.rightMargin + compassBezel.width + (_toolsMargin * 2)
        height:                 attitudeIndicator.height * 0.75
        radius:                 2
        color:                  qgcPal.window

        Rectangle {
            id:                     compassBezel
            anchors.verticalCenter: parent.verticalCenter
            anchors.leftMargin:     _toolsMargin
            anchors.left:           parent.left
            width:                  height
            height:                 parent.height - (northLabelBackground.height / 2) - (headingLabelBackground.height / 2)
            radius:                 height / 2
            border.color:           qgcPal.text
            border.width:           1
            color:                  Qt.rgba(0,0,0,0)
        }

        Rectangle {
            id:                         northLabelBackground
            anchors.top:                compassBezel.top
            anchors.topMargin:          -height / 2
            anchors.horizontalCenter:   compassBezel.horizontalCenter
            width:                      northLabel.contentWidth * 1.5
            height:                     northLabel.contentHeight * 1.5
            radius:                     ScreenTools.defaultFontPixelWidth  * 0.25
            color:                      qgcPal.windowShade

            QGCLabel {
                id:                 northLabel
                anchors.centerIn:   parent
                text:               "N"
                color:              qgcPal.text
                font.pointSize:     ScreenTools.smallFontPointSize
            }
        }

        Image {
            id:                 headingNeedle
            anchors.centerIn:   compassBezel
            height:             compassBezel.height * 0.75
            width:              height
            source:             "/custom/img/compass_needle.svg"
            fillMode:           Image.PreserveAspectFit
            sourceSize.height:  height
            transform: [
                Rotation {
                    origin.x:   headingNeedle.width  / 2
                    origin.y:   headingNeedle.height / 2
                    angle:      _heading
                }]
        }

        Rectangle {
            id:                         headingLabelBackground
            anchors.top:                compassBezel.bottom
            anchors.topMargin:          -height / 2
            anchors.horizontalCenter:   compassBezel.horizontalCenter
            width:                      headingLabel.contentWidth * 1.5
            height:                     headingLabel.contentHeight * 1.5
            radius:                     ScreenTools.defaultFontPixelWidth  * 0.25
            color:                      qgcPal.windowShade

            QGCLabel {
                id:                 headingLabel
                anchors.centerIn:   parent
                text:               _heading
                color:              qgcPal.text
                font.pointSize:     ScreenTools.smallFontPointSize
            }
        }
    }

    Rectangle {
        id:                     attitudeIndicator
        anchors.bottomMargin:   _toolsMargin + parentToolInsets.bottomEdgeRightInset
        anchors.rightMargin:    _toolsMargin
        anchors.bottom:         parent.bottom
        anchors.right:          parent.right
        height:                 ScreenTools.defaultFontPixelHeight * 6
        width:                  height
        radius:                 height * 0.5
        color:                  qgcPal.windowShade

        CustomAttitudeWidget {
            size:               parent.height * 0.95
            vehicle:            _activeVehicle
            showHeading:        false
            anchors.centerIn:   parent
        }
    }
}
