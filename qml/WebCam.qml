import QtQuick 2.0

Rectangle {
    id: root
    color: "white"
    implicitWidth: webcam.width
    implicitHeight: webcam.height

    property int modelIndex: -1
    property ExpandableContainer expandableContainer

    Connections {
        target: app.model

        onDescriptionUpdated: {
            if (modelIndex !== root.modelIndex)
                return
            webcam.source = app.model.currentModel.descriptions[modelIndex].webcamUrl
        }

        onUpdateTimeUpdated: {
            if (modelIndex !== root.modelIndex)
                return
//            updateTime = app.model.currentModel.updateStamps[modelIndex]
        }
    }

    Flickable {
        anchors.fill: parent
        contentHeight: webcam.height
        clip: true

        Image {
            id: webcam
            fillMode: Image.PreserveAspectFit
            width: parent.width
            source: app.model.currentModel.descriptions[modelIndex].webcamUrl
        }

        Rectangle {
            id: timeStampBg
            x: 10
            y: 10
            width: timeStamp.paintedWidth + 20
            height: timeStamp.paintedHeight + 20
            color: "black"
            opacity: 0.6
        }
        Text {
            id: timeStamp
            anchors.centerIn: timeStampBg
            font: app.fontH.font
            text: "27.02.16 | 11.56"
            color: "white"
        }
    }

    IconButton {
        baseName: expandableContainer.expanded ? "Contract" : "Expand"
        anchors.top: parent.top
        anchors.right: parent.right
        anchors.rightMargin: 5
        anchors.topMargin: 12
        onClicked: expandableContainer.toggle()
    }
}
