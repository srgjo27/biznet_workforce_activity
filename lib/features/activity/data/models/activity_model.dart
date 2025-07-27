import 'package:biznet_workforce_activity/features/activity/domain/entities/activity.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class ActivityModel extends Activity {
  const ActivityModel({
    super.id,
    required super.judul,
    required super.deskripsi,
    required super.lokasi,
    required super.longLat,
    required super.jamMulai,
    required super.jamSelesai,
    required super.status,
    required super.prioritas,
    required super.timestampCreated,
    super.timestampUpdated,
  });

  factory ActivityModel.fromSnapshot(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return ActivityModel(
      id: doc.id,
      judul: data['judul'] ?? '',
      deskripsi: data['deskripsi'] ?? '',
      lokasi: data['lokasi'] ?? '',
      longLat: data['long_lat'] ?? '',
      jamMulai: (data['jam_mulai'] as Timestamp).toDate(),
      jamSelesai: data['jam_selesai'] != null
          ? (data['jam_selesai'] as Timestamp).toDate()
          : null,
      status: data['status'] ?? '',
      prioritas: data['prioritas'] ?? '',
      timestampCreated: (data['timestamp_created'] as Timestamp).toDate(),
      timestampUpdated: data['timestamp_updated'] != null
          ? (data['timestamp_updated'] as Timestamp).toDate()
          : null,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'judul': judul,
      'deskripsi': deskripsi,
      'lokasi': lokasi,
      'long_lat': longLat,
      'jam_mulai': Timestamp.fromDate(jamMulai),
      if (jamSelesai != null) 'jam_selesai': Timestamp.fromDate(jamSelesai!),
      'status': status,
      'prioritas': prioritas,
      'timestamp_created': Timestamp.fromDate(timestampCreated),
      if (timestampUpdated != null)
        'timestamp_updated': Timestamp.fromDate(timestampUpdated!),
    };
  }
}
