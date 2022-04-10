import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class CustomTextField extends StatelessWidget {
  final TextEditingController controller;
  final String hintText;
  final FaIcon? prefixIcon;
  final FaIcon? suffixIcon;
  final TextInputType? inputType;
  final String? Function(String? val)? validator;
  final bool? isSecureText;
  final VoidCallback? suffixIconPressed;
  final bool? readOnly;
  const CustomTextField({
    Key? key,
    required,
    required this.controller,
    required this.hintText,
    this.prefixIcon,
    this.suffixIcon,
    required this.validator,
    this.inputType,
    this.suffixIconPressed,
    this.isSecureText,
    this.readOnly,
  }) : super(key: key);
//
  @override
  Widget build(BuildContext context) {
    return TextFormField(
      readOnly: readOnly ?? false,
      controller: controller,
      validator: validator,
      keyboardType: inputType,
      obscureText: isSecureText ?? false,
      decoration: InputDecoration(
        enabledBorder: const UnderlineInputBorder(
          borderSide: BorderSide(color: Colors.cyan),
        ),
        focusedBorder: const UnderlineInputBorder(
          borderSide: BorderSide(color: Colors.cyan),
        ),
        hintText: hintText,
        suffixIcon: suffixIcon == null
            ? null
            : IconButton(
                onPressed: suffixIconPressed,
                icon: suffixIcon ?? FaIcon(FontAwesomeIcons.notEqual)),
        prefixIcon: prefixIcon,
      ),
    );
  }
}
