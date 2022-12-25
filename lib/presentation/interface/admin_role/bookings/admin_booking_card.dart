
import 'package:atb_booking/data/models/booking.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class AdminBookingCard extends StatelessWidget {
  final Booking booking;

  const AdminBookingCard(this.booking);

  @override
  Widget build(BuildContext context) {
    return Center(
        child: Card(
            clipBehavior: Clip.antiAliasWithSaveLayer,
            elevation: 3,
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12.0)),
            child: Padding(
              padding: const EdgeInsets.all(5.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  Expanded(
                    flex: 12,
                    child: Center(
                      child: ListTile(
                        contentPadding: const EdgeInsets.only(left: 10),
                        title: Text(
                          booking.workspace.type.type,
                          style: Theme.of(context).textTheme.titleMedium,
                        ),
                        subtitle: Text(
                          'c ' +
                              DateFormat('HH:mm')
                                  .format(booking.reservationInterval.start) +
                              " до " +
                              DateFormat('HH:mm')
                                  .format(booking.reservationInterval.end) +
                              '\n' +
                              DateFormat.yMMMMd("ru_RU")
                                  .format(booking.reservationInterval.start),
                          style: Theme.of(context).textTheme.titleMedium,
                        ),
                        //trailing: trailing ? Icon(Icons.cancel, color: Colors.black) : null,
                      ),
                    ),
                  ),
                  Expanded(
                      flex: 12,
                      child: Center(
                        child: ListTile(
                          contentPadding: EdgeInsets.zero,
                          title: Text(booking.cityName,
                              style: Theme.of(context).textTheme.titleMedium),
                          subtitle: Text(booking.officeAddress,
                              style: Theme.of(context).textTheme.titleMedium),
                        ),
                      ))
                ],
              ),
            )));
  }
}
