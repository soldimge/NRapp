import QtQuick 2.15
import QtQuick.Controls 2.15
import QtWebView 1.1
import QtQuick.Layouts 1.1
import QtQuick.Controls.Styles 1.2

ApplicationWindow {
    visible: true
    width: 768
    height: 1024

    onClosing: {
        close.accepted = false
        dial.visible = true
      }

    Dialog {
        id: dial
        visible: false
        title: "Закрыть и выйти?"
        modal: true
        Overlay.modal: Rectangle {
                    color: "#aacfdbe7"
                }
        x: (parent.width - width) / 2
        y: (parent.height - height) / 2
        contentItem: Rectangle {
            implicitWidth: 130
            implicitHeight: 40
            color: "#121c2f"
            Button {
                id: b1
                flat: true
                highlighted: true
                anchors.right: parent.right
                anchors.bottom: parent.bottom
                onClicked: Qt.callLater(Qt.quit)
                Text {
                    text: "Да"
                    color: "#9cbdec"
                    anchors.centerIn: parent
                }
            }
            Button {
                flat: true
                highlighted: true
                anchors.left: parent.left
                anchors.bottom: parent.bottom
                onClicked: dial.visible = false
                Text {
                    text: "Нет"
                    color: "#9cbdec"
                    anchors.centerIn: parent
                }
            }
        }
    }

    Dialog {
        id: dialNoConnection
        visible: false
        title: "Проверьте подключение к сети"
        modal: true
        Overlay.modal: Rectangle {
                    color: "#aacfdbe7"
                }
        x: (parent.width - width) / 2
        y: (parent.height - height) / 2
        contentItem: Rectangle {
            implicitWidth: parent.width
            implicitHeight: 40
            color: "#121c2f"
            Button {
                id: dNCb1
                width: parent.width / 3
                flat: true
                highlighted: true
                anchors.right: parent.right
                anchors.bottom: parent.bottom
                onClicked: {
                    dialNoConnection.visible = false
                    backEnd.retry()
                }
                Text {
                    text: "Повторить"
                    color: "#9cbdec"
                    anchors.centerIn: parent
                }
            }
        }
    }

    SwipeView {
        id: swipeView
        anchors.fill: parent
        Page1Form {
            states: [
                    State { name: "https://live.novoeradio.by:444/live/novoeradio_aac128/icecast.audio" },
                    State { name: "https://advertizer.hoster.by/unistar/unistar-128kb/icecast.audio" },
                    State { name: "https://stream.hoster.by/rusradio/russkoe/icecast.audio" },
                    State { name: "https://stream2.datacenter.by/energy" },
                    State { name: "http://de.streams.radioplayer.by:8000/live" },
                    State { name: "http://93.84.112.253:8010/MV128" },
                    State { name: "http://live.humorfm.by:8000/radiorelax" },
                    State { name: "https://stream.hoster.by/pilotfm/audio/icecast.audio" },
                    State { name: "https://video.tvr.by:8443/radiusfm" },
                    State { name: "http://93.125.106.180:8000/BA128" },
                    State { name: "http://live.legendy.by:8000/legendyfm" }
                ]
            comboBox.onActivated:
            {
                roundButton1.text = "||"
                roundButton1.leftPadding = 12
                roundButton1.font.pointSize = 34
                webView.url = states[comboBox.currentIndex].name
                comboBox.displayText = comboBox.model[comboBox.currentIndex]
                backEnd.but_click(comboBox.currentIndex)
                text1.text = comboBox.displayText
            }
            mit1.onClicked:
            {
                if(element.visible == false)
                {
                    element.visible = true
                    element2.visible = true
                    image1.visible = false
                    image2.visible = false
                    tButtonBack.visible = true
                }
            }
            tButtonBack.onClicked:
            {
                element.visible = false
                element2.visible = false
                image1.visible = true
                image2.visible = true
                tButtonBack.visible = false
            }
            mit2.onClicked:
            {
                 Qt.openUrlExternally("https://www.novoeradio.by/")
            }
            mit3.onClicked:
            {
                 Qt.callLater(Qt.quit)
            }
            button.onClicked:
            {
                 menu.open()
            }
            roundButton1.onClicked:
            {
             if (roundButton1.text == "►")
             {
                 webView.url = states[comboBox.currentIndex].name
                 comboBox.displayText = comboBox.model[comboBox.currentIndex]
                 backEnd.but_click(comboBox.currentIndex)
                 text1.text = comboBox.displayText
                 roundButton1.text = "||"
                 roundButton1.leftPadding = 12
                 roundButton1.font.pointSize = 34
             }
             else
             {
                 webView.url = " "
                 roundButton1.text = "►"
                 roundButton1.leftPadding = 21
                 roundButton1.font.pointSize = 50
             }
            }

            butMit4VK.onClicked:
            {
                 Qt.openUrlExternally("https://vk.com/club22730082")
            }
            butMit4IN.onClicked:
            {
                 Qt.openUrlExternally("https://instagram.com/novoeradio/")
            }
            butMit4FB.onClicked:
            {
                 Qt.openUrlExternally("https://www.facebook.com/novoeradio.by")
            }
            butMit4VB.onClicked:
            {
                 Qt.openUrlExternally("https://invite.viber.com/?g2=AQBMbJwidArNlkqg65%2FAF0N7KU%2FfpDR7%2FcVDBJuVzomWN%2BBT0ZKOmM4ur2CugiCG&lang=ru")
            }
        }
    }

    WebView {
        id: webView
        anchors.fill: parent
        visible: false
        onLoadingChanged: {
            if (loadRequest.errorString)
                console.error(loadRequest.errorString);
        }
    }
}



