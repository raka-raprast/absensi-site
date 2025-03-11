import 'package:absensi_site/absensi/ui/pages/absensi_list.dart';
import 'package:absensi_site/auth/controller/auth_controller.dart';
import 'package:flutter/material.dart';
import 'package:get_storage/get_storage.dart';
import 'package:refreshed/refreshed.dart';

class HomePage extends GetView<AuthController> {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    final GetStorage storage = GetStorage();
    return GetBuilder<AuthController>(
      builder: (controller) => Scaffold(
        appBar: AppBar(
          actions: [
            IconButton.filled(
                onPressed: controller.logout,
                icon: Icon(
                  Icons.logout,
                  color: Colors.white,
                ))
          ],
          title: Text('Welcome ${storage.read('name')}'),
        ),
        body: Column(
          children: [
            buildButton(context, "Absensi", () {
              Get.to(() => AbsensiListPage());
            }),
            buildButton(context, "Pengajuan Cuti", () {}),
          ],
        ),
      ),
    );
  }

  Widget buildButton(BuildContext context, String title, Function() onTap) =>
      GestureDetector(
        onTap: onTap,
        child: Container(
          padding: EdgeInsets.all(16),
          margin: EdgeInsets.all(12),
          width: Get.width,
          decoration: BoxDecoration(
            color: context.theme.primaryColor,
            borderRadius: BorderRadius.circular(8),
          ),
          child: Text(
            title,
            style: TextStyle(fontSize: 24, color: context.theme.indicatorColor),
          ),
        ),
      );
}
