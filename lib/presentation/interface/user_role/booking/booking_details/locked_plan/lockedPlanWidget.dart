import 'package:atb_booking/data/models/workspace.dart';
import 'package:atb_booking/data/models/workspace_type.dart';
import 'package:atb_booking/data/services/image_provider.dart';
import 'package:atb_booking/data/services/network/network_controller.dart';
import 'package:atb_booking/data/services/workspace_type_repository.dart';
import 'package:atb_booking/logic/user_role/booking/locked_plan_bloc/locked_plan_bloc.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class LockedPlanWidget extends StatelessWidget {
  static TransformationController _transformationController =
  TransformationController();
  static double SCALE_FACTOR = 1.0;

  const LockedPlanWidget({super.key});

  @override
  Widget build(BuildContext context) {
    SCALE_FACTOR = MediaQuery.of(context).size.width / 1000.0;
    return BlocConsumer<LockedPlanBloc, LockedPlanState>(
      builder: (context, state) {
        if (state is LockedPlanLoadedState) {
          _transformationController =
              TransformationController(_transformationController.value);
          _transformationController.addListener(() {
            // context
            //     .read<LevelPlanEditorBloc>()
            //     .add(LevelPlanEditorForceUpdateEvent());
          });
          print("____________");
          var elements = <Widget>[];
          Widget? backgroundImage;

          ///
          ///
          ///
          if (state.levelPlanImageId != null) {
            var backgroundImage = Center(
              child: Container(
                width: double.infinity,
                height: double.infinity,
                child: CachedNetworkImage(
                    fit: BoxFit.fitHeight,
                    imageUrl: AppImageProvider.getImageUrlFromImageId(state.levelPlanImageId!),
                    httpHeaders: NetworkController().getAuthHeader(),
                    placeholder: (context, url) => const Center(),
                    errorWidget: (context, url, error) =>
                    const Icon(Icons.error)),
              ),
            );
            elements.add(backgroundImage);
          }

          ///
          ///
          if (backgroundImage != null) elements.add(backgroundImage);
          elements.addAll(_LevelPlanElementWidget.getListOfPlanElementWidget(
              state.workspaces,
              state.selectedWorkspaceId,
              WorkspaceTypeRepository().getMapOfTypes(),
              _transformationController.value.getMaxScaleOnAxis()));
          return Column(
            children: [
              InteractiveViewer(
                transformationController: _transformationController,
                minScale: 0.3,
                maxScale: 2.5,
                child: Container(
                  color: const Color.fromARGB(255, 232, 232, 232),
                  width: 1000.0 * LockedPlanWidget.SCALE_FACTOR,
                  height: 1000.0 * LockedPlanWidget.SCALE_FACTOR,
                  child: Stack(
                      fit: StackFit.expand,
                      children: elements
                  ),
                ),
              ),
            ],
          );
        }
        else{
         return ErrorWidget(Exception("unexpected state: $state"));
        }
      },
      listener: (context, state) {
        // TODO: implement listener
      },
    );
  }
}

class _LevelPlanElementWidget extends StatelessWidget {
  final LevelPlanElementData data;
  final bool isSelect;
  final double scaleInteractiveViewValue;

  static List<Widget> getListOfPlanElementWidget(
      List<LevelPlanElementData> datas,
      int? selectedWorkplaceId,
      Map<int, WorkspaceType> types,
      double scaleInteractiveViewValue) {
    List<Widget> elements = [];
    for (var data in datas) {
      elements.add(_LevelPlanElementWidget(
        data: data,
        isSelect: selectedWorkplaceId != null && selectedWorkplaceId == data.id!,
        scaleInteractiveViewValue: scaleInteractiveViewValue,
      ));
    }
    return elements;
  }

  const _LevelPlanElementWidget(
      {required this.data,
        required this.isSelect,
        required this.scaleInteractiveViewValue});

  @override
  Widget build(BuildContext context) {
    var cornerSize = 35 * LockedPlanWidget.SCALE_FACTOR / scaleInteractiveViewValue;
    return Positioned(
      left: data.positionX * LockedPlanWidget.SCALE_FACTOR - cornerSize,
      top: data.positionY * LockedPlanWidget.SCALE_FACTOR - cornerSize,
      child: Container(
        //color: AtbAdditionalColors.debugTranslucent,
        height: data.height * LockedPlanWidget.SCALE_FACTOR + (cornerSize * 2),
        width: data.width * LockedPlanWidget.SCALE_FACTOR + (cornerSize * 2),
        child: Stack(children: [
          Positioned(
            left: cornerSize,
            top: cornerSize,
            child: SizedBox(
              width: data.width * LockedPlanWidget.SCALE_FACTOR,
              height: data.height * LockedPlanWidget.SCALE_FACTOR,
              child: Card(
                clipBehavior: Clip.antiAliasWithSaveLayer,
                shape: RoundedRectangleBorder(
                    side: !isSelect
                        ? const BorderSide(width: 0, color: Colors.grey)
                        : BorderSide(
                        width: 6 * LockedPlanWidget.SCALE_FACTOR,
                        color: Theme.of(context).primaryColor),
                    borderRadius:
                    BorderRadius.circular(8 * LockedPlanWidget.SCALE_FACTOR)),
                shadowColor: Colors.black,
                elevation: isSelect ? 8 : 3,
                color: !data.isActive
                    ? const Color.fromARGB(255, 255, 231, 226)
                    : isSelect
                    ? const Color.fromARGB(255, 255, 231, 226)
                    : const Color.fromARGB(255, 234, 255, 226),
                child: SizedBox(
                  // width: data.width * LevelEditorPage.SCALE_FACTOR,
                  // height: data.height * LevelEditorPage.SCALE_FACTOR,
                  child: Padding(
                    padding: EdgeInsets.all(6 * LockedPlanWidget.SCALE_FACTOR),
                    child: Container(child: data.type.image),
                  ),
                ),
              ),
            ),
          ),
        ]),
      ),
    );
  }
}

