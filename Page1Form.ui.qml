import QtQuick 2.15
import QtQuick.Controls 2.15

Page {
    width: 768
    height: 1024
    property alias comboBox: comboBox
    property alias button: button
    property alias image: image
    property alias image1: image1
    property alias image2: image2
    property alias roundButton1: roundButton1
    property alias text1: text1
    property alias element: element
    property alias element2: element2
    property alias menu: menu
    property alias mit1: mit1
    property alias mit2: mit2
    property alias mit3: mit3
    property alias mit4: mit4
    property alias butMit4VK: butMit4VK
    property alias butMit4IN: butMit4IN
    property alias butMit4FB: butMit4FB
    property alias butMit4VB: butMit4VB
    property alias tButtonBack: tButtonBack

    Rectangle {
        id: rectangle1
        color: "#0b0d12"
        border.width: 0
        anchors.right: parent.right
        anchors.top: comboBox.bottom
        anchors.bottom: parent.bottom
        anchors.left: parent.left
    }

    Image {
        id: image2
        fillMode: Image.PreserveAspectFit
        anchors.top: rectangle3.bottom
        anchors.left: parent.left
        anchors.right: parent.right
        source: "qrc:/images/logog.png"
    }

    ComboBox {
        id: comboBox
        height: rectangle.height
        flat: true
        currentIndex: 0
        anchors.right: parent.right
        anchors.top: rectangle.bottom
        anchors.left: parent.left
        background: Rectangle
        {
            color: "#121c2f"
            border.width: 0
        }
        model: ["В Эфире", "Top 100", "MegaMix", "Fresh", "Wake Up Show"]

        delegate: ItemDelegate {
            width: comboBox.width
            contentItem: Text {
                text: modelData
                color: "#9cbdec"
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
            color: "#9cbdec"
            font.pointSize: 25
            verticalAlignment: Text.AlignVCenter
        }
        popup: Popup {
            width: comboBox.width
            x: swipeView.width - width
            y: comboBox.height - height
            leftPadding: 0
            implicitHeight: contentItem.implicitHeight
            padding: 0
            contentItem: ListView {
                clip: true
                implicitHeight: contentHeight
                model: comboBox.popup.visible ? comboBox.delegateModel : null
                currentIndex: comboBox.highlightedIndex
            }
        }
    }

    Image {
        id: image1
        fillMode: Image.PreserveAspectFit
        anchors.top: rectangle3.bottom
        anchors.left: parent.left
        anchors.right: parent.right
        source: "qrc:/images/logog.png"
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
            target: backEnd // Указываем целевое соединение
            /* Объявляем и реализуем функцию, как параметр
             * объекта и с имененем похожим на название сигнала
             * Разница в том, что добавляем в начале on и далее пишем
             * с заглавной буквы
             * */
            onNetError: {
                dialNoConnection.visible = true
            }
            onSendToQml: {
                if (comboBox.currentIndex == 0)
                {
                    if (song1 != "")
                        text1.text = song1
                    else
                        text1.text = "В Эфире"
                }
                else if (comboBox.currentIndex == 1)
                {
                    if (song2 != "")
                        text1.text = song2
                    else
                        text1.text = "Top 100"
                }
                else if (comboBox.currentIndex == 2)
                {
                    text1.text = "MegaMix"
                    image1.source = "images/mm.jpg"
                }
                else if (comboBox.currentIndex == 3)
                {
                    if (song4 != "")
                        text1.text = song4
                    else
                        text1.text = "Fresh"
                }
                else if (comboBox.currentIndex == 4)
                {
                    text1.text = "Wake Up Show"
                    image1.source = "images/wus.jpg"
                }
            }
            onSendToQml_pic: {
                    image1.source = pic1
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
        height: roundButton1.height / 2
        color: "#16a251"
        border.width: 0
    }

    Label {
        id: text1
        color: "#16a251"
        text: "В эфире"
        horizontalAlignment: Text.AlignHCenter
        font.pointSize: 14
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

    Image {
        id: image
        anchors.top: rectangle3.top
        anchors.left: rectangle3.left
        anchors.bottom: rectangle3.bottom
        fillMode: Image.PreserveAspectFit
        source: "images/logoit.png"
    }


    Text {
        id: element
        anchors.top: rectangle3.bottom
        anchors.left: parent.left
        anchors.right: parent.right
        height: roundButton1.height
        text: "

 Новое Радио — радио современных хитов!
 - это лучшие современные популярные хиты для
 современных людей
 - это бодрое начало дня с командой Wake Up Show
  и современными хитами
 - это легкость рабочего дня с большим количеством
  современных хитов без рекламы и разговоров
 - это нескучный вечер после рабочего дня в
 компании современных хитов
 - это современные хиты для отличных выходных"
        horizontalAlignment: Text.AlignLeft
        textFormat: Text.AutoText
        verticalAlignment: Text.AlignTop
        visible: false
        font.pointSize: 14
        color: "#9cbdec"
    }
    Text {
        id: element2
        anchors.bottom: rectangle.top
        anchors.left: element.left
        anchors.right: parent.right
        height: roundButton1.height
        text: "
 Учредителем \"Нового Радио\" является Издательский Дом \"Проф-Пресс\" Федерации
 профсоюзов Беларуси.Дочернее радиовещательное унитарное предприятие «Новое радио».
 Свидетельство о государственной регистрации юридического лица: зарегистрировано
 решением Мингорисполкома в Едином государственном регистре юридических лиц и
 индивидуальных предпринимателей 30.01.2014 г. за № 190471246"
        visible: false
        font.pointSize: 8
        color: "#9cbdec"
    }

    ToolButton {
        id: button
        anchors.top: rectangle3.top
        anchors.bottom: rectangle3.bottom
        anchors.right: parent.right
//        icon.name: "menu"
        Text {
            anchors.centerIn: button
            text: "⋮"
            bottomPadding: 5
            horizontalAlignment: Text.AlignHCenter
            verticalAlignment: Text.AlignVCenter
            font.pointSize: 36
            color: "#ffffff"
        }
        highlighted: true
        font.pointSize: 28
    }

    ToolButton {
        id: tButtonBack
        anchors.top: rectangle3.top
        anchors.bottom: rectangle3.bottom
        anchors.right: button.left
//        anchors.rightMargin: button.width
        Text {
            anchors.centerIn: tButtonBack
            text: "×"
            horizontalAlignment: Text.AlignHCenter
            verticalAlignment: Text.AlignVCenter
            font.pointSize: 36
            color: "#ffffff"
        }
        highlighted: true
        font.pointSize: 28
        visible: false
    }

    Menu {
        id: menu
        width: 180
        x: parent.width - width
        y: 0
        MenuItem {
            id: mit1
            text: "О радио"
        }
        MenuItem {
            id: mit2
            text: "Перейти на сайт"
        }
        MenuItem {
            id: mit4
            Button {
                id: butMit4VK
                anchors.top: parent.top
                anchors.bottom: parent.bottom
                anchors.left: parent.left
                anchors.leftMargin: 3
                width: height*0.86
                flat: true
                highlighted: true
                Image {
                    anchors.fill: parent
                    anchors.centerIn: butMit4VK
                    fillMode: Image.PreserveAspectFit
                    source: "images/vk.png"
                    scale: 0.5
                }
            }
            Button {
                id: butMit4IN
                anchors.top: parent.top
                anchors.bottom: parent.bottom
                anchors.left: butMit4VK.right
                anchors.leftMargin: 3
                width: height*0.86
                flat: true
                highlighted: true
                Image {
                    anchors.fill: parent
                    anchors.centerIn: butMit4IN
                    fillMode: Image.PreserveAspectFit
                    source: "images/instagram.png"
                    scale: 0.5
                }
            }
            Button {
                id: butMit4FB
                anchors.top: parent.top
                anchors.bottom: parent.bottom
                anchors.left: butMit4IN.right
                anchors.leftMargin: 3
                width: height*0.86
                flat: true
                highlighted: true
                Image {
                    anchors.fill: parent
                    anchors.centerIn: butMit4FB
                    fillMode: Image.PreserveAspectFit
                    source: "images/fb.png"
                    scale: 0.5
                }
            }
            Button {
                id: butMit4VB
                anchors.top: parent.top
                anchors.bottom: parent.bottom
                anchors.left: butMit4FB.right
                anchors.leftMargin: 3
                width: height*0.86
                flat: true
                highlighted: true
                Image {
                    anchors.fill: parent
                    anchors.centerIn: butMit4VB
                    fillMode: Image.PreserveAspectFit
                    source: "images/viber.png"
                    scale: 0.5
                }
            }
        }
        MenuSeparator {
                    padding: 0
                    topPadding: 4
                    bottomPadding: 4
                    contentItem: Rectangle {
                    implicitWidth: 120
                    implicitHeight: 1
                    color: "#0b0d12"
                    }
        }
        MenuItem {
            id: mit3
            text: "Выход"
        }
    }

}

//#44aa3f
//#0b0d12
