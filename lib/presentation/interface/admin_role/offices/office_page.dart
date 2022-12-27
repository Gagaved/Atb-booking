import 'package:atb_booking/data/models/level_plan.dart';
import 'package:atb_booking/logic/admin_role/offices/LevelPlanEditor/level_plan_editor_bloc.dart';
import 'package:atb_booking/logic/admin_role/offices/booking_stats/admin_booking_stats_bloc.dart';
import 'package:atb_booking/logic/admin_role/offices/bookings_page/admin_bookings_bloc.dart';
import 'package:atb_booking/logic/admin_role/offices/office_page/admin_office_page_bloc.dart';
import 'package:atb_booking/logic/admin_role/offices/offices_screen/admin_offices_bloc.dart';
import 'package:atb_booking/presentation/interface/admin_role/offices/bookings_page.dart';
import 'package:atb_booking/presentation/interface/admin_role/offices/booking_stats_page.dart';
import 'package:atb_booking/presentation/interface/admin_role/offices/level_editor_page.dart';
import 'package:atb_booking/presentation/widgets/elevated_button.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:syncfusion_flutter_core/theme.dart';
import 'package:syncfusion_flutter_sliders/sliders.dart';

class OfficePage extends StatelessWidget {
  const OfficePage({super.key});

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        context.read<AdminOfficesBloc>().add(AdminOfficesReloadEvent());
        return true;
      },
      child: GestureDetector(
        onTap: () {
          FocusScope.of(context).unfocus();
          context
              .read<AdminOfficePageBloc>()
              .add(AdminOfficePageUpdateFieldsEvent());
        },
        child: BlocBuilder<AdminOfficePageBloc, AdminOfficePageState>(
          builder: (context, state) {
            if (state is AdminOfficePageLoadedState) {
              return Scaffold(
                appBar: AppBar(
                  title: const Text("Офис"),
                  actions: [
                    TextButton(
                        onPressed: () {
                          showDialog(
                              useRootNavigator: false,
                              context: context,
                              builder: (_) {
                                return MultiBlocProvider(providers: [
                                  BlocProvider.value(
                                    value: context.read<AdminOfficePageBloc>(),
                                  ),
                                  BlocProvider.value(
                                    value: context.read<
                                        AdminOfficesBloc>(), //context.read<AdminOfficePageBloc>(),
                                  ),
                                ], child: const _DeleteConfirmDialog());
                              });
                        },
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text(
                            "удалить",
                            style: Theme.of(context)
                                .textTheme
                                .headlineSmall
                                ?.copyWith(
                                    decoration: TextDecoration.underline,
                                    color: Colors.red,
                                    fontSize: 20),
                          ),
                        ))
                  ],
                ),
                body: SingleChildScrollView(
                  child: Column(
                    children: [
                      _OfficeAddress(
                        state: state,
                      ),
                      _BookingRange(state: state),
                      _WorkTimeRange(state: state),
                      state.isSaveButtonActive
                          ? const _SaveButton()
                          : const SizedBox.shrink(),
                      Padding(
                        padding: const EdgeInsets.all(15.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: const [
                            _StatisticsButton(),
                            _BookingsButton()
                          ],
                        ),
                      ),
                      _LevelsList(state: state),
                    ],
                  ),
                ),
              );
            } else if (state is AdminOfficePageLoadingState) {
              return Scaffold(
                appBar: AppBar(title: const Text("Офис")),
                body: const Center(
                  child: CircularProgressIndicator(),
                ),
              );
            } else if (state is AdminOfficePageErrorState) {
              return Scaffold(
                appBar: AppBar(title: const Text("Офис")),
                body: Center(
                  child: Text(
                  "Не удалось загрузить офис. Проверьте интернет подключение",
                  style: Theme
                      .of(context)
                      .textTheme
                      .headlineSmall
                      ?.copyWith(
                      fontSize: 22,
                      fontWeight: FontWeight.w300),
                  textAlign: TextAlign.center,

                ),
                ),
              );
            } else if (state is AdminOfficePageInitial) {
              return Center(
                child: Text(
                  "",
                  style: Theme
                      .of(context)
                      .textTheme
                      .headlineSmall
                      ?.copyWith(
                      fontSize: 22,
                      fontWeight: FontWeight.w300),
                  textAlign: TextAlign.center,

                ),
              );
            } else {
              throw Exception("unknown AdminOfficePageState $state");
            }
          },
        ),
      ),
    );
  }
}

class _OfficeAddress extends StatelessWidget {
  static TextEditingController? _officeAddressController =
      TextEditingController();
  final AdminOfficePageLoadedState state;

  _OfficeAddress({required this.state});

  @override
  Widget build(BuildContext context) {
    if (state.address != _officeAddressController!.text) {
      _officeAddressController = TextEditingController(text: state.address);
    }
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 30.0, vertical: 5),
      child: Column(
        children: [
          SizedBox(
            width: double.infinity,
            child: Padding(
              padding: const EdgeInsets.only(left: 8.0),
              child: Text("Адрес",
                  textAlign: TextAlign.left,
                  style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                      fontSize: 20,
                      fontWeight: FontWeight.w300)),
            ),
          ),
          SizedBox(
            width: double.infinity,
            child: TextField(
              decoration: InputDecoration(
                filled: true,
                fillColor: Theme.of(context).backgroundColor,
                border: const OutlineInputBorder(
                  borderSide: BorderSide.none,
                  borderRadius: BorderRadius.all(Radius.circular(10.0)),
                ),
              ),
              keyboardType: TextInputType.streetAddress,
              onTap: () {
                context
                    .read<AdminOfficePageBloc>()
                    .add(AdminOfficePageUpdateFieldsEvent());
              },
              onChanged: (form) {
                context
                    .read<AdminOfficePageBloc>()
                    .add(AdminOfficeAddressChangeEvent(form));
              },
              controller: _officeAddressController,
              style: Theme.of(context)
                  .textTheme
                  .headlineSmall
                  ?.copyWith( fontSize: 20),
              maxLines: 4,
              minLines: 1,
              maxLength: 1000,
              //keyboardType: TextInputType.multiline,
            ),
          )
        ],
      ),
    );
  }
}

class _BookingRange extends StatelessWidget {
  static TextEditingController? _bookingRangeController;
  final AdminOfficePageLoadedState state;

  _BookingRange({required this.state}) {
    if (_bookingRangeController == null) {
      _bookingRangeController =
          TextEditingController(text: state.bookingRange.toString());
    } else {
      if (state.address != _bookingRangeController!.text) {
        _bookingRangeController =
            TextEditingController(text: state.bookingRange.toString());
      }
    }
    _bookingRangeController!.selection = TextSelection(
        baseOffset: 0, extentOffset: _bookingRangeController!.text.length);
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 30.0, vertical: 5),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            flex: 9,
            child: Row(
              children: [
                Text("Дальность \nбронирования в днях",
                    textAlign: TextAlign.right,
                    style: Theme.of(context).textTheme.headlineSmall?.copyWith(

                        fontSize: 20,
                        fontWeight: FontWeight.w300)),
                const SizedBox(
                  width: 5,
                ),
                Container(
                  height: 60,
                  width: 0.3,
                  color: Theme.of(context).backgroundColor,
                )
              ],
            ),
          ),
          Expanded(
            flex: 5,
            child: Padding(
              padding: const EdgeInsets.only(left: 20),
              child: TextField(
                textAlign: TextAlign.center,
                decoration: InputDecoration(
                  filled: true,
                  fillColor: Theme.of(context).backgroundColor,
                  border: const OutlineInputBorder(
                    borderSide: BorderSide.none,
                    borderRadius: BorderRadius.all(Radius.circular(10.0)),
                  ),
                ),
                keyboardType: TextInputType.number,
                onTap: () {
                  print('tap');
                  context
                      .read<AdminOfficePageBloc>()
                      .add(AdminOfficePageUpdateFieldsEvent());
                },
                onChanged: (form) {
                  print("controller.text: ${_bookingRangeController!.text}");
                  context
                      .read<AdminOfficePageBloc>()
                      .add(AdminBookingRangeChangeEvent(int.parse(form)));
                },
                onSubmitted: (form) {
                  context
                      .read<AdminOfficePageBloc>()
                      .add(AdminOfficePageUpdateFieldsEvent());
                },
                controller: _bookingRangeController,
                style: Theme.of(context)
                    .textTheme
                    .headlineSmall
                    ?.copyWith( fontSize: 22),
                //keyboardType: TextInputType.multiline,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _WorkTimeRange extends StatelessWidget {
  final AdminOfficePageLoadedState state;

  const _WorkTimeRange({required this.state});

  @override
  Widget build(BuildContext context) {
    var values =
        SfRangeValues(state.workTimeRange.start, state.workTimeRange.end);
    var start = DateFormat('HH:mm').format(state.workTimeRange.start);
    var end = DateFormat('HH:mm').format(state.workTimeRange.end);
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(30.0, 10, 30, 0),
          child: Column(
            children: [
              SizedBox(
                width: double.infinity,
                child: Text("Время работы: c $start до $end",
                    textAlign: TextAlign.left,
                    style: Theme.of(context).textTheme.headlineSmall?.copyWith(

                        fontSize: 20,
                        fontWeight: FontWeight.w300)),
              ),
              Container(
                height: 0.3,
                color: Theme.of(context).backgroundColor,
              ),
            ],
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 5.0),
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
            child: SfRangeSlider(
                showTicks: true,
                showDividers: true,
                minorTicksPerInterval: 2,
                values: values,
                min: DateTime(
                    state.workTimeRange.start.year,
                    state.workTimeRange.start.month,
                    state.workTimeRange.start.day,
                    0),
                max: DateTime(
                    state.workTimeRange.start.year,
                    state.workTimeRange.start.month,
                    state.workTimeRange.start.day,
                    24),
                showLabels: true,
                interval: 4,
                stepDuration: const SliderStepDuration(minutes: 30),
                dateIntervalType: DateIntervalType.hours,
                //numberFormat: NumberFormat('\$'),
                dateFormat: DateFormat.Hm(),
                enableTooltip: true,
                onChanged: (newValues) {
                  context
                      .read<AdminOfficePageBloc>()
                      .add(AdminOfficePageWorkRangeChangeEvent(DateTimeRange(
                        start: newValues.start,
                        end: newValues.end,
                      )));
                  //values = newValues;
                }),
          ),
        ),
      ],
    );
  }
}

class _SaveButton extends StatelessWidget {
  const _SaveButton({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(15.0),
      child: AtbElevatedButton(
        onPressed: () {
          context
              .read<AdminOfficePageBloc>()
              .add(AdminOfficeSaveChangesButtonEvent());
        },
        text: 'Сохранить изменения',
      ),
    );
  }
}

class _LevelsList extends StatelessWidget {
  const _LevelsList({Key? key, required this.state}) : super(key: key);
  final AdminOfficePageLoadedState state;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(30, 15, 30, 0),
      child: Column(
        children: [
          SizedBox(
            width: double.infinity,
            child: Text("Этажи",
                textAlign: TextAlign.left,
                style: Theme.of(context).textTheme.headlineSmall?.copyWith(

                    fontSize: 24,
                    fontWeight: FontWeight.w300)),
          ),
          const SizedBox(
            width: 5,
          ),
          Container(
            height: 0.3,
            width: double.infinity,
            color: Theme.of(context).colorScheme.surface
          ),
          ListView.builder(
            physics: const NeverScrollableScrollPhysics(),
            shrinkWrap: true,
            itemCount: state.levels.length,
            itemBuilder: (context, index) {
              return _LevelCard(level: state.levels[index]);
            },
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 5.0, vertical: 8),
            child: _AddNewLevelButton(
              state: state,
            ),
          )
        ],
      ),
    );
  }
}

class _LevelCard extends StatelessWidget {
  const _LevelCard({Key? key, required this.level}) : super(key: key);
  final LevelListItem level;

  @override
  Widget build(BuildContext context) {
    return Card(
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: () {
          Navigator.of(context).push(PageRouteBuilder(
            pageBuilder: (_, animation, secondaryAnimation) =>
                MultiBlocProvider(providers: [
              BlocProvider.value(
                value: context.read<AdminOfficePageBloc>(),
              ),
              BlocProvider<LevelPlanEditorBloc>(
                create: (_) => LevelPlanEditorBloc()
                  ..add(LevelPlanEditorLoadWorkspacesFromServerEvent(level.id)),
              ),
            ], child: const LevelEditorPage()),
            transitionsBuilder:
                (context, animation, secondaryAnimation, child) {
              const begin = Offset(1.0, 0.0);
              const end = Offset.zero;
              const curve = Curves.ease;

              var tween =
                  Tween(begin: begin, end: end).chain(CurveTween(curve: curve));

              return SlideTransition(
                position: animation.drive(tween),
                child: child,
              );
            },
          ));
        },
        child: ListTile(
          title: Text("${level.number} Этаж"),
        ),
      ),
    );
  }
}

class _DeleteConfirmDialog extends StatelessWidget {
  const _DeleteConfirmDialog({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AdminOfficePageBloc, AdminOfficePageState>(
      listener: (_, state) {
        if (state is AdminOfficePageDeleteSuccessState) {
          context.read<AdminOfficesBloc>().add(AdminOfficesReloadEvent());
          Navigator.pop(context);
          Navigator.pop(context);
          //Navigator.popUntil(context, (route) => route.isFirst);
        }
      },
      builder: (context, state) {
        if (state is AdminOfficePageDeleteErrorState) {
          return const AlertDialog(
            content: Text("Ошибка при удалении"),
          );
        }
        if (state is AdminOfficePageDeleteLoadingState) {
          return const Center(child: CircularProgressIndicator());
        }
        return AlertDialog(
          title: const Text('Удалить офис?'),
          content: Text(
            'После удаления все созданные брони в этом офисе будут отменены.\n Вы уверены что хотите удалить офис?',
            style: Theme.of(context).textTheme.headlineSmall?.copyWith(

                fontSize: 20,
                fontWeight: FontWeight.w300),
          ),
          actions: <Widget>[
            TextButton(
              onPressed: () => Navigator.pop(context, 'Cancel'),
              child: Text(
                'Отмена',
                style: Theme.of(context).textTheme.headlineSmall?.copyWith(

                    fontSize: 20,
                    fontWeight: FontWeight.w500),
              ),
            ),
            TextButton(
              onPressed: () {
                context
                    .read<AdminOfficePageBloc>()
                    .add(AdminOfficeDeleteEvent());
              },
              child: Text(
                'Удалить',
                style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                    fontSize: 20,
                    fontWeight: FontWeight.w500),
              ),
            ),
          ],
        );
      },
    );
  }
}

class _StatisticsButton extends StatelessWidget {
  const _StatisticsButton({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AdminOfficePageBloc, AdminOfficePageState>(
  builder: (context, state) {
    if(state is AdminOfficePageLoadedState){
    return MaterialButton(
      shape: RoundedRectangleBorder(
          side: BorderSide(width: 1, color: Theme.of(context).primaryColor),
          borderRadius: BorderRadius.circular(7.0)),
      onPressed: () {
        Navigator.of(context).push(MaterialPageRoute(
            builder: (context) => BlocProvider<AdminBookingStatsBloc>(
                  create: (context) => AdminBookingStatsBloc(state.officeId),
                  child: const AdminBookingsStatsPage(),
                )));
      },
      color: Theme.of(context).primaryColor,
      child: Row(
        children: [
          Text(
            "Статистика",
            style: Theme.of(context).textTheme.titleMedium!.copyWith(
              color: Colors.white,
            ),
          ),
          const SizedBox(
            width: 5,
          ),
          const Icon(Icons.query_stats,color: Colors.white,)
        ],
      ),
    );}else{
      return const SizedBox.shrink();
    }
  },
);
  }
}

class _BookingsButton extends StatelessWidget {
  const _BookingsButton({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AdminOfficePageBloc, AdminOfficePageState>(
  builder: (context, state) {
    if(state is AdminOfficePageLoadedState){
    return MaterialButton(
      shape: RoundedRectangleBorder(
          side: BorderSide(width: 1, color: Theme.of(context).primaryColor),
          borderRadius: BorderRadius.circular(7.0)),
      onPressed: () {
        Navigator.of(context).push(MaterialPageRoute(
            builder: (context) => BlocProvider<AdminBookingsBloc>(
                  create: (context) => AdminBookingsBloc(state.officeId),
                  child: AdminBookingsPage(),
                )));
      },
      color: Theme.of(context).primaryColor,
      child: Row(
        children: [
          Text(
            "Бронирования",
            style: Theme.of(context).textTheme.titleMedium!.copyWith(
              color: Colors.white,
            ),
          ),
          const SizedBox(
            width: 5,
          ),
          const Icon(Icons.cases_outlined,color: Colors.white,)
        ],
      ),
    );}else{
      return const SizedBox.shrink();
    }
  },
);
  }
}

class _AddNewLevelButton extends StatelessWidget {
  final AdminOfficePageLoadedState state;

  const _AddNewLevelButton({required this.state});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 20.0),
      child: MaterialButton(
        shape: RoundedRectangleBorder(
            side: BorderSide(width: 1, color: Theme.of(context).primaryColor),
            borderRadius: BorderRadius.circular(10.0)),
        onPressed: () {
          context
              .read<AdminOfficePageBloc>()
              .add(AdminOfficePageCreateNewLevelButtonPress());
          showDialog(
              useRootNavigator: false,
              context: context,
              builder: (_) {
                return BlocProvider.value(
                  value: context.read<AdminOfficePageBloc>(),
                  child:
                      BlocConsumer<AdminOfficePageBloc, AdminOfficePageState>(
                          builder: (context, state) {
                    if (state is AdminOfficePageErrorCreateLevelState) {
                      return const AlertDialog(
                        content: Text("Ошибка при создании..."),
                      );
                    }
                    return const Center(child: CircularProgressIndicator());
                  }, listener: (_, state) {
                    if (state is AdminOfficePageSuccessCreateLevelState) {
                      Navigator.pop(context);
                      Navigator.of(context).push(PageRouteBuilder(
                        pageBuilder: (_, animation, secondaryAnimation) =>
                            MultiBlocProvider(providers: [
                          BlocProvider.value(
                            value: context.read<AdminOfficePageBloc>(),
                          ),
                          BlocProvider(
                            create: (_) => LevelPlanEditorBloc()
                              ..add(
                                  LevelPlanEditorLoadWorkspacesFromServerEvent(
                                      state.levelId)),
                          ),
                        ], child: const LevelEditorPage()),
                        transitionsBuilder:
                            (context, animation, secondaryAnimation, child) {
                          const begin = Offset(1.0, 0.0);
                          const end = Offset.zero;
                          const curve = Curves.ease;

                          var tween = Tween(begin: begin, end: end)
                              .chain(CurveTween(curve: curve));

                          return SlideTransition(
                            position: animation.drive(tween),
                            child: child,
                          );
                        },
                      ));
                    }
                  }),
                );
              });
          // Navigator.of(context).push(MaterialPageRoute(builder: (Bcontext) {
          //   return MultiBlocProvider(providers: [
          //     BlocProvider.value(
          //       value: context.read<AdminOfficePageBloc>(),
          //     ),
          //     BlocProvider(
          //       create: (_)=>LevelPlanEditorBloc(),
          //     ),
          //   ], child: const LevelEditorPage());
          // }));
        },
        color: Theme.of(context).primaryColor,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 0.0, vertical: 10),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                "Добавить новый этаж",
                style: Theme.of(context).textTheme.titleMedium!.copyWith(
                  color: Colors.white,
                ),
              ),
              const SizedBox(
                width: 5,
              ),
              const Icon(Icons.add,color: Colors.white,)
            ],
          ),
        ),
      ),
    );
  }
}
