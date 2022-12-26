import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

class WorkspaceType {
  final int id;
  final String type;
  final Image? image;

  WorkspaceType(this.id, this.type, this.image);

  WorkspaceType.fromJson(Map<String, dynamic> json)
      :
        id = json['id'],
        type = json['type'],
        image =  getCachedNetworkImage(json['id']);
}

var image1 = Image.asset(
    'assets/workspace1.png'
);

var image2 = Image.asset(
'assets/workspace2.png'
);
Image getCachedNetworkImage(int typeId) {
  if (typeId == 1) {
    return image1;
  } else {
      return image2;
    }
}

