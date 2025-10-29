import 'package:flutter/material.dart';

class SocialButton extends StatelessWidget {
  final String assetPath;
  final VoidCallback onPressed;

  const SocialButton({
    super.key,
    required this.assetPath,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onPressed,
      borderRadius: BorderRadius.circular(25),
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              blurRadius: 5,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        // Pastikan Anda punya gambar google.png dan facebook.png di folder assets
        // child: Image.asset(assetPath, height: 24),
        // Untuk sementara kita gunakan Icon jika belum ada aset
        child: Icon(
          assetPath == 'google' ? Icons.android : Icons.facebook,
          color: assetPath == 'google' ? Colors.red : Colors.blue,
          size: 28,
        ),
      ),
    );
  }
}
