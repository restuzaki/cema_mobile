import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

class HomeController extends GetxController {
  var selectedIndex = 0.obs;
  var isFabExpanded = false.obs;

  var name = ''.obs;
  var role = ''.obs;
  var profilePic = ''.obs;

  var currentPageName = ''.obs;

  @override
  void onInit() {
    fetchUserProfile();
    super.onInit();
  }

  void fetchUserProfile() {
    final box = GetStorage();

    name.value = box.read('name');
    role.value = box.read('role');
    profilePic.value = box.read('profilePic') ?? "";
  }

  bool _isChangingTab = false;

  void updateCurrentPageName() {
    switch (selectedIndex.value) {
      case 0:
        currentPageName.value = "Dashboard";
        break;
      case 1:
        currentPageName.value = "Proyek";
        break;
      case 2:
        currentPageName.value = "Profil";
        break;
      default:
        currentPageName.value = "";
        break;
    }
  }

  void changeTabIndex(int index) {
    if (_isChangingTab || selectedIndex.value == index) return;

    _isChangingTab = true;
    selectedIndex.value = index;

    if (isFabExpanded.value) {
      isFabExpanded.value = false;
    }

    Future.delayed(const Duration(milliseconds: 300), () {
      _isChangingTab = false;
    });
  }

  void toggleFab() {
    isFabExpanded.value = !isFabExpanded.value;
  }

  void closeFab() {
    if (isFabExpanded.value) {
      isFabExpanded.value = false;
    }
  }
}
