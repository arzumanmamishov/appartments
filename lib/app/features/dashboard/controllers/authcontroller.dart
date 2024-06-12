import 'package:apartments/app/utils/services/auth_services.dart';
import 'package:get/get.dart';

class AuthController extends GetxController {
  var isAuthenticated = false.obs;

  @override
  void onInit() {
    super.onInit();
    checkAuthenticationStatus();
  }

  Future<void> checkAuthenticationStatus() async {
    isAuthenticated.value = await AuthService.isAuthenticated();
  }

  login(String email, String password) async {
    final errorMessage = await AuthService().login(email, password);
    if (errorMessage == null) {
      isAuthenticated.value = true;
      Get.offAllNamed('/'); // Navigate to home page
    } else {
      Get.snackbar('Login Failed', errorMessage);
    }
  }

  void logout() async {
    await AuthService.logout();
    isAuthenticated.value = false;
    Get.offAllNamed('/login'); // Navigate to login page
  }
}
