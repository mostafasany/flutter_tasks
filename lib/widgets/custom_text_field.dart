import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class CustomTextField extends StatelessWidget {
  final String title;
  final TextEditingController controller;
  final GestureTapCallback? onTap;
  final bool? readOnly;
  final List<TextInputFormatter>? inputFormatters;
  const CustomTextField(
      {Key? key,
      required this.title,
      required this.controller,
      this.onTap,
      this.inputFormatters,
      this.readOnly})
      : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(title),
        const SizedBox(height: 10.0),
        TextField(
          readOnly: readOnly ?? false,
          controller: controller,
          onTap: onTap,
          inputFormatters: inputFormatters,
          decoration: InputDecoration(
              border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(20.0),
                  borderSide: BorderSide())),
        ),
      ],
    );
  }
}
