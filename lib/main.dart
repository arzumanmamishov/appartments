import 'dart:ui';
import 'package:apartments/app/features/dashboard/controllers/authcontroller.dart';
import 'package:apartments/app/features/dashboard/views/screens/apartment_details.dart';
import 'package:apartments/app/features/dashboard/views/screens/dashboard_screen.dart';
import 'package:apartments/app/features/dashboard/views/screens/edit_appartment_screen.dart';

import 'package:apartments/app/features/dashboard/views/screens/second_page.dart';
import 'package:apartments/app/utils/helpers/navigation_services.dart';
import 'package:bot_toast/bot_toast.dart';
import 'package:provider/provider.dart';

import 'app/config/themes/app_theme.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'app/features/dashboard/views/screens/login_screen.dart';
import 'app/providers/appartment_provider.dart';
import 'app/utils/services/auth_services.dart';

class AuthMiddleware extends GetMiddleware {
  @override
  RouteSettings? redirect(String? route) {
    AuthService.isAuthenticated().then((isAuthenticated) {
      if (!isAuthenticated) {
        Get.offNamed('/login');
      }
    });
    return null;
  }
}

class MyNavigatorObserver extends NavigatorObserver {
  @override
  void didPop(Route route, Route? previousRoute) {
    super.didPop(route, previousRoute);
    print(
        'didPop: ${route.settings.name}, previousRoute: ${previousRoute?.settings.name}');
    // Custom behavior on pop
  }

  @override
  void didPush(Route route, Route? previousRoute) {
    super.didPush(route, previousRoute);
    print(
        'didPush: ${route.settings.name}, previousRoute: ${previousRoute?.settings.name}');
    // Custom behavior on push
  }
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  Get.put(DashboardController()); // Initialize DashboardController
  final authController = Get.put(AuthController());
  await authController.checkAuthenticationStatus();

  runApp(MultiProvider(providers: [
    ChangeNotifierProvider(create: (_) => AppartDetailsListener()),
  ], child: const MyApp()));
}

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  String tokenExist = '';
  @override
  void initState() {
    super.initState();
  }

  final AuthController authController = Get.put(AuthController());

  @override
  Widget build(BuildContext context) {
    final authController = Get.find<AuthController>();

    return GetMaterialApp(
      navigatorKey: NavigationService().navigationKey,
      title: 'Apartment',
      theme: AppTheme.basic,
      initialRoute: authController.isAuthenticated.value ? '/' : '/login',
      getPages: [
        GetPage(
          name: '/',
          page: () => const DashboardScreen(),
          middlewares: [AuthMiddleware()],
        ),
        GetPage(name: '/login', page: () => const LoginScreen()),
        GetPage(name: '/apartmentdetail', page: () => const ApartmentDetail()),
        GetPage(
            name: '/editingApartments',
            page: () => const ApartmentEditDetail()),
        GetPage(
          name: '/second',
          page: () => const SecondPage(),
          middlewares: [AuthMiddleware()],
        ),
      ],
      scrollBehavior: CustomScrollBehaviour(),
      builder: BotToastInit(),
      navigatorObservers: [BotToastNavigatorObserver(), MyNavigatorObserver()],
      debugShowCheckedModeBanner: false,
    );
  }
}

class CustomScrollBehaviour extends MaterialScrollBehavior {
  @override
  Set<PointerDeviceKind> get dragDevices => {
        PointerDeviceKind.touch,
        PointerDeviceKind.mouse,
      };
}
