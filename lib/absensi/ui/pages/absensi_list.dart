import 'package:absensi_site/absensi/controller/absen_list.controller.dart';
import 'package:absensi_site/absensi/model/absensi.model.dart';
import 'package:absensi_site/absensi/ui/pages/absensi_detail.dart';
import 'package:absensi_site/absensi/ui/pages/absensi_done_detail.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:refreshed/refreshed.dart';

class AbsensiListPage extends GetView<AbsenListController> {
  const AbsensiListPage({super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<AbsenListController>(
      init: AbsenListController(),
      builder: (AbsenListController controller) => Scaffold(
        appBar: AppBar(
          title: Text('Absensi'),
        ),
        body: Obx(
          () {
            if (controller.isLoading.value) {
              return Center(child: CircularProgressIndicator());
            }
            if (controller.absenList.isEmpty) {
              return Center(child: Text('Data absen kosong'));
            }
            return ListView.builder(
                itemBuilder: (context, i) => GestureDetector(
                      onTap: () async {
                        if (controller.absenList[i].endDate == null) {
                          final AbsensiModel? res =
                              await Get.to(() => AbsensiDetailPage(
                                    isMasuk: false,
                                    existingAbsen: controller.absenList[i],
                                  ));
                          if (res != null) {
                            controller.updateItemAbsenList(res);
                          }
                        } else {
                          Get.to(() => AbsensiDoneDetail(
                              absensi: controller.absenList[i]));
                        }
                      },
                      child: Container(
                        padding: EdgeInsets.all(16),
                        margin: EdgeInsets.all(12),
                        width: Get.width,
                        decoration: BoxDecoration(
                          color: context.theme.primaryColor,
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              controller.absenList[i].endDate != null ||
                                      controller.absenList[i].startDate != null
                                  ? DateFormat('dd/MM/yyyy HH:mm').format(
                                      controller.absenList[i].endDate ??
                                          controller.absenList[i].startDate ??
                                          DateTime.now())
                                  : '-',
                              style: TextStyle(
                                  fontSize: 14,
                                  color: context.theme.indicatorColor),
                            ),
                            Text(
                              controller.absenList[i].endDate != null
                                  ? 'Shift Selesai'
                                  : 'Shift Berjalan',
                              style: TextStyle(
                                  fontSize: 14,
                                  color: context.theme.indicatorColor),
                            ),
                          ],
                        ),
                      ),
                    ),
                itemCount: controller.absenList.length);
          },
        ),
        floatingActionButton: TextButton(
          onPressed: () async {
            final AbsensiModel? res = await Get.to(() => AbsensiDetailPage(
                  isMasuk: true,
                ));
            if (res != null) {
              controller.addItemAbsenList(res);
            }
          },
          style: ButtonStyle(
              backgroundColor:
                  WidgetStatePropertyAll(context.theme.primaryColor)),
          child: Text(
            'Absen Masuk',
            style: TextStyle(color: Colors.white),
          ),
        ),
      ),
    );
  }
}
