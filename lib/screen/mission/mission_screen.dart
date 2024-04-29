import 'package:flutter/material.dart';

import '../../widget/widget.dart';

class MissionScreen extends StatefulWidget {
  const MissionScreen({super.key});

  static const String routeName = '/mission';

  @override
  State<MissionScreen> createState() => _MissionScreenState();
}

class _MissionScreenState extends State<MissionScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Theme.of(context).colorScheme.background,
        appBar: const CustomAppBar(
          title: "Choose Payment",
        ),
        body: Center());
  }
}
