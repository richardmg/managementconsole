import QtQuick 2.4
import QtWebSockets 1.0

Item {
    // Proxy model

    property var currentModel: xmlHttpRequestModel

    signal descriptionUpdated(int modelIndex)
    signal parkingSpacesUpdated(int modelIndex)
    signal logUpdated(int modelIndex, int removed, int appended)
    signal updateTimeUpdated(int modelIndex)

    property var fakeModel: FakeModel {}
    property var xmlHttpRequestModel: XmlHttpRequestModel {}

    property int maxLogLength: 100
    property int pollIntervalMs: 10000

    Component.onCompleted: currentModel.update()
    onCurrentModelChanged: currentModel.update()

    // Uncomment the following signal handlers to get debug output!

//    onDescriptionUpdated: {
//        print("Description updated:", modelIndex, JSON.stringify(currentModel.descriptions[modelIndex], 0, "   "))
//    }

//    onParkingSpacesUpdated: {
//        print("Parking spaces updated:", modelIndex, JSON.stringify(currentModel.parkingSpaces[modelIndex], 0, "   "))
//    }

    function createEmptyDescription()
    {
        return {
            "EMPTY_DESCRIPTION_GENERATED_LOCALLY": true,
            "Id": "0",
            "locationName": "",
            "latitude": "0",
            "longitude": "0",
            "numberFreeParkingSpaces": "0",
            "numberTotalParkingSpaces": "8"
        }
    }

    function createEmptyParkingSpaceModel(garageId, parkingSpaceId)
    {
        return {
            "EMPTY_PARKING_SPACE_GENERATED_LOCALLY": true,
            "userId": "0",
            "arrival": "0",
            "garageId": garageId,
            "status": "Free",
            "onSiteId": parkingSpaceId,
            "parkingDuration": "0",
            "licensePlateNumber": "",
            "Timestamp": new Date().toString(),
        }
    }

    function createEmptyLog()
    {
        return new Array
    }

    function dateToHms(date, useSeconds)
    {
        var h = date.getHours()
        var m = date.getMinutes()
        h = (h < 10) ? "0" + h : h
        m = (m < 10) ? "0" + m : m
        return h + ":" + m
    }

}
