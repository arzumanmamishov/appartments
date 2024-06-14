// ignore_for_file: prefer_const_constructors

part of dashboard;

class DashboardController extends GetxController {
  final scafoldKey = GlobalKey<ScaffoldState>();
  final AuthController authController = Get.put(AuthController());

  final dataProfil = const UserProfileData(
    image: AssetImage(ImageRasterPath.man),
    name: "Parviz",
    jobDesk: "Owner",
  );

  void onPressedProfil() {}

  Future<void> onSelectedMainMenu(int index, SelectionButtonData value) async {
    if (index == 0) {
      Get.toNamed('/');
    }
    if (index == 1) {
      // NavigationService().navigateToScreen(AddingNewApartment());
      Get.to(AddingNewApartment());
    }
    if (index == 3) {
      authController.logout();
    }
  }

  void onSelectedTaskMenu(int index, String label) {}

  void searchTask(String value) {}

  void onPressedTask(int index, ListTaskAssignedData data) {}
  void onPressedAssignTask(int index, ListTaskAssignedData data) {}
  void onPressedMemberTask(int index, ListTaskAssignedData data) {}
  void onPressedCalendar() {}
  void onPressedTaskGroup(int index, ListAppartDateData data) {}

  void openDrawer() {
    if (scafoldKey.currentState != null) {
      scafoldKey.currentState!.openDrawer();
    }
  }
}
