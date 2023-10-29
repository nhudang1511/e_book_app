import 'package:flutter/material.dart';
class Responsive {
  static bool isMobile(BuildContext context) =>
      MediaQuery.of(context).size.width < 400;

  static bool isTablet(BuildContext context) =>
      MediaQuery.of(context).size.width < 800 &&
          MediaQuery.of(context).size.width >= 400;

  static bool isDesktop(BuildContext context) =>
      MediaQuery.of(context).size.width >= 800;
}