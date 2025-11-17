import 'package:flutter/material.dart';

class CustomNavButton extends StatelessWidget {
  final IconData icon;
  final String label;
  final bool isSelected;
  final VoidCallback onTap;

  const CustomNavButton({
    super.key,
    required this.icon,
    required this.label,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.symmetric(vertical: 10, horizontal: 20),
        decoration: isSelected
            ? BoxDecoration(
                border: Border(
                  top: BorderSide(
                    color: const Color.fromARGB(255, 24, 100, 44),
                    width: 3,
                  ),
                ),
              )
            : null,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              icon,
              color: isSelected
                  ? const Color.fromARGB(255, 20, 166, 25)
                  : Colors.grey,
            ),
            Text(
              label,
              style: TextStyle(
                color: isSelected
                    ? const Color.fromARGB(255, 30, 147, 63)
                    : Colors.grey,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
