import 'package:atb_booking/data/models/office.dart';
import 'package:atb_booking/logic/admin_role/offices/booking_stats/admin_booking_stats_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

class AdminBookingsStatsPage extends StatelessWidget {
  const AdminBookingsStatsPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Статистика по офису"),),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(30.0),
            child: _DateRangePickerWidget(
              onChanged: (DateTimeRange dateTimeRange) {},
            ),
          ),
          const _Charts()
        ],
      ),
    );
  }
}


class _DateRangePickerWidget extends StatelessWidget {
  _DateRangePickerWidget({required this.onChanged});

  final void Function(DateTimeRange dateTimeRange) onChanged;
  static const String _defaultText = "Выберите дату";
  final TextEditingController _textEditingController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AdminBookingStatsBloc, AdminBookingStatsState>(
      builder: (context, state) {
        var selectedDateTimeRange = state.selectedDateTimeRange;
        if (selectedDateTimeRange != null) {
          _textEditingController.text =
              "${DateFormat('dd.MM.yyyy').format(selectedDateTimeRange.start)} - ${DateFormat('dd.MM.yyyy').format(selectedDateTimeRange.end)}";
        }
        return TextField(
          decoration: InputDecoration(
            hintText: "Выберите диапазон...",
            filled: true,
            fillColor: Theme.of(context).backgroundColor,
            border: const OutlineInputBorder(
              borderSide: BorderSide.none,
              borderRadius: BorderRadius.all(Radius.circular(10.0)),
            ),
            suffixIcon: const Icon(Icons.search),
          ),
          focusNode: _AlwaysDisabledFocusNode(),
          controller: _textEditingController,
          onTap: () async {
            DateTimeRange? newDateTimeRange = await showDateRangePicker(
              context: context,
              builder: (context, child) {
                return Theme(
                  data: ThemeData.light().copyWith(
                    colorScheme: ColorScheme.light(
                      primary: Theme.of(context).primaryColor,
                      onPrimary: Colors.white,
                      surface: Theme.of(context).primaryColor,
                      onSurface: Colors.black,
                    ),
                    dialogBackgroundColor: Colors.white,
                  ),
                  child: child!,
                );
              },
              firstDate: DateTime.now().add(const Duration(days: -100)),
              lastDate: DateTime.now().add(const Duration(days: 100)),
            );
            if (newDateTimeRange != null) {
              print("add AdminBookingStatsSelectNewRangeEvent to bloc");
              context
                  .read<AdminBookingStatsBloc>()
                  .add(AdminBookingStatsSelectNewRangeEvent(newDateTimeRange));
              _textEditingController.text =
                  "${DateFormat('dd.MM.yyyy').format(newDateTimeRange.start)} - ${DateFormat('dd.MM.yyyy').format(newDateTimeRange.end)}";
            }
          },
        );
      },
    );
  }
}

class _Charts extends StatelessWidget {
  const _Charts({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AdminBookingStatsBloc, AdminBookingStatsState>(
  builder: (context, state) {
    if(state is AdminBookingStatsLoadedState){
      DateFormat format;
      if(state.selectedDateTimeRange!.duration.inDays<60){
        format = DateFormat.MMMd("ru_RU");
      }else{
        format = DateFormat.MMM("ru_RU");
      }
    return SfCartesianChart(
        // Initialize category axis
        primaryYAxis: NumericAxis(
            rangePadding: ChartRangePadding.additional,
            title: AxisTitle(
                text: 'Число бронирований',
                textStyle: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w300
                )
            )
        ),
        primaryXAxis: DateTimeAxis(
          //minorTicksPerInterval: 10,
            dateFormat: format,
        ),
        legend: Legend(
          position: LegendPosition.bottom,
            isVisible: true,
            // Border color and border width of legend
        ),
        series: <CartesianSeries>[
          ColumnSeries<OfficeBookingStatsItem, DateTime>(
              name:'Рабочие места',
              dataSource: state.stats,
              xValueMapper: (OfficeBookingStatsItem data, _) => data.date,
              yValueMapper: (OfficeBookingStatsItem data, _) => data.workspace),
          ColumnSeries<OfficeBookingStatsItem, DateTime>(
              name:'Переговорки',
              color: Theme.of(context).primaryColor,
              dataSource: state.stats,
              xValueMapper: (OfficeBookingStatsItem data, _) => data.date,
              yValueMapper: (OfficeBookingStatsItem data, _) => data.meetingRoom)
        ]);
    }else{
      return CircularProgressIndicator(color: Colors.grey,);
    }
  },
);
  }
}

class _AlwaysDisabledFocusNode extends FocusNode {
  @override
  bool get hasFocus => false;
}
