import 'package:cloud_firestore/cloud_firestore.dart';

class SessionModel {
  String id;
  String? title;
  DateTime date;
  String time;
  int duration;
  String location;
  String emailStudent;
  double notes;
  String code;
  String comments1;
  String comments2;
  String comments3;
  SessionModel({
    required this.id,
    this.title,
    required this.date,
    required this.time,
    required this.duration,
    required this.location,
    required this.emailStudent,
    required this.notes,
    required this.comments2,
    required this.comments1,
    required this.comments3,
    required this.code,
  });
  factory SessionModel.fromFirestore(
      DocumentSnapshot<Map<String, dynamic>> snapshot,
      [SnapshotOptions? options]) {
    final data = snapshot.data()!;
    return SessionModel(
      id: snapshot.id,
      title: data['title'] ?? '',
      date: data['date'].toDate(),
      time: data['time'] ?? '',
      duration: data['duration'] ?? 0,
      location: data['location'] ?? '',
      emailStudent: data['emailStudent'] ?? '',
      notes: data['notes'] ?? 0,
      comments1: data['comments1'] ?? '',
      comments2: data['comments2'] ?? '',
      comments3: data['comments3'] ?? '',
      code: data['code'] ?? '',
    );
  }
  Map<String, Object?> ToFirestore() {
    return {
      'title': title,
      'date': Timestamp.fromDate(date),
      'time': time,
      'duration': duration,
      'location': location,
      'emailStudent': emailStudent,
      'notes': notes,
      'comments1': comments1,
      'comments2': comments2,
      'comments3': comments3,
      'code': code,
    };
  }

  Map<String, Object?> ToEditFirestore() {
    return {
      'id': id,
      'title': title,
      'date': Timestamp.fromDate(date),
      'time': time,
      'duration': duration,
      'location': location,
      'emailStudent': emailStudent,
      'notes': notes,
      'comments1': comments1,
      'comments2': comments2,
      'comments3': comments3,
      'code': code,
    };
  }
}
