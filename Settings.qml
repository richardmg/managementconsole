import QtQuick 2.0
import QtQuick.Controls 1.4
import QtQuick.Layouts 1.2

TopView {
    id: top

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

    //=====================================

    GridLayout {
        columns: 2

        RadioButton {
            id: remoteSource
            text: "URL"
            checked: app.model.dataSource === app.model.kFakeRemoteSource
            exclusiveGroup: dataSourceGroup
        }
        TextField {
            placeholderText: "url"
        }

        RadioButton {
            id: offlineSource
            text: "Use offline data"
            Layout.columnSpan: 2
            checked: app.model.dataSource === app.model.kFakeDataSource
            exclusiveGroup: dataSourceGroup
        }

        RadioButton {
            id: noDataSource
            text: "Use no data"
            checked: app.model.dataSource === app.model.kNoDataSource
            exclusiveGroup: dataSourceGroup
            Layout.columnSpan: 2
        }

        Rectangle { width: 10; height: 10; color:"transparent"; Layout.columnSpan: 2 }

        CheckBox {
            text: "Use offline map"
            Layout.rowSpan: 2
            onCheckedChanged: {
                app.model.dataSource = app.model.kFakeDataSource
                app.mainView.parkMap.centerOnAllParks()
            }
        }

    }


}

