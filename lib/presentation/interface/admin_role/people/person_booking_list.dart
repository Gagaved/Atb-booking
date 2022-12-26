import 'package:atb_booking/data/models/user.dart';
import 'package:atb_booking/data/services/image_provider.dart';
import 'package:atb_booking/data/services/network/network_controller.dart';
import 'package:atb_booking/logic/admin_role/people/person_booking_list/admin_person_booking_list_bloc.dart';
import 'package:atb_booking/logic/user_role/booking/booking_details_bloc/booking_details_bloc.dart';
import 'package:atb_booking/presentation/constants/styles.dart';
import 'package:atb_booking/presentation/interface/admin_role/bookings/admin_booking_card.dart';
import 'package:atb_booking/presentation/interface/admin_role/bookings/booking_details_screen.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

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
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: ClipOval(
                  child: Container(
                    height: 70,
                    width: 70,
                    child: CachedNetworkImage(
                        fit: BoxFit.cover,
                        imageUrl: AppImageProvider.getImageUrlFromImageId(
                          user.avatarImageId,
                        ),
                        httpHeaders: NetworkController().getAuthHeader(),
                        progressIndicatorBuilder: (context, _, __) =>
                            const SizedBox.shrink(),
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
                      Container(
                        decoration: BoxDecoration(
                          color: AtbAdditionalColors.black7,
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 8.0),
                          child: Text(
                            user.fullName,
                            style:
                                Theme.of(context).textTheme.bodyLarge!.copyWith(
                                      fontWeight: FontWeight.w600,
                                      height: 0,
                                    ),
                          ),
                        ),
                      ),
                      Container(
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 8.0),
                          child: Text(
                            user.jobTitle,
                            style: Theme.of(context)
                                .textTheme
                                .bodyMedium!
                                .copyWith(
                                  fontWeight: FontWeight.w300,
                                  height: 0,
                                ),
                          ),
                        ),
                      ),
                      Container(
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 8.0),
                          child: Text(
                            user.email,
                            style: Theme.of(context)
                                .textTheme
                                .bodyMedium!
                                .copyWith(
                                  fontWeight: FontWeight.w300,
                                  height: 0,
                                ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        );
      } else {
        return const Center(
          child: SizedBox.shrink(),
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
        mainAxisAlignment: MainAxisAlignment.center,
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
          return Expanded(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Container(
                child: Center(
                  child: Text(
                    "У этого пользователя нет активных броней",
                    style: Theme.of(context)
                        .textTheme
                        .headlineSmall
                        ?.copyWith(fontSize: 23, fontWeight: FontWeight.w300),
                    textAlign: TextAlign.center,
                  ),
                ),
              ),
            ),
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
                        builder: (_) => BlocProvider.value(
                              value: context.read<AdminPersonBookingListBloc>(),
                              child: BlocProvider<BookingDetailsBloc>(
                                create: (_) =>
                                    BookingDetailsBloc(bookingData.id, true),
                                child: const BookingDetailsScreen(),
                              ),
                            )));
                  },
                  child: AdminBookingCard(bookingData),
                );
              },
            ),
          ),
        );
      } else if (state is AdminPersonBookingListLoadingState) {
        return Center(
            child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const CircularProgressIndicator(
              color: Colors.grey,
            ),
            Text(
              "Загружаем",
              style: Theme.of(context)
                  .textTheme
                  .headlineSmall
                  ?.copyWith(fontSize: 22, fontWeight: FontWeight.w300),
              textAlign: TextAlign.center,
            ),
          ],
        ));
      } else {
        return Center(
            child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              "Не удалось загрузить. Проверьте интернет соеденение.",
              style: Theme.of(context)
                  .textTheme
                  .headlineSmall
                  ?.copyWith(fontSize: 22, fontWeight: FontWeight.w300),
              textAlign: TextAlign.center,
            ),
          ],
        ));
      }
    });
  }
}
