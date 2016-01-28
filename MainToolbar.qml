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
        width: childrenRect.width
        height: childrenRect.height
        anchors.verticalCenter: parent.verticalCenter
        spacing: 20

        MainToolbarButton {
            id: mainViewButton
            text: "Main View"
            contentView: app.mainView
        }

        Repeater {
            model: app.model.current.descriptions.length
            width: childrenRect.width
            height: toolbar.height

            Row {
                width: childrenRect.width
                height: toolbar.height
                spacing: 20

                MainToolbarButton {
                    text: "|"
                }

                MainToolbarButton {
                    text: app.model.current.descriptions[index].LocationName
                    contentView: app.detailPages.itemAt(index)
                }
            }
        }
    }

    MainToolbarButton {
        id: settingsButton
        text: "Settings"
        contentView: app.settingsView
        anchors.right: parent.right
    }
}

