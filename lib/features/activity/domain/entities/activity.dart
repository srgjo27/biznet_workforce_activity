import 'package:equatable/equatable.dart';

class Activity extends Equatable {
  final String? id;
  final String judul;
  final String deskripsi;
  final String lokasi;
  final String longLat;
  final DateTime jamMulai;
  final DateTime? jamSelesai;
  final String status;
  final String prioritas;
  final DateTime timestampCreated;
  final DateTime? timestampUpdated;

  const Activity({
    this.id,
    required this.judul,
    required this.deskripsi,
    required this.lokasi,
    required this.longLat,
    required this.jamMulai,
    this.jamSelesai,
    required this.status,
    required this.prioritas,
    required this.timestampCreated,
    this.timestampUpdated,
  });

  @override
  List<Object?> get props => [
    id,
    judul,
    deskripsi,
    lokasi,
    longLat,
    jamMulai,
    jamSelesai,
    status,
    prioritas,
    timestampCreated,
    timestampUpdated,
  ];
}
