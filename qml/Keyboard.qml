import QtQuick 2.0
import QtQuick.Enterprise.VirtualKeyboard 1.3

InputPanel {
    id: inputPanel
    z: 99

    y: parent.height
    anchors.left: parent.left
    anchors.right: parent.right

    states: State {
        name: "visible"
        when: Qt.inputMethod.visible

        PropertyChanges {
            target: inputPanel
            y: parent.height - inputPanel.height
        }
    }

    transitions: Transition {
        from: ""
        to: "visible"
        reversible: true

        ParallelAnimation {
            NumberAnimation {
                properties: "y"
                duration: 250
                easing.type: Easing.InOutQuad
            }
        }
    }
}
