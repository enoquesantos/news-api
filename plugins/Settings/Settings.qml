import QtQuick 2.8
import QtQuick.Controls 2.0

import "qrc:/src/qml/" as Components

Components.BasePage {
    id: page
    objectName: "Settings.qml"
    title: qsTr("Settings")
    absPath: Config.plugins.settings + objectName
    hasListView: false
    hasNetworkRequest: false

    property var settings: App.readSetting("news_api_settings", App.SettingTypeJsonObject)

    // Timer has default time for 1000ms(1s)
    // Timer is default to not repeat
    // Timer is default to not running
    Timer {
        id: asynchronousNotify
        onTriggered: App.eventNotify(Config.events.settingsChanged, settings)
    }

    Constants {
        id: constants
    }

    Column {
        id: mainColumn
        spacing: 0
        width: parent.width * 0.95
        anchors { top: parent.top; topMargin: 0; horizontalCenter: parent.horizontalCenter }

        ItemDelegate {
            width: parent.width; height: 65
            anchors.horizontalCenter: parent.horizontalCenter
            onClicked: checkbox1.checked = !checkbox1.checked

            Label {
                width: parent.width - checkbox1.width * 1.15
                elide: Text.ElideRight; wrapMode: Text.WordWrap
                anchors.verticalCenter: parent.verticalCenter
                verticalAlignment: Label.AlignVCenter
                text: qsTr("Save the feeds in your device? Can be useful to read offline.")
            }

            CheckBox {
                id: checkbox1
                anchors { right: parent.right; verticalCenter: parent.verticalCenter }
                Component.onCompleted: checked = "save_feeds_in_device" in page.settings ? page.settings.save_feeds_in_device : true
            }

            Rectangle {
                width: parent.width; height: 1
                color: Config.theme.colorPrimary; opacity: 0.1
                anchors.bottom: parent.bottom
            }
        }

        ItemDelegate {
            width: parent.width; height: 65
            anchors.horizontalCenter: parent.horizontalCenter
            onClicked: checkbox2.checked = !checkbox2.checked

            Label {
                width: parent.width - checkbox2.width * 1.15
                elide: Text.ElideRight; wrapMode: Text.WordWrap
                anchors.verticalCenter: parent.verticalCenter
                verticalAlignment: Label.AlignVCenter
                text: qsTr("Save the search results in your device? Will be added to view when offline.")
            }

            CheckBox {
                id: checkbox2
                anchors { right: parent.right; verticalCenter: parent.verticalCenter }
                Component.onCompleted: checked = "save_search_results_in_device" in page.settings ? page.settings.save_search_results_in_device : true
            }

            Rectangle {
                width: parent.width; height: 1
                color: Config.theme.colorPrimary; opacity: 0.1
                anchors.bottom: parent.bottom
            }
        }

        ItemDelegate {
            width: parent.width; height: 65
            anchors.horizontalCenter: parent.horizontalCenter
            onClicked: checkbox3.checked = !checkbox3.checked

            Label {
                width: parent.width - checkbox3.width
                elide: Text.ElideRight; wrapMode: Text.WordWrap
                anchors.verticalCenter: parent.verticalCenter
                verticalAlignment: Label.AlignVCenter
                text: qsTr("Save the feeds images in your device? You can view the images when offline.")
            }

            CheckBox {
                id: checkbox3
                anchors { right: parent.right; verticalCenter: parent.verticalCenter }
                Component.onCompleted: checked = "save_images_in_device" in page.settings ? page.settings.save_images_in_device : true
            }

            Rectangle {
                width: parent.width; height: 1
                color: Config.theme.colorPrimary; opacity: 0.1
                anchors.bottom: parent.bottom
            }
        }

        ItemDelegate {
            width: parent.width; height: 65
            anchors.horizontalCenter: parent.horizontalCenter
            onClicked: comboBox1.down ? comboBox1.popup.close() : comboBox1.popup.open()

            Label {
                width: parent.width - (comboBox1.width * 1.20)
                elide: Text.ElideRight; wrapMode: Text.WordWrap
                anchors.verticalCenter: parent.verticalCenter
                verticalAlignment: Label.AlignVCenter
                text: qsTr("Set a language to load the feeds and sources. The default is the value defined by your device.")
            }

            ComboBox {
                id: comboBox1
                flat: true
                model: ["ar", "en", "cn", "de", "es", "fr", "he", "it", "nl", "no", "pt", "ru", "sv", "ud"]
                width: 75; height: parent.height * 0.85
                anchors { right: parent.right; verticalCenter: parent.verticalCenter }
                Component.onCompleted: currentIndex = find("language" in page.settings ? page.settings.language : constants.language)
            }

            Rectangle {
                width: parent.width; height: 1
                color: Config.theme.colorPrimary; opacity: 0.1
                anchors.bottom: parent.bottom
            }
        }

        ItemDelegate {
            width: parent.width; height: 65
            anchors.horizontalCenter: parent.horizontalCenter
            onClicked: comboBox2.down ? comboBox2.popup.close() : comboBox2.popup.open()

            Label {
                width: parent.width - (comboBox2.width * 1.20)
                elide: Text.ElideRight; wrapMode: Text.WordWrap
                anchors.verticalCenter: parent.verticalCenter
                verticalAlignment: Label.AlignVCenter
                text: qsTr("Set a country to load the feeds and sources. The default is the value defined by your device.")
            }

            ComboBox {
                id: comboBox2
                flat: true
                model: ["ar", "au", "br", "ca", "cn", "de", "es", "fr", "gb", "hk", "ie", "in", "is", "it", "nl", "no", "pk", "ru", "sa", "sv", "us", "za"]
                width: comboBox1.width; height: comboBox1.height
                anchors { right: parent.right; verticalCenter: parent.verticalCenter }
                Component.onCompleted: currentIndex = find("country" in page.settings ? page.settings.country : constants.country)
            }

            Rectangle {
                width: parent.width; height: 1
                color: Config.theme.colorPrimary; opacity: 0.1
                anchors.bottom: parent.bottom
            }
        }

        ItemDelegate {
            width: parent.width; height: 80
            anchors.horizontalCenter: parent.horizontalCenter
            onClicked: textFieldKey.focus = true

            Label {
                id: apiKeyLabel
                width: parent.width * 0.95
                elide: Text.ElideRight; wrapMode: Text.WordWrap
                anchors.verticalCenter: parent.verticalCenter
                verticalAlignment: Label.AlignVCenter
                text: qsTr("Enter the Key from News API in the field below. The key is needed to sent in http requests headers.")
            }

            Components.PasswordField {
                id: textFieldKey
                text: "news_api_key" in page.settings ? page.settings.news_api_key : ""
                anchors {
                    top: apiKeyLabel.bottom
                    topMargin: 7
                }
            }
        }

        // add option to user choose a category:
        // entertainment, gaming, general, health-and-medical, music, politics, science-and-nature, sport, technology
    }

    Components.CustomButton {
        anchors { bottom: parent.bottom; bottomMargin: 20; horizontalCenter: parent.horizontalCenter }
        text: qsTr("Save settings")
        onClicked: {
            if (!textFieldKey.text) {
                functions.alert(qsTr("Error!"), qsTr("Set the News Feed API key!"), null, null)
                return
            }
            settings["save_feeds_in_device"] = checkbox1.checked
            settings["save_search_results_in_device"] = checkbox2.checked
            settings["save_images_in_device"] = checkbox3.checked
            settings["language"] = comboBox1.currentText
            settings["country"] = comboBox2.currentText
            settings["news_api_key"] = textFieldKey.text
            settings = settings
            App.saveSetting("news_api_settings", settings)
            asynchronousNotify.running = true
        }
    }
}
