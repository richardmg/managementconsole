import QtQuick 2.0

Text {
    color: app.colorDarkFg

    property int capacity: 8
    property int freeSpaces: capacity

    text: {
        if (freeSpaces === 0)
            return "FULL"
        else
            return ((1 - (freeSpaces / capacity)).toFixed(2) * 100) + "%"
    }
}

