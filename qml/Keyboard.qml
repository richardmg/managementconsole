import QtQuick 2.0
import QtQuick.Enterprise.VirtualKeyboard 1.3

InputPanel {
    id: inputPanel

    property Item containerParent: keyboardLoader

    z: 99
    y: containerParent.height
    anchors.left: containerParent.left
    anchors.right: containerParent.right

    signal aboutToOpen
    signal aboutToClose

    Behavior on y { NumberAnimation{ easing.type: Easing.InOutQuad } }

    Connections {
        target: Qt.inputMethod
        onVisibleChanged: {
            if (Qt.inputMethod.visible) {
                inputPanel.y = containerParent.height - inputPanel.height
                aboutToOpen()
            } else {
                inputPanel.y = containerParent.height
                aboutToClose()
            }
        }
    }
}
