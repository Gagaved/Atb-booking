import 'package:atb_booking/data/models/user.dart';
import 'package:flutter/material.dart';

import 'workspace.dart';

enum PlaceType {
  meetingRoom,
  workPlace,
}

class Booking {
  final int id;
  final int holderId;
  final String holderName;
  final String cityName;
  final int levelId;
  final String officeAddress;
  final Workspace workspace;
  final DateTimeRange reservationInterval;
  final List<User>? guests;
  Booking({
    required this.id,
    required this.levelId,
    required this.cityName,
    required this.officeAddress,
    required this.workspace,
    required this.reservationInterval,
    required this.guests,
    required this.holderId,
    required this.holderName
  });

  Booking.fromJson(Map<String, dynamic> json)
      : id = json['id'],
        cityName = json['cityName'],
        levelId = json['levelId'],
        officeAddress = json['officeAddress'],
        reservationInterval = DateTimeRange(
          start: DateTime.parse(json['reservationInterval']['startsAt'])
              .toLocal(), //..add(Duration(hours: 10)),
          end: DateTime.parse(json['reservationInterval']['endsAt'])
              .toLocal(), //..add(Duration(hours: 10)),
        ),
        workspace = Workspace.fromJson(json['workspaceInfo']),
        guests =  json['guests']!=null?(json['guests'] as List<dynamic>).map((elem)=>User.fromJson(elem)).toList():null,
        holderId = json['holderInfo']['id'],
        holderName = json['holderInfo']['fullName'];
}
