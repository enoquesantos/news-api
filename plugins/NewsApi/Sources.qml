import QtQuick 2.8

import Database 1.0
import "qrc:/src/qml/" as Components

Components.BasePage {
    id: page
    objectName: "Sources.qml"
    title: qsTr("Sources")
    absPath: Config.plugins.newsapi + objectName
    listViewDelegate: SourceDelegate { }
    actionMessageText: qsTr("None source available.<br>Touch to reload!")
    onRequestUpdatePage: request()

    // handle request http responses
    onRequestFinished: {
        if (statusCode === 401 || statusCode === 403 || statusCode === 404) {
            console.error(qsTr("The News API send a %s error. Check the API key or API documentation and try again!".arg(statusCode)))
            window.alert(qsTr("Error!"), qsTr("Cannot get a valid respose from News API! Try again."), null, null)
        } else if (statusCode === 200 && response.sources.length > 0) {
            var i = 0, item = {}, length = response.sources.length
            while (i < length) {
                item = response.sources[i++]
                item.source_id = item.id
                delete item.id
                if (!database.containsId(item.source_id) && database.insert(item))
                    listViewModel.append(item)
            }
        } else {
            window.alert(qsTr("Error!"), qsTr("A error occur in the server! Try again!"), null, null)
        }
    }

    Component.onCompleted: {
        // try to load saved data from local storage, if available. Database selection data is asynchronous!
        database.select({}, {"limit": 16, "orderby": "source_id", "order": "asc"})
        request()
    }

    property var settings: App.readSetting("news_api_settings", App.SettingTypeJsonObject)
    property string apiKey: "news_api_key" in settings ? settings.news_api_key : ""
    property var signedSources: App.readSetting("signed_sources", App.SettingTypeJsonArray)
    onSignedSourcesChanged: if (signedSources.length) App.saveSetting("signed_sources", signedSources)

    function saveSignedSource(sourceId, _status) {
        if (!sourceId)
            return
        var index = signedSources.indexOf(sourceId)
        if (_status && index > -1)
            return
        if (!_status && index > -1)
            signedSources.splice(index, 1)
        else if (_status && index === -1)
            signedSources.push(sourceId)
        signedSources = signedSources
        App.eventNotify(Config.events.signedSourcesChanged, signedSources)
    }

    function request() {
        if (!apiKey || requestHttp.status === requestHttp.Loading || !page.settings.country || !page.settings.language)
            return
        // open a GET request with query string as object. The result is like this:
        // https://newsapi.org/v2/sources?language=en&country=us&apiKey=xxxxxxxxxxxxxxxxxxxxxxxxxx
        requestHttp.get("sources", {
            "apiKey": page.apiKey,
            "country": page.settings.country,
            "language": page.settings.language
        })
    }

    // plugin database handle
    Database {
        id: database
        pkColumn: "source_id"
        tableName: "sources"
        onItemLoaded: listViewModel.append(entry)
    }

    // this connection handle flickable movement.
    // After user flick to last item on the listView,
    // check for more news in local storage.
    // Otherwise, start a new request to webservice
    Connections {
        target: listView
        onMovementEnded: {
            if (listView.atYEnd && listViewModel.count && database.totalItens > listViewModel.count)
                database.select({}, {"limit": 16, "offset": listViewModel.count-1, "orderby": "source_id", "order": "asc"})
        }
    }

    Connections {
        target: App
        onEventNotify: {
            if (eventName === Config.events.settingsChanged) {
                settings = eventData
                request()
            }
        }
    }
}
