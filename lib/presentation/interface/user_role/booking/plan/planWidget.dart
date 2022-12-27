import 'package:atb_booking/data/models/workspace.dart';
import 'package:atb_booking/data/models/workspace_type.dart';
import 'package:atb_booking/data/services/image_provider.dart';
import 'package:atb_booking/data/services/network/network_controller.dart';
import 'package:atb_booking/data/services/workspace_type_repository.dart';
import 'package:atb_booking/logic/user_role/booking/new_booking/new_booking_bloc/plan_bloc/plan_bloc.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';

class PlanWidget extends StatelessWidget {
  static TransformationController _transformationController =
      TransformationController();
  static double SCALE_FACTOR = 1.0;

  const PlanWidget({super.key});

  @override
  Widget build(BuildContext context) {
    SCALE_FACTOR = MediaQuery.of(context).size.width / 1100.0;
    return BlocConsumer<PlanBloc, PlanState>(
      builder: (context, state) {
        if (state is PlanLoadedState) {
          _transformationController =
              TransformationController(_transformationController.value);
          _transformationController.addListener(() {});
          print("____________");
          var elements = <Widget>[];
          Widget? backgroundImage;

          ///
          ///
          if (state.levelPlanImageId != null) {
            backgroundImage = Center(
              child: Container(
                width: double.infinity,
                height: double.infinity,
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
            elements.add(backgroundImage);
          }

          ///
          ///
          if (backgroundImage != null) elements.add(backgroundImage);
          elements.addAll(_LevelPlanElementWidget.getListOfPlanElementWidget(
              state.workspaces,
              state.selectedWorkspace,
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
                  width: 1000.0 * PlanWidget.SCALE_FACTOR,
                  height: 1000.0 * PlanWidget.SCALE_FACTOR,
                  child: Stack(fit: StackFit.expand, children: elements),
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 30.0),
                child: Text(
                  state.title,
                  textAlign: TextAlign.center,
                  style: Theme.of(context).textTheme.headlineSmall,
                ),
              ),
            ],
          );
        }
        if (state is PlanWorkplaceSelectedState) {
          _transformationController =
              TransformationController(_transformationController.value);
          print("____________");
          var elements = <Widget>[];
          Widget? backgroundImage;

          ///
          ///
          if (state.levelPlanImageId != null) {
            var backgroundImage = Center(
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
            elements.add(backgroundImage);
          }

          ///
          ///
          if (backgroundImage != null) elements.add(backgroundImage);
          elements.addAll(_LevelPlanElementWidget.getListOfPlanElementWidget(
              state.workspaces,
              state.selectedWorkspace,
              WorkspaceTypeRepository().getMapOfTypes(),
              _transformationController.value.getMaxScaleOnAxis()));
          return Column(
            children: [
              InteractiveViewer(
                transformationController: _transformationController,
                maxScale: 2.5,
                minScale: 0.3,
                child: Container(
                  color: const Color.fromARGB(255, 232, 232, 232),
                  width: 1000.0 * PlanWidget.SCALE_FACTOR,
                  height: 1000.0 * PlanWidget.SCALE_FACTOR,
                  child: Stack(
                    children: elements,
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 30.0),
                child: Text(
                  state.title,
                  textAlign: TextAlign.center,
                  style: Theme.of(context).textTheme.headlineSmall,
                ),
              ),
              Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 30.0, vertical: 10),
                child: _DatePickerWidget(
                  onChanged: (DateTime dateTime) {},
                ),
              )
            ],
          );
        }

        if (state is PlanHidedState) {
          return Container();
        }
        if (state is PlanLoadingState) {
          return Container();
        } else {
          return ErrorWidget(Exception("errorState if plan"));
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
      LevelPlanElementData? selectedWorkplace,
      Map<int, WorkspaceType> types,
      double scaleInteractiveViewValue) {
    List<Widget> elements = [];
    for (var data in datas) {
      elements.add(_LevelPlanElementWidget(
        data: data,
        isSelect: selectedWorkplace != null && selectedWorkplace.id == data.id!,
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
    var cornerSize = 35 * PlanWidget.SCALE_FACTOR / scaleInteractiveViewValue;
    //var BLUE_PRINT_FRAME_WIDTH = 6.0;
    return Positioned(
      left: data.positionX * PlanWidget.SCALE_FACTOR - cornerSize,
      top: data.positionY * PlanWidget.SCALE_FACTOR - cornerSize,
      child: Container(
        //color: AtbAdditionalColors.debugTranslucent,
        height: data.height * PlanWidget.SCALE_FACTOR + (cornerSize * 2),
        width: data.width * PlanWidget.SCALE_FACTOR + (cornerSize * 2),
        child: GestureDetector(
          onTap: () {
            if(data.isActive) PlanBloc().add(PlanTapElementEvent(data));
          },
          child: Stack(children: [
            Positioned(
              left: cornerSize,
              top: cornerSize,
              child: SizedBox(
                width: data.width * PlanWidget.SCALE_FACTOR,
                height: data.height * PlanWidget.SCALE_FACTOR,
                child: Card(
                  clipBehavior: Clip.antiAliasWithSaveLayer,
                  shape: RoundedRectangleBorder(
                      side: !isSelect
                          ? const BorderSide(width: 0, color: Colors.grey)
                          : BorderSide(
                              width: 6 * PlanWidget.SCALE_FACTOR,
                              color: Theme.of(context).primaryColor),
                      borderRadius:
                          BorderRadius.circular(8 * PlanWidget.SCALE_FACTOR)),
                  shadowColor: Colors.black,
                  elevation: isSelect ? 8 : 3,
                  color: !data.isActive
                      ? const Color.fromARGB(255, 136, 136, 136)
                      : isSelect
                          ? const Color.fromARGB(255, 255, 231, 226)
                          : const Color.fromARGB(255, 234, 255, 226),
                  child: SizedBox(
                    // width: data.width * LevelEditorPage.SCALE_FACTOR,
                    // height: data.height * LevelEditorPage.SCALE_FACTOR,
                    child: Padding(
                      padding: EdgeInsets.all(6 * PlanWidget.SCALE_FACTOR),
                      child: Container(child: data.type.image),
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

class _DatePickerWidget extends StatefulWidget {
  const _DatePickerWidget({required this.onChanged});

  final void Function(DateTime dateTime) onChanged;

  @override
  _DatePickerWidgetState createState() => _DatePickerWidgetState();
}

class _DatePickerWidgetState extends State<_DatePickerWidget> {
  DateTime? _selectedDate;
  final TextEditingController _textEditingController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _selectedDate = PlanBloc().state.selectedDate;
  }

  @override
  Widget build(
    BuildContext context,
  ) {
    if (_selectedDate != null) {
      _textEditingController.text =
          (DateFormat.yMMMMd("ru_RU").format(_selectedDate!)).toString();
    }
    return TextField(
      decoration: InputDecoration(
        hintText: "Выберите офис",
        filled: true,
        fillColor: Theme.of(context).backgroundColor,
        border: const OutlineInputBorder(
          borderSide: BorderSide.none,
          borderRadius: BorderRadius.all(Radius.circular(10.0)),
        ),
        suffixIcon: const Icon(Icons.calendar_month),
      ),
      focusNode: AlwaysDisabledFocusNode(),
      controller: _textEditingController,
      onTap: () async {
        DateTime? newDate = await showDatePicker(
          builder: (context, child) {
            return Theme(
              data: Theme.of(context).copyWith(
                colorScheme: ColorScheme.light(
                  primary: Theme.of(context).primaryColor,
                  // header background color
                  onPrimary: Colors.white,

                  // header text color
                  onSurface: Theme.of(context).primaryColor, // body text color
                ),
                textButtonTheme: TextButtonThemeData(
                  style: TextButton.styleFrom(
                    foregroundColor: Colors.red, // button text color
                  ),
                ),
              ),
              child: child!,
            );
          },
          context: context,
          initialDate: DateTime(DateTime.now().year, DateTime.now().month,
                  DateTime.now().day, DateTime.now().hour)
              .add(const Duration(days: 1)),
          firstDate: DateTime(DateTime.now().year, DateTime.now().month,
              DateTime.now().day, DateTime.now().hour),
          lastDate: DateTime.now()
              .add(Duration(days: PlanBloc().maxBookingRangeInDays!)),
        );
        if (newDate != null) {
          _textEditingController.text =
              (DateFormat('dd.MM.yyyy').format(newDate)).toString();
          setState(() {
            _selectedDate = newDate;
          });
          PlanBloc().add(PlanSelectDateEvent(newDate));
          widget.onChanged(newDate);
          print("----------------");
          print("NEW VALUE DATA-PICKER IS: ${newDate.toUtc().toString()}");
          print("----------------");
        }
      },
    );
  }
}

class AlwaysDisabledFocusNode extends FocusNode {
  @override
  bool get hasFocus => false;
}
