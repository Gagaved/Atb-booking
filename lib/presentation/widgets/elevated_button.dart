import 'package:flutter/material.dart';

class AtbElevatedButton extends StatelessWidget {
  final VoidCallback onPressed;
  final String text;
  final Widget? icon;

  const AtbElevatedButton(
      {super.key, required this.onPressed, required this.text, this.icon});

  @override
  Widget build(BuildContext context) {
    return Theme(
        data: Theme.of(context).copyWith(
            colorScheme: Theme.of(context).colorScheme
                .copyWith(surface: Theme.of(context).primaryColor)),
        child: ElevatedButton(
          style: const ButtonStyle(),
          onPressed: onPressed,
          child: SizedBox(
              width: 240,
              height: 60,
              child: Center(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Center(
                        child: Text(
                      text,
                      style: Theme.of(context).textTheme.displayLarge
                          ?.copyWith(color: Colors.white, fontSize: 20),
                    )),
                    icon ?? const SizedBox.shrink(),
                  ],
                ),
              )),
        ));
  }
}
