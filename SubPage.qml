import QtQuick 2.0

Rectangle {
    anchors.fill: parent
    default property alias data: placeHolder.data
    property string iconBaseName: "Close"
    signal close

    MouseArea {
        anchors.fill: parent
    }

    Rectangle {
        anchors.fill: parent
        anchors.leftMargin: 137
        anchors.rightMargin: 137
        border.color: app.colorDarkBg

        Item {
            id: placeHolder
            anchors.fill: parent
            anchors.margins: 10
        }

        IconButton {
            baseName: iconBaseName
            anchors.right: parent.right
            anchors.top: parent.top
            anchors.margins: 10
            onClicked: close()
        }
    }
}
