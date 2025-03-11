import 'package:absensi_site/absensi/ui/pages/take_picture.dart';
import 'package:absensi_site/root_screen.dart';
import 'package:flutter/material.dart';
import 'package:get_storage/get_storage.dart';
import 'package:refreshed/refreshed.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await GetStorage.init(); // Initialize GetStorage

  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      // home: TakePicturePage(),
      home: RootScreen(),
    );
  }
}
