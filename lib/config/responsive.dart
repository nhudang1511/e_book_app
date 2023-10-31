import 'package:flutter/material.dart';
class Responsive {
  static bool isMobile(BuildContext context) =>
      MediaQuery.of(context).size.width < 500;

  static bool isTablet(BuildContext context) =>
      MediaQuery.of(context).size.width < 1000 &&
          MediaQuery.of(context).size.width >= 500;

  static bool isDesktop(BuildContext context) =>
      MediaQuery.of(context).size.width >= 1000;
}