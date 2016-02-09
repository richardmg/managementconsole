import QtQuick 2.0
import QtCharts 2.0

import QtQuick 2.0
import QtQuick.Layouts 1.2

Rectangle {
    id: parkLog

    property int modelIndex: -1

    Item {
        anchors.fill: parent
        anchors.leftMargin: 10
        anchors.rightMargin: 10

        Item {
            id: listHeader
            width: parent.width - (x * 2)
            height: headerDate.paintedHeight + 40

            RowLayout {
                anchors.fill: parent
                spacing: 10
                x: spacing

                Text {
                    id: headerDate
                    text: "< 26.02.2016 >"
                    font: app.fontC.font
                    Layout.fillWidth: true
                    elide: Text.ElideRight
                    color: app.colorDarkFg
                    x: 10
                    y: 6
                }
            }
        }

        Rectangle {
            id: chart
            anchors.top: listHeader.bottom
            width: parent.width
            height: 200
            border.color: app.colorDarkBg

            ChartView {
                anchors.fill: parent
                antialiasing: true
                legend.visible: false

                LineSeries {
                    name: "SplineSeries"
                    XYPoint { x: 0; y: 0.0 }
                    XYPoint { x: 1.1; y: 3.2 }
                    XYPoint { x: 1.9; y: 2.4 }
                    XYPoint { x: 2.1; y: 2.1 }
                    XYPoint { x: 2.9; y: 2.6 }
                    XYPoint { x: 3.4; y: 2.3 }
                    XYPoint { x: 4.1; y: 3.1 }
                }
            }
        }

        ListView {
            id: listView
            anchors.top: chart.bottom
            anchors.bottom: parent.bottom
            width: parent.width
            clip: true
            model: ParkingSpaceLogListModel { modelIndex: parkLog.modelIndex }

            delegate: Item {
                width: parent.width
                height: logMessage.paintedHeight + 20

                RowLayout {
                    id: modelContent
                    anchors.verticalCenter: parent.verticalCenter
                    spacing: 10
                    x: spacing
                    width: parent.width - (x * 2)
                    height: parent.height

                    Item {
                        id: logIcon
                        width: 40
                        height: 20
                        Image {
                            anchors.centerIn: parent
                            source: Status === "Malfunction" ? "qrc:/img/Alarm_icon.png" : "qrc:/img/Vehicle_icon.png"
                        }
                    }

                    TextEdit {
                        id: logMessage
                        text: Message
                        font: app.fontB.font
                        readOnly: true
                        Layout.fillWidth: true
                        color: app.colorDarkFg
                    }

                    TextEdit {
                        id: logTime
                        text: app.model.dateToHms(new Date(Timestamp), false)
                        font: app.fontB.font
                        readOnly: true
                        color: app.colorDarkFg
                    }
                }

                Rectangle {
                    id: underline
                    width: parent.width
                    height: 1
                    anchors.bottom: parent.bottom
                    color: app.colorLightFg
                }

            }
        }
    }
}
