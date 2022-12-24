import 'package:atb_booking/data/models/feedback.dart';

import 'package:atb_booking/logic/admin_role/feedback/admin_feedback_bloc.dart';
import 'package:atb_booking/logic/admin_role/feedback/feedback_open_card_bloc/feedback_open_card_bloc.dart';
import 'package:atb_booking/presentation/interface/admin_role/feedback/feedback_open_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';

class FeedbackCard extends StatelessWidget {
  final FeedbackItem feedback;

  const FeedbackCard(this.feedback, {super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider.value(
      value: BlocProvider.of<AdminFeedbackBloc>(context),
      child: Center(
          child: GestureDetector(
        onTap: () async {
          await Navigator.of(context).push(
            MaterialPageRoute(
              builder: (context) => BlocProvider(
                create: (context) => FeedbackOpenCardBloc(feedback),
                child: AdminFeedbackOpenCard(),
              ),
            ),
          );
        },
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
              child: Row(
                children: <Widget>[
                  Expanded(
                      child: ListTile(
                    title: Text(_DateConvert(feedback.date),
                        style: Theme.of(context).textTheme.bodyMedium!
                            .copyWith(fontWeight: FontWeight.w400)),
                    subtitle: Text(
                      feedback.userFullName,
                      style: Theme.of(context).textTheme.titleSmall,
                    ),
                    trailing: GestureDetector(
                      onTap: () {
                        context
                            .read<AdminFeedbackBloc>()
                            .add(AdminFeedbackDeleteItemEvent(feedback));
                      },
                      child: Icon(Icons.cancel),
                    ),
                    dense: true,
                    minLeadingWidth: 100,
                  ))
                ],
              ),
            )),
      )),
    );
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
