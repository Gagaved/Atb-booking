import 'package:atb_booking/logic/user_role/booking/booking_details_bloc/booking_details_bloc.dart';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class BookingDeleteDialog extends StatelessWidget {
  const BookingDeleteDialog({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<BookingDetailsBloc, BookingDetailsState>(
        builder: (context, state) {
      if (state is BookingDetailsLoadedState) {
        return AlertDialog(
          insetPadding:
              const EdgeInsets.symmetric(vertical: 30, horizontal: 30),
          content: Text(
            'Вы действительно хотите отменить бонирование?',
            style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                fontSize: 20,
                fontWeight: FontWeight.w300),
          ),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.pop(context, 'Cancel');
              },
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
                    .read<BookingDetailsBloc>()
                    .add(BookingDetailsDeleteEvent());
                Navigator.popUntil(context, (route) {
                  return route.isFirst;
                });
              },
              child: Text(
                'Отменить',
                style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                    fontSize: 20,
                    fontWeight: FontWeight.w500),
              ),
            ),
          ],
        );
      } else {
        throw ErrorWidget((Exception("unexpected state: $state")));
      }
    });
  }
}
