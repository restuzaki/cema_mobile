import 'package:cema_mobile/app/widgets/custom_circle.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/login_controller.dart';

class LoginView extends GetView<LoginController> {
  const LoginView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      body: Stack(
        children: [
          CustomCircle(),
          Container(color: Colors.white.withOpacity(0.6)),
          Image.asset(
            'assets/images/image_ruangan.png',
            fit: BoxFit.fill,
            height: 300,
            width: 400,
          ),

          Positioned.fill(
            child: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 30,
                  vertical: 80,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    const SizedBox(height: 250),
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
                          "Welcome Back",
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
                      "Login to your account",
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
                          color: const Color(0xFF8CC540).withOpacity(0.50),
                          fontWeight: FontWeight.bold,
                        ),
                        prefixIcon: const Icon(
                          Icons.email_outlined,
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
                          color: const Color(0xFF8CC540).withOpacity(0.50),
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
                    const SizedBox(height: 3),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Obx(
                          () => Row(
                            children: [
                              Transform.scale(
                                scale: 0.8,
                                child: Checkbox(
                                  value: controller.rememberMe.value,
                                  onChanged: controller.toggleRememberMe,
                                  activeColor: const Color(0xFF6FB327),
                                ),
                              ),
                              const Text(
                                "Remember Me",
                                style: TextStyle(
                                  fontSize: 13,
                                  fontWeight: FontWeight.bold,
                                  color: Color(0xFFD9D9D9),
                                ),
                              ),
                            ],
                          ),
                        ),
                        // TextButton(
                        //   onPressed: controller.forgotPassword,
                        //   child: const Text(
                        //     "Forget Password?",
                        //     style: TextStyle(
                        //       color: Colors.black,
                        //       fontWeight: FontWeight.bold,
                        //     ),
                        //   ),
                        // ),
                      ],
                    ),
                    const SizedBox(height: 3),

                    SizedBox(
                      width: double.infinity,
                      height: 50,
                      child: ElevatedButton(
                        onPressed: () => controller.login(),
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
                                  "Login",
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 14,
                                  ),
                                ),
                        ),
                      ),
                    ),

                    // const SizedBox(height: 8),
                    // Row(
                    //   children: const [
                    //     Expanded(
                    //       child: Divider(
                    //         thickness: 1,
                    //         color: Color(0xFF6FB327),
                    //       ),
                    //     ),
                    //     Padding(
                    //       padding: EdgeInsets.symmetric(horizontal: 8),
                    //       child: Text(
                    //         "Or",
                    //         style: TextStyle(fontWeight: FontWeight.bold),
                    //       ),
                    //     ),
                    //     Expanded(
                    //       child: Divider(
                    //         thickness: 1,
                    //         color: Color(0xFF6FB327),
                    //       ),
                    //     ),
                    //   ],
                    // ),
                    // const SizedBox(height: 15),
                    // Row(
                    //   mainAxisAlignment: MainAxisAlignment.center,
                    //   children: [
                    //     IconButton(
                    //       onPressed: () => controller.loginWithGoogle(),
                    //       icon: Obx(
                    //         () => controller.isLoading.value
                    //             ? const SizedBox(
                    //                 height: 20,
                    //                 width: 20,
                    //                 child: CircularProgressIndicator(
                    //                   strokeWidth: 2,
                    //                 ),
                    //               )
                    //             : Image.asset(
                    //                 'assets/images/logo_google.png',
                    //                 height: 35,
                    //               ),
                    //       ),
                    //     ),
                    //     const SizedBox(width: 15),
                    //     IconButton(
                    //       onPressed: () {},
                    //       icon: Image.asset(
                    //         'assets/images/logo_facebook.png',
                    //         height: 35,
                    //       ),
                    //     ),
                    //   ],
                    // ),

                    // const SizedBox(height: 10),
                    // Row(
                    //   mainAxisAlignment: MainAxisAlignment.center,
                    //   children: [
                    //     const Text(
                    //       "Don’t have an account? ",
                    //       style: TextStyle(
                    //         fontWeight: FontWeight.bold,
                    //         fontSize: 12,
                    //         color: Color(0xFFD9D9D9),
                    //       ),
                    //     ),
                    //     GestureDetector(
                    //       onTap: controller.signUp,
                    //       child: const Text(
                    //         "Sign Up",
                    //         style: TextStyle(
                    //           color: Color(0xFF6FB327),
                    //           fontSize: 12,
                    //           fontWeight: FontWeight.bold,
                    //           fontStyle: FontStyle.italic,
                    //         ),
                    //       ),
                    //     ),
                    //   ],
                    // ),
                    const SizedBox(height: 20),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
