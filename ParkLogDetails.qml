import QtQuick 2.0
import QtCharts 2.0

import QtQuick 2.0
import QtQuick.Layouts 1.2

Rectangle {
    id: parkLog

    property int modelIndex: -1
    property var description: app.model.createEmptyDescription()
    property var log: app.model.createEmptyLog()

    Component.onCompleted: {
        description = app.model.currentModel.descriptions[modelIndex]
        updateLog(0, 0)
    }

    Connections {
        target: app.model

        onDescriptionUpdated: {
            if (modelIndex !== parkLog.modelIndex)
                return
            description = app.model.currentModel.descriptions[modelIndex]
        }

        onLogUpdated: {
            if (modelIndex !== parkLog.modelIndex)
                return
            updateLog(removed, appended)
        }
    }

    function updateLog(removed, appended)
    {
        log = app.model.currentModel.logs[modelIndex]
        if (!log)
            return

        // We get notified how many entries that were removed from the
        // beginning of the log, and how many that were added to the end.
        // If both are zero, it means the whole log was changed.
        if (removed === 0 && appended === 0) {
            listModel.clear()
            appended = log.length
        }

        // We reverse the log, since we want the
        // newest entries to show up on top
        if (removed > 0)
            listModel.remove(listModel.count - removed, removed)

        for (var i = log.length - appended; i < log.length; ++i) {
            var entry = log[i]
            entry.Message = app.model.createLogMessage(entry)
            listModel.insert(0, entry)
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

        ListModel {
            id: listModel
        }

        ListView {
            id: listView
            anchors.top: chart.bottom
            anchors.bottom: parent.bottom
            width: parent.width
            clip: true
            model: listModel

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
