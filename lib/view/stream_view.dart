import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:web_socket_channel/io.dart';
import 'package:envos/loaders/loading_widget.dart';

class Choice {
  const Choice({this.title, this.icon});

  final String title;
  final IconData icon;
}

class StreamPage extends StatelessWidget {

  StreamPage(
      {Key key, this.auth, this.uuidArea, this.uuidDevice, this.name, this.description, this.topic, this.macaddress, this.min, this.max, this.gatewayAddr})
      : super(key: key);
  final auth;
  final String gatewayAddr;
  final String uuidArea;
  final String uuidDevice;
  final String name;
  final String description;
  final String topic;
  final String macaddress;
  final num min;
  final num max;

  List<Choice> choices = <Choice>[
    Choice(title: "Informazioni", icon: Icons.info),
    Choice(title: "Elimina Device", icon: Icons.delete),
    Choice(title: "Stop", icon: Icons.stop),
    Choice(title: "Start", icon: Icons.play_arrow),
  ];


  void _deleteRequest() async {
    String url = gatewayAddr + '/users/' + auth.user.user.uid.toString() +
        '/areas/' + uuidArea + '/devices/' + uuidDevice;
    Client client = new Client();
    await client.delete(
        url,
        headers: {'authorization': "Bearer " + auth.token.token.toString()}
    );
  }


  @override
  Widget build(BuildContext context) {
    IOWebSocketChannel channel;

    channel = new IOWebSocketChannel.connect(
        "ws://192.168.0.149:8997/",
        headers: {
          'authorization': auth.token.token.toString(),
        });


    void _showDialog() {
      showDialog(context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: new Text(name),
              content: new Text(
                  "Description: " + description + "\n" +
                      "Mac Address: " + macaddress + "\n" +
                      "Topic: " + topic + "\n" +
                      "Min/Max: " + min.toString() + "/" + max.toString()
              ),
            );
          }
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text("Stream"),
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
              Future.delayed(const Duration(milliseconds: 1000), () {
                Navigator.pushReplacementNamed(context, "/home");
              });
            },
          )
        ],
      ),
      body: StreamBuilder(
        stream: channel.stream,
        builder: (context, snapshot) {
          channel.sink.add(topic);
          Map<String, dynamic> value;

          try {
            value = jsonDecode(snapshot.data);

            if (value['data'] > max || value['data'] < min) {
              return Center(
                child: Container(
                  margin: EdgeInsets.all(15),
                  child: new Column(
                    children: <Widget>[
                      new Text("Value: " + value['data'].toString(),
                        style: TextStyle(
                            fontSize: 30, fontWeight: FontWeight.bold),
                      ),
                      new Image.asset('assets/allert.png',
                        height: 200,
                      ),
                      new Text("! WARNING !",
                        style: TextStyle(fontSize: 25, color: Colors.red),),
                    ],
                  ),
                ),
              );
            }
            else {
              return Center(
                child: Container(
                  margin: EdgeInsets.all(15),
                  child: new Column(
                    children: <Widget>[
                      new Text("Value: " + value['data'].toString(),
                        style: TextStyle(
                            fontSize: 30, fontWeight: FontWeight.bold),
                      ),
                      new Image.asset(
                        'assets/check.png',
                        height: 200,
                      ),
                    ],
                  ),
                ),
              );
            }
          }
          catch (i) {
            //return Container(child: Text(""));
            return Container(
                margin: EdgeInsets.all(50),
                child: Column(
                  children: <Widget>[
                    new ColorLoader5(),
                    new Text("\nDevice not connected, please stand by!",
                        style: TextStyle(fontSize: 12)),
                  ],
                ));
          }
        },
      ),
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
