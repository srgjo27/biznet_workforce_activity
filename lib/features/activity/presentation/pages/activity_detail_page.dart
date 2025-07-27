// ignore_for_file: use_build_context_synchronously

import 'package:biznet_workforce_activity/features/activity/presentation/bloc/activity_bloc.dart';
import 'package:biznet_workforce_activity/features/activity/presentation/bloc/activity_event.dart';
import 'package:biznet_workforce_activity/features/activity/presentation/bloc/activity_state.dart';
import 'package:biznet_workforce_activity/features/activity/presentation/pages/add_edit_activity_page.dart';
import 'package:biznet_workforce_activity/features/shared/colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';

class ActivityDetailPage extends StatefulWidget {
  final String activityId;
  const ActivityDetailPage({super.key, required this.activityId});

  @override
  State<ActivityDetailPage> createState() => _ActivityDetailPageState();
}

class _ActivityDetailPageState extends State<ActivityDetailPage> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) {
        context.read<ActivityBloc>().add(
          GetDetailActivityRequested(widget.activityId),
        );
      }
    });
  }

  Future<bool?> _showConfirmationBottomSheet() {
    return showModalBottomSheet<bool>(
      context: context,
      isDismissible: false,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20.r)),
      ),
      builder: (sheetContext) {
        return Padding(
          padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 16.h),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(Icons.delete_outline, size: 50.w, color: AppColors.error),
              SizedBox(height: 20.w),
              Text(
                'Konfirmasi Penghapusan',
                style: Theme.of(
                  context,
                ).textTheme.titleLarge!.copyWith(fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 12.w),
              Text(
                'Apakah Anda yakin ingin menghapus aktivitas ini? Tindakan ini tidak dapat dibatalkan.',
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.bodyMedium,
              ),
              SizedBox(height: 20.w),
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton(
                      onPressed: () => Navigator.of(sheetContext).pop(false),
                      child: Text(
                        'Tidak',
                        style: Theme.of(context).textTheme.bodyMedium,
                      ),
                    ),
                  ),
                  SizedBox(width: 16.w),
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () => Navigator.of(sheetContext).pop(true),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.error,
                        foregroundColor: Colors.white,
                      ),
                      child: const Text('Ya, Hapus'),
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

  Widget _buildStatusChip({
    required String text,
    required Color backgroundColor,
    required Color foregroundColor,
    required IconData icon,
  }) {
    return Chip(
      avatar: Icon(icon, color: foregroundColor, size: 18.sp),
      label: Text(text),
      labelStyle: TextStyle(
        color: foregroundColor,
        fontWeight: FontWeight.bold,
      ),
      backgroundColor: backgroundColor,
      padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 4.h),
    );
  }

  Widget _buildInfoRow({
    required IconData icon,
    required String label,
    required String value,
  }) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 12.h),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, color: AppColors.biznetLightBlue, size: 20.sp),
          SizedBox(width: 16.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: Theme.of(
                    context,
                  ).textTheme.bodySmall?.copyWith(color: Colors.grey.shade600),
                ),
                SizedBox(height: 4.h),
                Text(value, style: Theme.of(context).textTheme.bodyMedium),
              ],
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocConsumer<ActivityBloc, ActivityState>(
        listener: (context, state) {
          if (state is ActivityFailure) {
            ScaffoldMessenger.of(context)
              ..hideCurrentSnackBar()
              ..showSnackBar(SnackBar(content: Text(state.message)));
          }
        },
        builder: (context, state) {
          if (state is ActivityDetailLoaded) {
            final activity = state.activity;
            final dateFormat = DateFormat('dd MMM yyyy, HH:mm');

            final statusMap = activity.status == 'Selesai'
                ? {
                    'color': Colors.green.shade700,
                    'icon': Icons.check_circle_outline,
                  }
                : {
                    'color': Colors.blue.shade700,
                    'icon': Icons.hourglass_top_outlined,
                  };

            final priorityMap = {
              'Rendah': {
                'color': Colors.grey.shade600,
                'icon': Icons.arrow_downward,
              },
              'Normal': {'color': Colors.green.shade700, 'icon': Icons.remove},
              'Tinggi': {
                'color': Colors.red.shade800,
                'icon': Icons.arrow_upward,
              },
            };

            return CustomScrollView(
              slivers: [
                SliverAppBar(
                  pinned: true,
                  leading: IconButton(
                    icon: const Icon(Icons.arrow_back, color: Colors.white),
                    onPressed: () => Navigator.of(context).pop(),
                  ),
                  flexibleSpace: FlexibleSpaceBar(
                    title: Text(
                      'Detail Aktivitas',
                      style: Theme.of(
                        context,
                      ).textTheme.titleLarge!.copyWith(color: Colors.white),
                    ),
                    titlePadding: EdgeInsets.symmetric(
                      horizontal: 48.w,
                      vertical: 12.h,
                    ),
                    background: Container(color: AppColors.biznetLightBlue),
                  ),
                  actions: [
                    IconButton(
                      icon: Icon(Icons.edit_outlined, color: Colors.white),
                      tooltip: 'Edit Aktivitas',
                      onPressed: () async {
                        await Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (_) => BlocProvider.value(
                              value: BlocProvider.of<ActivityBloc>(context),
                              child: AddEditActivityPage(activity: activity),
                            ),
                          ),
                        );
                        if (context.mounted) {
                          context.read<ActivityBloc>().add(
                            GetDetailActivityRequested(widget.activityId),
                          );
                        }
                      },
                    ),
                    IconButton(
                      icon: Icon(Icons.delete_outline, color: Colors.white),
                      tooltip: 'Hapus Aktivitas',
                      onPressed: () async {
                        final isConfirmed =
                            await _showConfirmationBottomSheet();
                        if (isConfirmed == true) {
                          context.read<ActivityBloc>().add(
                            DeleteActivityRequested(widget.activityId),
                          );
                          Navigator.of(context).pop();
                        }
                      },
                    ),
                  ],
                ),
                SliverToBoxAdapter(
                  child: Padding(
                    padding: EdgeInsets.all(16.w),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Wrap(
                          spacing: 8.w,
                          runSpacing: 8.h,
                          children: [
                            _buildStatusChip(
                              text: activity.status,
                              backgroundColor: (statusMap['color'] as Color)
                                  .withAlpha(26),
                              foregroundColor: statusMap['color'] as Color,
                              icon: statusMap['icon'] as IconData,
                            ),
                            _buildStatusChip(
                              text: 'Prioritas: ${activity.prioritas}',
                              backgroundColor:
                                  (priorityMap[activity.prioritas]!['color']
                                          as Color)
                                      .withAlpha(26),
                              foregroundColor:
                                  priorityMap[activity.prioritas]!['color']
                                      as Color,
                              icon:
                                  priorityMap[activity.prioritas]!['icon']
                                      as IconData,
                            ),
                          ],
                        ),
                        SizedBox(height: 16.h),
                        Text(
                          'Judul',
                          style: Theme.of(context).textTheme.titleMedium
                              ?.copyWith(fontWeight: FontWeight.bold),
                        ),
                        SizedBox(height: 8.h),
                        Text(
                          activity.judul,
                          style: Theme.of(context).textTheme.bodyLarge
                              ?.copyWith(color: Colors.grey.shade700),
                        ),
                        SizedBox(height: 16.h),
                        Text(
                          'Deskripsi',
                          style: Theme.of(context).textTheme.titleMedium
                              ?.copyWith(fontWeight: FontWeight.bold),
                        ),
                        SizedBox(height: 8.h),
                        Text(
                          activity.deskripsi,
                          style: Theme.of(context).textTheme.bodyLarge
                              ?.copyWith(color: Colors.grey.shade700),
                        ),
                        SizedBox(height: 24.h),
                        Container(
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(12.r),
                            border: Border.all(
                              color: Colors.grey.shade300,
                              width: 1.w,
                            ),
                          ),
                          child: Padding(
                            padding: EdgeInsets.all(16.w),
                            child: Column(
                              children: [
                                _buildInfoRow(
                                  icon: Icons.calendar_today_outlined,
                                  label: 'Jam Mulai',
                                  value: dateFormat.format(activity.jamMulai),
                                ),
                                if (activity.jamSelesai != null) Divider(),
                                if (activity.jamSelesai != null)
                                  _buildInfoRow(
                                    icon: Icons.event_available_outlined,
                                    label: 'Jam Selesai',
                                    value: dateFormat.format(
                                      activity.jamSelesai!,
                                    ),
                                  ),
                                Divider(),
                                _buildInfoRow(
                                  icon: Icons.location_on_outlined,
                                  label: 'Lokasi',
                                  value: activity.lokasi,
                                ),
                                Divider(),
                                _buildInfoRow(
                                  icon: Icons.map_outlined,
                                  label: 'Koordinat',
                                  value: activity.longLat,
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            );
          }
          return Scaffold(
            body: const Center(child: CircularProgressIndicator()),
          );
        },
      ),
    );
  }
}
