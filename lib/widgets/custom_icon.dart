import 'package:flutter/material.dart';

class CustomIcon extends StatelessWidget {
  const CustomIcon({
    Key? key,
    required this.backgroundColor,
    required this.icon,
    required this.onPressed,
    this.iconColor,
    this.iconSize,
  }) : super(key: key);
  final Color? backgroundColor;
  final IconData icon;
  final double? iconSize;
  final VoidCallback onPressed;
  final Color? iconColor;
  @override
  Widget build(BuildContext context) {
    return Container(
      width: 40.0,
      height: 40.0,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(7.0),
        color: backgroundColor,
      ),
      child: IconButton(
        color: iconColor,
        iconSize: iconSize ?? 24,
        onPressed: onPressed,
        icon: Icon(icon),
      ),
    );
  }
}
