// ignore_for_file: use_build_context_synchronously

import 'package:biznet_workforce_activity/features/activity/presentation/pages/activity_list_page.dart';
import 'package:biznet_workforce_activity/features/shared/colors.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:geolocator/geolocator.dart';

class PermissionCheckPage extends StatefulWidget {
  const PermissionCheckPage({super.key});

  @override
  State<PermissionCheckPage> createState() => _PermissionCheckPageState();
}

class _PermissionCheckPageState extends State<PermissionCheckPage> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _checkPermissionsAndNavigate();
    });
  }

  Future<void> _checkPermissionsAndNavigate() async {
    // Check for internet connectivity
    final connectivityResult = await (Connectivity().checkConnectivity());
    final hasInternet =
        connectivityResult.contains(ConnectivityResult.mobile) ||
        connectivityResult.contains(ConnectivityResult.wifi);

    if (!hasInternet) {
      _showInternetPermissionSheet();

      return;
    }

    // Check for loaction permissions
    LocationPermission locationPermission = await Geolocator.checkPermission();
    if (locationPermission == LocationPermission.denied) {
      locationPermission = await Geolocator.requestPermission();
    }

    if (locationPermission == LocationPermission.denied ||
        locationPermission == LocationPermission.deniedForever) {
      _showLocationPermissionSheet();

      return;
    }

    Navigator.of(context).pushReplacement(
      MaterialPageRoute(builder: (_) => const ActivityListPage()),
    );
  }

  void _showInternetPermissionSheet() {
    showModalBottomSheet(
      context: context,
      isDismissible: false,
      builder: (context) {
        return Padding(
          padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 16.h),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                Icons.wifi_off,
                size: 50.w,
                color: AppColors.biznetLightBlue,
              ),
              SizedBox(height: 20.w),
              Text(
                'Tidak Ada Koneksi Internet',
                style: Theme.of(
                  context,
                ).textTheme.titleLarge!.copyWith(fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 12.w),
              Text(
                'Mohon pastikan perangkat Anda terhubung ke internet.',
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.bodyMedium,
              ),
              SizedBox(height: 20.w),
              ElevatedButton(
                onPressed: () {
                  Navigator.of(context).pop();
                  _checkPermissionsAndNavigate();
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.biznetLightBlue,
                  foregroundColor: Colors.white,
                ),
                child: Text(
                  'Coba Lagi',
                  style: Theme.of(
                    context,
                  ).textTheme.bodyMedium!.copyWith(color: Colors.white),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  void _showLocationPermissionSheet() {
    showModalBottomSheet(
      context: context,
      isDismissible: false,
      builder: (context) {
        return Padding(
          padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 16.h),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                Icons.location_off,
                size: 50.w,
                color: AppColors.biznetLightBlue,
              ),
              SizedBox(height: 20.w),
              Text(
                'Izin Lokasi Diperlukan',
                style: Theme.of(
                  context,
                ).textTheme.titleLarge!.copyWith(fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 12.w),
              Text(
                'Aplikasi ini memerlukan akses lokasi untuk berfungsi dengan baik.',
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.bodyMedium,
              ),
              SizedBox(height: 20.w),
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton(
                      onPressed: () async {
                        await Geolocator.openAppSettings();
                        Navigator.of(context).pop();
                      },
                      child: Text(
                        'Buka Pengaturan',
                        style: Theme.of(context).textTheme.bodyMedium,
                      ),
                    ),
                  ),
                  SizedBox(width: 16.w),
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () {
                        Navigator.of(context).pop();
                        _checkPermissionsAndNavigate();
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.biznetLightBlue,
                        foregroundColor: Colors.white,
                      ),
                      child: Text(
                        'Coba Lagi',
                        style: Theme.of(
                          context,
                        ).textTheme.bodyMedium!.copyWith(color: Colors.white),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return const Scaffold(body: Center(child: CircularProgressIndicator()));
  }
}
