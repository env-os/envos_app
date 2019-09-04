import 'dart:async';
import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:envos/models/Area.dart';
import 'package:envos/models/Device.dart';
import 'auth_base.dart';

Future<List<Area>> fetchAreas(http.Client client, Auth auth, String gatewayAddr) async {
  final response =
  await client.get(
      //'https://public-api-gateway.herokuapp.com/areas',
//      gatewayAddr + "/areas",
      gatewayAddr + "/users/" + auth.user.user.uid.toString() + "/areas" ,
      headers: {'authorization': "Bearer " + auth.token.token.toString()}
  );

  return compute(parseAreas, response.body);
}

Future<List<Device>> fetchDevice(http.Client client, Auth auth, String uuid, String gatewayAddr) async {
  final response =
  await client.get(
      //'https://public-api-gateway.herokuapp.com/areas/' + uuid + '/devices',
//      gatewayAddr + "/areas/" + uuid + "/devices",
      gatewayAddr + '/users/' + auth.user.user.uid.toString() + "/areas/" + uuid + "/devices",
      headers: {'authorization': "Bearer " + auth.token.token.toString()}
  );

  return compute(parseDevices, response.body);
}

List<Area> parseAreas(String responseBody) {
  final parsed = json.decode(responseBody).cast<Map<String, dynamic>>();

  return parsed.map<Area>((json) => Area.fromJson(json)).toList();
}

List<Device> parseDevices(String responseBody) {
  final devices = json.decode(responseBody).cast<Map<String, dynamic>>();

  return devices.map<Device>((json) => Device.fromJson(json)).toList();
}

Future<Device> createDevice(String url, Auth auth, {Map body}) async {

  //encode Map to JSON
  var _body = json.encode(body);

  var response = await http.post(url,
      headers: {"Content-Type": "application/json", 'authorization': "Bearer " + auth.token.token.toString()},
      body: _body
  );
  print("${response.statusCode}");
  print("${response.body}");
}

Future<Area> createArea(String url, Auth auth, {Map body}) async {

  //encode Map to JSON
  var _body = json.encode(body);

  var response = await http.post(url,
      headers: {"Content-Type": "application/json", 'authorization': "Bearer " + auth.token.token.toString()},
      body: _body
  );
  print("${response.statusCode}");
  print("${response.body}");
}