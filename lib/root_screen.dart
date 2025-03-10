import 'package:absensi_site/auth/controller/auth_controller.dart';
import 'package:absensi_site/auth/ui/pages/login_screen.dart';
import 'package:absensi_site/home/ui/pages/home_page.dart';
import 'package:flutter/material.dart';
import 'package:refreshed/refreshed.dart';

class RootScreen extends StatelessWidget {
  final AuthController authController = Get.put(AuthController());

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      return authController.isLoggedIn.value ? HomePage() : LoginPage();
    });
  }
}
