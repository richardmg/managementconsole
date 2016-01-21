import QtQuick 2.0

Item {
    width: childrenRect.width
    height: childrenRect.height

    property Item contentView: null
    property alias text: headerText.text

    Text {
        id: headerText
        text: "Main View"
        font: app.fontBig.font
        color: "white"
    }

    MouseArea {
        anchors.fill: parent
        onClicked: app.currentView = contentView
        enabled: contentView !== null
    }
}
