import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class ActionButton extends StatelessWidget {
  final BuildContext context;
  final IconData icon;
  final String label;
  final void Function() onPressed;
  final bool? disabled;

  const ActionButton(
      this.context, {
        Key? key,
        required this.icon,
        required this.label,
        required this.onPressed,
        this.disabled,
      }) : super(key: key);

  Color getColor() {
    if (disabled == null || !disabled!)
      return Theme.of(context).buttonColor;
    else
      return Theme.of(context).disabledColor;
  }

  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: BorderRadius.circular(4),
      onTap: (disabled == null || !disabled!) ? onPressed : null,
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.only(bottom: 8.0),
              child: Icon(
                icon,
                color: getColor(),
              ),
            ),
            Text(
              label.toUpperCase(),
              style: TextStyle(
                color: getColor(),
              ),
            ),
          ],
        ),
      ),
    );
  }
}