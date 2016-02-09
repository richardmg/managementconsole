import QtQuick 2.0

Item {
    width: childrenRect.width
    height: 100//childrenRect.height

    property Item contentView: null
    property alias text: headerText.text

    Text {
        id: headerText
        text: "Main View"
        font: app.fontA.font
        color: "white"
        anchors.verticalCenter: parent.verticalCenter
    }

    MouseArea {
        anchors.fill: parent
        onClicked: app.currentPage = contentView
        enabled: contentView !== null
    }
}
