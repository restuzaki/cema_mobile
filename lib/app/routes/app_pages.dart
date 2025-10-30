import 'package:cema_mobile/app/modules/forget_password/bindings/forget_password_binding.dart';
import 'package:cema_mobile/app/modules/forget_password/views/forget_password_view.dart';
import 'package:cema_mobile/app/modules/home/views/home_navbar.dart';
import 'package:cema_mobile/app/modules/login/bindings/login_binding.dart';
import 'package:cema_mobile/app/modules/login/views/login_view.dart';
import 'package:cema_mobile/app/modules/register/bindings/register_binding.dart';
import 'package:cema_mobile/app/modules/register/views/register_view.dart';
import 'package:get/get.dart';

import '../modules/home/bindings/home_binding.dart';

part 'app_routes.dart';

class AppPages {
  AppPages._();

  static const INITIAL = Routes.LOGIN;

  static final routes = [
    GetPage(name: _Paths.HOME, page: () => HomePage(), binding: HomeBinding()),
    GetPage(
      name: _Paths.LOGIN,
      page: () => const LoginView(),
      binding: LoginBinding(),
    ),
    GetPage(
      name: _Paths.FORGETPASSWORD,
      page: () => const ForgetPasswordPage(),
      binding: ForgetPasswordBinding(),
    ),
    GetPage(
      name: _Paths.REGISTER,
      page: () => const RegisterView(),
      binding: RegisterBinding(),
    ),
  ];
}
