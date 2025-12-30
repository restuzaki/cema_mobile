import 'package:cema_mobile/app/design_system/design_system.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controller/project_detail_controller.dart';

class TaskTabContent extends StatelessWidget {
  final ProjectDetailController controller;

  const TaskTabContent({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          width: double.infinity,
          decoration: BoxDecoration(
            color: AppColors.cardBackgroundLight,
            borderRadius: AppRadius.radiusLg,
            boxShadow: AppShadows.shadowSm,
          ),
          padding: AppSpacing.paddingMd,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Daftar Tugas', style: AppTypography.headingMD),
              SizedBox(height: AppSpacing.sm),
              Obx(
                () => SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    children: List.generate(4, (i) {
                      final labels = [
                        'Semua',
                        'Berlangsung',
                        'Terlambat',
                        'Selesai',
                      ];
                      return Padding(
                        padding: EdgeInsets.only(right: AppSpacing.md),
                        child: CustomFilter(
                          label: labels[i],
                          isActive: controller.taskFilterIndex.value == i,
                          onTap: () => controller.changeTaskFilter(i),
                        ),
                      );
                    }),
                  ),
                ),
              ),
              SizedBox(height: AppSpacing.sm),
              Obx(() {
                final list = controller.filteredTasks;
                if (list.isEmpty) {
                  return Padding(
                    padding: AppSpacing.paddingMd,
                    child: Center(
                      child: Text(
                        'Belum ada tugas',
                        style: AppTypography.bodyMD.copyWith(
                          color: AppColors.textSecondaryLight,
                        ),
                      ),
                    ),
                  );
                }
                return Column(
                  children: List.generate(list.length, (i) {
                    final task = list[i];
                    return Padding(
                      padding: EdgeInsets.only(bottom: AppSpacing.sm),
                      child: GestureDetector(
                        onTap: () {
                          // TODO: Navigate to detail
                        },
                        child: Container(
                          width: double.infinity,
                          decoration: BoxDecoration(
                            color: AppColors.backgroundLight,
                            borderRadius: AppRadius.radiusMd,
                            border: Border.all(color: AppColors.dividerLight),
                          ),
                          padding: AppSpacing.paddingMd,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Expanded(
                                    child: Text(
                                      task.title ?? 'Untitled',
                                      style: AppTypography.headingMD.copyWith(
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ),
                                  SizedBox(width: AppSpacing.sm),
                                  Row(
                                    children: [
                                      Icon(
                                        Icons.access_time,
                                        size: AppIconSize.sm,
                                        color: AppColors.textSecondaryLight,
                                      ),
                                      SizedBox(width: AppSpacing.xxs),
                                      Text(
                                        _getStatusLabel(task.status ?? 'TODO'),
                                        style: AppTypography.bodySM.copyWith(
                                          color: AppColors.textSecondaryLight,
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                              SizedBox(height: AppSpacing.md),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        'Due Date',
                                        style: AppTypography.bodySM.copyWith(
                                          color: AppColors.textSecondaryLight,
                                          fontWeight: FontWeight.w600,
                                        ),
                                      ),
                                      SizedBox(height: AppSpacing.xxs),
                                      Text(
                                        _formatDate(
                                          task.dueDate ?? DateTime.now(),
                                        ),
                                        style: AppTypography.bodySM.copyWith(
                                          color: AppColors.textLight,
                                          fontWeight: FontWeight.w500,
                                        ),
                                      ),
                                    ],
                                  ),
                                  Icon(
                                    Icons.chevron_right,
                                    color: AppColors.neutral700,
                                    size: AppIconSize.md,
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                    );
                  }),
                );
              }),
            ],
          ),
        ),
      ],
    );
  }

  String _getStatusLabel(String status) {
    switch (status) {
      case 'TODO':
        return 'Menunggu';
      case 'IN_PROGRESS':
        return 'Berlangsung';
      case 'IN_REVIEW':
        return 'Review';
      case 'DONE':
        return 'Selesai';
      default:
        return status;
    }
  }

  String _formatDate(DateTime date) {
    const months = [
      'Jan',
      'Feb',
      'Mar',
      'Apr',
      'Mei',
      'Jun',
      'Jul',
      'Agu',
      'Sep',
      'Okt',
      'Nov',
      'Des',
    ];

    return '${date.day} ${months[date.month - 1]} ${date.year}';
  }
}
