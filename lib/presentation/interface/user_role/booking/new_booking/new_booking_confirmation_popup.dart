
import 'package:atb_booking/logic/user_role/booking/booking_list_bloc/booking_list_bloc.dart';
import 'package:atb_booking/logic/user_role/booking/new_booking/new_booking_bloc/new_booking_sheet_bloc/new_booking_confirmation_popup_bloc.dart';
import 'package:atb_booking/presentation/widgets/elevated_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class NewBookingConfirmationPopup extends StatelessWidget {
  const NewBookingConfirmationPopup({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: BlocConsumer<NewBookingConfirmationPopupBloc,
          NewBookingConfirmationPopupState>(
        bloc: NewBookingConfirmationPopupBloc(),
        listener: (context, state) {
          // TODO: implement listener
        },
        builder: (context, state) {
          if (state is NewBookingConfirmationPopupInitialState) {
            return const Center(
              child: Text("initial state"),
            );
          }
          if (state is NewBookingConfirmationPopupLoadingState) {
            return const CircularProgressIndicator();
          }
          if (state is NewBookingConfirmationPopupSuccessfulState) {
            return _successfulWidget(context);
          }
          if (state is NewBookingConfirmationPopupErrorState) {
            return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                Text(
                  "Упс, что-то пошло не так...",
                  textAlign: TextAlign.center,
                  style: Theme.of(context).textTheme.titleLarge!.copyWith(
                      color: const Color.fromARGB(255, 49, 41, 0), fontSize: 30),
                ),
                AtbElevatedButton(
                    onPressed: () {
                      var popCounter = 2;
                      Navigator.of(context).popUntil((route) {
                        if (popCounter > 0) {
                          popCounter--;
                          return false;
                        }
                        return true;
                      });
                      // Navigator.of(context).push(
                      //     MaterialPageRoute(builder: (context) => NewBookingScreen()));
                      ///back to BookingListScreen
                    },
                    text: "Назад"),
              ],
            ));
          }
          throw Exception("badState");
        },
      ),
    );
  }

  Widget _successfulWidget(BuildContext context) {
    return Center(
      child: Container(
        width: double.infinity,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            Text(
              "Успешно\n забронированно ✓",
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.titleLarge!.copyWith( fontSize: 30),
            ),
            AtbElevatedButton(
                onPressed: () {
                  var popCounter = 2;
                  Navigator.of(context).popUntil((route) {
                    if (popCounter > 0) {
                      popCounter--;
                      return false;
                    }
                    return true;
                  });
                  // Navigator.of(context).push(
                  //     MaterialPageRoute(builder: (context) => NewBookingScreen()));
                  ///back to BookingListScreen
                },
                text: "Забронировать еще"),
            AtbElevatedButton(
                onPressed: () {
                  BookingListBloc().add(BookingListLoadEvent());
                  Navigator.of(context).popUntil((route) => route.isFirst);

                  ///back to BookingListScreen
                },
                text: "К списку броней")
          ],
        ),
      ),
    );
  }
}
