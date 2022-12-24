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

class ChartData {
  final DateTime date;
  final int value;

  ChartData(this.date, this.value);
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
          decoration: const InputDecoration(
            border: OutlineInputBorder(),
            labelText: _defaultText,
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
    return SfCartesianChart(
        // Initialize category axis
        primaryYAxis: NumericAxis(
            title: AxisTitle(
                text: 'Число бронирований',
                textStyle: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w300
                )
            )
        ),
        primaryXAxis: DateTimeAxis(
            dateFormat: DateFormat.MMM("ru_RU")
        ),
        series: <CartesianSeries>[
          ColumnSeries<ChartData, DateTime>(
              dataSource: [
                // Bind data source
                ChartData(DateTime(2022, 1,0), 35),
                ChartData(DateTime(2022, 2,0), 28),
                ChartData(DateTime(2022, 3,0), 34),
                ChartData(DateTime(2022, 4,0), 32),
                ChartData(DateTime(2022, 5,0), 70),
                ChartData(DateTime(2022, 6,0), 41),
                ChartData(DateTime(2022, 7,0), 20),
                ChartData(DateTime(2022, 8,0), 100),
                ChartData(DateTime(2022, 9,0), 24),
                ChartData(DateTime(2022, 10,0), 45),
                ChartData(DateTime(2022, 11,0), 33),

              ],
              xValueMapper: (ChartData data, _) => data.date,
              yValueMapper: (ChartData data, _) => data.value)
        ]);
  }
}

class _AlwaysDisabledFocusNode extends FocusNode {
  @override
  bool get hasFocus => false;
}
