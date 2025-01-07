import 'package:flutter_launcher_icons/custom_exceptions.dart';

import '../../../core/constants/secure_storage.dart';

class TimeKeepingModel {
  final String userId;
  final DateTime checkinAt;
  final DateTime? checkoutAt;
  final String status;
  final String note;

  TimeKeepingModel({
    this.userId = '',
    required this.checkinAt,
    this.checkoutAt,
    required this.status,
    required this.note,
  });

  Future<Map<String, dynamic>> toJson() async {
    final userId = await SecureStorage.getUserId();
    return <String, dynamic>{
      'userId': userId,
      'checkinAt': checkinAt.toIso8601String(),
      'status': status,
      'note': note,
    };
  }

  factory TimeKeepingModel.fromJson(Map<String, dynamic> map) {
    return TimeKeepingModel(
      userId: map['userId'] as String,
      checkinAt:
          DateTime.tryParse(map['checkinAt'] as String) ?? DateTime.now(),
      checkoutAt: map['checkoutAt'] != null
          ? DateTime.tryParse((map['checkoutAt'] as String?) ?? '')
          : null,
      status: map['status'] as String,
      note: map['note'] as String,
    );
  }
}

class TimeMyKeepingModel {
  final String checkinAt;
  final String? checkoutAt;
  final String hoursWorked;
  final String idUser;

  TimeMyKeepingModel(
      {required this.checkinAt,
      this.checkoutAt,
      required this.hoursWorked,
      required this.idUser});
  factory TimeMyKeepingModel.formJson(Map<String, dynamic> json) {
    return TimeMyKeepingModel(
      checkinAt: json['checkinAt'],
      checkoutAt: json['checkoutAt'] as String?,
      hoursWorked: json['hoursWorked'].toString(),
      idUser: json['userId']['_id'],
    );
  }
}
