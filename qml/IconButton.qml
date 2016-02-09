import QtQuick 2.0

Image {
    id: root
    property string baseName: ""
    property bool selected: false
    signal clicked

    source: "qrc:/img/"
            + baseName + (mouse.pressed ? "_Pressed" : "")
            + (selected ? "_Focus" : "")
            + "_btn.png"

    MouseArea {
        id: mouse
        anchors.fill: parent
        onClicked: root.clicked()
    }
}
