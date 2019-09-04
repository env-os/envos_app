import 'package:flutter/material.dart';
import 'package:envos/models/Device.dart';
import 'package:envos/presenter/process_json.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';
import 'stream_view.dart';
import 'add_device_view.dart';
import 'package:http/http.dart';

class Choice {
  const Choice({this.title, this.icon});

  final String title;
  final IconData icon;
}

class DevicePage extends StatelessWidget {

  DevicePage(
      {Key key, this.auth, this.uuidArea, this.name, this.description, this.gatewayAddr})
      : super(key: key);
  final auth;
  final String uuidArea;
  final String name;
  final String description;
  final String gatewayAddr;


  List<Choice> choices = <Choice>[
    Choice(title: "Informazioni", icon: Icons.info),
    Choice(title: "Elimina area", icon: Icons.delete),
  ];

  void _deleteRequest() async {
    String url = gatewayAddr + '/users/' + auth.user.user.uid.toString() +
        '/areas/' + uuidArea;
    Client client = new Client();
    await client.delete(
        url,
        headers: {'authorization': "Bearer " + auth.token.token.toString()}
    );
  }

  @override
  Widget build(BuildContext context) {
    void _showDialog() {
      showDialog(context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: new Text(name),
              content: new Text(description),
            );
          }
      );
    }

    return Scaffold(
        appBar: AppBar(
          title: const Text("Devices"),
          actions: <Widget>[
            IconButton(
              icon: Icon(choices[0].icon),
              onPressed: () {
                _showDialog();
              },
            ),
            IconButton(
              icon: Icon(choices[1].icon),
              onPressed: () {
                _deleteRequest();
                Future.delayed(const Duration(milliseconds: 2000), () {
                  Navigator.pushReplacementNamed(context, "/home");
                });
              },
            )
          ],
        ),
        floatingActionButton: SpeedDial(
          marginRight: 18,
          marginBottom: 20,
          animatedIconTheme: IconThemeData(size: 22.0),
          animatedIcon: AnimatedIcons.menu_close,
          closeManually: false,
          curve: Curves.bounceIn,
          overlayColor: Colors.black,
          overlayOpacity: 0.5,
          heroTag: 'speed-dial-hero-tag',
          backgroundColor: Colors.blue,
          foregroundColor: Colors.white,
          elevation: 8.0,
          shape: CircleBorder(),
          children: [
            SpeedDialChild(
                child: Icon(Icons.devices),
                backgroundColor: Colors.blue,
                label: ' Add Device',
                labelStyle: TextStyle(fontSize: 18.0),
                onTap: () {
                  var addDeviceRoute = new MaterialPageRoute(
                      builder: (BuildContext context) =>
                      new AddDevice(
                        auth: auth,
                        uuid: uuidArea,
                        gatewayAddr: gatewayAddr,
                      ));
                  Navigator.push(context, addDeviceRoute);
                }
            )
          ],
        ),
        body: FutureBuilder<List<Device>>(
          future: fetchDevice(Client(), auth, uuidArea, gatewayAddr),
          builder: (context, snapshot) {
            if (snapshot.hasError) print(snapshot.error);

            return snapshot.hasData
                ? DeviceList(devices: snapshot.data,
                auth: auth,
                uuidArea: uuidArea,
                gatewayAddr: gatewayAddr)
                : Center(child: CircularProgressIndicator());
          },
        )
    );
  }
}

class ChoiceCard extends StatelessWidget {
  const ChoiceCard({Key key, this.choice}) : super(key: key);

  final Choice choice;

  @override
  Widget build(BuildContext context) {
    final TextStyle textStyle = Theme
        .of(context)
        .textTheme
        .display1;
    return Card(
      color: Colors.white,
      child: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Icon(choice.icon, size: 128.0, color: textStyle.color),
            Text(choice.title, style: textStyle),
          ],
        ),
      ),
    );
  }
}


class DeviceList extends StatelessWidget {
  final List<Device> devices;
  final auth;
  final String uuidArea;
  final String gatewayAddr;

  DeviceList(
      {Key key, this.devices, this.auth, this.uuidArea, this.gatewayAddr})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
        itemCount: devices.length,
        itemBuilder: (context, index) {
          return ListTile(
              title: Text(devices[index].name.toString()),
              subtitle: Text(devices[index].description.toString()),
              onTap: () {
                var deviceRoute = new MaterialPageRoute(
                    builder: (BuildContext context) =>
                    new StreamPage(
                      auth: auth,
                      gatewayAddr: gatewayAddr,
                      uuidArea: uuidArea,
                      uuidDevice: devices[index].uuid,
                      name: devices[index].name,
                      description: devices[index].description,
                      topic: devices[index].topic,
                      macaddress: devices[index].macaddress,
                      min: devices[index].min,
                      max: devices[index].max,
                    ));
                Navigator.push(context, deviceRoute);
              });
        });
  }
}