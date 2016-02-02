import QtQuick 2.0
import QtQuick.Layouts 1.2

Rectangle {
    id: parkLog

    property int modelIndex: -1

    property bool showMapIcon: true
    property bool showPercentage: true
    property bool showExpandIcon: false
    property bool showDate: false
    property ExpandableContainer expandableContainer

    property var description: app.model.createEmptyDescription()
    property var log: app.model.createEmptyLog()

    color: "white"

    Component.onCompleted: {
        description = app.model.current.descriptions[modelIndex]
        log = app.model.current.logs[modelIndex]
    }

    Connections {
        target: app.model

        onDescriptionUpdated: {
            if (modelIndex !== parkLog.modelIndex)
                return

            description = app.model.current.descriptions[modelIndex]
        }

        onLogUpdated: {
            if (modelIndex !== parkLog.modelIndex)
                return

            log = app.model.current.logs[modelIndex]

            // We get notified how many entries that were removed from the
            // beginning of the log, and how many that were added to the end.
            // If both are zero, it means the whole log was changed.
            if (removed == 0 && appended == 0) {
                listModel.clear()
                appended = log.length
            }

            // We reverse the log, since we want the
            // newest entries to show up on top
            if (removed > 0)
                listModel.remove(listModel.count - removed, removed)

            for (var i = log.length - appended; i < log.length; ++i) {
                var entry = log[i]
                listModel.insert(0, ({message:entry.message, time:entry.time, type:entry.type}))
            }
        }
    }

    Item {
        anchors.fill: parent
        anchors.margins: 5

        Item {
            id: listHeader
            width: parent.width - (x * 2)
            height: headerParkName.paintedHeight + 40

            RowLayout {
                anchors.fill: parent
                spacing: 10
                x: spacing

                TextEdit {
                    id: headerParkName
                    text: description.LocationName
                    font: app.fontBig.font
                    Layout.fillWidth: true
                    readOnly: true
                    color: app.colorDarkFg
                    x: 10
                    y: 6
                }

//                Text {
//                    font: app.fontBig.font
//                    color: app.colorDarkFg
//                    text: "|"
//                }

                PercentageText {
                    id: headerFreeSpaces
                    visible: showPercentage
                    freeSpaces: description.NumberFreeParkingSpaces
                    capacity: description.NumberTotalParkingSpaces
                    x: 10
                    y: 6
                }

                IconButton {
                    visible: showMapIcon
                    baseName: "Locate"
                    selected: app.mainView.selectedIndex === modelIndex
                    onClicked: {
                        app.mainView.selectedIndex = modelIndex
                        app.mainView.parkMap.centerOnPark(modelIndex)
                    }
                }

                IconButton {
                    visible: showExpandIcon
                    baseName: visible && expandableContainer.expanded ? "Contract" : "Expand"
                    onClicked: expandableContainer.toggle()
                }
            }

            Rectangle {
                id: headerLine
                anchors.bottom: parent.bottom
                width: parent.width
                height: 1
                color: app.colorDarkFg
            }

        }

        ListModel {
            id: listModel
        }

        ListView {
            id: listView
            anchors.top: listHeader.bottom
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
                            source: type === "alert" ? "qrc:/img/Alarm_icon.png" : "qrc:/img/Vehicle_icon.png"
                        }
                    }

                    TextEdit {
                        id: logMessage
                        text: message
                        font: app.fontNormal.font
                        readOnly: true
                        Layout.fillWidth: true
                        color: app.colorDarkFg
                    }

                    TextEdit {
                        id: logTime
                        text: time
                        font: app.fontNormal.font
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
