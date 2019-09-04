import 'package:envos/models/Device.dart';
import 'package:envos/models/Place.dart';

class Signal{
  Device device;
  double date;
  DateTime sendDateTime;
  Place place;

  Signal(
      Device device,
      double date,
      DateTime sendDateTime,
      Place place
      )
  : this.device = device,
  this.date=date,
  this.sendDateTime=sendDateTime,
  this.place=place;
}