
import 'package:atb_booking/data/services/image_provider.dart';
import 'package:atb_booking/data/services/network/network_controller.dart';
import 'package:atb_booking/logic/user_role/booking/new_booking/new_booking_bloc/adding_people_to_booking_bloc/adding_people_to_booking_bloc.dart';
import 'package:atb_booking/logic/user_role/booking/new_booking/new_booking_bloc/new_booking_bloc.dart';
import 'package:atb_booking/logic/user_role/booking/new_booking/new_booking_bloc/new_booking_sheet_bloc/new_booking_sheet_bloc.dart';
import 'package:atb_booking/presentation/interface/user_role/booking/new_booking/adding_people_popup.dart';
import 'package:atb_booking/presentation/interface/user_role/booking/new_booking/new_booking_confirmation_popup.dart';
import 'package:atb_booking/presentation/widgets/elevated_button.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:syncfusion_flutter_core/theme.dart';
import 'package:syncfusion_flutter_sliders/sliders.dart';

class BookingBottomSheet extends StatelessWidget {
  const BookingBottomSheet({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<NewBookingSheetBloc, NewBookingSheetState>(
      listener: (context, state) {
        // TODO: implement listener
      },
      builder: (context, state) {
        if (state is NewBookingSheetLoadedState) {
          if (state.rangeList.isNotEmpty) {
            return _SheetLoadedStateWidget(state: state);
          } else {
            return _SheetLoadedEmptyWidget(state: state);
          }
        } else if (state is NewBookingSheetLoadingState) {
          return Column(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            mainAxisSize: MainAxisSize.min,
            children: [
              AppBar(
                title: Text(
                  'Загружаем...',
                  style: Theme.of(context).textTheme.labelMedium?.copyWith(
                      fontSize: 18, color: Theme.of(context).colorScheme.onSurface),
                ),
              ),
              const SizedBox(
                height: 300,
                child: Center(
                  child: SizedBox(
                    height: 50,
                    width: 50,
                    child: CircularProgressIndicator(),
                  ),
                ),
              )
            ],
          );
        } else if (state is NewBookingSheetErrorState) {
          return Center(
              child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                Text(
                  "Упс, что-то пошло не так...",
                  textAlign: TextAlign.center,
                  style: Theme.of(context).textTheme.titleLarge!.copyWith(
                      color: const Color.fromARGB(255, 49, 41, 0), fontSize: 30),
                )
              ]));
        } else {
          throw Exception("bad state");
        }
      },
    );
  }
}

class _SheetLoadedStateWidget extends StatelessWidget {
  final NewBookingSheetLoadedState state;
  static final ScrollController _sliderListScrollController = ScrollController();

  const _SheetLoadedStateWidget({required this.state});

  @override
  Widget build(BuildContext context) {
    Widget getSliderNEW(int index, NewBookingSheetLoadedState state) {
      var rangeList = state.rangeList;
      var activeSliderIndex = state.activeSliderIndex;
      var rangeValuesList = state.rangeValuesList;
      int sliderType = -1;
      var diff = ((rangeList[index].end as DateTime).millisecondsSinceEpoch -
              (rangeList[index].start as DateTime).millisecondsSinceEpoch)
          .abs();
      int setSliderType() {
        if (diff <= 10800000) {
          //10800000 is 3 hours
          return 0;
        } else {
          return 1;
        }
      }

      sliderType = setSliderType();
      double getSliderWidth(int sliderType) {
        double width = 0.0;
        if (sliderType == 0) {
          width = (((rangeList[index].end.minute - rangeList[index].start.minute)
              .toDouble() *
              4.toDouble().abs())
              .abs() +
              ((rangeList[index].end.hour - rangeList[index].start.hour)
                  .toDouble() *
                  1.5.toDouble() *
                  30.toDouble())
                  .toDouble()
                  .abs())*1.5;
        }
        if (sliderType == 1) {
          width = ((rangeList[index].end.minute - rangeList[index].start.minute)
                          .toDouble() *
                      4.toDouble().abs())
                  .abs() +
              ((rangeList[index].end.hour - rangeList[index].start.hour)
                          .toDouble() *
                      1.5.toDouble() *
                      30.toDouble())
                  .toDouble()
                  .abs();
        }
        if (width < 150.0) width = 150;
        if (width > 380.0) {
          width = 380.0;
        }
        return width;
      }

      return Center(
        child: GestureDetector(
            behavior: HitTestBehavior.translucent,
            onTap: () {
              if (activeSliderIndex == index) {
                return;
              }
              activeSliderIndex = index;
              context
                  .read<NewBookingSheetBloc>()
                  .add(NewBookingSheetSliderChangedEvent(activeSliderIndex));
            },
            child: Center(
              child: Container(
                  constraints:
                      const BoxConstraints(minHeight: 100, minWidth: 100),
                  height: 100,
                  width: getSliderWidth(sliderType),
                  child: SfRangeSlider(
                    showTicks: true,
                    showDividers: true,
                    minorTicksPerInterval: (sliderType == 0) ? 0 : 3,
                    values: rangeValuesList[index],
                    min: rangeList[index].start,
                    max: rangeList[index].end,
                    showLabels: true,
                    interval: sliderType == 0 ? 60 : 2,
                    stepDuration: const SliderStepDuration(minutes: 30),
                    dateIntervalType: (sliderType == 0)
                        ? DateIntervalType.minutes
                        : DateIntervalType.hours,
                    //numberFormat: NumberFormat('\$'),
                    dateFormat: DateFormat.Hm(),
                    enableTooltip: true,
                    onChanged: activeSliderIndex == index
                        ? (SfRangeValues newValues) {
                            context.read<NewBookingSheetBloc>().add(
                                NewBookingSheetValuesChangedEvent(newValues));
                          }
                        : null,
                  )),
            )),
      );
    }

    getSize() {
      if (state.workspace.photosIds.isEmpty) return 0.0;
      if (state.workspace.photosIds.length == 1) return 250.0;
      return 200.0;
    }

    return SingleChildScrollView(
      //physics: NeverScrollableScrollPhysics(),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        mainAxisSize: MainAxisSize.min,
        children: [
          AppBar(
            title: Text(
              state.workspace.type.type,
              style: Theme.of(context).textTheme.labelMedium?.copyWith(
                  fontSize: 18, color: Theme.of(context).colorScheme.onSurface),
            ),
            actions: (state.workspace.numberOfWorkspaces>1)?[
              IconButton(
                  onPressed: () {
                    showDialog(
                        context: context,
                        builder: (_) {
                          return BlocProvider<AddingPeopleToBookingBloc>(
                            create: (context) => AddingPeopleToBookingBloc(NewBookingBloc().guests),
                            child: const AddingPeopleWidget(),
                          );
                        });
                  },
                  icon: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Row(
                      children: [
                        const Icon(Icons.person_add_rounded),
                        state.selectedUsers.isNotEmpty
                            ? Container(
                                width: 30,
                                height: 30,
                                decoration: BoxDecoration(
                                    color: Theme.of(context).primaryColor,
                                    border: Border.all(
                                        color: Theme.of(context).primaryColor),
                                    borderRadius: const BorderRadius.all(
                                        Radius.circular(20))),
                                child: Center(
                                    child: Text(
                                  '${state.selectedUsers.length}',
                                  style: Theme.of(context).textTheme.titleMedium!
                                      .copyWith(color: Colors.white),
                                )),
                              )
                            : const SizedBox.shrink(),
                      ],
                    ),
                  ))
            ]:null,
          ),

          ///
          ///
          /// ФОТКИ
          SizedBox(
            height: getSize(), //getSize(),
            child: Center(
              child: ListView.builder(
                  shrinkWrap: true,
                  scrollDirection: Axis.horizontal,
                  itemCount: state.workspace.photosIds.length,
                  //state.workspace.photos.length,
                  itemBuilder: (context, index) {
                    return GestureDetector(
                      behavior: HitTestBehavior.translucent,
                      child:
                      CachedNetworkImage(
                        fit: BoxFit.cover,
                        imageUrl: AppImageProvider.getImageUrlFromImageId(state.workspace.photosIds[index]),
                        httpHeaders: NetworkController().getAuthHeader(),
                        placeholder: (context, url) => const Center(),
                        errorWidget: (context, url, error) => const Icon(Icons.error),
                      ),
                      onTap: () {
                        showDialog(
                            useRootNavigator: false,
                            context: context,
                            builder: (BuildContext context) {
                              return GestureDetector(
                                behavior: HitTestBehavior.translucent,
                                onTap: () {
                                  int count = 0;
                                  Navigator.popUntil(context, (route) {
                                    return count++ == 1;
                                  });
                                },
                                child: InteractiveViewer(
                                  transformationController:
                                      TransformationController(),
                                  maxScale: 2.0,
                                  minScale: 0.1,
                                  child: AlertDialog(
                                    //clipBehavior: Clip.none,
                                    shape: const RoundedRectangleBorder(
                                        borderRadius: BorderRadius.all(
                                            Radius.circular(0.0))),
                                    insetPadding: const EdgeInsets.symmetric(
                                        horizontal: 10, vertical: 200),
                                    contentPadding: const EdgeInsets.symmetric(
                                        horizontal: 10, vertical: 10),
                                    content:
                                    CachedNetworkImage(
                                      fit: BoxFit.cover,
                                      imageUrl: AppImageProvider.getImageUrlFromImageId(state.workspace.photosIds[index]),
                                      httpHeaders: NetworkController().getAuthHeader(),
                                      placeholder: (context, url) => const Center(),
                                      errorWidget: (context, url, error) => const Icon(Icons.error),
                                    ),
                                  ),
                                ),
                              );
                            });
                      },
                    );
                  }),
            ),
          ),
          Container(
              margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
              child: Scrollbar(
                thumbVisibility: false,
                child: Column(
                  children: [
                    Text("Описание",
                        textAlign: TextAlign.left,
                        style: Theme.of(context)
                            .textTheme
                            .headlineSmall
                            ?.copyWith(
                                fontSize: 24,
                                fontWeight: FontWeight.w300)),
                    Container(
                      height: 0.3,
                      color: Colors.black54,
                    ),
                    SingleChildScrollView(
                      child: Center(
                        child: Text(
                          state.workspace.description,
                          style: Theme.of(context).textTheme.headlineSmall!
                              .copyWith(fontSize: 18),
                          textAlign: TextAlign.justify,
                        ),
                      ),
                    ),
                  ],
                ),
              )),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 00.0),
            child: SizedBox(
              height: 140,
              child: SfRangeSliderTheme(
                data: SfRangeSliderThemeData(
                  activeLabelStyle: Theme.of(context).textTheme.bodyLarge
                      ?.copyWith(
                      fontSize: 14,
                      fontStyle: FontStyle.normal),
                  inactiveLabelStyle: Theme.of(context).textTheme.bodyMedium
                      ?.copyWith(
                      fontSize: 14,
                      fontStyle: FontStyle.normal),
                  tooltipTextStyle: Theme.of(context).textTheme.bodyLarge
                      ?.copyWith(
                      fontSize: 14,
                      fontStyle: FontStyle.normal),
                  overlappingTooltipStrokeColor: Theme.of(context).primaryColor,
                  tooltipBackgroundColor: Theme.of(context).colorScheme.surface,
                  disabledActiveTrackColor: Colors.grey,
                  disabledInactiveTrackColor: Colors.grey,
                  disabledActiveTickColor: Colors.grey,
                  disabledInactiveTickColor: Colors.grey,
                  disabledActiveMinorTickColor: Colors.grey,
                  disabledInactiveMinorTickColor: Colors.grey,
                  disabledActiveDividerColor: Colors.red,
                  disabledInactiveDividerColor: Colors.grey,
                  disabledThumbColor: Colors.grey,
                  activeTrackColor: Theme.of(context).primaryColor,
                  inactiveTrackColor: Colors.grey,
                  activeTickColor: Theme.of(context).primaryColor,
                  inactiveTickColor: Colors.grey,
                  activeMinorTickColor: Theme.of(context).primaryColor,
                  inactiveMinorTickColor: Colors.grey,
                  activeDividerColor: Theme.of(context).primaryColor,
                  inactiveDividerColor: Colors.grey,
                  thumbColor: Theme.of(context).primaryColor,
                ),
                child: Center(
                  child: Scrollbar(
                    thickness: 10,
                    controller: _sliderListScrollController,
                    thumbVisibility: true,
                    child: ListView.builder(
                      //physics: NeverScrollableScrollPhysics(),
                      controller: _sliderListScrollController,
                      primary: false,
                      scrollDirection: Axis.horizontal,
                      shrinkWrap: true,
                      itemCount: state.rangeValuesList.length,
                      itemBuilder: (context, index) {
                        return Center(child: getSliderNEW(index, state));
                      },
                    ),
                  ),
                ),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(10),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              mainAxisSize: MainAxisSize.max,
              children: [
                Container(
                  decoration: BoxDecoration(
                    //color: appThemeData.colorScheme.tertiary,
                    borderRadius: BorderRadius.circular(5),
                  ),
                  child: Row(
                    children: [
                      Text("Начало: ",
                          style: Theme.of(context).textTheme.titleLarge),
                      Text(
                        DateFormat("HH:mm").format(state
                            .rangeValuesList[state.activeSliderIndex].start),
                        style: Theme.of(context).textTheme.titleLarge,
                      ),
                    ],
                  ),
                ),
                Container(
                  decoration: BoxDecoration(
                      //color: appThemeData.colorScheme.tertiary,
                      borderRadius: BorderRadius.circular(5)),
                  child: Row(
                    children: [
                      Text(
                        "Конец: ",
                        style: Theme.of(context).textTheme.titleLarge,
                      ),
                      Text(
                        DateFormat("HH:mm").format(
                            state.rangeValuesList[state.activeSliderIndex].end),
                        style: Theme.of(context).textTheme.titleLarge,
                      ),
                    ],
                  ),
                )
              ],
            ),
          ),
          Padding(
              padding: const EdgeInsets.fromLTRB(30, 00, 30, 40),
              child: AtbElevatedButton(
                  onPressed: () {
                    NewBookingSheetBloc()
                        .add(NewBookingSheetButtonPressEvent());
                    _buildConfirmationPopupWidget(context);
                  },
                  text: 'Забронировать')),
        ],
      ),
    );
  }
}

class _SheetLoadedEmptyWidget extends StatelessWidget {
  final NewBookingSheetLoadedState state;

  const _SheetLoadedEmptyWidget({required this.state});

  @override
  Widget build(BuildContext context) {
    getSize() {
      if (state.workspace.photosIds.isEmpty) return 0.0;
      if (state.workspace.photosIds.length == 1) return 250.0;
      return 200.0;
    }

    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      mainAxisSize: MainAxisSize.min,
      children: [
        AppBar(
          title: Text(
            state.workspace.type.type,
            style: Theme.of(context).textTheme.labelMedium?.copyWith(
                fontSize: 18, color: Theme.of(context).colorScheme.onSurface),
          ),
        ),
        SizedBox(
          height: getSize(), //getSize(),
          child: ListView.builder(
              shrinkWrap: true,
              scrollDirection: Axis.horizontal,
              itemCount: state.workspace.photosIds.length,
              //state.workspace.photos.length,
              itemBuilder: (context, index) {
                return GestureDetector(
                  behavior: HitTestBehavior.translucent,
                  child: CachedNetworkImage(
                    fit: BoxFit.cover,
                    imageUrl: AppImageProvider.getImageUrlFromImageId(state.workspace.photosIds[index
                    ]),
                    httpHeaders: NetworkController().getAuthHeader(),
                    placeholder: (context, url) => const Center(),
                    errorWidget: (context, url, error) => const Icon(Icons.error),
                  ),
                  onTap: () {
                    showDialog(
                        useRootNavigator: false,
                        context: context,
                        builder: (BuildContext context) {
                          return GestureDetector(
                            behavior: HitTestBehavior.translucent,
                            onTap: () {
                              int count = 0;
                              Navigator.popUntil(context, (route) {
                                return count++ == 1;
                              });
                            },
                            child: InteractiveViewer(
                              transformationController:
                                  TransformationController(),
                              maxScale: 2.0,
                              minScale: 0.1,
                              child: AlertDialog(
                                //clipBehavior: Clip.none,
                                shape: const RoundedRectangleBorder(
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(0.0))),
                                insetPadding: const EdgeInsets.symmetric(
                                    horizontal: 10, vertical: 200),
                                contentPadding: const EdgeInsets.symmetric(
                                    horizontal: 10, vertical: 10),
                                content: CachedNetworkImage(
                                  fit: BoxFit.cover,
                                  imageUrl: AppImageProvider.getImageUrlFromImageId(state.workspace.photosIds[index]),
                                  httpHeaders: NetworkController().getAuthHeader(),
                                  placeholder: (context, url) => const Center(),
                                  errorWidget: (context, url, error) => const Icon(Icons.error),
                                )

                              ),
                            ),
                          );
                        });
                  },
                );
              }),
        ),
        Container(
            margin: const EdgeInsets.symmetric(vertical: 0.0),
            child: Scrollbar(
              thumbVisibility: false,
              child: SingleChildScrollView(
                child: SizedBox(
                  height: 120,
                  child: Center(
                    child: Text(
                      state.workspace.description,
                      style: Theme.of(context).textTheme.headlineSmall!
                          .copyWith(fontSize: 18),
                    ),
                  ),
                ),
              ),
            )),
        Padding(
            padding: const EdgeInsets.symmetric(vertical: 00.0),
            child: SizedBox(
                width: 600,
                height: 140,
                child: Text(
                  "Нет доступных окон на это число",
                  textAlign: TextAlign.center,
                  style: Theme.of(context).textTheme.displaySmall,
                ))),
        Padding(
            padding: const EdgeInsets.fromLTRB(30, 00, 30, 40),
            child: AtbElevatedButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                text: 'Вернуться назад')),
      ],
    );
  }
}

Future<void> _buildConfirmationPopupWidget(BuildContext context) {
  return showDialog<void>(
    useRootNavigator: false,
    context: context,
    builder: (BuildContext context) {
      return const AlertDialog(
          insetPadding: EdgeInsets.symmetric(horizontal: 10, vertical: 200),
          contentPadding: EdgeInsets.symmetric(horizontal: 10, vertical: 50),
          content: NewBookingConfirmationPopup());
    },
  );
}
