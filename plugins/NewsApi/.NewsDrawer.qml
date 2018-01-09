import QtQuick 2.8
import QtQuick.Controls 2.0

import "qrc:/qml/" as Components
import "qrc:/qml/Awesome/" as Awesome 

Drawer {
    id: drawer
    modal: false
    y: 50; transformOrigin: Popup.Top
    width: parent.width; height: page.height - (y+2)
    enter: Transition {
        NumberAnimation { property: "opacity"; from: 0.0; to: 1.0; duration: 200 }
    }
    exit: Transition {
        NumberAnimation { property: "opacity"; from: 1.0; to: 0.0; duration: 200 }
    }
    background: Rectangle {
        color: Config.theme.pageBackgroundColor
    }
    onClosed: App.eventNotify(Config.events.drawerClosed, 0)

    // fix listview elements visible property binds
    Component.onCompleted: { open(); close() }

    property var signedOptions: App.readSetting("signed_sources_list", App.SettingTypeJsonArray)

    Connections {
        target: App
        onEventNotify: {
            if (eventName === Config.events.openDrawer) {
                if (eventData)
                    open()
                else
                    close()
            } else if (eventName === Config.events.signedSourcesChanged) {
                signedOptions = App.readSetting("signed_sources_list", App.SettingTypeJsonArray)
            }
        }
    }

    Rectangle {
        color: Config.theme.textColorPrimary
        width: parent.width; height: 2; opacity: 0.5
        anchors.bottom: parent.bottom

        Awesome.Icon {
            name: "ellipsis_h"
            anchors.centerIn: parent
            onClicked: drawer.close()
        }
    }

    Components.CustomListView {
        width: parent.width; height: parent.height; clip: true
        model: signedOptions
        delegate: viewDelegate

        Components.PageActionMessage {
            visible: !parent.count
            iconName: "gear"
            messageText: qsTr("Signed feeds is empty!<br>Select the feeds in sources page.")
            // onClicked: {  } add click to paginate to sources page?
        }
    }

    Component {
        id: viewDelegate

        Components.ListItem {
            visible: true
            primaryLabelText: modelData.name
            secondaryLabelText: modelData.description
            onClicked: {
                drawer.close()
                activeSource = modelData
                request(true)
            }
        }
    }
}
