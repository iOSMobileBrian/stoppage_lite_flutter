import 'package:flutter/material.dart';

class ChildAvatar extends StatelessWidget {
  final String emoji;
  final double size;

  const ChildAvatar({Key? key, required this.emoji, this.size = 48})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: Colors.grey[800],
      ),
      alignment: Alignment.center,
      child: Text(
        emoji,
        style: TextStyle(fontSize: size * 0.55),
      ),
    );
  }
}
