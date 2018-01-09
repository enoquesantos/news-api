import QtQuick 2.8

QtObject {
    // read the window locale defined by device
    readonly property var deviceLocale: window.locale.name.toLowerCase().split("_")

    // set default country and language
    readonly property string country: deviceLocale.length ? deviceLocale[1] : "us"
    readonly property string language: deviceLocale.length ? deviceLocale[0] : "en"
}
