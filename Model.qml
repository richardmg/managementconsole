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
            "LocationName": "",
            "Latitude": "0",
            "Longitude": "0",
            "NumberFreeParkingSpaces": "0",
            "NumberTotalParkingSpaces": "8"
        }
    }

    function createEmptyParkingSpaceModel(garageId, parkingSpaceId)
    {
        return {
            "EMPTY_PARKING_SPACE_GENERATED_LOCALLY": true,
            "UserId": "0",
            "Arrival": "0",
            "GarageId": garageId,
            "Status": "Free",
            "OnSiteId": parkingSpaceId,
            "ParkingDuration": "0",
            "LicensePlateNumber": "",
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

    function createLogMessage(parkingSpaceObj)
    {
        if (parkingSpaceObj.Status === "Free")
            return "Space " + parkingSpaceObj.OnSiteId + " is now free"
        else if (parkingSpaceObj.Status === "Occupied")
            return parkingSpaceObj.LicensePlateNumber + " arrived at space " + parkingSpaceObj.OnSiteId
        else if (parkingSpaceObj.Status === "ToBeOccupied")
            return parkingSpaceObj.LicensePlateNumber + " reserved space " + parkingSpaceObj.OnSiteId
        else if (parkingSpaceObj.Status === "ToBeFree")
            return parkingSpaceObj.LicensePlateNumber + " is leaving space " + parkingSpaceObj.OnSiteId
        else if (parkingSpaceObj.Status === "Malfunction")
            return "Malfunction on space " + parkingSpaceObj.OnSiteId
        else return ""
    }

}
