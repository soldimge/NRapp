import QtQuick 2.15
import QtQuick.Controls 2.15
import QtAndroidTools 1.0

Page {

    property alias comboBox: comboBox
    property alias button: button
    property alias image1: image1
    property alias image2: image2
    property alias roundButton1: roundButton1
    property alias text1: text1
//    property alias banner1: banner1
    property alias notification1: notification1

    QtAndroidNotification {
        id: notification1
        title: comboBox.model[comboBox.currentIndex]
        text: text1.text
        expandableText: text1.text
        channelName: "playing now info"
        smallIconName: "icon"
        largeIconSource: image1.source
    }

    Image {
        id: image2
        fillMode: Image.PreserveAspectFit
        anchors.top: parent.top
        anchors.left: parent.left
        anchors.right: parent.right
        source: "images/logo.png"
    }

    Image {
        id: image1
        fillMode: Image.PreserveAspectFit
        anchors.top: parent.top
        anchors.left: parent.left
        anchors.right: parent.right
        source: "images/logo.png"
        onSourceChanged: console.log("song logo updated")
        cache: false
    }

    ComboBox {
        id: comboBox
        height: rectangle.height
        currentIndex: 0
        anchors.right: parent.right
        anchors.top: rectangle.bottom
        anchors.left: parent.left
        background: Rectangle
        {
            color: isDarkTheme == true ? "#0000ffff" : "#d7d6d5"
            border.width: 0
        }
        model: ["Новое Радио", "Радио Unistar", "Русское Радио", "Energy FM", "Радио РОКС",
                "Мелодии Века", "Радыё Relax", "Душевное Радио", "Радиус FM", "Радио Би-Эй",
                "Легенды FM", "Wargaming FM", "Авторадио", "Народное Радио", "Юмор FM",
                "Radio 4you", "Пилот FM", "Radio Aplus", "Центр FM", "Радио s13", "Радио Брест"]

        delegate: ItemDelegate {
            width: comboBox.width
            contentItem: Text {
                text: modelData
                color: isDarkTheme == true ? "#9cbdec" : "#000000"
                font: comboBox.font
                elide: Text.ElideRight
                verticalAlignment: Text.AlignVCenter
                horizontalAlignment: Text.AlignHCenter
            }
            highlighted: comboBox.highlightedIndex === index
        }

        contentItem: Text {
            leftPadding: 20
            text: comboBox.displayText
            color: isDarkTheme == true ? "#9cbdec" : "#000000"
            font.pointSize: 25
            verticalAlignment: Text.AlignVCenter
        }
        popup: Popup {
            width: comboBox.width
            x: swipeView.width - width
            y: comboBox.height - height
            leftPadding: 0
            implicitHeight: rectangle1.y
            padding: 0
            contentItem: ListView {
                clip: true
                implicitHeight: contentHeight
                model: comboBox.popup.visible ? comboBox.delegateModel : null
                currentIndex: comboBox.highlightedIndex
            }
        }
    }

    Rectangle {
        id: rectangle2
        color: "#181a1f"
        anchors.right: rectangle.left
        anchors.left: parent.left
        anchors.top: rectangle.top
        anchors.bottom: rectangle.bottom
    }

    Connections {
            target: backEnd

            onNetError: {
                dialNoConnection.open()
            }
            onSendToQml: {
                if (comboBox.currentIndex != 4)
                {
                    if (song != "")
                        text1.text = song
                }
                else
                    text1.text = comboBox.model[comboBox.currentIndex]
                notification1.cancel()
                notification1.largeIconSource = image1.source
                notification1.title = comboBox.model[comboBox.currentIndex]
                notification1.text = text1.text
                notification1.expandableText = text1.text
                notification1.show()
            }
            onSendToQml_pic: {
                banner1.show()
                image1.source = pic1
            }
            onSendToQml_homePage: {
                hp = homepage
                image.source = radioLogo
            }
            onSendSettings: {
                comboBox.currentIndex = id
                comboBox.displayText = comboBox.model[comboBox.currentIndex]
            }
            onStop: {
                audioPlayer.stop()
                roundButton1.text = "►"
                roundButton1.leftPadding = 21
                roundButton1.font.pointSize = 50
            }
            onPlay: {
                roundButton1.clicked()
            }
        }

    Rectangle {
        id: rectangle
        anchors.top: roundButton1.top
        anchors.topMargin: 6
        anchors.bottom: roundButton1.bottom
        anchors.bottomMargin: 6
        anchors.left: roundButton1.right
        anchors.right: parent.right
        height: roundButton1.height
        color: "#181a1f"
        border.width: 0
    }

    Rectangle {
        id: rectangle3
        anchors.right: parent.right
        anchors.top: parent.top
        anchors.left: parent.left
        height: rectangle.height / 2
        color: "#61181a1f"
        border.width: 0

        Image {
            id: image
            opacity: 0.7
            anchors.top: parent.top
            anchors.bottom: parent.bottom
            anchors.left: parent.left
            source: "http://cdn.onlineradiobox.com/img/logo/0/370.v23.png"
            fillMode: Image.PreserveAspectFit
            onSourceChanged: console.log("radio logo updated")
        }
    }

    Label {
        id: text1
        color: "#ffffff"
        text: "В эфире"
        horizontalAlignment: Text.AlignHCenter
        font.pointSize: 13
        anchors.centerIn: rectangle
    }

    Button {
        id: roundButton1
        width: parent.width/3.45
        height: width
        anchors.left: parent.left
        anchors.top: image2.bottom
        anchors.topMargin: -6
        text: "►"
        smooth: true
        font.bold: true
        bottomPadding: 18
        leftPadding: 21
        font.family: "Verdana"
        highlighted: true
        font.pointSize: 50
        autoExclusive: false
    }

    ToolButton {
        id: button
        anchors.top: rectangle3.top
        anchors.bottom: rectangle3.bottom
        anchors.right: parent.right
        Image {
            id: toolButton3Pic
            anchors.fill: parent
            anchors.centerIn: parent
            fillMode: Image.PreserveAspectFit
            source: "qrc:/images/menu.png"
            scale: 0.5
        }
        onClicked: menu.open()
    }

//    ToolButton {
//        id: button
//        anchors.top: rectangle3.top
//        anchors.bottom: rectangle3.bottom
//        anchors.right: parent.right

//        Text {
//            anchors.centerIn: button
//            text: "⋮"
//            bottomPadding: 5
//            horizontalAlignment: Text.AlignHCenter
//            verticalAlignment: Text.AlignVCenter
//            font.pointSize: 36
//            color: "#ffffff"
//        }
//        font.pointSize: 28
//        onClicked: menu.open()
//    }

    Rectangle {
        id: rectangle1
        color: isDarkTheme == true ? "#000000" : "#f3f3f3"
        border.width: 0
        anchors.right: parent.right
        anchors.top: comboBox.bottom
        anchors.bottom: parent.bottom
        anchors.left: parent.left
        QtAndroidAdMobBanner {
            id: banner1
            anchors.left: parent.left
            anchors.right: parent.right
            anchors.bottom: parent.bottom
            unitId: "ca-app-pub-3166358032711654/6170347050"
            type: QtAndroidAdMobBanner.TYPE_SMART_BANNER
            keywords: ["keyword_1", "keyword_2", "keyword_3"]
        }
    }
}

