import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:cema_mobile/app/design_system/design_system.dart';
import '../controller/project_detail_controller.dart';
import '../widgets/settings_form_widgets.dart';

class SettingsTabContent extends StatelessWidget {
  final ProjectDetailController controller;

  const SettingsTabContent({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // Form Container
        Container(
          width: double.infinity,
          decoration: BoxDecoration(
            color: AppColors.backgroundLight,
            borderRadius: BorderRadius.circular(AppRadius.lg),
            boxShadow: AppShadows.shadowSm,
          ),
          padding: EdgeInsets.all(AppSpacing.md),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              //Identitas Proyek
              Text("Identitas Proyek", style: AppTypography.headingMD),
              SizedBox(height: AppSpacing.md),
              WidgetInputField(
                label: "Nama Proyek",
                controller: controller.nameEdit,
              ),
              WidgetInputField(
                label: "Nama Klien",
                controller: controller.clientEdit,
              ),
              WidgetInputField(
                label: "Deskripsi Proyek",
                controller: controller.descEdit,
                maxLines: 4,
              ),

              Divider(
                height: AppSpacing.xl,
                thickness: 1,
                color: AppColors.neutral300,
              ),

              //Budget & Fase
              Text("Budget & Fase", style: AppTypography.headingMD),
              SizedBox(height: AppSpacing.md),
              WidgetCurrencyInput(
                label: "Budget Total",
                controller: controller.budgetEdit,
              ),
              Obx(
                () => WidgetPhasePicker(
                  label: "Fase Proyek",
                  value: controller.phaseEdit.value,
                  items: const [
                    "Lead",
                    "Pitching",
                    "Design",
                    "Development",
                    "Testing",
                    "Deployment",
                  ],
                  onChanged: (val) {
                    if (val != null) controller.phaseEdit.value = val;
                  },
                ),
              ),

              Divider(
                height: AppSpacing.xl,
                thickness: 1,
                color: AppColors.neutral300,
              ),

              //Jadwal
              Text("Jadwal", style: AppTypography.headingMD),
              SizedBox(height: AppSpacing.md),
              WidgetDateRangePicker(
                startController: controller.startDateEdit,
                endController: controller.endDateEdit,
                onStartTap: () async {
                  final date = await showDatePicker(
                    context: context,
                    initialDate: DateTime.now(),
                    firstDate: DateTime(2020),
                    lastDate: DateTime(2030),
                  );
                  if (date != null) {
                    controller.onDateSelected(controller.startDateEdit, date);
                  }
                },
                onEndTap: () async {
                  final date = await showDatePicker(
                    context: context,
                    initialDate: DateTime.now(),
                    firstDate: DateTime(2020),
                    lastDate: DateTime(2030),
                  );
                  if (date != null) {
                    controller.onDateSelected(controller.endDateEdit, date);
                  }
                },
              ),
            ],
          ),
        ),

        SizedBox(height: AppSpacing.xl),

        // Action Button
        if (controller.canEdit)
          SizedBox(
            width: double.infinity,
            child: CustomButton(
              text: "Simpan Perubahan",
              onPressed: controller.saveSettings,
              variant: ButtonVariant.primary,
              size: ButtonSize.large,
            ),
          ),
      ],
    );
  }
}
