import 'package:flutter/material.dart';

class CustomMessage extends StatelessWidget {
  const CustomMessage({
    Key? key,
    required this.child,
  }) : super(key: key);
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        DecoratedBox(
          decoration: BoxDecoration(
            color: Colors.blue,
            borderRadius: BorderRadius.only(
              topRight: Radius.circular(9.0),
              bottomLeft: Radius.circular(9.0),
              bottomRight: Radius.circular(9.0),
            ),
          ),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 15.0),
            child: Row(
              children: [
                const SizedBox(width: 10.0),
                Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 5.0),
                    child,
                    const SizedBox(height: 5.0),
                    Text(
                      '12:00 PM',
                      style: TextStyle(color: Colors.white, fontSize: 12.0),
                    ),
                    const SizedBox(height: 5.0),
                  ],
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
