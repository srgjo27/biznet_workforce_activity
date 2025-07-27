// ignore_for_file: use_build_context_synchronously

import 'package:biznet_workforce_activity/app/di/injector.dart';
import 'package:biznet_workforce_activity/features/activity/domain/entities/activity.dart';
import 'package:biznet_workforce_activity/features/activity/presentation/bloc/activity_bloc.dart';
import 'package:biznet_workforce_activity/features/activity/presentation/pages/activity_detail_page.dart';
import 'package:biznet_workforce_activity/features/shared/colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';

class ActivityCard extends StatelessWidget {
  final Activity activity;

  const ActivityCard({super.key, required this.activity});

  @override
  Widget build(BuildContext context) {
    final DateFormat formatter = DateFormat('dd MMM yyyy, HH:mm');
    final String deskripsi = activity.deskripsi.length > 60
        ? '${activity.deskripsi.substring(0, 60)}...'
        : activity.deskripsi;

    return Card(
      margin: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8.r)),
      clipBehavior: Clip.antiAlias,
      elevation: 0.0,
      child: Container(
        decoration: BoxDecoration(
          border: Border(
            left: BorderSide(color: AppColors.biznetLightBlue, width: 4.w),
            top: BorderSide(color: Colors.grey.shade400, width: 1.w),
            right: BorderSide(color: Colors.grey.shade400, width: 1.w),
            bottom: BorderSide(color: Colors.grey.shade400, width: 1.w),
          ),
        ),
        child: ListTile(
          title: Text(
            activity.judul,
            style: Theme.of(
              context,
            ).textTheme.titleMedium!.copyWith(fontWeight: FontWeight.bold),
          ),
          subtitle: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                deskripsi,
                maxLines: 2,
                style: Theme.of(context).textTheme.bodyMedium,
              ),
              SizedBox(height: 4.h),
              Row(
                children: [
                  Container(
                    padding: EdgeInsets.symmetric(
                      horizontal: 4.w,
                      vertical: 2.h,
                    ),
                    decoration: BoxDecoration(
                      color: activity.status == 'Selesai'
                          ? AppColors.success.withAlpha(26)
                          : AppColors.info.withAlpha(26),
                      borderRadius: BorderRadius.circular(4.r),
                    ),
                    child: Text(
                      activity.status,
                      style: Theme.of(context).textTheme.labelSmall!.copyWith(
                        color: activity.status == 'Selesai'
                            ? AppColors.success
                            : AppColors.info,
                      ),
                    ),
                  ),
                  SizedBox(width: 4.w),
                  Container(
                    padding: EdgeInsets.symmetric(
                      horizontal: 4.w,
                      vertical: 2.h,
                    ),
                    decoration: BoxDecoration(
                      color: activity.prioritas == 'Normal'
                          ? AppColors.success.withAlpha(26)
                          : activity.prioritas == 'Tinggi'
                          ? AppColors.error.withAlpha(26)
                          : Colors.grey.shade400.withAlpha(26),
                      borderRadius: BorderRadius.circular(4.r),
                    ),
                    child: Text(
                      activity.prioritas,
                      style: Theme.of(context).textTheme.labelSmall!.copyWith(
                        color: activity.prioritas == 'Normal'
                            ? AppColors.success
                            : activity.prioritas == 'Tinggi'
                            ? AppColors.error
                            : Colors.grey.shade400,
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 8.h),
              Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Mulai',
                          style: Theme.of(context).textTheme.labelSmall
                              ?.copyWith(color: Colors.grey.shade400),
                        ),
                        Text(
                          formatter.format(activity.jamMulai),
                          style: Theme.of(context).textTheme.bodySmall,
                        ),
                      ],
                    ),
                  ),
                  SizedBox(width: 4.w),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Selesai',
                          style: Theme.of(context).textTheme.labelSmall
                              ?.copyWith(color: Colors.grey.shade400),
                        ),
                        Text(
                          activity.jamSelesai != null
                              ? formatter.format(activity.jamSelesai!)
                              : '-',
                          style: Theme.of(context).textTheme.bodySmall,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ],
          ),
          onTap: () {
            Navigator.of(context).push(
              MaterialPageRoute(
                builder: (_) => BlocProvider<ActivityBloc>(
                  create: (context) => sl<ActivityBloc>(),
                  child: ActivityDetailPage(activityId: activity.id!),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
