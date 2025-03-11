import 'dart:io';

import 'package:absensi_site/absensi/controller/absensi_detail.controller.dart';
import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:refreshed/refreshed.dart';

class TakePicturePage extends GetView<AbsenDetailController> {
  const TakePicturePage({super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<AbsenDetailController>(
        builder: (AbsenDetailController controller) => Scaffold(
              appBar: AppBar(
                title: Text('Take Picture'),
                actions: [
                  IconButton(
                      onPressed: () {
                        controller.switchCamera();
                      },
                      icon: Icon(Icons.cameraswitch)),
                  IconButton(
                      onPressed: () {
                        //TODO: add flash
                      },
                      icon: Icon(Icons.flash_on))
                ],
              ),
              body: Column(
                children: [
                  Obx(() {
                    if (controller.isLoading.value ||
                        controller.cameraController.value == null ||
                        (controller.pictureFile.value != null &&
                            (controller.position.value == null ||
                                controller.location.value == null))) {
                      return Center(child: CircularProgressIndicator());
                    }
                    if (controller.pictureFile.value != null) {
                      return Stack(
                        children: [
                          Image.file(
                            File(controller.pictureFile.value!.path),
                            height: double.infinity,
                            fit: BoxFit.cover,
                          ),
                          Positioned(
                            bottom: 12,
                            left: 12,
                            child: IntrinsicHeight(
                              child: Container(
                                constraints:
                                    BoxConstraints(maxWidth: Get.width * .6),
                                padding: EdgeInsets.all(8),
                                decoration: BoxDecoration(color: Colors.white),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                        "Address: ${controller.location.value?.addressLine1 ?? controller.location.value?.addressLine2 ?? controller.location.value?.name ?? controller.location.value?.street}"),
                                    Text(
                                        "Latitude: ${controller.position.value?.latitude.toString() ?? '-'}"),
                                    Text(
                                        "Longitude: ${controller.position.value?.longitude.toString() ?? '-'}"),
                                  ],
                                ),
                              ),
                            ),
                          )
                        ],
                      );
                    }
                    return CameraPreview(controller.cameraController.value!);
                  }),
                  Expanded(
                    child: Center(
                      child: Obx(
                        () => Opacity(
                          opacity: controller.pictureFile.value == null ? 1 : 0,
                          child: ElevatedButton(
                            onPressed: controller.takePictures,
                            child: Icon(
                              Icons.camera_alt,
                              size: 24,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ));
  }
}
