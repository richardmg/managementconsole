import QtQuick 2.0
import QtQuick.Controls 1.4
import QtQuick.Layouts 1.2
import QtWebSockets 1.0

TopView {
    id: topo

    //=====================================
    // Sync data source with model
    //=====================================

    ExclusiveGroup {
        id: dataSourceGroup
        onCurrentChanged: {
            if (current === remoteSource)
                app.model.dataSource = app.model.kRemoteDataSource
            else if (current === offlineSource)
                app.model.dataSource = app.model.kFakeDataSource
            else
                app.model.dataSource = app.model.kNoDataSource
            app.mainView.parkMap.centerOnAllParks()
        }
    }

    Connections {
        target: app.model
        onDataSourceChanged: {
            if (app.model.dataSource === app.model.kRemoteDataSource)
                dataSourceGroup.current = remoteSource
            else if (app.model.dataSource === app.model.kFakeDataSource)
                dataSourceGroup.current = offlineSource
            else
                dataSourceGroup.current = noDataSource
        }
    }

    Component.onCompleted: {
        app.model.webSocket.url = remoteConnectionUrl.text
    }

    //=====================================

    GridLayout {
        columns: 1

        GridLayout {
            RadioButton {
                id: remoteSource
                text: "Remote server:"
                checked: app.model.dataSource === app.model.kFakeRemoteSource
                exclusiveGroup: dataSourceGroup
            }

            TextField {
                id: remoteConnectionUrl
                Layout.preferredWidth: 300
                text: "wss://echo.websocket.org"
                onAccepted: app.model.webSocket.url = text
            }

            Rectangle {
                id: remoteConnectionStatusIndicator
                width: 10
                height: width
                radius: width
                color: "gray"

                Connections {
                    target: app.model.webSocket
                    onStatusChanged: {
                        if (status === WebSocket.Connecting)
                            remoteConnectionStatusIndicator.color = "yellow"
                        else if (status === WebSocket.Open)
                            remoteConnectionStatusIndicator.color = "green"
                        else if (status === WebSocket.Closed)
                            remoteConnectionStatusIndicator.color = "gray"
                        else if (status === WebSocket.Error)
                            remoteConnectionStatusIndicator.color = "red"
                    }
                }
            }
        }

        RadioButton {
            id: offlineSource
            text: "Use offline data"
            checked: app.model.dataSource === app.model.kFakeDataSource
            exclusiveGroup: dataSourceGroup
        }

        RadioButton {
            id: noDataSource
            text: "Use no data"
            checked: app.model.dataSource === app.model.kNoDataSource
            exclusiveGroup: dataSourceGroup
        }

        Rectangle { width: 10; height: 10; color:"transparent"; }

        CheckBox {
            text: "Use offline map"
            onCheckedChanged: {
                app.model.dataSource = app.model.kFakeDataSource
                app.mainView.parkMap.centerOnAllParks()
            }
        }

    }


}

