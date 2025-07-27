// ignore_for_file: use_build_context_synchronously

import 'package:biznet_workforce_activity/features/activity/domain/entities/activity.dart';
import 'package:biznet_workforce_activity/features/activity/presentation/bloc/activity_bloc.dart';
import 'package:biznet_workforce_activity/features/activity/presentation/bloc/activity_event.dart';
import 'package:biznet_workforce_activity/features/shared/colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:geolocator/geolocator.dart';
import 'package:intl/intl.dart';

class AddEditActivityPage extends StatefulWidget {
  final Activity? activity;

  const AddEditActivityPage({super.key, this.activity});

  @override
  State<AddEditActivityPage> createState() => _AddEditActivityPageState();
}

class _AddEditActivityPageState extends State<AddEditActivityPage> {
  final _formKey = GlobalKey<FormState>();

  late TextEditingController _judulController;
  late TextEditingController _deskripsiController;
  late TextEditingController _lokasiController;
  late DateTime _jamMulai;
  String _status = '';
  String _prioritas = '';

  bool get _isEditing => widget.activity != null;

  @override
  void initState() {
    super.initState();
    _judulController = TextEditingController(
      text: widget.activity?.judul ?? '',
    );
    _deskripsiController = TextEditingController(
      text: widget.activity?.deskripsi ?? '',
    );
    _lokasiController = TextEditingController(
      text: widget.activity?.lokasi ?? '',
    );
    _jamMulai = widget.activity?.jamMulai ?? DateTime.now();
    _status = widget.activity?.status ?? 'Sedang Dikerjakan';
    _prioritas = widget.activity?.prioritas ?? 'Normal';
  }

  @override
  void dispose() {
    _judulController.dispose();
    _deskripsiController.dispose();
    _lokasiController.dispose();
    super.dispose();
  }

  Future<void> _selectDateTime(BuildContext context) async {
    final DateTime? date = await showDatePicker(
      context: context,
      initialDate: _jamMulai,
      firstDate: DateTime(2000),
      lastDate: DateTime(2101),
    );
    if (date == null) return;
    final TimeOfDay? time = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.fromDateTime(_jamMulai),
    );
    if (time == null) return;
    setState(() {
      _jamMulai = DateTime(
        date.year,
        date.month,
        date.day,
        time.hour,
        time.minute,
      );
    });
  }

  Future<String?> _getGeoLocation() async {
    bool serviceEnabled;
    LocationPermission permission;

    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Location services are disabled. Please enable them.'),
        ),
      );

      return null;
    }

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Location permissions are denied.')),
        );

        return null;
      }
    }

    if (permission == LocationPermission.deniedForever) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            'Location permissions are permanently denied, you can access settings to enable them.',
          ),
        ),
      );

      return null;
    }

    try {
      final position = await Geolocator.getCurrentPosition(
        locationSettings: const LocationSettings(
          accuracy: LocationAccuracy.high,
        ),
      );

      return '${position.latitude},${position.longitude}';
    } catch (e) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Failed to get location. $e')));

      return null;
    }
  }

  Future<void> _onSave() async {
    if (!_formKey.currentState!.validate()) return;

    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(const SnackBar(content: Text('Menyimpan data...')));

    final longLat = await _getGeoLocation();
    if (longLat == null) return;

    DateTime? finalJamSelesai;

    if (_isEditing) {
      if (_status == 'Selesai' && widget.activity!.status != 'Selesai') {
        finalJamSelesai = DateTime.now();
      } else {
        finalJamSelesai = widget.activity!.jamSelesai;
      }
    } else {
      finalJamSelesai = null;
    }

    final activity = Activity(
      id: widget.activity?.id,
      judul: _judulController.text,
      deskripsi: _deskripsiController.text,
      lokasi: _lokasiController.text,
      longLat: longLat,
      jamMulai: _jamMulai,
      jamSelesai: finalJamSelesai,
      status: _status,
      prioritas: _prioritas,
      timestampCreated: _isEditing
          ? widget.activity!.timestampCreated
          : DateTime.now(),
      timestampUpdated: _isEditing ? DateTime.now() : null,
    );

    if (_isEditing) {
      context.read<ActivityBloc>().add(UpdateActivityRequested(activity));
    } else {
      context.read<ActivityBloc>().add(AddActivityRequested(activity));
    }

    Navigator.of(context).pop();
  }

  Widget _buildSectionHeader(String title) {
    return Padding(
      padding: EdgeInsets.only(bottom: 8.h, top: 16.h),
      child: Text(title, style: Theme.of(context).textTheme.titleMedium),
    );
  }

  @override
  Widget build(BuildContext context) {
    final dateFormat = DateFormat('dd MMM yyyy, HH:mm');

    final inputDecoration = InputDecoration(
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12.r),
        borderSide: BorderSide(color: Colors.grey.shade300),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12.r),
        borderSide: BorderSide(color: Colors.grey.shade300),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12.r),
        borderSide: BorderSide(color: Theme.of(context).primaryColor, width: 2),
      ),
      filled: true,
      fillColor: Colors.grey.shade100,
      contentPadding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
    );

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text(_isEditing ? 'Edit Aktivitas' : 'Buat Aktivitas Baru'),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.symmetric(horizontal: 16.w),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildSectionHeader('Aktivitas'),
              TextFormField(
                controller: _judulController,
                decoration: inputDecoration.copyWith(
                  hintText: 'Contoh: Perbaiki WiFi',
                  prefixIcon: Icon(Icons.title, size: 16.sp),
                ),
                validator: (value) =>
                    value!.isEmpty ? 'Judul tidak boleh kosong' : null,
              ),
              SizedBox(height: 12.h),
              TextFormField(
                controller: _deskripsiController,
                decoration: inputDecoration.copyWith(
                  hintText: 'Deskripsi aktivitas...',
                  prefixIcon: Icon(Icons.description_outlined, size: 16.sp),
                ),
                maxLines: 4,
                validator: (value) =>
                    value!.isEmpty ? 'Deskripsi tidak boleh kosong' : null,
              ),
              SizedBox(height: 12.h),
              TextFormField(
                controller: _lokasiController,
                decoration: inputDecoration.copyWith(
                  hintText: 'Contoh: Mid Plaza',
                  prefixIcon: Icon(Icons.location_on_outlined, size: 16.sp),
                ),
                validator: (value) =>
                    value!.isEmpty ? 'Lokasi tidak boleh kosong' : null,
              ),
              SizedBox(height: 12.h),
              _buildSectionHeader('Jadwal & Status'),
              InkWell(
                onTap: () => _selectDateTime(context),
                child: Container(
                  padding: EdgeInsets.all(12.w),
                  decoration: BoxDecoration(
                    color: Colors.grey.shade100,
                    borderRadius: BorderRadius.circular(12.r),
                    border: Border.all(color: Colors.grey.shade300),
                  ),
                  child: Row(
                    children: [
                      Icon(
                        Icons.calendar_today_outlined,
                        color: Colors.grey,
                        size: 16.sp,
                      ),
                      SizedBox(width: 18.w),
                      Text(
                        'Mulai: ${dateFormat.format(_jamMulai)}',
                        style: Theme.of(
                          context,
                        ).textTheme.bodyLarge!.copyWith(fontSize: 14.sp),
                      ),
                      Spacer(),
                      const Icon(Icons.arrow_drop_down, color: Colors.grey),
                    ],
                  ),
                ),
              ),
              SizedBox(height: 12.h),
              DropdownButtonFormField<String>(
                value: _status,
                decoration: inputDecoration.copyWith(
                  prefixIcon: Icon(Icons.work_history_outlined, size: 16.sp),
                ),
                items: ['Sedang Dikerjakan', 'Selesai']
                    .map(
                      (label) => DropdownMenuItem(
                        value: label,
                        child: Text(
                          label,
                          style: Theme.of(
                            context,
                          ).textTheme.bodyMedium!.copyWith(fontSize: 14.sp),
                        ),
                      ),
                    )
                    .toList(),
                onChanged: (value) => setState(() => _status = value!),
              ),

              _buildSectionHeader('Prioritas'),
              SizedBox(
                width: double.infinity,
                child: SegmentedButton<String>(
                  segments: const <ButtonSegment<String>>[
                    ButtonSegment<String>(
                      value: 'Rendah',
                      label: Text('Rendah'),
                      icon: Icon(Icons.arrow_downward),
                    ),
                    ButtonSegment<String>(
                      value: 'Normal',
                      label: Text('Normal'),
                      icon: Icon(Icons.remove),
                    ),
                    ButtonSegment<String>(
                      value: 'Tinggi',
                      label: Text('Tinggi'),
                      icon: Icon(Icons.arrow_upward),
                    ),
                  ],
                  selected: <String>{_prioritas},
                  onSelectionChanged: (Set<String> newSelection) {
                    setState(() {
                      _prioritas = newSelection.first;
                    });
                  },
                  style: SegmentedButton.styleFrom(
                    selectedBackgroundColor: AppColors.biznetLightBlue,
                    padding: EdgeInsets.symmetric(vertical: 12.h),
                  ),
                ),
              ),

              SizedBox(height: 40.h),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton.icon(
                  label: Text(
                    'Simpan Aktivitas',
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                  onPressed: _onSave,
                  style: ElevatedButton.styleFrom(
                    padding: EdgeInsets.symmetric(vertical: 16.h),
                    textStyle: Theme.of(context).textTheme.titleMedium,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12.r),
                    ),
                  ),
                ),
              ),
              SizedBox(height: 20.h),
            ],
          ),
        ),
      ),
    );
  }
}
