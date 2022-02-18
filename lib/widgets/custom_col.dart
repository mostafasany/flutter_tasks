import 'package:flutter/material.dart';

class CustomCol extends StatelessWidget {
  final String title;
  final String subTitle;

  const CustomCol({Key? key, required this.title, required this.subTitle})
      : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: TextStyle(
            color: Colors.grey,
            fontSize: 12.0,
            fontWeight: FontWeight.bold,
          ),
        ),
        Text(
          subTitle,
          style: TextStyle(
            color: Colors.grey.shade800,
            fontSize: 18.0,
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }
}
