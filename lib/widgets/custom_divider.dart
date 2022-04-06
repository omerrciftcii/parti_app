import 'package:flutter/material.dart';

class CustomDivider extends StatelessWidget {
  const CustomDivider({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 8.0, bottom: 8),
      child: Container(
        height: 1.1,
        width: MediaQuery.of(context).size.width - 40,
        color: Colors.grey[300],
      ),
    );
  }
}
