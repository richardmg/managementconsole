import QtQuick 2.0
import QtQuick.Controls 1.4

Rectangle {
    id: toolbar
    width: parent.width
    height: 90
    color: app.colorDarkBg

    property int spacing: 20

    Rectangle {
        id: toolbarUnderline
        height: 7
        width: parent.width
        anchors.bottom: parent.bottom
        color: app.colorSelectedBg
    }

    Rectangle {
        id: moveableButtonBackground
        width: mainViewButton.width + (toolbar.spacing * 2)
        height: parent.height
        color: app.colorSelectedBg
        x: toolbar.mapFromItem(mainViewButton, 0, 0).x - toolbar.spacing

        Behavior on x { NumberAnimation{ easing.type: Easing.OutCubic } }
        Behavior on width { NumberAnimation{ easing.type: Easing.OutCubic } }

        Component.onCompleted: updateBg()
        Connections {
            target: app
            onCurrentViewChanged: moveableButtonBackground.updateBg()
        }

        function updateBg()
        {
            if (app.currentView === app.mainView) {
                moveToItem(mainViewButton)
            } else if (app.currentView === app.settingsView) {
                moveToItem(settingsButton)
            } else {
                for (var modelIndex = 0; modelIndex < garageRepeater.model; ++modelIndex) {
                    var item = garageRepeater.itemAt(modelIndex)
                    if (item.button.contentView === app.currentView)
                        moveToItem(item.button)
                }
            }
        }

        function moveToItem(item)
        {
            x = toolbar.mapFromItem(item, 0, 0).x - toolbar.spacing
            width = item.width + (toolbar.spacing * 2)
        }
    }

    Row {
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
            id: garageRepeater
            model: app.model.current.descriptions.length
            width: childrenRect.width
            height: toolbar.height

            Row {
                width: childrenRect.width
                height: toolbar.height
                spacing: 20
                property alias button: button

                MainToolbarButton {
                    text: "|"
                }

                MainToolbarButton {
                    id: button
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

