import 'package:flutter/material.dart';

class CustomInkwell extends StatelessWidget {
  final Icon mainIcon;
  final String title;
  final double currentHeight;
  final VoidCallback onTap;

  const CustomInkwell(
      {required this.mainIcon,
      required this.title,
      required this.currentHeight,
      super.key, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 32, right: 32),
      child: InkWell(
        onTap: onTap,
        child: Container(
          height: currentHeight / 12,
          decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.background,
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Expanded(
                flex: 1,
                child: mainIcon,
              ),
              Expanded(
                flex: 3,
                child: Text(
                  title,
                  style: Theme.of(context).textTheme.displaySmall,
                ),
              ),
              Expanded(
                flex: 1,
                child: Icon(
                  Icons.chevron_right,
                  color: Theme.of(context).colorScheme.primary,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
