import 'package:atb_booking/logic/notifications/notifications_bloc.dart';
import 'package:atb_booking/presentation/widgets/elevated_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'notifications_card.dart';

class NotificationsPage extends StatelessWidget {
  const NotificationsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Уведомления"), centerTitle: true),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 30),
        child: Column(
          children: [_ListOfNotifications()],
        ),
      ),
    );
  }
}

class _ListOfNotifications extends StatelessWidget {
  _ListOfNotifications();
  final ScrollController _scrollController = ScrollController();

  @override
  Widget build(BuildContext context) {
    _scrollController.addListener(() {
      if (_scrollController.position.maxScrollExtent ==
          _scrollController.position.pixels) {
        context.read<NotificationsBloc>().add(NotificationsLoadNextPageEvent());
      }
    });

    return Expanded(
      child: BlocBuilder<NotificationsBloc, NotificationsState>(
        builder: (context, state) {
          if (state is NotificationsErrorState) {
            return Center(
                child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text(
                    'Ой...  Не удалось загрузить.\n Попробуйте еще раз...',
                    style: TextStyle(fontSize: 25)),
                const SizedBox(height: 40),
                AtbElevatedButton(
                    onPressed: () {
                      context
                          .read<NotificationsBloc>()
                          .add(NotificationsLoadEvent(true));
                    },
                    text: "Загрузить")
              ],
            ));
          } else if (state is NotificationsLoadedState ||
              state is NotificationsLoadingState) {
            if (state is NotificationsLoadingState &&
                state.formHasBeenChanged) {
              return const Center(
                child: CircularProgressIndicator(),
              );
            } else if (state.ListOfNotifications.isEmpty) {
              return  Center(
                child: Text("Уведомлений пока нет", style: Theme.of(context).textTheme.headlineMedium,),
              );
            } else {
              return ListView.builder(
                  controller: _scrollController,
                  itemCount: state.ListOfNotifications.length,
                  itemBuilder: (context, index) => Column(
                        children: [
                          NotificationCard(state.ListOfNotifications[index]),
                          (state is NotificationsLoadingState &&
                                  index == state.ListOfNotifications.length - 1)
                              ? Container(
                                  height: 150,
                                  padding: EdgeInsets.fromLTRB(0, 0, 0, 100),
                                  child: const Center(
                                    child: CircularProgressIndicator(),
                                  ))
                              : const SizedBox.shrink(),
                        ],
                      ));
            }
          } else {
            throw Exception('bad state into notificationPage: $state');
          }
        },
      ),
    );
  }
}
