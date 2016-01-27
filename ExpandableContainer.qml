import QtQuick 2.0

Item {
    id: root

    property Item target
    property Item expandTo
    property bool expanded: false

    function toggle()
    {
        expanded = !expanded
    }

    Component.onCompleted: {
        if (!target)
            target = children[0]
    }

    onExpandedChanged: {
        if (!target)
            return
        target.opacity = 0
    }

    Connections {
        target: root.target
        onOpacityChanged: {
            if (target.opacity === 0) {
                fadeIn.start()
                target.parent = expanded ? expandTo : root
            }
        }
    }

    NumberAnimation {
        id: fadeIn
        target: root.target
        property: "opacity"
        easing.type: Easing.OutCubic
        duration: 500
        to: 1
    }
}

