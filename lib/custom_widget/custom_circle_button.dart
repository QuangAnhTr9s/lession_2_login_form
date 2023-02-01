import 'package:flutter/material.dart';

class MyCircleButton extends StatelessWidget {
  final Color color;
  final String lable;
  const MyCircleButton({super.key, required this.color, required this.lable});

  @override
  Widget build(BuildContext context) {
  return Container(
    width: 45,
    height: 45,
    decoration: BoxDecoration(
        color: Colors.transparent,
        border: Border.all(width: 3, color: color),
        shape: BoxShape.circle),
    child: Center(
        child: Text(
          lable,
          style:
          TextStyle(color: color, fontSize: 20, fontWeight: FontWeight.w900),
        )),
  );
  }
}
