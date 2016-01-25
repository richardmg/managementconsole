import QtQuick 2.0

Text {
    font: app.fontNormal.font
    color: app.colorDarkFg

    property int capacity: 8
    property int occupied: 0

    text: {
        if (occupied >= capacity)
            return "FULL"
        else
            return  ((occupied / capacity).toFixed(1) * 100) + "%"
    }
}

