import 'package:flutter/material.dart';

class CustomTextField extends StatelessWidget {
  final TextEditingController controller;
  final String hintText;
  final Widget icon;
  final TextInputType? keyboardType;
  const CustomTextField({
    super.key,
    required this.controller,
    required this.hintText,
    required this.icon,
    this.keyboardType,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 12.0),
      child: TextFormField(
        controller: controller,
        keyboardType: keyboardType,
        maxLines: keyboardType != null ? null : 1,
        decoration: InputDecoration(
            contentPadding: const EdgeInsets.symmetric(horizontal: 8.0),
            border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(16.0),
                borderSide: BorderSide.none),
            filled: true,
            fillColor: Colors.white,
            icon: icon,
            labelText: hintText,
            floatingLabelBehavior: FloatingLabelBehavior.auto,
            floatingLabelStyle: const TextStyle(
                color: Colors.grey,
                fontWeight: FontWeight.normal,
                fontSize: 16)),
        validator: (value) {
          if (value == null || value.isEmpty) {
            return '$hintText không được bỏ trống';
          }
          return null;
        },
      ),
    );
  }
}
