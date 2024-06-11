import 'package:apartments/app/features/dashboard/views/screens/apartment_details.dart';
import 'package:apartments/app/features/dashboard/views/screens/login_screen.dart';
import 'package:apartments/app/utils/services/shared_preferences.dart';

import '../../features/dashboard/views/screens/dashboard_screen.dart';
import 'package:get/get.dart';

part 'app_routes.dart';

class AppPages {
  final accessToken = SPHelper.getTokenSharedPreference();
  static const initial = Routes.dashboard;

  static final routes = [
    GetPage(
      name: _Paths.dashboard,
      page: () => const DashboardScreen(),
      binding: DashboardBinding(),
    ),
    GetPage(
      name: _Paths.appartDetails,
      page: () => const ApartmentDetails(),
      binding: DetailsdBinding(),
    ),
    GetPage(
      name: _Paths.loginScreen,
      page: () => const LoginScreen(),
      binding: DetailsdBinding(),
    ),
  ];
}

Future<String> getToken() async {
  final accessToken = await SPHelper.getTokenSharedPreference() ?? '';
  return accessToken;
}
