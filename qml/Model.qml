import QtQuick 2.4
import QtWebSockets 1.0

Item {
    // Proxy model

    property var currentModel: xmlHttpRequestModel

    signal descriptionUpdated(int modelIndex)
    signal parkingSpacesUpdated(int modelIndex)
    signal logUpdated(int modelIndex, int addCount, int removeCount)
    signal updateTimeUpdated(int modelIndex)

    property var fakeModel: FakeModel {}
    property var xmlHttpRequestModel: XmlHttpRequestModel {}

    property int maxLogLength: 100
    property int pollIntervalMs: 20 * 1000
    property string locationNameFilter: defaultLocationNameFilter
    property string cityNameFilter: defaultCityNameFilter

    readonly property string defaultLocationNameFilter: "Theaterparkhaus|Sterntor"
    readonly property string defaultCityNameFilter: ""

    Component.onCompleted: currentModel.reload()
    onCurrentModelChanged: currentModel.reload()
    onLocationNameFilterChanged: currentModel.reload()
    onCityNameFilterChanged: currentModel.reload()

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
            "FAKE": true,
            "Id": 0,
            "locationName": "",
            "latitude": 0,
            "longitude": 0,
            "numberFreeParkingSpaces": 8,
            "numberTotalParkingSpaces": 8,
            "webcamUrl": "qrc:/img/parkinglot.jpg"
        }
    }

    function createEmptyParkingSpaceModel(garageId, parkingSpaceId, modificationDate)
    {
        return {
            "FAKE": true,
            "userId": 0,
            "arrival": null,
            "garageId": garageId,
            "status": "Free",
            "onSiteId": parkingSpaceId,
            "parkingSpaceOnSiteId": parkingSpaceId,
            "parkingDuration": 0,
            "licensePlateNumber": "",
            "modificationDate": modificationDate,
            "FAKE_parkingDuration_start": modificationDate
        }
    }

    function createEmptyLogEntry(garageId, parkingSpaceId, modificationDate)
    {
        return {
            "FAKE": true,
            "id": 0,
            "parkingSpaceOnSiteId": 0,
            "status": "Free",
            "garageId": 0,
            "modificationDate": modificationDate,
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

    function dateToDmy(dateStr)
    {
        var date = new Date(dateStr)
        var d = date.getDate()
        var m = date.getMonth() + 1
        var y = date.getFullYear() - 2000
        d = (d < 10) ? "0" + d : d
        m = (m < 10) ? "0" + m : m
        return d + "." + m + "." + y
    }

    function dateToHms(dateStr, useSeconds)
    {
        var date = new Date(dateStr)
        var h = date.getHours()
        var m = date.getMinutes()
        h = (h < 10) ? "0" + h : h
        m = (m < 10) ? "0" + m : m
        return h + ":" + m
    }

    function dateToHumanReadable(dateStr)
    {
        return dateToDmy(dateStr) + " | " + dateToHms(dateStr, false)
    }

    function chopArray(array, max)
    {
        var removed = 0
        var overFlow = array.length - max
        if (overFlow > 0)
            array.splice(array.length - overFlow, overFlow)
        return Math.max(0, overFlow)
    }
}
