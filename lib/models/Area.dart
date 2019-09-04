import 'package:envos/models/Device.dart';

class Area{
  String uuid;
  String name;
  String description;
  List<Device> devices;

  Area({this.uuid, this.name, this.description, this.devices});

  factory Area.fromJson(Map<String, dynamic> json) {
    return Area(
      uuid: json['uuid'] as String,
      name: json['name'] as String,
      description: json['description'] as String,
      devices: json['device'] as List<Device>,
    );
  }

  Map toMap(){
    var map = new Map<String, dynamic>();
    map["uuid"] = uuid;
    map["name"] = name;
    map["description"] = description;
    return map;
  }
}
