import 'dart:io';

import 'package:absensi_site/absensi/model/absensi.model.dart';
import 'package:absensi_site/absensi/model/geopify_location.model.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:intl/intl.dart';

class AbsensiDoneDetail extends StatelessWidget {
  const AbsensiDoneDetail({super.key, required this.absensi});
  final AbsensiModel absensi;

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          title: const Text("Absensi Detail"),
          bottom: const TabBar(
            tabs: [
              Tab(text: "Start"),
              Tab(text: "End"),
            ],
          ),
        ),
        body: TabBarView(
          children: [
            _buildAbsensiDetail(
              context,
              imgFile: absensi.startImgFile,
              location: absensi.startLocation,
              position: absensi.startPosition,
              date: absensi.startDate,
            ),
            _buildAbsensiDetail(
              context,
              imgFile: absensi.endImgFile,
              location: absensi.endLocation,
              position: absensi.endPosition,
              remarks: absensi.remarks,
              date: absensi.endDate,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAbsensiDetail(
    BuildContext context, {
    File? imgFile,
    GeopifyLocation? location,
    Position? position,
    DateTime? date,
    String? remarks,
  }) {
    return Column(
      children: [
        Expanded(
          child: ListView(
            children: [
              Container(
                margin: const EdgeInsets.all(12),
                width: double.infinity,
                height: MediaQuery.of(context).size.height * .5,
                decoration: const BoxDecoration(color: Colors.grey),
                child: Stack(
                  children: [
                    if (imgFile != null)
                      Image.file(
                        imgFile,
                        height: double.infinity,
                        width: double.infinity,
                        fit: BoxFit.cover,
                      ),
                    Positioned(
                      bottom: 12,
                      left: 12,
                      child: IntrinsicHeight(
                        child: Container(
                          constraints: BoxConstraints(
                              maxWidth: MediaQuery.of(context).size.width * .6),
                          padding: const EdgeInsets.all(8),
                          decoration: const BoxDecoration(color: Colors.white),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                "Address: ${location?.addressLine1 ?? location?.addressLine2 ?? location?.name ?? location?.street ?? '-'}",
                              ),
                              Text("Latitude: ${position?.latitude ?? '-'}"),
                              Text("Longitude: ${position?.longitude ?? '-'}"),
                            ],
                          ),
                        ),
                      ),
                    )
                  ],
                ),
              ),
              if (date != null)
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 12),
                  child: Text(DateFormat('dd/MM/yyyy HH:mm').format(date)),
                ),
              if (remarks != null)
                Container(
                  padding: const EdgeInsets.all(12),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text('Keterangan'),
                      TextField(
                        readOnly: true,
                        controller: TextEditingController(text: remarks),
                        decoration: const InputDecoration(
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
      ],
    );
  }
}
