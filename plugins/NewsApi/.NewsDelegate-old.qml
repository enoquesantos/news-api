import QtQuick 2.8
import QtQuick.Layouts 1.3
import QtQuick.Controls 2.1

import "qrc:/qml/" as Components
import "qrc:/qml/Awesome/" as Awesome

ItemDelegate {
    id: delegate
    anchors.horizontalCenter: parent ? parent.horizontalCenter : undefined
    width: parent.width; height: 150
    onClicked: Qt.openUrlExternally(url)

    Rectangle {
        anchors.fill: parent
        color: "#fff"; opacity: 0.7
    }

    RowLayout {
        spacing: 8
        anchors { fill: parent; margins: spacing }

        Rectangle {
            id: articleImg
            width: 150; height: 110
            anchors.verticalCenter: parent.verticalCenter

            Image {
                source: urlToImage
                fillMode: Image.PreserveAspectCrop
                width: parent.width; height: parent.height
                sourceSize.width: width
                sourceSize.height: height
                anchors.centerIn: parent
                asynchronous: true; cache: true; smooth: true
                onStatusChanged: if (status == Image.Error) source = Qt.resolvedUrl("default-article-img.png")

                BusyIndicator {
                    anchors.centerIn: parent
                    width: 50; height: 50; opacity: 0.8
                    visible: parent.status == Image.Loading
                }
            }
        }

        ColumnLayout {
            spacing: 5
            width: delegate.width - articleImg.width; height: delegate.height
            anchors {
                top: parent.top; topMargin: 0
            }

            // show the article title
            Item {
                width: parent.width*0.80; height: 50

                Text {
                    id: titleLabel
                    text: title
                    width: parent.width * 0.90; height: 50
                    color: Config.theme.textColorPrimary
                    font.pointSize: Config.fontSize.normal
                    elide: Text.ElideRight; wrapMode: Text.WordWrap
                }
            }

            // show the article description
            Item {
                width: parent.width*0.80; height: 35

                Text {
                    text: description
                    width: parent.width * 0.90; height: 70
                    color: titleLabel.color
                    font.pointSize: Config.fontSize.small+1
                    elide: Text.ElideRight; wrapMode: Text.WrapAnywhere
                }
            }

            // add the date and time informations
            Row {
                id: bottomRow
                spacing: 1; height: 25
                anchors {
                    bottom: parent.bottom; bottomMargin: 2
                    right: parent.right; rightMargin: 10
                }

                Awesome.Icon {
                    size: dateLabel.font.pointSize-1; name: "calendar"
                    visible: dateLabel.text.length > 0; width: 15
                    color: dateLabel.color; clickEnabled: false
                    anchors.verticalCenter: parent.verticalCenter
                }

                Text {
                    id: dateLabel
                    text: Qt.formatDateTime(publishedAt, "dd/MM/yyyy")
                    font.pointSize: Config.fontSize.small
                    color: titleLabel.color
                    anchors.verticalCenter: parent.verticalCenter
                }

                Item { width: 5; height: parent.height }

                Awesome.Icon {
                    size: dateLabel.font.pointSize; name: "clock_o"
                    visible: timeLabel.text.length > 0; width: 15
                    color: dateLabel.color; clickEnabled: false
                    anchors.verticalCenter: parent.verticalCenter
                }

                Text {
                    id: timeLabel
                    text: new Date(publishedAt).toLocaleTimeString(window.locale).substring(0, 8)
                    font.pointSize: dateLabel.font.pointSize
                    color: dateLabel.color
                    anchors.verticalCenter: parent.verticalCenter
                }
            }
        }
    }

    // draw a separator line
    Rectangle {
        width: parent.width; height: 1
        color: titleLabel.color; opacity: 0.1
        anchors.bottom: parent.bottom
    }
}
