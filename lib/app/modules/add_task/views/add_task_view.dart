import 'package:cema_mobile/app/design_system/design_system.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/add_task_controller.dart';

class AddTaskView extends GetView<AddTaskController> {
  const AddTaskView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.neutral100,
      appBar: CustomHeader(title: 'Tambah Tugas'),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: AppSpacing.paddingMd,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: AppSpacing.sm),

              // Detail Task Section
              Text(
                'Detail Task',
                style: AppTypography.headingMD.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: AppSpacing.md),

              // Nama Penanggung Jawab
              CustomTextField(
                label: 'Nama Penanggung Jawab',
                placeholder: 'Text',
                controller: controller.responsibleNameController,
                prefixIcon: Icons.person_outline,
              ),
              SizedBox(height: AppSpacing.md),

              // Nama Task
              CustomTextField(
                label: 'Nama Task',
                placeholder: 'Text',
                controller: controller.taskNameController,
                prefixIcon: Icons.assignment_outlined,
              ),
              SizedBox(height: AppSpacing.md),

              // Deskripsi Task
              CustomTextField(
                label: 'Deskripsi Task',
                placeholder: 'Projek Berkah',
                controller: controller.taskDescriptionController,
                maxLines: 5,
                minLines: 3,
                prefixIcon: Icons.description_outlined,
              ),
              SizedBox(height: AppSpacing.md),

              // Tanggal Mulai Task
              CustomTextField(
                label: 'Tanggal Mulai Task',
                placeholder: '20/10/2021',
                controller: controller.startDateController,
                readOnly: true,
                prefixIcon: Icons.calendar_today_outlined,
                onTap: () => controller.selectStartDate(context),
              ),
              SizedBox(height: AppSpacing.md),

              // Tanggal Selesai Task
              CustomTextField(
                label: 'Tanggal Selesai Task',
                placeholder: '21/08/2023',
                controller: controller.endDateController,
                readOnly: true,
                prefixIcon: Icons.calendar_today_outlined,
                onTap: () => controller.selectEndDate(context),
              ),
              SizedBox(height: AppSpacing.md),

              // Status Task
              Text(
                'Status Task',
                style: AppTypography.bodySM.copyWith(
                  fontWeight: FontWeight.w600,
                  color: AppColors.textLight,
                ),
              ),
              SizedBox(height: AppSpacing.xxs),
              Obx(
                () => Container(
                  padding: AppSpacing.paddingMd,
                  decoration: BoxDecoration(
                    color: AppColors.backgroundLight,
                    borderRadius: AppRadius.radiusMd,
                    border: Border.all(color: AppColors.dividerLight),
                  ),
                  child: DropdownButton<String>(
                    value: controller.selectedStatus.value,
                    isExpanded: true,
                    underline: const SizedBox(),
                    icon: Icon(
                      Icons.keyboard_arrow_down,
                      color: AppColors.textSecondaryLight,
                    ),
                    items: controller.statusOptions.map((String status) {
                      return DropdownMenuItem<String>(
                        value: status,
                        child: Text(status, style: AppTypography.bodyMD),
                      );
                    }).toList(),
                    onChanged: (String? newValue) {
                      if (newValue != null) {
                        controller.selectStatus(newValue);
                      }
                    },
                  ),
                ),
              ),
              SizedBox(height: AppSpacing.xl),

              // Action Buttons
              Row(
                children: [
                  Expanded(
                    child: CustomButton(
                      text: 'Cancel',
                      variant: ButtonVariant.secondary,
                      size: ButtonSize.large,
                      onPressed: controller.cancelAddTask,
                    ),
                  ),
                  SizedBox(width: AppSpacing.md),
                  Expanded(
                    child: Obx(
                      () => CustomButton(
                        text: 'Confirm',
                        variant: ButtonVariant.primary,
                        size: ButtonSize.large,
                        onPressed: controller.confirmAddTask,
                        isLoading: controller.isLoading.value,
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(height: AppSpacing.md),
            ],
          ),
        ),
      ),
    );
  }
}
