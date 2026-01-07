import 'package:cema_mobile/app/design_system/design_system.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controller/project_detail_controller.dart';

class FinanceTabContent extends StatelessWidget {
  final ProjectDetailController controller;

  const FinanceTabContent({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Kesehatan Proyek Section
        Container(
          width: double.infinity,
          padding: AppSpacing.paddingMd,
          decoration: BoxDecoration(
            color: AppColors.cardBackgroundLight,
            borderRadius: AppRadius.radiusLg,
            boxShadow: AppShadows.shadowMd,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text('Kesehatan Proyek', style: AppTypography.headingMD),
              SizedBox(height: AppSpacing.md),
              Obx(() {
                final financials = controller.currentProject.value?.financials;
                final spiColors = controller.getMetricColors(
                  financials?.spi,
                  true,
                );
                final cpiColors = controller.getMetricColors(
                  financials?.cpi,
                  true,
                );
                final pvColors = controller.getMetricColors(
                  financials?.valuePlanned,
                  false,
                );

                return Column(
                  children: [
                    // Top row: SPI (small) + EV (large)
                    Row(
                      children: [
                        Expanded(
                          child: _HealthCard(
                            label: 'SPI',
                            value: controller.formatMetric(financials?.spi),
                            color: spiColors.$1,
                            textColor: spiColors.$2,
                          ),
                        ),
                        SizedBox(width: AppSpacing.sm),
                        Expanded(
                          flex: 3,
                          child: _HealthCard(
                            label: 'EV',
                            value: controller.formatCurrency(
                              financials?.valueEarned,
                            ),
                            color: spiColors.$1, // EV follows SPI color
                            textColor: spiColors.$2,
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: AppSpacing.sm),
                    // Middle row: AV (large) + CPI (small)
                    Row(
                      children: [
                        Expanded(
                          flex: 3,
                          child: _HealthCard(
                            label: 'AV',
                            value: controller.formatCurrency(
                              financials?.costActual,
                            ),
                            color: cpiColors.$1, // AV follows CPI color
                            textColor: cpiColors.$2,
                          ),
                        ),
                        SizedBox(width: AppSpacing.sm),
                        Expanded(
                          child: _HealthCard(
                            label: 'CPI',
                            value: controller.formatMetric(financials?.cpi),
                            color: cpiColors.$1,
                            textColor: cpiColors.$2,
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: AppSpacing.sm),
                    // Bottom row: PV (full width)
                    Row(
                      mainAxisSize: MainAxisSize.max,
                      children: [
                        Expanded(
                          child: _HealthCard(
                            label: 'PV',
                            value: controller.formatCurrency(
                              financials?.valuePlanned,
                            ),
                            color: pvColors.$1,
                            textColor: pvColors.$2,
                          ),
                        ),
                      ],
                    ),
                  ],
                );
              }),
              SizedBox(height: AppSpacing.md),
              CustomButton(
                text: 'Ekspor Laporan Keuangan',
                size: ButtonSize.medium,
                variant: ButtonVariant.primary,
                icon: Icons.arrow_forward,
                onPressed: () {},
              ),
            ],
          ),
        ),
        SizedBox(height: AppSpacing.lg),

        // Daftar Biaya Section
        Container(
          width: double.infinity,
          padding: AppSpacing.paddingMd,
          decoration: BoxDecoration(
            color: AppColors.cardBackgroundLight,
            borderRadius: AppRadius.radiusLg,
            boxShadow: AppShadows.shadowMd,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('Daftar Biaya', style: AppTypography.headingMD),
                  TextButton(
                    onPressed: () {},
                    child: Text(
                      'Lihat Semua',
                      style: AppTypography.labelSmall.copyWith(
                        color: AppColors.primary500,
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(height: AppSpacing.sm),
              Obx(
                () => SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    children: List.generate(2, (i) {
                      final labels = ['Menunggu Persetujuan', 'Semua'];
                      return Padding(
                        padding: EdgeInsets.only(right: AppSpacing.md),
                        child: CustomFilter(
                          label: labels[i],
                          isActive: controller.financeFilterIndex.value == i,
                          onTap: () => controller.changeFinanceFilter(i),
                        ),
                      );
                    }),
                  ),
                ),
              ),
              SizedBox(height: AppSpacing.md),

              // Expense List
              Obx(() {
                final expenses = controller.filteredExpenses;
                if (expenses.isEmpty) {
                  return Padding(
                    padding: AppSpacing.paddingMd,
                    child: Center(
                      child: Text(
                        'Belum ada biaya',
                        style: AppTypography.bodyMD.copyWith(
                          color: AppColors.textSecondaryLight,
                        ),
                      ),
                    ),
                  );
                }
                return Column(
                  children: expenses.map((expense) {
                    final isPending = (expense.status ?? '') == 'PENDING';
                    return Padding(
                      padding: EdgeInsets.only(bottom: AppSpacing.sm),
                      child: ExpenseCard(
                        amount: controller.formatCurrency(expense.amount),
                        description: expense.title,
                        status: expense.status ?? 'PENDING',
                        statusLabel: StatusLabel(
                          label: isPending
                              ? 'Menunggu Persetujuan'
                              : (expense.status ?? '') == 'APPROVED'
                              ? 'Disetujui'
                              : 'Ditolak',
                          type: isPending
                              ? StatusLabelType.warning
                              : (expense.status ?? '') == 'APPROVED'
                              ? StatusLabelType.success
                              : StatusLabelType.error,
                          icon: isPending
                              ? Icons.warning_amber
                              : (expense.status ?? '') == 'APPROVED'
                              ? Icons.check_circle
                              : Icons.cancel,
                        ),
                        trailing: Row(
                          children: [
                            Icon(
                              Icons.person,
                              size: AppIconSize.md,
                              color: AppColors.textSecondaryLight,
                            ),
                            SizedBox(width: AppSpacing.xxs),
                            CircleAvatar(
                              radius: 16,
                              backgroundColor: AppColors.primary500,
                              child: Text(
                                'U',
                                style: AppTypography.labelSmall.copyWith(
                                  color: AppColors.neutral000,
                                ),
                              ),
                            ),
                          ],
                        ),
                        actions: isPending
                            ? [
                                CustomButton(
                                  text: 'Accept',
                                  size: ButtonSize.small,
                                  variant: ButtonVariant.primary,
                                  onPressed: () => controller.acceptExpense(
                                    expense.id ?? '',
                                  ),
                                ),
                                SizedBox(width: AppSpacing.xs),
                                CustomButton(
                                  text: 'Reject',
                                  size: ButtonSize.small,
                                  variant: ButtonVariant.danger,
                                  onPressed: () => controller.rejectExpense(
                                    expense.id ?? '',
                                  ),
                                ),
                              ]
                            : [
                                TextButton(
                                  onPressed: () {},
                                  child: Row(
                                    children: [
                                      Text(
                                        'Lihat Detail',
                                        style: AppTypography.labelSmall
                                            .copyWith(
                                              color:
                                                  AppColors.textSecondaryLight,
                                            ),
                                      ),
                                      Icon(
                                        Icons.arrow_forward,
                                        size: AppIconSize.sm,
                                        color: AppColors.textSecondaryLight,
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                      ),
                    );
                  }).toList(),
                );
              }),
            ],
          ),
        ),
      ],
    );
  }
}

class _HealthCard extends StatelessWidget {
  final String label;
  final String value;
  final Color color;
  final Color textColor;

  const _HealthCard({
    required this.label,
    required this.value,
    required this.color,
    required this.textColor,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: AppSpacing.paddingSm,
      decoration: BoxDecoration(color: color, borderRadius: AppRadius.radiusMd),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text(
            label,
            style: AppTypography.labelSmall.copyWith(
              color: textColor,
              fontWeight: FontWeight.w600,
            ),
          ),
          SizedBox(height: AppSpacing.xxs),
          Text(
            value,
            style: AppTypography.bodyLG.copyWith(
              color: textColor,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }
}
