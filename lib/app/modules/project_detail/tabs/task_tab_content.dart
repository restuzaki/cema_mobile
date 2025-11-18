// lib/app/modules/project_detail/views/widgets/task_tab_content.dart
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
                      child: Container(
                        width: double.infinity,
                        decoration: BoxDecoration(
                          color: AppColors.backgroundLight,
                          borderRadius: AppRadius.radiusMd,
                          border: Border.all(color: AppColors.dividerLight),
                        ),
                        padding: AppSpacing.paddingMd,
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    task.title,
                                    style: AppTypography.headingMD.copyWith(
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  SizedBox(height: AppSpacing.xxs),
                                  Text(
                                    task.responsibleName,
                                    style: AppTypography.bodyMD.copyWith(
                                      color: AppColors.textSecondaryLight,
                                    ),
                                  ),
                                  SizedBox(height: AppSpacing.xs),
                                  Row(
                                    children: [
                                      Text(
                                        'Due Date: ',
                                        style: AppTypography.bodySM.copyWith(
                                          color: AppColors.textSecondaryLight,
                                          fontWeight: FontWeight.w600,
                                        ),
                                      ),
                                      Text(
                                        _formatDate(task.dueDate),
                                        style: AppTypography.bodySM.copyWith(
                                          color: AppColors.textSecondaryLight,
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.end,
                              children: [
                                Row(
                                  children: [
                                    Icon(
                                      Icons.access_time,
                                      size: AppIconSize.sm,
                                      color: AppColors.textSecondaryLight,
                                    ),
                                    SizedBox(width: AppSpacing.xxs),
                                    Text(
                                      task.phase,
                                      style: AppTypography.bodySM.copyWith(
                                        color: AppColors.textSecondaryLight,
                                      ),
                                    ),
                                  ],
                                ),
                                SizedBox(height: AppSpacing.xs),
                                StatusLabel(
                                  label: _getStatusLabel(task.status),
                                  type: _getStatusType(task.status),
                                ),
                                SizedBox(height: AppSpacing.xs),
                                CustomButton(
                                  text: 'Lihat Detail',
                                  size: ButtonSize.small,
                                  variant: ButtonVariant.primary,
                                  onPressed: () {},
                                ),
                              ],
                            ),
                          ],
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
      case 'ongoing':
        return 'Berlangsung';
      case 'late':
        return 'Terlambat';
      case 'done':
        return 'Selesai';
      case 'menunggu':
        return 'Menunggu';
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

  StatusLabelType _getStatusType(String status) {
    switch (status) {
      case 'ongoing':
        return StatusLabelType.info;
      case 'late':
        return StatusLabelType.error;
      case 'done':
        return StatusLabelType.success;
      case 'menunggu':
        return StatusLabelType.warning;
      default:
        return StatusLabelType.info;
    }
  }
}
