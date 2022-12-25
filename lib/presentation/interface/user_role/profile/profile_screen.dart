import 'package:atb_booking/data/services/image_provider.dart';
import 'package:atb_booking/data/services/network/network_controller.dart';
import 'package:atb_booking/logic/notifications/notifications_bloc.dart';
import 'package:atb_booking/logic/user_role/booking/booking_list_bloc/booking_list_bloc.dart';
import 'package:atb_booking/logic/user_role/feedback_bloc/feedback_bloc.dart';
import 'package:atb_booking/logic/user_role/profile_bloc/profile_bloc.dart';
import 'package:atb_booking/presentation/interface/auth/auth_screen.dart';
import 'package:atb_booking/presentation/interface/user_role/feedback/feedback_screen.dart';
import 'package:atb_booking/presentation/interface/user_role/profile/notifications/notifications.dart';
import 'package:atb_booking/presentation/interface/user_role/profile/pdf_file_list.dart';
import 'package:atb_booking/presentation/widgets/elevated_button.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: [
          IconButton(
              onPressed: () {
                context.read<BookingListBloc>().add(BookingListInitialEvent());
                NetworkController()
                    .exitFromApp(); //todo вынести в блок как эвент и ждать
                Navigator.pushReplacement(
                    context, MaterialPageRoute(builder: (_) => const Auth()));
              },
              icon: const Icon(Icons.logout, size: 28))
        ],
        title: const Center(
          child: Text("Профиль"),
        ),
        centerTitle: true,
      ),
      body: BlocConsumer<ProfileBloc, ProfileState>(
        listener: (context, state) {},
        builder: (context, state) {
          if (state is ProfileLoadedState) {
            return SingleChildScrollView(
              child: Column(
                children: [
                  const SizedBox(height: 20),
                  _UserTitle(
                    avatar: CachedNetworkImage(
                        fit: BoxFit.cover,
                        imageUrl: AppImageProvider.getImageUrlFromImageId(
                          state.userPerson.avatarImageId,
                        ),
                        httpHeaders: NetworkController().getAuthHeader(),
                        progressIndicatorBuilder:
                            (context, url, downloadProgress) => Center(
                                child: CircularProgressIndicator(
                                    value: downloadProgress.progress)),
                        errorWidget: (context, url, error) => Container()),
                    userName: state.userPerson.fullName,
                  ),
                  const SizedBox(height: 15),
                  _UserInfo(
                    email: state.userPerson.email,
                    number: state.userPerson.phone,
                    job: state.userPerson.jobTitle,
                  ),
                  const SizedBox(height: 25),
                  _UserBubbleButton(),
                  const SizedBox(height: 15)
                ],
              ),
            );
          } else if (state is ProfileLoadingState) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          } else if (state is ProfileErrorState) {
            return Center(
                child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text(
                    'Ой...  Не удалось загрузить.\n Попробуйте еще раз...',
                    style: TextStyle(fontSize: 30)),
                AtbElevatedButton(
                    onPressed: () {
                      ProfileBloc().add(ProfileLoadEvent());
                    },
                    text: "Загрузить")
              ],
            ));
          } else {
            return ErrorWidget(Exception("BadState"));
          }
        },
      ),
    );
  }
}

class _UserTitle extends StatelessWidget {
  const _UserTitle({required this.avatar, required this.userName});

  final CachedNetworkImage avatar;
  final String userName;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        ClipOval(
          child: SizedBox(
            width: 150,
            height: 150,
            child: avatar,
          ),
        ),
        const SizedBox(height: 25),
        Text(
          userName,
          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
        ),
      ],
    );
  }
}

class _UserInfo extends StatelessWidget {
  const _UserInfo(
      {required this.email, required this.number, required this.job});

  final String job;
  final String email;
  final String number;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 30),
      width: double.infinity,
      child: Column(children: [
        _RowForInfo(
          title: "E-MAIL",
          body: email,
          titleStyle: Theme.of(context)
              .textTheme
              .headlineSmall!
              .copyWith(fontSize: 22, fontWeight: FontWeight.w300),
          bodyStyle:
              Theme.of(context).textTheme.headlineSmall!.copyWith(fontSize: 23),
        ),
        const SizedBox(height: 8),
        _RowForInfo(
          title: "Должность",
          body: job,
          titleStyle: Theme.of(context)
              .textTheme
              .headlineSmall!
              .copyWith(fontSize: 22, fontWeight: FontWeight.w300),
          bodyStyle:
              Theme.of(context).textTheme.headlineSmall!.copyWith(fontSize: 23),
        ),
        const SizedBox(height: 8),
        _RowForInfo(
          title: "Телефон",
          body: number,
          titleStyle: Theme.of(context)
              .textTheme
              .headlineSmall!
              .copyWith(fontSize: 22, fontWeight: FontWeight.w300),
          bodyStyle:
              Theme.of(context).textTheme.headlineSmall!.copyWith(fontSize: 23),
        ),
      ]),
    );
  }
}

class _RowForInfo extends StatelessWidget {
  final String title;
  final TextStyle titleStyle;
  final TextStyle bodyStyle;
  final String body;

  const _RowForInfo(
      {required this.title,
      required this.titleStyle,
      required this.bodyStyle,
      required this.body});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: titleStyle,
            ),
            Container(
                padding: EdgeInsets.symmetric(horizontal: 10, vertical: 1),
                decoration: ShapeDecoration(
                  color: Theme.of(context).backgroundColor,
                  shape: const RoundedRectangleBorder(
                    borderRadius: BorderRadius.all(Radius.circular(10.0)),
                  ),
                ),
                child: Text(body, style: bodyStyle))
          ],
        )
      ],
    );
  }
}

class _UserBubbleButton extends StatelessWidget {
  const _UserBubbleButton();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 30),
      child: Column(
        children: [
          GestureDetector(
            onTap: () {
              _bubbleTransition(context);
            },
            child: const _UserBubbleBtn(
                title: "Обратная связь",
                subTitle: "Пожаловаться или оставить отзыв"),
          ),
          const SizedBox(height: 25),
          GestureDetector(
            onTap: () {
              _openNotificationsList(context);
            },
            child: const _UserBubbleBtn(
                title: "Уведомления", subTitle: "Уведомления и оповещения"),
          ),
          const SizedBox(height: 25),
          GestureDetector(
            onTap: () {
              _openPDFList(context);
            },
            child: const _UserBubbleBtn(
                title: "Информация", subTitle: "Инструкции и рекомендации"),
          ),
        ],
      ),
    );
  }
}

class _UserBubbleBtn extends StatelessWidget {
  const _UserBubbleBtn({required this.title, required this.subTitle});

  final String title;
  final String subTitle;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Theme.of(context).backgroundColor,
        borderRadius: BorderRadius.circular(15),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.2),
            spreadRadius: 2,
            blurRadius: 3,
            offset: const Offset(0, 0),
          ),
        ],
      ),
      padding: const EdgeInsets.only(
        top: 10,
        bottom: 10,
        left: 25,
      ),
      width: double.infinity,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Text(
              title,
            ),
            const SizedBox(
              height: 5,
            ),
            Text(
              subTitle,
              style: Theme.of(context).textTheme.bodySmall,
            )
          ]),
          const Icon(Icons.keyboard_arrow_right_sharp)
        ],
      ),
    );
  }
}

/// OPEN PDF List

void _openPDFList(BuildContext context) {
  Navigator.of(context)
      .push(MaterialPageRoute(builder: ((context) => PDFListPage())));
}

void _openNotificationsList(BuildContext context) {
  Navigator.of(context).push(MaterialPageRoute(
      builder: ((context) => BlocProvider(
            create: (context) => NotificationsBloc(),
            child: NotificationsPage(),
          ))));
}

void _bubbleTransition(BuildContext context) async {
  await Navigator.push(
    context,
    MaterialPageRoute(builder: (context) {
      return BlocProvider<FeedbackBloc>(
        create: (context) => FeedbackBloc(),
        child: const FeedBackScreen(),
      );
    }),
  );
}
