import QtQuick 2.0

Rectangle {
    id: root
    property bool expanded: false
    visible: false
    anchors.fill: parent
    color: "white"

    onExpandedChanged: {
        if (expanded) {
            fadeIn.start()
            visible = true
        } else {
            visible = false
        }
    }

    NumberAnimation {
        id: fadeIn
        target: root
        property: "opacity"
        easing.type: Easing.OutCubic
        duration: 500
        from: 0
        to: 1
    }

    MouseArea {
        // Block touch
        anchors.fill: parent
    }
}
