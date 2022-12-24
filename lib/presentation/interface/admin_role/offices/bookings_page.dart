import 'package:atb_booking/logic/admin_role/offices/bookings_page/admin_bookings_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';

class AdminBookingsPage extends StatelessWidget {
  AdminBookingsPage({Key? key}) : super(key: key);
  final _textEditingController = TextEditingController();
  final String _defaultText = "defaultText";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(),
        body: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 30),
          child: Column(children: [
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 10),
              child: _DateRangePickerWidget(onChanged: (_) {}),
            ),
            _BookingsList()

          ]),
        ));
  }
}

class _DateRangePickerWidget extends StatelessWidget {
  _DateRangePickerWidget({required this.onChanged});

  final void Function(DateTimeRange dateTimeRange) onChanged;
  static const String _defaultText = "Выберите дату";
  final TextEditingController _textEditingController =
  TextEditingController();

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AdminBookingsBloc, AdminBookingsState>(
      builder: (context, state) {
        var selectedDateTimeRange = state.selectedDateTimeRange;
        if (selectedDateTimeRange != null) {
          _textEditingController.text =
          "${DateFormat('dd.MM.yyyy').format(
              selectedDateTimeRange.start)} - ${DateFormat('dd.MM.yyyy')
              .format(selectedDateTimeRange.end)}";
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
              print("add AdminBookingsSelectNewRangeEvent to bloc");
              context.read<AdminBookingsBloc>().add(
                  AdminBookingsSelectNewRangeEvent(newDateTimeRange));
              // _textEditingController.text =
              //     "${DateFormat('dd.MM.yyyy').format(newDateTimeRange.start)} - ${DateFormat('dd.MM.yyyy').format(newDateTimeRange.end)}";
            }
          },
        );
      },
    );
  }
}

class _AlwaysDisabledFocusNode extends FocusNode {
  @override
  bool get hasFocus => false;
}

class _BookingsList extends StatelessWidget {
  _BookingsList({Key? key}) : super(key: key);
  final ScrollController _scrollController = ScrollController();
  @override
  Widget build(BuildContext context) {
    _scrollController.addListener(() {
      if (_scrollController.position.maxScrollExtent ==
          _scrollController.position.pixels) {
        context.read<AdminBookingsBloc>().add(AdminBookingsLoadNextPageEvent());
      }
    });
    return BlocBuilder<AdminBookingsBloc, AdminBookingsState>(
      // buildWhen: (context,state){
      //   return (state is AdminBookingsLoadingState || state is AdminBookingsLoadedState);
      // },
      builder: (context, state) {
        if(state is AdminBookingsLoadedState) {
          return Expanded(
          child:ListView.builder(
            controller: _scrollController,
              itemCount: state.bookings.length,
              itemBuilder: (context,index)
              {
                return Card(child: Container(height: 50,),);
              }),
        );
        }else if(state is AdminBookingsLoadingState){
          print("build loading state");
          return Expanded(
            child:ListView.builder(
                controller: _scrollController,
                itemCount: state.bookings.length,
                itemBuilder: (context,index)
                {
                  return Column(
                    children: [
                      Card(child: Container(height: 50,),),
                      if(state.bookings.length-1 == index) const Padding(
                        padding: EdgeInsets.all(15.0),
                        child: Center(child: CircularProgressIndicator(),),
                      )
                    ],
                  );
                }),
          );
        }
        if(state is AdminBookingsInitialState){
          return const Center(child: Text('initial state'),);
        }
        else{
          throw Exception("invalid state: $state");
        }
      },
    );
  }
}



