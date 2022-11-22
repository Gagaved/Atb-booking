import 'package:atb_booking/user_interface/widgets/plan/plan_bloc/plan_bloc.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../data/models/workspace.dart';
import '../../../data/models/workspace_type.dart';
import '../../../presentation/constants/styles.dart';

class PlanElement extends StatelessWidget {
  final bool isActive;
  final bool isSelect;
  final WorkspaceOnPlan workspace;
  final double x;
  final double y;
  final double height;
  final double width;
  final CachedNetworkImage cachedNetworkImage;

  const PlanElement(
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
        child: GestureDetector(
          child: Card(
            clipBehavior: Clip.antiAliasWithSaveLayer,
            shape: RoundedRectangleBorder(
                side: !isSelect?
                BorderSide(
                    width: 0.2, color: Colors.black):
                    BorderSide(width: 4,color: appThemeData.primaryColor),
                borderRadius: BorderRadius.circular(12.0)),
            shadowColor: !isActive
                ? Colors.grey
                : isSelect
                    ? Color.fromARGB(255, 255, 126, 0)
                    : Color.fromARGB(255, 198, 255, 170),
            elevation: isSelect?8:3,
            color: !isActive
                ? Colors.grey
                : isSelect
                    ? Color.fromARGB(255, 255, 231, 226)
                    : Color.fromARGB(255, 234, 255, 226),
            child: Container(
              width: width,
              height: height,
              child: Padding(
                padding: const EdgeInsets.all(5.0),
                child: Container(child: cachedNetworkImage),
              ),
            ),
          ),
          onTap: () {
            if (isActive) {
              context.read<PlanBloc>().add(PlanTapElementEvent(workspace));
            }
          },
        ));
  }

  static List<PlanElement> getListOfPlanElement(
      List<WorkspaceOnPlan> workspaces, WorkspaceOnPlan? selectedWorkplace, Map<int, WorkspaceType> types) {
    List<PlanElement> elements = [];
    for (WorkspaceOnPlan workspace in workspaces) {
      elements.add(PlanElement(
        isActive: workspace.isActive,
        x: workspace.positionX,
        y: workspace.positionY,
        height: workspace.sizeY,
        // workspace.height,
        width: workspace.sizeX,
        //workspace.width,
        workspace: workspace,
        isSelect: workspace == selectedWorkplace ? true : false,
        cachedNetworkImage: types[workspace.typeId]!.cachedNetworkImage,
      )); //workspace.isSelect));
    }
    return elements;
  }
}
