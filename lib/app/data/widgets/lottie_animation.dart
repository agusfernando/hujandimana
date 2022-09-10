import 'package:flutter/material.dart';

class LottieAnimation extends StatelessWidget {
  const LottieAnimation({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
        color: Colors.green.shade100,
        child: Center(child: CircularProgressIndicator())
        // Lottie.asset('assets/images/alertPinMaps.json'),
        );
  }
}
