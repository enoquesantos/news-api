import QtQuick 2.8
import QtQuick.Controls 2.0

import "qrc:/src/qml/" as Components

// the delegate receive a object like this:
// {
//    "id": "abc-news",
//    "name": "ABC News",
//    "description": "Your trusted source for breaking news, analysis, exclusive interviews, headlines...",
//    "url": "http://abcnews.go.com",
//    "category": "general",
//    "language": "en",
//    "country": "us"
// }
Component {
    Components.ListItem {
        primaryLabelText: name
        secondaryLabelText: description
        backgroundColor: "#fff"
        secondaryActionItem.visible: true

        Label {
            parent: primaryLabel
            text: ">> " + url
            width: (parent.width * 0.55); height: 10
            elide: Label.ElideRight
            wrapMode: Label.WrapAnywhere
            color: Config.theme.linkColor
            font.pointSize: Config.fontSize.small
            anchors { left: parent.left; leftMargin: primaryLabel.implicitWidth + 5; top: parent.top; topMargin: 5 }
        }

        CheckBox {
            anchors { verticalCenter: parent.verticalCenter; right: parent.right; rightMargin: 8 }
            checked: signedSources.length > 0 && signedSources.indexOf(source_id) > -1
            onClicked: saveSignedSource(source_id, checked)
        }
    }
}
