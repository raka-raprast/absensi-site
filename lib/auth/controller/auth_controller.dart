import 'package:absensi_site/auth/model/user_model.dart';
import 'package:get_storage/get_storage.dart';
import 'package:refreshed/refreshed.dart';

final List<User> availableAccounts = [
  User(
      id: "e8b5b3dc-8e50-4c37-9a29-0b5a4f9a6df8",
      name: "Rafly Akbar",
      password: "rafly123",
      site: "siteA"),
  User(
      id: "ad3b90c1-4e92-47b8-a3b7-92f5c5a3f4d1",
      name: "Raka Prasetyo",
      password: "raka123",
      site: "adminSite"),
  User(
      id: "fc8c9c2b-12b1-46d0-8e39-1c932fd22d40",
      name: "Ayaz Iman",
      password: "ayaz123",
      site: "adminSite"),
  User(
      id: "bb5f65e3-f0d8-4a46-90a2-6c8f239b7b89",
      name: "user1",
      password: "pass123",
      site: "siteA"),
  User(
      id: "d1f0cb19-29b2-4a2c-9a3e-7e6a4c2c476f",
      name: "user2",
      password: "pass456",
      site: "siteB"),
  User(
      id: "92d27468-49b5-4724-81e9-35b72df1b236",
      name: "user3",
      password: "pass789",
      site: "siteC"),
  User(
      id: "c47e9f98-1a6c-4e90-9671-3840a5e3070d",
      name: "admin",
      password: "adminpass",
      site: "adminSite"),
  User(
      id: "ae729d85-45cf-4fb7-b3a4-79964a4f96d3",
      name: "guest",
      password: "guestpass",
      site: "guestSite"),
];

class AuthController extends GetxController {
  var isLoggedIn = false.obs;
  var errorMessage = ''.obs;
  User? currentUser;
  final GetStorage storage = GetStorage();

  @override
  void onInit() {
    super.onInit();
    _loadUserFromStorage();
  }

  void login(String name, String password, String site) {
    final account = availableAccounts.firstWhereOrNull(
      (user) =>
          user.name == name && user.password == password && user.site == site,
    );

    if (account != null) {
      currentUser = account;
      isLoggedIn.value = true;
      errorMessage.value = "";

      // Save credentials to storage
      storage.write('isLoggedIn', true);
      storage.write('accountId', account.id);
      storage.write('name', account.name);
      storage.write('password', account.password);
      storage.write('site', account.site);
    } else {
      isLoggedIn.value = false;
      errorMessage.value = "Invalid credentials";
    }
  }

  void logout() {
    currentUser = null;
    isLoggedIn.value = false;

    // Clear storage
    storage.erase();
  }

  void _loadUserFromStorage() {
    bool? storedLogin = storage.read('isLoggedIn');
    if (storedLogin == true) {
      String? id = storage.read('accountId');
      String? name = storage.read('name');
      String? password = storage.read('password');
      String? site = storage.read('site');

      if (id != null && name != null && password != null && site != null) {
        currentUser = User(id: id, name: name, password: password, site: site);
        isLoggedIn.value = true;
      } else {
        logout();
      }
    }
  }
}
