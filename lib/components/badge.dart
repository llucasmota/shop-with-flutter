import 'package:flutter/material.dart';

class Badge extends StatelessWidget {
  final Widget childWidget;
  final String value;
  final Color? color;
  const Badge(
      {Key? key, required this.childWidget, required this.value, this.color})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.center,
      children: [
        childWidget,
        Positioned(
          right: 8,
          top: 8,
          child: Container(
            padding: EdgeInsets.all(2),
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                color: color ?? Theme.of(context).colorScheme.secondary),
            child: Text(
              textAlign: TextAlign.center,
              value,
              style: TextStyle(fontSize: 10),
            ),
          ),
        )
      ],
    );
  }
}
