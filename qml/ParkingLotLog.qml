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
    property var updateTime: new Date()

    color: "white"

    Component.onCompleted: {
        description = app.model.currentModel.descriptions[modelIndex]
    }

    Connections {
        target: app.model

        onDescriptionUpdated: {
            if (modelIndex !== parkLog.modelIndex)
                return
            description = app.model.currentModel.descriptions[modelIndex]
        }

        onUpdateTimeUpdated: {
            if (modelIndex !== parkLog.modelIndex)
                return
            updateTime = app.model.currentModel.updateStamps[modelIndex]
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

                Text {
                    id: headerParkName
                    text: description.locationName
                    font: app.fontC.font
                    Layout.fillWidth: true
                    elide: Text.ElideRight
                    color: app.colorDarkFg
                    x: 10
                    y: 6
                }

                Text {
                    font: app.fontC.font
                    color: app.colorDarkFg
                    text: "|"
                }

                PercentageText {
                    id: headerFreeSpaces
                    visible: showPercentage
                    freeSpaces: description.numberFreeParkingSpaces
                    capacity: description.numberTotalParkingSpaces
                    font: app.fontC.font
                    x: 10
                    y: 6
                }

                Text {
                    id: date
                    visible: showDate
                    font: app.fontE.font
                    x: 10
                    anchors.bottom: headerParkName.bottom
                    text: updateTime.getDay() + "." + updateTime.getMonth() + "." + updateTime.getFullYear()
                }

                IconButton {
                    visible: showMapIcon
                    baseName: "Locate"
                    selected: app.mainViewPage.selectedIndex === modelIndex
                    onClicked: {
                        app.mainViewPage.selectedIndex = modelIndex
                        app.mainViewPage.parkMap.centerOnPark(modelIndex)
                    }
                }

                IconButton {
                    visible: showExpandIcon
                    baseName: "Expand"
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
