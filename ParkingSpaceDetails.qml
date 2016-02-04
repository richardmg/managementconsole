import QtQuick 2.0

ExpandableContainer {
    id: root
    visible: false

    function showModel(parkingSpaceModel)
    {
        print("show model", parkingSpaceModel.OnSiteId)
        text.psm = parkingSpaceModel
        expanded = true
    }

    Rectangle {
        id: details
        anchors.fill: parent
        border.color: app.colorDarkBg

        MouseArea {
            // Block mouseareas underneath
            anchors.fill: parent
        }

        IconButton {
            baseName: "Close"
            anchors.right: parent.right
            anchors.top: parent.top
            anchors.margins: 10
            onClicked: expanded = false
        }

        Text {
            id: headerText
            font: app.fontC.font
            text: "Report Details"
            x: 20
            y: 20
        }

        Text {
            id: text
            anchors.left: headerText.left
            y: 100
            property var psm: app.model.createEmptyParkingSpaceModel()
            text: "Parking space ID: " + psm.OnSiteId
                  + "<br>Status: " + psm.Status
                  + (psm.Status === "Free" ? "" :
                     "<br>Licence plate: " + psm.LicensePlateNumber
                     + "<br>Arrival: " + psm.Arrival
                     + "<br>Duration: " + psm.ParkingDuration)
        }
    }
}
