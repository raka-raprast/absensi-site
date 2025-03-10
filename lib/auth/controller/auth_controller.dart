import 'package:absensi_site/auth/model/user_model.dart';
import 'package:get_storage/get_storage.dart';
import 'package:refreshed/refreshed.dart';
  final List<User> availableAccounts = [
    User(name: "user1", password: "pass123", site: "siteA"),
    User(name: "user2", password: "pass456", site: "siteB"),
    User(name: "user3", password: "pass789", site: "siteC"),
    User(name: "admin", password: "adminpass", site: "adminSite"),
    User(name: "guest", password: "guestpass", site: "guestSite"),
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
      (user) => user.name == name && user.password == password && user.site == site,
    );

    if (account != null) {
      currentUser = account;
      isLoggedIn.value = true;
      errorMessage.value = "";

      // Save credentials to storage
      storage.write('isLoggedIn', true);
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
      String? name = storage.read('name');
      String? password = storage.read('password');
      String? site = storage.read('site');

      if (name != null && password != null && site != null) {
        currentUser = User(name: name, password: password, site: site);
        isLoggedIn.value = true;
      }
    }
  }
}
