import 'package:flutter/material.dart';
import 'package:envos/models/Area.dart';
import 'package:envos/presenter/process_json.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';
import 'package:http/http.dart' as http;
import 'package:envos/view/device_view.dart';


class AreasPage extends StatelessWidget {

  AreasPage({Key key, this.title, this.auth, this.gatewayAddr})
      : super(key: key);
  final auth;
  final String title;
  final String gatewayAddr;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(title),
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
                child: Icon(Icons.add_box),
                backgroundColor: Colors.blue,
                label: ' Add Area',
                labelStyle: TextStyle(fontSize: 18.0),
                onTap: () {
                  Navigator.pushNamed(context, '/addarea');
                }
            )
          ],
        ),
        drawer: Drawer(
          child: ListView(
            padding: EdgeInsets.zero,
            children: <Widget>[
              DrawerHeader(
                child: Text(auth.user.user.email.toString()),
                decoration: BoxDecoration(
                  color: Colors.blue,
                ),
              ),
              ListTile(
                title: Text('Logout'),
                onTap: () {
                  auth.Logout();
                  Navigator.pushReplacementNamed(context, '/');
                },
              ),

            ],
          ),
        ),
        body: FutureBuilder<List<Area>>(
          future: fetchAreas(http.Client(), auth, gatewayAddr),
          builder: (context, snapshot) {
            if (snapshot.hasError) print(snapshot.error);

            return snapshot.hasData
                ? AreaList(
                areas: snapshot.data, auth: auth, gatewayAddr: gatewayAddr)
                : Center(child: CircularProgressIndicator());
          },
        )
    );
  }
}

class AreaList extends StatelessWidget {
  final List<Area> areas;
  final auth;
  final String gatewayAddr;

  AreaList({Key key, this.areas, this.auth, this.gatewayAddr})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
      ),
      itemCount: areas.length,
      itemBuilder: (context, index) {
        return RaisedButton(
            onPressed: () {
              var deviceRoute = new MaterialPageRoute(
                  builder: (BuildContext context) =>
                  new DevicePage(
                    auth: auth,
                    uuidArea: areas[index].uuid,
                    name: areas[index].name,
                    description: areas[index].description,
                    gatewayAddr: gatewayAddr,
                  ));
              Navigator.push(context, deviceRoute);
            },
            color: Colors.white70,
            textColor: Colors.black,
            padding: const EdgeInsets.all(10.10),
            splashColor: Colors.blueAccent,
            child: Text(areas[index].name,
                style: TextStyle(fontSize: 20))

        );
      },
    );
  }
}