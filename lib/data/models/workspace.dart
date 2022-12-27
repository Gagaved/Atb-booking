import 'package:atb_booking/data/models/workspace_type.dart';
import 'package:atb_booking/data/services/image_provider.dart';
import 'package:atb_booking/data/services/network/network_controller.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

class Workspace {
  final int id;
  final int numberOfWorkspaces;
  final String description;
  final bool isActive;
  final double positionX;
  final double positionY;
  final double sizeX;
  final double sizeY;
  final WorkspaceType type;
  final int level;
  final List<int> photosIds;

  Workspace.fromJson(Map<String, dynamic> json)
      : id = json['id'],
        numberOfWorkspaces = json['numberOfWorkspaces'],
        description = json['description'],
        isActive = json['isActive'],
        positionX = (json['positionX'] as int).toDouble(),
        positionY = (json['positionY'] as int).toDouble(),
        sizeX = (json['sizeX'] as int).toDouble(),
        sizeY = (json['sizeY'] as int).toDouble(),
        type = WorkspaceType.fromJson(json['type']),
        level = json['level'],
        photosIds = json['photos'] != null
            ? (json['photos'] as List<dynamic>).map((e) => e as int).toList()
            : [];

  Workspace(
      this.id,
      this.numberOfWorkspaces,
      this.description,
      this.isActive,
      this.positionX,
      this.positionY,
      this.level,
      this.photosIds,
      this.sizeX,
      this.sizeY,
      this.type);
}

class LevelPlanElementData {
  int? id;
  double positionX;
  double positionY;

  //double? minSize;
  double width;
  double height;
  int numberOfWorkspaces;
  String description;
  bool isActive;
  WorkspaceType type;
  int? levelId;
  late List<int> photosIds;
  int? levelNumber;

  LevelPlanElementData({
    required this.positionX,
    required this.positionY,
    //required this.minSize,
    required this.width,
    required this.height,
    required this.numberOfWorkspaces,
    required this.type,
    required this.description,
    required this.isActive,
    required this.levelId,
  }) {
    photosIds = [];
  }

  Map<String, dynamic> toJson() {
    var json = <String, dynamic>{};
    json['id'] = id;
    json["numberOfWorkspaces"] = numberOfWorkspaces;
    json["description"] = description;
    json["isActive"] = isActive;
    json["positionX"] = positionX.floor();
    json["positionY"] = positionY.floor();
    json["sizeX"] = width.floor();
    json["sizeY"] = height.floor();
    json["typeId"] = type.id;
    json["levelId"] = levelId;
    return json;
  }

  LevelPlanElementData.fromJson(Map<String, dynamic> json)
      : id = json['id'],
        numberOfWorkspaces = json['numberOfWorkspaces'],
        description = json['description'],
        isActive = json['isActive'],
        positionX = (json['positionX'] as int).toDouble(),
        positionY = (json['positionY'] as int).toDouble(),
        width = (json['sizeX'] as int).toDouble(),
        height = (json['sizeY'] as int).toDouble(),
        type = WorkspaceType.fromJson(json['type']),
        levelNumber = json['level'],
        photosIds = json['photos'] != null
            ? (json['photos'] as List<dynamic>).map((e) => e as int).toList()
            : [];
}

class Photo {
  final int id;
  final int imageId;
  final CachedNetworkImage photo;

  Photo.fromJson(Map<String, dynamic> json)
      : id = json['id'],
        imageId = json['imageId'],
        photo = CachedNetworkImage(
          fit: BoxFit.cover,
          imageUrl: AppImageProvider.getImageUrlFromImageId(json['imageId']),
          httpHeaders: NetworkController().getAuthHeader(),
          placeholder: (context, url) => const Center(),
          errorWidget: (context, url, error) => const Icon(Icons.error),
        );

  Photo({required this.id, required this.photo, required this.imageId});
}
