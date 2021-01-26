import QtQuick 2.15
import QtQuick.Controls 2.15
import QtQuick.Layouts 1.1
import QtQuick.Controls.Styles 1.2
import QtMultimedia 5.15
import QtQuick.Window 2.15
import Qt.labs.settings 1.0
import QtQuick.Controls.Material 2.12

ApplicationWindow {
    id: window
    width: Qt.platform.os === "windows" ? 360 : Screen.desktopAvailableWidth
    height: Qt.platform.os === "windows" ? 640 : Screen.desktopAvailableHeight

    visible: true

    onClosing: {
        close.accepted = false
        dial.open()
      }

    property var hp : mainSettings.value("hpSettings", "https://www.novoeradio.by/")

    property bool isDarkTheme: mainSettings.value("isDarkThemeSettings", true)

    Material.theme: Material.Dark

    onIsDarkThemeChanged: {
//        console.log(isDarkTheme)
        if(isDarkTheme == true) {
            Material.background = "#121c2f"
            Material.foreground = "#d7d6d5"
            Material.primary = "#9cbdec"
            Material.accent = "#9cbdec"
            Material.theme = Material.Dark
        }
        else {
            Material.background = "#f3f3f3"
            Material.foreground = "#000000"
            Material.primary = "#f3f3f3"
            Material.accent = "#9cbdec"
            Material.theme = Material.Light
        }
    }

    Settings {
            id: mainSettings
            property alias hpSettings: window.hp
            property alias volumeSettings: audioPlayer.volume
            property alias isDarkThemeSettings: window.isDarkTheme
        }

    Dialog {
        id: aboutDialog
        modal: true
        focus: true
        title: "About"
        x: (parent.width - width) / 2
        y: (parent.height - height) / 2
        width: parent.width*0.7
        contentHeight: aboutColumn.height

        Column {
            id: aboutColumn
            spacing: 20

            Label {
                width: aboutDialog.availableWidth
                text: "Belarus radio\nVersion 0.1"
                wrapMode: Label.Wrap
                verticalAlignment: Text.AlignVCenter
                horizontalAlignment: Text.AlignHCenter
                font.pixelSize: Qt.platform.os === "windows" ? 12 : 14
            }

            Label {
                width: aboutDialog.availableWidth
                text: "Contact the developer:"
                    + "<br><style type=\"text/css\"></style><a href=\"mailto:soldimge@gmail.com?subject=Belarus radio%20android%20app\">soldimge@gmail.com</a><br>"
                wrapMode: Label.Wrap
                font.pointSize: Qt.platform.os === "windows" ? 10 : 14
                onLinkActivated: Qt.openUrlExternally(link)
                verticalAlignment: Text.AlignVCenter
                horizontalAlignment: Text.AlignHCenter
            }
        }
    }

    Dialog {
        id: dial
        title: "Закрыть и выйти?"
        modal: true
        x: (parent.width - width) / 2
        y: (parent.height - height) / 2
        standardButtons: Dialog.Ok | Dialog.Cancel
        onAccepted: Qt.callLater(Qt.quit)
    }

    Dialog {
        id: dialNoConnection
        title: "Проверьте подключение к сети"
        modal: true
        x: (parent.width - width) / 2
        y: (parent.height - height) / 2
        standardButtons: Dialog.Ok
        onAccepted: {
            dialNoConnection.close()
            backEnd.retry()
        }
    }

    Menu {
        id: menu
        width: 180
        x: parent.width - width
        y: 0
        MenuItem {
            id: mit1
            Column {
                id: col
                anchors.left: parent.left
                anchors.leftMargin: 10
                anchors.right: parent.right
                anchors.rightMargin: 10
                Label
                {
                    anchors.left: parent.left
                    anchors.leftMargin: 5
                    anchors.right: parent.right
                    anchors.rightMargin: 5
                    text: "\nГромкость:       " + Math.round(volumeSlider.value * 100) + "%"
                }
                Slider {
                    id: volumeSlider
                    anchors.left: parent.left
                    anchors.leftMargin: 10
                    anchors.right: parent.right
                    anchors.rightMargin: 10
                    orientation: Qt.Horizontal
                    value: 1
                    stepSize : 0.01
                    snapMode : Slider.SnapAlways
                }
                }
            height: col.height
        }
        MenuItem {
            text: "Перейти на сайт"
            onClicked: Qt.openUrlExternally(hp)
        }
        MenuItem {
            text: isDarkTheme == true ? qsTr("Light theme") : qsTr("Standard theme")
            onTriggered: {
                isDarkTheme = (isDarkTheme == true) ? false : true
            }
        }
        MenuItem {
            text: "О приложении"
            onTriggered: {
                aboutDialog.open()
            }
        }
        MenuSeparator {
            width: parent.width
            padding: 0
            topPadding: 4
            bottomPadding: 4
        }
        MenuItem {
            text: "Выход"
            onClicked: Qt.callLater(Qt.quit)
        }
    }

    SwipeView {
        id: swipeView
        anchors.fill: parent
        HomePage {
            states: [
                    State { name: "http://live.novoeradio.by:8000/novoeradio-128k" },
                    State { name: "https://advertizer.hoster.by/unistar/unistar-128kb/icecast.audio" },
                    State { name: "https://stream.hoster.by/rusradio/russkoe/icecast.audio?magic=true" }, //
                    State { name: "https://stream2.datacenter.by/energy" },
                    State { name: "http://de.streams.radioplayer.by:8000/live" }, //
                    State { name: "http://93.84.112.253:8010/MV128" },
                    State { name: "http://live.humorfm.by:8000/radiorelax" },
                    State { name: "https://stream.hoster.by/pilotfm/audio/icecast.audio" }, //
                    State { name: "https://video.tvr.by:8443/radiusfm" }, //
                    State { name: "http://93.125.106.180:8000/BA128" },
                    State { name: "http://live.legendy.by:8000/legendyfm" },
                    State { name: "https://sv.wargaming.fm/1/128" },
                    State { name: "http://live.humorfm.by:8000/avtoradio" },
                    State { name: "https://live.novoeradio.by:444/live/narodnoeradio_aac128/icecast.audio" }, //
                    State { name: "http://live.humorfm.by:8000/veseloe" },
                    State { name: "https://a1.radioheart.ru:9003/RH17982" },
                    State { name: "https://stream.hoster.by/pilotfm/pilot/icecast.audio" }, //
                    State { name: "https://s.aplus.fm/aplus_128" },
                    State { name: "https://stream.hoster.by/ont/centerfm/icecast.audio" },
                    State { name: "https://c28.radioboss.fm:18099/stream" },
                    State { name: "http://93.84.112.253:8039/stream" }
                ]

            roundButton1.onClicked:
            {
             if (roundButton1.text == "►")
             {
                 audioPlayer.source = states[comboBox.currentIndex].name
                 audioPlayer.play()
                 comboBox.displayText = comboBox.model[comboBox.currentIndex]
                 backEnd.but_click(comboBox.currentIndex)
                 roundButton1.text = "||"
                 roundButton1.leftPadding = 12
                 roundButton1.font.pointSize = 34
             }
             else
             {
                 audioPlayer.stop()
                 roundButton1.text = "►"
                 roundButton1.leftPadding = 21
                 roundButton1.font.pointSize = 50
             }
            }

            comboBox.onActivated:
            {
                roundButton1.text = "||"
                roundButton1.leftPadding = 12
                roundButton1.font.pointSize = 34
                audioPlayer.source = states[comboBox.currentIndex].name
                audioPlayer.play()
                comboBox.displayText = comboBox.model[comboBox.currentIndex]
                backEnd.but_click(comboBox.currentIndex)
                text1.text = comboBox.displayText
            }
        }
    }

    Audio {
            id: audioPlayer
            audioRole: Audio.MusicRole
            source: " "
            autoLoad: false
            autoPlay: true
            volume: mainSettings.value("volumeSettings", 1)
        }
}



