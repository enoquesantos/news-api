import QtQuick 2.8
import QtQuick.Controls 2.0

import "qrc:/src/qml/" as Components

ToolBar {
    width: parent.width; height: 50
    background: Rectangle {
        color: Config.theme.pageBackgroundColor
    }

    signal cancelSearch()
    signal searchTextChanged(string text)

    Components.AwesomeIcon {
        id: toolBarIcon
        width: 35; name: searchField.visible ? "arrow_left" : "feed"
        clickEnabled: name === "arrow_left"
        anchors { left: parent.left; leftMargin: 15; verticalCenter: parent.verticalCenter }
        onClicked: { searchField.visible = false; searchField.text = "" }
    }

    TextField {
        id: searchField
        visible: false
        focus: visible
        width: Qt.platform.os === "linux" || Qt.platform.os === "osx" ? parent.width * 0.76 : parent.width * 0.60
        placeholderText: qsTr("Enter a text to search the articles")
        anchors { left: toolBarIcon.right; leftMargin: 13; verticalCenter: parent.verticalCenter }
        onTextChanged: searchTextChanged(text)
        onVisibleChanged: if (!visible) cancelSearch()
    }

    Components.AwesomeIcon {
        id: toolBarSearchIcon
        width: 35; name: searchField.visible ? "close" : "search"
        anchors { right: parent.right; rightMargin: 20; verticalCenter: parent.verticalCenter }
        onClicked: {
            if (!searchField.visible && name === "search")
                searchField.visible = true
            else if (searchField.visible && searchField.text)
                searchField.text = ""
        }
    }

    Label {
        visible: !searchField.visible
        width: parent.width * 0.90
        color: Config.theme.textColorPrimary
        elide: Label.ElideRight; wrapMode: Label.WrapAnywhere
        anchors { left: toolBarIcon.right; leftMargin: 25; verticalCenter: parent.verticalCenter }
        text: qsTr("News API")
    }
}
