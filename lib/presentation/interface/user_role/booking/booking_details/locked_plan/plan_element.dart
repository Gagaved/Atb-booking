

import 'package:atb_booking/data/models/workspace.dart';
import 'package:atb_booking/data/models/workspace_type.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
class LockedPlanElement extends StatelessWidget {
  final bool isActive;
  final bool isSelect;
  final LevelPlanElementData workspace;
  final double x;
  final double y;
  final double height;
  final double width;
  final CachedNetworkImage cachedNetworkImage;

  const LockedPlanElement(
      {super.key,
      required this.x,
      required this.y,
      required this.height,
      required this.width,
      required this.workspace,
      required this.isSelect,
      required this.cachedNetworkImage,
      required this.isActive});

  @override
  Widget build(BuildContext context) {
    return Positioned(
        top: y,
        left: x,
        child: Card(
          clipBehavior: Clip.antiAliasWithSaveLayer,
          shape: RoundedRectangleBorder(
              side: !isSelect?
              const BorderSide(
                  width: 0.2, color: Colors.black):
                  BorderSide(width: 4,color: Theme.of(context).primaryColor),
              borderRadius: BorderRadius.circular(12.0)),
          shadowColor: !isActive
              ? const Color.fromARGB(255, 236, 236, 236)
              : isSelect
                  ? const Color.fromARGB(255, 255, 126, 0)
                  : const Color.fromARGB(255, 236, 236, 236),
          elevation: isSelect?8:3,
          color: !isActive
              ? const Color.fromARGB(255, 236, 236, 236)
              : isSelect
                  ? const Color.fromARGB(255, 255, 235, 206)
                  : const Color.fromARGB(255, 236, 236, 236),
          child: SizedBox(
            width: width,
            height: height,
            child: Padding(
              padding: const EdgeInsets.all(5.0),
              child: Container(child: cachedNetworkImage),
            ),
          ),
        ));
  }

  static List<LockedPlanElement> getListOfLockedPlanElement(
      List<LevelPlanElementData> workspaces, int selectedWorkspaceId, Map<int, WorkspaceType> types) {
    List<LockedPlanElement> elements = [];
    for (LevelPlanElementData item in workspaces) {
      elements.add(LockedPlanElement(
        isActive: item.isActive,
        x: item.positionX,
        y: item.positionY,
        height: item.height,
        // workspace.height,
        width: item.width,
        //workspace.width,
        workspace: item,
        isSelect: item.id == selectedWorkspaceId,
        cachedNetworkImage: getCachedNetworkImage(item.type.id),
      )); //workspace.isSelect));
    }
    return elements;
  }
}
