import QtQuick 2.0
import QtQuick.Controls 1.4
import QtQuick.Layouts 1.2
import QtWebSockets 1.0

import "qrc:/components/qml"

TopLevelPage {
    id: root

    Connections {
        target: app.keyboard
        onAboutToOpen: {
            if (!root.visible)
                return
            flickable.contentY = flickable.mapFromItem(app.activeFocusItem, 0, 0).y
        }
        onAboutToClose: {
            if (!root.visible)
                return
            flickable.contentY = 0
            app.activeFocusItem.focus = false
        }
    }

    Flickable {
        id: flickable
        anchors.fill: parent
        contentHeight: settingsGrid.height + (app.keyboard ? app.keyboard.height : 0)
        clip: true

        GridLayout {
            id: settingsGrid
            columns: 2

            Text {
                id: remoteSource
                text: "Remote server:"
            }

            TextField {
                id: remoteConnectionUrl
                Layout.preferredWidth: 600
                text: app.model.xmlHttpRequestModel.baseUrl
                onAccepted: {
                    app.model.currentModel = app.model.xmlHttpRequestModel
                    app.model.xmlHttpRequestModel.baseUrl = text
                }

                Rectangle {
                    id: remoteConnectionStatusIndicator
                    width: 10
                    height: width
                    radius: width
                    color: "gray"
                    anchors.verticalCenter: parent.verticalCenter
                    anchors.right: parent.right
                    anchors.rightMargin: 5

                    Connections {
                        target: app.model.xmlHttpRequestModel
                        onStatusChanged: {
                            var status = app.model.xmlHttpRequestModel.status
                            if (status === WebSocket.Connecting)
                                remoteConnectionStatusIndicator.color = "yellow"
                            else if (status === WebSocket.Open)
                                remoteConnectionStatusIndicator.color = app.colorGreenBg
                            else if (status === WebSocket.Closed)
                                remoteConnectionStatusIndicator.color = "gray"
                            else if (status === WebSocket.Error)
                                remoteConnectionStatusIndicator.color = "red"
                        }
                    }
                }
            }

            Text {
                text: "Location name filter:"
            }

            TextField {
                id: locationNameFilter
                Layout.preferredWidth: 600
                text: app.model.locationNameFilter
                placeholderText: "Regular expression"
                onAccepted: {
                    app.model.locationNameFilter = text
                    app.model.currentModel.reload()
                    focus = false
                }
            }

            Text {
                text: "Server update interval:"
            }

            TextField {
                id: pollInterval
                Layout.preferredWidth: 600
                text: app.model.pollIntervalMs / 1000
                placeholderText: "seconds"
                onAccepted: {
                    var number = Number(text)
                    if (number < 10)
                        number = 10
                    text = number
                    app.model.pollIntervalMs = Number(number * 1000)
                    app.model.currentModel.update()
                    focus = false
                }
            }

            Rectangle {
                width: 10
                height: 10
                color:"transparent";
                Layout.columnSpan: 2
            }

            CheckBox {
                id: offlineSource
                text: "Use offline data"
                checked: app.model.currentModel === app.model.fakeModel
                Layout.columnSpan: 2
                onCheckedChanged: {
                    app.model.currentModel = checked ? app.model.fakeModel : app.model.xmlHttpRequestModel
                    app.model.currentModel.reload()
                    app.mainViewPage.parkMap.centerOnAllParks()
                }
            }

            CheckBox {
                text: "Use offline map"
                Layout.columnSpan: 2
                onCheckedChanged: {
                }
            }

            Rectangle {
                width: 10
                height: 10
                color:"transparent";
                Layout.columnSpan: 2
            }

            Button {
                text: "Request update"
                onClicked: {
                    app.model.currentModel.update()
                }
            }

            Button {
                text: "Reset configuration"
                onClicked: {
                    app.model.xmlHttpRequestModel.baseUrl = app.model.xmlHttpRequestModel.originalBaseUrl
                    locationNameFilter.text = app.model.defaultLocationNameFilter
                    app.model.locationNameFilter = locationNameFilter.text
                    app.model.pollIntervalMs = app.model.defaultPollIntervalMs
                    pollInterval.text = app.model.pollIntervalMs / 1000
                    app.model.currentModel.reload()
                }
            }
        }
    }


}

