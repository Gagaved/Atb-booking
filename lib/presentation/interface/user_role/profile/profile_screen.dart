import 'package:atb_booking/data/services/image_provider.dart';
import 'package:atb_booking/data/services/network/network_controller.dart';
import 'package:atb_booking/logic/user_role/feedback_bloc/feedback_bloc.dart';
import 'package:atb_booking/logic/user_role/profile_bloc/profile_bloc.dart';
import 'package:atb_booking/presentation/interface/auth/auth_screen.dart';
import 'package:atb_booking/presentation/interface/user_role/feedback/feedback_screen.dart';
import 'package:atb_booking/presentation/widgets/elevated_button.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_bloc/flutter_bloc.dart';


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

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: [
          IconButton(
              onPressed: () {
                NetworkController().exitFromApp();//todo вынести в блок как эвент и ждать
                Navigator.pushReplacement(
                    context, MaterialPageRoute(builder: (_) => const Auth()));
              },
              icon: const Icon(Icons.logout, size: 28))
        ],
        title: const Center(
          child: Text("     Профиль"),
        ),
      ),
      body: BlocConsumer<ProfileBloc, ProfileState>(
        listener: (context, state) {
          // TODO: implement listener
        },
        builder: (context, state) {
          if (state is ProfileLoadedState) {
            return SingleChildScrollView(
              child: Column(
                children: [
                  const SizedBox(height: 35),
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
                  const SizedBox(height: 55),
                  _UserInfo(
                      email: state.userPerson.email,
                      number: state.userPerson.phone,
                    job: state.userPerson.jobTitle,
                  ),
                  const SizedBox(height: 65),
                  GestureDetector(
                      onTap: () {
                        _bubbleTransition(context);
                      },
                      child: const _UserBubbleButton()),
                  const SizedBox(height: 20)
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
                    'Ой...  Неудалось загрузить.\n Попробуйте еще раз...',
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
            "Должность",
            "email",
            Theme.of(context).textTheme.headlineSmall!.copyWith(
                color: Colors.black54,
                fontSize: 22,
                fontWeight: FontWeight.w300),
            Theme.of(context)
                .textTheme
                .headlineSmall!
                .copyWith(color: Colors.black, fontSize: 23),
            job),
        _RowForInfo(
            "E-MAIL",
            "email",
            Theme.of(context).textTheme.headlineSmall!.copyWith(
                color: Colors.black54,
                fontSize: 22,
                fontWeight: FontWeight.w300),
            Theme.of(context)
                .textTheme
                .headlineSmall!
                .copyWith(color: Colors.black, fontSize: 23),
            email),
        const SizedBox(height: 15),
        _RowForInfo(
            "Телефон",
            "number",
            Theme.of(context).textTheme.headlineSmall!.copyWith(
                color: Colors.black54,
                fontSize: 22,
                fontWeight: FontWeight.w300),
            Theme.of(context)
                .textTheme
                .headlineSmall!
                .copyWith(color: Colors.black, fontSize: 23),
            number),
      ]),
    );
  }
}

Row _RowForInfo(String title, String dataType, TextStyle titleStyle,
    TextStyle dataStyle, String element) {
  return Row(
    children: [
      Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: titleStyle,
          ),
          if (dataType == "job") ...[
            Container(
                decoration: const ShapeDecoration(
                  color: Color.fromARGB(255, 243, 243, 243),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.all(Radius.circular(10.0)),
                  ),
                ),
                child: Text(element, style: dataStyle))
          ],
          if (dataType == "email") ...[
            Container(
                decoration: const ShapeDecoration(
                  color: Color.fromARGB(255, 243, 243, 243),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.all(Radius.circular(10.0)),
                  ),
                ),
                child: Text(element, style: dataStyle))
          ],
          if (dataType == 'number') ...[
            Container(
                decoration: const ShapeDecoration(
                  color: Color.fromARGB(255, 243, 243, 243),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.all(Radius.circular(10.0)),
                  ),
                ),
                child: Text(element, style: dataStyle))
          ]
        ],
      )
    ],
  );
}

class _UserBubbleButton extends StatelessWidget {
  const _UserBubbleButton();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 30),
      child: Column(
        children: const [
          _UserBubbleBtn(
              title: "Обратная связь",
              subTitle: "Пожаловаться или оставить отзыв"),
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
        color: Colors.white,
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
              style: const TextStyle(color: Colors.black, fontSize: 17),
            ),
            const SizedBox(
              height: 5,
            ),
            Text(
              subTitle,
              style: const TextStyle(color: Colors.grey, fontSize: 15),
            )
          ]),
          const Icon(Icons.keyboard_arrow_right_sharp)
        ],
      ),
    );
  }
}
