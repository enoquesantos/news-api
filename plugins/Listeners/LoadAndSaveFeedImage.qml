import QtQuick 2.8

import "qrc:/src/qml/" as Components

Item {
    id: rootItem
    objectName: "LoadAndSaveFeedImage.qml"

    Component.onCompleted: console.log(rootItem.objectName + " created!")
    Component.onDestruction: console.log(rootItem.objectName + " onDestruction!")

    property var feedProperties: ({})
    property var settings: App.readSetting("news_api_settings", App.SettingTypeJsonObject)
    property string localImagePath: Qt.platform.os === "android" ? "assets://" : ""

    Components.RequestHttp {
        id: requestHttp
        onDownloadedFileSaved: {
            if (filePath) {
                var fixedPath = "", eventData = {}, p = 0, feedId = 0, feedImageBaseName = Utils.fileBaseName(filePath)
                feedId = Object.keys(feedProperties).filter(function(key) {return feedProperties[key] === feedImageBaseName})[0]
                if (feedId) {
                    eventData = {
                        "feedId": feedId,
                        "urlToImage": filePath.toString().replace(/%20/g, " ")
                    }
                    App.eventNotify(Config.events.downloadFeedImageFinished, eventData)
                }
            }
        }
    }

    Connections {
        target: App
        onEventNotify: {
            // signal signature: eventNotify(QString eventName, QVariant eventData)
            if (eventName === Config.events.downloadFeedImage) {
                if (!App.isDeviceOnline())
                    return
                feedProperties[eventData.feedId] = Utils.fileBaseName(eventData.urlToImage)
                feedProperties = feedProperties
                requestHttp.downloadFile(eventData.urlToImage, true)
            }
        }
    }
}
