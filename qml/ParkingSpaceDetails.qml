import QtQuick 2.0
import QtQuick.Layouts 1.2

Rectangle {
    id: root

    property var parkingSpaceModel: app.model.createEmptyParkingSpaceModel(0, 0, new Date())
    property var arrivalDate: new Date()

    property bool isFree: parkingSpaceModel.status === "Free"
    property bool isOccupied: parkingSpaceModel.status === "Occupied"
    property bool isReserved: parkingSpaceModel.status === "ToBeOccupied"
    property bool isLeaving: parkingSpaceModel.status === "ToBeFree"

    MouseArea {
        // Block mouseareas underneath
        anchors.fill: parent
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
            columnSpacing: 20
            columns: 2

            Text {
                font: app.fontF.font
                color: app.colorDarkBg
                text: "Parking space ID:"
            }
            Text {
                font: app.fontF.font
                text: parkingSpaceModel.onSiteId
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
                text: parkingSpaceModel.status
            }
            // ------------------------------
            Text {
                font: app.fontF.font
                color: app.colorDarkBg
                text: "User ID:"
                visible: !isFree
            }
            Text {
                font: app.fontF.font
                text: visible ? parkingSpaceModel.userId : ""
                visible: !isFree
            }
            // ------------------------------
            Text {
                font: app.fontF.font
                color: app.colorDarkBg
                text: "License plate:"
                visible: !isFree
            }
            Text {
                font: app.fontF.font
                text: visible ? parkingSpaceModel.licensePlateNumber : ""
                visible: !isFree
            }
            // ------------------------------
            Text {
                font: app.fontF.font
                color: app.colorDarkBg
                text: "arrival:"
                visible: isOccupied || isLeaving
            }
            Text {
                font: app.fontF.font
                text: visible ? formatDateString(parkingSpaceModel.arrival) : ""
                visible: isOccupied || isLeaving
            }
            // ------------------------------
            Text {
                font: app.fontF.font
                color: app.colorDarkBg
                text: "Parking duration:"
                visible: isOccupied || isLeaving
            }
            Text {
                font: app.fontF.font
                text: parkingSpaceModel.parkingDuration
                visible: isOccupied || isLeaving
            }

        }
    }

    function formatDateString(dateStr)
    {
        var date = new Date(dateStr)
        return date.toDateString() + " at " + app.model.dateToHms(date, false)
    }
}
