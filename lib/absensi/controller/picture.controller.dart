import 'dart:developer';

import 'package:absensi_site/absensi/model/absen_picture.model.dart';
import 'package:absensi_site/absensi/model/geopify_location.model.dart';
import 'package:camera/camera.dart';
import 'package:dio/dio.dart';
import 'package:geolocator/geolocator.dart';
import 'package:refreshed/refreshed.dart';
import 'package:geocoding/geocoding.dart';

class PictureController extends GetxController {
  final RxString errorMessage = ''.obs;
  final RxBool isLoading = false.obs, isTakingPicture = false.obs;
  final RxList<AbsenPictureModel> pictures = <AbsenPictureModel>[].obs;
  Rxn<CameraController?> cameraController = Rxn<CameraController?>();
  late List<CameraDescription> _cameras;
  final Rxn<XFile?> pictureFile = Rxn<XFile?>();
  final Rxn<Position?> position = Rxn<Position?>();
  final Rxn<GeopifyLocation?> location = Rxn<GeopifyLocation?>();

  @override
  void onReady() async {
    super.onReady();
    isLoading.value = true;
    await _initializeCamera();
    await _checkAndRequestPermission();
    isLoading.value = false;
  }

  @override
  void dispose() {
    cameraController.value?.dispose();
    super.dispose();
  }

  Future<void> _initializeCamera() async {
    try {
      _cameras = await availableCameras();
      cameraController.value =
          CameraController(_cameras[0], ResolutionPreset.max);
      await cameraController.value?.initialize();
    } catch (e) {
      if (e is CameraException) {
        switch (e.code) {
          case 'CameraAccessDenied':
            errorMessage.value = 'Camera access denied';
            break;
          default:
            errorMessage.value = 'Error initializing camera: ${e.code}';
            break;
        }
      } else {
        errorMessage.value = e.toString();
      }
    }
  }

  void takePictures() async {
    try {
      isTakingPicture.value = true;
      final res = await cameraController.value?.takePicture();
      if (res != null) {
        pictureFile.value = res;
        final determinedPosition = await _determinePosition();
        position.value = determinedPosition;
        await getAddress();
        isTakingPicture.value = false;
      } else {
        isTakingPicture.value = false;
      }
    } catch (e) {
      isTakingPicture.value = false;
      log('Error taking picture: $e');
      errorMessage.value = e.toString();
    }
  }

  Future<void> getAddress() async {
    if (position.value == null ||
        position.value?.latitude == null ||
        position.value?.longitude == null) {
      log('here');
      return;
    }
    var dio = Dio();
    var url =
        "https://api.geoapify.com/v1/geocode/reverse?lat=${position.value?.latitude}&lon=${position.value?.longitude}&apiKey=16c94fce8318406991d1526b97de1d15";

    try {
      var response = await dio.get(url);

      if (response.statusCode == 200) {
        final res = GeopifyLocation.fromJson(
            response.data['features'][0]['properties']);
        location.value = res;
      } else {
        log('Request failed with status: ${response.statusCode}');
      }
    } catch (error) {
      log('Error: $error');
    }
    // final placemarkResult = await placemarkFromCoordinates(
    //     position.value!.latitude, position.value!.longitude);
    // if (placemarkResult.isNotEmpty) {
    //   log('there');
    //   placemark.value = placemarkResult.first;
    // } else {
    //   log('uhuy');
    //   return;
    // }
  }

  Future<Position> _determinePosition() async {
    if (!await Geolocator.isLocationServiceEnabled()) {
      return Future.error('Location services are disabled.');
    }

    if (!await _checkAndRequestPermission()) {
      return Future.error('Location permissions are denied.');
    }

    return await Geolocator.getCurrentPosition();
  }

  Future<bool> _checkAndRequestPermission() async {
    LocationPermission permission = await Geolocator.checkPermission();

    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        return false;
      }
    }

    if (permission == LocationPermission.deniedForever) {
      return false;
    }

    return true;
  }
}
