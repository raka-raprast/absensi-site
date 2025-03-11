import 'dart:developer';

import 'package:absensi_site/absensi/model/absen_picture.model.dart';
import 'package:absensi_site/absensi/model/absensi.model.dart';
import 'package:absensi_site/absensi/model/geopify_location.model.dart';
import 'package:camera/camera.dart';
import 'package:dio/dio.dart';
import 'package:flutter/widgets.dart';
import 'package:geolocator/geolocator.dart';
import 'package:refreshed/refreshed.dart';

class AbsenDetailController extends GetxController {
  final RxString errorMessage = ''.obs;
  final RxBool isLoading = false.obs, isTakingPicture = false.obs;
  final RxList<AbsenPictureModel> pictures = <AbsenPictureModel>[].obs;
  Rxn<CameraController?> cameraController = Rxn<CameraController?>();
  Rxn<TextEditingController?> remarksController =
      Rxn<TextEditingController?>(TextEditingController());
  late List<CameraDescription> _cameras;
  final Rxn<XFile?> pictureFile = Rxn<XFile?>();
  final Rxn<Position?> position = Rxn<Position?>();
  final Rxn<GeopifyLocation?> location = Rxn<GeopifyLocation?>();
  final bool isMasuk;
  final AbsensiModel? existingAbsen;

  AbsenDetailController({this.isMasuk = false, this.existingAbsen});

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

      // Find the front camera
      final frontCamera = _cameras.firstWhere(
        (camera) => camera.lensDirection == CameraLensDirection.front,
        orElse: () => _cameras
            .first, // Fallback to first camera if no front camera is found
      );

      cameraController.value =
          CameraController(frontCamera, ResolutionPreset.max);
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

  void setCamera(CameraDescription camera) async {
    cameraController.value?.dispose();
    cameraController.value = CameraController(camera, ResolutionPreset.medium);
    await cameraController.value!.initialize();
  }

  void switchCamera() async {
    isLoading.value = true;
    if (_cameras == null || _cameras!.isEmpty) {
      isLoading.value = false;
      return;
    }

    final isUsingFront = cameraController.value?.description.lensDirection ==
        CameraLensDirection.front;
    final newCamera = _cameras!.firstWhere(
      (camera) =>
          camera.lensDirection ==
          (isUsingFront ? CameraLensDirection.back : CameraLensDirection.front),
      orElse: () => _cameras!.first,
    );

    if (cameraController.value?.description == newCamera) {
      isLoading.value = false;
      return; // Prevent unnecessary re-initialization
    }

    await cameraController.value?.dispose();
    cameraController.value = CameraController(newCamera, ResolutionPreset.max);
    isLoading.value = false;
    try {
      await cameraController.value!.initialize();
    } catch (e) {
      isLoading.value = false;
      errorMessage.value = 'Error switching camera: $e';
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
        Get.back();
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
