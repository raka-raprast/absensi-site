import 'package:absensi_site/auth/controller/auth_controller.dart';
import 'package:flutter/material.dart';
import 'package:refreshed/refreshed.dart';

class LoginPage extends GetView<AuthController> {
  final TextEditingController nameController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final RxString selectedSite = ''.obs; // Observable site selection

  

  @override
  Widget build(BuildContext context) {
    final List<String> siteOptions = availableAccounts.map((e) => e.site).toSet().toList();

    return Scaffold(
      appBar: AppBar(title: Text("Login")),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(controller: nameController, decoration: InputDecoration(labelText: "Name")),
            TextField(controller: passwordController, decoration: InputDecoration(labelText: "Password"), obscureText: true),
            Obx(
              () => DropdownButtonFormField<String>(
                value: selectedSite.value.isEmpty ? null : selectedSite.value,
                items: siteOptions.map((site) {
                  return DropdownMenuItem(value: site, child: Text(site));
                }).toList(),
                onChanged: (value) => selectedSite.value = value!,
                decoration: InputDecoration(labelText: "Site"),
              ),
            ),
            SizedBox(height: 20),
            Obx(() => Text(controller.errorMessage.value, style: TextStyle(color: Colors.red))),
            ElevatedButton(
              onPressed: () {
                controller.login(nameController.text, passwordController.text, selectedSite.value);
              },
              child: Text("Login"),
            ),
            Obx(() => controller.isLoggedIn.value ? Text("Login Successful!") : Container()),
          ],
        ),
      ),
    );
  }
}
