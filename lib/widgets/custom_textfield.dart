import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class CustomTextField extends StatelessWidget {
  final TextEditingController controller;
  final String hintText;
  final FaIcon? prefixIcon;
  final Widget? suffixIcon;
  final TextInputType? inputType;
  final String? Function(String? val)? validator;
  final bool? isSecureText;
  final VoidCallback? suffixIconPressed;
  final VoidCallback? prefixIconPressed;

  final bool? readOnly;
  final int? maxLine;
  final int? maxCharacter;
  final int? minCharacter;
  final VoidCallback? onTap;
  const CustomTextField({
    Key? key,
    required,
    required this.controller,
    required this.hintText,
    this.prefixIcon,
    this.suffixIcon,
    this.prefixIconPressed,
    required this.validator,
    this.inputType,
    this.suffixIconPressed,
    this.isSecureText,
    this.readOnly,
    this.maxLine,
    this.maxCharacter,
    this.minCharacter,
    this.onTap,
  }) : super(key: key);
//
  @override
  Widget build(BuildContext context) {
    return TextFormField(
      readOnly: readOnly ?? false,
      controller: controller,
      onTap: onTap,
      validator: validator,
      keyboardType: inputType,
      obscureText: isSecureText ?? false,
      maxLines: maxLine ?? 1,
      maxLength: maxCharacter,
      minLines: 1,
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
                icon: suffixIcon ?? FaIcon(FontAwesomeIcons.notEqual),
              ),
        prefixIcon: prefixIcon == null
            ? null
            : IconButton(
                onPressed: prefixIconPressed,
                
                icon: prefixIcon ?? FaIcon(FontAwesomeIcons.notEqual),
              ),
      ),
    );
  }
}
