import 'package:flutter/material.dart';

class AppointmentModel {
  String id;
  final String doctorId;
  final String userId;
  final DateTime appointmentDate;
  final TimeOfDay appointmentTime;
  final double consultationFee;
  final String status;

  AppointmentModel({
    this.id = '',
    required this.doctorId,
    required this.userId,
    required this.appointmentDate,
    required this.appointmentTime,
    required this.consultationFee,
    this.status = 'pending',
  });

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'doctorId': doctorId,
      'userId': userId,
      'appointmentDate': appointmentDate.toIso8601String(),
      'appointmentTime': '${appointmentTime.hour}:${appointmentTime.minute}',
      'consultationFee': consultationFee,
      'status': status,
    };
  }

  factory AppointmentModel.fromJson(Map<String, dynamic> json) {
    return AppointmentModel(
      id: json['id'],
      doctorId: json['doctorId'],
      userId: json['userId'],
      appointmentDate: DateTime.parse(json['appointmentDate']),
      appointmentTime: _parseTimeOfDay(json['appointmentTime']),
      consultationFee: json['consultationFee'],
      status: json['status'],
    );
  }

  static TimeOfDay _parseTimeOfDay(String time) {
    final parts = time.split(':');
    final hour = int.parse(parts[0]);
    final minute = int.parse(parts[1]);
    return TimeOfDay(hour: hour, minute: minute);
  }
}
