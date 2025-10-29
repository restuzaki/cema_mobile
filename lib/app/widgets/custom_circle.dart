import 'package:flutter/material.dart';

class CustomCircle extends StatelessWidget {
  const CustomCircle({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,

      body: Stack(
        children: [
          Positioned(
            top: 635,
            left: 356,
            child: Container(
              width: 77,
              height: 77,
              decoration: BoxDecoration(
                color: const Color(0xFFA8CC54),
                shape: BoxShape.circle,
              ),
            ),
          ),
          Positioned(
            top: 270,
            left: 330,
            child: Container(
              width: 77,
              height: 77,
              decoration: BoxDecoration(
                color: const Color(0xFFA8CC54),
                shape: BoxShape.circle,
              ),
            ),
          ),
          Positioned(
            bottom: 10,
            right: 50,
            child: Container(
              width: 77,
              height: 77,
              decoration: BoxDecoration(
                color: const Color(0xFFA8CC54),
                shape: BoxShape.circle,
              ),
            ),
          ),
          Positioned(
            bottom: -17,
            left: -35,
            child: Container(
              width: 77,
              height: 77,
              decoration: BoxDecoration(
                color: const Color(0xFFA8CC54),
                shape: BoxShape.circle,
              ),
            ),
          ),
          Positioned(
            bottom: 79,
            left: 7,
            child: Container(
              width: 77,
              height: 77,
              decoration: BoxDecoration(
                color: const Color(0xFFA8CC54),
                shape: BoxShape.circle,
              ),
            ),
          ),
          Positioned(
            top: 262,
            left: -45,
            child: Container(
              width: 77,
              height: 77,
              decoration: BoxDecoration(
                color: const Color(0xFFA8CC54),
                shape: BoxShape.circle,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
