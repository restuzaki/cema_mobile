import 'package:cema_mobile/app/design_system/design_system.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/add_task_controller.dart';
import '../../../widgets/widget_project_trigger.dart';
import '../../../widgets/widget_input_field.dart';
import '../../../widgets/widget_currency_input.dart';
import '../../../widgets/widget_date_picker.dart';
import '../../../design_system/widgets/custom_button.dart';

class AddTaskView extends GetView<AddTaskController> {
  const AddTaskView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.neutral100,
      appBar: AppBar(
        title: Text(
          'Tambah Task',
          style: AppTypography.headingMD.copyWith(
            fontWeight: FontWeight.bold,
            color: AppColors.textLight,
          ),
        ),
        centerTitle: true,
        backgroundColor: AppColors.neutral100,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.close, color: AppColors.textLight),
          onPressed: controller.cancelAddTask,
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24.0), // 24px spacing/padding
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Project Trigger
              Obx(
                () => WidgetProjectTrigger(
                  selectedProjectName: controller.selectedProject.value?.name,
                  isLocked: controller.isProjectLocked.value,
                  onTap: controller.selectProject,
                ),
              ),

              const SizedBox(height: 24),

              // Task Name
              WidgetInputField(
                controller: controller.taskNameController,
                label: "Nama Task",
                hint: "Masukkan nama task",
              ),

              const SizedBox(height: 24),

              // Budget
              WidgetCurrencyInput(
                controller: controller.budgetAllocationController,
                label: "Budget Teralokasi",
                hint: "0",
              ),

              const SizedBox(height: 24),

              // Due Date
              Obx(
                () => WidgetDatePicker(
                  label: "Tenggat Waktu",
                  selectedDate: controller.dueDate.value,
                  onTap: () => controller.selectDueDate(context),
                ),
              ),

              // Note: Member Picker and Attachment Slot skipped as per instruction.
            ],
          ),
        ),
      ),
      bottomNavigationBar: Container(
        padding: const EdgeInsets.all(24.0), // Consistent padding
        decoration: BoxDecoration(
          color: AppColors.neutral100,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              offset: const Offset(0, -4),
              blurRadius: 16,
            ),
          ],
        ),
        child: SafeArea(
          child: Obx(
            () => CustomButton(
              text: "Simpan Task",
              isLoading: controller.isLoading.value,
              onPressed: controller.confirmAddTask,
              size: ButtonSize.large,
              variant: ButtonVariant.primary,
            ),
          ),
        ),
      ),
    );
  }
}
