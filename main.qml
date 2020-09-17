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
            comboBox.onActivated:
            {
                roundButton1.text = "||"
                roundButton1.leftPadding = 12
                roundButton1.font.pointSize = 34
                if(comboBox.currentIndex == 0)
                {
                    comboBox.displayText = "В Эфире"
                    webView.url = "https://live.novoeradio.by:444/live/novoeradio_aac128/icecast.audio"
                    backEnd.but_click(1)
                    text1.text = "В Эфире"
                }
                else if(comboBox.currentIndex == 1)
                {
                    comboBox.displayText = "Top 100"
                    webView.url = "https://live.novoeradio.by:444/live/novoeradio_TOP100_aac128/icecast.audio"
                    backEnd.but_click(2)
                    text1.text = "Top 100"
                }
                else if(comboBox.currentIndex == 2)
                {
                    comboBox.displayText = "MegaMix"
                    webView.url = "https://live.novoeradio.by:444/live/novoeradio_megamix_aac128/icecast.audio"
                    backEnd.but_click(3)
                    text1.text = "MegaMix"
                }
                else if(comboBox.currentIndex == 3)
                {
                    comboBox.displayText = "Fresh"
                    webView.url = "https://live.novoeradio.by:444/live/novoeradio_fresh_aac128/icecast.audio"
                    backEnd.but_click(4)
                    text1.text = "Fresh"
                }
                else if(comboBox.currentIndex == 4)
                {
                    comboBox.displayText = "Wake Up Show"
                    webView.url = "https://live.novoeradio.by:444/live/novoeradio_wakeupshow_aac128/icecast.audio"
                    backEnd.but_click(5)
                    text1.text = "Wake Up Show"
                }
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
                 if(comboBox.currentIndex == 0)
                 {
                     comboBox.displayText = "В Эфире"
                     webView.url = "https://live.novoeradio.by:444/live/novoeradio_aac128/icecast.audio"
                     backEnd.but_click(1)
                     text1.text = "В Эфире"
                 }
                 else if(comboBox.currentIndex == 1)
                 {
                     comboBox.displayText = "Top 100"
                     webView.url = "https://live.novoeradio.by:444/live/novoeradio_TOP100_aac128/icecast.audio"
                     backEnd.but_click(2)
                     text1.text = "Top 100"
                 }
                 else if(comboBox.currentIndex == 2)
                 {
                     comboBox.displayText = "MegaMix"
                     webView.url = "https://live.novoeradio.by:444/live/novoeradio_megamix_aac128/icecast.audio"
                     backEnd.but_click(3)
                     text1.text = "MegaMix"
                 }
                 else if(comboBox.currentIndex == 3)
                 {
                     comboBox.displayText = "Fresh"
                     webView.url = "https://live.novoeradio.by:444/live/novoeradio_fresh_aac128/icecast.audio"
                     backEnd.but_click(4)
                     text1.text = "Fresh"
                 }
                 else if(comboBox.currentIndex == 4)
                 {
                     comboBox.displayText = "Wake Up Show"
                     webView.url = "https://live.novoeradio.by:444/live/novoeradio_wakeupshow_aac128/icecast.audio"
                     backEnd.but_click(5)
                     text1.text = "Wake Up Show"
                 }
                 roundButton1.text = "||"
                 backEnd.but_click(comboBox.currentIndex + 1)
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

//        Page2Form {
//            roundButton2.onClicked:
//            {
//                if (roundButton2.text == "►")
//                {
//                    webView.url = "https://live.novoeradio.by:444/live/novoeradio_TOP100_aac128/icecast.audio"
//                    roundButton2.text = "||"
//                    backEnd.but_click(2)
//                }
//                else
//                {
//                    webView.url = " "
//                    roundButton2.text = "►"
//                    roundButton1.highlighted = true
//                }
//            }
//        }

//        Page3Form {
//            roundButton3.onClicked:
//            {
//                if (roundButton3.text == "►")
//                {
//                    webView.url = "https://live.novoeradio.by:444/live/novoeradio_megamix_aac128/icecast.audio"
//                    roundButton3.text = "||"
//                    backEnd.but_click(3)
//                }
//                else
//                {
//                    webView.url = " "
//                    roundButton3.text = "►"
//                    roundButton1.highlighted = true
//                }
//            }
//        }

//        Page4Form {
//            roundButton4.onClicked:
//            {
//                if (roundButton4.text == "►")
//                {
//                    webView.url = "https://live.novoeradio.by:444/live/novoeradio_fresh_aac128/icecast.audio"
//                    roundButton4.text = "||"
//                    backEnd.but_click(4)
//                }
//                else
//                {
//                    webView.url = " "
//                    roundButton4.text = "►"
//                    roundButton1.highlighted = true
//                }
//            }
//        }

//        Page5Form {
//            roundButton5.onClicked:
//            {
//                if (roundButton5.text == "►")
//                {
//                    webView.url = "https://live.novoeradio.by:444/live/novoeradio_wakeupshow_aac128/icecast.audio"
//                    roundButton5.text = "||"
//                    backEnd.but_click(5)
//                }
//                else
//                {
//                    webView.url = " "
//                    roundButton5.text = "►"
//                    roundButton1.highlighted = true
//                }
//            }
//        }
    }

//    footer : PageIndicator {
//        id: pageIndicator
//        interactive: true
//        count: swipeView.count
//        currentIndex: swipeView.currentIndex
////        anchors.bottom: swipeView.bottom
////        anchors.bottomMargin: parent.height/36
//        anchors.horizontalCenter: parent.horizontalCenter
////        scale: 3
//    }

    WebView {
        id: webView
        anchors.fill: parent
        visible: false
//        url: initialUrl
        onLoadingChanged: {
            if (loadRequest.errorString)
                console.error(loadRequest.errorString);
        }
    }
}





//    footer: TabBar {
//        id: tabBar
//        currentIndex: swipeView.currentIndex

//        TabButton {
//            text: "В эфире"
//        }
//        TabButton {
//            text: "Top 100"
//        }
//        TabButton {
//            text: "MegaMix"
//        }
//        TabButton {
//            text: "Fresh"
//        }
//        TabButton {
//            text: "Wake up show"
//        }
    //    }

//    visible: false
//    x: initialX
//    y: initialY
//    width: initialWidth
//    height: initialHeight
//    title: webView.title

//    toolBar: ToolBar {
//        id: navigationBar
//        RowLayout {
//            anchors.fill: parent
//            spacing: 0

//            ToolButton {
//                id: backButton
//                tooltip: qsTr("Back")
//                iconSource: "images/left-32.png"
//                onClicked: webView.goBack()
//                enabled: webView.canGoBack
//                Layout.preferredWidth: navigationBar.height
//                style: ButtonStyle {
//                    background: Rectangle { color: "transparent" }
//                }
//            }

//            ToolButton {
//                id: forwardButton
//                tooltip: qsTr("Forward")
//                iconSource: "images/right-32.png"
//                onClicked: webView.goForward()
//                enabled: webView.canGoForward
//                Layout.preferredWidth: navigationBar.height
//                style: ButtonStyle {
//                    background: Rectangle { color: "transparent" }
//                }
//            }

//            ToolButton {
//                id: reloadButton
//                tooltip: webView.loading ? qsTr("Stop"): qsTr("Refresh")
//                iconSource: webView.loading ? "images/stop-32.png" : "images/refresh-32.png"
//                onClicked: webView.loading ? webView.stop() : webView.reload()
//                Layout.preferredWidth: navigationBar.height
//                style: ButtonStyle {
//                    background: Rectangle { color: "transparent" }
//                }
//            }

//            Item { Layout.preferredWidth: 5 }

//            TextField {
//                Layout.fillWidth: true
//                id: urlField
//                inputMethodHints: Qt.ImhUrlCharactersOnly | Qt.ImhPreferLowercase
//                text: webView.url

//                onAccepted: webView.url = utils.fromUserInput(text)

//                ProgressBar {
//                    anchors.centerIn: parent
//                    style: LoadProgressStyle { }
//                    z: Qt.platform.os === "android" ? -1 : 1
//                    visible: showProgress
//                    minimumValue: 0
//                    maximumValue: 100
//                    value: webView.loadProgress == 100 ? 0 : webView.loadProgress
//                }
//            }

//            Item { Layout.preferredWidth: 5 }

//            ToolButton {
//                id: goButton
//                text: qsTr("Go")
//                Layout.preferredWidth: navigationBar.height
//                onClicked: {
//                    Qt.inputMethod.commit()
//                    Qt.inputMethod.hide()
//                    webView.url = utils.fromUserInput(urlField.text)
//                }
//                style: ButtonStyle {
//                    background: Rectangle { color: "transparent" }
//                }
//            }

//            Item { Layout.preferredWidth: 10 }
//        }
//    }

//    statusBar: StatusBar {
//        id: statusBar
//        visible: showProgress
//        RowLayout {
//            anchors.fill: parent
//            Label { text: webView.loadProgress == 100 ? qsTr("Done") : qsTr("Loading: ") + webView.loadProgress + "%" }
//        }
//    }
