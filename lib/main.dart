import 'dart:ui';
import 'package:apartments/app/features/dashboard/views/screens/dashboard_screen.dart';
import 'package:apartments/app/utils/helpers/navigation_services.dart';
import 'package:bot_toast/bot_toast.dart';
import 'package:provider/provider.dart';

import 'app/api/client_api.dart';
import 'app/config/routes/app_pages.dart';
import 'app/config/themes/app_theme.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'app/features/dashboard/views/screens/login_screen.dart';
import 'app/providers/appartment_provider.dart';

void main() {
  runApp(MultiProvider(providers: [
    MultiProvider(providers: [
      ChangeNotifierProvider(create: (_) => AppartDetailsListener()),
    ]),
  ], child: const MyApp()));
}

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  String tokenExist = '';
  ApiClient apiClient = ApiClient();
  @override
  void initState() {
    getToken();
    super.initState();
  }

  getToken() async {
    tokenExist = await apiClient.getToken();
  }

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      navigatorKey: NavigationService().navigationKey,
      title: 'Apartment',
      theme: AppTheme.basic,
      // initialRoute: AppPages.initial,
      getPages: AppPages.routes,
      home: tokenExist.isNotEmpty == true
          ? const DashboardScreen()
          : const LoginScreen(),
      scrollBehavior: CustomScrollBehaviour(),
      builder: BotToastInit(),
      navigatorObservers: [BotToastNavigatorObserver()],
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
