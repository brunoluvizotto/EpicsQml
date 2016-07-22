import QtQuick 2.7
import QtQuick.Controls 2.0
import QtQuick.Controls.Material 2.0
import QtWebSockets 1.0
import QtQml 2.2
import QtQuick.Extras 1.4
import "Pv.js" as PvJs
import "."

Rectangle {
    id: appWindow
    visible: true

    height: 600
    width: 400

    //Material.theme: Material.Dark
    //Material.accent: Material.Purple

    property var pvs: ["BBB01{Temp-BBB}OUT", "BBB01{MOTION:31}IN", "BBB01{LED:0}OUT", "BBB01{LED:0}Trigger", "BBB01{LED:1}OUT", "BBB01{LED:1}Trigger", "BBB01{LED:2}OUT", "BBB01{LED:2}Trigger", "BBB01{LED:3}OUT", "BBB01{LED:3}Trigger"]
    property var pvsWritable: ["no", "bitRO", "bit", "intEnum", "bit", "intEnum", "bit", "intEnum", "bit", "intEnum"]
    property variant pvsAdded: []
    property int pvsCount: 0

    property string localUrl: "ws://192.168.1.5:8888/monitor"
    property string remoteUrl: "ws://24.190.236.71:8888/monitor"

    WebSocket {
        id: socket
        url: localUrl //"ws://192.168.1.10:8890/monitor" //192.168.1.5:8888/monitor"
        onTextMessageReceived: {
            PvJs.parseMessage(message)
            //messageBox.text = messageBox.text + "\nReceived message: " + message
        }
        onStatusChanged: {
            if (socket.status == WebSocket.Error) {
                console.log("Error: " + socket.errorString)
                active = false
                for(var i = 0; i < pvsListView.model.count; ++i)
                    pvsListView.model.set(i, {"pvConn":false})
                if (socket.errorString == "Host not found" ||
                        socket.errorString == "Connection timed out" ||
                        socket.errorString == "Invalid socket descriptor")
                    url = remoteUrl//"ws://24.190.236.71:8888/monitor"
                console.log(url)
            }

            else if (socket.status == WebSocket.Open) {
                timer.stop()
                console.log("Open")

                pvsListModel.clear()
                pvsCount = 0
                //if (!pvsCount)
                for (var i = 0; i < pvs.length; ++i)
                {
                    PvJs.createPvsObjects(pvs[i], pvsWritable[i])
                }
            }

            else if (socket.status == WebSocket.Closed) {
                console.log("Socket closed")
                //active = true
            }
        }
        active: true//false

    }

    Timer {
        id: timer
        interval: 1000
        running: socket.status !== WebSocket.Open && socket.status !== WebSocket.Connecting
        Component.onCompleted: start()
        onTriggered:
        {
            socket.active = false
            socket.url = remoteUrl //"ws://24.190.236.71:8890/monitor"
            socket.active = true
        }
    }

    Page {
        id: screen
        anchors.fill: parent
        //color: "transparent"
        header: ToolBar {
                Label {
                    text: view.currentIndex == 0 ? "PVs" : view.currentIndex == 1 ? "RokuTV" : "EpisQML"
                    font.pixelSize: 20
                    anchors.centerIn: parent
                }
            }

        /*Drawer {
            id: drawer
            contentItem: Rectangle {
                width: screen.width * 0.4
                height: screen.height
                color: "red"
                transform: Translate {
                    x: (1.0 - drawer.position) * screen.width
                }
            }
        }*/

        SwipeView {
            id: view

            currentIndex: 0
            //anchors.fill: parent
            anchors {
                top: parent.top
                left: parent.left
                right: parent.right
                bottom: parent.bottom
                bottomMargin: indicator.height
            }

            Page {
                id: firstPage
                Rectangle {
                    id: listRectangle
                    anchors {
                        top: parent.top
                        //topMargin: screen.height * 0.01
                        bottom: parent.bottom
                        right: parent.right
                    }
                    width: parent.width
                    color: "transparent"
                    Behavior on width { PropertyAnimation { easing.type: Easing.InOutBack; duration: 200; easing.overshoot: 2} }
                    //Behavior on width { SpringAnimation { spring: 5; damping: 0.3 } }

                    property int menusOpen: 0

                    ListModel {
                        id: pvsListModel
                    }

                    Component {
                        id: pvsDelegate
                        Item {
                            id: container
                            height: textValue.height * 2.4
                            width: ListView.view.width;

                            property string timestamp: pvTimestamp
                            property var date: new Date(0)
                            property string humanTimestamp: ""

                            onTimestampChanged:
                            {
                                date = new Date(pvTimestamp * 1000);
                                humanTimestamp = date.getHours() + ':' + ("0" + date.getMinutes()).substr(-2) + ':' + ("0" + date.getSeconds()).substr(-2);
                                //console.log(humanTimestamp)
                            }

                            Rectangle {
                                id: rectangleContainer
                                anchors.fill: parent
                                color: "transparent"
                                //border.width: 1
                                MouseArea {
                                    anchors.fill: parent
                                    hoverEnabled: true
                                    onClicked:
                                    {
                                        //notificationClient.notification = "User is happy!"
                                        container.ListView.view.currentIndex = index
                                        container.forceActiveFocus()
                                        /*console.log(pvsListView.model.get(container.ListView.view.currentIndex).menuVisible)
                                        if(!menu.visible)
                                        {
                                            if(!listRectangle.menusOpen)
                                                menu.open()
                                            else
                                            {
                                                pvsListView.model.get(container.ListView.view.currentIndex).menuVisible = false
                                                console.log(pvsListView.currentItem.childAt(50,50))//.menu.close()
                                            }
                                        }
                                        else
                                            menu.close()*/
                                    }
                                }

                                StatusIndicator {
                                    id: containerConnected
                                    height: textValue.height * 0.75
                                    width: height
                                    anchors {
                                        left: parent.left
                                        leftMargin: firstPage.width * 0.03
                                        top: parent.top
                                        topMargin: firstPage.height * 0.025 //6
                                    }
                                    color: "chartreuse"
                                    active: pvConn
                                }
                                Label {
                                    id: textName
                                    anchors {
                                        left: containerConnected.right
                                        leftMargin: firstPage.width * 0.03
                                        right: switchOn.left
                                        rightMargin: firstPage.width * 0.03
                                        verticalCenter: containerConnected.verticalCenter
                                    }
                                    width: container.width * 0.6
                                    clip: true
                                    text: "<b>PV: </b>" + pvName
                                    font.pixelSize: screen.height * 0.0275
                                }

                                Label {
                                    id: textValue
                                    property var enums: (pvEnumStrs !== null) && (pvWritable == "bit" || pvWritable == "bitRO") ? pvEnumStrs : ({"count": 0})
                                    anchors.top: textName.bottom
                                    anchors.topMargin: firstPage.height * 0.006
                                    anchors.left: textName.left
                                    anchors.right: textTime.left
                                    anchors.rightMargin: firstPage.width * 0.03
                                    clip: true
                                    text: pvWritable == "intEnum" ? "<b>Value: </b>" + pvValue + " (" + comboEnum.currentText + ") " + pvEgu : (pvWritable == "bit" || pvWritable == "bitRO") && enums !== null && typeof enums !== 'undefined' && enums.count > 0 ? "<b>Value: </b>" + pvValue + " (" + enums.get(pvValue).item + ") " + pvEgu : "<b>Value: </b>" + pvValue + " " + pvEgu
                                    color: pvStatus == 4 ? "orange" : pvStatus == 3 ? "red" : pvStatus == 6 ? "#000080" : pvStatus == 5 ? "blue" : "black"
                                    font.pixelSize: screen.height * 0.0275
                                }
                                Label {
                                    id: textTime
                                    anchors.verticalCenter: textValue.verticalCenter
                                    anchors.right: parent.right
                                    anchors.rightMargin: firstPage.width * 0.03 * 4
                                    text: "<b>Time: </b>" + humanTimestamp
                                    font.pixelSize: screen.height * 0.0275
                                }
                                Switch {
                                    property bool value: pvValue == "1" ? true : false
                                    id: switchOn
                                    visible: pvWritable == "bit"
                                    anchors.verticalCenter: textName.verticalCenter
                                    anchors.right: parent.right
                                    anchors.rightMargin: firstPage.width * 0.03
                                    height: textValue.height * 2
                                    width: 2 * height
                                    checked: value
                                    onCheckedChanged:
                                    {
                                        if(checked == "1")
                                            socket.sendTextMessage(JSON.stringify({ "action":"setpv", "pv":pvName , "value":"1"}))
                                        else
                                            socket.sendTextMessage(JSON.stringify({ "action":"setpv", "pv":pvName , "value":"0"}))
                                    }
                                }
                                ComboBox
                                {
                                    property int value: pvValue
                                    onValueChanged: currentIndex = value//console.log(value)

                                    property int firstValue: 0
                                    property var enums: (pvEnumStrs !== null) && visible ? pvEnumStrs : ({"count": 0})
                                    id: comboEnum
                                    model: enums
                                    visible: pvWritable == "intEnum"
                                    currentIndex: visible && pvValue >= 0 ? pvValue : 0
                                    anchors.verticalCenter: textName.verticalCenter
                                    anchors.verticalCenterOffset: -firstPage.height * 0.002
                                    anchors.right: parent.right
                                    anchors.rightMargin: firstPage.width * 0.03
                                    height: textValue.height * 1.3
                                    width: 4 * height

                                    Timer {
                                        // Timer para setar os valores iniciais do ComboBox
                                        id: timerCombobox
                                        property bool oneTime: false
                                        interval: 200
                                        running: parent.visible && parent.enums && !oneTime
                                        onTriggered:
                                        {
                                            if(parent.count)
                                            {
                                                parent.currentIndex = pvValue
                                                oneTime = true
                                            }
                                            else
                                                start()
                                        }
                                    }

                                    onCurrentIndexChanged:
                                    {
                                        if(count && timerCombobox.oneTime && currentIndex >= 0 && visible)
                                            socket.sendTextMessage(JSON.stringify({ "action":"setpv", "pv":pvName , "value":currentIndex}))

                                    }
                                }

                                /*Menu {
                                    id: menu
                                    y: parent.height
                                    x: (parent.width / 2) - (width / 2)
                                    visible: menuVisible
                                    closePolicy: Popup.CloseOnEscape | Popup.CloseOnReleaseOutside

                                    MenuItem {
                                        text: "New..."
                                    }
                                    MenuItem {
                                        text: "Open..."
                                    }
                                    MenuItem {
                                        text: "Save"
                                    }
                                    onOpened: {
                                        ++listRectangle.menusOpen
                                        menuVisible = true
                                    }
                                    onClosed:
                                    {
                                        --listRectangle.menusOpen
                                        menuVisible = false
                                    }
                                }*/
                            }
                        }
                    }

                    ListView {
                        id: pvsListView
                        spacing: firstPage.height * 0.0145
                        height: contentHeight + 16 > view.height ? view.height : contentHeight + 16 //(screen.height * 0.025 + 6) * pvsListView.model.count + 6
                        anchors {
                            top: parent.top
                            left: parent.left
                            leftMargin: firstPage.width * 0.015
                            right: parent.right
                            rightMargin: firstPage.width * 0.015
                        }

                        snapMode: ListView.SnapToItem
                        opacity: 1
                        clip: true
                        cacheBuffer: 4000
                        model: pvsListModel
                        delegate: pvsDelegate
                        focus: true
                    }

                    BusyIndicator {
                        id: busyIndicator
                        running: false
                        anchors.centerIn: parent
                    }
                }
            }
            Page {
                id: secondPage
                RokuControl {}
            }
            /*Item {
                id: thirdPage
            }*/
        }
        ToolBar{
            id: indicator
            height: indicatorPage.height
            width: parent.width
            anchors.bottom: parent.bottom
            anchors.horizontalCenter: parent.horizontalCenter
            position: ToolBar.Footer

            PageIndicator {
                id: indicatorPage
                count: view.count
                currentIndex: view.currentIndex
                anchors.centerIn: parent
            }
        }

/*
  Importantes:
  pvsListView.model.get(i).idText
  pvsListView.model.count
  pvsListModel.clear()
  pvsListModel.insert(index, {"pvName":name, "pvValue":value, "pvConn":conn, "pvEgu":egu})
  */

    }

}
