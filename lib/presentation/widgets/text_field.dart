import 'package:flutter/material.dart';

class AtbTextField extends StatelessWidget{
  final String text;

  const AtbTextField({super.key, required this.text});
  @override
  Widget build(BuildContext context) {
    return Container(
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.tertiary,
          borderRadius:
          BorderRadius.circular(10).copyWith(),
        ),
        child: TextField(
            obscureText: false,
            decoration: InputDecoration(
              border: const OutlineInputBorder(),
              labelText: text,
            )));
  }

}