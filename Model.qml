import QtQuick 2.4
import QtWebSockets 1.0

Item {
    readonly property int kNoDataSource: 0
    readonly property int kFakeDataSource: 1
    readonly property int kRemoteDataSource: 2

    signal parkModelUpdated(int parkId)

    property int dataSource: kFakeDataSource
    onDataSourceChanged: {
        parkModelUpdated(0)
        parkModelUpdated(1)
    }

    property var fakeModel: createFakeParkingLotModel()
    property alias webSocket: webSocket

    Component.onCompleted: dumpFakeModel()
    function dumpFakeModel()
    {
        print(JSON.stringify(fakeModel, 0, " "))
    }

    function getParkIds() {
        if (dataSource === kNoDataSource)
            return [0, 1]
        else if (dataSource === kFakeDataSource)
            return [0, 1]
        else if (dataSource === kRemoteDataSource)
            return [0, 1]
    }

    function getParkModel(id)
    {
        if (dataSource === kNoDataSource)
            return createEmptyParkingLotModel(id)
        else if (dataSource === kFakeDataSource)
            return fakeModel.parks[id]
        else if (dataSource === kRemoteDataSource)
            return fakeModel.parks[id]
    }

    function createEmptyParkingLotModel(id)
    {
        var model = {}

        model.parkId = -1
        model.isEmpty = true
        model.parkName = "[Empty]"
        model.latitude = 0
        model.longitude = 0
        model.spaceCapacity = 0
        model.spacesOccupied = []
        model.log = new Array

        return model
    }

    function createFakeParkingLotModel()
    {
        var parkModel = {
            parks: new Array
        }

        var park = {}
        park.parkId = 0
        park.parkName = "Augustinerhof"
        park.spaceCapacity = 8
        park.spacesOccupied = new Array
        park.latitude = 49.45370
        park.longitude = 11.07515
        park.log = new Array
        parkModel.parks.push(park)

        park = {}
        park.parkId = 1
        park.parkName = "Karlstadt"
        park.spaceCapacity = 8
        park.spacesOccupied = new Array
        park.latitude = 49.45297
        park.longitude = 11.08270
        park.log = new Array
        parkModel.parks.push(park)

        return parkModel
    }

    function addFakeLogEntry(model)
    {
        var time = new Date()
        var h = time.getHours()
        var m = time.getMinutes()
        h = (h < 10) ? "0" + h : h
        m = (m < 10) ? "0" + m : m
        var timeStamp = h + ":" + m

        // Add new log entry:
        if (model.spacesOccupied.length === 0) {
            model.spacesOccupied.push(model.spacesOccupied + 1)
            model.log.push({message:"Vehicle has arrived", time:timeStamp, type:"normal"})
        } else if (model.spacesOccupied.length >= model.spaceCapacity) {
            model.spacesOccupied.splice(-1, 1)
            model.log.push({message:"Vehicle has left", time:timeStamp, type:"normal"})
        } else {
            var event = Math.round(Math.random() * 11)
            if (event === 11)
                model.log.push({message:"Malfunction alert", time:timeStamp, type:"alert"})
            else if (event % 2) {
                model.spacesOccupied.push(model.spacesOccupied + 1)
                model.log.push({message:"Vehicle has arrived", time:timeStamp, type:"normal"})
            } else {
                model.spacesOccupied.splice(-1, 1)
                model.log.push({message:"Vehicle has left", time:timeStamp, type:"normal"})
            }
        }

        // Trim log length:
        if (model.log.length > 30)
            model.log.splice(0, model.log.length - 30)
    }

    Timer {
        running: dataSource === kFakeDataSource
        interval: 1000
        repeat: true
        onTriggered: {
            var parkId = Math.round(Math.random() * (fakeModel.parks.length - 1))
            addFakeLogEntry(fakeModel.parks[parkId])
            parkModelUpdated(parkId)
            interval = Math.round(500 + (Math.random() * 5000))
        }
    }

    WebSocket {
        id: webSocket
        active: dataSource == kRemoteDataSource

        onTextMessageReceived: {
            print("Received message:", message)
        }
    }

}
