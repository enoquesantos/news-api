import QtQuick 2.8
import QtQuick.Controls 2.1
import QtQuick.Layouts 1.3

import "qrc:/src/qml/" as Components

Components.BasePage {
    id: page
    objectName: "AboutPage.qml"
    title: qsTr("About the ") + Qt.application.displayName
    absPath: Config.plugins.about + objectName
    hasListView: false
    hasNetworkRequest: false
    pageBackgroundColor: Config.theme.colorPrimary

    Flickable {
        id: flickable
        anchors.fill: parent
        contentHeight: Math.max(column.implicitHeight + 50, height)

        ColumnLayout {
            id: column
            spacing: 10
            width: page.width
            anchors { top: parent.top; horizontalCenter: parent.horizontalCenter }

            Rectangle {
                color: Config.theme.pageBackgroundColor
                width: 128; height: width; radius: width
                anchors.horizontalCenter: parent.horizontalCenter

                Components.RoundedImage {
                    id: logo
                    width: parent.width; height: width
                    imgSource: "qrc:/icon.png"
                    anchors.centerIn: parent
                    onClicked: animationTerminator.running = !animationTerminator.running

                    NumberAnimation on rotation {
                        from: 0; to: 360; running: animationTerminator.running
                        duration: 150; loops: Animation.Infinite
                    }

                    Timer {
                        id: animationTerminator
                        interval: 600; running: true
                        onTriggered: logo.rotation = 0
                    }
                }
            }

            Item {
                width: parent.width * 0.80; height: applicationName.implicitHeight + 10
                anchors.horizontalCenter: parent.horizontalCenter

                Label {
                    id: applicationName
                    width: parent.width
                    wrapMode: Text.WordWrap
                    text: Config.appName
                    color: Config.theme.colorAccent
                    font { weight: Font.ExtraBold; pointSize: Config.fontSize.extraLarge }
                    horizontalAlignment: Label.AlignHCenter
                    anchors.horizontalCenter: parent.horizontalCenter

                    MouseArea {
                        anchors.fill: parent
                        onClicked: Qt.openUrlExternally("https://newsapi.org")
                    }
                }
            }

            Item {
                id: lastLabel
                width: parent.width * 0.80; height: applicationDescription.implicitHeight + 10
                anchors.horizontalCenter: parent.horizontalCenter

                Label {
                    id: applicationDescription
                    width: parent.width
                    wrapMode: Text.WordWrap
                    elide: Text.ElideRight
                    text: Config.appDescription
                    color: Config.theme.colorAccent
                    font { weight: Font.DemiBold; pointSize: 16 }
                    horizontalAlignment: Label.AlignHCenter
                    anchors.horizontalCenter: parent.horizontalCenter
                }
            }

            Item {
                width: parent.width * 0.90
                height: appDetailedDescription.height
                anchors {
                    horizontalCenter: parent.horizontalCenter
                    top: lastLabel.bottom
                    topMargin: 25
                }

                Text {
                    id: appDetailedDescription
                    width: parent.width
                    wrapMode: Text.WordWrap
                    elide: Text.ElideRight
                    color: Config.theme.colorAccent
                    font { weight: Font.DemiBold; pointSize: 13 }
                    horizontalAlignment: Label.AlignJustify
                    anchors.horizontalCenter: parent.horizontalCenter
                    text: Utils.readFile(Qt.resolvedUrl("AppDescription.txt"))
                    textFormat: Text.RichText
                    onLinkActivated: Qt.openUrlExternally(link)
                }
            }
        }
    }
}
