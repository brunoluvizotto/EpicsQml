import QtQuick 2.7
import QtQuick.Controls 2.0
import QtQuick.Controls.Material 2.0
import QtQuick.Extras 1.4

Rectangle {
    id: listRectangle
    anchors {
        top: parent.top
        topMargin: screen.height * 0.02
        bottom: parent.bottom
        right: parent.right
    }
    width: parent.width
    color: "transparent"
    Behavior on width { PropertyAnimation { easing.type: Easing.InOutBack; duration: 200; easing.overshoot: 2} }
    //Behavior on width { SpringAnimation { spring: 5; damping: 0.3 } }

    function createPvsObjects(name, writable) {
        var component = Qt.createQmlObject(PvJs.pvStringCreation, appWindow, "pvObj" + pvsCount.toString())
        component.name = name
        //var component = Qt.createComponent("Pv.qml");
        //var pv = component.createObject(appWindow, {"name": name});

        pvsAdded.push(component)
        socket.sendTextMessage(JSON.stringify({ "action":"connect", "pv":name }))
        pvsListModel.insert(pvsCount, {"pvName":name, "pvValue":"", "pvEgu":"", "pvConn":false, "pvTimestamp":"", "pvCount":"", "pvSeverity":"0", "pvWritable":writable})
        pvsCount++
        //pv1.currentPv = pvsAdded[0]

    }

    function parseMessage(received)
    {
        var data = JSON.parse(received);
        //console.log(received)
        //console.log(data['pvname'])
        //console.log('Index dessa pv: ' + pvs.indexOf(data['pvname']))
        //console.log('Objeto:? ' + pvsAdded[pvs.indexOf(data['pvname'])])
        var indexPv = pvs.indexOf(data['pvname'])
        var currentPv = pvsAdded[indexPv]
        var properties = {};

        if(typeof data['units'] !== 'undefined')
        {
            currentPv.egu = data['units']
            properties.pvEgu = currentPv.egu;
        }
        if(typeof data['timestamp'] !== 'undefined')
        {
            currentPv.timeStamp = data['timestamp']
            properties.pvTimestamp = currentPv.timeStamp;
        }
        if(typeof data['count'] !== 'undefined')
        {
            currentPv.count = data['count']
            properties.pvCount = currentPv.count;
        }
        if(typeof data['conn'] !== 'undefined')
        {
            currentPv.conn = data['conn']
            properties.pvConn = currentPv.conn;
        }
        if(typeof data['value'] !== 'undefined') //data['value'] == "0" || data['value'])
        {
            currentPv.value = data['value']
            properties.pvValue = currentPv.value;
        }
        if(typeof data['timestamp'] !== 'undefined') //data['value'] == "0" || data['value'])
        {
            currentPv.timestamp = data['timestamp']
            properties.pvTimestamp = currentPv.timestamp;
        }
        if(typeof data['severity'] !== 'undefined') //data['value'] == "0" || data['value'])
        {
            currentPv.severity = data['severity']
            properties.pvSeverity = currentPv.severity;
        }
        pvsListView.model.set(indexPv, properties)
        //pvsListView.update()
    }


    ListModel {
        id: pvsListModel
    }

    Component {
        id: pvsDelegate
        Item {
            id: container
            height: textValue.height * 2.2
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
                anchors.fill: parent
                color: "transparent"
                //color: dataMouseArea.beingPressed ? "yellow" : "white"
                Behavior on color {
                    ColorAnimation { from: "white"; easing.type: Easing.Linear; duration: 800 }
                }
                //border.width: 1
                MouseArea {
                    anchors.fill: parent
                    hoverEnabled: true
                    onClicked:
                    {
                        container.ListView.view.currentIndex = index
                        container.forceActiveFocus()
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
                        topMargin: firstPage.height * 0.011 //6
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
                    anchors.top: textName.bottom
                    anchors.topMargin: firstPage.height * 0.0035
                    anchors.left: textName.left
                    anchors.right: textTime.left
                    anchors.rightMargin: firstPage.width * 0.03
                    clip: true
                    text: "<b>Value: </b>" + pvValue + " " + pvEgu
                    color: pvSeverity == "1" ? "orange" : pvSeverity == "2" ? "red" : "black"
                    font.pixelSize: screen.height * 0.0275
                }
                Label {
                    id: textTime
                    anchors.top: textName.bottom
                    anchors.topMargin: firstPage.height * 0.0035
                    anchors.right: parent.right
                    anchors.rightMargin: firstPage.width * 0.03 * 4
                    text: "<b>Time: </b>" + humanTimestamp
                    font.pixelSize: screen.height * 0.0275
                }
                Switch {
                    property bool value: pvValue == "1" ? true : false
                    id: switchOn
                    visible: pvWritable
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
            }
        }
    }

    ListView {
        id: pvsListView
        spacing: firstPage.height * 0.0145
        height: contentHeight + 16 > parent.height ? parent.height : contentHeight + 16 //(screen.height * 0.025 + 6) * pvsListView.model.count + 6
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
