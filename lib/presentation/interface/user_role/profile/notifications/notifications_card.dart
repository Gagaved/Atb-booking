import 'package:atb_booking/logic/notifications/notifications_bloc.dart';
import 'package:flutter/material.dart';
import 'package:atb_booking/data/models/notificathions.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';

class NotificationCard extends StatelessWidget {
  final NotificationsModel notification;

  const NotificationCard(this.notification, {super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
        child: Padding(
      padding: const EdgeInsets.symmetric(vertical: 3),
      child: Card(
          semanticContainer: true,
          elevation: 1,
          clipBehavior: Clip.antiAliasWithSaveLayer,
          shape: RoundedRectangleBorder(
              side: BorderSide(
                  width: 0, color: Theme.of(context).colorScheme.tertiary),
              borderRadius: BorderRadius.circular(12.0)),
          child: Padding(
            padding: const EdgeInsets.all(3.0),
            child: ListTile(
              title: Container(
                padding: EdgeInsets.symmetric(horizontal: 10, vertical: 1),
                decoration: ShapeDecoration(
                  color: Theme.of(context).backgroundColor,
                  shape: const RoundedRectangleBorder(
                    borderRadius: BorderRadius.all(Radius.circular(10.0)),
                  ),
                ),
                child: Text(_DateConvert(notification.date),
                    style: Theme.of(context)
                        .textTheme
                        .bodyMedium!
                        .copyWith(fontWeight: FontWeight.w400)),
              ),
              subtitle: Text(
                notification.message,
                style: Theme.of(context).textTheme.bodyMedium,
              ),
              trailing: GestureDetector(
                onTap: () {
                  context
                      .read<NotificationsBloc>()
                      .add(NotificationsDeleteEvent(notification));
                },
                child: Icon(Icons.cancel),
              ),
              dense: true,
              minLeadingWidth: 100,
            ),
          )),
    ));
  }
}

String _DateConvert(DateTime date) {
  String res = '';
  if (date.toLocal().day == DateTime.now().toLocal().day) {
    res = "Сегодня";
  } else if (date.toLocal().day == DateTime.now().toLocal().day - 1) {
    res = 'Вчера';
  } else {
    res = DateFormat.MMMd("ru_RU").format(date);
  }
  return res;
}
