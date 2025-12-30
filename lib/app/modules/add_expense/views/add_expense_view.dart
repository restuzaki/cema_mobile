import 'package:cema_mobile/app/design_system/design_system.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/add_expense_controller.dart';
import '../../../widgets/widget_project_trigger.dart';
import '../../../widgets/widget_input_field.dart';
import '../../../widgets/widget_currency_input.dart';
import '../../../widgets/widget_date_picker.dart';
import '../../../widgets/widget_dropdown.dart';
import '../../../design_system/widgets/custom_button.dart';

class AddExpenseView extends GetView<AddExpenseController> {
  const AddExpenseView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.neutral100,
      appBar: AppBar(
        title: Text(
          'Tambah Pengeluaran',
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
          onPressed: controller.cancel,
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24.0),
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

              // Title
              WidgetInputField(
                controller: controller.titleController,
                label: "Judul Pengeluaran",
                hint: "Contoh: Beli Semen",
              ),

              const SizedBox(height: 24),

              // Amount
              WidgetCurrencyInput(
                controller: controller.amountController,
                label: "Jumlah",
                hint: "0",
              ),

              const SizedBox(height: 24),

              // Category
              Obx(
                () => WidgetDropdown<String>(
                  label: "Kategori",
                  hint: "Pilih Kategori",
                  items: controller.categories.map((String category) {
                    return DropdownMenuItem<String>(
                      value: category,
                      child: Text(category),
                    );
                  }).toList(),
                  value: controller.selectedCategory.value.isEmpty
                      ? null
                      : controller.selectedCategory.value,
                  onChanged: (val) {
                    if (val != null) controller.selectCategory(val);
                  },
                ),
              ),

              const SizedBox(height: 24),

              // Date
              Obx(
                () => WidgetDatePicker(
                  label: "Tanggal",
                  selectedDate: controller.selectedDate.value,
                  onTap: () => controller.selectDate(context),
                ),
              ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: Container(
        padding: const EdgeInsets.all(24.0),
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
              text: "Simpan Pengeluaran",
              isLoading: controller.isLoading.value,
              onPressed: controller.submit,
              size: ButtonSize.large,
              variant: ButtonVariant.primary,
            ),
          ),
        ),
      ),
    );
  }
}
