import QtQuick 2.0
import QtQuick.Layouts 1.2

ExpandableContainer {
    id: root
    visible: false

    property var parkingSpaceModel: app.model.createEmptyParkingSpaceModel(0, 0)
    property var arrivalDate: new Date()
    property var isFree: parkingSpaceModel.Status === "Free"

    function showModel(parkingSpaceModel)
    {
        root.parkingSpaceModel = parkingSpaceModel
        arrivalDate = parkingSpaceModel.Arrival ? new Date(parkingSpaceModel.Arrival) : 0
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
            font: app.fontG.font
            color: app.colorDarkBg
            text: "Report Details"
            x: 20
            y: 20
        }

        Flickable {
            anchors.top: headerText.bottom
            anchors.bottom: parent.bottom
            anchors.left: parent.left
            anchors.right: parent.right
            anchors.leftMargin: 10
            anchors.rightMargin: 10
            anchors.topMargin: 20
            anchors.bottomMargin: 20
            contentWidth: width
            contentHeight: grid.height
            clip: true

            GridLayout {
                y: 50
                anchors.left: parent.left
                anchors.right: parent.right
                anchors.leftMargin: 10
                anchors.rightMargin: 10
                height: childrenRect.height
                columnSpacing: 20
                columns: 2

                Text {
                    font: app.fontF.font
                    color: app.colorDarkBg
                    text: "Parking space ID:"
                }
                Text {
                    font: app.fontF.font
                    text: parkingSpaceModel.OnSiteId
                    Layout.fillWidth: true

                }
                // ------------------------------
                Text {
                    font: app.fontF.font
                    color: app.colorDarkBg
                    text: "Status:"
                }
                Text {
                    font: app.fontF.font
                    text: parkingSpaceModel.Status
                }
                // ------------------------------
                Text {
                    font: app.fontF.font
                    color: app.colorDarkBg
                    text: "User ID:"
                }
                Text {
                    font: app.fontF.font
                    text: isFree ? "" : parkingSpaceModel.UserId
                }
                // ------------------------------
                Text {
                    font: app.fontF.font
                    color: app.colorDarkBg
                    text: "License plate:"
                }
                Text {
                    font: app.fontF.font
                    text: isFree ? "" : parkingSpaceModel.LicensePlateNumber
                }
                // ------------------------------
                Text {
                    font: app.fontF.font
                    color: app.colorDarkBg
                    text: "Arrival:"
                }
                Text {
                    font: app.fontF.font
                    text: !isFree && arrivalDate ? arrivalDate.toDateString() + " at " + app.model.dateToHms(arrivalDate, false): ""
                }
                // ------------------------------
                Text {
                    font: app.fontF.font
                    color: app.colorDarkBg
                    text: "Parking duration:"
                }
                Text {
                    font: app.fontF.font
                    text: isFree ? "" : parkingSpaceModel.ParkingDuration
                }

            }
        }
    }
}
