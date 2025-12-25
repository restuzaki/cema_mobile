import 'package:cema_mobile/app/modules/register/controllers/register_controller.dart';
import 'package:cema_mobile/app/widgets/custom_circle.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class RegisterView extends GetView<RegisterController> {
  const RegisterView({super.key});

  @override
  Widget build(BuildContext context) {
    // Ambil ukuran layar penuh agar background tidak ikut mengecil saat keyboard muncul
    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      resizeToAvoidBottomInset:
          true, // Tetap true agar form bisa scroll ke atas
      body: Stack(
        children: [
          // LAYER 1: BACKGROUND (DIKUNCI UKURANNYA)
          // Kita gunakan SizedBox dengan tinggi layar penuh agar tidak ikut terdorong keyboard
          SizedBox(
            height: screenHeight,
            width: screenWidth,
            child: CustomCircle(),
          ),
          SizedBox(
            height: screenHeight,
            width: screenWidth,
            child: Container(color: Colors.white.withOpacity(0.6)),
          ),

          // LAYER 2: KONTEN (SCROLLABLE)
          Positioned.fill(
            child: SingleChildScrollView(
              physics: const ClampingScrollPhysics(),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Image.asset(
                    'assets/images/image_ruangan.png',
                    fit: BoxFit.fill,
                    height: 248,
                    width: screenWidth,
                  ),

                  Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 30,
                      vertical: 20,
                    ),
                    child: Column(
                      children: [
                        const SizedBox(height: 20),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Image.asset(
                              "assets/images/logo_cema.png",
                              height: 30,
                              width: 30,
                            ),
                            const SizedBox(width: 10),
                            const Text(
                              "Register",
                              style: TextStyle(
                                fontSize: 28,
                                fontWeight: FontWeight.bold,
                                color: Color(0xFF6FB327),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 8),
                        const Text(
                          "Create your new account",
                          style: TextStyle(
                            fontSize: 14,
                            color: Colors.grey,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        const SizedBox(height: 30),

                        _buildTextField(
                          controller: controller.emailController,
                          hint: "Email",
                          icon: Icons.email_rounded,
                        ),
                        const SizedBox(height: 15),

                        _buildTextField(
                          controller: controller.fullNameController,
                          hint: "Full Name",
                          icon: Icons.person_sharp,
                        ),
                        const SizedBox(height: 15),

                        _buildTextField(
                          controller: controller.passwordController,
                          hint: "Password",
                          icon: Icons.lock_outlined,
                          isPassword: true,
                        ),
                        const SizedBox(height: 25),

                        SizedBox(
                          width: double.infinity,
                          height: 50,
                          child: ElevatedButton(
                            onPressed: () => controller.register(),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: const Color(0xFF6FB327),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(30),
                              ),
                            ),
                            child: Obx(
                              () => controller.isLoading.value
                                  ? const SizedBox(
                                      height: 20,
                                      width: 20,
                                      child: CircularProgressIndicator(
                                        color: Colors.white,
                                        strokeWidth: 2,
                                      ),
                                    )
                                  : const Text(
                                      "Register",
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 14,
                                      ),
                                    ),
                            ),
                          ),
                        ),

                        const SizedBox(height: 15),
                        Row(
                          children: const [
                            Expanded(
                              child: Divider(
                                thickness: 1,
                                color: Color(0xFF6FB327),
                              ),
                            ),
                            Padding(
                              padding: EdgeInsets.symmetric(horizontal: 8),
                              child: Text(
                                "Or",
                                style: TextStyle(fontWeight: FontWeight.bold),
                              ),
                            ),
                            Expanded(
                              child: Divider(
                                thickness: 1,
                                color: Color(0xFF6FB327),
                              ),
                            ),
                          ],
                        ),

                        const SizedBox(height: 15),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            IconButton(
                              onPressed: () {},
                              icon: Image.asset(
                                'assets/images/logo_google.png',
                                height: 35,
                              ),
                            ),
                            const SizedBox(width: 15),
                            IconButton(
                              onPressed: () {},
                              icon: Image.asset(
                                'assets/images/logo_facebook.png',
                                height: 35,
                              ),
                            ),
                          ],
                        ),

                        const SizedBox(height: 10),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Text(
                              "Already Have an Account? ",
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 12,
                                color: Color(0xFFD9D9D9),
                              ),
                            ),
                            GestureDetector(
                              onTap: controller.signIn,
                              child: const Text(
                                "Sign In",
                                style: TextStyle(
                                  color: Color(0xFF6FB327),
                                  fontSize: 12,
                                  fontWeight: FontWeight.bold,
                                  fontStyle: FontStyle.italic,
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 20),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String hint,
    required IconData icon,
    bool isPassword = false,
  }) {
    return TextField(
      controller: controller,
      obscureText: isPassword,
      decoration: InputDecoration(
        hintText: hint,
        hintStyle: TextStyle(
          color: const Color(0xFF8CC540).withOpacity(0.50),
          fontWeight: FontWeight.bold,
        ),
        prefixIcon: Icon(icon, color: const Color(0xFF8CC540)),
        filled: true,
        fillColor: const Color(0xFF8CC540).withOpacity(0.50),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide.none,
        ),
      ),
    );
  }
}
