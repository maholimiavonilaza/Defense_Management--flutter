import 'package:flutter/material.dart' show BorderRadius, BorderSide, Colors, InputDecoration, OutlineInputBorder, Radius, TextEditingController, TextFormField, TextStyle;

class CustomTextField {
  final String title;
  final String placeholder;
  final bool ispass;
  String error;
  late TextEditingController controller;

  CustomTextField({
    required this.title,
    required this.placeholder,
    this.ispass = false,
    this.error = '',
  }) {
    controller = TextEditingController();
  }

  TextFormField textFormField() {
    return TextFormField(
      controller: controller,
      validator: (e) => e?.isEmpty ?? true ? error : null,
      obscureText: ispass,
      decoration: InputDecoration(
        hintText: placeholder,
        labelText: title,
        labelStyle: const TextStyle(color: Colors.redAccent),
        border: const OutlineInputBorder(
          borderRadius: BorderRadius.all(Radius.circular(1)),
        ),
        focusedBorder: const OutlineInputBorder(
          borderSide: BorderSide(
            color: Colors.redAccent,
          ),
        ),
      ),
    );
  }

  String get value{
    return controller.text;
  }
}
