import 'package:atb_booking/data/authController.dart';
import 'package:atb_booking/data/models/booking.dart';
import 'package:atb_booking/data/models/workspace_type.dart';
import 'package:atb_booking/data/services/image_provider.dart';
import 'package:atb_booking/data/services/network/network_controller.dart';
import 'package:atb_booking/logic/user_role/booking/booking_details_bloc/booking_details_bloc.dart';
import 'package:atb_booking/logic/user_role/booking/booking_list_bloc/booking_list_bloc.dart';
import 'package:atb_booking/logic/user_role/booking/new_booking/new_booking_bloc/new_booking_bloc.dart';
import 'package:atb_booking/logic/user_role/booking/new_booking/new_booking_bloc/new_booking_sheet_bloc/new_booking_sheet_bloc.dart';
import 'package:atb_booking/logic/user_role/booking/new_booking/new_booking_bloc/plan_bloc/plan_bloc.dart';
import 'package:atb_booking/presentation/constants/styles.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../booking_details/booking_details_screen.dart';
import '../new_booking/new_booking_screen.dart';
import 'booking_card_widget.dart';

class _FilterButtons extends StatelessWidget {
  const _FilterButtons({Key? key}) : super(key: key);
  static const List<Widget> fruits = <Widget>[
    Text('Мои '),
    Text('Гостевые'),
    Text('Все')
  ];

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<BookingListBloc, BookingListState>(
      builder: (context, state) {
        return ToggleButtons(
          onPressed: (int index) {
            context
                .read<BookingListBloc>()
                .add(BookingListFilterChangeEvent(index));
          },
          textStyle: appThemeData.textTheme.titleMedium,
          borderRadius: const BorderRadius.all(Radius.circular(8)),
          selectedBorderColor: appThemeData.primaryColor,
          selectedColor: Colors.white,
          color: Colors.black,
          fillColor: appThemeData.primaryColor,
          // color: Colors.red[400],
          constraints: const BoxConstraints(
            minHeight: 40.0,
            minWidth: 115.0,
          ),
          isSelected: state.filterList,
          children: fruits,
        );
      },
    );
  }
}

class BookingScreen extends StatelessWidget {
  const BookingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    ScrollController scrollController = ScrollController();
    return Scaffold(
      appBar: AppBar(
        title: const Center(
          child: _FilterButtons(),
        ),
      ),
      body: BlocBuilder<BookingListBloc, BookingListState>(
        builder: (context, state) {
          if (state is BookingListLoadingState) {
            return Padding(
                padding: const EdgeInsets.fromLTRB(15.0, 0.0, 15.0, 0),
                child: Column(
                  children: const [
                ShimmerBookingCard(),
                ShimmerBookingCard(),
                ShimmerBookingCard(),
                  ],
                ));
          } else if (state is BookingListLoadedState) {
            if (state.bookingList.isNotEmpty) {
              return Padding(
                padding: const EdgeInsets.fromLTRB(10.0, 00.0, 10.0, 0),
                child: Scrollbar(
                  child: ListView.builder(
                    controller: scrollController,
                    itemCount: state.bookingList.length,
                    itemBuilder: (context, index) {
                      final item = state.bookingList[index];
                      return GestureDetector(
                        onTap: () {
                          BookingListBloc().add(BookingCardTapEvent(item.id));
                          Navigator.of(context).push(MaterialPageRoute(
                              builder: (context) =>
                                  BlocProvider<BookingDetailsBloc>(
                                    create: (context) => BookingDetailsBloc(
                                        state.bookingList[index].id, true),
                                    child: const BookingDetailsScreen(),
                                  )));
                        },
                        child: getBookingCard(
                            state.bookingList[index], state.mapOfTypes),
                      );
                    },
                  ),
                ),
              );
            } else {
              return Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20.0),
                child: Center(
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(
                      "Чтобы забронировать используйте кнопку ниже",
                      style: appThemeData.textTheme.headlineMedium,
                      textAlign: TextAlign.center,
                    ),
                  ),
                ),
              );
            }
          } else {
            throw Exception("unexpected state $state");
          }
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // NewBookingBloc().add(NewBookingReloadCitiesEvent());
          Navigator.of(context).push(MaterialPageRoute(
              builder: (context) => MultiBlocProvider(
                    providers: [
                      BlocProvider.value(value: NewBookingBloc()),
                      BlocProvider.value(value: NewBookingSheetBloc()),
                      BlocProvider.value(value: PlanBloc()),
                      //BlocProvider.value(value: NewBookingPlanBloc())
                    ],
                    child: const NewBookingScreen(),
                  )));
        },
        child: const Icon(Icons.add, color: Colors.white),
      ),
    );
  }
}

BookingCard getBookingCard(
    Booking bookingData, Map<int, WorkspaceType> mapOfTypes) {
  bool isGuestBooking = bookingData.holderId != AuthController.currentUserId;
  return BookingCard(
      bookingData,
      bookingData.workspace.type.type,
      "assets/workplacelogo.png",
      (bookingData.workspace.photosIds.isEmpty)
          ? null
          : CachedNetworkImage(
              fit: BoxFit.cover,
              imageUrl: AppImageProvider.getImageUrlFromImageId(
                  bookingData.workspace.photosIds[0]),
              httpHeaders: NetworkController().getAuthHeader(),
              placeholder: (context, url) => const Center(),
              errorWidget: (context, url, error) => const Icon(Icons.error),
            ),
      isGuestBooking);
}
