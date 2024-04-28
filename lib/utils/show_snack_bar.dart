import 'package:elegant_notification/elegant_notification.dart';
import 'package:elegant_notification/resources/arrays.dart';
import 'package:flutter/material.dart';

const Color infoColor = Color(0xff0066FF);
const Color successColor = Color(0xff01CB67);
const Color errorColor = Color(0xffFE355C);
const Color greyColor = Color(0xffF3F3F3);

enum Status { success, error }

class ShowSnackBar {
  static void success(String message, BuildContext context) {
    final sizeScreen = MediaQuery.of(context).size;
    ElegantNotification.success(
      width: sizeScreen.width,
      position: Alignment.topLeft,
      animation: AnimationType.fromTop,
      title: Text(Status.success.name.toUpperCase(),
          style: Theme.of(context).textTheme.bodyLarge!.copyWith(
            fontWeight: FontWeight.bold,
            color: successColor,
          )),
      description: Text(message),
      showProgressIndicator: true,
    ).show(context);
  }

  static void error(String message, BuildContext context) {
    final sizeScreen = MediaQuery.of(context).size;
    ElegantNotification.error(
      width: sizeScreen.width,
      position: Alignment.topLeft,
      animation: AnimationType.fromTop,
      title: Text(Status.error.name.toUpperCase(),
          style: Theme.of(context).textTheme.bodyLarge!.copyWith(
            fontWeight: FontWeight.bold,
            color: errorColor,
          )),
      description: Text(message),
      showProgressIndicator: true,
    ).show(context);
  }
}
