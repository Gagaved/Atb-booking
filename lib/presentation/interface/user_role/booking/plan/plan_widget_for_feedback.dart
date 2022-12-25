import 'package:atb_booking/data/models/workspace.dart';
import 'package:atb_booking/data/services/image_provider.dart';
import 'package:atb_booking/data/services/network/network_controller.dart';
import 'package:atb_booking/logic/admin_role/offices/LevelPlanEditor/level_plan_editor_bloc.dart';
import 'package:atb_booking/logic/user_role/feedback_bloc/feedback_bloc.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class FeedbackLevelPlan extends StatelessWidget {
  static var SCALE_FACTOR = 1.0;

  const FeedbackLevelPlan({Key? key}) : super(key: key);
  static TransformationController _transformationController =
      TransformationController();

  @override
  Widget build(BuildContext context) {
    SCALE_FACTOR = MediaQuery.of(context).size.width / 1200.0;
    return BlocBuilder<FeedbackBloc, FeedbackState>(builder: (context, state) {
      if (state is FeedbackMainState) {
        _transformationController =
            TransformationController(_transformationController.value);
        print("____________");
        var elements = <Widget>[];

        ///
        ///
        Widget? backgroundImage;
        if (state.levelPlanImageId != null) {
          backgroundImage = Center(
            child: Container(
              width: double.infinity,
              //height:  double.infinity,
              child: CachedNetworkImage(
                  fit: BoxFit.fitHeight,
                  imageUrl: AppImageProvider.getImageUrlFromImageId(
                      state.levelPlanImageId!),
                  httpHeaders: NetworkController().getAuthHeader(),
                  placeholder: (context, url) => const Center(),
                  errorWidget: (context, url, error) =>
                      const Icon(Icons.error)),
            ),
          );
        }
        if (backgroundImage != null) {
          elements.add(backgroundImage);
        }

        ///
        ///
        _LevelPlanEditorElementWidget? selectedElem;
        print("length: ${state.listOfPlanElements!.length}");
        for (int i = 0; i < state.listOfPlanElements!.length; i++) {
          bool isSelect = i == state.selectedElementIndex;
          print("isSelect: $isSelect");
          if (isSelect) {
            selectedElem = _LevelPlanEditorElementWidget(
                data: state.listOfPlanElements![i],
                isSelect: isSelect,
                scaleInteractiveViewValue:
                    _transformationController.value.getMaxScaleOnAxis());
          } else {
            elements.add(_LevelPlanEditorElementWidget(
                data: state.listOfPlanElements![i],
                isSelect: isSelect,
                scaleInteractiveViewValue:
                    _transformationController.value.getMaxScaleOnAxis()));
          }
        }
        ///кидаем наверх плана выбранный
        if (selectedElem != null) elements.add(selectedElem);

        print("____________");
        return InteractiveViewer(
          minScale: 0.3,
          maxScale: 2.5,
          transformationController: _transformationController,
          child: Container(
              color: const Color.fromARGB(255, 232, 232, 232),
              width: 1000.0 * FeedbackLevelPlan.SCALE_FACTOR,
              height: 1000.0 * FeedbackLevelPlan.SCALE_FACTOR,
              child: Stack(
                children: elements,
              )),
        );
      } else if (state is LevelPlanEditorInitial) {
        return const Center(
          child: CircularProgressIndicator(),
        );
      } else {
        throw Exception('State: $state');
      }
    });
  }
}

class _LevelPlanEditorElementWidget extends StatelessWidget {
  final LevelPlanElementData data;
  final bool isSelect;
  final double scaleInteractiveViewValue;

  const _LevelPlanEditorElementWidget(
      {required this.data,
      required this.isSelect,
      required this.scaleInteractiveViewValue});

  @override
  Widget build(BuildContext context) {
    var cornerSize =
        35 * FeedbackLevelPlan.SCALE_FACTOR / scaleInteractiveViewValue;
    // var BLUE_PRINT_FRAME_WIDTH = 6.0;
    return Positioned(
      left: data.positionX * FeedbackLevelPlan.SCALE_FACTOR - cornerSize,
      top: data.positionY * FeedbackLevelPlan.SCALE_FACTOR - cornerSize,
      child: Container(
        //color: AtbAdditionalColors.debugTranslucent,
        height: data.height * FeedbackLevelPlan.SCALE_FACTOR + (cornerSize * 2),
        width: data.width * FeedbackLevelPlan.SCALE_FACTOR + (cornerSize * 2),
        child: GestureDetector(
          onTap: () {
            if (data.isActive)
              context
                  .read<FeedbackBloc>()
                  .add(FeedbackWorkplaceTapEvent(data.id!));
          },
          child: Stack(children: [
            Positioned(
              left: cornerSize,
              top: cornerSize,
              child: Container(
                width: data.width * FeedbackLevelPlan.SCALE_FACTOR,
                height: data.height * FeedbackLevelPlan.SCALE_FACTOR,
                child: Card(
                  clipBehavior: Clip.antiAliasWithSaveLayer,
                  shape: RoundedRectangleBorder(
                      side: !isSelect
                          ? const BorderSide(width: 0, color: Colors.grey)
                          : BorderSide(
                              width: 6 * FeedbackLevelPlan.SCALE_FACTOR,
                              color: Theme.of(context).primaryColor),
                      borderRadius: BorderRadius.circular(
                          8 * FeedbackLevelPlan.SCALE_FACTOR)),
                  shadowColor: Colors.black,
                  elevation: isSelect ? 8 : 3,
                  color: !data.isActive
                      ? Colors.black12
                      : isSelect
                          ? const Color.fromARGB(255, 255, 231, 226)
                          : const Color.fromARGB(255, 234, 255, 226),
                  child: SizedBox(
                    // width: data.width * LevelEditorPage.SCALE_FACTOR,
                    // height: data.height * LevelEditorPage.SCALE_FACTOR,
                    child: Padding(
                      padding:
                          EdgeInsets.all(6 * FeedbackLevelPlan.SCALE_FACTOR),
                      child: Container(child: data.type.cachedNetworkImage),
                    ),
                  ),
                ),
              ),
            ),
          ]),
        ),
      ),
    );
  }
}
