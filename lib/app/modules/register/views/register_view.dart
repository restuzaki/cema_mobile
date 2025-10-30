import 'package:cema_mobile/app/modules/register/controllers/register_controller.dart';
import 'package:cema_mobile/app/widgets/custom_circle.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class RegisterView extends GetView<RegisterController> {
  const RegisterView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: Stack(
        children: [
          CustomCircle(),

          Container(color: Colors.white.withOpacity(0.6)),

          Image.asset(
            'assets/images/image_ruangan.png',
            fit: BoxFit.fill,
            height: 248,
            width: 400,
          ),

          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 80),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const SizedBox(height: 170),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Image.asset(
                      "assets/images/logo_cema.png",
                      height: 30,
                      width: 30,
                    ),
                    SizedBox(width: 10),
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

                TextField(
                  controller: controller.emailController,
                  decoration: InputDecoration(
                    hintText: "Email",
                    hintStyle: TextStyle(
                      color: Color(0xFF8CC540).withOpacity(0.50),
                      fontWeight: FontWeight.bold,
                    ),
                    prefixIcon: const Icon(
                      Icons.email_rounded,
                      color: Color(0xFF8CC540),
                    ),
                    filled: true,
                    fillColor: const Color(0xFF8CC540).withOpacity(0.50),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide.none,
                    ),
                  ),
                ),
                const SizedBox(height: 15),

                TextField(
                  controller: controller.fullNameController,
                  decoration: InputDecoration(
                    hintText: "Full Name",
                    hintStyle: TextStyle(
                      color: Color(0xFF8CC540).withOpacity(0.50),
                      fontWeight: FontWeight.bold,
                    ),
                    prefixIcon: const Icon(
                      Icons.person_sharp,
                      color: Color(0xFF8CC540),
                    ),
                    filled: true,
                    fillColor: const Color(0xFF8CC540).withOpacity(0.50),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide.none,
                    ),
                  ),
                ),
                const SizedBox(height: 15),

                TextField(
                  controller: controller.passwordController,
                  obscureText: true,
                  decoration: InputDecoration(
                    hintText: "Password",
                    hintStyle: TextStyle(
                      color: Color(0xFF8CC540).withOpacity(0.50),
                      fontWeight: FontWeight.bold,
                    ),
                    prefixIcon: const Icon(
                      Icons.lock_outlined,
                      color: Color(0xFF8CC540),
                    ),
                    filled: true,
                    fillColor: const Color(0xFF8CC540).withOpacity(0.50),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide.none,
                    ),
                  ),
                ),
                const SizedBox(height: 20),

                SizedBox(
                  width: double.infinity,
                  height: 50,
                  child: ElevatedButton(
                    onPressed: controller.register,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF6FB327),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30),
                      ),
                    ),
                    child: const Text(
                      "Register",
                      style: TextStyle(color: Colors.white, fontSize: 16),
                    ),
                  ),
                ),

                const SizedBox(height: 8),

                Row(
                  children: const [
                    Expanded(
                      child: Divider(thickness: 1, color: Color(0xFF6FB327)),
                    ),
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 8),
                      child: Text(
                        "Or",
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                    ),
                    Expanded(
                      child: Divider(thickness: 1, color: Color(0xFF6FB327)),
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

                const SizedBox(height: 2),
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
              ],
            ),
          ),
        ],
      ),
    );
  }
}
