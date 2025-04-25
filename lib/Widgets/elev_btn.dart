import 'package:flutter/material.dart';

class ElevBtn extends StatelessWidget {
  final String timeLabel;
  final VoidCallback onPress;
  final Color primary;

  const ElevBtn({Key? key, required this.timeLabel, required this.onPress, required this.primary}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: onPress,
      child: Container(
          width: 70,
          height: 70,
          alignment: Alignment.center,
          child: Text(
            timeLabel,
            style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.white),
          )),
      style: ElevatedButton.styleFrom(
          backgroundColor: primary,
          elevation: 2.0,
          shape: const CircleBorder(
            side: BorderSide(color: Colors.white),
          )),
    );
  }
}
