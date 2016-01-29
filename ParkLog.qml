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
    property bool _pendingLogUpdate: false

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

            if (listView.moving)
                _pendingLogUpdate = true
            else
                updateLog()
        }
    }

    function updateLog()
    {
        _pendingLogUpdate = false
        log = app.model.current.logs[modelIndex]
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
                        app.mainView.parkMap.centerOnAllParks()
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

        ListView {
            id: listView
            anchors.top: listHeader.bottom
            anchors.bottom: parent.bottom
            width: parent.width
            clip: true
            model: log.length

            onMovingChanged: {
                if (!moving && _pendingLogUpdate)
                    updateLog()
            }

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
                            source: log[index].type === "alert" ? "qrc:/img/Alarm_icon.png" : "qrc:/img/Vehicle_icon.png"
                        }
                    }

                    TextEdit {
                        id: logMessage
                        text: log[index].message
                        font: app.fontNormal.font
                        readOnly: true
                        Layout.fillWidth: true
                        color: app.colorDarkFg
                    }

                    TextEdit {
                        id: logTime
                        text: log[index].time
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
