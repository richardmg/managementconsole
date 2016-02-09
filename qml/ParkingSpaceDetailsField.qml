import QtQuick 2.0

Item {
    property string modelKey
    width: childrenRect.width
    height: childrenRect.height

    Text {
        font: app.fontF.font
        color: app.colorDarkBg
        text: modelKey
    }
    Text {
        x: fieldSplit
        font: app.fontF.font
        text: parkingSpaceModel[modelKey]
    }
}
