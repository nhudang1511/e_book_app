import 'package:flutter/material.dart';
import 'package:material_dialogs/dialogs.dart';
import 'package:material_dialogs/widgets/buttons/icon_button.dart';

class CustomDialog {
  static Future<void> show({
    required BuildContext context,
    required String title,
    required Color dialogColor,
    required Color msgColor,
    required Color titleColor,
    required VoidCallback onPressed,
  }) {
    return Dialogs.materialDialog(
      msg: title,
      title: "Warning",
      color: dialogColor,
      msgStyle: TextStyle(color: msgColor),
      titleStyle: TextStyle(color: titleColor, fontSize: 20),
      context: context,
      actions: [
        IconsButton(
          onPressed: onPressed,
          text: "Ok",
          iconData: Icons.check,
          color: Theme.of(context).colorScheme.primary,
          textStyle: const TextStyle(color: Colors.white),
          iconColor: Colors.white,
        ),
      ],
    );
  }
}