import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

class CustomWaitingIndicator extends StatelessWidget {
  const CustomWaitingIndicator({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Lottie.asset(
        'assets/lottie/waiting.json',
        width: 200,
        height: 200,
      ),
    );
  }
}
