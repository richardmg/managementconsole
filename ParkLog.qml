import QtQuick 2.0
import QtQuick.Layouts 1.2

Item {
    id: parkLog

    property int parkId: -1

    property var _model: app.model.getParkingLotModel(parkId)

    Connections {
        target: app.model
        onParkModelUpdated: {
            if (parkId !== parkLog.parkId)
                return
            _model = app.model.getParkingLotModel(parkId)
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
                    text: parkLog._model.parkName
                    font: app.fontBig.font
                    Layout.fillWidth: true
                    readOnly: true
                    x: 10
                    y: 6
                }

                TextEdit {
                    id: headerFreeSpaces
                    text: "Free spaces: " + (parkLog._model.spaceCapacity - parkLog._model.spacesOccupied.length)
                    font: app.fontSmall.font
                    readOnly: true
                    x: 10
                    y: 6
                }

                Image {
                    source: app.mainView.selectedParkId === parkId ?
                                "qrc:/img/locationindicator_on.png" :
                                "qrc:/img/locationindicator_off.png"
                }
            }

            Rectangle {
                id: headerLine
                anchors.bottom: parent.bottom
                width: parent.width
                height: 1
                color: app.colorDarkLine
            }

            MouseArea {
                anchors.fill: parent
                onClicked: {
                    app.mainView.selectedParkId = parkLog._model.parkId
                    app.mainView.parkMap.centerOnAllParks()
                }
            }
        }

        ListView {
            id: listView
            anchors.top: listHeader.bottom
            anchors.bottom: parent.bottom
            width: parent.width
            clip: true
            model: parkLog._model.log

            delegate: Item {
                width: parent.width
                height: logMessage.paintedHeight + 20
                property var log: parkLog._model.log[index]

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
                        Rectangle {
                            width: logMessage.paintedHeight
                            height: width
                            radius: width
                            anchors.centerIn: parent
                            color: log.icon === "normal" ? "green" : "red"
                        }
                    }

                    TextEdit {
                        id: logMessage
                        text: log.message
                        font: app.fontNormal.font
                        readOnly: true
                        Layout.fillWidth: true
                    }

                    TextEdit {
                        id: logTime
                        text: log.time
                        font: app.fontNormal.font
                        readOnly: true
                    }
                }

                Rectangle {
                    id: underline
                    width: parent.width
                    height: 1
                    anchors.bottom: parent.bottom
                    color: app.colorLightLine
                }

            }
        }
    }
}
