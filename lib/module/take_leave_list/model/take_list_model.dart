import '../../../core/constants/secure_storage.dart';

class TakeListModel {
  final String id;
  final DateTime startDate;
  final DateTime endDate;
  final String reason;
  final String? status;
  final DateTime? createdAt;

  factory TakeListModel.fromJson(Map<String, dynamic> json) {
    return TakeListModel(
      id: json['_id'] as String,
      startDate: DateTime.parse(json['startDate'] as String),
      endDate: DateTime.parse(json['endDate'] as String),
      reason: json['reason'] as String,
      status: json['status'] as String?,
      createdAt: DateTime.tryParse(json['createdAt'] as String),
    );
  }

  TakeListModel({
    this.id = '',
    required this.startDate,
    required this.endDate,
    required this.reason,
    this.status,
    this.createdAt,
  });

  Future<Map<String, dynamic>> toJson() async {
    final userId = await SecureStorage.getUserId();
    return {
      'userId': userId,
      'startDate': startDate.toIso8601String(),
      'endDate': endDate.toIso8601String(),
      'reason': reason,
    };
  }
}
