import QtQuick 2.4
import QtWebSockets 1.0

Item {
    // Proxy model

    property var currentModel: fakeModel

    signal descriptionUpdated(int modelIndex)
    signal parkingSpacesUpdated(int modelIndex)
    signal logUpdated(int modelIndex, int removed, int appended)
    signal updateTimeUpdated(int modelIndex)

    property var fakeModel: FakeModel {}
    property var xmlHttpRequestModel: XmlHttpRequestModel {}

    property int maxLogLength: 100
    property int pollIntervalMs: 10000

    Component.onCompleted: currentModel.reload()
    onCurrentModelChanged: currentModel.reload()

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
            "Id": 0,
            "locationName": "",
            "latitude": 0,
            "longitude": 0,
            "numberFreeParkingSpaces": 0,
            "numberTotalParkingSpaces": 8
        }
    }

    function createEmptyParkingSpaceModel(garageId, parkingSpaceId)
    {
        return {
            "EMPTY_PARKING_SPACE_GENERATED_LOCALLY": true,
            "userId": 0,
            "arrival": null,
            "garageId": garageId,
            "status": "Free",
            "onSiteId": parkingSpaceId,
            "parkingSpaceOnSiteId": parkingSpaceId,
            "parkingDuration": 0,
            "licensePlateNumber": "",
            "modificationDate": new Date().toString(),
        }
    }

    function createEmptyLogEntry()
    {
        return {
            "id": 0,
            "parkingSpaceOnSiteId": 0,
            "status": "Free",
            "garageId": 0,
            "modificationDate": new Date().toString(),
            "arrival": null,
            "licensePlateNumber": null,
            "statusInformation": null,
            "userId": null,
            "parkingDuration": 0
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
