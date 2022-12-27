import 'package:atb_booking/data/services/image_provider.dart';
import 'package:atb_booking/data/services/network/network_controller.dart';
import 'package:atb_booking/logic/user_role/booking/booking_details_bloc/booking_details_bloc.dart';
import 'package:atb_booking/logic/user_role/booking/locked_plan_bloc/locked_plan_bloc.dart';
import 'package:atb_booking/presentation/interface/user_role/booking/booking_details/booking_delete_confirmation_popup.dart';
import 'package:atb_booking/presentation/interface/user_role/booking/booking_details/locked_plan/booking_added_people_widget.dart';
import 'package:atb_booking/presentation/interface/user_role/booking/booking_details/locked_plan/lockedPlanWidget.dart';
import 'package:atb_booking/presentation/widgets/elevated_button.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';

class _InfoField extends StatelessWidget {
  final String title;
  final String body;

  const _InfoField({required this.title, required this.body});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 30.0, vertical: 5),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title,
              textAlign: TextAlign.left,
              style: Theme
                  .of(context)
                  .textTheme
                  .headlineSmall
                  ?.copyWith(fontSize: 24, fontWeight: FontWeight.w300)),
          Container(
            decoration: BoxDecoration(
              color: Theme
                  .of(context)
                  .backgroundColor,
              borderRadius: const BorderRadius.all(Radius.circular(10.0)),
            ),
            child: Text(body,
                style: Theme
                    .of(context)
                    .textTheme
                    .headlineSmall
                    ?.copyWith(fontSize: 23)),
          ),
        ],
      ),
    );
  }
}

class BookingDetailsScreen extends StatelessWidget {
  const BookingDetailsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<BookingDetailsBloc, BookingDetailsState>(
      builder: (context, state) {
        if (state is BookingDetailsLoadedState) {
          getPhotoSize() {
            if (state.booking.workspace.photosIds.isEmpty) return 0.0;
            if (state.booking.workspace.photosIds.length == 1) return 250.0;
            return 200.0;
          }

          return Scaffold(
            appBar: AppBar(
              title: Text("Бронь №${state.booking.id}"),
            ),
            body: Center(
              child: SingleChildScrollView(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [

                    ///
                    ///
                    /// Фотографии рабочего места.
                    SizedBox(
                      height: getPhotoSize(), //getSize(),
                      child: Padding(
                        padding: const EdgeInsets.only(bottom: 5),
                        child: Center(
                          child: ListView.builder(
                              shrinkWrap: true,
                              scrollDirection: Axis.horizontal,
                              itemCount:
                              state.booking.workspace.photosIds.length,
                              //state.workspace.photos.length,
                              itemBuilder: (context, index) {
                                return GestureDetector(
                                  behavior: HitTestBehavior.translucent,
                                  child: CachedNetworkImage(
                                    fit: BoxFit.cover,
                                    imageUrl:
                                    AppImageProvider.getImageUrlFromImageId(
                                        state.booking.workspace
                                            .photosIds[index]),
                                    httpHeaders:
                                    NetworkController().getAuthHeader(),
                                    placeholder: (context, url) =>
                                    const Center(),
                                    errorWidget: (context, url, error) =>
                                    const Icon(Icons.error),
                                  ),
                                  onTap: () {
                                    showDialog(
                                        useRootNavigator: false,
                                        context: context,
                                        builder: (BuildContext context) {
                                          return GestureDetector(
                                            behavior:
                                            HitTestBehavior.translucent,
                                            onTap: () {
                                              int count = 0;
                                              Navigator.popUntil(context,
                                                      (route) {
                                                    return count++ == 1;
                                                  });
                                            },
                                            child: InteractiveViewer(
                                              transformationController:
                                              TransformationController(),
                                              maxScale: 2.0,
                                              minScale: 0.1,
                                              child: AlertDialog(
                                                //clipBehavior: Clip.none,
                                                  shape:
                                                  const RoundedRectangleBorder(
                                                      borderRadius:
                                                      BorderRadius.all(
                                                          Radius
                                                              .circular(
                                                              0.0))),
                                                  insetPadding: const EdgeInsets
                                                      .symmetric(
                                                      horizontal: 10,
                                                      vertical: 200),
                                                  contentPadding:
                                                  const EdgeInsets
                                                      .symmetric(
                                                      horizontal: 10,
                                                      vertical: 10),
                                                  content: CachedNetworkImage(
                                                    fit: BoxFit.cover,
                                                    imageUrl: AppImageProvider
                                                        .getImageUrlFromImageId(
                                                        state
                                                            .booking
                                                            .workspace
                                                            .photosIds[
                                                        index]),
                                                    httpHeaders:
                                                    NetworkController()
                                                        .getAuthHeader(),
                                                    placeholder:
                                                        (context, url) =>
                                                    const Center(),
                                                    errorWidget: (context, url,
                                                        error) =>
                                                    const Icon(Icons.error),
                                                  )),
                                            ),
                                          );
                                        });
                                  },
                                );
                              }),
                        ),
                      ),
                    ),

                    ///
                    ///
                    /// Кнопки показа карты и людей
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        MaterialButton(
                          shape: RoundedRectangleBorder(
                              side: BorderSide(
                                  width: 0,
                                  color: Theme
                                      .of(context)
                                      .primaryColor),
                              borderRadius: BorderRadius.circular(7.0)),
                          onPressed: () {
                            showDialog(
                                context: context,
                                builder: (_) {
                                  return AlertDialog(
                                      shape: RoundedRectangleBorder(
                                          borderRadius:
                                          BorderRadius.circular(00.0)),
                                      insetPadding: const EdgeInsets.symmetric(
                                          horizontal: 00, vertical: 00),
                                      titlePadding: const EdgeInsets.symmetric(
                                          horizontal: 00, vertical: 00),
                                      contentPadding:
                                      const EdgeInsets.symmetric(
                                          horizontal: 00, vertical: 00),
                                      clipBehavior: Clip.none,
                                      content: SizedBox(
                                          width: double.infinity,
                                          height:
                                          MediaQuery
                                              .of(context)
                                              .size
                                              .width,
                                          child: BlocProvider.value(
                                            value: LockedPlanBloc(),
                                            child: const LockedPlanWidget(),
                                          )));
                                });
                          },
                          color: Theme
                              .of(context)
                              .primaryColor,
                          child: Container(
                            height: 50,
                            child: Row(
                              children: [
                                Text(
                                  (state.booking.guests != null &&
                                      state.booking.guests!.isNotEmpty)
                                      ? "Показать\nна плане"
                                      : "Показать на плане",
                                  style: Theme
                                      .of(context)
                                      .textTheme
                                      .titleMedium!
                                      .copyWith(
                                    color: Colors.white,
                                  ),
                                ),
                                const SizedBox(
                                  width: 5,
                                ),
                                const Icon(Icons.place, color: Colors.white,)
                              ],
                            ),
                          ),
                        ),
                        if (state.booking.guests != null &&
                            state.booking.guests!.isNotEmpty)
                          MaterialButton(
                            shape: RoundedRectangleBorder(
                                side: BorderSide(
                                    width: 0,
                                    color: Theme
                                        .of(context)
                                        .primaryColor),
                                borderRadius: BorderRadius.circular(7.0)),
                            onPressed: () {
                              showDialog(
                                  context: context,
                                  builder: (_) {
                                    return BlocProvider.value(
                                      value: context.read<BookingDetailsBloc>(),
                                      child: const BookingAddedPeopleWidget(),
                                    );
                                  });
                            },
                            color: Theme
                                .of(context)
                                .primaryColor,
                            child: Container(
                              height: 50,
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: [
                                  Text(
                                    "Гости",
                                    style: Theme
                                        .of(context)
                                        .textTheme
                                        .titleMedium!
                                        .copyWith(
                                      color: Colors.white,
                                    ),
                                    textAlign: TextAlign.end,
                                  ),
                                  const SizedBox(
                                    width: 5,
                                  ),
                                  const Icon(
                                    Icons.people, color: Colors.white,),
                                  Container(
                                    width: 30,
                                    height: 30,
                                    decoration: BoxDecoration(
                                        color: Colors.white,
                                        border: Border.all(color: Colors.white),
                                        borderRadius: const BorderRadius.all(
                                            Radius.circular(20))),
                                    child: Center(
                                        child: Text(
                                          state.booking.guests!.length
                                              .toString(),
                                          style: Theme
                                              .of(context)
                                              .textTheme
                                              .titleMedium!
                                              .copyWith(
                                              color: Theme
                                                  .of(context)
                                                  .primaryColor),
                                        )),
                                  )
                                ],
                              ),
                            ),
                          )
                      ],
                    ),

                    ///
                    ///
                    ///
                    /// Бронирующий
                    if (state.holderUser.id != state.currentUserId)
                      Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 30.0, vertical: 5),
                        child: Column(
                          children: [
                            SizedBox(
                              width: double.infinity,
                              child: Text("Бронирующий",
                                  textAlign: TextAlign.left,
                                  style: Theme
                                      .of(context)
                                      .textTheme
                                      .headlineSmall
                                      ?.copyWith(
                                      fontSize: 22,
                                      fontWeight: FontWeight.w300)),
                            ),
                            Container(
                              height: 0.3,
                              color: Colors.black54,
                            ),
                            AddedPeopleCard(user: state.holderUser)
                            //Expanded(child: PeopleCard(user))
                          ],
                        ),
                      ),

                    ///
                    ///
                    /// Описание рабочего места
                    _InfoField(
                      title: "Описание рабочего места",
                      body: state.booking.workspace.description,
                    ),

                    ///
                    ///
                    ///Название и этаж
                    _InfoField(
                        title: "Место",
                        body:
                        "${state.booking.workspace.type.type} ${state.booking
                            .workspace.level} Этаж"),

                    ///
                    ///
                    /// ОФИС
                    _InfoField(
                        title: "Офис",
                        body:
                        '${state.booking.cityName} ${state.booking
                            .officeAddress}'),

                    ///
                    ///
                    /// ДАТА
                    _InfoField(
                      title: "Дата",
                      body: DateFormat.yMMMMd("ru_RU")
                          .format(state.booking.reservationInterval.start),
                    ),

                    ///
                    ///
                    /// ВРЕМЯ
                    _InfoField(
                        title: "Время",
                        body:
                        'c ${DateFormat('HH:mm').format(
                            state.booking.reservationInterval
                                .start)} до ${DateFormat('HH:mm').format(
                            state.booking.reservationInterval.end)}'),

                    ///
                    ///
                    /// КНОПКА ОТМЕНЫ
                    if (state.buttonIsShow)
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          Padding(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 30.0, vertical: 30),
                              child: AtbElevatedButton(
                                onPressed: () {
                                  showDialog(
                                    useRootNavigator: false,
                                    context: context,
                                    builder: (_) {
                                      return BlocProvider.value(
                                        value: context.read<
                                            BookingDetailsBloc>(),
                                        child: const BookingDeleteDialog(),
                                      );
                                    },
                                  );
                                },
                                text: "Отменить",
                              )),
                        ],
                      )
                  ],
                ),
              ),
            ),
          );
        } else if (state is BookingDetailsLoadingState) {
          return Scaffold(
              appBar: AppBar(title: const Text('Бронь')),
              body: Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const CircularProgressIndicator(color: Colors.grey,),
                      Text(
                        "Загружаем",
                        style: Theme
                            .of(context)
                            .textTheme
                            .headlineSmall
                            ?.copyWith(
                            fontSize: 22,
                            fontWeight: FontWeight.w300),
                        textAlign: TextAlign.center,

                      ),
                    ],
                  )));
          } else
              if (state is BookingDetailsErrorState)
          {
            return Scaffold(
              appBar: AppBar(title: const Text('Ошибка при загрузке')),
              body: Center(
                  child: Text(
                    "Не удалось загрузить информацию, проверьте интернет подключение",
                    style: Theme
                        .of(context)
                        .textTheme
                        .headlineSmall
                        ?.copyWith(
                        fontSize: 22,
                        fontWeight: FontWeight.w300),
                    textAlign: TextAlign.center,

                  )),
            );
          } else if (state is BookingDetailsDeletedState) {
          getPhotoSize() {
            if (state.booking.workspace.photosIds.isEmpty) return 0.0;
            if (state.booking.workspace.photosIds.length == 1) return 250.0;
            return 200.0;
          }

          return Scaffold(
            appBar: AppBar(
              title: Text("Бронь №${state.booking.id}"),
            ),
            body: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 20),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [

                    ///
                    ///
                    /// Фотографии рабочего места.
                    SizedBox(
                      height: getPhotoSize(), //getSize(),
                      child: Padding(
                        padding: const EdgeInsets.only(bottom: 5.0),
                        child: Center(
                          child: ListView.builder(
                              shrinkWrap: true,
                              scrollDirection: Axis.horizontal,
                              itemCount:
                              state.booking.workspace.photosIds.length,
                              //state.workspace.photos.length,
                              itemBuilder: (context, index) {
                                return GestureDetector(
                                  behavior: HitTestBehavior.translucent,
                                  child: CachedNetworkImage(
                                    fit: BoxFit.cover,
                                    imageUrl:
                                    AppImageProvider.getImageUrlFromImageId(
                                        state.booking.workspace
                                            .photosIds[index]),
                                    httpHeaders:
                                    NetworkController().getAuthHeader(),
                                    placeholder: (context, url) =>
                                    const Center(),
                                    errorWidget: (context, url, error) =>
                                    const Icon(Icons.error),
                                  ),
                                  onTap: () {
                                    showDialog(
                                        useRootNavigator: false,
                                        context: context,
                                        builder: (BuildContext context) {
                                          return GestureDetector(
                                            behavior:
                                            HitTestBehavior.translucent,
                                            onTap: () {
                                              int count = 0;
                                              Navigator.popUntil(context,
                                                      (route) {
                                                    return count++ == 1;
                                                  });
                                            },
                                            child: InteractiveViewer(
                                              transformationController:
                                              TransformationController(),
                                              maxScale: 2.0,
                                              minScale: 0.1,
                                              child: AlertDialog(
                                                //clipBehavior: Clip.none,
                                                  shape:
                                                  const RoundedRectangleBorder(
                                                      borderRadius:
                                                      BorderRadius.all(
                                                          Radius
                                                              .circular(
                                                              0.0))),
                                                  insetPadding: const EdgeInsets
                                                      .symmetric(
                                                      horizontal: 10,
                                                      vertical: 200),
                                                  contentPadding:
                                                  const EdgeInsets
                                                      .symmetric(
                                                      horizontal: 10,
                                                      vertical: 10),
                                                  content: CachedNetworkImage(
                                                    fit: BoxFit.cover,
                                                    imageUrl: AppImageProvider
                                                        .getImageUrlFromImageId(
                                                        state
                                                            .booking
                                                            .workspace
                                                            .photosIds[
                                                        index]),
                                                    httpHeaders:
                                                    NetworkController()
                                                        .getAuthHeader(),
                                                    placeholder:
                                                        (context, url) =>
                                                    const Center(),
                                                    errorWidget: (context, url,
                                                        error) =>
                                                    const Icon(Icons.error),
                                                  )),
                                            ),
                                          );
                                        });
                                  },
                                );
                              }),
                        ),
                      ),
                    ),

                    ///
                    ///
                    /// Описание рабочего места
                    _InfoField(
                      title: "Описание рабочего места",
                      body: state.booking.workspace.description,
                    ),

                    ///
                    ///
                    ///Название и этаж
                    _InfoField(
                        title: "Место",
                        body:
                        "${state.booking.workspace.type.type} ${state.booking
                            .workspace.level} Этаж"),

                    ///
                    ///
                    /// ОФИС
                    _InfoField(
                        title: "Офис",
                        body:
                        '${state.booking.cityName} ${state.booking
                            .officeAddress}'),

                    ///
                    ///
                    /// ДАТА
                    _InfoField(
                      title: "Дата",
                      body: DateFormat.yMMMMd("ru_RU")
                          .format(state.booking.reservationInterval.start),
                    ),

                    ///
                    ///
                    /// ВРЕМЯ
                    _InfoField(
                        title: "Дата",
                        body:
                        'c${DateFormat('HH:mm').format(state.booking
                            .reservationInterval.start)} до ${DateFormat(
                            'HH:mm').format(state.booking.reservationInterval
                            .end)}'),

                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(
                        "БРОНЬ ОТМЕНЕНА",
                        textAlign: TextAlign.center,
                        style: Theme
                            .of(context)
                            .textTheme
                            .displaySmall!
                            .copyWith(
                            color: const Color.fromARGB(255, 72, 0, 0),
                            fontSize: 30),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        } else {
          throw Exception("unexpected state: $state");
        }
      },
    );
  }
}
