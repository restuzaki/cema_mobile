import 'package:flutter/material.dart';
import 'package:get/get.dart';

class CustomLeadingBackActionButton extends StatelessWidget {
  const CustomLeadingBackActionButton({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 8),
      child: IconButton(
        onPressed: () {
          Get.back();
        },
        icon: Icon(Icons.arrow_back),
      ),
    );
  }
}
