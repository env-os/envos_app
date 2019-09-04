import 'package:json_annotation/json_annotation.dart';

@JsonSerializable()
class Device{
  String uuid;
  String name;
  String macaddress;
  String topic;
  String description;
  num min;
  num max;


  Device({this.uuid, this.name, this.macaddress, this.topic, this.description, this.min, this.max});

  factory Device.fromJson(Map<String, dynamic> json) {
    return Device(
      uuid: json['uuid'] as String,
      name: json['name'] as String,
      macaddress: json['macaddress'] as String,
      topic: json['topic'] as String,
      description: json['description'] as String,
      max: json['valmax'] as num,
      min: json['valmin'] as num,
    );
  }
//
  Map toMap() {
    var map = new Map<String, dynamic>();
    map["uuid"] = uuid;
    map["name"] = name;
    map["macaddress"] = macaddress;
    map["topic"] = topic;
    map["description"] = description;
    map["valmax"] = max;
    map["valmin"] = min;

    return map;
  }



}