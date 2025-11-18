import 'package:get/get.dart';

class HomeController extends GetxController {
  var selectedIndex = 0.obs;
  var isFabExpanded = false.obs;

  // Debouncing untuk mencegah rapid taps
  bool _isChangingTab = false;

  void changeTabIndex(int index) {
    if (_isChangingTab || selectedIndex.value == index) return;

    _isChangingTab = true;
    selectedIndex.value = index;

    // Close FAB menu when changing tabs
    if (isFabExpanded.value) {
      isFabExpanded.value = false;
    }

    // Reset debounce setelah animation selesai
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

  @override
  void onClose() {
    // Cleanup
    super.onClose();
  }
}
