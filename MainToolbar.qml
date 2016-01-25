import QtQuick 2.0
import QtQuick.Controls 1.4

Rectangle {
    id: toolbar
    width: parent.width
    height: 90
    color: app.colorDarkBg

    property int spacing: 20

    function updateBg()
    {
        for (var i = 0; i < buttonRow.children.length; ++i) {
            var button = buttonRow.children[i]
            if (button.contentView === app.currentView) {
                selectedBg.x = toolbar.mapFromItem(button, 0, 0).x - toolbar.spacing
                selectedBg.width = button.width + (toolbar.spacing * 2)
            }
        }
        if (app.currentView === app.settingsView) {
            selectedBg.x = toolbar.mapFromItem(settingsButton, 0, 0).x - toolbar.spacing
            selectedBg.width = settingsButton.width + (toolbar.spacing * 2)
        }
    }

    Rectangle {
        height: 7
        width: parent.width
        anchors.bottom: parent.bottom
        color: app.colorSelectedBg
    }

    Rectangle {
        id: selectedBg
        width: mainViewButton.width + (toolbar.spacing * 2)
        height: parent.height
        color: app.colorSelectedBg
        x: toolbar.mapFromItem(mainViewButton, 0, 0).x - toolbar.spacing
        Behavior on x { NumberAnimation{ easing.type: Easing.OutCubic } }
        Behavior on width { NumberAnimation{ easing.type: Easing.OutCubic } }

        Component.onCompleted: updateBg()
        Connections {
            target: app
            onCurrentViewChanged: updateBg()
        }
    }

    Row {
        id: buttonRow
        x: app.contentLeftMargin + toolbar.spacing
        width: parent.width - x
        height: childrenRect.height
        anchors.verticalCenter: parent.verticalCenter
        spacing: 20

        MainToolbarButton {
            id: mainViewButton
            text: "Main View"
            contentView: app.mainView
        }
        MainToolbarButton {
            text: "|"
        }
        MainToolbarButton {
            id: park0Button
            text: "Augustinerhof Park"
            contentView: app.park0DetailsView
        }
        MainToolbarButton {
            text: "|"
        }
        MainToolbarButton {
            id: park1Button
            text: "Karlstadt Park"
            contentView: app.park1DetailsView
        }
    }

    MainToolbarButton {
        id: settingsButton
        text: "Settings"
        contentView: app.settingsView
        anchors.right: parent.right
    }

//    Button {
//        anchors.right: parent.right
//        text: "Settings"
//        onClicked: currentView = settingsView
//    }

//    Row {
//        Button {
//            text: "MainView"
//            onClicked: currentView = mainView
//        }
//    }
}

