import 'dart:io';
import 'dart:math';

import 'package:absensi_site/absensi/controller/absensi_detail.controller.dart';
import 'package:absensi_site/absensi/ui/pages/take_picture.dart';
import 'package:flutter/material.dart';
import 'package:refreshed/refreshed.dart';
import 'package:absensi_site/absensi/model/absensi.model.dart';

class AbsensiDetailPage extends GetView<AbsenDetailController> {
  const AbsensiDetailPage({
    super.key,
    this.isMasuk = false,
    this.existingAbsen,
  });
  final bool isMasuk;
  final AbsensiModel? existingAbsen;
  @override
  Widget build(BuildContext context) {
    return GetBuilder<AbsenDetailController>(
      init: AbsenDetailController(isMasuk: isMasuk),
      builder: (controller) => Scaffold(
        appBar: AppBar(
          title: Text(controller.isMasuk ? 'Absen Masuk' : "Absen Keluar"),
        ),
        body: Column(
          children: [
            Expanded(
              child: ListView(
                children: [
                  Container(
                    margin: EdgeInsets.all(12),
                    width: Get.width,
                    height: Get.height * .5,
                    decoration: BoxDecoration(
                      color: Colors.grey,
                    ),
                    child: Obx(() {
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
                              width: double.infinity,
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
                                  decoration:
                                      BoxDecoration(color: Colors.white),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
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
                      return Center(
                        child: TextButton(
                          onPressed: () async {
                            Get.to(() => TakePicturePage());
                          },
                          style: ButtonStyle(
                            backgroundColor: WidgetStatePropertyAll(
                              context.theme.primaryColor,
                            ),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(
                                Icons.camera_alt,
                                color: Colors.white,
                              ),
                              Text(
                                'Take Picture',
                                style: TextStyle(color: Colors.white),
                              ),
                            ],
                          ),
                        ),
                      );
                    }),
                  ),
                  if (!controller.isMasuk)
                    Container(
                      decoration: BoxDecoration(
                        color: context.theme.scaffoldBackgroundColor,
                      ),
                      padding: EdgeInsets.all(12),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('Keterangan'),
                          TextField(
                            controller: controller.remarksController.value,
                            decoration: InputDecoration(
                              isDense: true,
                              border: OutlineInputBorder(),
                              hintText: 'Masukkan keterangan',
                              hintStyle:
                                  TextStyle(color: Colors.grey, fontSize: 14),
                            ),
                            maxLines: 7,
                          ),
                        ],
                      ),
                    ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: TextButton(
                onPressed: () {
                  if (controller.pictureFile.value == null) {
                    return;
                  }
                  final AbsensiModel? absen;
                  if (controller.isMasuk) {
                    absen = AbsensiModel(
                        id: generateHexId(),
                        startLocation: controller.location.value,
                        startPosition: controller.position.value,
                        startImgFile: File(controller.pictureFile.value!.path),
                        startDate: DateTime.now());
                  } else {
                    absen = existingAbsen!.copyWith(
                      endLocation: controller.location.value,
                      endPosition: controller.position.value,
                      endImgFile: File(controller.pictureFile.value!.path),
                      endDate: DateTime.now(),
                      remarks: controller.remarksController.value!.text,
                    );
                  }
                  Get.back(result: absen);
                },
                style: ButtonStyle(
                  backgroundColor: WidgetStatePropertyAll(
                    (controller.isMasuk &&
                                controller.pictureFile.value != null) ||
                            (!controller.isMasuk &&
                                controller.pictureFile.value != null &&
                                controller
                                    .remarksController.value!.text.isNotEmpty)
                        ? context.theme.primaryColor
                        : Colors.grey,
                  ),
                ),
                child: Text(
                  controller.isMasuk ? 'Mulai Shift' : "Selesaikan Shift",
                  style: TextStyle(
                    color: (controller.isMasuk &&
                                controller.pictureFile.value != null) ||
                            (!controller.isMasuk &&
                                controller.pictureFile.value != null &&
                                controller
                                    .remarksController.value!.text.isNotEmpty)
                        ? Colors.white
                        : Colors.black,
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}

String generateHexId() {
  final Random random = Random();
  return List.generate(8, (_) => random.nextInt(16).toRadixString(16)).join();
}
