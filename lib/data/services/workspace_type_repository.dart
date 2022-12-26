//
// class WorkspaceTypeRepository{
//   final WorkspaceTypeProvider _workspaceTypeProvider = WorkspaceTypeProvider();
//   Future<List<WorkspaceType>> getBookingByUserId(int id) => _workspaceTypeProvider.getBookingByUserId(id);
//   Future<List<WorkspaceType>> getBookingById(int id)=>_workspaceTypeProvider.getBookingById(id);
// }

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

import '../models/workspace_type.dart';

class WorkspaceTypeRepository {
  Map<int,WorkspaceType> getMapOfTypes() {
    var list = List.of([
      WorkspaceType(
          1,
          "Стол с компьютером",
          Image.asset("assets/workspace1.png")),
      WorkspaceType(
          2,
          "Переговорка",
          Image.asset("assets/workspace2.png")),
    ]);
    var result = { for (var v in list) v.id: v};
    return result;
  }
}
