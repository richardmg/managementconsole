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
            timeStamp.text = createTimeStampLabel()
        }
    }

    function createTimeStampLabel()
    {
        var date = app.model.currentModel.updateStamps[modelIndex]
        var formattedDate = app.model.dateToDmy(date)
        var formattedTime = app.model.dateToHms(date, false)
        return formattedDate + " | " + formattedTime
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
            text: createTimeStampLabel()
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
