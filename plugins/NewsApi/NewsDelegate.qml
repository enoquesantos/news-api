import QtQuick 2.8
import QtQuick.Layouts 1.3
import QtQuick.Controls 2.1

import "qrc:/src/qml/" as Components

// the ArticlesDelegate receive a object with follow properties:
//
// {
//    "source": {
//      "id": "bbc-news",
//      "name": "BBC News"
//    },
//    "author": "BBC News",
//    "title": "Trump says Flynn's Russia dealings lawful",
//    "description": "President Trump says ex-aide Michael Flynn's dealings with Russia in December were lawful but he was fired for lying.",
//    "url": "http://www.bbc.co.uk/news/world-us-canada-42209758",
//    "urlToImage": "https://ichef.bbci.co.uk/images/ic/1024x576/p05pwbcr.jpg",
//    "publishedAt": "2017-12-02T17:40:54Z"
// }
Component {
    ItemDelegate {
        id: delegate
        anchors.horizontalCenter: parent ? parent.horizontalCenter : undefined
        width: parent.width; height: 250
        onClicked: Qt.openUrlExternally(url)

        // set the delegate content
        ColumnLayout {
            spacing: 5
            width: parent.width; height: parent.height

            // show the article image
            Rectangle {
                id: articleImg
                width: parent.width; height: 190

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
                Rectangle {
                    width: parent.width; height: 1
                    color: "green"; opacity: 0.1
                    anchors.bottom: parent.bottom
                }
            }

            // show the article title
            Item {
                width: parent.width; height: 40

                Text {
                    id: titleLabel
                    text: "%1%2".arg(title).arg(description ? ". " + description : "")
                    width: parent.width* 0.95; height: parent.height
                    color: Config.theme.textColorPrimary
                    font.pointSize: Config.fontSize.small
                    leftPadding: 8
                    elide: Text.ElideRight; wrapMode: Text.WordWrap
                    anchors.verticalCenter: parent.verticalCenter
                }
            }

            RowLayout {
                spacing: 0
                width: parent.width; height: 20
                anchors {
                    bottom: parent.bottom; bottomMargin: 0
                    left: parent.left; leftMargin: 8
                    right: parent.right; rightMargin: 8
                }

                // show the article source id
                Item {
                    id: articleSourceId
                    width: parent.width * 0.60; height: Qt.platform.os === "linux" || Qt.platform.os === "osx" ? parent.height : parent.height/1.6

                    Text {
                        text: qsTr("From <u><i>%1</i></u>%2").arg(source.name).arg(author ? " by " +author : "")
                        width: parent.width; height: parent.height
                        color: Config.theme.linkColor
                        font.pointSize: Config.fontSize.small-1
                        elide: Text.ElideRight; wrapMode: Text.WordWrap
                        anchors.verticalCenter: parent.verticalCenter
                    }
                }

                // show the date and time informations
                Row {
                    id: bottomRow
                    spacing: 0
                    width: articleSourceId.width; height: parent.height
                    anchors.right: parent.right

                    Components.AwesomeIcon {
                        size: dateLabel.font.pointSize-1; name: "calendar"
                        visible: dateLabel.text.length > 0; width: 15
                        color: dateLabel.color; clickEnabled: false
                        anchors.verticalCenter: parent.verticalCenter
                    }

                    Text {
                        id: dateLabel
                        text: Qt.formatDateTime(publishedAt, "dd/MM/yyyy")
                        font.pointSize: Config.fontSize.small-1
                        color: Config.theme.linkColor
                        anchors.verticalCenter: parent.verticalCenter
                    }

                    Item { width: 3; height: parent.height }

                    Components.AwesomeIcon {
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
}
