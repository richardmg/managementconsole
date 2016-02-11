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

    Flickable {
        id: flickable
        anchors.fill: parent
        contentWidth: row.width + settingsButton.width + 100

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
                onCurrentPageChanged: moveableButtonBackground.updateBg()
            }

            function updateBg()
            {
                if (app.currentPage === app.mainViewPage) {
                    moveToItem(mainViewButton)
                } else if (app.currentPage === app.settingsView) {
                    moveToItem(settingsButton)
                } else {
                    for (var modelIndex = 0; modelIndex < garageRepeater.model; ++modelIndex) {
                        var item = garageRepeater.itemAt(modelIndex)
                        if (item.button.contentView === app.currentPage)
                            moveToItem(item.button)
                    }
                }
            }

            function moveToItem(item)
            {
                x = parent.mapFromItem(item, 0, 0).x - toolbar.spacing
                width = item.width + (toolbar.spacing * 2)
            }
        }

        Row {
            id: row
            width: childrenRect.width
            height: childrenRect.height
            spacing: 20

            Item {
                width: app.contentLeftMargin
                height: parent.height
            }

            MainToolbarButton {
                id: mainViewButton
                text: "Main View"
                contentView: app.mainViewPage
            }

            Repeater {
                id: garageRepeater
                model: app.model.currentModel.descriptions.length
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
                        text: app.model.currentModel.descriptions[index].locationName
                        contentView: app.detailPages.itemAt(index)
                    }
                }
            }
        }

        Image {
            id: settingsButton
            source: "qrc:/img/settings_icon.png"
            anchors.verticalCenter: parent.verticalCenter
            height: toolbar.height
            fillMode: Image.PreserveAspectFit
            x: Math.max(flickable.width, flickable.contentWidth) - width - 20
            onXChanged: moveableButtonBackground.updateBg()

            MouseArea {
                width: parent.width
                height: toolbar.height
                onClicked: app.currentPage = app.settingsView
            }
        }
    }
}

