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
        park.spacesOccupied = [0, 1, 2, 3]
        park.latitude = 49.45370
        park.longitude = 11.07515
        var log = new Array
        log.push({message:"Vehicle has left", time:"10:45", type:"normal"})
        log.push({message:"Malfunction Alert", time:"09:37", type:"alert"})
        log.push({message:"Vehicle has arrived", time:"09:28", type:"normal"})
        log.push({message:"Vehicle has left", time:"09:02", type:"normal"})
        park.log = log
        parkModel.parks.push(park)

        park = {}
        park.parkId = 1
        park.parkName = "Karlstadt"
        park.spaceCapacity = 8
        park.spacesOccupied = [0, 1, 2, 3, 4, 5, 6, 7]
        park.latitude = 49.45297
        park.longitude = 11.08270
        log = new Array
        log.push({message:"Vehicle has arrived", time:"10:45", type:"normal"})
        log.push({message:"Vehicle has left", time:"10:10", type:"normal"})
        log.push({message:"Vehicle has arrived", time:"09:22", type:"normal"})
        log.push({message:"Vehicle has arrived", time:"09:21", type:"normal"})
        log.push({message:"Vehicle has left", time:"09:13", type:"normal"})
        park.log = log
        parkModel.parks.push(park)

        return parkModel
    }

    Component.onCompleted: dumpFakeModel()
    function dumpFakeModel()
    {
        print(JSON.stringify(fakeModel, 0, '   '))
    }

    Timer {
        running: dataSource === kFakeDataSource
        interval: 1000
        repeat: true
        onTriggered: {
            var parkId = Math.round(Math.random() * (fakeModel.parks.length - 1))
            var model = fakeModel.parks[parkId]

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

            parkModelUpdated(0)
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
