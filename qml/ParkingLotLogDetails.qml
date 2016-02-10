import QtQuick 2.0
import QtCharts 2.0

import QtQuick 2.0
import QtQuick.Layouts 1.2

Rectangle {
    id: parkLog

    property int modelIndex: -1

    onVisibleChanged: {
        if (visible)
            updateGraph()
    }

    function updateGraph()
    {
        var free = app.model.currentModel.descriptions[modelIndex].numberFreeParkingSpaces
        var total = app.model.currentModel.descriptions[modelIndex].numberTotalParkingSpaces
        var occupied = total - free

        graphPoints.clear()

        // We only know what the current occupation rate is right now on the
        // parking lot, so to draw a graph, we need to traverse the log backwards
        // and calculate what the rate must have been at the time of each entry.
        var log = app.model.currentModel.logs[modelIndex]
        for (var i = log.length - 1; i >= 0; --i) {
            var entryTime = log.length - i - 1
            var occupationRate = occupied * 100 / total

            graphPoints.append(entryTime, occupationRate)

            var entry = log[i]
            if (entry.status === "Free") {
                // If this entry freed up a space, it means that the
                // occupation rate must have been bigger before.
                occupied++
            } else if (entry.status === "ToBeOccupied") {
                occupied--
            }
        }
    }

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

                ValueAxis {
                    id: axisX
                    min: 0
                    max: 60
                    tickCount: 8
                    labelFormat: "%i"
                }

                ValueAxis {
                    id: axisY
                    min: 0
                    max: 100
                    tickCount: 5
                    labelFormat: "%i\%"
                }

                LineSeries {
                    id: graphPoints
                    axisX: axisX
                    axisY: axisY
                }
            }
        }

        ParkingSpaceLogListModel {
            id: logModel
            modelIndex: parkLog.modelIndex
            onCountChanged: updateGraph()
        }

        ListView {
            id: listView
            anchors.top: chart.bottom
            anchors.bottom: parent.bottom
            width: parent.width
            clip: true
            model: logModel

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
                            source: status === "Malfunction" ? "qrc:/img/Alarm_icon.png" : "qrc:/img/Vehicle_icon.png"
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
                        text: app.model.dateToHms(new Date(timestamp), false)
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
