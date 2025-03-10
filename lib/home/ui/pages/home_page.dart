import 'package:flutter/material.dart';
import 'package:get_storage/get_storage.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: IconButton.filled(onPressed: () {
           final GetStorage storage = GetStorage();
           storage.erase();
        }, icon: Icon(Icons.logout)),
      ),
    );
  }
}
