import 'package:cema_mobile/app/modules/home/views/home_navbar.dart';
import 'package:cema_mobile/app/modules/login/bindings/login_binding.dart';
import 'package:cema_mobile/app/modules/login/views/login_view.dart';
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
  ];
}
