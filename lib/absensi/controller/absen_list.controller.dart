import 'package:absensi_site/absensi/model/absensi.model.dart';
import 'package:get_storage/get_storage.dart';
import 'package:refreshed/refreshed.dart';

class AbsenListController extends GetxController {
  final RxString errorMessage = ''.obs;
  final RxBool isLoading = false.obs;
  final RxList<AbsensiModel> absenList = <AbsensiModel>[].obs;

  @override
  void onReady() async {
    super.onReady();
    isLoading.value = true;
    await _fetchAbsenList();
    isLoading.value = false;
  }

  Future<void> _fetchAbsenList() async {
    isLoading.value = true;
    final GetStorage storage = GetStorage();
    try {
      absenList.value = storage.read('absenList') ?? [];
      isLoading.value = false;
    } catch (e) {
      isLoading.value = false;
      errorMessage.value = e.toString();
    }
  }

  Future<void> addItemAbsenList(AbsensiModel newModel) async {
    final GetStorage storage = GetStorage();
    try {
      isLoading.value = true;
      absenList.value.add(newModel);
      storage.write('absenList', absenList.value);
      isLoading.value = false;
    } catch (e) {
      isLoading.value = false;
      errorMessage.value = e.toString();
    }
  }

  Future<void> updateItemAbsenList(AbsensiModel updateModel) async {
    final GetStorage storage = GetStorage();
    try {
      isLoading.value = true;
      final index =
          absenList.value.indexWhere((item) => item.id == updateModel.id);
      if (index != -1) {
        absenList.value[index] = updateModel;
      } else {
        isLoading.value = false;
        return;
      }
      storage.write('absenList', absenList.value);
      isLoading.value = false;
    } catch (e) {
      isLoading.value = false;
      errorMessage.value = e.toString();
    }
  }
}
