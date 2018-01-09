import QtQuick 2.8
import QtQuick.Controls 2.0

import Database 1.0
import "qrc:/src/qml/" as Components

Components.BasePage {
    id: page
    objectName: "News.qml"
    title: qsTr("Last news")
    absPath: Config.plugins.newsapi + objectName
    listViewDelegate: NewsDelegate { }
    header: NewsToolBar { id: toolbar }
    actionMessageText: qsTr("None feed available.<br>Touch to reload!")
    onRequestUpdatePage: request()

    Component.onCompleted: {
        // first, set listview customization
        listView.bottomMargin = 10

        // try to load saved data from local storage, if available. Database selection data is asynchronous!
        database.select({}, {"limit": 16, "orderby": "id", "order": "desc"})

        // start a request to load recent news
        request()
    }

    readonly property var settings: App.readSetting("news_api_settings", App.SettingTypeJsonObject)
    readonly property var signedSources: App.readSetting("signed_sources", App.SettingTypeJsonArray)
    property string apiKey: "news_api_key" in settings ? settings.news_api_key : ""

    // handle request http responses
    onRequestFinished: {
        if (statusCode === 401 || statusCode === 403 || statusCode === 404) {
            window.alert(qsTr("Error!"), qsTr("The News API send a %1 error. Check the API key and try again.".arg(statusCode)), null, null)
        } else if (statusCode === 200) {
            var article = {}, feedId = 0, i = 0, length = response.articles.length
            while (i < length) {
                article = response.articles[i++]
                if (!article.title && !article.description)
                    continue
                if (!article.publishedAt)
                    article.publishedAt = new Date().toUTCString()
                if (!article.urlToImage)
                    article.urlToImage = Qt.resolvedUrl("default-article-img.png")
                else if (article.urlToImage.indexOf("http") === -1)
                    article.urlToImage = "http://" + article.urlToImage
                // append the 'source_id' to correct save in database
                // the 'source_id' is needed to optimize the filter by source id.
                article["source_id"] = article.source.id
                // try to insert the article in database.
                // if is already saved, the article in too already in the listview.
                // if the insert return 0, the item already exists and we cannot add duplicated items.
                if (searchResultsModel.isEnabledToSearch) {
                    if (settings.save_search_results_in_device && database.insert(article))
                        searchResultsModel.append(article)
                    else if (!settings.save_search_results_in_device)
                        searchResultsModel.append(article)
                    return
                }
                if (!page.settings.save_feeds_in_device) {
                    listViewModel.append(article)
                } else {
                    feedId = database.insert(article)
                    if (feedId > 0 && listViewModel.count <= 15)
                        listViewModel.append(article)
                    if (feedId > 0 && page.settings.save_images_in_device && article.urlToImage.indexOf("default-article-img.png") < 0)
                        App.eventNotify(Config.events.downloadFeedImage, ({"feedId": feedId, "urlToImage": article.urlToImage}))
                }
            }
        } else {
            window.alert(qsTr("Error!"), qsTr("A error occur in the server! Try again."), null, null)
        }
    }

    function request() {
        if (!App.isDeviceOnline()) {
            snackbar.show(qsTr("Cannot connect to internet!"))
            return
        } else if (!apiKey || page.isPageBusy || !signedSources.length || !page.settings.country || !page.settings.language) {
            return
        }
        var args = {
            "apiKey": page.apiKey
        }
        // add query args to search a article if search is enabled
        if (searchResultsModel.isEnabledToSearch) {
            args.q = searchResultsModel.searchText
        } else {
            // add user country and language to get articles
            args.country = page.settings.country
            args.language = page.settings.language
            args.sources = signedSources.length > 1 ? signedSources.join(",") : signedSources[0]
        }
        // @WARNING!
        // The News API in developer mode, limit the to 1000 request by day.
        // the top-headlines can group multiple sources:
        // top-headlines?sources=the-next-web,the-verge&apiKey={API_KEY}
        // open the request type GET with query string builder from a javascript object
        requestHttp.get("top-headlines", args)
    }

    // plugin database handle
    Database {
        id: database
        jsonColumns: ["source"]
        tableName: "news"
        pkColumn: "title"
        onItemLoaded: listViewModel.append(entry)
    }

    Timer {
        interval: 500000; repeat: true; running: true
        onTriggered: request()
    }

    Connections {
        target: toolbar
        onCancelSearch: searchResultsModel.searchText = ""
        onSearchTextChanged: searchResultsModel.searchText = text
    }

    // this connection handle flickable movement.
    // After user flick to last item on the listView,
    // check for more news in local storage.
    // Otherwise, start a new request to webservice
    Connections {
        target: listView
        onMovementEnded: {
            if (!listView.atYEnd && !listViewModel.count)
                return
            if (database.totalItens > listViewModel.count)
                database.select({}, {"limit": 16, "offset": listViewModel.count-1, "orderby": "id", "order": "desc"})
            else if (database.totalItens <= listViewModel.count && App.isDeviceOnline())
                request()
        }
    }

    Connections {
        target: App
        onEventNotify: {
            if (eventName === Config.events.settingsChanged) {
                settings = eventData
                request()
            } else if (eventName === Config.events.signedSourcesChanged) {
                signedSources = eventData
                request()
            } else if (eventName === Config.events.downloadFeedImageFinished) {
                // update the image path in database to feedId with the local path
                database.update({"urlToImage": eventData.urlToImage}, {"id": eventData.feedId})
            }
        }
    }

    // to view the search articles, we need to use another ListModel
    ListModel {
        id: searchResultsModel
        onCountChanged: listView.model = (count ? searchResultsModel : listViewModel)
        property string searchText: ""
        property bool isEnabledToSearch: searchText.length > 3
        onIsEnabledToSearchChanged: isEnabledToSearch ? request() : clear()
    }
}
