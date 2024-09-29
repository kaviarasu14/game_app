import 'package:flutter/material.dart';

class Deadpiece extends StatelessWidget {
  final String imagepath;
  final bool iswhite;
  const Deadpiece({super.key, required this.imagepath, required this.iswhite});

  @override
  Widget build(BuildContext context) {
    return Image.asset(
      imagepath,
      color: iswhite ? Colors.grey[400] : Colors.grey[800],
    );
  }
}
