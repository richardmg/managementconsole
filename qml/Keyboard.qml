import QtQuick 2.0
import QtQuick.Enterprise.VirtualKeyboard 1.3

InputPanel {
    id: inputPanel
    z: 99

    y: parent.height

    anchors.left: parent.left
    anchors.right: parent.right

    signal aboutToOpen
    signal aboutToClose

    Behavior on y { NumberAnimation{ easing.type: Easing.InOutQuad } }

    Connections {
        target: Qt.inputMethod
        onVisibleChanged: {
            if (Qt.inputMethod.visible) {
                inputPanel.y = inputPanel.parent.height - inputPanel.height
                aboutToOpen()
            } else {
                inputPanel.y = inputPanel.parent.height
                aboutToClose()
            }
        }
    }
}
