import 'package:atb_booking/data/models/booking.dart';
import 'package:atb_booking/data/models/user.dart';
import 'package:atb_booking/data/services/image_provider.dart';
import 'package:atb_booking/data/services/network/network_controller.dart';
import 'package:atb_booking/logic/admin_role/people/person_booking_list/admin_person_booking_list_bloc.dart';
import 'package:atb_booking/logic/user_role/booking/booking_details_bloc/booking_details_bloc.dart';
import 'package:atb_booking/presentation/interface/user_role/booking/booking_details/booking_details_screen.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';

class _PersonInfoWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AdminPersonBookingListBloc, AdminPersonBookingListState>(
        builder: (context, state) {
      if (state is AdminPersonBookingListLoadedState) {
        User user = state.user;
        return Card(
          margin: EdgeInsets.zero,
          elevation: 1,
          shape: RoundedRectangleBorder(
              side: const BorderSide(width: 0.2, color: Colors.black38),
              borderRadius: BorderRadius.circular(0.0)),
          clipBehavior: Clip.antiAliasWithSaveLayer,
          child: Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: ClipOval(
                child: Container(
                  height: 90,
                  width: 90,
                  child: CachedNetworkImage(
                      fit: BoxFit.cover,
                      imageUrl: AppImageProvider.getImageUrlFromImageId(
                        user.avatarImageId,
                      ),
                      httpHeaders: NetworkController().getAuthHeader(),
                      progressIndicatorBuilder:
                          (context, url, downloadProgress) => Center(
                              child: CircularProgressIndicator(
                                  value: downloadProgress.progress)),
                      errorWidget: (context, url, error) => Container()),
                ),
              ),
            ),
            Expanded(
              child: Container(
                padding: const EdgeInsets.all(10.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      user.fullName,
                      style: Theme.of(context)
                          .textTheme
                          .headlineSmall
                          ?.copyWith(
                              fontSize: 25,
                              color: Theme.of(context).colorScheme.primary),
                    ),
                    Text(
                      user.email,
                      style: Theme.of(context).textTheme.bodyLarge,
                    ),
                    Text(
                      user.phone,
                      style: Theme.of(context).textTheme.bodyLarge,
                    ),
                  ],
                ),
              ),
            ),
          ]),
        );
      } else {
        return const Center(
          child: CircularProgressIndicator(),
        );
      }
    });
  }
}

class AdminPersonBookingListPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    ScrollController scrollController = ScrollController();
    return Scaffold(
      appBar: AppBar(
        title: const Text("Брони пользователя"),
        centerTitle: true,
      ),
      body: Column(
        children: [
          _PersonInfoWidget(),
          const _BookingList(),
        ],
      ),
    );
  }
}

class _BookingList extends StatelessWidget {
  const _BookingList({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AdminPersonBookingListBloc, AdminPersonBookingListState>(
      builder: (context, state) {
        if (state is AdminPersonBookingListLoadedState) {
          if (state.bookingList.isEmpty) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }
          return Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10.0),
              child: ListView.builder(
                itemCount: state.bookingList.length,
                itemBuilder: (context, index) {
                  var bookingData = state.bookingList[index];
                  return GestureDetector(
                    onTap: () {
                      Navigator.of(context).push(MaterialPageRoute(
                          builder: (context) => BlocProvider<BookingDetailsBloc>(
                                create:(_)=>BookingDetailsBloc(bookingData.id, true),
                                child: const BookingDetailsScreen(),
                              )));
                    },
                    child: _BookingCard(bookingData),
                  );
                },
              ),
            ),
          );
        } else {
          return const SizedBox.shrink();
        }
      },
    );
  }
}

class _BookingCard extends StatelessWidget {
  final Booking booking;

  const _BookingCard(this.booking);

  @override
  Widget build(BuildContext context) {
    return Center(
        child: Card(
            clipBehavior: Clip.antiAliasWithSaveLayer,
            elevation: 1,
            shape: RoundedRectangleBorder(
                side: const BorderSide(
                    width: 0.3, color: Color.fromARGB(255, 200, 194, 207)),
                borderRadius: BorderRadius.circular(12.0)),
            color: Colors.white,
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
