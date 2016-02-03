import QtQuick 2.4
import QtWebSockets 1.0

Item {
    // Proxy model

    property var current: fakeModel

    signal descriptionUpdated(int modelIndex)
    signal parkingSpacesUpdated(int modelIndex)
    signal logUpdated(int modelIndex, int removed, int appended)

    property var fakeModel: FakeModel {}
    property var xmlHttpRequestModel: XmlHttpRequestModel {}

    property int maxLogLength: 100
    property int pollIntervalMs: 10000

    Component.onCompleted: current.update()
    onCurrentChanged: current.update()

    // Uncomment the following signal handlers to get debug output!

//    onDescriptionUpdated: {
//        print("Description updated:", modelIndex, JSON.stringify(current.descriptions[modelIndex], 0, "   "))
//    }

//    onParkingSpacesUpdated: {
//        print("Parking spaces updated:", modelIndex, JSON.stringify(current.parkingSpaces[modelIndex], 0, "   "))
//    }

    function createEmptyDescription()
    {
        return {
            "EMPTY_DESCRIPTION_GENERATED_LOCALLY": true,
            "Id": 0,
            "LocationName": "",
            "Latitude": 0,
            "Longitude": 0,
            "NumberFreeParkingSpaces": 0,
            "NumberTotalParkingSpaces": 8
        }
    }

    function createEmptyParkingSpaceObject(garageId, parkingSpaceId)
    {
        return {
            "EMPTY_PARKING_SPACE_GENERATED_LOCALLY": true,
            "UserId": 0,
            "Arrival": 0,
            "GarageId": garageId,
            "Status": "Free",
            "OnSiteId": parkingSpaceId,
            "ParkingDuration": 0,
            "LicensePlateNumber": ""
        }
    }

    function createEmptyLog()
    {
        return new Array
    }
}
