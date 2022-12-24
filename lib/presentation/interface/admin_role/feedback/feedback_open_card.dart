import 'package:atb_booking/data/models/feedback.dart';
import 'package:atb_booking/data/services/image_provider.dart';
import 'package:atb_booking/data/services/network/network_controller.dart';
import 'package:atb_booking/logic/admin_role/feedback/admin_feedback_bloc.dart';
import 'package:atb_booking/logic/admin_role/feedback/feedback_open_card_bloc/feedback_open_card_bloc.dart';
import 'package:atb_booking/logic/user_role/people_profile_bloc/people_profile_booking_bloc.dart';
import 'package:atb_booking/presentation/constants/styles.dart';
import 'package:atb_booking/presentation/interface/user_role/people/person_profile_screen.dart';
import 'package:atb_booking/presentation/widgets/elevated_button.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'feedback_added_people_card.dart';

class AdminFeedbackOpenCard extends StatelessWidget {
  const AdminFeedbackOpenCard({super.key});

  @override
  Widget build(BuildContext context) {
    ScrollController scrollController = ScrollController();
    return Scaffold(
      appBar: AppBar(
        title: const Text("Feedback пользователя"),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Container(
          child: Column(
            children: [
              _PersonSenderCard(),
              const _Body(),
            ],
          ),
        ),
      ),
    );
  }
}

class _PersonSenderCard extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<FeedbackOpenCardBloc, FeedbackOpenCardState>(
        builder: (context, state) {
      if (state is FeedbackOpenCardLoadedState) {
        ///
        ///
        /// Бронирующий
        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 30.0, vertical: 20),
          child: Column(
            children: [
              SizedBox(
                width: double.infinity,
                child: Padding(
                  padding: const EdgeInsets.only(left: 8),
                  child: Text("Отправитель",
                      textAlign: TextAlign.left,
                      style: Theme.of(context)
                          .textTheme
                          .headlineSmall
                          ?.copyWith(
                              color: Colors.black54,
                              fontSize: 25,
                              fontWeight: FontWeight.w300)),
                ),
              ),
              GestureDetector(
                  onTap: () async {
                    await Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (context) => BlocProvider.value(
                          value: PeopleProfileBookingBloc()
                            ..add(PeopleProfileBookingLoadEvent(
                                id: state.user.id)),
                          child: PersonProfileScreen(state.user),
                        ),
                      ),
                    );
                  },
                  child: AddedFeedbackPeopleCard(user: state.user))
            ],
          ),
        );
      } else {
        return Container(
          height: 100,
          child: const Center(
            child: CircularProgressIndicator(),
          ),
        );
      }
    });
  }
}

class _Body extends StatelessWidget {
  const _Body();

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<FeedbackOpenCardBloc, FeedbackOpenCardState>(
      builder: (context, state) {
        if (state is FeedbackOpenCardLoadedState) {
          /// Простое сообщение
          if (state.feedback.feedbackTypeId == 1) {
            return Column(
              children: [
                _Message(
                  message: state.feedback.comment,
                ),
                _ButtonDelete(state.feedback),
              ],
            );
          }

          /// Жалоба на пользователя
          else if (state.feedback.feedbackTypeId == 2) {
            return Column(
              children: [
                _PersonComplaintCard(),
                _Message(
                  message: state.feedback.comment,
                ),
                _ButtonDelete(state.feedback),
              ],
            );
          }

          /// Жалоба на рабочее место
          else if (state.feedback.feedbackTypeId == 3) {
            return Container(); //todo Сделать для feedback type 3
          } else {
            throw ('Unknown type of feedback');
          }
        } else if (state is FeedbackOpenCardLoadingState) {
          return Container();
        } else if (state is FeedbackOpenCardErrorState) {
          return Center(
              child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text('Ой...  Не удалось загрузить.\n Попробуйте еще раз...',
                  style: TextStyle(fontSize: 25)),
              const SizedBox(height: 40),
              AtbElevatedButton(
                  onPressed: () {
                    context
                        .read<FeedbackOpenCardBloc>()
                        .add(FeedbackOpenCardLoadEvent());
                  },
                  text: "Загрузить")
            ],
          ));
        } else {
          throw ("Error state in feedback open card: $state");
        }
      },
    );
  }
}

class _Message extends StatelessWidget {
  final String message;

  const _Message({super.key, required this.message});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 15),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.only(left: 8, bottom: 5),
            child: Text("Сообщение",
                style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                    color: Colors.black54,
                    fontSize: 25,
                    fontWeight: FontWeight.w300)),
          ),
          Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 5),
              decoration: const BoxDecoration(
                color: Color.fromARGB(255, 238, 238, 238),
                borderRadius: BorderRadius.all(Radius.circular(10.0)),
              ),
              child: Text(message, style: appThemeData.textTheme.bodyMedium)),
        ],
      ),
    );
  }
}

class _ButtonDelete extends StatelessWidget {
  FeedbackItem feedback;
  _ButtonDelete(this.feedback, {super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 20),
      child: AtbElevatedButton(
          onPressed: () {
            // context.read<AdminFeedbackBloc>().add(AdminFeedbackDeleteItemEvent(feedback)); //todo Сделать
            Navigator.pop(context);
          },
          text: "Закрыть обращение"),
    );
  }
}

class _PersonComplaintCard extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<FeedbackOpenCardBloc, FeedbackOpenCardState>(
        builder: (context, state) {
      if (state is FeedbackOpenCardLoadedState) {
        ///
        ///
        /// Тот на кого пожаловались
        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 30.0, vertical: 8),
          child: Column(
            children: [
              SizedBox(
                width: double.infinity,
                child: Padding(
                  padding: const EdgeInsets.only(
                    left: 8,
                  ),
                  child: Text("На кого жалуются",
                      textAlign: TextAlign.left,
                      style: Theme.of(context)
                          .textTheme
                          .headlineSmall
                          ?.copyWith(
                              color: Colors.black54,
                              fontSize: 25,
                              fontWeight: FontWeight.w300)),
                ),
              ),
              GestureDetector(
                  onTap: () async {
                    await Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (context) => BlocProvider.value(
                          value: PeopleProfileBookingBloc()
                            ..add(PeopleProfileBookingLoadEvent(
                                id: state.complaint!.id)),
                          child: PersonProfileScreen(state.complaint!),
                        ),
                      ),
                    );
                  },
                  child: AddedFeedbackPeopleCard(user: state.complaint!))
            ],
          ),
        );
      } else {
        return Container(
          height: 100,
          child: const Center(
            child: CircularProgressIndicator(),
          ),
        );
      }
    });
  }
}
