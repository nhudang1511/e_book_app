import 'package:flutter/material.dart';
import 'package:material_dialogs/dialogs.dart';
import 'package:material_dialogs/widgets/buttons/icon_button.dart';

class CustomDialog {
  static Future<void> show(
      {required BuildContext context,
      required String title,
      required Color dialogColor,
      required Color msgColor,
      required Color titleColor,
      required VoidCallback onPressed,
      bool isCancel = false}) {
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
        if (isCancel)
          IconsButton(
            onPressed: (){
              Navigator.pop(context);
            },
            text: "Cancel",
            iconData: Icons.cancel,
            color: Theme.of(context).colorScheme.primary,
            textStyle: const TextStyle(color: Colors.white),
            iconColor: Colors.white,
          ),
      ],
    );
  }
}
