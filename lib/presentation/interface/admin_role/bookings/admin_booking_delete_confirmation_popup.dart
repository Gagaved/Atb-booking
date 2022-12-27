import 'package:flutter/material.dart';
class BookingDeleteDialog extends StatelessWidget {
  const BookingDeleteDialog({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      insetPadding: const EdgeInsets.symmetric(vertical: 30, horizontal: 30),
      content: Text(
        'Вы действительно хотите отменить бонирование?',
        style: Theme.of(context)
            .textTheme
            .headlineSmall
            ?.copyWith(fontSize: 20, fontWeight: FontWeight.w300),
      ),
      actions: <Widget>[
        TextButton(
          onPressed: () {
            Navigator.pop(context, false);
          },
          child: Text(
            'Назад',
            style: Theme.of(context)
                .textTheme
                .headlineSmall
                ?.copyWith(fontSize: 20, fontWeight: FontWeight.w500),
          ),
        ),
        TextButton(
          onPressed: () => Navigator.pop(
            context,
            true,
          ),
          child: Text(
            'Отменить',
            style: Theme.of(context)
                .textTheme
                .headlineSmall
                ?.copyWith(fontSize: 20, fontWeight: FontWeight.w500),
          ),
        ),
      ],
    );
  }
}
