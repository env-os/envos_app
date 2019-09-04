import 'dart:async';
import 'package:flutter/material.dart';
import 'package:envos/models/Device.dart';
import 'package:envos/presenter/process_json.dart';
import 'package:http/http.dart' as http;
import 'package:envos/presenter/auth_base.dart';


class AddDevice extends StatefulWidget {

  AddDevice({Key key, this.title, this.auth, this.post, this.uuid, this.gatewayAddr}) : super(key: key);

  final auth;
  final Future<Device> post;
  final title;
  final String uuid;
  final String gatewayAddr;

  AddDeviceState createState() => AddDeviceState(auth, uuid, gatewayAddr);
}

  class AddDeviceState extends State<AddDevice> {
    final Auth auth;
    final String uuid;
    final String gatewayAddr;

    AddDeviceState(this.auth, this.uuid, this.gatewayAddr);

    TextEditingController nameController = new TextEditingController();
    TextEditingController descriptionController = new TextEditingController();
    TextEditingController topicController = new TextEditingController();
    TextEditingController macController = new TextEditingController();
    TextEditingController maxController = new TextEditingController();
    TextEditingController minController = new TextEditingController();


    @override
    Widget build(BuildContext context) {
      // TODO: implement build
      return MaterialApp(
        title: "Add Device",
        theme: ThemeData(
          primaryColor: Colors.blue,
        ),
        home: Scaffold(
          appBar: AppBar(
            title: Text('Add Device'),
          ),
          body: _addDeviceFields(context),
        ),
      );
    }

    @override
    Widget _addDeviceFields(BuildContext context) {
      return new Container(
        margin: const EdgeInsets.only(left: 8.0, right: 8.0),
        child: new Column(
          children: <Widget>[
            new TextField(
              controller: nameController,
              decoration: InputDecoration(
                  hintText: "name....", labelText: 'Name Device'),
            ),
            new TextField(
              controller: descriptionController,
              decoration: InputDecoration(
                  hintText: "description....", labelText: 'Description Device'),
            ),
            new TextField(
              controller: topicController,
              decoration: InputDecoration(
                  hintText: "topic....", labelText: 'Topic Device'),
            ),
            new TextField(
              controller: macController,
              decoration: InputDecoration(
                  hintText: "macaddress....", labelText: 'Macaddress Device'),
            ),
            new Text("Inserire range per la notifica."),
            new TextField(
              controller: minController,
              decoration: InputDecoration(
                  hintText: "Inserire valore con il punto es: 1.0",
                  labelText: 'Min value'),
            ),
            new TextField(
              controller: maxController,
              decoration: InputDecoration(
                  hintText: "Inserire valore con il punto es: 10.0",
                  labelText: 'Max value'),
            ),
            new RaisedButton(
              onPressed: () async {
                Device newDevice = new Device(
                  name: nameController.text,
                  topic: topicController.text,
                  macaddress: macController.text,
                  description: descriptionController.text,
                  max: num.parse(maxController.text),
                  min: num.parse(minController.text),
                );

                final CREATE_POST_URL = gatewayAddr + '/users/' +
                    auth.user.user.uid.toString() + '/areas/' + uuid +
                    '/devices';
                await createDevice(CREATE_POST_URL, auth,
                    body: newDevice.toMap());
                Navigator.pushReplacementNamed(context, '/home');
              },
              child: const Text("Add"),
            )
          ],
        ),
      );
    }
  }