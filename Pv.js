var pvStringCreation = 'import QtQuick 2.7; Item {property string name: ""; property string timestamp: ""; property string severity: ""; property int status: 0; property string egu: ""; property real value: 0; property string timeStamp: ""; property var enumStrs: ([]); property string count: ""; property bool conn: false; property int id: 0}'

function createPvsObjects(name, writable) {
    var component = Qt.createQmlObject(PvJs.pvStringCreation, appWindow, "pvObj" + pvsCount.toString())
    component.name = name
    //var component = Qt.createComponent("Pv.qml");
    //var pv = component.createObject(appWindow, {"name": name});

    pvsAdded.push(component)
    socket.sendTextMessage(JSON.stringify({ "action":"connect", "pv":name }))
    pvsListModel.insert(pvsCount, {"pvName":name, "pvValue":0, "pvEgu":"", "pvConn":false, "pvTimestamp":"", "pvCount":"", "pvSeverity":"0", "pvStatus":0, "pvEnumStrs":[], "pvWritable":writable, "menuVisible":false})
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
    if(typeof data['timestamp'] !== 'undefined')
    {
        currentPv.timestamp = data['timestamp']
        properties.pvTimestamp = currentPv.timestamp;
    }
    if(typeof data['severity'] !== 'undefined')
    {
        currentPv.severity = data['severity']
        properties.pvSeverity = currentPv.severity;
    }
    if(typeof data['status'] !== 'undefined')
    {
        currentPv.status = data['status']
        properties.pvStatus = currentPv.status;
    }

    if(typeof data['enum_strs'] !== 'undefined' && data['enum_strs'] !== null)
    {
        if(typeof currentPv.enumStrs !== 'undefined')
        {
            if(!currentPv.enumStrs.length)
            {
                currentPv.enumStrs = data['enum_strs']
                var objectEnum = []
                for(var i = 0; i < data['enum_strs'].length; ++i)
                    objectEnum.push({item: data['enum_strs'][i]})

                properties.pvEnumStrs = objectEnum//currentPv.enumStrs;
                //console.log(JSON.stringify(properties.pvEnumStrs))
            }
        }
        else
            properties.pvEnumStrs = []


    }
    //else
    //    properties.pvEnumStrs = []


    if(data['msg_type'] == "connection")
        if(data['conn'] == true)
        {
            socket.sendTextMessage(JSON.stringify({ "action":"get_enums", "pv":data['pvname'] }))
        }

    //console.log(data['enum_strs'])
    //return [indexPv, properties]
    pvsListView.model.set(indexPv, properties)
    //pvsListView.update()
}
