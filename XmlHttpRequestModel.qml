import QtQuick 2.0

Item {
    property string baseUrl: "http://cloudparkingdemo.azurewebsites.net/api/tdxremote/"

    property var garageArray: new Array
    property var parkingSpaceArray: new Array

    Component.onCompleted: {
        loadGarageArray()
    }

    function load(action, callback)
    {
        var xmlhttp = new XMLHttpRequest();
        xmlhttp.onreadystatechange = function() {
            if (xmlhttp.readyState === XMLHttpRequest.DONE) {
                if (xmlhttp.status == 200) {
//                    print(JSON.stringify(JSON.parse(xmlhttp.responseText), 0, "   "))
                    callback(JSON.parse(xmlhttp.responseText))
                } else {
                    print("WARNING! could not get data from server:", xmlhttp.statusText)
                }
            }
        }

        xmlhttp.open("GET", baseUrl + action, true);
        xmlhttp.send();
    }

    function dumpObject(obj)
    {
        print(JSON.stringify(obj, 0, "   "))
    }

    function loadGarageArray()
    {
        load("garage", function(obj) {
            garageArray = obj
            app.model.garageModelUpdated()
        })
    }

    function getParkIds()
    {
        var ids = new Array
        for (var i = 0; i < garageArray.length; ++i) {
            print(garageArray[i])
            ids.push(garageArray[i].Id);
        }
        return ids
    }

}
