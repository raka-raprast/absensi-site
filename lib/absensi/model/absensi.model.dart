import 'dart:io';

import 'package:absensi_site/absensi/model/geopify_location.model.dart';
import 'package:geolocator/geolocator.dart';

class AbsensiModel {
  final String? id;
  final String? accountId;
  final DateTime? startDate;
  final DateTime? endDate;
  final String? startImgUrl;
  final String? endImgUrl;
  final File? startImgFile;
  final File? endImgFile;
  final GeopifyLocation? startLocation;
  final GeopifyLocation? endLocation;
  final Position? startPosition;
  final Position? endPosition;
  final String? remarks;

  AbsensiModel({
    this.id,
    this.accountId,
    this.startDate,
    this.endDate,
    this.startImgUrl,
    this.endImgUrl,
    this.startLocation,
    this.endLocation,
    this.startPosition,
    this.endPosition,
    this.remarks,
    this.startImgFile,
    this.endImgFile,
  });

  AbsensiModel copyWith({
    String? id,
    String? accountId,
    DateTime? startDate,
    DateTime? endDate,
    String? startImgUrl,
    String? endImgUrl,
    GeopifyLocation? startLocation,
    GeopifyLocation? endLocation,
    Position? startPosition,
    Position? endPosition,
    String? remarks,
    File? startImgFile,
    File? endImgFile,
  }) {
    return AbsensiModel(
      id: id ?? this.id,
      accountId: accountId ?? this.accountId,
      startDate: startDate ?? this.startDate,
      endDate: endDate ?? this.endDate,
      startImgUrl: startImgUrl ?? this.startImgUrl,
      endImgUrl: endImgUrl ?? this.endImgUrl,
      startLocation: startLocation ?? this.startLocation,
      endLocation: endLocation ?? this.endLocation,
      startPosition: startPosition ?? this.startPosition,
      endPosition: endPosition ?? this.endPosition,
      remarks: remarks ?? this.remarks,
      startImgFile: startImgFile ?? this.startImgFile,
      endImgFile: endImgFile ?? this.endImgFile,
    );
  }
}
