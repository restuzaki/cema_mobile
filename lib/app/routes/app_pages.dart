import 'package:cema_mobile/app/modules/cs_support/bindings/cs_support_binding.dart';
import 'package:cema_mobile/app/modules/cs_support/views/cs_support_view.dart';
import 'package:cema_mobile/app/modules/dashboard/bindings/dashboard_binding.dart';
import 'package:cema_mobile/app/modules/dashboard/views/dahsboard_view.dart';
import 'package:cema_mobile/app/modules/forget_password/bindings/forget_password_binding.dart';
import 'package:cema_mobile/app/modules/forget_password/views/forget_password_view.dart';
import 'package:cema_mobile/app/modules/home/views/home_navbar.dart';
import 'package:cema_mobile/app/modules/login/bindings/login_binding.dart';
import 'package:cema_mobile/app/modules/login/views/login_view.dart';
import 'package:cema_mobile/app/modules/privacy_and_policy/bindings/privacy_and_policy_binding.dart';
import 'package:cema_mobile/app/modules/privacy_and_policy/views/privacy_and_policy_view.dart';
import 'package:cema_mobile/app/modules/profile/bindings/profile_binding.dart';
import 'package:cema_mobile/app/modules/profile/views/profile_view.dart';
import 'package:cema_mobile/app/modules/register/bindings/register_binding.dart';
import 'package:cema_mobile/app/modules/register/views/register_view.dart';
import 'package:cema_mobile/app/modules/update_profile/bindings/update_profile_binding.dart';
import 'package:cema_mobile/app/modules/update_profile/views/update_profile_view.dart';
import 'package:cema_mobile/app/modules/task_manager/bindings/task_manager_binding.dart';
import 'package:cema_mobile/app/modules/task_manager/views/task_manager_view.dart';
import 'package:cema_mobile/app/modules/tambah_proyek/bindings/tambah_proyek_binding.dart';
import 'package:cema_mobile/app/modules/tambah_proyek/views/tambah_proyek_view.dart';
import 'package:cema_mobile/app/modules/project_detail/bindings/project_detail_bindings.dart';
import 'package:cema_mobile/app/modules/project_detail/view/project_detail_view.dart';
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
    GetPage(
      name: _Paths.DASHBOARD,
      page: () => const DashboardView(),
      binding: DashboardBinding(),
    ),
    GetPage(
      name: _Paths.PROFILE,
      page: () => ProfilePage(),
      binding: ProfileBinding(),
    ),
    GetPage(
      name: _Paths.PRIVACYANDPOLICY,
      page: () => PrivacyPolicyPage(),
      binding: PrivacyAndPolicyBinding(),
    ),
    GetPage(
      name: _Paths.UPDATEPROFILE,
      page: () => UpdateProfilePage(),
      binding: UpdateProfileBinding(),
    ),
    GetPage(
      name: _Paths.CSSUPPORT,
      page: () => CustomerSupportPage(),
      binding: CsSupportBinding(),
    ),
    GetPage(
      name: _Paths.TASKMANAGER,
      page: () => TaskManagerPage(),
      binding: TaskManagerBinding(),
    ),
    GetPage(
      name: _Paths.TAMBAHPROYEK,
      page: () => TambahProyekPage(),
      binding: TambahProyekBinding(),
    ),
    GetPage(
      name: _Paths.PROJECT_DETAILS,
      page: () => const ProjectDetailView(),
      binding: ProjectDetailBinding(),
    ),
  ];
}
