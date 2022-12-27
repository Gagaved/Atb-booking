
import 'package:atb_booking/data/models/booking.dart';
import 'package:atb_booking/logic/user_role/booking/booking_details_bloc/booking_details_bloc.dart';
import 'package:atb_booking/presentation/interface/admin_role/bookings/admin_booking_details_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';

class _AdminBookingCard extends StatelessWidget {
  final Booking booking;

  const _AdminBookingCard(this.booking);

  @override
  Widget build(BuildContext context) {
    return Center(
        child: Card(
            clipBehavior: Clip.antiAliasWithSaveLayer,
            elevation: 3,
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12.0)),
            child: InkWell(
              onTap: (){
                Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (context) => BlocProvider(
                        create: (context) => BookingDetailsBloc(booking.id,true),
                        child: const AdminBookingDetailsScreen(),
                      ),
                    ));
              },
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
              ),
            )));
  }
}
