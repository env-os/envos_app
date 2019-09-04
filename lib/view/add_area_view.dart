import 'dart:async';
import 'package:flutter/material.dart';
import 'package:envos/models/Area.dart';
import 'package:envos/presenter/process_json.dart';
import 'package:http/http.dart' as http;
import 'package:envos/presenter/auth_base.dart';


class AddArea extends StatefulWidget {

  AddArea({Key key, this.title, this.auth, this.post, this.gatewayAddr})
      : super(key: key);

  final auth;
  final Future<Area> post;
  final title;
  final String gatewayAddr;

  AddAreaState createState() => AddAreaState(auth, gatewayAddr);
}

  class AddAreaState extends State<AddArea> {
    final Auth auth;
    final String gatewayAddr;

    AddAreaState(this.auth, this.gatewayAddr);

    TextEditingController nameController = new TextEditingController();
    TextEditingController descriptionController = new TextEditingController();

    @override
    Widget build(BuildContext context) {
      // TODO: implement build
      return MaterialApp(
        title: "Add Area",
        theme: ThemeData(
          primaryColor: Colors.blue,
        ),
        home: Scaffold(
          appBar: AppBar(
            title: Text('Add Area'),
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
                  hintText: "name....", labelText: 'Name area'),
            ),
            new TextField(
              controller: descriptionController,
              decoration: InputDecoration(
                  hintText: "description....", labelText: 'Description area'),
            ),
            new RaisedButton(
              onPressed: () async {
                Area newArea = new Area(
                    name: nameController.text,
                    description: descriptionController.text
                );

                final CREATE_POST_URL = gatewayAddr + '/users/' +
                    auth.user.user.uid.toString() + '/areas';
                await createArea(CREATE_POST_URL, auth,
                    body: newArea.toMap());
                Navigator.pushReplacementNamed(context, '/home');
              },
              child: const Text("Add"),
            )
          ],
        ),
      );
    }
  }