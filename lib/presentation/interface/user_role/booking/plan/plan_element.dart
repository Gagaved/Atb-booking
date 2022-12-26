
import 'package:atb_booking/data/models/workspace.dart';
import 'package:atb_booking/logic/user_role/booking/new_booking/new_booking_bloc/plan_bloc/plan_bloc.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

class PlanElementWidget extends StatelessWidget {
  final bool isActive;
  final bool isSelect;
  final LevelPlanElementData workspace;
  final double x;
  final double y;
  final double height;
  final double width;
  final CachedNetworkImage cachedNetworkImage;

  const PlanElementWidget(
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
                    BorderSide(width: 4,color: Theme.of(context).primaryColor),
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
            print("$isActive");
            if (isActive) {
              PlanBloc().add(PlanTapElementEvent(workspace));
            }
          },
        ));
  }

}
