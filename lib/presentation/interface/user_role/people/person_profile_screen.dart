import 'package:atb_booking/data/models/booking.dart';
import 'package:atb_booking/data/models/user.dart';
import 'package:atb_booking/data/models/workspace_type.dart';
import 'package:atb_booking/data/services/image_provider.dart';
import 'package:atb_booking/data/services/network/network_controller.dart';
import 'package:atb_booking/logic/user_role/people_profile_bloc/people_profile_booking_bloc.dart';
import 'package:atb_booking/presentation/constants/styles.dart';
import 'package:atb_booking/presentation/interface/user_role/booking/booking_details/booking_details_screen.dart';
import 'package:atb_booking/presentation/interface/user_role/booking/booking_list/booking_card_widget.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class PersonProfileScreen extends StatelessWidget {
  final User user;
  const PersonProfileScreen(this.user, {super.key});

  @override
  Widget build(BuildContext context) {
    ScrollController scrollController = ScrollController();
    return Scaffold(
      appBar: AppBar(
        title: const Text("Брони пользователя"),
        centerTitle: true,
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Card(
            margin: EdgeInsets.zero,
            elevation: 1,
            shape: RoundedRectangleBorder(
                side: const BorderSide(width: 0.2, color: Colors.black38),
                borderRadius: BorderRadius.circular(0.0)),
            clipBehavior: Clip.antiAliasWithSaveLayer,
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: ClipOval(
                    child:
                    Container(
                      height: 90,
                      width: 90,
                      child: CachedNetworkImage(
                          fit: BoxFit.cover,
                          imageUrl: AppImageProvider
                              .getImageUrlFromImageId(user.avatarImageId,),
                          httpHeaders: NetworkController()
                              .getAuthHeader(),
                          progressIndicatorBuilder: (context,
                              url, downloadProgress) =>
                              Center(
                                  child:
                                  CircularProgressIndicator(
                                      value:
                                      downloadProgress
                                          .progress)),
                          errorWidget: (context, url, error) =>
                              Container()),
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
                              color: appThemeData.colorScheme.primary),
                        ),
                        Text(
                          user.email,
                          style: appThemeData.textTheme.bodyLarge,),
                        Text(
                          user.phone,
                        style: appThemeData.textTheme.bodyLarge,),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 20),
          BlocConsumer<PeopleProfileBookingBloc, PeopleProfileBookingState>(
            listener: (context, state) {
              // TODO: implement listener
            },
            builder: (context, state) {
              return Expanded(
                child: (state is PeopleProfileBooking_LoadingState)
                    ? const Padding(
                        padding: EdgeInsets.fromLTRB(10.0, 0.0, 10.0, 0),
                        child: Center(
                          child: CircularProgressIndicator(),
                        ))
                    : (state is PeopleProfileBooking_LoadedState)
                        ? Padding(
                            padding:
                                const EdgeInsets.fromLTRB(10.0, 00.0, 10.0, 0),
                            child: Stack(children: <Widget>[
                              Scrollbar(
                                child: Expanded(
                                  child: ListView.builder(
                                    controller: scrollController,
                                    itemCount: state.bookingList.length,
                                    itemBuilder: (context, index) {
                                      final item = state.bookingList[index];
                                      return GestureDetector(
                                        onTap: () {
                                          PeopleProfileBookingBloc().add(
                                              PeopleProfileBookingCardTapEvent(
                                                  item.id));
                                          Navigator.of(context).push(
                                              MaterialPageRoute(
                                                  builder: (context) =>
                                                      BookingDetailsScreen()));
                                        },
                                        child: getBookingCard(
                                            state.bookingList[index],
                                            state.mapOfTypes),
                                      );
                                    },
                                  ),
                                ),
                              ),
                            ]),
                          )
                        : (state is PeopleProfileBooking_EmptyState)
                            ? Padding(
                                padding:
                                    EdgeInsets.fromLTRB(10.0, 0.0, 10.0, 0),
                                child: Center(
                                  child: Text(
                                    "Броней пока нет",
                                    textAlign: TextAlign.center,
                                    style: appThemeData.textTheme.titleLarge,
                                  ),
                                ))
                            : Center(
                                child: ErrorWidget(
                                    "ErrorStatePeopleProfileBookingBloc"),
                              ),
              );
            },
          )
        ],
      ),
    );
  }
}

BookingCard getBookingCard(
  Booking bookingData,
  Map<int, WorkspaceType> mapOfTypes,
) {
  return BookingCard(
      bookingData,
      bookingData.workspace.type.type,
      "assets/workplacelogo.png",
      (bookingData.workspace.photosIds.isEmpty)
          ? null
          :
      CachedNetworkImage(
        fit: BoxFit.cover,
        imageUrl: AppImageProvider.getImageUrlFromImageId(bookingData.workspace.photosIds[0]),
        httpHeaders: NetworkController().getAuthHeader(),
        placeholder: (context, url) => const Center(),
        errorWidget: (context, url, error) => const Icon(Icons.error),
      ),false
  );
}
