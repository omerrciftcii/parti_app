import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';

class SocialMediaButton extends StatelessWidget {
  final Color? backgroundColor;
  final String text;
  final TextStyle textStyle;
  final FaIcon icon;
  const SocialMediaButton(
      {required this.backgroundColor,
      required this.text,
      required this.textStyle,
      required this.icon});
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 50,
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: const BorderRadius.all(
          Radius.circular(10),
        ),
        border: backgroundColor == Colors.transparent
            ? Border.all(color: Colors.grey[400] ?? Color(0xfff), width: 1.2)
            : Border.all(color: Colors.transparent),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.only(left: 18.0),
            child: icon,
          ),
          Padding(
            padding: const EdgeInsets.only(left: 50.0),
            child: Text(
              text,
              style: textStyle,
            ),
          ),
        ],
      ),
    );
  }
}
