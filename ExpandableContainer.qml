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

        if (expanded) {
            target.parent = expandTo
            fadeIn.start()
        } else {
            target.parent = root
            target.opacity = 1
        }
    }

    NumberAnimation {
        id: fadeIn
        target: root.target
        property: "opacity"
        easing.type: Easing.OutCubic
        duration: 500
        from: 0
        to: 1
    }
}

